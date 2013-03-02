Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab3CBNPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:15:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:39572 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab3CBNPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:15:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,767,1355126400"; 
   d="scan'208";a="293913593"
Date: Sat, 2 Mar 2013 21:15:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christopher Li <sparse@chrisli.org>
Subject: Re: [trace:tip/perf/core 5/15] kernel/trace/trace_functions.c:79:16:
 sparse: incorrect type in initializer (different address spaces)
Message-ID: <20130302131526.GA15049@localhost>
References: <5131ad43.H709l5IR4X+pbvbq%fengguang.wu@intel.com>
 <1362229972.31874.7.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362229972.31874.7.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

// add CC to Christopher.

On Sat, Mar 02, 2013 at 08:12:52AM -0500, Steven Rostedt wrote:
> On Sat, 2013-03-02 at 15:41 +0800, kbuild test robot wrote:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git tip/perf/core
> > head:   f44f8638e47c89fa5c612a18f324ba6222b69597
> > commit: 50b85fe13be0878f13eecd36d1219828ba73316d [5/15] tracing: Replace the static global per_cpu arrays with allocated per_cpu
> > 
> > 
> > sparse warnings: (new ones prefixed by >>)
> > 
> > >> kernel/trace/trace_functions.c:79:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_functions.c:79:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_functions.c:79:16:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_functions.c:110:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_functions.c:110:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_functions.c:110:16:    got struct trace_array_cpu *<noident>
> 
> I'm confused to exactly what sparse is complaining about?
> 
> It's barfing on every instance of my code that references a dynamically
> allocated 'per_cpu' instance. Did I do that wrong?
> 
> Hmm, actually it seems to be complaining everywhere but in trace.c which
> is where the per_cpu was allocated. Do I need to annotate the trace.h
> header to specify (at least to sparse) that the pointer is allocated per
> cpu?
> 
> -- Steve
> 
> 
> > --
> >    kernel/trace/trace_functions_graph.c:187:15: sparse: symbol 'ftrace_return_to_handler' was not declared. Should it be static?
> > >> kernel/trace/trace_functions_graph.c:268:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_functions_graph.c:268:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_functions_graph.c:268:16:    got struct trace_array_cpu *<noident>
> >    kernel/trace/trace_functions_graph.c:283:5: sparse: symbol 'trace_graph_thresh_entry' was not declared. Should it be static?
> > >> kernel/trace/trace_functions_graph.c:353:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_functions_graph.c:353:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_functions_graph.c:353:16:    got struct trace_array_cpu *<noident>
> >    kernel/trace/trace_functions_graph.c:372:6: sparse: symbol 'trace_graph_thresh_return' was not declared. Should it be static?
> >    kernel/trace/trace_functions_graph.c:1358:6: sparse: symbol 'print_graph_headers' was not declared. Should it be static?
> > --
> >    kernel/trace/trace_irqsoff.c:24:8: sparse: symbol 'tracing_cpu' was not declared. Should it be static?
> > >> kernel/trace/trace_irqsoff.c:124:17: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_irqsoff.c:124:17:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_irqsoff.c:124:17:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_irqsoff.c:383:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_irqsoff.c:383:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_irqsoff.c:383:16:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_irqsoff.c:421:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_irqsoff.c:421:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_irqsoff.c:421:16:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_irqsoff.c:421:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_irqsoff.c:421:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_irqsoff.c:421:16:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_irqsoff.c:383:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_irqsoff.c:383:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_irqsoff.c:383:16:    got struct trace_array_cpu *<noident>
> > --
> > >> kernel/trace/trace_kdb.c:29:29: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_kdb.c:29:29:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_kdb.c:29:29:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_kdb.c:86:29: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_kdb.c:86:29:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_kdb.c:86:29:    got struct trace_array_cpu *<noident>
> > --
> > >> kernel/trace/trace_mmiotrace.c:333:40: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_mmiotrace.c:333:40:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_mmiotrace.c:333:40:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_mmiotrace.c:366:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_mmiotrace.c:366:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_mmiotrace.c:366:16:    got struct trace_array_cpu *<noident>
> > --
> > >> kernel/trace/trace_sched_switch.c:72:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_sched_switch.c:72:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_sched_switch.c:72:16:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_sched_switch.c:126:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_sched_switch.c:126:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_sched_switch.c:126:16:    got struct trace_array_cpu *<noident>
> > --
> > >> kernel/trace/trace_sched_wakeup.c:92:17: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_sched_wakeup.c:92:17:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_sched_wakeup.c:92:17:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_sched_wakeup.c:356:20: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_sched_wakeup.c:356:20:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_sched_wakeup.c:356:20:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_sched_wakeup.c:368:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_sched_wakeup.c:368:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_sched_wakeup.c:368:16:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_sched_wakeup.c:390:21: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_sched_wakeup.c:390:21:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_sched_wakeup.c:390:21:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_sched_wakeup.c:438:20: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_sched_wakeup.c:438:20:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_sched_wakeup.c:438:20:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_sched_wakeup.c:461:16: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_sched_wakeup.c:461:16:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_sched_wakeup.c:461:16:    got struct trace_array_cpu *<noident>
> > >> kernel/trace/trace_sched_wakeup.c:475:21: sparse: incorrect type in initializer (different address spaces)
> >    kernel/trace/trace_sched_wakeup.c:475:21:    expected void const [noderef] <asn:3>*__vpp_verify
> >    kernel/trace/trace_sched_wakeup.c:475:21:    got struct trace_array_cpu *<noident>
> > 
> > vim +79 kernel/trace/trace_functions.c
> > 
> >     73	
> >     74		bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> >     75		if (bit < 0)
> >     76			goto out;
> >     77	
> >     78		cpu = smp_processor_id();
> >   > 79		data = per_cpu_ptr(tr->data, cpu);
> >     80		if (!atomic_read(&data->disabled)) {
> >     81			local_save_flags(flags);
> >     82			trace_function(tr, ip, parent_ip, flags, pc);
> >     83		}
> >     84		trace_clear_recursion(bit);
> >     85	
> >     86	 out:
> >     87		preempt_enable_notrace();
> >     88	}
> >     89	
> >     90	static void
> >     91	function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
> >     92				  struct ftrace_ops *op, struct pt_regs *pt_regs)
> >     93	{
> >     94		struct trace_array *tr = func_trace;
> >     95		struct trace_array_cpu *data;
> >     96		unsigned long flags;
> >     97		long disabled;
> >     98		int cpu;
> >     99		int pc;
> >    100	
> >    101		if (unlikely(!ftrace_function_enabled))
> >    102			return;
> >    103	
> >    104		/*
> >    105		 * Need to use raw, since this must be called before the
> >    106		 * recursive protection is performed.
> >    107		 */
> >    108		local_irq_save(flags);
> >    109		cpu = raw_smp_processor_id();
> >  > 110		data = per_cpu_ptr(tr->data, cpu);
> >    111		disabled = atomic_inc_return(&data->disabled);
> >    112	
> >    113		if (likely(disabled == 1)) {
> > 
> > ---
> > 0-DAY kernel build testing backend              Open Source Technology Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> 
