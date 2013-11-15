Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3KOA7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 19:59:06 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31553 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3KOA66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 19:58:58 -0500
X-AuditID: cbfee691-b7f866d000001b8c-2d-528571cfb7ed
Message-id: <528571CF.6080405@samsung.com>
Date: Fri, 15 Nov 2013 09:58:55 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] extcon: arizona: Factor out different headphone
 detection IPs
References: <1384445907-12859-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384445907-12859-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1384445907-12859-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWyRsSkUPd8YWuQwYuDJhb/ptxgt7j/9Sij
	xeVdc9gsbjeuYLNY/vY/m8XpblYHNo871/awecw7GejxcuJvNo++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DKuNP9kK3gnnPF4R89TA2Mm0y6GDk5JARMJHpuzWaEsMUkLtxbz9bFyMUhJLCU
	UWL926WsMEXXrq9jgUhMZ5TouNzICuG8YpToPbiFBaSKV0BLovPIe2YQm0VAVaJvygx2EJsN
	KL7/xQ02EFtUIExi5fQrUPWCEj8m3wOzRQQsJKYsucUMMpRZoI9R4lHLTLDVwgLREjcnfGGE
	2DYf6KaXZ8CO5QSa9Kv3IFgRs4COxP7WaWwQtrzE5jVvwSZJCBxjl3h9YRkrxEkCEt8mHwJa
	xwGUkJXYdIAZ4jdJiYMrbrBMYBSbheSoWUjGzkIydgEj8ypG0dSC5ILipPQiU73ixNzi0rx0
	veT83E2MwHg7/e/ZxB2M9w9YH2JMBlo5kVlKNDkfGK95JfGGxmZGFqYmpsZG5pZmpAkrifOm
	P0oKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4mcnqfNyq3p57s9ReJJsfmeWy/azaD86o
	a+mJZyMsOkX/Hq33XaKy6aPKxd973u2YE9Vs0Z+iFLZUONqjvY33V9iqI/W/+xI1tdYJyYnL
	WpZonf+awbn3atKttUp/FGvLQiP/LbrR8MnjqvqU1Ys/rritba9+cOmKfXHl82x1TpzMaRc5
	/iRYiaU4I9FQi7moOBEArRx5Tc0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd3zha1BBodWa1v8m3KD3eL+16OM
	Fpd3zWGzuN24gs1i+dv/bBanu1kd2DzuXNvD5jHvZKDHy4m/2Tz6tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8ad7odsBfecKw7/6GFqYNxk0sXIySEh
	YCJx7fo6FghbTOLCvfVsXYxcHEIC0xklOi43skI4rxgleg9uAaviFdCS6DzynhnEZhFQleib
	MoMdxGYDiu9/cYMNxBYVCJNYOf0KVL2gxI/J98BsEQELiSlLbjGDDGUW6GOUeNQykxUkISwQ
	LXFzwhdGiG3zGSXWvzzDCJLgBJr0q/cgWBGzgI7E/tZpbBC2vMTmNW+ZJzAKzEKyZBaSsllI
	yhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7mZ9I7GFc1WBxiFOBgVOLhjZBuDRJi
	TSwrrsw9xCjBwawkwvssASjEm5JYWZValB9fVJqTWnyIMRkYBhOZpUST84GJJq8k3tDYxMzI
	0sjc0MLI2Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGGPnMeyT5V5uLrW1udRhjuqV
	rczKJ2MOfgw51nJ0a+gP6xsf+3Ud1hzs7+ls2xBkc8vwj+PbqYv//eI5xjM5Sij28z2FmkNM
	y5ardcnO+rw1+omy4MIPD43zv0xZfijvvtQ0B96vBes3Mwvtt3DuOraZ+Y/N9El77LKEinTX
	vch7ImoSYmGt81CJpTgj0VCLuag4EQAIUeNEKgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On 11/15/2013 01:18 AM, Charles Keepax wrote:
> This patch factors out each headphone detection IP in a seperate
> function this makes the code a little more readable and prevents us
> getting to excessive levels of indentation.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |  215 +++++++++++++++++++++++---------------
>  1 files changed, 130 insertions(+), 85 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index f4fe2d1..d71a738 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -354,7 +354,31 @@ static struct {
>  	{ 1000, 10000 },
>  };
>  
> -static int arizona_hpdet_read(struct arizona_extcon_info *info)
> +static int arizona_hpdet_read_ip0(struct arizona_extcon_info *info)
> +{
> +	struct arizona *arizona = info->arizona;
> +	unsigned int val;
> +	int ret;
> +
> +	ret = regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_2, &val);
> +	if (ret != 0) {

I prefer following checking statement
	if (ret < 0) instead of if (ret != 0) 

> +		dev_err(arizona->dev, "Failed to read HPDET status: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +
> +	if (!(val & ARIZONA_HP_DONE)) {
> +		dev_err(arizona->dev, "HPDET did not complete: %x\n", val);
> +		return -EAGAIN;
> +	}
> +
> +	val &= ARIZONA_HP_LVL_MASK;
> +
> +	return val;
> +}
> +
> +static int arizona_hpdet_read_ip1(struct arizona_extcon_info *info)
>  {
>  	struct arizona *arizona = info->arizona;
>  	unsigned int val, range;
> @@ -367,106 +391,127 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
>  		return ret;
>  	}
>  
> -	switch (info->hpdet_ip) {
> -	case 0:
> -		if (!(val & ARIZONA_HP_DONE)) {
> -			dev_err(arizona->dev, "HPDET did not complete: %x\n",
> -				val);
> -			return -EAGAIN;
> -		}
> +	if (!(val & ARIZONA_HP_DONE_B)) {
> +		dev_err(arizona->dev, "HPDET did not complete: %x\n", val);
> +		return -EAGAIN;
> +	}
>  
> -		val &= ARIZONA_HP_LVL_MASK;
> -		break;
> +	ret = regmap_read(arizona->regmap, ARIZONA_HP_DACVAL, &val);
> +	if (ret != 0) {

ditto.

> +		dev_err(arizona->dev, "Failed to read HP value: %d\n", ret);
> +		return -EAGAIN;
> +	}
>  
> -	case 1:
> -		if (!(val & ARIZONA_HP_DONE_B)) {
> -			dev_err(arizona->dev, "HPDET did not complete: %x\n",
> -				val);
> -			return -EAGAIN;
> -		}
> +	regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1, &range);
> +	range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
> +		   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
>  
> -		ret = regmap_read(arizona->regmap, ARIZONA_HP_DACVAL, &val);
> -		if (ret != 0) {
> -			dev_err(arizona->dev, "Failed to read HP value: %d\n",
> -				ret);
> -			return -EAGAIN;
> -		}
> +	if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
> +	    (val < 100 || val >= 0x3fb)) {

If you possible, I'd like you to define '100' and '0x3fb' as defined constant with 'define' keyword
to improve readability.

> +		range++;
> +		dev_dbg(arizona->dev, "Moving to HPDET range %d\n", range);
> +		regmap_update_bits(arizona->regmap,
> +				   ARIZONA_HEADPHONE_DETECT_1,
> +				   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
> +				   range <<
> +				   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
> +		return -EAGAIN;
> +	}
>  
> -		regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
> -			    &range);
> -		range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
> -			   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
> +	/* If we go out of range report top of range */
> +	if (val < 100 || val >= 0x3fb) {

ditto.

> +		dev_dbg(arizona->dev, "Measurement out of range\n");
> +		return ARIZONA_HPDET_MAX;
> +	}
>  
> -		if (range < ARRAY_SIZE(arizona_hpdet_b_ranges) - 1 &&
> -		    (val < 100 || val >= 0x3fb)) {
> -			range++;
> -			dev_dbg(arizona->dev, "Moving to HPDET range %d\n",
> -				range);
> -			regmap_update_bits(arizona->regmap,
> -					   ARIZONA_HEADPHONE_DETECT_1,
> -					   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
> -					   range <<
> -					   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
> -			return -EAGAIN;
> -		}
> +	dev_dbg(arizona->dev, "HPDET read %d in range %d\n", val, range);
>  
> -		/* If we go out of range report top of range */
> -		if (val < 100 || val >= 0x3fb) {
> -			dev_dbg(arizona->dev, "Measurement out of range\n");
> -			return ARIZONA_HPDET_MAX;
> -		}
> +	val = arizona_hpdet_b_ranges[range].factor_b
> +		/ ((val * 100) - arizona_hpdet_b_ranges[range].factor_a);

ditto.

What is meaning of 100? I prefer to define constant variable.

> +
> +	return val;
> +}
> +
> +static int arizona_hpdet_read_ip2(struct arizona_extcon_info *info)
> +{
> +	struct arizona *arizona = info->arizona;
> +	unsigned int val, range;
> +	int ret;
> +
> +	ret = regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_2, &val);
> +	if (ret != 0) {

ditto.

> +		dev_err(arizona->dev, "Failed to read HPDET status: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	if (!(val & ARIZONA_HP_DONE_B)) {
> +		dev_err(arizona->dev, "HPDET did not complete: %x\n", val);
> +		return -EAGAIN;
> +	}
> +
> +	val &= ARIZONA_HP_LVL_B_MASK;
> +	/* Convert to ohms, the value is in 0.5 ohm increments */
> +	val /= 2;
> +
> +	regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1, &range);
> +	range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
> +		   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
> +
> +	/* Skip up a range, or report? */
> +	if (range < ARRAY_SIZE(arizona_hpdet_c_ranges) - 1 &&
> +	    (val >= arizona_hpdet_c_ranges[range].max)) {
> +		range++;
> +		dev_dbg(arizona->dev, "Moving to HPDET range %d-%d\n",
> +			arizona_hpdet_c_ranges[range].min,
> +			arizona_hpdet_c_ranges[range].max);
> +		regmap_update_bits(arizona->regmap,
> +				   ARIZONA_HEADPHONE_DETECT_1,
> +				   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
> +				   range <<
> +				   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
> +		return -EAGAIN;
> +	}
> +
> +	if (range && (val < arizona_hpdet_c_ranges[range].min)) {
> +		dev_dbg(arizona->dev, "Reporting range boundary %d\n",
> +			arizona_hpdet_c_ranges[range].min);
> +		val = arizona_hpdet_c_ranges[range].min;
> +	}
> +
> +	return val;
> +}
>  
> -		dev_dbg(arizona->dev, "HPDET read %d in range %d\n",
> -			val, range);
> +static int arizona_hpdet_read(struct arizona_extcon_info *info)
> +{
> +	struct arizona *arizona = info->arizona;
> +	int ret = 0;
>  
> -		val = arizona_hpdet_b_ranges[range].factor_b
> -			/ ((val * 100) -
> -			   arizona_hpdet_b_ranges[range].factor_a);
> +	switch (info->hpdet_ip) {
> +	case 0:
> +		ret = arizona_hpdet_read_ip0(info);
> +		if (ret < 0)
> +			return ret;
> +		break;
> +
> +	case 1:
> +		ret = arizona_hpdet_read_ip1(info);
> +		if (ret < 0)
> +			return ret;
>  		break;
>  
>  	default:
>  		dev_warn(arizona->dev, "Unknown HPDET IP revision %d\n",
>  			 info->hpdet_ip);
>  	case 2:
> -		if (!(val & ARIZONA_HP_DONE_B)) {
> -			dev_err(arizona->dev, "HPDET did not complete: %x\n",
> -				val);
> -			return -EAGAIN;
> -		}
> -
> -		val &= ARIZONA_HP_LVL_B_MASK;
> -		/* Convert to ohms, the value is in 0.5 ohm increments */
> -		val /= 2;
> -
> -		regmap_read(arizona->regmap, ARIZONA_HEADPHONE_DETECT_1,
> -			    &range);
> -		range = (range & ARIZONA_HP_IMPEDANCE_RANGE_MASK)
> -			   >> ARIZONA_HP_IMPEDANCE_RANGE_SHIFT;
> -
> -		/* Skip up a range, or report? */
> -		if (range < ARRAY_SIZE(arizona_hpdet_c_ranges) - 1 &&
> -		    (val >= arizona_hpdet_c_ranges[range].max)) {
> -			range++;
> -			dev_dbg(arizona->dev, "Moving to HPDET range %d-%d\n",
> -				arizona_hpdet_c_ranges[range].min,
> -				arizona_hpdet_c_ranges[range].max);
> -			regmap_update_bits(arizona->regmap,
> -					   ARIZONA_HEADPHONE_DETECT_1,
> -					   ARIZONA_HP_IMPEDANCE_RANGE_MASK,
> -					   range <<
> -					   ARIZONA_HP_IMPEDANCE_RANGE_SHIFT);
> -			return -EAGAIN;
> -		}
> -
> -		if (range && (val < arizona_hpdet_c_ranges[range].min)) {
> -			dev_dbg(arizona->dev, "Reporting range boundary %d\n",
> -				arizona_hpdet_c_ranges[range].min);
> -			val = arizona_hpdet_c_ranges[range].min;
> -		}
> +		ret = arizona_hpdet_read_ip2(info);
> +		if (ret < 0)
> +			return ret;
> +		break;
>  	}
>  
> -	dev_dbg(arizona->dev, "HP impedance %d ohms\n", val);
> -	return val;
> +	dev_dbg(arizona->dev, "HP impedance %d ohms\n", ret);

Need blank line.

> +	return ret;
>  }
>  
>  static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
> 

Thanks,
Chanwoo Choi
