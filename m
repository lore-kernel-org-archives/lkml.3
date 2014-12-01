Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaLANn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:43:59 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55359 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaLANn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:43:56 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-17-547c709913da
Message-id: <547C7097.4040907@samsung.com>
Date: Mon, 01 Dec 2014 14:43:51 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
        sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v8 11/14] DT: Add documentation for the mfd Maxim
 max77693
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-12-git-send-email-j.anaszewski@samsung.com>
 <20141129192607.GB17355@amd> <547C65F7.4090801@samsung.com>
 <20141201130231.GA24737@amd>
In-reply-to: <20141201130231.GA24737@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t/xq7ozC2pCDP5PEbe4te4cq8XGGetZ
	LY7unMhkMf8IkNv/ZiGrxcd7/1gtzr1ayWhxtukNu8X9r0cZLS7vmsNmsfXNOkaLng1bWS2W
	Xr/IZHH31FE2iwnT17JYtO49wm6xe9dTVovDb9pZLc7sX8lmcbqb1UHEY828NYwel/t6mTx2
	zrrL7rFy+Rc2j8NfF7J4bFrVyeZx59oeNo95JwM99sz/werRt2UVo8ezj++YPVas/s7u8XmT
	XABvFJdNSmpOZllqkb5dAlfGnO/PWApWcFU0/3vM3MDYyNHFyMkhIWAisWHxLRYIW0ziwr31
	bF2MXBxCAksZJRpXvWGGcD4ySjS0n2IFqeIV0JJonb+VEcRmEVCV6Lp3AizOJmAo8fPFayYQ
	W1QgQuLP6X1Q9YISPybfA9sgIiAvsbVvBdhQZoG7LBIXTr4BaxAWCJH4PHECE8S2p4wSe5se
	g3VzCmhKvP74FqyIWcBaYuWkbYwQtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRNLU0uKE5K
	zzXUK07MLS7NS9dLzs/dxAiJ3C87GBcfszrEKMDBqMTDe2FVdYgQa2JZcWXuIUYJDmYlEd5V
	qTUhQrwpiZVVqUX58UWlOanFhxiZODilGhi5ivZO1at5XCt04SnXJKP8oDPqBlH77I48XOg7
	u6aM661t0rM3/B5pen1PlTrORto8Tnv07bOj5BvBPMniizv5N2mUHe/KPMC14F38jYv2rvNX
	vH18Jvi1josy14ODyXIu7EUpFdHmvS2GMw7bNi1bofB7ye81bfPECqZEMl0WOv1WoerGuXtK
	LMUZiYZazEXFiQAELq4TugIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On 12/01/2014 02:02 PM, Pavel Machek wrote:
> Hi!
>
>>> Is this one needed? Just ommit child note if it is not there.
>>
>> It is needed because you can have one led connected two both
>> outputs. This allows to describe such a design.
>
> Ok.
>
>>>> +- maxim,trigger-type : Array of trigger types in order: flash, torch
>>>> +	Possible trigger types:
>>>> +		0 - Rising edge of the signal triggers the flash/torch,
>>>> +		1 - Signal level controls duration of the flash/torch.
>>>> +- maxim,trigger : Array of flags indicating which trigger can activate given led
>>>> +	in order: fled1, fled2
>>>> +	Possible flag values (can be combined):
>>>> +		1 - FLASH pin of the chip,
>>>> +		2 - TORCH pin of the chip,
>>>> +		4 - software via I2C command.
>>>
>>> Is it good idea to have bitfields like this?
>>>
>>> Make these required properties of the subnode?
>>
>> This is related to a single property: trigger. I think that splitting
>> it to three properties would make unnecessary noise in the
>> binding.
>
> Well, maybe it is not that much noise, and you'll have useful names
> (not a bitfield).

I think we'd need an opinion of at least one more person :)

> Should these properties move to the LED subnode?

I would leave them device specific.

Regards,
Jacek
