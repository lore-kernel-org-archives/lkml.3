Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaEGLKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 07:10:35 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32473 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbaEGLKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 07:10:34 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fae6d000004d6d-93-536a14a74953
Content-transfer-encoding: 8BIT
Message-id: <1399461043.22811.3.camel@AMDC1943>
Subject: Re: [RFT PATCH] regulator: s2mpa01: Use correct register for buck[36]
 ramp delay
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sangbeom Kim <sbkim73@samsung.com>
Date: Wed, 07 May 2014 13:10:43 +0200
In-reply-to: <1399456358-12168-1-git-send-email-k.kozlowski@samsung.com>
References: <1399456358-12168-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xy7rLRbKCDbqealhMffiEzeLblQ4m
	i8u75rBZnPzTy2hxccUXJosFGx8xOrB57Jx1l91j06pONo871/awefRtWcXo8XmTXABrFJdN
	SmpOZllqkb5dAldG51H5gveCFWdOz2RrYOzl62Lk5JAQMJE4tWAhO4QtJnHh3nq2LkYuDiGB
	pYwSfSdWsIIkeAUEJX5MvsfSxcjBwSwgL3HkUjZImFlAXWLSvEXMEPWfGSU2vj7HCFGvL/Ft
	w04mEFtYIFri/s/ZzCA2m4CxxOblS9hAbBEBLYmX3cuZQJqZBZYxShz78IwFJMEioCrx7v89
	MJtTwEPiy8v/7CCLhQTcJe63eUAcqiwxb/8xpgmMArOQnDcL4bxZSM5bwMi8ilE0tTS5oDgp
	PddIrzgxt7g0L10vOT93EyMkrL/uYFx6zOoQowAHoxIP7wKZjGAh1sSy4srcQ4wSHMxKIrzd
	/FnBQrwpiZVVqUX58UWlOanFhxiZODilGhj5Fafm6Z9erf1Yw+jo3MvhR5o74jc0Gf5e6ZbP
	uqt694lntuHl8aYTBOVurEud5lPKkSSlzyVy6/j0mD0LBXP2vkjr124sjf8rfrQk6/XXH86V
	Dc1Ta/Z76+6e7l6bm9PH92FP3rsc7Yo5yjMmna9+Yi7OfS0/f2K32jQvI69Nt9Nvt/KUFSux
	FGckGmoxFxUnAgAc5M6nSQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,


I'm looking at SM-N7505 JB Open source code and it seems that I was
wrong - the ramp delay for buck1 is set in wrong register, not buck3.

I don't have the datasheet for S2MPA01 so could you confirm the
registers for ramp delay of buck1, buck3 and buck6?


Best regards,
Krzysztof


On śro, 2014-05-07 at 11:52 +0200, Krzysztof Kozlowski wrote:
> Buck1 and buck6 share the field (offset 4) in ramp delay register
> (S2MPA01_REG_RAMP1). The buck3 uses its own field in S2MPA01_REG_RAMP2
> register, also at offset 4.
> 
> The driver interchanged the registers for ramp delay of buck3 and buck6.
> This lead to updating ramp delay for wrong buck (buck3 instead of buck6
> and vice versa).
> 
> Cc: <stable@vger.kernel.org>
> Fixes: f18792714608 ("regulator: Add support for S2MPA01 regulator")
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/regulator/s2mpa01.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
> index f19a30f0fb42..67a5ab335dae 100644
> --- a/drivers/regulator/s2mpa01.c
> +++ b/drivers/regulator/s2mpa01.c
> @@ -137,17 +137,16 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
>  		enable_shift = S2MPA01_BUCK3_RAMP_EN_SHIFT;
>  		if (!ramp_delay) {
>  			ramp_enable = 0;
>  			break;
>  		}
>  
>  		s2mpa01->ramp_delay3 = ramp_delay;
>  		ramp_shift = S2MPA01_BUCK3_RAMP_SHIFT;
> -		ramp_reg = S2MPA01_REG_RAMP1;
>  		break;
>  	case S2MPA01_BUCK4:
>  		enable_shift = S2MPA01_BUCK4_RAMP_EN_SHIFT;
>  		if (!ramp_delay) {
>  			ramp_enable = 0;
>  			break;
>  		}
>  
> @@ -165,16 +164,17 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
>  		break;
>  	case S2MPA01_BUCK6:
>  		if (ramp_delay > s2mpa01->ramp_delay16)
>  			s2mpa01->ramp_delay16 = ramp_delay;
>  		else
>  			ramp_delay = s2mpa01->ramp_delay16;
>  
>  		ramp_shift = S2MPA01_BUCK16_RAMP_SHIFT;
> +		ramp_reg = S2MPA01_REG_RAMP1;
>  		break;
>  	case S2MPA01_BUCK7:
>  		s2mpa01->ramp_delay7 = ramp_delay;
>  		ramp_shift = S2MPA01_BUCK7_RAMP_SHIFT;
>  		break;
>  	case S2MPA01_BUCK8:
>  	case S2MPA01_BUCK9:
>  	case S2MPA01_BUCK10:

