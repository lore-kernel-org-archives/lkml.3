Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab3JHHgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:36:55 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:49593 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3JHHgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:36:51 -0400
Date: Tue, 8 Oct 2013 09:36:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@redhat.com, jolsa@redhat.com,
        zheng.z.yan@intel.com
Subject: Re: [PATCH v1 1/2] perf,x86: add Intel RAPL PMU support
Message-ID: <20131008073647.GC4455@gmail.com>
References: <1381162158-24329-1-git-send-email-eranian@google.com>
 <1381162158-24329-2-git-send-email-eranian@google.com>
 <20131007175542.GB3363@tassilo.jf.intel.com>
 <20131007180810.GJ3081@twins.programming.kicks-ass.net>
 <20131007192258.GC3363@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007192258.GC3363@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> On Mon, Oct 07, 2013 at 08:08:10PM +0200, Peter Zijlstra wrote:
> > On Mon, Oct 07, 2013 at 10:55:42AM -0700, Andi Kleen wrote:
> > > This would in principle allow making it a module later (if perf ever
> > > supports that)
> > 
> > IIRC its a few EXPORTs away from being able to do that.
> 
> Great. With ~700k text that would be a good thing.

Nonsense, the real overhead of core perf + PMU drivers on x86-64 is around 
150k.

The 700k overhead you claimed is not reproducible, at all, and I tested it 
with your own config:

  https://lkml.org/lkml/2013/10/8/62

700k in perf is nonsensical - it's an obvious lie really, the code sizes 
of the relevant perf .o objects are nowhere even _close_ to that amount:

 hubble:~/tip> size $(find . -name '*perf*.o')
   text    data     bss     dec     hex filename
    887       0      32     919     397 ./arch/x86/kernel/cpu/perfctr-watchdog.o
   2932     680      96    3708     e7c ./arch/x86/kernel/cpu/perf_event_amd_uncore.o
  14117    6361       1   20479    4fff ./arch/x86/kernel/cpu/perf_event_intel.o
  23787   19541     264   43592    aa48 ./arch/x86/kernel/cpu/perf_event_intel_uncore.o
   4531    1572       0    6103    17d7 ./arch/x86/kernel/cpu/perf_event_p4.o
   1728    1121       0    2849     b21 ./arch/x86/kernel/cpu/perf_event_knc.o
   4591     811      32    5434    153a ./arch/x86/kernel/cpu/perf_event_amd_ibs.o
  13394    6797     116   20307    4f53 ./arch/x86/kernel/cpu/perf_event.o
   3156    1483      32    4671    123f ./arch/x86/kernel/cpu/perf_event_amd_iommu.o
   5322    4396       0    9718    25f6 ./arch/x86/kernel/cpu/perf_event_intel_ds.o
  11383       1       0   11384    2c78 ./arch/x86/kernel/cpu/perf_event_intel_lbr.o
   3636    1125       0    4761    1299 ./arch/x86/kernel/cpu/perf_event_amd.o
   1282     544       0    1826     722 ./arch/x86/kernel/cpu/perf_event_p6.o
    278       1       0     279     117 ./arch/x86/kernel/perf_regs.o
   4844      88      12    4944    1350 ./drivers/acpi/processor_perflib.o
     77      96       0     173      ad ./drivers/cpufreq/cpufreq_performance.o
    232      64       0     296     128 ./drivers/devfreq/governor_performance.o
   1972       4      64    2040     7f8 ./kernel/trace/trace_event_perf.o

So stop making that ridiculous claim without posting exact .config's 
publicly.

Thanks,

	Ingo
