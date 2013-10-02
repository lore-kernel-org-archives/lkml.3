Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3JBR21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:28:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49075 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab3JBR2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:28:24 -0400
Message-ID: <524C5786.2090008@ti.com>
Date: Wed, 2 Oct 2013 13:27:34 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH] sched_clock: fix postinit no sched_clock function check
References: <1380732928-13897-1-git-send-email-santosh.shilimkar@ti.com> <20131002170917.GB30298@mudshark.cambridge.arm.com> <524C5484.5000601@ti.com> <524C565C.8010709@codeaurora.org>
In-Reply-To: <524C565C.8010709@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 October 2013 01:22 PM, Stephen Boyd wrote:
> On 10/02/13 10:14, Santosh Shilimkar wrote:
>> On Wednesday 02 October 2013 01:09 PM, Will Deacon wrote:
>>> On Wed, Oct 02, 2013 at 05:55:28PM +0100, Santosh Shilimkar wrote:
>>>> The sched_clock code uses 2 levels of function pointers, sched_clock_func()
>>>> and read_sched_clock() but the no sched_clock check in postinit() just
>>>> checks read_sched_clock().
>>>>
>>>> This leads to kernel falling back to jiffy based sched clock even in
>>>> presence of sched_clock_func() which is not desirable.
>>>>
>>>> Fix the postinit() check to avoid the issue. Probably the issue is hidden
>>>> so far on most of the arm SOCs because of already existing sched_clock
>>>> registrations apart from arch_timer sched_clock. One can reproduce the
>>>> issue by just have arch_timer as sched_clock
>>> Isn't this just an issue with the arch timer driver not calling
>>> setup_sched_clock? Instead, we munge around with sched_clock_func directly,
>>> which doesn't appear to be the way anybody else deals with this.
>>>
>> I thought about that option as well but was not sure since even in that case
>> the check is not complete. We just ensure that function is popullated.
> 
> Yes, nothing is actually broken because sched_clock_func() won't try to
> use the jiffy based read_sched_clock() function. I'm not sure we
> actually need this patch besides to remove a useless timer that updates
> the jiffy epoch. Can we wait until my 64-bit sched_clock patch series
> lands in 3.13? It looks like I still need an ack from Will or Catalin on
> the architected timer patch before the clocksource folks pick it up.
> 
Really... I have not created patch out of fun.
Its broken on my keystone machine at least where the sched_clock is
falling back on jiffy based sched_clock even in presence of arch_timer
sched_clock.

Regards,
Santosh

