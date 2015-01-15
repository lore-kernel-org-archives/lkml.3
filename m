Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbbAOLlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:41:35 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48770 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbbAOLle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:41:34 -0500
Message-ID: <54B7A767.9000205@linaro.org>
Date: Thu, 15 Jan 2015 12:41:27 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        sylvain.rochet@finsecur.com
Subject: Re: [PATCH] clocksource: timer-atmel-pit: don't suspend/resume if
 unused
References: <1418911523-28492-1-git-send-email-nicolas.ferre@atmel.com> <54B3D450.7050405@atmel.com> <54B3D88C.80702@linaro.org> <alpine.DEB.2.11.1501131143250.17382@nanos>
In-Reply-To: <alpine.DEB.2.11.1501131143250.17382@nanos>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 11:47 AM, Thomas Gleixner wrote:
> On Mon, 12 Jan 2015, Daniel Lezcano wrote:
>
>> On 01/12/2015 03:04 PM, Nicolas Ferre wrote:
>>> Le 18/12/2014 15:05, Nicolas Ferre a écrit :
>>>> From: Sylvain Rochet <sylvain.rochet@finsecur.com>
>>>>
>>>> Waiting for PIT to stop counting takes a long time:
>>>>     1/(Master clock/prescaler/PIVR)
>>>> = 1/(133 MHz     /16       /2^20)
>>>> = 126 ms
>>>>
>>>> Up to 126 ms if master clock is set to 133 MHz, skipping suspend/resume
>>>> of the unused PIT device reduce (suspend time + resume time) from ~140 ms
>>>> to ~17 ms.
>>>>
>>>> Signed-off-by: Sylvain Rochet <sylvain.rochet@finsecur.com>
>>>> [nicolas.ferre@atmel.com: move to newer clocksource driver]
>>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>>>> ---
>>>> Hi Sylvain,
>>>>
>>>> I re-worked (and "Acked") your patch so it can be applied on the newer
>>>> Mainline
>>>> kernels. Beware, I changed the "subject line" as well. The PIT driver
>>>> moved
>>>> recently (3.18).
>>>>
>>>> Daniel,
>>>> Can you take this patch in your tree?
>>>
>>> Hi Daniel,
>>>
>>> Anything prevents this patch from being merged (aka ping ;-))?
>>
>> [Cc'ed tglx].
>>
>> Hi Nico,
>>
>> thanks for the head up.
>>
>> Nothing prevents it but I am wondering if this change shouldn't be in the
>> generic framework (kernel/time/clocksource.c and kernel/time/clockevents.c),
>> so all drivers will benefit this change ?
>
> Indeed. There is no point in calling suspend/resume for unused
> clockevents. They should be stopped and disabled already.

Hi Nico,

are you planning to do the change in the generic framework ?

Thanks
   -- Daniel

> Now with clocksources this might be different. We have no explicit
> state for this, but its trivial to add one at least for those
> clocksources which have enable/disable callbacks. For the other ones
> not so much.





-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

