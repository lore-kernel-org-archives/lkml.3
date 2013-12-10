Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3LJIZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:25:27 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61529 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3LJIZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:25:19 -0500
Message-ID: <52A6CFEC.7010607@linaro.org>
Date: Tue, 10 Dec 2013 09:25:16 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: anish singh <anish198519851985@gmail.com>
CC: Alex Shi <alex.shi@linaro.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        preeti@linux.vnet.ibm.com, "len.brown@intel.com" <len.brown@intel.com>
Subject: Re: questions of cpuidle
References: <52A5C846.30308@linaro.org>	<52A5D0E0.7050201@linaro.org>	<52A6B5BB.3060506@linaro.org>	<52A6C24B.3030800@linaro.org> <CAK7N6vpbrSKJvUG0ZY34Lt0CqOR=5Xaew65wJvf4paD5xB0mCg@mail.gmail.com>
In-Reply-To: <CAK7N6vpbrSKJvUG0ZY34Lt0CqOR=5Xaew65wJvf4paD5xB0mCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 09:07 AM, anish singh wrote:
> On Mon, Dec 9, 2013 at 11:27 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>> On 12/10/2013 07:33 AM, Alex Shi wrote:
>>>
>>> On 12/09/2013 10:17 PM, Daniel Lezcano wrote:
>>>>
>>>>
>>>> Concerning the wake up of the cpu: the cpu disabled the irq and
>>>> goes to sleep, it is up to the firmware to wake up the cpu when an
>>>> interrupt occurs. It will exits its sleep state, call
>>>> clock_events_notify(EXIT), by this way re-switching to the local
>>>> timer, and then re-enabling the local interrupt which leads to the
>>>> interrupt handler.
>>>
>>>
>>> Thanks a lots for excellent article and detailed explains!
>>>
>>> So, if the firmware is in response to wake up cpu. that means there
>>> is a unit which control the firmware and it can not be power down.
>>
>>
>> Correct.
>>
>>
>>> Do you know which unit running the firmware to wake up deep idle
>>> CPU.
>>
>>
>> That depends on the SoC implementation.
> and which is intentionally kept hidden away.
>>
>> Some SoC have a "Power Management Unit". The PMU has several idle states
>> defined, each of them are described in the technical reference manual
>> (TRM) with the wake up sources.
> PMU is intentionally kept hidden by OEM companies as this way
> they protect there hardware IP.

Unfortunately yes and beside that hiding the bugs in a black box letting 
the user/developer to bang its head against the walls :)

>> Some SoC don't have any PMU and the idle states are very few, keeping
>> most of the logic on.
>>
>> Some other SoC hide the PMU behind PSCI calls.
> which is intentional.
>>> And does the wake up pass via GIC to CPU? If so, does the GIC need
>>> keep awake when all cpu idle? If not, how the firmware give the
>>> interrupt to CPU? And I am wondering if the deep idle cpu voltage get
>>> to near 0. How the cpu get the interrupt signal?
>>
>>
>> If a deep idle state powers down the GIC, it is up to the PMU to proxy
>> the interrupts. When an interrupt occurs, the PMU powers up the logic,
>> including the GIC. The notifier call chain with cpu_suspend / cpu_resume
>> will save and restore the GIC registers.
>>
>> But this is hardware specific and will depend on how the PMU is
>> implemented and how far it goes in the power management.
>>
>> You have a good example in the drivers/cpuidle/cpuidle-ux500.c to
>> understand with the comments how the interrupts are handled through the
>> power management unit.
>>
>> In the Xillinx documentation available on the web [1], the chapter 24.4
>> gives the information about one kind of PMU.
>>
>> I believe the mechanism is pretty similar on all the hardware but it is
>> obfuscated by a generic power instruction like mwait.
>>
>>    -- Daniel
>>
>> [1]
>> http://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf
>>
>>
>>
>>>> There are some more informations in the wiki page [1].
>>>>
>>>> -- Daniel
>>>>
>>>> [1]
>>>> https://wiki.linaro.org/WorkingGroups/PowerManagement/Doc/WakeUpSources
>>>
>>>
>>>>
>>>
>>
>>
>> --
>>   <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>>
>> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
>> <http://twitter.com/#!/linaroorg> Twitter |
>> <http://www.linaro.org/linaro-blog/> Blog
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

