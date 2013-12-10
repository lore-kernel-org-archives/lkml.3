Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3LJIHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:07:40 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63632 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3LJIHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:07:33 -0500
MIME-Version: 1.0
In-Reply-To: <52A6C24B.3030800@linaro.org>
References: <52A5C846.30308@linaro.org>
	<52A5D0E0.7050201@linaro.org>
	<52A6B5BB.3060506@linaro.org>
	<52A6C24B.3030800@linaro.org>
Date: Tue, 10 Dec 2013 00:07:32 -0800
Message-ID: <CAK7N6vpbrSKJvUG0ZY34Lt0CqOR=5Xaew65wJvf4paD5xB0mCg@mail.gmail.com>
Subject: Re: questions of cpuidle
From: anish singh <anish198519851985@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Alex Shi <alex.shi@linaro.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        preeti@linux.vnet.ibm.com, "len.brown@intel.com" <len.brown@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 11:27 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 12/10/2013 07:33 AM, Alex Shi wrote:
>>
>> On 12/09/2013 10:17 PM, Daniel Lezcano wrote:
>>>
>>>
>>> Concerning the wake up of the cpu: the cpu disabled the irq and
>>> goes to sleep, it is up to the firmware to wake up the cpu when an
>>> interrupt occurs. It will exits its sleep state, call
>>> clock_events_notify(EXIT), by this way re-switching to the local
>>> timer, and then re-enabling the local interrupt which leads to the
>>> interrupt handler.
>>
>>
>> Thanks a lots for excellent article and detailed explains!
>>
>> So, if the firmware is in response to wake up cpu. that means there
>> is a unit which control the firmware and it can not be power down.
>
>
> Correct.
>
>
>> Do you know which unit running the firmware to wake up deep idle
>> CPU.
>
>
> That depends on the SoC implementation.
and which is intentionally kept hidden away.
>
> Some SoC have a "Power Management Unit". The PMU has several idle states
> defined, each of them are described in the technical reference manual
> (TRM) with the wake up sources.
PMU is intentionally kept hidden by OEM companies as this way
they protect there hardware IP.
>
> Some SoC don't have any PMU and the idle states are very few, keeping
> most of the logic on.
>
> Some other SoC hide the PMU behind PSCI calls.
which is intentional.
>
>
>> And does the wake up pass via GIC to CPU? If so, does the GIC need
>> keep awake when all cpu idle? If not, how the firmware give the
>> interrupt to CPU? And I am wondering if the deep idle cpu voltage get
>> to near 0. How the cpu get the interrupt signal?
>
>
> If a deep idle state powers down the GIC, it is up to the PMU to proxy
> the interrupts. When an interrupt occurs, the PMU powers up the logic,
> including the GIC. The notifier call chain with cpu_suspend / cpu_resume
> will save and restore the GIC registers.
>
> But this is hardware specific and will depend on how the PMU is
> implemented and how far it goes in the power management.
>
> You have a good example in the drivers/cpuidle/cpuidle-ux500.c to
> understand with the comments how the interrupts are handled through the
> power management unit.
>
> In the Xillinx documentation available on the web [1], the chapter 24.4
> gives the information about one kind of PMU.
>
> I believe the mechanism is pretty similar on all the hardware but it is
> obfuscated by a generic power instruction like mwait.
>
>   -- Daniel
>
> [1]
> http://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf
>
>
>
>>> There are some more informations in the wiki page [1].
>>>
>>> -- Daniel
>>>
>>> [1]
>>> https://wiki.linaro.org/WorkingGroups/PowerManagement/Doc/WakeUpSources
>>
>>
>>>
>>
>
>
> --
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
