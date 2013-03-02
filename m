Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3CBNM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:12:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29567 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3CBNMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:12:54 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5BHuyXGbWtAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lh4F20eZPa0A:10 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8 a=ht5wYcPVL0dB-KKA__QA:9 a=PUjeQqilurYA:10 a=a9KbZ5m3lz2QKupf:21 a=elth4ZflDEtXABFI:21 a=b4w4DIHMpfxiJz4D:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362229972.31874.7.camel@gandalf.local.home>
Subject: Re: [trace:tip/perf/core 5/15]
 kernel/trace/trace_functions.c:79:16: sparse: incorrect type in initializer
 (different address spaces)
From: Steven Rostedt <rostedt@goodmis.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sat, 02 Mar 2013 08:12:52 -0500
In-Reply-To: <5131ad43.H709l5IR4X+pbvbq%fengguang.wu@intel.com>
References: <5131ad43.H709l5IR4X+pbvbq%fengguang.wu@intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 15:41 +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git tip/perf/core
> head:   f44f8638e47c89fa5c612a18f324ba6222b69597
> commit: 50b85fe13be0878f13eecd36d1219828ba73316d [5/15] tracing: Replace the static global per_cpu arrays with allocated per_cpu
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
> >> kernel/trace/trace_functions.c:79:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_functions.c:79:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_functions.c:79:16:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_functions.c:110:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_functions.c:110:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_functions.c:110:16:    got struct trace_array_cpu *<noident>

I'm confused to exactly what sparse is complaining about?

It's barfing on every instance of my code that references a dynamically
allocated 'per_cpu' instance. Did I do that wrong?

Hmm, actually it seems to be complaining everywhere but in trace.c which
is where the per_cpu was allocated. Do I need to annotate the trace.h
header to specify (at least to sparse) that the pointer is allocated per
cpu?

-- Steve


> --
>    kernel/trace/trace_functions_graph.c:187:15: sparse: symbol 'ftrace_return_to_handler' was not declared. Should it be static?
> >> kernel/trace/trace_functions_graph.c:268:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_functions_graph.c:268:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_functions_graph.c:268:16:    got struct trace_array_cpu *<noident>
>    kernel/trace/trace_functions_graph.c:283:5: sparse: symbol 'trace_graph_thresh_entry' was not declared. Should it be static?
> >> kernel/trace/trace_functions_graph.c:353:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_functions_graph.c:353:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_functions_graph.c:353:16:    got struct trace_array_cpu *<noident>
>    kernel/trace/trace_functions_graph.c:372:6: sparse: symbol 'trace_graph_thresh_return' was not declared. Should it be static?
>    kernel/trace/trace_functions_graph.c:1358:6: sparse: symbol 'print_graph_headers' was not declared. Should it be static?
> --
>    kernel/trace/trace_irqsoff.c:24:8: sparse: symbol 'tracing_cpu' was not declared. Should it be static?
> >> kernel/trace/trace_irqsoff.c:124:17: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_irqsoff.c:124:17:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_irqsoff.c:124:17:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_irqsoff.c:383:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_irqsoff.c:383:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_irqsoff.c:383:16:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_irqsoff.c:421:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_irqsoff.c:421:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_irqsoff.c:421:16:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_irqsoff.c:421:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_irqsoff.c:421:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_irqsoff.c:421:16:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_irqsoff.c:383:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_irqsoff.c:383:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_irqsoff.c:383:16:    got struct trace_array_cpu *<noident>
> --
> >> kernel/trace/trace_kdb.c:29:29: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_kdb.c:29:29:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_kdb.c:29:29:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_kdb.c:86:29: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_kdb.c:86:29:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_kdb.c:86:29:    got struct trace_array_cpu *<noident>
> --
> >> kernel/trace/trace_mmiotrace.c:333:40: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_mmiotrace.c:333:40:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_mmiotrace.c:333:40:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_mmiotrace.c:366:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_mmiotrace.c:366:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_mmiotrace.c:366:16:    got struct trace_array_cpu *<noident>
> --
> >> kernel/trace/trace_sched_switch.c:72:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_sched_switch.c:72:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_sched_switch.c:72:16:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_sched_switch.c:126:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_sched_switch.c:126:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_sched_switch.c:126:16:    got struct trace_array_cpu *<noident>
> --
> >> kernel/trace/trace_sched_wakeup.c:92:17: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_sched_wakeup.c:92:17:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_sched_wakeup.c:92:17:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_sched_wakeup.c:356:20: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_sched_wakeup.c:356:20:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_sched_wakeup.c:356:20:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_sched_wakeup.c:368:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_sched_wakeup.c:368:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_sched_wakeup.c:368:16:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_sched_wakeup.c:390:21: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_sched_wakeup.c:390:21:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_sched_wakeup.c:390:21:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_sched_wakeup.c:438:20: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_sched_wakeup.c:438:20:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_sched_wakeup.c:438:20:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_sched_wakeup.c:461:16: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_sched_wakeup.c:461:16:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_sched_wakeup.c:461:16:    got struct trace_array_cpu *<noident>
> >> kernel/trace/trace_sched_wakeup.c:475:21: sparse: incorrect type in initializer (different address spaces)
>    kernel/trace/trace_sched_wakeup.c:475:21:    expected void const [noderef] <asn:3>*__vpp_verify
>    kernel/trace/trace_sched_wakeup.c:475:21:    got struct trace_array_cpu *<noident>
> 
> vim +79 kernel/trace/trace_functions.c
> 
>     73	
>     74		bit = trace_test_and_set_recursion(TRACE_FTRACE_START, TRACE_FTRACE_MAX);
>     75		if (bit < 0)
>     76			goto out;
>     77	
>     78		cpu = smp_processor_id();
>   > 79		data = per_cpu_ptr(tr->data, cpu);
>     80		if (!atomic_read(&data->disabled)) {
>     81			local_save_flags(flags);
>     82			trace_function(tr, ip, parent_ip, flags, pc);
>     83		}
>     84		trace_clear_recursion(bit);
>     85	
>     86	 out:
>     87		preempt_enable_notrace();
>     88	}
>     89	
>     90	static void
>     91	function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
>     92				  struct ftrace_ops *op, struct pt_regs *pt_regs)
>     93	{
>     94		struct trace_array *tr = func_trace;
>     95		struct trace_array_cpu *data;
>     96		unsigned long flags;
>     97		long disabled;
>     98		int cpu;
>     99		int pc;
>    100	
>    101		if (unlikely(!ftrace_function_enabled))
>    102			return;
>    103	
>    104		/*
>    105		 * Need to use raw, since this must be called before the
>    106		 * recursive protection is performed.
>    107		 */
>    108		local_irq_save(flags);
>    109		cpu = raw_smp_processor_id();
>  > 110		data = per_cpu_ptr(tr->data, cpu);
>    111		disabled = atomic_inc_return(&data->disabled);
>    112	
>    113		if (likely(disabled == 1)) {
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation


