Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaAVMAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:00:54 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:60427 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbaAVMAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:00:52 -0500
Date: Wed, 22 Jan 2014 13:00:48 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        dyoung@redhat.com
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140122120048.GB389@x4>
References: <20131212140835.729222186@infradead.org>
 <20131212141655.362219382@infradead.org>
 <52DEF495.2020304@oracle.com>
 <20140122104532.GJ31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122104532.GJ31570@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.01.22 at 11:45 +0100, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 05:28:37PM -0500, Sasha Levin wrote:
> > On 12/12/2013 09:08 AM, Peter Zijlstra wrote:
> > 
> > This patch seems to be causing an issue with booting a KVM guest. It seems that it
> > causes the time to go random during early boot process:
> > 
> > 	[    0.000000] Initmem setup node 30 [mem 0x12ee000000-0x138dffffff]
> > 	[    0.000000]   NODE_DATA [mem 0xcfa42000-0xcfa72fff]
> > 	[    0.000000]     NODE_DATA(30) on node 1
> > 	[    0.000000] Initmem setup node 31 [mem 0x138e000000-0x142fffffff]
> > 	[    0.000000]   NODE_DATA [mem 0xcfa11000-0xcfa41fff]
> > 	[    0.000000]     NODE_DATA(31) on node 1
> > 	[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> > 	[    0.000000] kvm-clock: cpu 0, msr 0:cf991001, boot clock
> > 	[133538.294040] Zone ranges:
> > 	[133538.294338]   DMA      [mem 0x00001000-0x00ffffff]
> > 	[133538.294804]   DMA32    [mem 0x01000000-0xffffffff]
> > 	[133538.295223]   Normal   [mem 0x100000000-0x142fffffff]
> > 	[133538.295670] Movable zone start for each node
> > 

FYI it happens on real hardware on my machine:
...
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 3210.681 MHz processor
[   60.375238] Calibrating delay loop (skipped), value calculated using timer frequency.. 6423.91 BogoMIPS (lpj=10702270)
[   60.375240] pid_max: default: 32768 minimum: 301
[   60.375259] Mount-cache hash table entries: 256
[   60.375373] tseg: 0000000000
[   60.375377] CPU: Physical Processor ID: 0
[   60.375377] CPU: Processor Core ID: 0
[   60.375378] mce: CPU supports 6 MCE banks
[   60.375382] LVT offset 0 assigned for vector 0xf9
[   60.375384] process: using AMD E400 aware idle routine
[   60.375386] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
...
-- 
Markus
