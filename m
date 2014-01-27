Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaA0P6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:58:36 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:55484 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753483AbaA0P6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:58:33 -0500
Date: Mon, 27 Jan 2014 15:57:55 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 2/9] ARM64: get rid of arch_cpu_idle_prepare()
Message-ID: <20140127155755.GH32608@arm.com>
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org>
 <1390802904-28399-3-git-send-email-nicolas.pitre@linaro.org>
 <20140127154315.GG32608@arm.com>
 <alpine.LFD.2.11.1401271047240.1652@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1401271047240.1652@knanqh.ubzr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 03:51:02PM +0000, Nicolas Pitre wrote:
> On Mon, 27 Jan 2014, Catalin Marinas wrote:
> 
> > On Mon, Jan 27, 2014 at 06:08:17AM +0000, Nicolas Pitre wrote:
> > > ARM and ARM64 are the only two architectures implementing
> > > arch_cpu_idle_prepare() simply to call local_fiq_enable().
> > > 
> > > We have secondary_start_kernel() already calling local_fiq_enable() and
> > > this is done a second time in arch_cpu_idle_prepare() in that case. And
> > > enabling FIQs has nothing to do with idling the CPU to start with.
> > > 
> > > So let's introduce init_fiq_boot_cpu() to take care of FIQs on the boot
> > > CPU and remove arch_cpu_idle_prepare(). This is now done a bit earlier
> > > at late_initcall time but this shouldn't make a difference in practice
> > > given that FIQs are not currently used on ARM64.
> > > 
> > > Signed-off-by: Nicolas Pitre <nico@linaro.org>
> > 
> > For arm64, we could simply remove any reference to FIQs. I'm not aware
> > of anyone using them.
> 
> OK. What if I sumply remove arch_cpu_idle_prepare() and let you do the 
> remove the rest?
> 
> IMHO I'd simply remove local_fiq_{enable/disable}() from 
> arm64/kernel/smp.c and leave the infrastructure in place in case someone 
> needs it eventually.  In which case I could include that into my patch 
> as well.

Sounds good. We can keep the local_fiq_*() functions but remove about 4
calling sites (process.c and smp.c) until needed.

Thanks.

-- 
Catalin
