Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaJ2DXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:23:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18881 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaJ2DW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:22:59 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfee68e-f79b46d000002b74-2d-54505d7dee96
Content-transfer-encoding: 8BIT
Message-id: <54505D7D.4000704@samsung.com>
Date: Wed, 29 Oct 2014 12:22:37 +0900
From: Jaewon Kim <jaewon02.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: max77693-haptic - fix potential overflow
References: <20141028164322.GA13234@dtor-ws>
In-reply-to: <20141028164322.GA13234@dtor-ws>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSpFsbGxBi0H7cyuL6l+esFocXvWC0
	uPnpG6vF5V1z2BxYPHbOusvu0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBlT26YzF+zhrZh9
	9DhbA2MrdxcjJ4eEgInEwqWn2CFsMYkL99azgdhCAksZJVqWlMPUzDn4gwkiPp1R4v6CahCb
	V0BQ4sfkeyxdjBwczALyEkcuZYOEmQXMJB61rGPuYuQCKn/NKLHk8E4miHotiZtvz4PtYhFQ
	lVj+aR8LiM0moC3xff1iVhBbVCBC4sqaOYwgtoiAj0TjzEesEEPdJM6sPw1WLyzgIrFj3zZ2
	iHt0JCb/6WEGsTkFdCW6Ju5mBFksIbCOXeJ210tmiGUCEt8mHwI7VEJAVmLTAWaIvyQlDq64
	wTKBUWwWkndmIbwzC8k7CxiZVzGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIExs/pf8/6djDe
	PGB9iFGAg1GJh9fgoV+IEGtiWXFl7iFGU6AjJjJLiSbnA6M0ryTe0NjMyMLUxNTYyNzSTEmc
	N0HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRuOGXM4ri3JE4g/VTdLNOdotxTbndr1p
	9rN2sS/Tou9++rZn61uVu2JPy77b2/6fGblozvIXib+X3yo33zLNd7PmXq6Hz65ve+GdJfuo
	riP9qtfBiZ/s/1wv0dvQF7ZsieGm8/qzezO2vV54hamOb2r1hl4dww3vtFutkn6oKtsmrv23
	Y8lh36lKLMUZiYZazEXFiQBCoVhnmgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jQd3a2IAQg+7rxhbXvzxntTi86AWj
	xc1P31gtLu+aw+bA4rFz1l12j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMmNo2nblgD2/F7KPH2RoYW7m7GDk5JARMJOYc/MEEYYtJXLi3ng3EFhKY
	zihxf0E1iM0rICjxY/I9li5GDg5mAXmJI5eyQcLMAmYSj1rWMXcxcgGVv2aUWHJ4JxNEvZbE
	zbfn2UFsFgFVieWf9rGA2GwC2hLf1y9mBbFFBSIkrqyZwwhiiwj4SDTOfMQKMdRN4sz602D1
	wgIuEjv2bWOHuEdHYvKfHmYQm1NAV6Jr4m7GCYwCs5CcNwvhvFlIzlvAyLyKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIzg+n0nvYFzVYHGIUYCDUYmH1/ChX4gQa2JZcWXuIUYJDmYlEd4d
	5gEhQrwpiZVVqUX58UWlOanFhxhNgZ6byCwlmpwPTB15JfGGxiZmRpZG5oYWRsbmSuK8B1ut
	A4UE0hNLUrNTUwtSi2D6mDg4pRoYq3+8ubzdoktUwMbjvtcnW5sJK2dWiW0W6r+y98Mm+/hN
	XiuLpZdFXP1cEJ3OvV5NJcqvQSisZRLbbOUzsTOzNaQnKabNcTp9/yfTE40zN47/cNizXpnz
	RLUpF/+G5NPq16P8fCdb7nD6VXPxzX13ySW6uYwci/eKfpwhv8tUtznSxiH3dkuHEktxRqKh
	FnNRcSIAGTAY+OUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

2014년 10월 29일 01:43에 Dmitry Torokhov 이(가) 쓴 글:
> Expression haptic->pwm_dev->period * haptic->magnitude is of type 'unsigned
> int' and may overflow. We need to convert one of the operands to u64 before
> multiplying, instead of casting result (potentially overflown) to u64.
>
> Reported by Coverity: CID 1248753
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>   drivers/input/misc/max77693-haptic.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/input/misc/max77693-haptic.c b/drivers/input/misc/max77693-haptic.c
> index 7b1fde9..ef6a9d6 100644
> --- a/drivers/input/misc/max77693-haptic.c
> +++ b/drivers/input/misc/max77693-haptic.c
> @@ -194,7 +194,7 @@ static int max77693_haptic_play_effect(struct input_dev *dev, void *data,
>   				       struct ff_effect *effect)
>   {
>   	struct max77693_haptic *haptic = input_get_drvdata(dev);
> -	uint64_t period_mag_multi;
> +	u64 period_mag_multi;
>   
>   	haptic->magnitude = effect->u.rumble.strong_magnitude;
>   	if (!haptic->magnitude)
> @@ -205,8 +205,7 @@ static int max77693_haptic_play_effect(struct input_dev *dev, void *data,
>   	 * The formula to convert magnitude to pwm_duty as follows:
>   	 * - pwm_duty = (magnitude * pwm_period) / MAX_MAGNITUDE(0xFFFF)
>   	 */
> -	period_mag_multi = (int64_t)(haptic->pwm_dev->period *
> -						haptic->magnitude);
> +	period_mag_multi = (u64)haptic->pwm_dev->period * haptic->magnitude;
>   	haptic->pwm_duty = (unsigned int)(period_mag_multi >>
>   						MAX_MAGNITUDE_SHIFT);
>   


There was casting miss in multiplying.
Thanks.

Acked-by : Jaewon Kim <jaewon02.kim@samsung.com>
