Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaEWOTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:19:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45397 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaEWOTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:19:39 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-29-537f58f989dd
Content-transfer-encoding: 8BIT
Message-id: <1400854775.7331.6.camel@AMDC1943>
Subject: Re: [RFT PATCH] regulator: s2mpa01: Use correct register for buck[36]
 ramp delay
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sangbeom Kim <sbkim73@samsung.com>
Date: Fri, 23 May 2014 16:19:35 +0200
In-reply-to: <1399461043.22811.3.camel@AMDC1943>
References: <1399456358-12168-1-git-send-email-k.kozlowski@samsung.com>
 <1399461043.22811.3.camel@AMDC1943>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xa7o/I+qDDc5/ZLOY+vAJm8W3Kx1M
	Fpd3zWGzOPmnl9Hi4oovTBYLNj5idGDz2DnrLrvHplWdbB53ru1h8+jbsorR4/MmuQDWKC6b
	lNSczLLUIn27BK6Mt9Mmshf8Fqto+vGAuYHxpWAXIyeHhICJxNvZE5kgbDGJC/fWs4HYQgJL
	GSX+zbUAsXkFBCV+TL7H0sXIwcEsIC9x5FI2SJhZQF1i0rxFzF2MXEDlnxkl3s+ZywJRrydx
	b/k8RhBbWCBa4v7P2cwgNpuAscTm5UvA5osIaEm87F7OBNLMLLCMUeLYh2dgzSwCqhKbVx1j
	BbE5BQwkOtseQx2UK3Hi9lxmiEOVJebtP8Y0gVFgFpL7ZiHcNwvJfQsYmVcxiqaWJhcUJ6Xn
	GuoVJ+YWl+al6yXn525ihAT2lx2Mi49ZHWIU4GBU4uHdUVoXLMSaWFZcmXuIUYKDWUmEt9iv
	PliINyWxsiq1KD++qDQntfgQIxMHp1QDo80Fhfb7KoFGFpvfeXLmeIROcv91j+dsjQVLnecs
	Rh27z10r5/hL/P+WyHwpSuX9JJsO3utc37Q2Xi0N/XPEbGvu291XWBa0ZXzcmHZMuzl5VvFd
	oSUqCbMtcjeGV67Oku6ezhHlEGPu2NKo/HfOBj0hAz7D96be8m6Xq/4yVJzYt3bnE/NXSizF
	GYmGWsxFxYkAQLaAuUoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

The s2mpa01 regulator driver uses wrong registers for ramp delay (buck1
and buck3 in RAMP1, buck6 in RAMP2) but I am not sure which layout is
proper (it seems that that buck1 should be in RAMP2 register).

Could you check in S2MPA01 datasheet the registers for ramp delay for
buck1, buck3 and buck6?

I have prepared patches for merging s2mpa01 and s2mps11 but this one
issue is holding them.

Best regards,
Krzysztof


On śro, 2014-05-07 at 13:10 +0200, Krzysztof Kozlowski wrote:
> Hi Sachin,
> 
> 
> I'm looking at SM-N7505 JB Open source code and it seems that I was
> wrong - the ramp delay for buck1 is set in wrong register, not buck3.
> 
> I don't have the datasheet for S2MPA01 so could you confirm the
> registers for ramp delay of buck1, buck3 and buck6?
> 
> 
> Best regards,
> Krzysztof
> 
> 
> On śro, 2014-05-07 at 11:52 +0200, Krzysztof Kozlowski wrote:
> > Buck1 and buck6 share the field (offset 4) in ramp delay register
> > (S2MPA01_REG_RAMP1). The buck3 uses its own field in S2MPA01_REG_RAMP2
> > register, also at offset 4.
> > 
> > The driver interchanged the registers for ramp delay of buck3 and buck6.
> > This lead to updating ramp delay for wrong buck (buck3 instead of buck6
> > and vice versa).
> > 
> > Cc: <stable@vger.kernel.org>
> > Fixes: f18792714608 ("regulator: Add support for S2MPA01 regulator")
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/regulator/s2mpa01.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
> > index f19a30f0fb42..67a5ab335dae 100644
> > --- a/drivers/regulator/s2mpa01.c
> > +++ b/drivers/regulator/s2mpa01.c
> > @@ -137,17 +137,16 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
> >  		enable_shift = S2MPA01_BUCK3_RAMP_EN_SHIFT;
> >  		if (!ramp_delay) {
> >  			ramp_enable = 0;
> >  			break;
> >  		}
> >  
> >  		s2mpa01->ramp_delay3 = ramp_delay;
> >  		ramp_shift = S2MPA01_BUCK3_RAMP_SHIFT;
> > -		ramp_reg = S2MPA01_REG_RAMP1;
> >  		break;
> >  	case S2MPA01_BUCK4:
> >  		enable_shift = S2MPA01_BUCK4_RAMP_EN_SHIFT;
> >  		if (!ramp_delay) {
> >  			ramp_enable = 0;
> >  			break;
> >  		}
> >  
> > @@ -165,16 +164,17 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
> >  		break;
> >  	case S2MPA01_BUCK6:
> >  		if (ramp_delay > s2mpa01->ramp_delay16)
> >  			s2mpa01->ramp_delay16 = ramp_delay;
> >  		else
> >  			ramp_delay = s2mpa01->ramp_delay16;
> >  
> >  		ramp_shift = S2MPA01_BUCK16_RAMP_SHIFT;
> > +		ramp_reg = S2MPA01_REG_RAMP1;
> >  		break;
> >  	case S2MPA01_BUCK7:
> >  		s2mpa01->ramp_delay7 = ramp_delay;
> >  		ramp_shift = S2MPA01_BUCK7_RAMP_SHIFT;
> >  		break;
> >  	case S2MPA01_BUCK8:
> >  	case S2MPA01_BUCK9:
> >  	case S2MPA01_BUCK10:

