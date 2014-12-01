Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaLALrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:47:20 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9409 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaLALrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:47:16 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-20-547c554238a6
Message-id: <547C5540.2070304@samsung.com>
Date: Mon, 01 Dec 2014 12:47:12 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
        sakari.ailus@iki.fi, s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC v8 12/14] leds: Add driver for AAT1290 current regulator
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-13-git-send-email-j.anaszewski@samsung.com>
 <20141129190550.GA17355@amd>
In-reply-to: <20141129190550.GA17355@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xq7pOoTUhBid/slpsnLGe1eLozolM
	Fmeb3rBbXN41h81i65t1jBY9G7ayWtw9dZTNYveup6wWh9+0s1qc2b+SzYHLY+esu+weh78u
	ZPHYM/8Hq0ffllWMHitWf2f3+LxJLoAtissmJTUnsyy1SN8ugSvj9ibtgoU8Fc1v3rE1ML7i
	7GLk5JAQMJFo2fuWBcIWk7hwbz1bFyMXh5DAUkaJj+vWsUA4HxklXvx4xgRSxSugJfFw/n82
	EJtFQFVi1tFWRhCbTcBQ4ueL12A1ogIREn9O72OFqBeU+DH5HtgGEQF5ia19K5hBhjILvGCU
	mPFuPdggYYEAiS3/ZzNBbFvOKPH83hJmkASngKbElyk7wIqYBawlVk7axghhy0tsXvOWeQKj
	wCwkS2YhKZuFpGwBI/MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJCI+LqDcekxq0OMAhyM
	Sjy8mmurQ4RYE8uKK3MPMUpwMCuJ8L71rgkR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwBj627uy
	rCDM8bVczrK0mQkR536wRCl5vZYJ9mH6MK3M/IjhKR02PsXbNnse7q4IeX/3oY9mWXPwqcT6
	e4xlm78niyloO/2p3XzDYnbswQfqGg6dS59xN3IdXs99teF+B1t0yb3FTnI3+wRKZ33/zXyD
	/2pMukrvykWhgTUTuS6+n7ky1nj9OyWW4oxEQy3mouJEAPCTNWNmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Thanks for a review.

On 11/29/2014 08:05 PM, Pavel Machek wrote:
> Hi!
>
>
>> @@ -0,0 +1,472 @@
>> +/*
>> + *	LED Flash class driver for the AAT1290
>> + *	1.5A Step-Up Current Regulator for Flash LEDs
>> + *
>> + *	Copyright (C) 2014, Samsung Electronics Co., Ltd.
>> + *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + */
>> +
>
>> +#define AAT1290_MM_TO_FL_1_92	1
>> +#define AAT1290_MM_TO_FL_3_7	2
>> +#define AAT1290_MM_TO_FL_5_5	3
>> +#define AAT1290_MM_TO_FL_7_3	4
>> +#define AAT1290_MM_TO_FL_9	5
>> +#define AAT1290_MM_TO_FL_10_7	6
>> +#define AAT1290_MM_TO_FL_12_4	7
>> +#define AAT1290_MM_TO_FL_14	8
>> +#define AAT1290_MM_TO_FL_15_9	9
>> +#define AAT1290_MM_TO_FL_17_5	10
>> +#define AAT1290_MM_TO_FL_19_1	11
>> +#define AAT1290_MM_TO_FL_20_8	12
>> +#define AAT1290_MM_TO_FL_22_4	13
>> +#define AAT1290_MM_TO_FL_24	14
>> +#define AAT1290_MM_TO_FL_25_6	15
>> +#define AAT1290_MM_TO_FL_OFF	16
>
> Only one of these defines is unused.

The only cost of these macros are lines of code and I think
it is worth of having all the possible settings listed in one place.

>
>> +static struct of_device_id aat1290_led_dt_match[] = {
>
>> +	{.compatible = "skyworks,aat1290"},
>
> spaces after { and before } ?

I see both styles in kernel, but ok, I will add spaces.

Regards,
Jacek

