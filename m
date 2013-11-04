Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3KDAcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 19:32:52 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:32379 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3KDAcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 19:32:51 -0500
X-AuditID: cbfee691-b7f866d000001b8c-fa-5276eb310234
Message-id: <5276EB32.9060803@samsung.com>
Date: Mon, 04 Nov 2013 09:32:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] extcon: arizona: Fix reset of HPDET after race with
 removal
References: <1382890752-30970-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1382890752-30970-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWyRsSkRNfwdVmQwY4+VYt/U26wW1zeNYfN
	4nbjCjaL5W//szmweLyc+JvNo2/LKkaPz5vkApijuGxSUnMyy1KL9O0SuDIWvexnKXjIVXFx
	+l6mBsaTHF2MnBwSAiYSJ6feY4KwxSQu3FvP1sXIxSEksJRR4sSZL+wwRZPvP2cDsYUEFjFK
	zPusAFH0ilFi19MnYN28AloSt9pnMILYLAKqEvd/LgGLswHF97+4AdYsKhAmsXL6FRaIekGJ
	H5PvgdkiAhYSU5bcYgaxmQUSJeacg1gsLBAp8fv9SxaIxaESKycvZu1i5ODgBJpz/kcKRLmO
	xP7WaWwQtrzE5jVvmSFuXsYuMf1gJcQ5AhLfJh9iAWmVEJCV2HQAqkRS4uCKGywTGMVmITlo
	FpKps5BMXcDIvIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMIJO/3s2cQfj/QPWhxiTgVZO
	ZJYSTc4HRmBeSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tSs1NTC1KL4otKc1KLDzEy
	cXBKNTAK/YtfZLJSdNml+zHrzqt/2Pvi44WefNb/ec/cQgSWudqq+zjOtmPxmiInVZjxmqVm
	6oGcybtuHg7dn/ZIKaAu5ajrIsHCIzMn+D41D9jLa7Ls+Bl75iCn6y4eL5mb5bPZ355oONXb
	+51zmtf5a2/DpQtzN87mUSxqjtP4sq45dbqX/Y+jmRlKLMUZiYZazEXFiQBDMFYctgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xgK7h67Igg5cvZC3+TbnBbnF51xw2
	i9uNK9gslr/9z+bA4vFy4m82j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMWPSyn6XgIVfFxel7mRoYT3J0MXJySAiYSEy+/5wNwhaTuHBvPZgtJLCI
	UWLeZ4UuRi4g+xWjxK6nT5hAErwCWhK32mcwgtgsAqoS938uAYuzAcX3v7gB1iwqECaxcvoV
	Foh6QYkfk++B2SICFhJTltxiBrGZBRIl5pz7wg5iCwtESvx+/5IFYnGoxMrJi1m7GDk4OIHm
	nP+RAlGuI7G/dRobhC0vsXnNW+YJjAKzkGyYhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL
	89L1kvNzNzGCI/SZ1A7GlQ0WhxgFOBiVeHglLpcFCbEmlhVX5h5ilOBgVhLhdT4HFOJNSays
	Si3Kjy8qzUktPsSYDAyAicxSosn5wOSRVxJvaGxiZmRpZG5oYWRsTpqwkjjvgVbrQCGB9MSS
	1OzU1ILUIpgtTBycUg2MEZLzOh77G8c4zNJJS5X/058cesYkofWT6syyrU+qu2a8VfusorN+
	1ZeZ2z+sZMhaecwg7JvMdp60r7e/vF1+iWUqb/6pqxa/i98yZpRfvjLvQYyp1v9TjpktE54u
	4Rb9KSDgM2+l7ecb+nGtUpcmPn8y83188uSqX1P7wiaeWdTwz+FR4CJbUyWW4oxEQy3mouJE
	APncVQsUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On 10/28/2013 01:19 AM, Charles Keepax wrote:
> We need to make sure we reset back to our starting state, especially
> making sure that we have disabled poll in the register cache.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index ec9a14e..dac8ba0 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -596,9 +596,15 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
>  		dev_err(arizona->dev, "Failed to report HP/line: %d\n",
>  			ret);
>  
> +done:
> +	/* Reset back to starting range */
> +	regmap_update_bits(arizona->regmap,
> +			   ARIZONA_HEADPHONE_DETECT_1,
> +			   ARIZONA_HP_IMPEDANCE_RANGE_MASK | ARIZONA_HP_POLL,
> +			   0);
> +
>  	arizona_extcon_do_magic(info, 0);
>  
> -done:
>  	if (id_gpio)
>  		gpio_set_value_cansleep(id_gpio, 0);
>  
> 

The arizona_hpdet_do_id() return only either -EAGIN or 0(zero).
extcon-arizona driver could never execute 'goto done;' statement.

	ret = arizona_hpdet_do_id(info, &reading, &mic);
	if (ret == -EAGAIN) {
		goto out;
	} else if (ret < 0) {
		goto done;
	}

Thanks,
Chanwoo Choi


