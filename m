Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaBKMu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:50:26 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:57943 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaBKMuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:50:23 -0500
Message-ID: <52FA1C8C.40105@linaro.org>
Date: Tue, 11 Feb 2014 13:50:20 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, rob@landley.net,
        linux@arm.linux.org.uk, galak@codeaurora.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, tglx@linutronix.de,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grygorii.strashko@ti.com, joshc@codeaurora.org
Subject: Re: [PATCH v6 0/3] Introduce clocksource driver for Keystone platform
References: <1392027058-11680-1-git-send-email-ivan.khoronzhuk@ti.com> <52F8F55A.2090903@ti.com>
In-Reply-To: <52F8F55A.2090903@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 04:50 PM, Santosh Shilimkar wrote:
> Daniel,
>
> On Monday 10 February 2014 05:10 AM, Ivan Khoronzhuk wrote:
>> Add a broadcast timer64 based clockevent driver for keystone arch.
>> This driver uses timer in 64-bit general purpose mode as clock event
>> device.
>>
>> Documentation:
>>      http://www.ti.com/lit/ug/sprugv5a/sprugv5a.pdf
>>
>> Based on
>> git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
>> keystone/master
>>
>> v5..v6:
>> 	added function to encapsulate __iowmb().
>>
>> v4..v5:
>> 	used __iowmb() insted of wmb()
>>
>> v3..v4:
>> 	rebased on latest of linux-keystone.git keystone/master
>>
>> v2..v3:
>> - clocksource: timer-keystone: introduce clocksource driver for
>> 	changed "u64" type to "unsigned long" for hz_period as more appropriate
>> 	hz_period rounded up by DIV_ROUND_UP(rate, HZ)
>> 	corrected comments
>>
>> v1..v2:
>> - clocksource: timer-keystone: introduce clocksource driver for
>> 	renamed timer on "timer-keystone"
>> 	in keystone_timer_interrupt() evet pointer is passed via "dev_id"
>> 	used __relaxed variants of writel/readl and added explicit barriers
>> 	added "keystone_timer_disable()" for using in keystone_set_mode()
>> 	keystone_timer_config() is not used for disabling the timer any more
>> 	in case of an unsupported mode the keystone_timer_config() returns -1.
>> 	used request_irq() instead of setup_irq()
>> 	assigned irq for event_device in event_dev->irq
>> 	calculated timer.hz_period for CLOCK_EVT_MODE_PERIODIC at init
>> 	deleted spare call of keystone_timer_config() in keystone_timer_init()
>>
>> Ivan Khoronzhuk (3):
>>    clocksource: timer-keystone: introduce clocksource driver for Keystone
>>    clocksource: keystone: add bindings for keystone timer
>>    arm: dts: keystone: add keystone timer entry
>>
> Can you queue the first two patches from the series ?
> I will queue the dts patch via my tree.

Sure.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

