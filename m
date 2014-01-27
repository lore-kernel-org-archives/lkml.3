Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaA0RMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:12:55 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:47149 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaA0RMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:12:53 -0500
Message-ID: <52E69395.9020004@linaro.org>
Date: Mon, 27 Jan 2014 18:12:53 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/9] ARM: get rid of arch_cpu_idle_prepare()
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org> <1390802904-28399-2-git-send-email-nicolas.pitre@linaro.org> <52E6175F.1050401@linaro.org> <20140127160736.GP15937@n2100.arm.linux.org.uk>
In-Reply-To: <20140127160736.GP15937@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 05:07 PM, Russell King - ARM Linux wrote:
> On Mon, Jan 27, 2014 at 09:22:55AM +0100, Daniel Lezcano wrote:
>> On 01/27/2014 07:08 AM, Nicolas Pitre wrote:
>>> ARM and ARM64 are the only two architectures implementing
>>> arch_cpu_idle_prepare() simply to call local_fiq_enable().
>>>
>>> We have secondary_start_kernel() already calling local_fiq_enable() and
>>> this is done a second time in arch_cpu_idle_prepare() in that case. And
>>> enabling FIQs has nothing to do with idling the CPU to start with.
>>>
>>> So let's introduce init_fiq_boot_cpu() to take care of FIQs on the boot
>>> CPU and remove arch_cpu_idle_prepare(). This is now done a bit earlier
>>> at late_initcall time but this shouldn't make a difference in practice
>>> i.e. when FIQs are actually used.
>>>
>>> Signed-off-by: Nicolas Pitre <nico@linaro.org>
>>
>> Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>
> What kind of review did you do when giving that attributation?

I did the review to the best of my knowledge and with good will.

I read your comment on this patch and I learnt one more thing.

Today, I am smarter than yesterday and dumber than tomorrow :)


   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

