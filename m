Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab3KKH7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:59:37 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24185 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3KKH73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:59:29 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-be-52808e5ee102
Message-id: <52808E09.9060902@samsung.com>
Date: Mon, 11 Nov 2013 11:58:01 +0400
From: Tarek Dakhran <t.dakhran@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Naour Romain <romain.naour@openwide.fr>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH v3 3/4] ARM: EXYNOS: add Exynos Dual Cluster Support
References: <20131108184036.GD2602@localhost.localdomain>
 <alpine.LFD.2.03.1311081356300.15571@syhkavp.arg>
In-reply-to: <alpine.LFD.2.03.1311081356300.15571@syhkavp.arg>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t/xq7pxfQ1BBj9WsVtMWneAyWLeZ1mL
	prl7GC3mHznHavH/0WtWi3OvVjJa9C64ymax6fE1VouFbUtYLC7vmsNmMeP8PiaL25d5LZZe
	v8hk8XTCRTaLT8/+sVtMmL6WxeLwCqBp615OZ7HY8rOD0eLVwTYWi82bpjJbrNr1h9Fi6owf
	7A7iHmvmrWH0aGnuYfNY8PkKu8ffVS+YPXbOusvusXL5FzaPV6tnsnrcubaHzePduXPsHpuX
	1Hu8usbi0bdlFaPH9mvzmD0+b5Lz2Dg3NIA/issmJTUnsyy1SN8ugSvjcFM7e8F3rYov+1pZ
	Gxi3KHYxcnJICJhI3Dl2hhnCFpO4cG89G4gtJLCUUWLrd6suRi4g+z2jxNWFX1hBErwCWhIX
	XjYxgdgsAqoSk5Y9Zu9i5OBgE9CW2LLDCyQsKhAhcXT1M6hyQYkfk++xgNgiAv4Sd6asYQGZ
	ySzwnF1i54IVYAlhAQ+Jk7Mus0IszpU49G4O2HxOATuJpb/ugNUwC1hLrJy0jRHClpfYvOYt
	8wRGgVlIdsxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCHx/XUH49JjVocY
	BTgYlXh4GeQagoRYE8uKK3MPMUpwMCuJ8GZ5AIV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwKh2T
	MXUzNZvU8WXiyfWrbkXyL0iutf18eX5VZObfiF9743NUWJh3upSfnxrrXHlSUds1UN9+RcT5
	9nM3rWzM/jGwbbZKnrfb/KXho/+vljXx3FcoXi71oO+d7wHOEOvE42uE1odmsYqc3HfxL+N+
	x7rGlJePV82qMdnd+WZJQjwro8WZhglHlViKMxINtZiLihMBug85mc0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08.11.2013 23:21, Nicolas Pitre wrote:
> On Fri, 8 Nov 2013, Dave Martin wrote:
>
>> On Thu, Nov 07, 2013 at 11:51:49AM -0500, Nicolas Pitre wrote:
>>> On Thu, 7 Nov 2013, Dave Martin wrote:
>>>
>>>> If there is a pending powerdown which has reached the __mcpm_cpu_down()
>>>> stage, then the kernel has no way to know what is still pending.  This
>>>> means that when calling exynos_power_up(cpu, cluster) after a successful
>>>> call to exynos_power_down(same cpu, cluster), there is a chance that
>>>> the CPU still gets powered down, because of the pending
>>>> exynos_core_power_control() on the outbound side.
>>>> This isn't an issue for TC2, because TC2's power controller queues
>>>> requests and services them in order, so a new powerup request cannot
>>>> race with a powerdown request in that way.
>> We still rely on the power controller doing some serialisation.
>>
>> Come to think of it, I should go and take a look at how cpu_kill()
>> should be implemented for DSCSB too.
>>
>>> The reason why this isn't an issue for TC2 is because the request to
>>> power down request is sent from within the spinlock protected area which
>>> serializes all requests.  Here exynos_core_power_down() is invoked where
>>> there is no such protection.
>> We don't wait for the requests to complete before dropping the lock, so
>> we still rely on the SPC doing some serialisation.
> Yes.  But the request order is still preserved in that case.
>
> In this case here, the exynos_core_power_up call is performed with a
> lock held, but exynos_core_power_down is not.  This means that, by the
> time exynos_core_power_down is about to be called, some other CPU might
> have decided that the current CPU should not power down after all and
> call exynos_core_power_up.  Which one will win the race and execute
> before the other is up in the air.
>
> It is important that the actual power control be tightly related to the
> management of the usage count currently and properly done within the
> lock protected area.  If the use count is zero in the power_up request
> then the power has to be turned on.
>
> However here there is still a chance that the power will be turned off
> right away afterwards based on the skip_wfi variable which is wrong.
>
>>> The simple fix would be to simply move this call up, assuming that the
>>> power is actually turned off only when the WFI signal is asserted.
>> Can you explain?  I'm not sure I get this -- once the outbound CPU has
>> gone into blackout there's no way to know when it's finished except
>> to wait.
> The issue here is not about whether or not the outbound has finished
> killing itself.  It is about making sure that the actual power knob is
> on or off according to the use count.  Therefore the power knob has to
> be toggled from within the same lock protected area as the use count for
> coherency to be preserved.  If exynos_core_power_down is called outside
> of the lock protected area, it is well possible that the use count might
> have gone back to 1 in the mean time.
>
>>>> Maybe we should always just poll and wait, though.  exynos_power_up()
>>>> should never be called for a CPU that the kernel thinks is already up,
>>>> so it should either be down already (in which case we will poll the
>>>> status once and then continue), or a power down is pending (in which
>>>> case we must wait, but we know the wait will terminate).  This would
>>>> be simpler than tracking a "power down pending" flag for each CPU.
>>> That is also a good way to avoid the race.
>> I guess it will depend on exactly what the power controller does.
> Right.
>
> Samsung people: could you give us more info on the behavior of the power
> controller please?
>
>
> Nicolas
>
This is how the power controller works on exynos5410. For example for CORE0.

ARM_CORE0_STATUS register indicates the power state of Core 0 part of 
processor core.
0x3 indicates that power to Core 0 is turned-on. 0x0 indicates that 
power to Core 0 is turned-off.
All other values indicate that the power On/Off sequence of Core 0 in 
progress.

To turn Off the power of Core 0 power domain:

1. Set the LOCAL_POWER_CFG field of ARM_CORE0_CONFIGURATION register to 0x3.
2. After PMU detects a change in the LOCAL_POWER_CFG field, it waits for 
the execution of WFI.
3. After Core 0 executes the WFI instruction, PMU starts the power-down 
sequence.
4. The Status field of ARM_CORE0_STATUS register indicates the 
completion of the sequence.

That's why in the v1 of this patch exynos_core_power_control function 
was implemented as:

static int exynos_core_power_control(unsigned int cpu, unsigned int 
cluster,  int enable)
{
        unsigned long timeout = jiffies + msecs_to_jiffies(10);
        unsigned int offset = cluster * MAX_CPUS_PER_CLUSTER + cpu;
        int value = enable ? S5P_CORE_LOCAL_PWR_EN : 0;

        if ((__raw_readl(EXYNOS5410_CORE_STATUS(offset)) & 0x3) == value)
                return 0;

        __raw_writel(value, EXYNOS5410_CORE_CONFIGURATION(offset));
        do {
                if ((__raw_readl(EXYNOS5410_CORE_STATUS(offset)) & 0x3)
                                == value)
                        return 0;
        } while (time_before(jiffies, timeout));

        return -EDEADLK;
}

But, as i mentioned, this is no good using while here.
Now thinking about the problem.

Thank you,
         Tarek Dakhran
