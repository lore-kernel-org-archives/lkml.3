Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3JBSIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:08:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34125 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3JBSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:08:37 -0400
Message-ID: <524C60F4.7000802@ti.com>
Date: Wed, 2 Oct 2013 14:07:48 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Stephen Boyd <sboyd@codeaurora.org>,
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
References: <1380732928-13897-1-git-send-email-santosh.shilimkar@ti.com> <20131002170917.GB30298@mudshark.cambridge.arm.com> <524C5484.5000601@ti.com> <524C565C.8010709@codeaurora.org> <524C5786.2090008@ti.com> <524C5B10.20006@codeaurora.org> <20131002174841.GH30298@mudshark.cambridge.arm.com>
In-Reply-To: <20131002174841.GH30298@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 October 2013 01:48 PM, Will Deacon wrote:
> On Wed, Oct 02, 2013 at 06:42:40PM +0100, Stephen Boyd wrote:
>> On 10/02/13 10:27, Santosh Shilimkar wrote:
>>> Really... I have not created patch out of fun.
>>> Its broken on my keystone machine at least where the sched_clock is
>>> falling back on jiffy based sched_clock even in presence of arch_timer
>>> sched_clock.
>>
>> How is that possible? sched_clock_func is only assigned by
>> arch/arm/kernel/arch_timer.c when the architected timer is detected and
>> sched_clock() in kernel/time/sched_clock.c calls that function pointer
>> unconditionally. The only way I see this happening is if the architected
>> timer rate is zero.
>   ^^^^^^^^^^^^^^^^^^
> 
> *cough* CNTFRQ *cough*
> 
:) CNTFRQ as such is fine. I think the below print mis-lead me mostly. 

sched_clock: ARM arch timer >56 bits at 6144kHz, resolution 162ns
sched_clock: 32 bits at 100 Hz, resolution 10000000ns, wraps every 4294967286ms

So yes, now the subject patch actually just avoids the jiffy sched_clock()
registration and nothing else. Even without the patch arch_timer sched_clock
will be in use.

Regards,
Santosh
