Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbaLJK7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:59:47 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39866 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaLJK7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:59:43 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-2f-5488279ceb70
Message-id: <54882789.2010700@samsung.com>
Date: Wed, 10 Dec 2014 11:59:21 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v9 06/19] DT: Add documentation for the mfd Maxim
 max77693
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-7-git-send-email-j.anaszewski@samsung.com>
 <20141204100706.GP14746@valkosipuli.retiisi.org.uk>
 <54804840.4030202@samsung.com> <54881A1F.2080607@samsung.com>
In-reply-to: <54881A1F.2080607@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t/xK7pz1DtCDJqfqlncWneO1WLjjPWs
	Fkd3TmSyuP7lOavF/CNAsf43C1ktzr1ayWjRe/U5o8XZpjfsFve/HmW0uLxrDpvF1jfrGC16
	NmxltVh6/SKTxd1TR9ksJkxfy2LRuvcIu8XuXU9ZLc7sX8nmIOyxZt4aRo/Lfb1MHjtn3WX3
	WLn8C5vH4a8LWTw2repk87hzbQ+bx575P1g9+rasYvRYsfo7u8fnTXIB3FFcNimpOZllqUX6
	dglcGYtX7mMsmM5V0d11n7GB8R97FyMHh4SAicSai2FdjJxAppjEhXvr2boYuTiEBJYySsy/
	v48NJCEk8IlRou9JBIjNK6Al0X38FyOIzSKgKrHl/SGwGjYBQ4neo31gcVGBCImTd/ewQ9QL
	SvyYfI8FxBYR0JdoaACp4eJgFnjPLLFoxhcmkISwQIjE1v2nWSCW/WWUWL8lBMTmFNCWuPNm
	FTPIocwCehL3L2qBhJkF5CU2r3nLPIFRYBaSFbMQqmYhqVrAyLyKUTS1NLmgOCk910ivODG3
	uDQvXS85P3cTIyQqv+5gXHrM6hCjAAejEg/vDsW2ECHWxLLiytxDjBIczEoivG8kO0KEeFMS
	K6tSi/Lji0pzUosPMTJxcEo1MDr/sVp/OumFRiNrVuQGh33z5x4+2+yuLl1XubdgFuO5xae/
	2LD5p99+YX64ueHkk4evVtqu6jD7vdfWUsZTJ2fP8+aYL2oeE/8z+CaGmUb2njhQ+HqZ9bT1
	9S8NVycVlDSvb0/7eCZvVV3g/v+Xi9ZUnz+rKVua91nhzQ+nq5Zcpt8t4lq22iuxFGckGmox
	FxUnAgC4Is46qAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/14 11:02, Jacek Anaszewski wrote:
>>>> +Optional properties:
>>>> >>> +- maxim,fleds : Array of current outputs in order: fled1, fled2.

s/current outputs/LED current regulator outputs used/ ?

>>>> >>> +    Note: both current outputs can be connected to a single led

s/led/LED ? And there seem to be other similar occurrences that would
need to be put in upper case.

>>>> >>> +    Possible values:
>>>> >>> +        MAX77693_LED_FLED_UNUSED - the output is left disconnected,
>>>> >>> +        MAX77693_LED_FLED_USED - a diode is connected to the output.

As noted below, I would simply use 0/1 for these.

>>> >>
>>> >> As you have a LED sub-nodes for each LED already, isn't this redundant?
>> >
>> > Well, it seems so :)
>
> I agreed here recklessly. This property allows to describe the
> situation when one LED is connected to both outputs. Single sub-node
> can describe two type of designs: one LED connected to a single
> output or one LED connected to both outputs. Therefore additional
> property is needed to assess what is the actual case.

How about renaming  "maxim,fleds" to "maxim,active-outputs" ?
And simply using 0 and 1 to indicate if one is used or not, rather
than defining macros for these true/false values ?

--
Regards,
Sylwester
