Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaBKNaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:30:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54536 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaBKNaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:30:06 -0500
Date: Tue, 11 Feb 2014 14:29:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
Message-ID: <20140211132956.GY9987@twins.programming.kicks-ass.net>
References: <20140130190253.GA11819@redhat.com>
 <alpine.DEB.2.10.1402101620170.29602@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402101620170.29602@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 04:26:29PM -0500, Vince Weaver wrote:
> On Thu, 30 Jan 2014, Dave Jones wrote:
> 
> > I gave Vince's perf_fuzzer a run, hoping to trigger a different perf bug
> > that I've been seeing. Instead I hit a different bug.
> 
> I've been seeing that WARN_ON for months but it was hard to reproduce.
> After a lot of hassle (and scores or reboots) I managed to narrow this to 
> a small test case.
> 
> Unfortunately it only reproduces on my core2 machine.  My ivb machine 
> won't trigger it because it doesn't support PERF_COUNT_HW_INSTRUCTIONS
> when precise_ip=1; is set.
> 
> This is with 3.14-rc2
> 
> The test case is attached, the warning message from my machine is below.
> 
> Vince
> 
> [   47.296031] ------------[ cut here ]------------
> [   47.300013] WARNING: CPU: 0 PID: 2821 at arch/x86/kernel/cpu/perf_event.c:1076 x86_pmu_start+0x46/0xee()
> [   47.300013] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 usbnet evdev ohci_pci ohci_hcd pcspkr i2c_nforce2 psmouse serio_raw coretemp video wmi button acpi_cpufreq processor thermal_sys ehci_pci ehci_hcd sg sd_mod usbcore usb_common
> [   47.300013] CPU: 0 PID: 2821 Comm: out Not tainted 3.14.0-rc2 #2

Yes that one is annoying.. I've seen it several times.

Unfortunately I cannot seem to reproduce on either the WSM (which should
have INST.RET as PEBS capable) nor my core2 laptop.

That said, the laptop seems sick on current kernels, so it might be
hiding due to other problems.

I'll see if I can run through the reproduction case by hand.
