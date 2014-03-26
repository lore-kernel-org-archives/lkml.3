Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaCZWKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 18:10:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaCZWKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 18:10:12 -0400
Date: Wed, 26 Mar 2014 15:10:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephane Eranian <eranian@google.com>
Cc: Artem Fetishev <artem_fetishev@epam.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Fix boot on uniprocessor systems
Message-Id: <20140326151010.777e0c527243c23da4a2b1f4@linux-foundation.org>
In-Reply-To: <CABPqkBTk+b_+PM_YdxUYw8PDdo9PL506jCR1xzqD6=SXc+zbKg@mail.gmail.com>
References: <20140324225910.GB4937@owamsq.epam.com>
	<20140326133148.4a347bf956b1c5fd2ae40335@linux-foundation.org>
	<CABPqkBTk+b_+PM_YdxUYw8PDdo9PL506jCR1xzqD6=SXc+zbKg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014 23:01:07 +0100 Stephane Eranian <eranian@google.com> wrote:

> On Wed, Mar 26, 2014 at 9:31 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Tue, 25 Mar 2014 01:59:10 +0300 Artem Fetishev <artem_fetishev@epam.com> wrote:
> >
> >> On x86 uniprocessor systems topology_physical_package_id() returns -1 which
> >> causes rapl_cpu_prepare() to leave rapl_pmu variable uninitialized which leads
> >> to GPF in rapl_pmu_init(). See arch/x86/kernel/cpu/perf_event_intel_rapl.c.
> >>
> >> It turns out that physical_package_id and core_id can actually be retreived for
> >> uniprocessor systems too. Enabling them also fixes rapl_pmu code.
> >>
> >> Signed-off-by: Artem Fetishev <artem_fetishev@epam.com>
> >> ---
> >> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> >> index d35f24e..1306d11 100644
> >> --- a/arch/x86/include/asm/topology.h
> >> +++ b/arch/x86/include/asm/topology.h
> >> @@ -119,9 +119,10 @@ static inline void setup_node_to_cpumask_map(void) { }
> >>
> >>  extern const struct cpumask *cpu_coregroup_mask(int cpu);
> >>
> >> -#ifdef ENABLE_TOPO_DEFINES
> >>  #define topology_physical_package_id(cpu)    (cpu_data(cpu).phys_proc_id)
> >>  #define topology_core_id(cpu)                        (cpu_data(cpu).cpu_core_id)
> >> +
> >> +#ifdef ENABLE_TOPO_DEFINES
> >>  #define topology_core_cpumask(cpu)           (per_cpu(cpu_core_map, cpu))
> >>  #define topology_thread_cpumask(cpu)         (per_cpu(cpu_sibling_map, cpu))
> >>  #endif
> >
> > The patch applies to 3.13 and perhaps earlier kernels.  Is it needed in
> > those kernel versions?
> 
> Before 3.13 there was no RAPL support.
> But it seems the patch is still useful regardless

Is that an ack?  If so I'll squirt it Linuswards right now for 3.14.

