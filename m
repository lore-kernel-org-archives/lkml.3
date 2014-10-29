Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaJ2EeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 00:34:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33467 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaJ2EeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 00:34:08 -0400
X-AuditID: cbfee68e-f79b46d000002b74-dc-54506e3cfcce
Message-id: <54506E3C.9050206@samsung.com>
Date: Wed, 29 Oct 2014 13:34:04 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: max77693-haptic - fix potential overflow
References: <20141028164322.GA13234@dtor-ws>
In-reply-to: <20141028164322.GA13234@dtor-ws>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42JZI2JSoGuTFxBi0N5ka3F40QtGix0NR1gt
	bn76xmpxedccNgcWj52z7rJ79G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8aFnk9sBRN5K05M
	/8rewPiSq4uRk0NCwERi7qNXTBC2mMSFe+vZuhi5OIQEljJKbFi5nQ2m6Pq5m0wQiUWMErfm
	LYSqes0ocWjKSmaQKl4BLYlrh5aygtgsAqoSJy6sAouzAcX3v7gBNklUIExi5fQrLBD1ghI/
	Jt8Ds0UE9CW2z/7FCGIzC6RJbFnwB+wkYQEXiR37trGD2EICOhKT//SAzeQU0JXomrgbql5H
	Yn/rNDYIW15i85q3zCDHSQgsYpfYteo1E8RBAhLfJh8CWsYBlJCV2HSAGeIzSYmDK26wTGAU
	m4XkpFlIxs5CMnYBI/MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjMA4Ov3vWd8OxpsHrA8x
	CnAwKvHwvkgOCBFiTSwrrsw9xGgKdMVEZinR5HxgtOaVxBsamxlZmJqYGhuZW5opifMmSP0M
	FhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBozyJ5yr8+SaCDe1q6/bM5EyrWbClgb3y2/t51
	rpcM1RHb5Z+cqriuLRW6KsRxulBs5qMII9XrrSafnI7bqKm8EJs71zb2Id9fvaqf25JEJb4F
	13zb5jc7cU/zw/knnma+7lswebPYj+ffeYNevF15cqnNwqq16d/XBx/evceRR6/0xHnGvHdH
	lFiKMxINtZiLihMBGV+cP54CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAV2bvIAQgzMvTC0OL3rBaLGj4Qir
	xc1P31gtLu+aw+bA4rFz1l12j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMuNDzia1gIm/Fielf2RsYX3J1MXJySAiYSFw/d5MJwhaTuHBvPVsXIxeH
	kMAiRolb8xZCOa8ZJQ5NWckMUsUroCVx7dBSVhCbRUBV4sSFVWBxNqD4/hc32EBsUYEwiZXT
	r7BA1AtK/Jh8D8wWEdCX2D77FyOIzSyQJrFlwR+wzcICLhI79m1jB7GFBHQkJv/pAZvJKaAr
	0TVxN1S9jsT+1mlsELa8xOY1b5knMArMQrJiFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0u
	zUvXS87P3cQIjtJnUjsYVzZYHGIU4GBU4uF9kRwQIsSaWFZcmXuIUYKDWUmEd4c5UIg3JbGy
	KrUoP76oNCe1+BCjKTAEJjJLiSbnAxNIXkm8obGJmZGlkbmhhZGxuZI474FW60AhgfTEktTs
	1NSC1CKYPiYOTqkGRlk1vcdeG8Vbr6isCbDwvZKTPzdLioeFu8ToyR25JM3+j28e31m1eU6B
	5jXNzGMCZgtKBKw2cD3PuN4h8OTTrS1CjEnTt/533nE9qOTFoWrZwxZ8CUKMC/nmn75n83y2
	xiH7pFOXVPdKvkzg8lle++GS3Y66KWfZpPasWRbFy9dn3aO+deryg0osxRmJhlrMRcWJAO6a
	qUfoAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 01:43 AM, Dmitry Torokhov wrote:
> Expression haptic->pwm_dev->period * haptic->magnitude is of type 'unsigned
> int' and may overflow. We need to convert one of the operands to u64 before
> multiplying, instead of casting result (potentially overflown) to u64.
> 
> Reported by Coverity: CID 1248753
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/misc/max77693-haptic.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/misc/max77693-haptic.c b/drivers/input/misc/max77693-haptic.c
> index 7b1fde9..ef6a9d6 100644
> --- a/drivers/input/misc/max77693-haptic.c
> +++ b/drivers/input/misc/max77693-haptic.c
> @@ -194,7 +194,7 @@ static int max77693_haptic_play_effect(struct input_dev *dev, void *data,
>  				       struct ff_effect *effect)
>  {
>  	struct max77693_haptic *haptic = input_get_drvdata(dev);
> -	uint64_t period_mag_multi;
> +	u64 period_mag_multi;
>  
>  	haptic->magnitude = effect->u.rumble.strong_magnitude;
>  	if (!haptic->magnitude)
> @@ -205,8 +205,7 @@ static int max77693_haptic_play_effect(struct input_dev *dev, void *data,
>  	 * The formula to convert magnitude to pwm_duty as follows:
>  	 * - pwm_duty = (magnitude * pwm_period) / MAX_MAGNITUDE(0xFFFF)
>  	 */
> -	period_mag_multi = (int64_t)(haptic->pwm_dev->period *
> -						haptic->magnitude);
> +	period_mag_multi = (u64)haptic->pwm_dev->period * haptic->magnitude;
>  	haptic->pwm_duty = (unsigned int)(period_mag_multi >>
>  						MAX_MAGNITUDE_SHIFT);
>  
> 

Looks good to me.

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi
