Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3C1M6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:58:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab3C1M60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:58:26 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XGMjaeuumeYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=8Vi8ztNION4A:10 a=VwQbUJbxAAAA:8 a=IdUD1D9K-fXo6wDmkFEA:9 a=QEXdDO2ut3YA:10 a=Sf_gFPzhefAA:10 a=-0qkl0XTG-IA:10 a=OEzDJgjNXGrKBa13:21 a=OYeNey5XaOzDiQsq:21 a=BRxEmHNTAZfNM4cS:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1364475498.6345.223.camel@gandalf.local.home>
Subject: Re: [GIT PULL] tracing: multibuffers, new triggers, clocks, and more
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Keun-O Park <kpark3469@gmail.com>,
        David Sharp <dhsharp@google.com>
Date: Thu, 28 Mar 2013 08:58:18 -0400
In-Reply-To: <1363987836.6345.144.camel@gandalf.local.home>
References: <1363987836.6345.144.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

-- Steve


On Fri, 2013-03-22 at 17:30 -0400, Steven Rostedt wrote:
> Ingo,
> 
> A lot has changed and this has been in linux-next for a while. Instead
> of spamming LKML with a large patch set, as all changes have already
> been posted to LKML, I'm posting this as one big patch of all the
> changes involved. Here's the summary:
> 
> The biggest change was the addition of multiple tracing buffers and a
> new directory called "instances". Doing a mkdir here creates a new
> tracing directory that has its own buffers. Only trace events can be
> enabled and currently no tracers can (that's for 3.11 ;-). But its fully
> functional. It also includes the ability of snapshots and per cpu
> referencing, and buffer management.
> 
> Use of slabs have brought the memory footprint down a little.
> 
> The tracing files now block as they should and described in the read(2)
> man pages.
> 
> The max_tr has been replaced by the trace_array holding two buffer
> pointers that can now swap. This allows the multiple buffers to also
> take advantage of snapshots.
> 
> Added allocation of the snapshot buffer in the kernel command line.
> 
> Added trace_puts() and special macro magic to trace_printk() to use it
> when it has no arguments to the format string. This makes trace_printk()
> have an even smaller footprint to recording what is happening.
> 
> Added new function triggers, where the function tracer hits a specified
> function, it can enable/disable an event, cause a snapshot, or
> stacktrace.
> 
> Added new trace clocks: uptime and perf
> 
> Added new ring buffer self test, to make sure it doesn't lose any events
> (it never did, but something else caused events to be lost and I thought
> it was the ring buffer).
> 
> Updated some much needed documentation.
> 
> -- Steve
> 
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: 22f45649ce08642ad7df238d5c25fa5c86bfdd31
> 
> 
> Li Zefan (4):
>       tracing: Add a helper function for event print functions
>       tracing: Annotate event field-defining functions with __init
>       tracing/syscalls: Annotate field-defining functions with __init
>       tracing: Fix some section mismatch warnings
> 
> Steven Rostedt (13):
>       tracing: Separate out trace events from global variables
>       tracing: Use RING_BUFFER_ALL_CPUS for TRACE_PIPE_ALL_CPU
>       tracing: Encapsulate global_trace and remove dependencies on global vars
>       tracing: Pass the ftrace_file to the buffer lock reserve code
>       tracing: Replace the static global per_cpu arrays with allocated per_cpu
>       tracing: Make syscall events suitable for multiple buffers
>       tracing: Add interface to allow multiple trace buffers
>       tracing: Add rmdir to remove multibuffer instances
>       tracing: Get trace_events kernel command line working again
>       tracing: Use kmem_cache_alloc instead of kmalloc in trace_events.c
>       tracing: Use direct field, type and system names
>       tracing: Fix polling on trace_pipe_raw
>       tracing: Fix read blocking on trace_pipe_raw
> 
> Steven Rostedt (Red Hat) (50):
>       tracing: Do not block on splice if either file or splice NONBLOCK flag is set
>       tracing/ring-buffer: Move poll wake ups into ring buffer code
>       tracing: Add __per_cpu annotation to trace array percpu data pointer
>       tracing: Fix trace events build without modules
>       ring-buffer: Init waitqueue for blocked readers
>       tracing: Add comment for trace event flag IGNORE_ENABLE
>       tracing: Only clear trace buffer on module unload if event was traced
>       tracing: Clear all trace buffers when unloaded module event was used
>       tracing: Enable snapshot when any latency tracer is enabled
>       tracing: Consolidate max_tr into main trace_array structure
>       tracing: Add snapshot in the per_cpu trace directories
>       tracing: Add config option to allow snapshot to swap per cpu
>       tracing: Add snapshot_raw to extract the raw data from snapshot
>       tracing: Have trace_array keep track if snapshot buffer is allocated
>       tracing: Consolidate buffer allocation code
>       tracing: Add snapshot feature to instances
>       tracing: Add per_cpu directory into tracing instances
>       tracing: Prevent deleting instances when they are being read
>       tracing: Add internal tracing_snapshot() functions
>       ring-buffer: Do not use schedule_work_on() for current CPU
>       tracing: Move the tracing selftest code into its own function
>       tracing: Add alloc_snapshot kernel command line parameter
>       tracing: Fix the branch tracer that broke with buffer change
>       tracing: Add trace_puts() for even faster trace_printk() tracing
>       tracing: Optimize trace_printk() with one arg to use trace_puts()
>       tracing: Add internal ftrace trace_puts() for ftrace to use
>       tracing: Let tracing_snapshot() be used by modules but not NMI
>       tracing: Consolidate updating of count for traceon/off
>       tracing: Consolidate ftrace_trace_onoff_unreg() into callback
>       ftrace: Separate unlimited probes from count limited probes
>       ftrace: Fix function probe to only enable needed functions
>       tracing: Add alloc/free_snapshot() to replace duplicate code
>       tracing: Add snapshot trigger to function probes
>       tracing: Fix comments for ftrace_event_file/call flags
>       ftrace: Clean up function probe methods
>       ftrace: Use manual free after synchronize_sched() not call_rcu_sched()
>       tracing: Add a way to soft disable trace events
>       tracing: Add function probe triggers to enable/disable events
>       tracing: Add skip argument to trace_dump_stack()
>       tracing: Add function probe to trigger stack traces
>       tracing: Use stack of calling function for stack tracer
>       tracing: Fix stack tracer with fentry use
>       tracing: Remove most or all of stack tracer stack size from stack_max_size
>       tracing: Add function-trace option to disable function tracing of latency tracers
>       tracing: Add "uptime" trace clock that uses jiffies
>       tracing: Add "perf" trace_clock
>       tracing: Bring Documentation/trace/ftrace.txt up to date
>       ring-buffer: Add ring buffer startup selftest
>       tracing: Fix ftrace_dump()
>       tracing: Update debugfs README file
> 
> zhangwei(Jovi) (6):
>       tracing: Use pr_warn_once instead of open coded implementation
>       tracing: Use TRACE_MAX_PRINT instead of constant
>       tracing: Move find_event_field() into trace_events.c
>       tracing: Convert trace_destroy_fields() to static
>       tracing: Fix comment about prefix in arch_syscall_match_sym_name()
>       tracing: Rename trace_event_mutex to trace_event_sem
> 
> ----
>  Documentation/kernel-parameters.txt  |    7 +
>  Documentation/trace/ftrace.txt       | 2097 ++++++++++++++++++++++----------
>  include/linux/ftrace.h               |    6 +-
>  include/linux/ftrace_event.h         |  109 +-
>  include/linux/kernel.h               |   70 +-
>  include/linux/ring_buffer.h          |    6 +
>  include/linux/trace_clock.h          |    1 +
>  include/trace/ftrace.h               |   47 +-
>  kernel/trace/Kconfig                 |   49 +
>  kernel/trace/blktrace.c              |    4 +-
>  kernel/trace/ftrace.c                |   73 +-
>  kernel/trace/ring_buffer.c           |  500 +++++++-
>  kernel/trace/trace.c                 | 2204 ++++++++++++++++++++++++----------
>  kernel/trace/trace.h                 |  144 ++-
>  kernel/trace/trace_branch.c          |    8 +-
>  kernel/trace/trace_clock.c           |   10 +
>  kernel/trace/trace_entries.h         |   23 +-
>  kernel/trace/trace_events.c          | 1421 +++++++++++++++++-----
>  kernel/trace/trace_events_filter.c   |   34 +-
>  kernel/trace/trace_export.c          |    4 +-
>  kernel/trace/trace_functions.c       |  207 +++-
>  kernel/trace/trace_functions_graph.c |   12 +-
>  kernel/trace/trace_irqsoff.c         |   85 +-
>  kernel/trace/trace_kdb.c             |   12 +-
>  kernel/trace/trace_mmiotrace.c       |   12 +-
>  kernel/trace/trace_output.c          |  119 +-
>  kernel/trace/trace_output.h          |    4 +-
>  kernel/trace/trace_sched_switch.c    |    8 +-
>  kernel/trace/trace_sched_wakeup.c    |   87 +-
>  kernel/trace/trace_selftest.c        |   51 +-
>  kernel/trace/trace_stack.c           |   74 +-
>  kernel/trace/trace_syscalls.c        |   90 +-
>  32 files changed, 5672 insertions(+), 1906 deletions(-)
> ---------------------------
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 6c72381..0edc409 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -320,6 +320,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			on: enable for both 32- and 64-bit processes
>  			off: disable for both 32- and 64-bit processes
>  
> +	alloc_snapshot	[FTRACE]
> +			Allocate the ftrace snapshot buffer on boot up when the
> +			main buffer is allocated. This is handy if debugging
> +			and you need to use tracing_snapshot() on boot up, and
> +			do not want to use tracing_snapshot_alloc() as it needs
> +			to be done where GFP_KERNEL allocations are allowed.
> +
>  	amd_iommu=	[HW,X86-64]
>  			Pass parameters to the AMD IOMMU driver in the system.
>  			Possible values are:
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index a372304..bfe8c29 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -8,6 +8,7 @@ Copyright 2008 Red Hat Inc.
>  Reviewers:   Elias Oltmanns, Randy Dunlap, Andrew Morton,
>  	     John Kacur, and David Teigland.
>  Written for: 2.6.28-rc2
> +Updated for: 3.10
>  
>  Introduction
>  ------------
> @@ -17,13 +18,16 @@ designers of systems to find what is going on inside the kernel.
>  It can be used for debugging or analyzing latencies and
>  performance issues that take place outside of user-space.
>  
> -Although ftrace is the function tracer, it also includes an
> -infrastructure that allows for other types of tracing. Some of
> -the tracers that are currently in ftrace include a tracer to
> -trace context switches, the time it takes for a high priority
> -task to run after it was woken up, the time interrupts are
> -disabled, and more (ftrace allows for tracer plugins, which
> -means that the list of tracers can always grow).
> +Although ftrace is typically considered the function tracer, it
> +is really a frame work of several assorted tracing utilities.
> +There's latency tracing to examine what occurs between interrupts
> +disabled and enabled, as well as for preemption and from a time
> +a task is woken to the task is actually scheduled in.
> +
> +One of the most common uses of ftrace is the event tracing.
> +Through out the kernel is hundreds of static event points that
> +can be enabled via the debugfs file system to see what is
> +going on in certain parts of the kernel.
>  
> 
>  Implementation Details
> @@ -61,7 +65,7 @@ the extended "/sys/kernel/debug/tracing" path name.
>  
>  That's it! (assuming that you have ftrace configured into your kernel)
>  
> -After mounting the debugfs, you can see a directory called
> +After mounting debugfs, you can see a directory called
>  "tracing".  This directory contains the control and output files
>  of ftrace. Here is a list of some of the key files:
>  
> @@ -84,7 +88,9 @@ of ftrace. Here is a list of some of the key files:
>  
>  	This sets or displays whether writing to the trace
>  	ring buffer is enabled. Echo 0 into this file to disable
> -	the tracer or 1 to enable it.
> +	the tracer or 1 to enable it. Note, this only disables
> +	writing to the ring buffer, the tracing overhead may
> +	still be occurring.
>  
>    trace:
>  
> @@ -109,7 +115,15 @@ of ftrace. Here is a list of some of the key files:
>  
>  	This file lets the user control the amount of data
>  	that is displayed in one of the above output
> -	files.
> +	files. Options also exist to modify how a tracer
> +	or events work (stack traces, timestamps, etc).
> +
> +  options:
> +
> +	This is a directory that has a file for every available
> +	trace option (also in trace_options). Options may also be set
> +	or cleared by writing a "1" or "0" respectively into the
> +	corresponding file with the option name.
>  
>    tracing_max_latency:
>  
> @@ -121,10 +135,17 @@ of ftrace. Here is a list of some of the key files:
>  	latency is greater than the value in this
>  	file. (in microseconds)
>  
> +  tracing_thresh:
> +
> +	Some latency tracers will record a trace whenever the
> +	latency is greater than the number in this file.
> +	Only active when the file contains a number greater than 0.
> +	(in microseconds)
> +
>    buffer_size_kb:
>  
>  	This sets or displays the number of kilobytes each CPU
> -	buffer can hold. The tracer buffers are the same size
> +	buffer holds. By default, the trace buffers are the same size
>  	for each CPU. The displayed number is the size of the
>  	CPU buffer and not total size of all buffers. The
>  	trace buffers are allocated in pages (blocks of memory
> @@ -133,16 +154,30 @@ of ftrace. Here is a list of some of the key files:
>  	than requested, the rest of the page will be used,
>  	making the actual allocation bigger than requested.
>  	( Note, the size may not be a multiple of the page size
> -	  due to buffer management overhead. )
> +	  due to buffer management meta-data. )
>  
> -	This can only be updated when the current_tracer
> -	is set to "nop".
> +  buffer_total_size_kb:
> +
> +	This displays the total combined size of all the trace buffers.
> +
> +  free_buffer:
> +
> +	If a process is performing the tracing, and the ring buffer
> +	should be shrunk "freed" when the process is finished, even
> +	if it were to be killed by a signal, this file can be used
> +	for that purpose. On close of this file, the ring buffer will
> +	be resized to its minimum size. Having a process that is tracing
> +	also open this file, when the process exits its file descriptor
> +	for this file will be closed, and in doing so, the ring buffer
> +	will be "freed".
> +
> +	It may also stop tracing if disable_on_free option is set.
>  
>    tracing_cpumask:
>  
>  	This is a mask that lets the user only trace
> -	on specified CPUS. The format is a hex string
> -	representing the CPUS.
> +	on specified CPUs. The format is a hex string
> +	representing the CPUs.
>  
>    set_ftrace_filter:
>  
> @@ -183,6 +218,261 @@ of ftrace. Here is a list of some of the key files:
>  	"set_ftrace_notrace". (See the section "dynamic ftrace"
>  	below for more details.)
>  
> +  enabled_functions:
> +
> +	This file is more for debugging ftrace, but can also be useful
> +	in seeing if any function has a callback attached to it.
> +	Not only does the trace infrastructure use ftrace function
> +	trace utility, but other subsystems might too. This file
> +	displays all functions that have a callback attached to them
> +	as well as the number of callbacks that have been attached.
> +	Note, a callback may also call multiple functions which will
> +	not be listed in this count.
> +
> +	If the callback registered to be traced by a function with
> +	the "save regs" attribute (thus even more overhead), a 'R'
> +	will be displayed on the same line as the function that
> +	is returning registers.
> +
> +  function_profile_enabled:
> +
> +	When set it will enable all functions with either the function
> +	tracer, or if enabled, the function graph tracer. It will
> +	keep a histogram of the number of functions that were called
> +	and if run with the function graph tracer, it will also keep
> +	track of the time spent in those functions. The histogram
> +	content can be displayed in the files:
> +
> +	trace_stats/function<cpu> ( function0, function1, etc).
> +
> +  trace_stats:
> +
> +	A directory that holds different tracing stats.
> +
> +  kprobe_events:
> + 
> +	Enable dynamic trace points. See kprobetrace.txt.
> +
> +  kprobe_profile:
> +
> +	Dynamic trace points stats. See kprobetrace.txt.
> +
> +  max_graph_depth:
> +
> +	Used with the function graph tracer. This is the max depth
> +	it will trace into a function. Setting this to a value of
> +	one will show only the first kernel function that is called
> +	from user space.
> +
> +  printk_formats:
> +
> +	This is for tools that read the raw format files. If an event in
> +	the ring buffer references a string (currently only trace_printk()
> +	does this), only a pointer to the string is recorded into the buffer
> +	and not the string itself. This prevents tools from knowing what
> +	that string was. This file displays the string and address for
> +	the string allowing tools to map the pointers to what the
> +	strings were.
> +
> +  saved_cmdlines:
> +
> +	Only the pid of the task is recorded in a trace event unless
> +	the event specifically saves the task comm as well. Ftrace
> +	makes a cache of pid mappings to comms to try to display
> +	comms for events. If a pid for a comm is not listed, then
> +	"<...>" is displayed in the output.
> +
> +  snapshot:
> +
> +	This displays the "snapshot" buffer and also lets the user
> +	take a snapshot of the current running trace.
> +	See the "Snapshot" section below for more details.
> +
> +  stack_max_size:
> +
> +	When the stack tracer is activated, this will display the
> +	maximum stack size it has encountered.
> +	See the "Stack Trace" section below.
> +
> +  stack_trace:
> +
> +	This displays the stack back trace of the largest stack
> +	that was encountered when the stack tracer is activated.
> +	See the "Stack Trace" section below.
> +
> +  stack_trace_filter:
> +
> +	This is similar to "set_ftrace_filter" but it limits what
> +	functions the stack tracer will check.
> +
> +  trace_clock:
> +
> +	Whenever an event is recorded into the ring buffer, a
> +	"timestamp" is added. This stamp comes from a specified
> +	clock. By default, ftrace uses the "local" clock. This
> +	clock is very fast and strictly per cpu, but on some
> +	systems it may not be monotonic with respect to other
> +	CPUs. In other words, the local clocks may not be in sync
> +	with local clocks on other CPUs.
> +
> +	Usual clocks for tracing:
> +
> +	  # cat trace_clock
> +	  [local] global counter x86-tsc
> +
> +	  local: Default clock, but may not be in sync across CPUs
> +
> +	  global: This clock is in sync with all CPUs but may
> +	  	  be a bit slower than the local clock.
> +
> +	  counter: This is not a clock at all, but literally an atomic
> +	  	   counter. It counts up one by one, but is in sync
> +		   with all CPUs. This is useful when you need to
> +		   know exactly the order events occurred with respect to
> +		   each other on different CPUs.
> +
> +	  uptime: This uses the jiffies counter and the time stamp
> +	  	  is relative to the time since boot up.
> +
> +	  perf: This makes ftrace use the same clock that perf uses.
> +	  	Eventually perf will be able to read ftrace buffers
> +		and this will help out in interleaving the data.
> +
> +	  x86-tsc: Architectures may define their own clocks. For
> +	  	   example, x86 uses its own TSC cycle clock here.
> +
> +	To set a clock, simply echo the clock name into this file.
> +
> +	  echo global > trace_clock
> +
> +  trace_marker:
> +
> +	This is a very useful file for synchronizing user space
> +	with events happening in the kernel. Writing strings into
> +	this file will be written into the ftrace buffer.
> +
> +	It is useful in applications to open this file at the start
> +	of the application and just reference the file descriptor
> +	for the file.
> +
> +	void trace_write(const char *fmt, ...)
> +	{
> +		va_list ap;
> +		char buf[256];
> +		int n;
> +
> +		if (trace_fd < 0)
> +			return;
> +
> +		va_start(ap, fmt);
> +		n = vsnprintf(buf, 256, fmt, ap);
> +		va_end(ap);
> +
> +		write(trace_fd, buf, n);
> +	}
> +
> +	start:
> +
> +		trace_fd = open("trace_marker", WR_ONLY);
> +
> +  uprobe_events:
> + 
> +	Add dynamic tracepoints in programs.
> +	See uprobetracer.txt
> +
> +  uprobe_profile:
> +
> +	Uprobe statistics. See uprobetrace.txt
> +
> +  instances:
> +
> +	This is a way to make multiple trace buffers where different
> +	events can be recorded in different buffers.
> +	See "Instances" section below.
> +
> +  events:
> +
> +	This is the trace event directory. It holds event tracepoints
> +	(also known as static tracepoints) that have been compiled
> +	into the kernel. It shows what event tracepoints exist
> +	and how they are grouped by system. There are "enable"
> +	files at various levels that can enable the tracepoints
> +	when a "1" is written to them.
> +
> +	See events.txt for more information.
> +
> +  per_cpu:
> +
> +	This is a directory that contains the trace per_cpu information.
> +
> +  per_cpu/cpu0/buffer_size_kb:
> +
> +	The ftrace buffer is defined per_cpu. That is, there's a separate
> +	buffer for each CPU to allow writes to be done atomically,
> +	and free from cache bouncing. These buffers may have different
> +	size buffers. This file is similar to the buffer_size_kb
> +	file, but it only displays or sets the buffer size for the
> +	specific CPU. (here cpu0).
> +
> +  per_cpu/cpu0/trace:
> +
> +	This is similar to the "trace" file, but it will only display
> +	the data specific for the CPU. If written to, it only clears
> +	the specific CPU buffer.
> +
> +  per_cpu/cpu0/trace_pipe
> +
> +	This is similar to the "trace_pipe" file, and is a consuming
> +	read, but it will only display (and consume) the data specific
> +	for the CPU.
> +
> +  per_cpu/cpu0/trace_pipe_raw
> +
> +	For tools that can parse the ftrace ring buffer binary format,
> +	the trace_pipe_raw file can be used to extract the data
> +	from the ring buffer directly. With the use of the splice()
> +	system call, the buffer data can be quickly transferred to
> +	a file or to the network where a server is collecting the
> +	data.
> +
> +	Like trace_pipe, this is a consuming reader, where multiple
> +	reads will always produce different data.
> +
> +  per_cpu/cpu0/snapshot:
> +
> +	This is similar to the main "snapshot" file, but will only
> +	snapshot the current CPU (if supported). It only displays
> +	the content of the snapshot for a given CPU, and if
> +	written to, only clears this CPU buffer.
> +
> +  per_cpu/cpu0/snapshot_raw:
> +
> +	Similar to the trace_pipe_raw, but will read the binary format
> +	from the snapshot buffer for the given CPU.
> +
> +  per_cpu/cpu0/stats:
> +
> +	This displays certain stats about the ring buffer:
> +
> +	 entries: The number of events that are still in the buffer.
> +
> +	 overrun: The number of lost events due to overwriting when
> +	 	  the buffer was full.
> +
> +	 commit overrun: Should always be zero.
> +	 	This gets set if so many events happened within a nested
> +		event (ring buffer is re-entrant), that it fills the
> +		buffer and starts dropping events.
> +
> +	 bytes: Bytes actually read (not overwritten).
> +
> +	 oldest event ts: The oldest timestamp in the buffer
> +
> +	 now ts: The current timestamp
> +
> +	 dropped events: Events lost due to overwrite option being off.
> +
> +	 read events: The number of events read.
>  
>  The Tracers
>  -----------
> @@ -234,11 +524,6 @@ Here is the list of current tracers that may be configured.
>          RT tasks (as the current "wakeup" does). This is useful
>          for those interested in wake up timings of RT tasks.
>  
> -  "hw-branch-tracer"
> -
> -	Uses the BTS CPU feature on x86 CPUs to traces all
> -	branches executed.
> -
>    "nop"
>  
>  	This is the "trace nothing" tracer. To remove all
> @@ -261,70 +546,100 @@ Here is an example of the output format of the file "trace"
>                               --------
>  # tracer: function
>  #
> -#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> -#              | |      |          |         |
> -            bash-4251  [01] 10152.583854: path_put <-path_walk
> -            bash-4251  [01] 10152.583855: dput <-path_put
> -            bash-4251  [01] 10152.583855: _atomic_dec_and_lock <-dput
> +# entries-in-buffer/entries-written: 140080/250280   #P:4
> +#
> +#                              _-----=> irqs-off
> +#                             / _----=> need-resched
> +#                            | / _---=> hardirq/softirq
> +#                            || / _--=> preempt-depth
> +#                            ||| /     delay
> +#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> +#              | |       |   ||||       |         |
> +            bash-1977  [000] .... 17284.993652: sys_close <-system_call_fastpath
> +            bash-1977  [000] .... 17284.993653: __close_fd <-sys_close
> +            bash-1977  [000] .... 17284.993653: _raw_spin_lock <-__close_fd
> +            sshd-1974  [003] .... 17284.993653: __srcu_read_unlock <-fsnotify
> +            bash-1977  [000] .... 17284.993654: add_preempt_count <-_raw_spin_lock
> +            bash-1977  [000] ...1 17284.993655: _raw_spin_unlock <-__close_fd
> +            bash-1977  [000] ...1 17284.993656: sub_preempt_count <-_raw_spin_unlock
> +            bash-1977  [000] .... 17284.993657: filp_close <-__close_fd
> +            bash-1977  [000] .... 17284.993657: dnotify_flush <-filp_close
> +            sshd-1974  [003] .... 17284.993658: sys_select <-system_call_fastpath
>                               --------
>  
>  A header is printed with the tracer name that is represented by
> -the trace. In this case the tracer is "function". Then a header
> -showing the format. Task name "bash", the task PID "4251", the
> -CPU that it was running on "01", the timestamp in <secs>.<usecs>
> -format, the function name that was traced "path_put" and the
> -parent function that called this function "path_walk". The
> -timestamp is the time at which the function was entered.
> +the trace. In this case the tracer is "function". Then it shows the
> +number of events in the buffer as well as the total number of entries
> +that were written. The difference is the number of entries that were
> +lost due to the buffer filling up (250280 - 140080 = 110200 events
> +lost).
> +
> +The header explains the content of the events. Task name "bash", the task
> +PID "1977", the CPU that it was running on "000", the latency format
> +(explained below), the timestamp in <secs>.<usecs> format, the
> +function name that was traced "sys_close" and the parent function that
> +called this function "system_call_fastpath". The timestamp is the time
> +at which the function was entered.
>  
>  Latency trace format
>  --------------------
>  
> -When the latency-format option is enabled, the trace file gives
> -somewhat more information to see why a latency happened.
> -Here is a typical trace.
> +When the latency-format option is enabled or when one of the latency
> +tracers is set, the trace file gives somewhat more information to see
> +why a latency happened. Here is a typical trace.
>  
>  # tracer: irqsoff
>  #
> -irqsoff latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 97 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: swapper-0 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: apic_timer_interrupt
> - => ended at:   do_softirq
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -  <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interrupt)
> -  <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
> -  <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)
> +# irqsoff latency trace v1.1.5 on 3.8.0-test+
> +# --------------------------------------------------------------------
> +# latency: 259 us, #4/4, CPU#2 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> +#    -----------------
> +#    | task: ps-6143 (uid:0 nice:0 policy:0 rt_prio:0)
> +#    -----------------
> +#  => started at: __lock_task_sighand
> +#  => ended at:   _raw_spin_unlock_irqrestore
> +#
> +#
> +#                  _------=> CPU#            
> +#                 / _-----=> irqs-off        
> +#                | / _----=> need-resched    
> +#                || / _---=> hardirq/softirq 
> +#                ||| / _--=> preempt-depth   
> +#                |||| /     delay             
> +#  cmd     pid   ||||| time  |   caller      
> +#     \   /      |||||  \    |   /           
> +      ps-6143    2d...    0us!: trace_hardirqs_off <-__lock_task_sighand
> +      ps-6143    2d..1  259us+: trace_hardirqs_on <-_raw_spin_unlock_irqrestore
> +      ps-6143    2d..1  263us+: time_hardirqs_on <-_raw_spin_unlock_irqrestore
> +      ps-6143    2d..1  306us : <stack trace>
> + => trace_hardirqs_on_caller
> + => trace_hardirqs_on
> + => _raw_spin_unlock_irqrestore
> + => do_task_stat
> + => proc_tgid_stat
> + => proc_single_show
> + => seq_read
> + => vfs_read
> + => sys_read
> + => system_call_fastpath
>  
> 
>  This shows that the current tracer is "irqsoff" tracing the time
> -for which interrupts were disabled. It gives the trace version
> -and the version of the kernel upon which this was executed on
> -(2.6.26-rc8). Then it displays the max latency in microsecs (97
> -us). The number of trace entries displayed and the total number
> -recorded (both are three: #3/3). The type of preemption that was
> -used (PREEMPT). VP, KP, SP, and HP are always zero and are
> -reserved for later use. #P is the number of online CPUS (#P:2).
> +for which interrupts were disabled. It gives the trace version (which
> +never changes) and the version of the kernel upon which this was executed on
> +(3.10). Then it displays the max latency in microseconds (259 us). The number
> +of trace entries displayed and the total number (both are four: #4/4).
> +VP, KP, SP, and HP are always zero and are reserved for later use.
> +#P is the number of online CPUs (#P:4).
>  
>  The task is the process that was running when the latency
> -occurred. (swapper pid: 0).
> +occurred. (ps pid: 6143).
>  
>  The start and stop (the functions in which the interrupts were
>  disabled and enabled respectively) that caused the latencies:
>  
> -  apic_timer_interrupt is where the interrupts were disabled.
> -  do_softirq is where they were enabled again.
> + __lock_task_sighand is where the interrupts were disabled.
> + _raw_spin_unlock_irqrestore is where they were enabled again.
>  
>  The next lines after the header are the trace itself. The header
>  explains which is which.
> @@ -367,16 +682,43 @@ The above is mostly meaningful for kernel developers.
>  
>    The rest is the same as the 'trace' file.
>  
> +  Note, the latency tracers will usually end with a back trace
> +  to easily find where the latency occurred.
>  
>  trace_options
>  -------------
>  
> -The trace_options file is used to control what gets printed in
> -the trace output. To see what is available, simply cat the file:
> +The trace_options file (or the options directory) is used to control
> +what gets printed in the trace output, or manipulate the tracers.
> +To see what is available, simply cat the file:
>  
>    cat trace_options
> -  print-parent nosym-offset nosym-addr noverbose noraw nohex nobin \
> -  noblock nostacktrace nosched-tree nouserstacktrace nosym-userobj
> +print-parent
> +nosym-offset
> +nosym-addr
> +noverbose
> +noraw
> +nohex
> +nobin
> +noblock
> +nostacktrace
> +trace_printk
> +noftrace_preempt
> +nobranch
> +annotate
> +nouserstacktrace
> +nosym-userobj
> +noprintk-msg-only
> +context-info
> +latency-format
> +sleep-time
> +graph-time
> +record-cmd
> +overwrite
> +nodisable_on_free
> +irq-info
> +markers
> +function-trace
>  
>  To disable one of the options, echo in the option prepended with
>  "no".
> @@ -428,13 +770,34 @@ Here are the available options:
>  
>    bin - This will print out the formats in raw binary.
>  
> -  block - TBD (needs update)
> +  block - When set, reading trace_pipe will not block when polled.
>  
>    stacktrace - This is one of the options that changes the trace
>  	       itself. When a trace is recorded, so is the stack
>  	       of functions. This allows for back traces of
>  	       trace sites.
>  
> +  trace_printk - Can disable trace_printk() from writing into the buffer.
> +
> +  branch - Enable branch tracing with the tracer.
> +
> +  annotate - It is sometimes confusing when the CPU buffers are full
> +  	     and one CPU buffer had a lot of events recently, thus
> +	     a shorter time frame, were another CPU may have only had
> +	     a few events, which lets it have older events. When
> +	     the trace is reported, it shows the oldest events first,
> +	     and it may look like only one CPU ran (the one with the
> +	     oldest events). When the annotate option is set, it will
> +	     display when a new CPU buffer started:
> +
> +          <idle>-0     [001] dNs4 21169.031481: wake_up_idle_cpu <-add_timer_on
> +          <idle>-0     [001] dNs4 21169.031482: _raw_spin_unlock_irqrestore <-add_timer_on
> +          <idle>-0     [001] .Ns4 21169.031484: sub_preempt_count <-_raw_spin_unlock_irqrestore
> +##### CPU 2 buffer started ####
> +          <idle>-0     [002] .N.1 21169.031484: rcu_idle_exit <-cpu_idle
> +          <idle>-0     [001] .Ns3 21169.031484: _raw_spin_unlock <-clocksource_watchdog
> +          <idle>-0     [001] .Ns3 21169.031485: sub_preempt_count <-_raw_spin_unlock
> +
>    userstacktrace - This option changes the trace. It records a
>  		   stacktrace of the current userspace thread.
>  
> @@ -451,9 +814,13 @@ Here are the available options:
>  		a.out-1623  [000] 40874.465068: /root/a.out[+0x480] <-/root/a.out[+0
>  x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
>  
> -  sched-tree - trace all tasks that are on the runqueue, at
> -	       every scheduling event. Will add overhead if
> -	       there's a lot of tasks running at once.
> +
> +  printk-msg-only - When set, trace_printk()s will only show the format
> +  		    and not their parameters (if trace_bprintk() or
> +		    trace_bputs() was used to save the trace_printk()).
> +
> +  context-info - Show only the event data. Hides the comm, PID,
> +  	         timestamp, CPU, and other useful data.
>  
>    latency-format - This option changes the trace. When
>                     it is enabled, the trace displays
> @@ -461,31 +828,61 @@ x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
>                     latencies, as described in "Latency
>                     trace format".
>  
> +  sleep-time - When running function graph tracer, to include
> +  	       the time a task schedules out in its function.
> +	       When enabled, it will account time the task has been
> +	       scheduled out as part of the function call.
> +
> +  graph-time - When running function graph tracer, to include the
> +  	       time to call nested functions. When this is not set,
> +	       the time reported for the function will only include
> +	       the time the function itself executed for, not the time
> +	       for functions that it called.
> +
> +  record-cmd - When any event or tracer is enabled, a hook is enabled
> +  	       in the sched_switch trace point to fill comm cache
> +	       with mapped pids and comms. But this may cause some
> +	       overhead, and if you only care about pids, and not the
> +	       name of the task, disabling this option can lower the
> +	       impact of tracing.
> +
>    overwrite - This controls what happens when the trace buffer is
>                full. If "1" (default), the oldest events are
>                discarded and overwritten. If "0", then the newest
>                events are discarded.
> +	        (see per_cpu/cpu0/stats for overrun and dropped)
>  
> -ftrace_enabled
> ---------------
> +  disable_on_free - When the free_buffer is closed, tracing will
> +  		    stop (tracing_on set to 0).
>  
> -The following tracers (listed below) give different output
> -depending on whether or not the sysctl ftrace_enabled is set. To
> -set ftrace_enabled, one can either use the sysctl function or
> -set it via the proc file system interface.
> +  irq-info - Shows the interrupt, preempt count, need resched data.
> +  	     When disabled, the trace looks like:
>  
> -  sysctl kernel.ftrace_enabled=1
> +# tracer: function
> +#
> +# entries-in-buffer/entries-written: 144405/9452052   #P:4
> +#
> +#           TASK-PID   CPU#      TIMESTAMP  FUNCTION
> +#              | |       |          |         |
> +          <idle>-0     [002]  23636.756054: ttwu_do_activate.constprop.89 <-try_to_wake_up
> +          <idle>-0     [002]  23636.756054: activate_task <-ttwu_do_activate.constprop.89
> +          <idle>-0     [002]  23636.756055: enqueue_task <-activate_task
>  
> - or
>  
> -  echo 1 > /proc/sys/kernel/ftrace_enabled
> +  markers - When set, the trace_marker is writable (only by root).
> +  	    When disabled, the trace_marker will error with EINVAL
> +	    on write.
> +
> +
> +  function-trace - The latency tracers will enable function tracing
> +  	    if this option is enabled (default it is). When
> +	    it is disabled, the latency tracers do not trace
> +	    functions. This keeps the overhead of the tracer down
> +	    when performing latency tests.
>  
> -To disable ftrace_enabled simply replace the '1' with '0' in the
> -above commands.
> + Note: Some tracers have their own options. They only appear
> +       when the tracer is active.
>  
> -When ftrace_enabled is set the tracers will also record the
> -functions that are within the trace. The descriptions of the
> -tracers will also show an example with ftrace enabled.
>  
> 
>  irqsoff
> @@ -506,95 +903,133 @@ new trace is saved.
>  To reset the maximum, echo 0 into tracing_max_latency. Here is
>  an example:
>  
> + # echo 0 > options/function-trace
>   # echo irqsoff > current_tracer
> - # echo latency-format > trace_options
> - # echo 0 > tracing_max_latency
>   # echo 1 > tracing_on
> + # echo 0 > tracing_max_latency
>   # ls -ltr
>   [...]
>   # echo 0 > tracing_on
>   # cat trace
>  # tracer: irqsoff
>  #
> -irqsoff latency trace v1.1.5 on 2.6.26
> ---------------------------------------------------------------------
> - latency: 12 us, #3/3, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: bash-3730 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: sys_setpgid
> - => ended at:   sys_setpgid
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -    bash-3730  1d...    0us : _write_lock_irq (sys_setpgid)
> -    bash-3730  1d..1    1us+: _write_unlock_irq (sys_setpgid)
> -    bash-3730  1d..2   14us : trace_hardirqs_on (sys_setpgid)
> -
> -
> -Here we see that that we had a latency of 12 microsecs (which is
> -very good). The _write_lock_irq in sys_setpgid disabled
> -interrupts. The difference between the 12 and the displayed
> -timestamp 14us occurred because the clock was incremented
> +# irqsoff latency trace v1.1.5 on 3.8.0-test+
> +# --------------------------------------------------------------------
> +# latency: 16 us, #4/4, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> +#    -----------------
> +#    | task: swapper/0-0 (uid:0 nice:0 policy:0 rt_prio:0)
> +#    -----------------
> +#  => started at: run_timer_softirq
> +#  => ended at:   run_timer_softirq
> +#
> +#
> +#                  _------=> CPU#            
> +#                 / _-----=> irqs-off        
> +#                | / _----=> need-resched    
> +#                || / _---=> hardirq/softirq 
> +#                ||| / _--=> preempt-depth   
> +#                |||| /     delay             
> +#  cmd     pid   ||||| time  |   caller      
> +#     \   /      |||||  \    |   /           
> +  <idle>-0       0d.s2    0us+: _raw_spin_lock_irq <-run_timer_softirq
> +  <idle>-0       0dNs3   17us : _raw_spin_unlock_irq <-run_timer_softirq
> +  <idle>-0       0dNs3   17us+: trace_hardirqs_on <-run_timer_softirq
> +  <idle>-0       0dNs3   25us : <stack trace>
> + => _raw_spin_unlock_irq
> + => run_timer_softirq
> + => __do_softirq
> + => call_softirq
> + => do_softirq
> + => irq_exit
> + => smp_apic_timer_interrupt
> + => apic_timer_interrupt
> + => rcu_idle_exit
> + => cpu_idle
> + => rest_init
> + => start_kernel
> + => x86_64_start_reservations
> + => x86_64_start_kernel
> +
> +Here we see that that we had a latency of 16 microseconds (which is
> +very good). The _raw_spin_lock_irq in run_timer_softirq disabled
> +interrupts. The difference between the 16 and the displayed
> +timestamp 25us occurred because the clock was incremented
>  between the time of recording the max latency and the time of
>  recording the function that had that latency.
>  
> -Note the above example had ftrace_enabled not set. If we set the
> -ftrace_enabled, we get a much larger output:
> +Note the above example had function-trace not set. If we set
> +function-trace, we get a much larger output:
> +
> + with echo 1 > options/function-trace
>  
>  # tracer: irqsoff
>  #
> -irqsoff latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 50 us, #101/101, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: ls-4339 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: __alloc_pages_internal
> - => ended at:   __alloc_pages_internal
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -      ls-4339  0...1    0us+: get_page_from_freelist (__alloc_pages_internal)
> -      ls-4339  0d..1    3us : rmqueue_bulk (get_page_from_freelist)
> -      ls-4339  0d..1    3us : _spin_lock (rmqueue_bulk)
> -      ls-4339  0d..1    4us : add_preempt_count (_spin_lock)
> -      ls-4339  0d..2    4us : __rmqueue (rmqueue_bulk)
> -      ls-4339  0d..2    5us : __rmqueue_smallest (__rmqueue)
> -      ls-4339  0d..2    5us : __mod_zone_page_state (__rmqueue_smallest)
> -      ls-4339  0d..2    6us : __rmqueue (rmqueue_bulk)
> -      ls-4339  0d..2    6us : __rmqueue_smallest (__rmqueue)
> -      ls-4339  0d..2    7us : __mod_zone_page_state (__rmqueue_smallest)
> -      ls-4339  0d..2    7us : __rmqueue (rmqueue_bulk)
> -      ls-4339  0d..2    8us : __rmqueue_smallest (__rmqueue)
> +# irqsoff latency trace v1.1.5 on 3.8.0-test+
> +# --------------------------------------------------------------------
> +# latency: 71 us, #168/168, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> +#    -----------------
> +#    | task: bash-2042 (uid:0 nice:0 policy:0 rt_prio:0)
> +#    -----------------
> +#  => started at: ata_scsi_queuecmd
> +#  => ended at:   ata_scsi_queuecmd
> +#
> +#
> +#                  _------=> CPU#            
> +#                 / _-----=> irqs-off        
> +#                | / _----=> need-resched    
> +#                || / _---=> hardirq/softirq 
> +#                ||| / _--=> preempt-depth   
> +#                |||| /     delay             
> +#  cmd     pid   ||||| time  |   caller      
> +#     \   /      |||||  \    |   /           
> +    bash-2042    3d...    0us : _raw_spin_lock_irqsave <-ata_scsi_queuecmd
> +    bash-2042    3d...    0us : add_preempt_count <-_raw_spin_lock_irqsave
> +    bash-2042    3d..1    1us : ata_scsi_find_dev <-ata_scsi_queuecmd
> +    bash-2042    3d..1    1us : __ata_scsi_find_dev <-ata_scsi_find_dev
> +    bash-2042    3d..1    2us : ata_find_dev.part.14 <-__ata_scsi_find_dev
> +    bash-2042    3d..1    2us : ata_qc_new_init <-__ata_scsi_queuecmd
> +    bash-2042    3d..1    3us : ata_sg_init <-__ata_scsi_queuecmd
> +    bash-2042    3d..1    4us : ata_scsi_rw_xlat <-__ata_scsi_queuecmd
> +    bash-2042    3d..1    4us : ata_build_rw_tf <-ata_scsi_rw_xlat
>  [...]
> -      ls-4339  0d..2   46us : __rmqueue_smallest (__rmqueue)
> -      ls-4339  0d..2   47us : __mod_zone_page_state (__rmqueue_smallest)
> -      ls-4339  0d..2   47us : __rmqueue (rmqueue_bulk)
> -      ls-4339  0d..2   48us : __rmqueue_smallest (__rmqueue)
> -      ls-4339  0d..2   48us : __mod_zone_page_state (__rmqueue_smallest)
> -      ls-4339  0d..2   49us : _spin_unlock (rmqueue_bulk)
> -      ls-4339  0d..2   49us : sub_preempt_count (_spin_unlock)
> -      ls-4339  0d..1   50us : get_page_from_freelist (__alloc_pages_internal)
> -      ls-4339  0d..2   51us : trace_hardirqs_on (__alloc_pages_internal)
> -
> -
> -
> -Here we traced a 50 microsecond latency. But we also see all the
> +    bash-2042    3d..1   67us : delay_tsc <-__delay
> +    bash-2042    3d..1   67us : add_preempt_count <-delay_tsc
> +    bash-2042    3d..2   67us : sub_preempt_count <-delay_tsc
> +    bash-2042    3d..1   67us : add_preempt_count <-delay_tsc
> +    bash-2042    3d..2   68us : sub_preempt_count <-delay_tsc
> +    bash-2042    3d..1   68us+: ata_bmdma_start <-ata_bmdma_qc_issue
> +    bash-2042    3d..1   71us : _raw_spin_unlock_irqrestore <-ata_scsi_queuecmd
> +    bash-2042    3d..1   71us : _raw_spin_unlock_irqrestore <-ata_scsi_queuecmd
> +    bash-2042    3d..1   72us+: trace_hardirqs_on <-ata_scsi_queuecmd
> +    bash-2042    3d..1  120us : <stack trace>
> + => _raw_spin_unlock_irqrestore
> + => ata_scsi_queuecmd
> + => scsi_dispatch_cmd
> + => scsi_request_fn
> + => __blk_run_queue_uncond
> + => __blk_run_queue
> + => blk_queue_bio
> + => generic_make_request
> + => submit_bio
> + => submit_bh
> + => __ext3_get_inode_loc
> + => ext3_iget
> + => ext3_lookup
> + => lookup_real
> + => __lookup_hash
> + => walk_component
> + => lookup_last
> + => path_lookupat
> + => filename_lookup
> + => user_path_at_empty
> + => user_path_at
> + => vfs_fstatat
> + => vfs_stat
> + => sys_newstat
> + => system_call_fastpath
> +
> +
> +Here we traced a 71 microsecond latency. But we also see all the
>  functions that were called during that time. Note that by
>  enabling function tracing, we incur an added overhead. This
>  overhead may extend the latency times. But nevertheless, this
> @@ -614,120 +1049,122 @@ Like the irqsoff tracer, it records the maximum latency for
>  which preemption was disabled. The control of preemptoff tracer
>  is much like the irqsoff tracer.
>  
> + # echo 0 > options/function-trace
>   # echo preemptoff > current_tracer
> - # echo latency-format > trace_options
> - # echo 0 > tracing_max_latency
>   # echo 1 > tracing_on
> + # echo 0 > tracing_max_latency
>   # ls -ltr
>   [...]
>   # echo 0 > tracing_on
>   # cat trace
>  # tracer: preemptoff
>  #
> -preemptoff latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 29 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: sshd-4261 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: do_IRQ
> - => ended at:   __do_softirq
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -    sshd-4261  0d.h.    0us+: irq_enter (do_IRQ)
> -    sshd-4261  0d.s.   29us : _local_bh_enable (__do_softirq)
> -    sshd-4261  0d.s1   30us : trace_preempt_on (__do_softirq)
> +# preemptoff latency trace v1.1.5 on 3.8.0-test+
> +# --------------------------------------------------------------------
> +# latency: 46 us, #4/4, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> +#    -----------------
> +#    | task: sshd-1991 (uid:0 nice:0 policy:0 rt_prio:0)
> +#    -----------------
> +#  => started at: do_IRQ
> +#  => ended at:   do_IRQ
> +#
> +#
> +#                  _------=> CPU#            
> +#                 / _-----=> irqs-off        
> +#                | / _----=> need-resched    
> +#                || / _---=> hardirq/softirq 
> +#                ||| / _--=> preempt-depth   
> +#                |||| /     delay             
> +#  cmd     pid   ||||| time  |   caller      
> +#     \   /      |||||  \    |   /           
> +    sshd-1991    1d.h.    0us+: irq_enter <-do_IRQ
> +    sshd-1991    1d..1   46us : irq_exit <-do_IRQ
> +    sshd-1991    1d..1   47us+: trace_preempt_on <-do_IRQ
> +    sshd-1991    1d..1   52us : <stack trace>
> + => sub_preempt_count
> + => irq_exit
> + => do_IRQ
> + => ret_from_intr
>  
> 
>  This has some more changes. Preemption was disabled when an
> -interrupt came in (notice the 'h'), and was enabled while doing
> -a softirq. (notice the 's'). But we also see that interrupts
> -have been disabled when entering the preempt off section and
> -leaving it (the 'd'). We do not know if interrupts were enabled
> -in the mean time.
> +interrupt came in (notice the 'h'), and was enabled on exit.
> +But we also see that interrupts have been disabled when entering
> +the preempt off section and leaving it (the 'd'). We do not know if
> +interrupts were enabled in the mean time or shortly after this
> +was over.
>  
>  # tracer: preemptoff
>  #
> -preemptoff latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 63 us, #87/87, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: sshd-4261 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: remove_wait_queue
> - => ended at:   __do_softirq
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -    sshd-4261  0d..1    0us : _spin_lock_irqsave (remove_wait_queue)
> -    sshd-4261  0d..1    1us : _spin_unlock_irqrestore (remove_wait_queue)
> -    sshd-4261  0d..1    2us : do_IRQ (common_interrupt)
> -    sshd-4261  0d..1    2us : irq_enter (do_IRQ)
> -    sshd-4261  0d..1    2us : idle_cpu (irq_enter)
> -    sshd-4261  0d..1    3us : add_preempt_count (irq_enter)
> -    sshd-4261  0d.h1    3us : idle_cpu (irq_enter)
> -    sshd-4261  0d.h.    4us : handle_fasteoi_irq (do_IRQ)
> +# preemptoff latency trace v1.1.5 on 3.8.0-test+
> +# --------------------------------------------------------------------
> +# latency: 83 us, #241/241, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> +#    -----------------
> +#    | task: bash-1994 (uid:0 nice:0 policy:0 rt_prio:0)
> +#    -----------------
> +#  => started at: wake_up_new_task
> +#  => ended at:   task_rq_unlock
> +#
> +#
> +#                  _------=> CPU#            
> +#                 / _-----=> irqs-off        
> +#                | / _----=> need-resched    
> +#                || / _---=> hardirq/softirq 
> +#                ||| / _--=> preempt-depth   
> +#                |||| /     delay             
> +#  cmd     pid   ||||| time  |   caller      
> +#     \   /      |||||  \    |   /           
> +    bash-1994    1d..1    0us : _raw_spin_lock_irqsave <-wake_up_new_task
> +    bash-1994    1d..1    0us : select_task_rq_fair <-select_task_rq
> +    bash-1994    1d..1    1us : __rcu_read_lock <-select_task_rq_fair
> +    bash-1994    1d..1    1us : source_load <-select_task_rq_fair
> +    bash-1994    1d..1    1us : source_load <-select_task_rq_fair
>  [...]
> -    sshd-4261  0d.h.   12us : add_preempt_count (_spin_lock)
> -    sshd-4261  0d.h1   12us : ack_ioapic_quirk_irq (handle_fasteoi_irq)
> -    sshd-4261  0d.h1   13us : move_native_irq (ack_ioapic_quirk_irq)
> -    sshd-4261  0d.h1   13us : _spin_unlock (handle_fasteoi_irq)
> -    sshd-4261  0d.h1   14us : sub_preempt_count (_spin_unlock)
> -    sshd-4261  0d.h1   14us : irq_exit (do_IRQ)
> -    sshd-4261  0d.h1   15us : sub_preempt_count (irq_exit)
> -    sshd-4261  0d..2   15us : do_softirq (irq_exit)
> -    sshd-4261  0d...   15us : __do_softirq (do_softirq)
> -    sshd-4261  0d...   16us : __local_bh_disable (__do_softirq)
> -    sshd-4261  0d...   16us+: add_preempt_count (__local_bh_disable)
> -    sshd-4261  0d.s4   20us : add_preempt_count (__local_bh_disable)
> -    sshd-4261  0d.s4   21us : sub_preempt_count (local_bh_enable)
> -    sshd-4261  0d.s5   21us : sub_preempt_count (local_bh_enable)
> +    bash-1994    1d..1   12us : irq_enter <-smp_apic_timer_interrupt
> +    bash-1994    1d..1   12us : rcu_irq_enter <-irq_enter
> +    bash-1994    1d..1   13us : add_preempt_count <-irq_enter
> +    bash-1994    1d.h1   13us : exit_idle <-smp_apic_timer_interrupt
> +    bash-1994    1d.h1   13us : hrtimer_interrupt <-smp_apic_timer_interrupt
> +    bash-1994    1d.h1   13us : _raw_spin_lock <-hrtimer_interrupt
> +    bash-1994    1d.h1   14us : add_preempt_count <-_raw_spin_lock
> +    bash-1994    1d.h2   14us : ktime_get_update_offsets <-hrtimer_interrupt
>  [...]
> -    sshd-4261  0d.s6   41us : add_preempt_count (__local_bh_disable)
> -    sshd-4261  0d.s6   42us : sub_preempt_count (local_bh_enable)
> -    sshd-4261  0d.s7   42us : sub_preempt_count (local_bh_enable)
> -    sshd-4261  0d.s5   43us : add_preempt_count (__local_bh_disable)
> -    sshd-4261  0d.s5   43us : sub_preempt_count (local_bh_enable_ip)
> -    sshd-4261  0d.s6   44us : sub_preempt_count (local_bh_enable_ip)
> -    sshd-4261  0d.s5   44us : add_preempt_count (__local_bh_disable)
> -    sshd-4261  0d.s5   45us : sub_preempt_count (local_bh_enable)
> +    bash-1994    1d.h1   35us : lapic_next_event <-clockevents_program_event
> +    bash-1994    1d.h1   35us : irq_exit <-smp_apic_timer_interrupt
> +    bash-1994    1d.h1   36us : sub_preempt_count <-irq_exit
> +    bash-1994    1d..2   36us : do_softirq <-irq_exit
> +    bash-1994    1d..2   36us : __do_softirq <-call_softirq
> +    bash-1994    1d..2   36us : __local_bh_disable <-__do_softirq
> +    bash-1994    1d.s2   37us : add_preempt_count <-_raw_spin_lock_irq
> +    bash-1994    1d.s3   38us : _raw_spin_unlock <-run_timer_softirq
> +    bash-1994    1d.s3   39us : sub_preempt_count <-_raw_spin_unlock
> +    bash-1994    1d.s2   39us : call_timer_fn <-run_timer_softirq
>  [...]
> -    sshd-4261  0d.s.   63us : _local_bh_enable (__do_softirq)
> -    sshd-4261  0d.s1   64us : trace_preempt_on (__do_softirq)
> +    bash-1994    1dNs2   81us : cpu_needs_another_gp <-rcu_process_callbacks
> +    bash-1994    1dNs2   82us : __local_bh_enable <-__do_softirq
> +    bash-1994    1dNs2   82us : sub_preempt_count <-__local_bh_enable
> +    bash-1994    1dN.2   82us : idle_cpu <-irq_exit
> +    bash-1994    1dN.2   83us : rcu_irq_exit <-irq_exit
> +    bash-1994    1dN.2   83us : sub_preempt_count <-irq_exit
> +    bash-1994    1.N.1   84us : _raw_spin_unlock_irqrestore <-task_rq_unlock
> +    bash-1994    1.N.1   84us+: trace_preempt_on <-task_rq_unlock
> +    bash-1994    1.N.1  104us : <stack trace>
> + => sub_preempt_count
> + => _raw_spin_unlock_irqrestore
> + => task_rq_unlock
> + => wake_up_new_task
> + => do_fork
> + => sys_clone
> + => stub_clone
>  
> 
>  The above is an example of the preemptoff trace with
> -ftrace_enabled set. Here we see that interrupts were disabled
> +function-trace set. Here we see that interrupts were not disabled
>  the entire time. The irq_enter code lets us know that we entered
>  an interrupt 'h'. Before that, the functions being traced still
>  show that it is not in an interrupt, but we can see from the
>  functions themselves that this is not the case.
>  
> -Notice that __do_softirq when called does not have a
> -preempt_count. It may seem that we missed a preempt enabling.
> -What really happened is that the preempt count is held on the
> -thread's stack and we switched to the softirq stack (4K stacks
> -in effect). The code does not copy the preempt count, but
> -because interrupts are disabled, we do not need to worry about
> -it. Having a tracer like this is good for letting people know
> -what really happens inside the kernel.
> -
> -
>  preemptirqsoff
>  --------------
>  
> @@ -762,38 +1199,57 @@ tracer.
>  Again, using this trace is much like the irqsoff and preemptoff
>  tracers.
>  
> + # echo 0 > options/function-trace
>   # echo preemptirqsoff > current_tracer
> - # echo latency-format > trace_options
> - # echo 0 > tracing_max_latency
>   # echo 1 > tracing_on
> + # echo 0 > tracing_max_latency
>   # ls -ltr
>   [...]
>   # echo 0 > tracing_on
>   # cat trace
>  # tracer: preemptirqsoff
>  #
> -preemptirqsoff latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 293 us, #3/3, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: ls-4860 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: apic_timer_interrupt
> - => ended at:   __do_softirq
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -      ls-4860  0d...    0us!: trace_hardirqs_off_thunk (apic_timer_interrupt)
> -      ls-4860  0d.s.  294us : _local_bh_enable (__do_softirq)
> -      ls-4860  0d.s1  294us : trace_preempt_on (__do_softirq)
> -
> +# preemptirqsoff latency trace v1.1.5 on 3.8.0-test+
> +# --------------------------------------------------------------------
> +# latency: 100 us, #4/4, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> +#    -----------------
> +#    | task: ls-2230 (uid:0 nice:0 policy:0 rt_prio:0)
> +#    -----------------
> +#  => started at: ata_scsi_queuecmd
> +#  => ended at:   ata_scsi_queuecmd
> +#
> +#
> +#                  _------=> CPU#            
> +#                 / _-----=> irqs-off        
> +#                | / _----=> need-resched    
> +#                || / _---=> hardirq/softirq 
> +#                ||| / _--=> preempt-depth   
> +#                |||| /     delay             
> +#  cmd     pid   ||||| time  |   caller      
> +#     \   /      |||||  \    |   /           
> +      ls-2230    3d...    0us+: _raw_spin_lock_irqsave <-ata_scsi_queuecmd
> +      ls-2230    3...1  100us : _raw_spin_unlock_irqrestore <-ata_scsi_queuecmd
> +      ls-2230    3...1  101us+: trace_preempt_on <-ata_scsi_queuecmd
> +      ls-2230    3...1  111us : <stack trace>
> + => sub_preempt_count
> + => _raw_spin_unlock_irqrestore
> + => ata_scsi_queuecmd
> + => scsi_dispatch_cmd
> + => scsi_request_fn
> + => __blk_run_queue_uncond
> + => __blk_run_queue
> + => blk_queue_bio
> + => generic_make_request
> + => submit_bio
> + => submit_bh
> + => ext3_bread
> + => ext3_dir_bread
> + => htree_dirblock_to_tree
> + => ext3_htree_fill_tree
> + => ext3_readdir
> + => vfs_readdir
> + => sys_getdents
> + => system_call_fastpath
>  
> 
>  The trace_hardirqs_off_thunk is called from assembly on x86 when
> @@ -802,105 +1258,158 @@ function tracing, we do not know if interrupts were enabled
>  within the preemption points. We do see that it started with
>  preemption enabled.
>  
> -Here is a trace with ftrace_enabled set:
> -
> +Here is a trace with function-trace set:
>  
>  # tracer: preemptirqsoff
>  #
> -preemptirqsoff latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 105 us, #183/183, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: sshd-4261 (uid:0 nice:0 policy:0 rt_prio:0)
> -    -----------------
> - => started at: write_chan
> - => ended at:   __do_softirq
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -      ls-4473  0.N..    0us : preempt_schedule (write_chan)
> -      ls-4473  0dN.1    1us : _spin_lock (schedule)
> -      ls-4473  0dN.1    2us : add_preempt_count (_spin_lock)
> -      ls-4473  0d..2    2us : put_prev_task_fair (schedule)
> -[...]
> -      ls-4473  0d..2   13us : set_normalized_timespec (ktime_get_ts)
> -      ls-4473  0d..2   13us : __switch_to (schedule)
> -    sshd-4261  0d..2   14us : finish_task_switch (schedule)
> -    sshd-4261  0d..2   14us : _spin_unlock_irq (finish_task_switch)
> -    sshd-4261  0d..1   15us : add_preempt_count (_spin_lock_irqsave)
> -    sshd-4261  0d..2   16us : _spin_unlock_irqrestore (hrtick_set)
> -    sshd-4261  0d..2   16us : do_IRQ (common_interrupt)
> -    sshd-4261  0d..2   17us : irq_enter (do_IRQ)
> -    sshd-4261  0d..2   17us : idle_cpu (irq_enter)
> -    sshd-4261  0d..2   18us : add_preempt_count (irq_enter)
> -    sshd-4261  0d.h2   18us : idle_cpu (irq_enter)
> -    sshd-4261  0d.h.   18us : handle_fasteoi_irq (do_IRQ)
> -    sshd-4261  0d.h.   19us : _spin_lock (handle_fasteoi_irq)
> -    sshd-4261  0d.h.   19us : add_preempt_count (_spin_lock)
> -    sshd-4261  0d.h1   20us : _spin_unlock (handle_fasteoi_irq)
> -    sshd-4261  0d.h1   20us : sub_preempt_count (_spin_unlock)
> -[...]
> -    sshd-4261  0d.h1   28us : _spin_unlock (handle_fasteoi_irq)
> -    sshd-4261  0d.h1   29us : sub_preempt_count (_spin_unlock)
> -    sshd-4261  0d.h2   29us : irq_exit (do_IRQ)
> -    sshd-4261  0d.h2   29us : sub_preempt_count (irq_exit)
> -    sshd-4261  0d..3   30us : do_softirq (irq_exit)
> -    sshd-4261  0d...   30us : __do_softirq (do_softirq)
> -    sshd-4261  0d...   31us : __local_bh_disable (__do_softirq)
> -    sshd-4261  0d...   31us+: add_preempt_count (__local_bh_disable)
> -    sshd-4261  0d.s4   34us : add_preempt_count (__local_bh_disable)
> +# preemptirqsoff latency trace v1.1.5 on 3.8.0-test+
> +# --------------------------------------------------------------------
> +# latency: 161 us, #339/339, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> +#    -----------------
> +#    | task: ls-2269 (uid:0 nice:0 policy:0 rt_prio:0)
> +#    -----------------
> +#  => started at: schedule
> +#  => ended at:   mutex_unlock
> +#
> +#
> +#                  _------=> CPU#            
> +#                 / _-----=> irqs-off        
> +#                | / _----=> need-resched    
> +#                || / _---=> hardirq/softirq 
> +#                ||| / _--=> preempt-depth   
> +#                |||| /     delay             
> +#  cmd     pid   ||||| time  |   caller      
> +#     \   /      |||||  \    |   /           
> +kworker/-59      3...1    0us : __schedule <-schedule
> +kworker/-59      3d..1    0us : rcu_preempt_qs <-rcu_note_context_switch
> +kworker/-59      3d..1    1us : add_preempt_count <-_raw_spin_lock_irq
> +kworker/-59      3d..2    1us : deactivate_task <-__schedule
> +kworker/-59      3d..2    1us : dequeue_task <-deactivate_task
> +kworker/-59      3d..2    2us : update_rq_clock <-dequeue_task
> +kworker/-59      3d..2    2us : dequeue_task_fair <-dequeue_task
> +kworker/-59      3d..2    2us : update_curr <-dequeue_task_fair
> +kworker/-59      3d..2    2us : update_min_vruntime <-update_curr
> +kworker/-59      3d..2    3us : cpuacct_charge <-update_curr
> +kworker/-59      3d..2    3us : __rcu_read_lock <-cpuacct_charge
> +kworker/-59      3d..2    3us : __rcu_read_unlock <-cpuacct_charge
> +kworker/-59      3d..2    3us : update_cfs_rq_blocked_load <-dequeue_task_fair
> +kworker/-59      3d..2    4us : clear_buddies <-dequeue_task_fair
> +kworker/-59      3d..2    4us : account_entity_dequeue <-dequeue_task_fair
> +kworker/-59      3d..2    4us : update_min_vruntime <-dequeue_task_fair
> +kworker/-59      3d..2    4us : update_cfs_shares <-dequeue_task_fair
> +kworker/-59      3d..2    5us : hrtick_update <-dequeue_task_fair
> +kworker/-59      3d..2    5us : wq_worker_sleeping <-__schedule
> +kworker/-59      3d..2    5us : kthread_data <-wq_worker_sleeping
> +kworker/-59      3d..2    5us : put_prev_task_fair <-__schedule
> +kworker/-59      3d..2    6us : pick_next_task_fair <-pick_next_task
> +kworker/-59      3d..2    6us : clear_buddies <-pick_next_task_fair
> +kworker/-59      3d..2    6us : set_next_entity <-pick_next_task_fair
> +kworker/-59      3d..2    6us : update_stats_wait_end <-set_next_entity
> +      ls-2269    3d..2    7us : finish_task_switch <-__schedule
> +      ls-2269    3d..2    7us : _raw_spin_unlock_irq <-finish_task_switch
> +      ls-2269    3d..2    8us : do_IRQ <-ret_from_intr
> +      ls-2269    3d..2    8us : irq_enter <-do_IRQ
> +      ls-2269    3d..2    8us : rcu_irq_enter <-irq_enter
> +      ls-2269    3d..2    9us : add_preempt_count <-irq_enter
> +      ls-2269    3d.h2    9us : exit_idle <-do_IRQ
>  [...]
> -    sshd-4261  0d.s3   43us : sub_preempt_count (local_bh_enable_ip)
> -    sshd-4261  0d.s4   44us : sub_preempt_count (local_bh_enable_ip)
> -    sshd-4261  0d.s3   44us : smp_apic_timer_interrupt (apic_timer_interrupt)
> -    sshd-4261  0d.s3   45us : irq_enter (smp_apic_timer_interrupt)
> -    sshd-4261  0d.s3   45us : idle_cpu (irq_enter)
> -    sshd-4261  0d.s3   46us : add_preempt_count (irq_enter)
> -    sshd-4261  0d.H3   46us : idle_cpu (irq_enter)
> -    sshd-4261  0d.H3   47us : hrtimer_interrupt (smp_apic_timer_interrupt)
> -    sshd-4261  0d.H3   47us : ktime_get (hrtimer_interrupt)
> +      ls-2269    3d.h3   20us : sub_preempt_count <-_raw_spin_unlock
> +      ls-2269    3d.h2   20us : irq_exit <-do_IRQ
> +      ls-2269    3d.h2   21us : sub_preempt_count <-irq_exit
> +      ls-2269    3d..3   21us : do_softirq <-irq_exit
> +      ls-2269    3d..3   21us : __do_softirq <-call_softirq
> +      ls-2269    3d..3   21us+: __local_bh_disable <-__do_softirq
> +      ls-2269    3d.s4   29us : sub_preempt_count <-_local_bh_enable_ip
> +      ls-2269    3d.s5   29us : sub_preempt_count <-_local_bh_enable_ip
> +      ls-2269    3d.s5   31us : do_IRQ <-ret_from_intr
> +      ls-2269    3d.s5   31us : irq_enter <-do_IRQ
> +      ls-2269    3d.s5   31us : rcu_irq_enter <-irq_enter
>  [...]
> -    sshd-4261  0d.H3   81us : tick_program_event (hrtimer_interrupt)
> -    sshd-4261  0d.H3   82us : ktime_get (tick_program_event)
> -    sshd-4261  0d.H3   82us : ktime_get_ts (ktime_get)
> -    sshd-4261  0d.H3   83us : getnstimeofday (ktime_get_ts)
> -    sshd-4261  0d.H3   83us : set_normalized_timespec (ktime_get_ts)
> -    sshd-4261  0d.H3   84us : clockevents_program_event (tick_program_event)
> -    sshd-4261  0d.H3   84us : lapic_next_event (clockevents_program_event)
> -    sshd-4261  0d.H3   85us : irq_exit (smp_apic_timer_interrupt)
> -    sshd-4261  0d.H3   85us : sub_preempt_count (irq_exit)
> -    sshd-4261  0d.s4   86us : sub_preempt_count (irq_exit)
> -    sshd-4261  0d.s3   86us : add_preempt_count (__local_bh_disable)
> +      ls-2269    3d.s5   31us : rcu_irq_enter <-irq_enter
> +      ls-2269    3d.s5   32us : add_preempt_count <-irq_enter
> +      ls-2269    3d.H5   32us : exit_idle <-do_IRQ
> +      ls-2269    3d.H5   32us : handle_irq <-do_IRQ
> +      ls-2269    3d.H5   32us : irq_to_desc <-handle_irq
> +      ls-2269    3d.H5   33us : handle_fasteoi_irq <-handle_irq
>  [...]
> -    sshd-4261  0d.s1   98us : sub_preempt_count (net_rx_action)
> -    sshd-4261  0d.s.   99us : add_preempt_count (_spin_lock_irq)
> -    sshd-4261  0d.s1   99us+: _spin_unlock_irq (run_timer_softirq)
> -    sshd-4261  0d.s.  104us : _local_bh_enable (__do_softirq)
> -    sshd-4261  0d.s.  104us : sub_preempt_count (_local_bh_enable)
> -    sshd-4261  0d.s.  105us : _local_bh_enable (__do_softirq)
> -    sshd-4261  0d.s1  105us : trace_preempt_on (__do_softirq)
> -
> -
> -This is a very interesting trace. It started with the preemption
> -of the ls task. We see that the task had the "need_resched" bit
> -set via the 'N' in the trace.  Interrupts were disabled before
> -the spin_lock at the beginning of the trace. We see that a
> -schedule took place to run sshd.  When the interrupts were
> -enabled, we took an interrupt. On return from the interrupt
> -handler, the softirq ran. We took another interrupt while
> -running the softirq as we see from the capital 'H'.
> +      ls-2269    3d.s5  158us : _raw_spin_unlock_irqrestore <-rtl8139_poll
> +      ls-2269    3d.s3  158us : net_rps_action_and_irq_enable.isra.65 <-net_rx_action
> +      ls-2269    3d.s3  159us : __local_bh_enable <-__do_softirq
> +      ls-2269    3d.s3  159us : sub_preempt_count <-__local_bh_enable
> +      ls-2269    3d..3  159us : idle_cpu <-irq_exit
> +      ls-2269    3d..3  159us : rcu_irq_exit <-irq_exit
> +      ls-2269    3d..3  160us : sub_preempt_count <-irq_exit
> +      ls-2269    3d...  161us : __mutex_unlock_slowpath <-mutex_unlock
> +      ls-2269    3d...  162us+: trace_hardirqs_on <-mutex_unlock
> +      ls-2269    3d...  186us : <stack trace>
> + => __mutex_unlock_slowpath
> + => mutex_unlock
> + => process_output
> + => n_tty_write
> + => tty_write
> + => vfs_write
> + => sys_write
> + => system_call_fastpath
> +
> +This is an interesting trace. It started with kworker running and
> +scheduling out and ls taking over. But as soon as ls released the
> +rq lock and enabled interrupts (but not preemption) an interrupt
> +triggered. When the interrupt finished, it started running softirqs.
> +But while the softirq was running, another interrupt triggered.
> +When an interrupt is running inside a softirq, the annotation is 'H'.
>  
> 
>  wakeup
>  ------
>  
> +One common case that people are interested in tracing is the
> +time it takes for a task that is woken to actually wake up.
> +Now for non Real-Time tasks, this can be arbitrary. But tracing
> +it none the less can be interesting. 
> +
> +Without function tracing:
> +
> + # echo 0 > options/function-trace
> + # echo wakeup > current_tracer
> + # echo 1 > tracing_on
> + # echo 0 > tracing_max_latency
> + # chrt -f 5 sleep 1
> + # echo 0 > tracing_on
> + # cat trace
> +# tracer: wakeup
> +#
> +# wakeup latency trace v1.1.5 on 3.8.0-test+
> +# --------------------------------------------------------------------
> +# latency: 15 us, #4/4, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> +#    -----------------
> +#    | task: kworker/3:1H-312 (uid:0 nice:-20 policy:0 rt_prio:0)
> +#    -----------------
> +#
> +#                  _------=> CPU#            
> +#                 / _-----=> irqs-off        
> +#                | / _----=> need-resched    
> +#                || / _---=> hardirq/softirq 
> +#                ||| / _--=> preempt-depth   
> +#                |||| /     delay             
> +#  cmd     pid   ||||| time  |   caller      
> +#     \   /      |||||  \    |   /           
> +  <idle>-0       3dNs7    0us :      0:120:R   + [003]   312:100:R kworker/3:1H
> +  <idle>-0       3dNs7    1us+: ttwu_do_activate.constprop.87 <-try_to_wake_up
> +  <idle>-0       3d..3   15us : __schedule <-schedule
> +  <idle>-0       3d..3   15us :      0:120:R ==> [003]   312:100:R kworker/3:1H
> +
> +The tracer only traces the highest priority task in the system
> +to avoid tracing the normal circumstances. Here we see that
> +the kworker with a nice priority of -20 (not very nice), took
> +just 15 microseconds from the time it woke up, to the time it
> +ran.
> +
> +Non Real-Time tasks are not that interesting. A more interesting
> +trace is to concentrate only on Real-Time tasks.
> +
> +wakeup_rt
> +---------
> +
>  In a Real-Time environment it is very important to know the
>  wakeup time it takes for the highest priority task that is woken
>  up to the time that it executes. This is also known as "schedule
> @@ -914,124 +1423,229 @@ Real-Time environments are interested in the worst case latency.
>  That is the longest latency it takes for something to happen,
>  and not the average. We can have a very fast scheduler that may
>  only have a large latency once in a while, but that would not
> -work well with Real-Time tasks.  The wakeup tracer was designed
> +work well with Real-Time tasks.  The wakeup_rt tracer was designed
>  to record the worst case wakeups of RT tasks. Non-RT tasks are
>  not recorded because the tracer only records one worst case and
>  tracing non-RT tasks that are unpredictable will overwrite the
> -worst case latency of RT tasks.
> +worst case latency of RT tasks (just run the normal wakeup
> +tracer for a while to see that effect).
>  
>  Since this tracer only deals with RT tasks, we will run this
>  slightly differently than we did with the previous tracers.
>  Instead of performing an 'ls', we will run 'sleep 1' under
>  'chrt' which changes the priority of the task.
>  
> - # echo wakeup > current_tracer
> - # echo latency-format > trace_options
> - # echo 0 > tracing_max_latency
> + # echo 0 > options/function-trace
> + # echo wakeup_rt > current_tracer
>   # echo 1 > tracing_on
> + # echo 0 > tracing_max_latency
>   # chrt -f 5 sleep 1
>   # echo 0 > tracing_on
>   # cat trace
>  # tracer: wakeup
>  #
> -wakeup latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 4 us, #2/2, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: sleep-4901 (uid:0 nice:0 policy:1 rt_prio:5)
> -    -----------------
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -  <idle>-0     1d.h4    0us+: try_to_wake_up (wake_up_process)
> -  <idle>-0     1d..4    4us : schedule (cpu_idle)
> -
> -
> -Running this on an idle system, we see that it only took 4
> -microseconds to perform the task switch.  Note, since the trace
> -marker in the schedule is before the actual "switch", we stop
> -the tracing when the recorded task is about to schedule in. This
> -may change if we add a new marker at the end of the scheduler.
> -
> -Notice that the recorded task is 'sleep' with the PID of 4901
> +# tracer: wakeup_rt
> +#
> +# wakeup_rt latency trace v1.1.5 on 3.8.0-test+
> +# --------------------------------------------------------------------
> +# latency: 5 us, #4/4, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> +#    -----------------
> +#    | task: sleep-2389 (uid:0 nice:0 policy:1 rt_prio:5)
> +#    -----------------
> +#
> +#                  _------=> CPU#            
> +#                 / _-----=> irqs-off        
> +#                | / _----=> need-resched    
> +#                || / _---=> hardirq/softirq 
> +#                ||| / _--=> preempt-depth   
> +#                |||| /     delay             
> +#  cmd     pid   ||||| time  |   caller      
> +#     \   /      |||||  \    |   /           
> +  <idle>-0       3d.h4    0us :      0:120:R   + [003]  2389: 94:R sleep
> +  <idle>-0       3d.h4    1us+: ttwu_do_activate.constprop.87 <-try_to_wake_up
> +  <idle>-0       3d..3    5us : __schedule <-schedule
> +  <idle>-0       3d..3    5us :      0:120:R ==> [003]  2389: 94:R sleep
> +
> +
> +Running this on an idle system, we see that it only took 5 microseconds
> +to perform the task switch.  Note, since the trace point in the schedule
> +is before the actual "switch", we stop the tracing when the recorded task
> +is about to schedule in. This may change if we add a new marker at the
> +end of the scheduler.
> +
> +Notice that the recorded task is 'sleep' with the PID of 2389
>  and it has an rt_prio of 5. This priority is user-space priority
>  and not the internal kernel priority. The policy is 1 for
>  SCHED_FIFO and 2 for SCHED_RR.
>  
> -Doing the same with chrt -r 5 and ftrace_enabled set.
> +Note, that the trace data shows the internal priority (99 - rtprio).
>  
> -# tracer: wakeup
> +  <idle>-0       3d..3    5us :      0:120:R ==> [003]  2389: 94:R sleep
> +
> +The 0:120:R means idle was running with a nice priority of 0 (120 - 20)
> +and in the running state 'R'. The sleep task was scheduled in with
> +2389: 94:R. That is the priority is the kernel rtprio (99 - 5 = 94)
> +and it too is in the running state.
> +
> +Doing the same with chrt -r 5 and function-trace set.
> +
> +  echo 1 > options/function-trace
> +
> +# tracer: wakeup_rt
>  #
> -wakeup latency trace v1.1.5 on 2.6.26-rc8
> ---------------------------------------------------------------------
> - latency: 50 us, #60/60, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
> -    -----------------
> -    | task: sleep-4068 (uid:0 nice:0 policy:2 rt_prio:5)
> -    -----------------
> -
> -#                _------=> CPU#
> -#               / _-----=> irqs-off
> -#              | / _----=> need-resched
> -#              || / _---=> hardirq/softirq
> -#              ||| / _--=> preempt-depth
> -#              |||| /
> -#              |||||     delay
> -#  cmd     pid ||||| time  |   caller
> -#     \   /    |||||   \   |   /
> -ksoftirq-7     1d.H3    0us : try_to_wake_up (wake_up_process)
> -ksoftirq-7     1d.H4    1us : sub_preempt_count (marker_probe_cb)
> -ksoftirq-7     1d.H3    2us : check_preempt_wakeup (try_to_wake_up)
> -ksoftirq-7     1d.H3    3us : update_curr (check_preempt_wakeup)
> -ksoftirq-7     1d.H3    4us : calc_delta_mine (update_curr)
> -ksoftirq-7     1d.H3    5us : __resched_task (check_preempt_wakeup)
> -ksoftirq-7     1d.H3    6us : task_wake_up_rt (try_to_wake_up)
> -ksoftirq-7     1d.H3    7us : _spin_unlock_irqrestore (try_to_wake_up)
> -[...]
> -ksoftirq-7     1d.H2   17us : irq_exit (smp_apic_timer_interrupt)
> -ksoftirq-7     1d.H2   18us : sub_preempt_count (irq_exit)
> -ksoftirq-7     1d.s3   19us : sub_preempt_count (irq_exit)
> -ksoftirq-7     1..s2   20us : rcu_process_callbacks (__do_softirq)
> -[...]
> -ksoftirq-7     1..s2   26us : __rcu_process_callbacks (rcu_process_callbacks)
> -ksoftirq-7     1d.s2   27us : _local_bh_enable (__do_softirq)
> -ksoftirq-7     1d.s2   28us : sub_preempt_count (_local_bh_enable)
> -ksoftirq-7     1.N.3   29us : sub_preempt_count (ksoftirqd)
> -ksoftirq-7     1.N.2   30us : _cond_resched (ksoftirqd)
> -ksoftirq-7     1.N.2   31us : __cond_resched (_cond_resched)
> -ksoftirq-7     1.N.2   32us : add_preempt_count (__cond_resched)
> -ksoftirq-7     1.N.2   33us : schedule (__cond_resched)
> -ksoftirq-7     1.N.2   33us : add_preempt_count (schedule)
> -ksoftirq-7     1.N.3   34us : hrtick_clear (schedule)
> -ksoftirq-7     1dN.3   35us : _spin_lock (schedule)
> -ksoftirq-7     1dN.3   36us : add_preempt_count (_spin_lock)
> -ksoftirq-7     1d..4   37us : put_prev_task_fair (schedule)
> -ksoftirq-7     1d..4   38us : update_curr (put_prev_task_fair)
> -[...]
> -ksoftirq-7     1d..5   47us : _spin_trylock (tracing_record_cmdline)
> -ksoftirq-7     1d..5   48us : add_preempt_count (_spin_trylock)
> -ksoftirq-7     1d..6   49us : _spin_unlock (tracing_record_cmdline)
> -ksoftirq-7     1d..6   49us : sub_preempt_count (_spin_unlock)
> -ksoftirq-7     1d..4   50us : schedule (__cond_resched)
> -
> -The interrupt went off while running ksoftirqd. This task runs
> -at SCHED_OTHER. Why did not we see the 'N' set early? This may
> -be a harmless bug with x86_32 and 4K stacks. On x86_32 with 4K
> -stacks configured, the interrupt and softirq run with their own
> -stack. Some information is held on the top of the task's stack
> -(need_resched and preempt_count are both stored there). The
> -setting of the NEED_RESCHED bit is done directly to the task's
> -stack, but the reading of the NEED_RESCHED is done by looking at
> -the current stack, which in this case is the stack for the hard
> -interrupt. This hides the fact that NEED_RESCHED has been set.
> -We do not see the 'N' until we switch back to the task's
> -assigned stack.
> +# wakeup_rt latency trace v1.1.5 on 3.8.0-test+
> +# --------------------------------------------------------------------
> +# latency: 29 us, #85/85, CPU#3 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> +#    -----------------
> +#    | task: sleep-2448 (uid:0 nice:0 policy:1 rt_prio:5)
> +#    -----------------
> +#
> +#                  _------=> CPU#            
> +#                 / _-----=> irqs-off        
> +#                | / _----=> need-resched    
> +#                || / _---=> hardirq/softirq 
> +#                ||| / _--=> preempt-depth   
> +#                |||| /     delay             
> +#  cmd     pid   ||||| time  |   caller      
> +#     \   /      |||||  \    |   /           
> +  <idle>-0       3d.h4    1us+:      0:120:R   + [003]  2448: 94:R sleep
> +  <idle>-0       3d.h4    2us : ttwu_do_activate.constprop.87 <-try_to_wake_up
> +  <idle>-0       3d.h3    3us : check_preempt_curr <-ttwu_do_wakeup
> +  <idle>-0       3d.h3    3us : resched_task <-check_preempt_curr
> +  <idle>-0       3dNh3    4us : task_woken_rt <-ttwu_do_wakeup
> +  <idle>-0       3dNh3    4us : _raw_spin_unlock <-try_to_wake_up
> +  <idle>-0       3dNh3    4us : sub_preempt_count <-_raw_spin_unlock
> +  <idle>-0       3dNh2    5us : ttwu_stat <-try_to_wake_up
> +  <idle>-0       3dNh2    5us : _raw_spin_unlock_irqrestore <-try_to_wake_up
> +  <idle>-0       3dNh2    6us : sub_preempt_count <-_raw_spin_unlock_irqrestore
> +  <idle>-0       3dNh1    6us : _raw_spin_lock <-__run_hrtimer
> +  <idle>-0       3dNh1    6us : add_preempt_count <-_raw_spin_lock
> +  <idle>-0       3dNh2    7us : _raw_spin_unlock <-hrtimer_interrupt
> +  <idle>-0       3dNh2    7us : sub_preempt_count <-_raw_spin_unlock
> +  <idle>-0       3dNh1    7us : tick_program_event <-hrtimer_interrupt
> +  <idle>-0       3dNh1    7us : clockevents_program_event <-tick_program_event
> +  <idle>-0       3dNh1    8us : ktime_get <-clockevents_program_event
> +  <idle>-0       3dNh1    8us : lapic_next_event <-clockevents_program_event
> +  <idle>-0       3dNh1    8us : irq_exit <-smp_apic_timer_interrupt
> +  <idle>-0       3dNh1    9us : sub_preempt_count <-irq_exit
> +  <idle>-0       3dN.2    9us : idle_cpu <-irq_exit
> +  <idle>-0       3dN.2    9us : rcu_irq_exit <-irq_exit
> +  <idle>-0       3dN.2   10us : rcu_eqs_enter_common.isra.45 <-rcu_irq_exit
> +  <idle>-0       3dN.2   10us : sub_preempt_count <-irq_exit
> +  <idle>-0       3.N.1   11us : rcu_idle_exit <-cpu_idle
> +  <idle>-0       3dN.1   11us : rcu_eqs_exit_common.isra.43 <-rcu_idle_exit
> +  <idle>-0       3.N.1   11us : tick_nohz_idle_exit <-cpu_idle
> +  <idle>-0       3dN.1   12us : menu_hrtimer_cancel <-tick_nohz_idle_exit
> +  <idle>-0       3dN.1   12us : ktime_get <-tick_nohz_idle_exit
> +  <idle>-0       3dN.1   12us : tick_do_update_jiffies64 <-tick_nohz_idle_exit
> +  <idle>-0       3dN.1   13us : update_cpu_load_nohz <-tick_nohz_idle_exit
> +  <idle>-0       3dN.1   13us : _raw_spin_lock <-update_cpu_load_nohz
> +  <idle>-0       3dN.1   13us : add_preempt_count <-_raw_spin_lock
> +  <idle>-0       3dN.2   13us : __update_cpu_load <-update_cpu_load_nohz
> +  <idle>-0       3dN.2   14us : sched_avg_update <-__update_cpu_load
> +  <idle>-0       3dN.2   14us : _raw_spin_unlock <-update_cpu_load_nohz
> +  <idle>-0       3dN.2   14us : sub_preempt_count <-_raw_spin_unlock
> +  <idle>-0       3dN.1   15us : calc_load_exit_idle <-tick_nohz_idle_exit
> +  <idle>-0       3dN.1   15us : touch_softlockup_watchdog <-tick_nohz_idle_exit
> +  <idle>-0       3dN.1   15us : hrtimer_cancel <-tick_nohz_idle_exit
> +  <idle>-0       3dN.1   15us : hrtimer_try_to_cancel <-hrtimer_cancel
> +  <idle>-0       3dN.1   16us : lock_hrtimer_base.isra.18 <-hrtimer_try_to_cancel
> +  <idle>-0       3dN.1   16us : _raw_spin_lock_irqsave <-lock_hrtimer_base.isra.18
> +  <idle>-0       3dN.1   16us : add_preempt_count <-_raw_spin_lock_irqsave
> +  <idle>-0       3dN.2   17us : __remove_hrtimer <-remove_hrtimer.part.16
> +  <idle>-0       3dN.2   17us : hrtimer_force_reprogram <-__remove_hrtimer
> +  <idle>-0       3dN.2   17us : tick_program_event <-hrtimer_force_reprogram
> +  <idle>-0       3dN.2   18us : clockevents_program_event <-tick_program_event
> +  <idle>-0       3dN.2   18us : ktime_get <-clockevents_program_event
> +  <idle>-0       3dN.2   18us : lapic_next_event <-clockevents_program_event
> +  <idle>-0       3dN.2   19us : _raw_spin_unlock_irqrestore <-hrtimer_try_to_cancel
> +  <idle>-0       3dN.2   19us : sub_preempt_count <-_raw_spin_unlock_irqrestore
> +  <idle>-0       3dN.1   19us : hrtimer_forward <-tick_nohz_idle_exit
> +  <idle>-0       3dN.1   20us : ktime_add_safe <-hrtimer_forward
> +  <idle>-0       3dN.1   20us : ktime_add_safe <-hrtimer_forward
> +  <idle>-0       3dN.1   20us : hrtimer_start_range_ns <-hrtimer_start_expires.constprop.11
> +  <idle>-0       3dN.1   20us : __hrtimer_start_range_ns <-hrtimer_start_range_ns
> +  <idle>-0       3dN.1   21us : lock_hrtimer_base.isra.18 <-__hrtimer_start_range_ns
> +  <idle>-0       3dN.1   21us : _raw_spin_lock_irqsave <-lock_hrtimer_base.isra.18
> +  <idle>-0       3dN.1   21us : add_preempt_count <-_raw_spin_lock_irqsave
> +  <idle>-0       3dN.2   22us : ktime_add_safe <-__hrtimer_start_range_ns
> +  <idle>-0       3dN.2   22us : enqueue_hrtimer <-__hrtimer_start_range_ns
> +  <idle>-0       3dN.2   22us : tick_program_event <-__hrtimer_start_range_ns
> +  <idle>-0       3dN.2   23us : clockevents_program_event <-tick_program_event
> +  <idle>-0       3dN.2   23us : ktime_get <-clockevents_program_event
> +  <idle>-0       3dN.2   23us : lapic_next_event <-clockevents_program_event
> +  <idle>-0       3dN.2   24us : _raw_spin_unlock_irqrestore <-__hrtimer_start_range_ns
> +  <idle>-0       3dN.2   24us : sub_preempt_count <-_raw_spin_unlock_irqrestore
> +  <idle>-0       3dN.1   24us : account_idle_ticks <-tick_nohz_idle_exit
> +  <idle>-0       3dN.1   24us : account_idle_time <-account_idle_ticks
> +  <idle>-0       3.N.1   25us : sub_preempt_count <-cpu_idle
> +  <idle>-0       3.N..   25us : schedule <-cpu_idle
> +  <idle>-0       3.N..   25us : __schedule <-preempt_schedule
> +  <idle>-0       3.N..   26us : add_preempt_count <-__schedule
> +  <idle>-0       3.N.1   26us : rcu_note_context_switch <-__schedule
> +  <idle>-0       3.N.1   26us : rcu_sched_qs <-rcu_note_context_switch
> +  <idle>-0       3dN.1   27us : rcu_preempt_qs <-rcu_note_context_switch
> +  <idle>-0       3.N.1   27us : _raw_spin_lock_irq <-__schedule
> +  <idle>-0       3dN.1   27us : add_preempt_count <-_raw_spin_lock_irq
> +  <idle>-0       3dN.2   28us : put_prev_task_idle <-__schedule
> +  <idle>-0       3dN.2   28us : pick_next_task_stop <-pick_next_task
> +  <idle>-0       3dN.2   28us : pick_next_task_rt <-pick_next_task
> +  <idle>-0       3dN.2   29us : dequeue_pushable_task <-pick_next_task_rt
> +  <idle>-0       3d..3   29us : __schedule <-preempt_schedule
> +  <idle>-0       3d..3   30us :      0:120:R ==> [003]  2448: 94:R sleep
> +
> +This isn't that big of a trace, even with function tracing enabled,
> +so I included the entire trace.
> +
> +The interrupt went off while when the system was idle. Somewhere
> +before task_woken_rt() was called, the NEED_RESCHED flag was set,
> +this is indicated by the first occurrence of the 'N' flag.
> +
> +Latency tracing and events
> +--------------------------
> +As function tracing can induce a much larger latency, but without
> +seeing what happens within the latency it is hard to know what
> +caused it. There is a middle ground, and that is with enabling
> +events.
> +
> + # echo 0 > options/function-trace
> + # echo wakeup_rt > current_tracer
> + # echo 1 > events/enable
> + # echo 1 > tracing_on
> + # echo 0 > tracing_max_latency
> + # chrt -f 5 sleep 1
> + # echo 0 > tracing_on
> + # cat trace
> +# tracer: wakeup_rt
> +#
> +# wakeup_rt latency trace v1.1.5 on 3.8.0-test+
> +# --------------------------------------------------------------------
> +# latency: 6 us, #12/12, CPU#2 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
> +#    -----------------
> +#    | task: sleep-5882 (uid:0 nice:0 policy:1 rt_prio:5)
> +#    -----------------
> +#
> +#                  _------=> CPU#            
> +#                 / _-----=> irqs-off        
> +#                | / _----=> need-resched    
> +#                || / _---=> hardirq/softirq 
> +#                ||| / _--=> preempt-depth   
> +#                |||| /     delay             
> +#  cmd     pid   ||||| time  |   caller      
> +#     \   /      |||||  \    |   /           
> +  <idle>-0       2d.h4    0us :      0:120:R   + [002]  5882: 94:R sleep
> +  <idle>-0       2d.h4    0us : ttwu_do_activate.constprop.87 <-try_to_wake_up
> +  <idle>-0       2d.h4    1us : sched_wakeup: comm=sleep pid=5882 prio=94 success=1 target_cpu=002
> +  <idle>-0       2dNh2    1us : hrtimer_expire_exit: hrtimer=ffff88007796feb8
> +  <idle>-0       2.N.2    2us : power_end: cpu_id=2
> +  <idle>-0       2.N.2    3us : cpu_idle: state=4294967295 cpu_id=2
> +  <idle>-0       2dN.3    4us : hrtimer_cancel: hrtimer=ffff88007d50d5e0
> +  <idle>-0       2dN.3    4us : hrtimer_start: hrtimer=ffff88007d50d5e0 function=tick_sched_timer expires=34311211000000 softexpires=34311211000000
> +  <idle>-0       2.N.2    5us : rcu_utilization: Start context switch
> +  <idle>-0       2.N.2    5us : rcu_utilization: End context switch
> +  <idle>-0       2d..3    6us : __schedule <-schedule
> +  <idle>-0       2d..3    6us :      0:120:R ==> [002]  5882: 94:R sleep
> +
>  
>  function
>  --------
> @@ -1039,6 +1653,7 @@ function
>  This tracer is the function tracer. Enabling the function tracer
>  can be done from the debug file system. Make sure the
>  ftrace_enabled is set; otherwise this tracer is a nop.
> +See the "ftrace_enabled" section below.
>  
>   # sysctl kernel.ftrace_enabled=1
>   # echo function > current_tracer
> @@ -1048,23 +1663,23 @@ ftrace_enabled is set; otherwise this tracer is a nop.
>   # cat trace
>  # tracer: function
>  #
> -#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> -#              | |      |          |         |
> -            bash-4003  [00]   123.638713: finish_task_switch <-schedule
> -            bash-4003  [00]   123.638714: _spin_unlock_irq <-finish_task_switch
> -            bash-4003  [00]   123.638714: sub_preempt_count <-_spin_unlock_irq
> -            bash-4003  [00]   123.638715: hrtick_set <-schedule
> -            bash-4003  [00]   123.638715: _spin_lock_irqsave <-hrtick_set
> -            bash-4003  [00]   123.638716: add_preempt_count <-_spin_lock_irqsave
> -            bash-4003  [00]   123.638716: _spin_unlock_irqrestore <-hrtick_set
> -            bash-4003  [00]   123.638717: sub_preempt_count <-_spin_unlock_irqrestore
> -            bash-4003  [00]   123.638717: hrtick_clear <-hrtick_set
> -            bash-4003  [00]   123.638718: sub_preempt_count <-schedule
> -            bash-4003  [00]   123.638718: sub_preempt_count <-preempt_schedule
> -            bash-4003  [00]   123.638719: wait_for_completion <-__stop_machine_run
> -            bash-4003  [00]   123.638719: wait_for_common <-wait_for_completion
> -            bash-4003  [00]   123.638720: _spin_lock_irq <-wait_for_common
> -            bash-4003  [00]   123.638720: add_preempt_count <-_spin_lock_irq
> +# entries-in-buffer/entries-written: 24799/24799   #P:4
> +#
> +#                              _-----=> irqs-off
> +#                             / _----=> need-resched
> +#                            | / _---=> hardirq/softirq
> +#                            || / _--=> preempt-depth
> +#                            ||| /     delay
> +#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> +#              | |       |   ||||       |         |
> +            bash-1994  [002] ....  3082.063030: mutex_unlock <-rb_simple_write
> +            bash-1994  [002] ....  3082.063031: __mutex_unlock_slowpath <-mutex_unlock
> +            bash-1994  [002] ....  3082.063031: __fsnotify_parent <-fsnotify_modify
> +            bash-1994  [002] ....  3082.063032: fsnotify <-fsnotify_modify
> +            bash-1994  [002] ....  3082.063032: __srcu_read_lock <-fsnotify
> +            bash-1994  [002] ....  3082.063032: add_preempt_count <-__srcu_read_lock
> +            bash-1994  [002] ...1  3082.063032: sub_preempt_count <-__srcu_read_lock
> +            bash-1994  [002] ....  3082.063033: __srcu_read_unlock <-fsnotify
>  [...]
>  
> 
> @@ -1214,79 +1829,19 @@ int main (int argc, char **argv)
>          return 0;
>  }
>  
> +Or this simple script!
>  
> -hw-branch-tracer (x86 only)
> ----------------------------
> -
> -This tracer uses the x86 last branch tracing hardware feature to
> -collect a branch trace on all cpus with relatively low overhead.
> -
> -The tracer uses a fixed-size circular buffer per cpu and only
> -traces ring 0 branches. The trace file dumps that buffer in the
> -following format:
> -
> -# tracer: hw-branch-tracer
> -#
> -# CPU#        TO  <-  FROM
> -   0  scheduler_tick+0xb5/0x1bf	  <-  task_tick_idle+0x5/0x6
> -   2  run_posix_cpu_timers+0x2b/0x72a	  <-  run_posix_cpu_timers+0x25/0x72a
> -   0  scheduler_tick+0x139/0x1bf	  <-  scheduler_tick+0xed/0x1bf
> -   0  scheduler_tick+0x17c/0x1bf	  <-  scheduler_tick+0x148/0x1bf
> -   2  run_posix_cpu_timers+0x9e/0x72a	  <-  run_posix_cpu_timers+0x5e/0x72a
> -   0  scheduler_tick+0x1b6/0x1bf	  <-  scheduler_tick+0x1aa/0x1bf
> -
> -
> -The tracer may be used to dump the trace for the oops'ing cpu on
> -a kernel oops into the system log. To enable this,
> -ftrace_dump_on_oops must be set. To set ftrace_dump_on_oops, one
> -can either use the sysctl function or set it via the proc system
> -interface.
> -
> -  sysctl kernel.ftrace_dump_on_oops=n
> -
> -or
> -
> -  echo n > /proc/sys/kernel/ftrace_dump_on_oops
> -
> -If n = 1, ftrace will dump buffers of all CPUs, if n = 2 ftrace will
> -only dump the buffer of the CPU that triggered the oops.
> -
> -Here's an example of such a dump after a null pointer
> -dereference in a kernel module:
> -
> -[57848.105921] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> -[57848.106019] IP: [<ffffffffa0000006>] open+0x6/0x14 [oops]
> -[57848.106019] PGD 2354e9067 PUD 2375e7067 PMD 0
> -[57848.106019] Oops: 0002 [#1] SMP
> -[57848.106019] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:20:05.0/local_cpus
> -[57848.106019] Dumping ftrace buffer:
> -[57848.106019] ---------------------------------
> -[...]
> -[57848.106019]    0  chrdev_open+0xe6/0x165	  <-  cdev_put+0x23/0x24
> -[57848.106019]    0  chrdev_open+0x117/0x165	  <-  chrdev_open+0xfa/0x165
> -[57848.106019]    0  chrdev_open+0x120/0x165	  <-  chrdev_open+0x11c/0x165
> -[57848.106019]    0  chrdev_open+0x134/0x165	  <-  chrdev_open+0x12b/0x165
> -[57848.106019]    0  open+0x0/0x14 [oops]	  <-  chrdev_open+0x144/0x165
> -[57848.106019]    0  page_fault+0x0/0x30	  <-  open+0x6/0x14 [oops]
> -[57848.106019]    0  error_entry+0x0/0x5b	  <-  page_fault+0x4/0x30
> -[57848.106019]    0  error_kernelspace+0x0/0x31	  <-  error_entry+0x59/0x5b
> -[57848.106019]    0  error_sti+0x0/0x1	  <-  error_kernelspace+0x2d/0x31
> -[57848.106019]    0  page_fault+0x9/0x30	  <-  error_sti+0x0/0x1
> -[57848.106019]    0  do_page_fault+0x0/0x881	  <-  page_fault+0x1a/0x30
> -[...]
> -[57848.106019]    0  do_page_fault+0x66b/0x881	  <-  is_prefetch+0x1ee/0x1f2
> -[57848.106019]    0  do_page_fault+0x6e0/0x881	  <-  do_page_fault+0x67a/0x881
> -[57848.106019]    0  oops_begin+0x0/0x96	  <-  do_page_fault+0x6e0/0x881
> -[57848.106019]    0  trace_hw_branch_oops+0x0/0x2d	  <-  oops_begin+0x9/0x96
> -[...]
> -[57848.106019]    0  ds_suspend_bts+0x2a/0xe3	  <-  ds_suspend_bts+0x1a/0xe3
> -[57848.106019] ---------------------------------
> -[57848.106019] CPU 0
> -[57848.106019] Modules linked in: oops
> -[57848.106019] Pid: 5542, comm: cat Tainted: G        W  2.6.28 #23
> -[57848.106019] RIP: 0010:[<ffffffffa0000006>]  [<ffffffffa0000006>] open+0x6/0x14 [oops]
> -[57848.106019] RSP: 0018:ffff880235457d48  EFLAGS: 00010246
> -[...]
> +------
> +#!/bin/bash
> +
> +debugfs=`sed -ne 's/^debugfs \(.*\) debugfs.*/\1/p' /proc/mounts`
> +echo nop > $debugfs/tracing/current_tracer
> +echo 0 > $debugfs/tracing/tracing_on
> +echo $$ > $debugfs/tracing/set_ftrace_pid
> +echo function > $debugfs/tracing/current_tracer
> +echo 1 > $debugfs/tracing/tracing_on
> +exec "$@"
> +------
>  
> 
>  function graph tracer
> @@ -1473,16 +2028,18 @@ starts of pointing to a simple return. (Enabling FTRACE will
>  include the -pg switch in the compiling of the kernel.)
>  
>  At compile time every C file object is run through the
> -recordmcount.pl script (located in the scripts directory). This
> -script will process the C object using objdump to find all the
> -locations in the .text section that call mcount. (Note, only the
> -.text section is processed, since processing other sections like
> -.init.text may cause races due to those sections being freed).
> +recordmcount program (located in the scripts directory). This
> +program will parse the ELF headers in the C object to find all
> +the locations in the .text section that call mcount. (Note, only
> +white listed .text sections are processed, since processing other
> +sections like .init.text may cause races due to those sections
> +being freed unexpectedly).
>  
>  A new section called "__mcount_loc" is created that holds
>  references to all the mcount call sites in the .text section.
> -This section is compiled back into the original object. The
> -final linker will add all these references into a single table.
> +The recordmcount program re-links this section back into the
> +original object. The final linking stage of the kernel will add all these
> +references into a single table.
>  
>  On boot up, before SMP is initialized, the dynamic ftrace code
>  scans this table and updates all the locations into nops. It
> @@ -1493,13 +2050,25 @@ unloaded, it also removes its functions from the ftrace function
>  list. This is automatic in the module unload code, and the
>  module author does not need to worry about it.
>  
> -When tracing is enabled, kstop_machine is called to prevent
> -races with the CPUS executing code being modified (which can
> -cause the CPU to do undesirable things), and the nops are
> +When tracing is enabled, the process of modifying the function
> +tracepoints is dependent on architecture. The old method is to use
> +kstop_machine to prevent races with the CPUs executing code being
> +modified (which can cause the CPU to do undesirable things, especially
> +if the modified code crosses cache (or page) boundaries), and the nops are
>  patched back to calls. But this time, they do not call mcount
>  (which is just a function stub). They now call into the ftrace
>  infrastructure.
>  
> +The new method of modifying the function tracepoints is to place
> +a breakpoint at the location to be modified, sync all CPUs, modify
> +the rest of the instruction not covered by the breakpoint. Sync
> +all CPUs again, and then remove the breakpoint with the finished
> +version to the ftrace call site.
> +
> +Some archs do not even need to monkey around with the synchronization,
> +and can just slap the new code on top of the old without any
> +problems with other CPUs executing it at the same time.
> +
>  One special side-effect to the recording of the functions being
>  traced is that we can now selectively choose which functions we
>  wish to trace and which ones we want the mcount calls to remain
> @@ -1530,20 +2099,28 @@ mutex_lock
>  
>  If I am only interested in sys_nanosleep and hrtimer_interrupt:
>  
> - # echo sys_nanosleep hrtimer_interrupt \
> -		> set_ftrace_filter
> + # echo sys_nanosleep hrtimer_interrupt > set_ftrace_filter
>   # echo function > current_tracer
>   # echo 1 > tracing_on
>   # usleep 1
>   # echo 0 > tracing_on
>   # cat trace
> -# tracer: ftrace
> +# tracer: function
> +#
> +# entries-in-buffer/entries-written: 5/5   #P:4
>  #
> -#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> -#              | |      |          |         |
> -          usleep-4134  [00]  1317.070017: hrtimer_interrupt <-smp_apic_timer_interrupt
> -          usleep-4134  [00]  1317.070111: sys_nanosleep <-syscall_call
> -          <idle>-0     [00]  1317.070115: hrtimer_interrupt <-smp_apic_timer_interrupt
> +#                              _-----=> irqs-off
> +#                             / _----=> need-resched
> +#                            | / _---=> hardirq/softirq
> +#                            || / _--=> preempt-depth
> +#                            ||| /     delay
> +#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> +#              | |       |   ||||       |         |
> +          usleep-2665  [001] ....  4186.475355: sys_nanosleep <-system_call_fastpath
> +          <idle>-0     [001] d.h1  4186.475409: hrtimer_interrupt <-smp_apic_timer_interrupt
> +          usleep-2665  [001] d.h1  4186.475426: hrtimer_interrupt <-smp_apic_timer_interrupt
> +          <idle>-0     [003] d.h1  4186.475426: hrtimer_interrupt <-smp_apic_timer_interrupt
> +          <idle>-0     [002] d.h1  4186.475427: hrtimer_interrupt <-smp_apic_timer_interrupt
>  
>  To see which functions are being traced, you can cat the file:
>  
> @@ -1571,20 +2148,25 @@ Note: It is better to use quotes to enclose the wild cards,
>  
>  Produces:
>  
> -# tracer: ftrace
> +# tracer: function
>  #
> -#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> -#              | |      |          |         |
> -            bash-4003  [00]  1480.611794: hrtimer_init <-copy_process
> -            bash-4003  [00]  1480.611941: hrtimer_start <-hrtick_set
> -            bash-4003  [00]  1480.611956: hrtimer_cancel <-hrtick_clear
> -            bash-4003  [00]  1480.611956: hrtimer_try_to_cancel <-hrtimer_cancel
> -          <idle>-0     [00]  1480.612019: hrtimer_get_next_event <-get_next_timer_interrupt
> -          <idle>-0     [00]  1480.612025: hrtimer_get_next_event <-get_next_timer_interrupt
> -          <idle>-0     [00]  1480.612032: hrtimer_get_next_event <-get_next_timer_interrupt
> -          <idle>-0     [00]  1480.612037: hrtimer_get_next_event <-get_next_timer_interrupt
> -          <idle>-0     [00]  1480.612382: hrtimer_get_next_event <-get_next_timer_interrupt
> -
> +# entries-in-buffer/entries-written: 897/897   #P:4
> +#
> +#                              _-----=> irqs-off
> +#                             / _----=> need-resched
> +#                            | / _---=> hardirq/softirq
> +#                            || / _--=> preempt-depth
> +#                            ||| /     delay
> +#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> +#              | |       |   ||||       |         |
> +          <idle>-0     [003] dN.1  4228.547803: hrtimer_cancel <-tick_nohz_idle_exit
> +          <idle>-0     [003] dN.1  4228.547804: hrtimer_try_to_cancel <-hrtimer_cancel
> +          <idle>-0     [003] dN.2  4228.547805: hrtimer_force_reprogram <-__remove_hrtimer
> +          <idle>-0     [003] dN.1  4228.547805: hrtimer_forward <-tick_nohz_idle_exit
> +          <idle>-0     [003] dN.1  4228.547805: hrtimer_start_range_ns <-hrtimer_start_expires.constprop.11
> +          <idle>-0     [003] d..1  4228.547858: hrtimer_get_next_event <-get_next_timer_interrupt
> +          <idle>-0     [003] d..1  4228.547859: hrtimer_start <-__tick_nohz_idle_enter
> +          <idle>-0     [003] d..2  4228.547860: hrtimer_force_reprogram <-__rem
>  
>  Notice that we lost the sys_nanosleep.
>  
> @@ -1651,19 +2233,29 @@ traced.
>  
>  Produces:
>  
> -# tracer: ftrace
> +# tracer: function
> +#
> +# entries-in-buffer/entries-written: 39608/39608   #P:4
>  #
> -#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> -#              | |      |          |         |
> -            bash-4043  [01]   115.281644: finish_task_switch <-schedule
> -            bash-4043  [01]   115.281645: hrtick_set <-schedule
> -            bash-4043  [01]   115.281645: hrtick_clear <-hrtick_set
> -            bash-4043  [01]   115.281646: wait_for_completion <-__stop_machine_run
> -            bash-4043  [01]   115.281647: wait_for_common <-wait_for_completion
> -            bash-4043  [01]   115.281647: kthread_stop <-stop_machine_run
> -            bash-4043  [01]   115.281648: init_waitqueue_head <-kthread_stop
> -            bash-4043  [01]   115.281648: wake_up_process <-kthread_stop
> -            bash-4043  [01]   115.281649: try_to_wake_up <-wake_up_process
> +#                              _-----=> irqs-off
> +#                             / _----=> need-resched
> +#                            | / _---=> hardirq/softirq
> +#                            || / _--=> preempt-depth
> +#                            ||| /     delay
> +#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> +#              | |       |   ||||       |         |
> +            bash-1994  [000] ....  4342.324896: file_ra_state_init <-do_dentry_open
> +            bash-1994  [000] ....  4342.324897: open_check_o_direct <-do_last
> +            bash-1994  [000] ....  4342.324897: ima_file_check <-do_last
> +            bash-1994  [000] ....  4342.324898: process_measurement <-ima_file_check
> +            bash-1994  [000] ....  4342.324898: ima_get_action <-process_measurement
> +            bash-1994  [000] ....  4342.324898: ima_match_policy <-ima_get_action
> +            bash-1994  [000] ....  4342.324899: do_truncate <-do_last
> +            bash-1994  [000] ....  4342.324899: should_remove_suid <-do_truncate
> +            bash-1994  [000] ....  4342.324899: notify_change <-do_truncate
> +            bash-1994  [000] ....  4342.324900: current_fs_time <-notify_change
> +            bash-1994  [000] ....  4342.324900: current_kernel_time <-current_fs_time
> +            bash-1994  [000] ....  4342.324900: timespec_trunc <-current_fs_time
>  
>  We can see that there's no more lock or preempt tracing.
>  
> @@ -1729,6 +2321,28 @@ this special filter via:
>   echo > set_graph_function
>  
> 
> +ftrace_enabled
> +--------------
> +
> +Note, the proc sysctl ftrace_enable is a big on/off switch for the
> +function tracer. By default it is enabled (when function tracing is
> +enabled in the kernel). If it is disabled, all function tracing is
> +disabled. This includes not only the function tracers for ftrace, but
> +also for any other uses (perf, kprobes, stack tracing, profiling, etc).
> +
> +Please disable this with care.
> +
> +This can be disable (and enabled) with:
> +
> +  sysctl kernel.ftrace_enabled=0
> +  sysctl kernel.ftrace_enabled=1
> +
> + or
> +
> +  echo 0 > /proc/sys/kernel/ftrace_enabled
> +  echo 1 > /proc/sys/kernel/ftrace_enabled
> +
> +
>  Filter commands
>  ---------------
>  
> @@ -1763,12 +2377,58 @@ The following commands are supported:
>  
>     echo '__schedule_bug:traceoff:5' > set_ftrace_filter
>  
> +  To always disable tracing when __schedule_bug is hit:
> +
> +   echo '__schedule_bug:traceoff' > set_ftrace_filter
> +
>    These commands are cumulative whether or not they are appended
>    to set_ftrace_filter. To remove a command, prepend it by '!'
>    and drop the parameter:
>  
> +   echo '!__schedule_bug:traceoff:0' > set_ftrace_filter
> +
> +    The above removes the traceoff command for __schedule_bug
> +    that have a counter. To remove commands without counters:
> +
>     echo '!__schedule_bug:traceoff' > set_ftrace_filter
>  
> +- snapshot
> +  Will cause a snapshot to be triggered when the function is hit.
> +
> +   echo 'native_flush_tlb_others:snapshot' > set_ftrace_filter
> +
> +  To only snapshot once:
> +
> +   echo 'native_flush_tlb_others:snapshot:1' > set_ftrace_filter
> +
> +  To remove the above commands:
> +
> +   echo '!native_flush_tlb_others:snapshot' > set_ftrace_filter
> +   echo '!native_flush_tlb_others:snapshot:0' > set_ftrace_filter
> +
> +- enable_event/disable_event
> +  These commands can enable or disable a trace event. Note, because
> +  function tracing callbacks are very sensitive, when these commands
> +  are registered, the trace point is activated, but disabled in
> +  a "soft" mode. That is, the tracepoint will be called, but
> +  just will not be traced. The event tracepoint stays in this mode
> +  as long as there's a command that triggers it.
> +
> +   echo 'try_to_wake_up:enable_event:sched:sched_switch:2' > \
> +   	 set_ftrace_filter
> +
> +  The format is:
> +
> +    <function>:enable_event:<system>:<event>[:count]
> +    <function>:disable_event:<system>:<event>[:count]
> +
> +  To remove the events commands:
> +
> +
> +   echo '!try_to_wake_up:enable_event:sched:sched_switch:0' > \
> +   	 set_ftrace_filter
> +   echo '!schedule:disable_event:sched:sched_switch' > \
> +   	 set_ftrace_filter
>  
>  trace_pipe
>  ----------
> @@ -1787,28 +2447,31 @@ different. The trace is live.
>   # cat trace
>  # tracer: function
>  #
> -#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> -#              | |      |          |         |
> +# entries-in-buffer/entries-written: 0/0   #P:4
> +#
> +#                              _-----=> irqs-off
> +#                             / _----=> need-resched
> +#                            | / _---=> hardirq/softirq
> +#                            || / _--=> preempt-depth
> +#                            ||| /     delay
> +#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> +#              | |       |   ||||       |         |
>  
>   #
>   # cat /tmp/trace.out
> -            bash-4043  [00] 41.267106: finish_task_switch <-schedule
> -            bash-4043  [00] 41.267106: hrtick_set <-schedule
> -            bash-4043  [00] 41.267107: hrtick_clear <-hrtick_set
> -            bash-4043  [00] 41.267108: wait_for_completion <-__stop_machine_run
> -            bash-4043  [00] 41.267108: wait_for_common <-wait_for_completion
> -            bash-4043  [00] 41.267109: kthread_stop <-stop_machine_run
> -            bash-4043  [00] 41.267109: init_waitqueue_head <-kthread_stop
> -            bash-4043  [00] 41.267110: wake_up_process <-kthread_stop
> -            bash-4043  [00] 41.267110: try_to_wake_up <-wake_up_process
> -            bash-4043  [00] 41.267111: select_task_rq_rt <-try_to_wake_up
> +            bash-1994  [000] ....  5281.568961: mutex_unlock <-rb_simple_write
> +            bash-1994  [000] ....  5281.568963: __mutex_unlock_slowpath <-mutex_unlock
> +            bash-1994  [000] ....  5281.568963: __fsnotify_parent <-fsnotify_modify
> +            bash-1994  [000] ....  5281.568964: fsnotify <-fsnotify_modify
> +            bash-1994  [000] ....  5281.568964: __srcu_read_lock <-fsnotify
> +            bash-1994  [000] ....  5281.568964: add_preempt_count <-__srcu_read_lock
> +            bash-1994  [000] ...1  5281.568965: sub_preempt_count <-__srcu_read_lock
> +            bash-1994  [000] ....  5281.568965: __srcu_read_unlock <-fsnotify
> +            bash-1994  [000] ....  5281.568967: sys_dup2 <-system_call_fastpath
>  
> 
>  Note, reading the trace_pipe file will block until more input is
> -added. By changing the tracer, trace_pipe will issue an EOF. We
> -needed to set the function tracer _before_ we "cat" the
> -trace_pipe file.
> -
> +added.
>  
>  trace entries
>  -------------
> @@ -1817,31 +2480,50 @@ Having too much or not enough data can be troublesome in
>  diagnosing an issue in the kernel. The file buffer_size_kb is
>  used to modify the size of the internal trace buffers. The
>  number listed is the number of entries that can be recorded per
> -CPU. To know the full size, multiply the number of possible CPUS
> +CPU. To know the full size, multiply the number of possible CPUs
>  with the number of entries.
>  
>   # cat buffer_size_kb
>  1408 (units kilobytes)
>  
> -Note, to modify this, you must have tracing completely disabled.
> -To do that, echo "nop" into the current_tracer. If the
> -current_tracer is not set to "nop", an EINVAL error will be
> -returned.
> +Or simply read buffer_total_size_kb
> +
> + # cat buffer_total_size_kb 
> +5632
> +
> +To modify the buffer, simple echo in a number (in 1024 byte segments).
>  
> - # echo nop > current_tracer
>   # echo 10000 > buffer_size_kb
>   # cat buffer_size_kb
>  10000 (units kilobytes)
>  
> -The number of pages which will be allocated is limited to a
> -percentage of available memory. Allocating too much will produce
> -an error.
> +It will try to allocate as much as possible. If you allocate too
> +much, it can cause Out-Of-Memory to trigger.
>  
>   # echo 1000000000000 > buffer_size_kb
>  -bash: echo: write error: Cannot allocate memory
>   # cat buffer_size_kb
>  85
>  
> +The per_cpu buffers can be changed individually as well:
> +
> + # echo 10000 > per_cpu/cpu0/buffer_size_kb
> + # echo 100 > per_cpu/cpu1/buffer_size_kb
> +
> +When the per_cpu buffers are not the same, the buffer_size_kb
> +at the top level will just show an X
> +
> + # cat buffer_size_kb
> +X
> +
> +This is where the buffer_total_size_kb is useful:
> +
> + # cat buffer_total_size_kb 
> +12916
> +
> +Writing to the top level buffer_size_kb will reset all the buffers
> +to be the same again.
> +
>  Snapshot
>  --------
>  CONFIG_TRACER_SNAPSHOT makes a generic snapshot feature
> @@ -1925,7 +2607,188 @@ bash: echo: write error: Device or resource busy
>   # cat snapshot
>  cat: snapshot: Device or resource busy
>  
> +
> +Instances
> +---------
> +In the debugfs tracing directory is a directory called "instances".
> +This directory can have new directories created inside of it using
> +mkdir, and removing directories with rmdir. The directory created
> +with mkdir in this directory will already contain files and other
> +directories after it is created.
> +
> + # mkdir instances/foo
> + # ls instances/foo
> +buffer_size_kb  buffer_total_size_kb  events  free_buffer  per_cpu
> +set_event  snapshot  trace  trace_clock  trace_marker  trace_options
> +trace_pipe  tracing_on
> +
> +As you can see, the new directory looks similar to the tracing directory
> +itself. In fact, it is very similar, except that the buffer and
> +events are agnostic from the main director, or from any other
> +instances that are created.
> +
> +The files in the new directory work just like the files with the
> +same name in the tracing directory except the buffer that is used
> +is a separate and new buffer. The files affect that buffer but do not
> +affect the main buffer with the exception of trace_options. Currently,
> +the trace_options affect all instances and the top level buffer
> +the same, but this may change in future releases. That is, options
> +may become specific to the instance they reside in.
> +
> +Notice that none of the function tracer files are there, nor is
> +current_tracer and available_tracers. This is because the buffers
> +can currently only have events enabled for them.
> +
> + # mkdir instances/foo
> + # mkdir instances/bar
> + # mkdir instances/zoot
> + # echo 100000 > buffer_size_kb
> + # echo 1000 > instances/foo/buffer_size_kb
> + # echo 5000 > instances/bar/per_cpu/cpu1/buffer_size_kb
> + # echo function > current_trace
> + # echo 1 > instances/foo/events/sched/sched_wakeup/enable
> + # echo 1 > instances/foo/events/sched/sched_wakeup_new/enable
> + # echo 1 > instances/foo/events/sched/sched_switch/enable
> + # echo 1 > instances/bar/events/irq/enable
> + # echo 1 > instances/zoot/events/syscalls/enable
> + # cat trace_pipe
> +CPU:2 [LOST 11745 EVENTS]
> +            bash-2044  [002] .... 10594.481032: _raw_spin_lock_irqsave <-get_page_from_freelist
> +            bash-2044  [002] d... 10594.481032: add_preempt_count <-_raw_spin_lock_irqsave
> +            bash-2044  [002] d..1 10594.481032: __rmqueue <-get_page_from_freelist
> +            bash-2044  [002] d..1 10594.481033: _raw_spin_unlock <-get_page_from_freelist
> +            bash-2044  [002] d..1 10594.481033: sub_preempt_count <-_raw_spin_unlock
> +            bash-2044  [002] d... 10594.481033: get_pageblock_flags_group <-get_pageblock_migratetype
> +            bash-2044  [002] d... 10594.481034: __mod_zone_page_state <-get_page_from_freelist
> +            bash-2044  [002] d... 10594.481034: zone_statistics <-get_page_from_freelist
> +            bash-2044  [002] d... 10594.481034: __inc_zone_state <-zone_statistics
> +            bash-2044  [002] d... 10594.481034: __inc_zone_state <-zone_statistics
> +            bash-2044  [002] .... 10594.481035: arch_dup_task_struct <-copy_process
> +[...]
> +
> + # cat instances/foo/trace_pipe
> +            bash-1998  [000] d..4   136.676759: sched_wakeup: comm=kworker/0:1 pid=59 prio=120 success=1 target_cpu=000
> +            bash-1998  [000] dN.4   136.676760: sched_wakeup: comm=bash pid=1998 prio=120 success=1 target_cpu=000
> +          <idle>-0     [003] d.h3   136.676906: sched_wakeup: comm=rcu_preempt pid=9 prio=120 success=1 target_cpu=003
> +          <idle>-0     [003] d..3   136.676909: sched_switch: prev_comm=swapper/3 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=rcu_preempt next_pid=9 next_prio=120
> +     rcu_preempt-9     [003] d..3   136.676916: sched_switch: prev_comm=rcu_preempt prev_pid=9 prev_prio=120 prev_state=S ==> next_comm=swapper/3 next_pid=0 next_prio=120
> +            bash-1998  [000] d..4   136.677014: sched_wakeup: comm=kworker/0:1 pid=59 prio=120 success=1 target_cpu=000
> +            bash-1998  [000] dN.4   136.677016: sched_wakeup: comm=bash pid=1998 prio=120 success=1 target_cpu=000
> +            bash-1998  [000] d..3   136.677018: sched_switch: prev_comm=bash prev_pid=1998 prev_prio=120 prev_state=R+ ==> next_comm=kworker/0:1 next_pid=59 next_prio=120
> +     kworker/0:1-59    [000] d..4   136.677022: sched_wakeup: comm=sshd pid=1995 prio=120 success=1 target_cpu=001
> +     kworker/0:1-59    [000] d..3   136.677025: sched_switch: prev_comm=kworker/0:1 prev_pid=59 prev_prio=120 prev_state=S ==> next_comm=bash next_pid=1998 next_prio=120
> +[...]
> +
> + # cat instances/bar/trace_pipe
> +     migration/1-14    [001] d.h3   138.732674: softirq_raise: vec=3 [action=NET_RX]
> +          <idle>-0     [001] dNh3   138.732725: softirq_raise: vec=3 [action=NET_RX]
> +            bash-1998  [000] d.h1   138.733101: softirq_raise: vec=1 [action=TIMER]
> +            bash-1998  [000] d.h1   138.733102: softirq_raise: vec=9 [action=RCU]
> +            bash-1998  [000] ..s2   138.733105: softirq_entry: vec=1 [action=TIMER]
> +            bash-1998  [000] ..s2   138.733106: softirq_exit: vec=1 [action=TIMER]
> +            bash-1998  [000] ..s2   138.733106: softirq_entry: vec=9 [action=RCU]
> +            bash-1998  [000] ..s2   138.733109: softirq_exit: vec=9 [action=RCU]
> +            sshd-1995  [001] d.h1   138.733278: irq_handler_entry: irq=21 name=uhci_hcd:usb4
> +            sshd-1995  [001] d.h1   138.733280: irq_handler_exit: irq=21 ret=unhandled
> +            sshd-1995  [001] d.h1   138.733281: irq_handler_entry: irq=21 name=eth0
> +            sshd-1995  [001] d.h1   138.733283: irq_handler_exit: irq=21 ret=handled
> +[...]
> +
> + # cat instances/zoot/trace
> +# tracer: nop
> +#
> +# entries-in-buffer/entries-written: 18996/18996   #P:4
> +#
> +#                              _-----=> irqs-off
> +#                             / _----=> need-resched
> +#                            | / _---=> hardirq/softirq
> +#                            || / _--=> preempt-depth
> +#                            ||| /     delay
> +#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> +#              | |       |   ||||       |         |
> +            bash-1998  [000] d...   140.733501: sys_write -> 0x2
> +            bash-1998  [000] d...   140.733504: sys_dup2(oldfd: a, newfd: 1)
> +            bash-1998  [000] d...   140.733506: sys_dup2 -> 0x1
> +            bash-1998  [000] d...   140.733508: sys_fcntl(fd: a, cmd: 1, arg: 0)
> +            bash-1998  [000] d...   140.733509: sys_fcntl -> 0x1
> +            bash-1998  [000] d...   140.733510: sys_close(fd: a)
> +            bash-1998  [000] d...   140.733510: sys_close -> 0x0
> +            bash-1998  [000] d...   140.733514: sys_rt_sigprocmask(how: 0, nset: 0, oset: 6e2768, sigsetsize: 8)
> +            bash-1998  [000] d...   140.733515: sys_rt_sigprocmask -> 0x0
> +            bash-1998  [000] d...   140.733516: sys_rt_sigaction(sig: 2, act: 7fff718846f0, oact: 7fff71884650, sigsetsize: 8)
> +            bash-1998  [000] d...   140.733516: sys_rt_sigaction -> 0x0
> +
> +You can see that the trace of the top most trace buffer shows only
> +the function tracing. The foo instance displays wakeups and task
> +switches.
> +
> +To remove the instances, simply delete their directories:
> +
> + # rmdir instances/foo
> + # rmdir instances/bar
> + # rmdir instances/zoot
> +
> +Note, if a process has a trace file open in one of the instance
> +directories, the rmdir will fail with EBUSY.
> +
> +
> +Stack trace
>  -----------
> +Since the kernel has a fixed sized stack, it is important not to
> +waste it in functions. A kernel developer must be conscience of
> +what they allocate on the stack. If they add too much, the system
> +can be in danger of a stack overflow, and corruption will occur,
> +usually leading to a system panic.
> +
> +There are some tools that check this, usually with interrupts
> +periodically checking usage. But if you can perform a check
> +at every function call that will become very useful. As ftrace provides
> +a function tracer, it makes it convenient to check the stack size
> +at every function call. This is enabled via the stack tracer.
> +
> +CONFIG_STACK_TRACER enables the ftrace stack tracing functionality.
> +To enable it, write a '1' into /proc/sys/kernel/stack_tracer_enabled.
> +
> + # echo 1 > /proc/sys/kernel/stack_tracer_enabled
> +
> +You can also enable it from the kernel command line to trace
> +the stack size of the kernel during boot up, by adding "stacktrace"
> +to the kernel command line parameter.
> +
> +After running it for a few minutes, the output looks like:
> +
> + # cat stack_max_size
> +2928
> +
> + # cat stack_trace
> +        Depth    Size   Location    (18 entries)
> +        -----    ----   --------
> +  0)     2928     224   update_sd_lb_stats+0xbc/0x4ac
> +  1)     2704     160   find_busiest_group+0x31/0x1f1
> +  2)     2544     256   load_balance+0xd9/0x662
> +  3)     2288      80   idle_balance+0xbb/0x130
> +  4)     2208     128   __schedule+0x26e/0x5b9
> +  5)     2080      16   schedule+0x64/0x66
> +  6)     2064     128   schedule_timeout+0x34/0xe0
> +  7)     1936     112   wait_for_common+0x97/0xf1
> +  8)     1824      16   wait_for_completion+0x1d/0x1f
> +  9)     1808     128   flush_work+0xfe/0x119
> + 10)     1680      16   tty_flush_to_ldisc+0x1e/0x20
> + 11)     1664      48   input_available_p+0x1d/0x5c
> + 12)     1616      48   n_tty_poll+0x6d/0x134
> + 13)     1568      64   tty_poll+0x64/0x7f
> + 14)     1504     880   do_select+0x31e/0x511
> + 15)      624     400   core_sys_select+0x177/0x216
> + 16)      224      96   sys_select+0x91/0xb9
> + 17)      128     128   system_call_fastpath+0x16/0x1b
> +
> +Note, if -mfentry is being used by gcc, functions get traced before
> +they set up the stack frame. This means that leaf level functions
> +are not tested by the stack tracer when -mfentry is used.
> +
> +Currently, -mfentry is used by gcc 4.6.0 and above on x86 only.
> +
> +---------
>  
>  More details can be found in the source code, in the
>  kernel/trace/*.c files.
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index e5ca8ef..832422d 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -259,8 +259,10 @@ struct ftrace_probe_ops {
>  	void			(*func)(unsigned long ip,
>  					unsigned long parent_ip,
>  					void **data);
> -	int			(*callback)(unsigned long ip, void **data);
> -	void			(*free)(void **data);
> +	int			(*init)(struct ftrace_probe_ops *ops,
> +					unsigned long ip, void **data);
> +	void			(*free)(struct ftrace_probe_ops *ops,
> +					unsigned long ip, void **data);
>  	int			(*print)(struct seq_file *m,
>  					 unsigned long ip,
>  					 struct ftrace_probe_ops *ops,
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 13a54d0..4e28b01 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -8,6 +8,7 @@
>  #include <linux/perf_event.h>
>  
>  struct trace_array;
> +struct trace_buffer;
>  struct tracer;
>  struct dentry;
>  
> @@ -38,6 +39,12 @@ const char *ftrace_print_symbols_seq_u64(struct trace_seq *p,
>  const char *ftrace_print_hex_seq(struct trace_seq *p,
>  				 const unsigned char *buf, int len);
>  
> +struct trace_iterator;
> +struct trace_event;
> +
> +int ftrace_raw_output_prep(struct trace_iterator *iter,
> +			   struct trace_event *event);
> +
>  /*
>   * The trace entry - the most basic unit of tracing. This is what
>   * is printed in the end as a single line in the trace output, such as:
> @@ -61,6 +68,7 @@ struct trace_entry {
>  struct trace_iterator {
>  	struct trace_array	*tr;
>  	struct tracer		*trace;
> +	struct trace_buffer	*trace_buffer;
>  	void			*private;
>  	int			cpu_file;
>  	struct mutex		mutex;
> @@ -95,8 +103,6 @@ enum trace_iter_flags {
>  };
>  
> 
> -struct trace_event;
> -
>  typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
>  				      int flags, struct trace_event *event);
>  
> @@ -128,6 +134,13 @@ enum print_line_t {
>  void tracing_generic_entry_update(struct trace_entry *entry,
>  				  unsigned long flags,
>  				  int pc);
> +struct ftrace_event_file;
> +
> +struct ring_buffer_event *
> +trace_event_buffer_lock_reserve(struct ring_buffer **current_buffer,
> +				struct ftrace_event_file *ftrace_file,
> +				int type, unsigned long len,
> +				unsigned long flags, int pc);
>  struct ring_buffer_event *
>  trace_current_buffer_lock_reserve(struct ring_buffer **current_buffer,
>  				  int type, unsigned long len,
> @@ -182,53 +195,49 @@ extern int ftrace_event_reg(struct ftrace_event_call *event,
>  			    enum trace_reg type, void *data);
>  
>  enum {
> -	TRACE_EVENT_FL_ENABLED_BIT,
>  	TRACE_EVENT_FL_FILTERED_BIT,
> -	TRACE_EVENT_FL_RECORDED_CMD_BIT,
>  	TRACE_EVENT_FL_CAP_ANY_BIT,
>  	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
>  	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
> +	TRACE_EVENT_FL_WAS_ENABLED_BIT,
>  };
>  
> +/*
> + * Event flags:
> + *  FILTERED	  - The event has a filter attached
> + *  CAP_ANY	  - Any user can enable for perf
> + *  NO_SET_FILTER - Set when filter has error and is to be ignored
> + *  IGNORE_ENABLE - For ftrace internal events, do not enable with debugfs file
> + *  WAS_ENABLED   - Set and stays set when an event was ever enabled
> + *                    (used for module unloading, if a module event is enabled,
> + *                     it is best to clear the buffers that used it).
> + */
>  enum {
> -	TRACE_EVENT_FL_ENABLED		= (1 << TRACE_EVENT_FL_ENABLED_BIT),
>  	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
> -	TRACE_EVENT_FL_RECORDED_CMD	= (1 << TRACE_EVENT_FL_RECORDED_CMD_BIT),
>  	TRACE_EVENT_FL_CAP_ANY		= (1 << TRACE_EVENT_FL_CAP_ANY_BIT),
>  	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
>  	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
> +	TRACE_EVENT_FL_WAS_ENABLED	= (1 << TRACE_EVENT_FL_WAS_ENABLED_BIT),
>  };
>  
>  struct ftrace_event_call {
>  	struct list_head	list;
>  	struct ftrace_event_class *class;
>  	char			*name;
> -	struct dentry		*dir;
>  	struct trace_event	event;
>  	const char		*print_fmt;
>  	struct event_filter	*filter;
> +	struct list_head	*files;
>  	void			*mod;
>  	void			*data;
> -
>  	/*
> -	 * 32 bit flags:
> -	 *   bit 1:		enabled
> -	 *   bit 2:		filter_active
> -	 *   bit 3:		enabled cmd record
> -	 *   bit 4:		allow trace by non root (cap any)
> -	 *   bit 5:		failed to apply filter
> -	 *   bit 6:		ftrace internal event (do not enable)
> -	 *
> -	 * Changes to flags must hold the event_mutex.
> -	 *
> -	 * Note: Reads of flags do not hold the event_mutex since
> -	 * they occur in critical sections. But the way flags
> -	 * is currently used, these changes do no affect the code
> -	 * except that when a change is made, it may have a slight
> -	 * delay in propagating the changes to other CPUs due to
> -	 * caching and such.
> +	 *   bit 0:		filter_active
> +	 *   bit 1:		allow trace by non root (cap any)
> +	 *   bit 2:		failed to apply filter
> +	 *   bit 3:		ftrace internal event (do not enable)
> +	 *   bit 4:		Event was enabled by module
>  	 */
> -	unsigned int		flags;
> +	int			flags; /* static flags of different events */
>  
>  #ifdef CONFIG_PERF_EVENTS
>  	int				perf_refcount;
> @@ -236,6 +245,56 @@ struct ftrace_event_call {
>  #endif
>  };
>  
> +struct trace_array;
> +struct ftrace_subsystem_dir;
> +
> +enum {
> +	FTRACE_EVENT_FL_ENABLED_BIT,
> +	FTRACE_EVENT_FL_RECORDED_CMD_BIT,
> +	FTRACE_EVENT_FL_SOFT_MODE_BIT,
> +	FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> +};
> +
> +/*
> + * Ftrace event file flags:
> + *  ENABLED	  - The event is enabled
> + *  RECORDED_CMD  - The comms should be recorded at sched_switch
> + *  SOFT_MODE     - The event is enabled/disabled by SOFT_DISABLED
> + *  SOFT_DISABLED - When set, do not trace the event (even though its
> + *                   tracepoint may be enabled)
> + */
> +enum {
> +	FTRACE_EVENT_FL_ENABLED		= (1 << FTRACE_EVENT_FL_ENABLED_BIT),
> +	FTRACE_EVENT_FL_RECORDED_CMD	= (1 << FTRACE_EVENT_FL_RECORDED_CMD_BIT),
> +	FTRACE_EVENT_FL_SOFT_MODE	= (1 << FTRACE_EVENT_FL_SOFT_MODE_BIT),
> +	FTRACE_EVENT_FL_SOFT_DISABLED	= (1 << FTRACE_EVENT_FL_SOFT_DISABLED_BIT),
> +};
> +
> +struct ftrace_event_file {
> +	struct list_head		list;
> +	struct ftrace_event_call	*event_call;
> +	struct dentry			*dir;
> +	struct trace_array		*tr;
> +	struct ftrace_subsystem_dir	*system;
> +
> +	/*
> +	 * 32 bit flags:
> +	 *   bit 0:		enabled
> +	 *   bit 1:		enabled cmd record
> +	 *   bit 2:		enable/disable with the soft disable bit
> +	 *   bit 3:		soft disabled
> +	 *
> +	 * Note: The bits must be set atomically to prevent races
> +	 * from other writers. Reads of flags do not need to be in
> +	 * sync as they occur in critical sections. But the way flags
> +	 * is currently used, these changes do not affect the code
> +	 * except that when a change is made, it may have a slight
> +	 * delay in propagating the changes to other CPUs due to
> +	 * caching and such. Which is mostly OK ;-)
> +	 */
> +	unsigned long		flags;
> +};
> +
>  #define __TRACE_EVENT_FLAGS(name, value)				\
>  	static int __init trace_init_flags_##name(void)			\
>  	{								\
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index c566927..239dbb9 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -483,6 +483,8 @@ enum ftrace_dump_mode {
>  void tracing_on(void);
>  void tracing_off(void);
>  int tracing_is_on(void);
> +void tracing_snapshot(void);
> +void tracing_snapshot_alloc(void);
>  
>  extern void tracing_start(void);
>  extern void tracing_stop(void);
> @@ -512,10 +514,32 @@ do {									\
>   *
>   * This is intended as a debugging tool for the developer only.
>   * Please refrain from leaving trace_printks scattered around in
> - * your code.
> + * your code. (Extra memory is used for special buffers that are
> + * allocated when trace_printk() is used)
> + *
> + * A little optization trick is done here. If there's only one
> + * argument, there's no need to scan the string for printf formats.
> + * The trace_puts() will suffice. But how can we take advantage of
> + * using trace_puts() when trace_printk() has only one argument?
> + * By stringifying the args and checking the size we can tell
> + * whether or not there are args. __stringify((__VA_ARGS__)) will
> + * turn into "()\0" with a size of 3 when there are no args, anything
> + * else will be bigger. All we need to do is define a string to this,
> + * and then take its size and compare to 3. If it's bigger, use
> + * do_trace_printk() otherwise, optimize it to trace_puts(). Then just
> + * let gcc optimize the rest.
>   */
>  
> -#define trace_printk(fmt, args...)					\
> +#define trace_printk(fmt, ...)				\
> +do {							\
> +	char _______STR[] = __stringify((__VA_ARGS__));	\
> +	if (sizeof(_______STR) > 3)			\
> +		do_trace_printk(fmt, ##__VA_ARGS__);	\
> +	else						\
> +		trace_puts(fmt);			\
> +} while (0)
> +
> +#define do_trace_printk(fmt, args...)					\
>  do {									\
>  	static const char *trace_printk_fmt				\
>  		__attribute__((section("__trace_printk_fmt"))) =	\
> @@ -535,7 +559,45 @@ int __trace_bprintk(unsigned long ip, const char *fmt, ...);
>  extern __printf(2, 3)
>  int __trace_printk(unsigned long ip, const char *fmt, ...);
>  
> -extern void trace_dump_stack(void);
> +/**
> + * trace_puts - write a string into the ftrace buffer
> + * @str: the string to record
> + *
> + * Note: __trace_bputs is an internal function for trace_puts and
> + *       the @ip is passed in via the trace_puts macro.
> + *
> + * This is similar to trace_printk() but is made for those really fast
> + * paths that a developer wants the least amount of "Heisenbug" affects,
> + * where the processing of the print format is still too much.
> + *
> + * This function allows a kernel developer to debug fast path sections
> + * that printk is not appropriate for. By scattering in various
> + * printk like tracing in the code, a developer can quickly see
> + * where problems are occurring.
> + *
> + * This is intended as a debugging tool for the developer only.
> + * Please refrain from leaving trace_puts scattered around in
> + * your code. (Extra memory is used for special buffers that are
> + * allocated when trace_puts() is used)
> + *
> + * Returns: 0 if nothing was written, positive # if string was.
> + *  (1 when __trace_bputs is used, strlen(str) when __trace_puts is used)
> + */
> +
> +extern int __trace_bputs(unsigned long ip, const char *str);
> +extern int __trace_puts(unsigned long ip, const char *str, int size);
> +#define trace_puts(str) ({						\
> +	static const char *trace_printk_fmt				\
> +		__attribute__((section("__trace_printk_fmt"))) =	\
> +		__builtin_constant_p(str) ? str : NULL;			\
> +									\
> +	if (__builtin_constant_p(str))					\
> +		__trace_bputs(_THIS_IP_, trace_printk_fmt);		\
> +	else								\
> +		__trace_puts(_THIS_IP_, str, strlen(str));		\
> +})
> +
> +extern void trace_dump_stack(int skip);
>  
>  /*
>   * The double __builtin_constant_p is because gcc will give us an error
> @@ -570,6 +632,8 @@ static inline void trace_dump_stack(void) { }
>  static inline void tracing_on(void) { }
>  static inline void tracing_off(void) { }
>  static inline int tracing_is_on(void) { return 0; }
> +static inline void tracing_snapshot(void) { }
> +static inline void tracing_snapshot_alloc(void) { }
>  
>  static inline __printf(1, 2)
>  int trace_printk(const char *fmt, ...)
> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> index 1342e69..d69cf63 100644
> --- a/include/linux/ring_buffer.h
> +++ b/include/linux/ring_buffer.h
> @@ -4,6 +4,7 @@
>  #include <linux/kmemcheck.h>
>  #include <linux/mm.h>
>  #include <linux/seq_file.h>
> +#include <linux/poll.h>
>  
>  struct ring_buffer;
>  struct ring_buffer_iter;
> @@ -96,6 +97,11 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
>  	__ring_buffer_alloc((size), (flags), &__key);	\
>  })
>  
> +void ring_buffer_wait(struct ring_buffer *buffer, int cpu);
> +int ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
> +			  struct file *filp, poll_table *poll_table);
> +
> +
>  #define RING_BUFFER_ALL_CPUS -1
>  
>  void ring_buffer_free(struct ring_buffer *buffer);
> diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
> index d563f37..1d7ca27 100644
> --- a/include/linux/trace_clock.h
> +++ b/include/linux/trace_clock.h
> @@ -16,6 +16,7 @@
>  
>  extern u64 notrace trace_clock_local(void);
>  extern u64 notrace trace_clock(void);
> +extern u64 notrace trace_clock_jiffies(void);
>  extern u64 notrace trace_clock_global(void);
>  extern u64 notrace trace_clock_counter(void);
>  
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 40dc5e8..4bda044 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -227,29 +227,18 @@ static notrace enum print_line_t					\
>  ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
>  			 struct trace_event *trace_event)		\
>  {									\
> -	struct ftrace_event_call *event;				\
>  	struct trace_seq *s = &iter->seq;				\
> +	struct trace_seq __maybe_unused *p = &iter->tmp_seq;		\
>  	struct ftrace_raw_##call *field;				\
> -	struct trace_entry *entry;					\
> -	struct trace_seq *p = &iter->tmp_seq;				\
>  	int ret;							\
>  									\
> -	event = container_of(trace_event, struct ftrace_event_call,	\
> -			     event);					\
> -									\
> -	entry = iter->ent;						\
> -									\
> -	if (entry->type != event->event.type) {				\
> -		WARN_ON_ONCE(1);					\
> -		return TRACE_TYPE_UNHANDLED;				\
> -	}								\
> -									\
> -	field = (typeof(field))entry;					\
> +	field = (typeof(field))iter->ent;				\
>  									\
> -	trace_seq_init(p);						\
> -	ret = trace_seq_printf(s, "%s: ", event->name);			\
> +	ret = ftrace_raw_output_prep(iter, trace_event);		\
>  	if (ret)							\
> -		ret = trace_seq_printf(s, print);			\
> +		return ret;						\
> +									\
> +	ret = trace_seq_printf(s, print);				\
>  	if (!ret)							\
>  		return TRACE_TYPE_PARTIAL_LINE;				\
>  									\
> @@ -335,7 +324,7 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
>  
>  #undef DECLARE_EVENT_CLASS
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
> -static int notrace							\
> +static int notrace __init						\
>  ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
>  {									\
>  	struct ftrace_raw_##call field;					\
> @@ -414,7 +403,8 @@ static inline notrace int ftrace_get_offsets_##call(			\
>   *
>   * static void ftrace_raw_event_<call>(void *__data, proto)
>   * {
> - *	struct ftrace_event_call *event_call = __data;
> + *	struct ftrace_event_file *ftrace_file = __data;
> + *	struct ftrace_event_call *event_call = ftrace_file->event_call;
>   *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
>   *	struct ring_buffer_event *event;
>   *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
> @@ -423,12 +413,16 @@ static inline notrace int ftrace_get_offsets_##call(			\
>   *	int __data_size;
>   *	int pc;
>   *
> + *	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> + *		     &ftrace_file->flags))
> + *		return;
> + *
>   *	local_save_flags(irq_flags);
>   *	pc = preempt_count();
>   *
>   *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
>   *
> - *	event = trace_current_buffer_lock_reserve(&buffer,
> + *	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
>   *				  event_<call>->event.type,
>   *				  sizeof(*entry) + __data_size,
>   *				  irq_flags, pc);
> @@ -440,7 +434,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
>   *			   __array macros.
>   *
>   *	if (!filter_current_check_discard(buffer, event_call, entry, event))
> - *		trace_current_buffer_unlock_commit(buffer,
> + *		trace_nowake_buffer_unlock_commit(buffer,
>   *						   event, irq_flags, pc);
>   * }
>   *
> @@ -518,7 +512,8 @@ static inline notrace int ftrace_get_offsets_##call(			\
>  static notrace void							\
>  ftrace_raw_event_##call(void *__data, proto)				\
>  {									\
> -	struct ftrace_event_call *event_call = __data;			\
> +	struct ftrace_event_file *ftrace_file = __data;			\
> +	struct ftrace_event_call *event_call = ftrace_file->event_call;	\
>  	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
>  	struct ring_buffer_event *event;				\
>  	struct ftrace_raw_##call *entry;				\
> @@ -527,12 +522,16 @@ ftrace_raw_event_##call(void *__data, proto)				\
>  	int __data_size;						\
>  	int pc;								\
>  									\
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
> +		     &ftrace_file->flags))				\
> +		return;							\
> +									\
>  	local_save_flags(irq_flags);					\
>  	pc = preempt_count();						\
>  									\
>  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
>  									\
> -	event = trace_current_buffer_lock_reserve(&buffer,		\
> +	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,	\
>  				 event_call->event.type,		\
>  				 sizeof(*entry) + __data_size,		\
>  				 irq_flags, pc);			\
> @@ -581,7 +580,7 @@ static inline void ftrace_test_probe_##call(void)			\
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
>  _TRACE_PERF_PROTO(call, PARAMS(proto));					\
>  static const char print_fmt_##call[] = print;				\
> -static struct ftrace_event_class __used event_class_##call = {		\
> +static struct ftrace_event_class __used __refdata event_class_##call = { \
>  	.system			= __stringify(TRACE_SYSTEM),		\
>  	.define_fields		= ftrace_define_fields_##call,		\
>  	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index b516a8e..0b5ecf5 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -191,6 +191,8 @@ config IRQSOFF_TRACER
>  	select GENERIC_TRACER
>  	select TRACER_MAX_TRACE
>  	select RING_BUFFER_ALLOW_SWAP
> +	select TRACER_SNAPSHOT
> +	select TRACER_SNAPSHOT_PER_CPU_SWAP
>  	help
>  	  This option measures the time spent in irqs-off critical
>  	  sections, with microsecond accuracy.
> @@ -213,6 +215,8 @@ config PREEMPT_TRACER
>  	select GENERIC_TRACER
>  	select TRACER_MAX_TRACE
>  	select RING_BUFFER_ALLOW_SWAP
> +	select TRACER_SNAPSHOT
> +	select TRACER_SNAPSHOT_PER_CPU_SWAP
>  	help
>  	  This option measures the time spent in preemption-off critical
>  	  sections, with microsecond accuracy.
> @@ -232,6 +236,7 @@ config SCHED_TRACER
>  	select GENERIC_TRACER
>  	select CONTEXT_SWITCH_TRACER
>  	select TRACER_MAX_TRACE
> +	select TRACER_SNAPSHOT
>  	help
>  	  This tracer tracks the latency of the highest priority task
>  	  to be scheduled in, starting from the point it has woken up.
> @@ -263,6 +268,27 @@ config TRACER_SNAPSHOT
>  	      echo 1 > /sys/kernel/debug/tracing/snapshot
>  	      cat snapshot
>  
> +config TRACER_SNAPSHOT_PER_CPU_SWAP
> +        bool "Allow snapshot to swap per CPU"
> +	depends on TRACER_SNAPSHOT
> +	select RING_BUFFER_ALLOW_SWAP
> +	help
> +	  Allow doing a snapshot of a single CPU buffer instead of a
> +	  full swap (all buffers). If this is set, then the following is
> +	  allowed:
> +
> +	      echo 1 > /sys/kernel/debug/tracing/per_cpu/cpu2/snapshot
> +
> +	  After which, only the tracing buffer for CPU 2 was swapped with
> +	  the main tracing buffer, and the other CPU buffers remain the same.
> +
> +	  When this is enabled, this adds a little more overhead to the
> +	  trace recording, as it needs to add some checks to synchronize
> +	  recording with swaps. But this does not affect the performance
> +	  of the overall system. This is enabled by default when the preempt
> +	  or irq latency tracers are enabled, as those need to swap as well
> +	  and already adds the overhead (plus a lot more).
> +
>  config TRACE_BRANCH_PROFILING
>  	bool
>  	select GENERIC_TRACER
> @@ -539,6 +565,29 @@ config RING_BUFFER_BENCHMARK
>  
>  	  If unsure, say N.
>  
> +config RING_BUFFER_STARTUP_TEST
> +       bool "Ring buffer startup self test"
> +       depends on RING_BUFFER
> +       help
> +         Run a simple self test on the ring buffer on boot up. Late in the
> +	 kernel boot sequence, the test will start that kicks off
> +	 a thread per cpu. Each thread will write various size events
> +	 into the ring buffer. Another thread is created to send IPIs
> +	 to each of the threads, where the IPI handler will also write
> +	 to the ring buffer, to test/stress the nesting ability.
> +	 If any anomalies are discovered, a warning will be displayed
> +	 and all ring buffers will be disabled.
> +
> +	 The test runs for 10 seconds. This will slow your boot time
> +	 by at least 10 more seconds.
> +
> +	 At the end of the test, statics and more checks are done.
> +	 It will output the stats of each per cpu buffer. What
> +	 was written, the sizes, what was read, what was lost, and
> +	 other similar details.
> +
> +	 If unsure, say N
> +
>  endif # FTRACE
>  
>  endif # TRACING_SUPPORT
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 71259e2..90a5505 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -72,7 +72,7 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
>  	bool blk_tracer = blk_tracer_enabled;
>  
>  	if (blk_tracer) {
> -		buffer = blk_tr->buffer;
> +		buffer = blk_tr->trace_buffer.buffer;
>  		pc = preempt_count();
>  		event = trace_buffer_lock_reserve(buffer, TRACE_BLK,
>  						  sizeof(*t) + len,
> @@ -218,7 +218,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  	if (blk_tracer) {
>  		tracing_record_cmdline(current);
>  
> -		buffer = blk_tr->buffer;
> +		buffer = blk_tr->trace_buffer.buffer;
>  		pc = preempt_count();
>  		event = trace_buffer_lock_reserve(buffer, TRACE_BLK,
>  						  sizeof(*t) + pdu_len,
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index e6effd0..2577082 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1068,7 +1068,7 @@ struct ftrace_func_probe {
>  	unsigned long		flags;
>  	unsigned long		ip;
>  	void			*data;
> -	struct rcu_head		rcu;
> +	struct list_head	free_list;
>  };
>  
>  struct ftrace_func_entry {
> @@ -2978,28 +2978,27 @@ static void __disable_ftrace_function_probe(void)
>  }
>  
> 
> -static void ftrace_free_entry_rcu(struct rcu_head *rhp)
> +static void ftrace_free_entry(struct ftrace_func_probe *entry)
>  {
> -	struct ftrace_func_probe *entry =
> -		container_of(rhp, struct ftrace_func_probe, rcu);
> -
>  	if (entry->ops->free)
> -		entry->ops->free(&entry->data);
> +		entry->ops->free(entry->ops, entry->ip, &entry->data);
>  	kfree(entry);
>  }
>  
> -
>  int
>  register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>  			      void *data)
>  {
>  	struct ftrace_func_probe *entry;
> +	struct ftrace_hash **orig_hash = &trace_probe_ops.filter_hash;
> +	struct ftrace_hash *hash;
>  	struct ftrace_page *pg;
>  	struct dyn_ftrace *rec;
>  	int type, len, not;
>  	unsigned long key;
>  	int count = 0;
>  	char *search;
> +	int ret;
>  
>  	type = filter_parse_regex(glob, strlen(glob), &search, &not);
>  	len = strlen(search);
> @@ -3010,8 +3009,16 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>  
>  	mutex_lock(&ftrace_lock);
>  
> -	if (unlikely(ftrace_disabled))
> +	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
> +	if (!hash) {
> +		count = -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +	if (unlikely(ftrace_disabled)) {
> +		count = -ENODEV;
>  		goto out_unlock;
> +	}
>  
>  	do_for_each_ftrace_rec(pg, rec) {
>  
> @@ -3035,14 +3042,21 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>  		 * for each function we find. We call the callback
>  		 * to give the caller an opportunity to do so.
>  		 */
> -		if (ops->callback) {
> -			if (ops->callback(rec->ip, &entry->data) < 0) {
> +		if (ops->init) {
> +			if (ops->init(ops, rec->ip, &entry->data) < 0) {
>  				/* caller does not like this func */
>  				kfree(entry);
>  				continue;
>  			}
>  		}
>  
> +		ret = enter_record(hash, rec, 0);
> +		if (ret < 0) {
> +			kfree(entry);
> +			count = ret;
> +			goto out_unlock;
> +		}
> +
>  		entry->ops = ops;
>  		entry->ip = rec->ip;
>  
> @@ -3050,10 +3064,16 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>  		hlist_add_head_rcu(&entry->node, &ftrace_func_hash[key]);
>  
>  	} while_for_each_ftrace_rec();
> +
> +	ret = ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
> +	if (ret < 0)
> +		count = ret;
> +
>  	__enable_ftrace_function_probe();
>  
>   out_unlock:
>  	mutex_unlock(&ftrace_lock);
> +	free_ftrace_hash(hash);
>  
>  	return count;
>  }
> @@ -3067,7 +3087,12 @@ static void
>  __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>  				  void *data, int flags)
>  {
> +	struct ftrace_func_entry *rec_entry;
>  	struct ftrace_func_probe *entry;
> +	struct ftrace_func_probe *p;
> +	struct ftrace_hash **orig_hash = &trace_probe_ops.filter_hash;
> +	struct list_head free_list;
> +	struct ftrace_hash *hash;
>  	struct hlist_node *n, *tmp;
>  	char str[KSYM_SYMBOL_LEN];
>  	int type = MATCH_FULL;
> @@ -3088,6 +3113,14 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>  	}
>  
>  	mutex_lock(&ftrace_lock);
> +
> +	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
> +	if (!hash)
> +		/* Hmm, should report this somehow */
> +		goto out_unlock;
> +
> +	INIT_LIST_HEAD(&free_list);
> +
>  	for (i = 0; i < FTRACE_FUNC_HASHSIZE; i++) {
>  		struct hlist_head *hhd = &ftrace_func_hash[i];
>  
> @@ -3108,12 +3141,30 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>  					continue;
>  			}
>  
> +			rec_entry = ftrace_lookup_ip(hash, entry->ip);
> +			/* It is possible more than one entry had this ip */
> +			if (rec_entry)
> +				free_hash_entry(hash, rec_entry);
> +
>  			hlist_del_rcu(&entry->node);
> -			call_rcu_sched(&entry->rcu, ftrace_free_entry_rcu);
> +			list_add(&entry->free_list, &free_list);
>  		}
>  	}
>  	__disable_ftrace_function_probe();
> +	/*
> +	 * Remove after the disable is called. Otherwise, if the last
> +	 * probe is removed, a null hash means *all enabled*.
> +	 */
> +	ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
> +	synchronize_sched();
> +	list_for_each_entry_safe(entry, p, &free_list, free_list) {
> +		list_del(&entry->free_list);
> +		ftrace_free_entry(entry);
> +	}
> +		
> + out_unlock:
>  	mutex_unlock(&ftrace_lock);
> +	free_ftrace_hash(hash);
>  }
>  
>  void
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 7244acd..e5472f7 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -8,13 +8,16 @@
>  #include <linux/trace_clock.h>
>  #include <linux/trace_seq.h>
>  #include <linux/spinlock.h>
> +#include <linux/irq_work.h>
>  #include <linux/debugfs.h>
>  #include <linux/uaccess.h>
>  #include <linux/hardirq.h>
> +#include <linux/kthread.h>	/* for self test */
>  #include <linux/kmemcheck.h>
>  #include <linux/module.h>
>  #include <linux/percpu.h>
>  #include <linux/mutex.h>
> +#include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/init.h>
>  #include <linux/hash.h>
> @@ -442,6 +445,12 @@ int ring_buffer_print_page_header(struct trace_seq *s)
>  	return ret;
>  }
>  
> +struct rb_irq_work {
> +	struct irq_work			work;
> +	wait_queue_head_t		waiters;
> +	bool				waiters_pending;
> +};
> +
>  /*
>   * head_page == tail_page && head == tail then buffer is empty.
>   */
> @@ -476,6 +485,8 @@ struct ring_buffer_per_cpu {
>  	struct list_head		new_pages; /* new pages to add */
>  	struct work_struct		update_pages_work;
>  	struct completion		update_done;
> +
> +	struct rb_irq_work		irq_work;
>  };
>  
>  struct ring_buffer {
> @@ -495,6 +506,8 @@ struct ring_buffer {
>  	struct notifier_block		cpu_notify;
>  #endif
>  	u64				(*clock)(void);
> +
> +	struct rb_irq_work		irq_work;
>  };
>  
>  struct ring_buffer_iter {
> @@ -506,6 +519,118 @@ struct ring_buffer_iter {
>  	u64				read_stamp;
>  };
>  
> +/*
> + * rb_wake_up_waiters - wake up tasks waiting for ring buffer input
> + *
> + * Schedules a delayed work to wake up any task that is blocked on the
> + * ring buffer waiters queue.
> + */
> +static void rb_wake_up_waiters(struct irq_work *work)
> +{
> +	struct rb_irq_work *rbwork = container_of(work, struct rb_irq_work, work);
> +
> +	wake_up_all(&rbwork->waiters);
> +}
> +
> +/**
> + * ring_buffer_wait - wait for input to the ring buffer
> + * @buffer: buffer to wait on
> + * @cpu: the cpu buffer to wait on
> + *
> + * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
> + * as data is added to any of the @buffer's cpu buffers. Otherwise
> + * it will wait for data to be added to a specific cpu buffer.
> + */
> +void ring_buffer_wait(struct ring_buffer *buffer, int cpu)
> +{
> +	struct ring_buffer_per_cpu *cpu_buffer;
> +	DEFINE_WAIT(wait);
> +	struct rb_irq_work *work;
> +
> +	/*
> +	 * Depending on what the caller is waiting for, either any
> +	 * data in any cpu buffer, or a specific buffer, put the
> +	 * caller on the appropriate wait queue.
> +	 */
> +	if (cpu == RING_BUFFER_ALL_CPUS)
> +		work = &buffer->irq_work;
> +	else {
> +		cpu_buffer = buffer->buffers[cpu];
> +		work = &cpu_buffer->irq_work;
> +	}
> +
> +
> +	prepare_to_wait(&work->waiters, &wait, TASK_INTERRUPTIBLE);
> +
> +	/*
> +	 * The events can happen in critical sections where
> +	 * checking a work queue can cause deadlocks.
> +	 * After adding a task to the queue, this flag is set
> +	 * only to notify events to try to wake up the queue
> +	 * using irq_work.
> +	 *
> +	 * We don't clear it even if the buffer is no longer
> +	 * empty. The flag only causes the next event to run
> +	 * irq_work to do the work queue wake up. The worse
> +	 * that can happen if we race with !trace_empty() is that
> +	 * an event will cause an irq_work to try to wake up
> +	 * an empty queue.
> +	 *
> +	 * There's no reason to protect this flag either, as
> +	 * the work queue and irq_work logic will do the necessary
> +	 * synchronization for the wake ups. The only thing
> +	 * that is necessary is that the wake up happens after
> +	 * a task has been queued. It's OK for spurious wake ups.
> +	 */
> +	work->waiters_pending = true;
> +
> +	if ((cpu == RING_BUFFER_ALL_CPUS && ring_buffer_empty(buffer)) ||
> +	    (cpu != RING_BUFFER_ALL_CPUS && ring_buffer_empty_cpu(buffer, cpu)))
> +		schedule();
> +
> +	finish_wait(&work->waiters, &wait);
> +}
> +
> +/**
> + * ring_buffer_poll_wait - poll on buffer input
> + * @buffer: buffer to wait on
> + * @cpu: the cpu buffer to wait on
> + * @filp: the file descriptor
> + * @poll_table: The poll descriptor
> + *
> + * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
> + * as data is added to any of the @buffer's cpu buffers. Otherwise
> + * it will wait for data to be added to a specific cpu buffer.
> + *
> + * Returns POLLIN | POLLRDNORM if data exists in the buffers,
> + * zero otherwise.
> + */
> +int ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
> +			  struct file *filp, poll_table *poll_table)
> +{
> +	struct ring_buffer_per_cpu *cpu_buffer;
> +	struct rb_irq_work *work;
> +
> +	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
> +	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
> +		return POLLIN | POLLRDNORM;
> +
> +	if (cpu == RING_BUFFER_ALL_CPUS)
> +		work = &buffer->irq_work;
> +	else {
> +		cpu_buffer = buffer->buffers[cpu];
> +		work = &cpu_buffer->irq_work;
> +	}
> +
> +	work->waiters_pending = true;
> +	poll_wait(filp, &work->waiters, poll_table);
> +
> +	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
> +	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
> +		return POLLIN | POLLRDNORM;
> +	return 0;
> +}
> +
>  /* buffer may be either ring_buffer or ring_buffer_per_cpu */
>  #define RB_WARN_ON(b, cond)						\
>  	({								\
> @@ -1061,6 +1186,8 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int nr_pages, int cpu)
>  	cpu_buffer->lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
>  	INIT_WORK(&cpu_buffer->update_pages_work, update_pages_handler);
>  	init_completion(&cpu_buffer->update_done);
> +	init_irq_work(&cpu_buffer->irq_work.work, rb_wake_up_waiters);
> +	init_waitqueue_head(&cpu_buffer->irq_work.waiters);
>  
>  	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
>  			    GFP_KERNEL, cpu_to_node(cpu));
> @@ -1156,6 +1283,9 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
>  	buffer->clock = trace_clock_local;
>  	buffer->reader_lock_key = key;
>  
> +	init_irq_work(&buffer->irq_work.work, rb_wake_up_waiters);
> +	init_waitqueue_head(&buffer->irq_work.waiters);
> +
>  	/* need at least two pages */
>  	if (nr_pages < 2)
>  		nr_pages = 2;
> @@ -1551,11 +1681,22 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
>  			if (!cpu_buffer->nr_pages_to_update)
>  				continue;
>  
> -			if (cpu_online(cpu))
> +			/* The update must run on the CPU that is being updated. */
> +			preempt_disable();
> +			if (cpu == smp_processor_id() || !cpu_online(cpu)) {
> +				rb_update_pages(cpu_buffer);
> +				cpu_buffer->nr_pages_to_update = 0;
> +			} else {
> +				/*
> +				 * Can not disable preemption for schedule_work_on()
> +				 * on PREEMPT_RT.
> +				 */
> +				preempt_enable();
>  				schedule_work_on(cpu,
>  						&cpu_buffer->update_pages_work);
> -			else
> -				rb_update_pages(cpu_buffer);
> +				preempt_disable();
> +			}
> +			preempt_enable();
>  		}
>  
>  		/* wait for all the updates to complete */
> @@ -1593,12 +1734,22 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
>  
>  		get_online_cpus();
>  
> -		if (cpu_online(cpu_id)) {
> +		preempt_disable();
> +		/* The update must run on the CPU that is being updated. */
> +		if (cpu_id == smp_processor_id() || !cpu_online(cpu_id))
> +			rb_update_pages(cpu_buffer);
> +		else {
> +			/*
> +			 * Can not disable preemption for schedule_work_on()
> +			 * on PREEMPT_RT.
> +			 */
> +			preempt_enable();
>  			schedule_work_on(cpu_id,
>  					 &cpu_buffer->update_pages_work);
>  			wait_for_completion(&cpu_buffer->update_done);
> -		} else
> -			rb_update_pages(cpu_buffer);
> +			preempt_disable();
> +		}
> +		preempt_enable();
>  
>  		cpu_buffer->nr_pages_to_update = 0;
>  		put_online_cpus();
> @@ -2610,6 +2761,22 @@ static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
>  	rb_end_commit(cpu_buffer);
>  }
>  
> +static __always_inline void
> +rb_wakeups(struct ring_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
> +{
> +	if (buffer->irq_work.waiters_pending) {
> +		buffer->irq_work.waiters_pending = false;
> +		/* irq_work_queue() supplies it's own memory barriers */
> +		irq_work_queue(&buffer->irq_work.work);
> +	}
> +
> +	if (cpu_buffer->irq_work.waiters_pending) {
> +		cpu_buffer->irq_work.waiters_pending = false;
> +		/* irq_work_queue() supplies it's own memory barriers */
> +		irq_work_queue(&cpu_buffer->irq_work.work);
> +	}
> +}
> +
>  /**
>   * ring_buffer_unlock_commit - commit a reserved
>   * @buffer: The buffer to commit to
> @@ -2629,6 +2796,8 @@ int ring_buffer_unlock_commit(struct ring_buffer *buffer,
>  
>  	rb_commit(cpu_buffer, event);
>  
> +	rb_wakeups(buffer, cpu_buffer);
> +
>  	trace_recursive_unlock();
>  
>  	preempt_enable_notrace();
> @@ -2801,6 +2970,8 @@ int ring_buffer_write(struct ring_buffer *buffer,
>  
>  	rb_commit(cpu_buffer, event);
>  
> +	rb_wakeups(buffer, cpu_buffer);
> +
>  	ret = 0;
>   out:
>  	preempt_enable_notrace();
> @@ -4465,3 +4636,320 @@ static int rb_cpu_notify(struct notifier_block *self,
>  	return NOTIFY_OK;
>  }
>  #endif
> +
> +#ifdef CONFIG_RING_BUFFER_STARTUP_TEST
> +/*
> + * This is a basic integrity check of the ring buffer.
> + * Late in the boot cycle this test will run when configured in.
> + * It will kick off a thread per CPU that will go into a loop
> + * writing to the per cpu ring buffer various sizes of data.
> + * Some of the data will be large items, some small.
> + *
> + * Another thread is created that goes into a spin, sending out
> + * IPIs to the other CPUs to also write into the ring buffer.
> + * this is to test the nesting ability of the buffer.
> + *
> + * Basic stats are recorded and reported. If something in the
> + * ring buffer should happen that's not expected, a big warning
> + * is displayed and all ring buffers are disabled.
> + */
> +static struct task_struct *rb_threads[NR_CPUS] __initdata;
> +
> +struct rb_test_data {
> +	struct ring_buffer	*buffer;
> +	unsigned long		events;
> +	unsigned long		bytes_written;
> +	unsigned long		bytes_alloc;
> +	unsigned long		bytes_dropped;
> +	unsigned long		events_nested;
> +	unsigned long		bytes_written_nested;
> +	unsigned long		bytes_alloc_nested;
> +	unsigned long		bytes_dropped_nested;
> +	int			min_size_nested;
> +	int			max_size_nested;
> +	int			max_size;
> +	int			min_size;
> +	int			cpu;
> +	int			cnt;
> +};
> +
> +static struct rb_test_data rb_data[NR_CPUS] __initdata;
> +
> +/* 1 meg per cpu */
> +#define RB_TEST_BUFFER_SIZE	1048576
> +
> +static char rb_string[] __initdata =
> +	"abcdefghijklmnopqrstuvwxyz1234567890!@#$%^&*()?+\\"
> +	"?+|:';\",.<>/?abcdefghijklmnopqrstuvwxyz1234567890"
> +	"!@#$%^&*()?+\\?+|:';\",.<>/?abcdefghijklmnopqrstuv";
> +
> +static bool rb_test_started __initdata;
> +
> +struct rb_item {
> +	int size;
> +	char str[];
> +};
> +
> +static __init int rb_write_something(struct rb_test_data *data, bool nested)
> +{
> +	struct ring_buffer_event *event;
> +	struct rb_item *item;
> +	bool started;
> +	int event_len;
> +	int size;
> +	int len;
> +	int cnt;
> +
> +	/* Have nested writes different that what is written */
> +	cnt = data->cnt + (nested ? 27 : 0);
> +
> +	/* Multiply cnt by ~e, to make some unique increment */
> +	size = (data->cnt * 68 / 25) % (sizeof(rb_string) - 1);
> +
> +	len = size + sizeof(struct rb_item);
> +
> +	started = rb_test_started;
> +	/* read rb_test_started before checking buffer enabled */
> +	smp_rmb();
> +
> +	event = ring_buffer_lock_reserve(data->buffer, len);
> +	if (!event) {
> +		/* Ignore dropped events before test starts. */
> +		if (started) {
> +			if (nested)
> +				data->bytes_dropped += len;
> +			else
> +				data->bytes_dropped_nested += len;
> +		}
> +		return len;
> +	}
> +
> +	event_len = ring_buffer_event_length(event);
> +
> +	if (RB_WARN_ON(data->buffer, event_len < len))
> +		goto out;
> +
> +	item = ring_buffer_event_data(event);
> +	item->size = size;
> +	memcpy(item->str, rb_string, size);
> +
> +	if (nested) {
> +		data->bytes_alloc_nested += event_len;
> +		data->bytes_written_nested += len;
> +		data->events_nested++;
> +		if (!data->min_size_nested || len < data->min_size_nested)
> +			data->min_size_nested = len;
> +		if (len > data->max_size_nested)
> +			data->max_size_nested = len;
> +	} else {
> +		data->bytes_alloc += event_len;
> +		data->bytes_written += len;
> +		data->events++;
> +		if (!data->min_size || len < data->min_size)
> +			data->max_size = len;
> +		if (len > data->max_size)
> +			data->max_size = len;
> +	}
> +
> + out:
> +	ring_buffer_unlock_commit(data->buffer, event);
> +
> +	return 0;
> +}
> +
> +static __init int rb_test(void *arg)
> +{
> +	struct rb_test_data *data = arg;
> +
> +	while (!kthread_should_stop()) {
> +		rb_write_something(data, false);
> +		data->cnt++;
> +
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		/* Now sleep between a min of 100-300us and a max of 1ms */
> +		usleep_range(((data->cnt % 3) + 1) * 100, 1000);
> +	}
> +
> +	return 0;
> +}
> +
> +static __init void rb_ipi(void *ignore)
> +{
> +	struct rb_test_data *data;
> +	int cpu = smp_processor_id();
> +
> +	data = &rb_data[cpu];
> +	rb_write_something(data, true);
> +}
> +
> +static __init int rb_hammer_test(void *arg)
> +{
> +	while (!kthread_should_stop()) {
> +
> +		/* Send an IPI to all cpus to write data! */
> +		smp_call_function(rb_ipi, NULL, 1);
> +		/* No sleep, but for non preempt, let others run */
> +		schedule();
> +	}
> +
> +	return 0;
> +}
> +
> +static __init int test_ringbuffer(void)
> +{
> +	struct task_struct *rb_hammer;
> +	struct ring_buffer *buffer;
> +	int cpu;
> +	int ret = 0;
> +
> +	pr_info("Running ring buffer tests...\n");
> +
> +	buffer = ring_buffer_alloc(RB_TEST_BUFFER_SIZE, RB_FL_OVERWRITE);
> +	if (WARN_ON(!buffer))
> +		return 0;
> +
> +	/* Disable buffer so that threads can't write to it yet */
> +	ring_buffer_record_off(buffer);
> +
> +	for_each_online_cpu(cpu) {
> +		rb_data[cpu].buffer = buffer;
> +		rb_data[cpu].cpu = cpu;
> +		rb_data[cpu].cnt = cpu;
> +		rb_threads[cpu] = kthread_create(rb_test, &rb_data[cpu],
> +						 "rbtester/%d", cpu);
> +		if (WARN_ON(!rb_threads[cpu])) {
> +			pr_cont("FAILED\n");
> +			ret = -1;
> +			goto out_free;
> +		}
> +
> +		kthread_bind(rb_threads[cpu], cpu);
> + 		wake_up_process(rb_threads[cpu]);
> +	}
> +
> +	/* Now create the rb hammer! */
> +	rb_hammer = kthread_run(rb_hammer_test, NULL, "rbhammer");
> +	if (WARN_ON(!rb_hammer)) {
> +		pr_cont("FAILED\n");
> +		ret = -1;
> +		goto out_free;
> +	}
> +
> +	ring_buffer_record_on(buffer);
> +	/*
> +	 * Show buffer is enabled before setting rb_test_started.
> +	 * Yes there's a small race window where events could be
> +	 * dropped and the thread wont catch it. But when a ring
> +	 * buffer gets enabled, there will always be some kind of
> +	 * delay before other CPUs see it. Thus, we don't care about
> +	 * those dropped events. We care about events dropped after
> +	 * the threads see that the buffer is active.
> +	 */
> +	smp_wmb();
> +	rb_test_started = true;
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	/* Just run for 10 seconds */;
> +	schedule_timeout(10 * HZ);
> +
> +	kthread_stop(rb_hammer);
> +
> + out_free:
> +	for_each_online_cpu(cpu) {
> +		if (!rb_threads[cpu])
> +			break;
> +		kthread_stop(rb_threads[cpu]);
> +	}
> +	if (ret) {
> +		ring_buffer_free(buffer);
> +		return ret;
> +	}
> +
> +	/* Report! */
> +	pr_info("finished\n");
> +	for_each_online_cpu(cpu) {
> +		struct ring_buffer_event *event;
> +		struct rb_test_data *data = &rb_data[cpu];
> +		struct rb_item *item;
> +		unsigned long total_events;
> +		unsigned long total_dropped;
> +		unsigned long total_written;
> +		unsigned long total_alloc;
> +		unsigned long total_read = 0;
> +		unsigned long total_size = 0;
> +		unsigned long total_len = 0;
> +		unsigned long total_lost = 0;
> +		unsigned long lost;
> +		int big_event_size;
> +		int small_event_size;
> +
> +		ret = -1;
> +
> +		total_events = data->events + data->events_nested;
> +		total_written = data->bytes_written + data->bytes_written_nested;
> +		total_alloc = data->bytes_alloc + data->bytes_alloc_nested;
> +		total_dropped = data->bytes_dropped + data->bytes_dropped_nested;
> +
> +		big_event_size = data->max_size + data->max_size_nested;
> +		small_event_size = data->min_size + data->min_size_nested;
> +
> +		pr_info("CPU %d:\n", cpu);
> +		pr_info("              events:    %ld\n", total_events);
> +		pr_info("       dropped bytes:    %ld\n", total_dropped);
> +		pr_info("       alloced bytes:    %ld\n", total_alloc);
> +		pr_info("       written bytes:    %ld\n", total_written);
> +		pr_info("       biggest event:    %d\n", big_event_size);
> +		pr_info("      smallest event:    %d\n", small_event_size);
> +
> +		if (RB_WARN_ON(buffer, total_dropped))
> +			break;
> +
> +		ret = 0;
> +
> +		while ((event = ring_buffer_consume(buffer, cpu, NULL, &lost))) {
> +			total_lost += lost;
> +			item = ring_buffer_event_data(event);
> +			total_len += ring_buffer_event_length(event);
> +			total_size += item->size + sizeof(struct rb_item);
> +			if (memcmp(&item->str[0], rb_string, item->size) != 0) {
> +				pr_info("FAILED!\n");
> +				pr_info("buffer had: %.*s\n", item->size, item->str);
> +				pr_info("expected:   %.*s\n", item->size, rb_string);
> +				RB_WARN_ON(buffer, 1);
> +				ret = -1;
> +				break;
> +			}
> +			total_read++;
> +		}
> +		if (ret)
> +			break;
> +
> +		ret = -1;
> +
> +		pr_info("         read events:   %ld\n", total_read);
> +		pr_info("         lost events:   %ld\n", total_lost);
> +		pr_info("        total events:   %ld\n", total_lost + total_read);
> +		pr_info("  recorded len bytes:   %ld\n", total_len);
> +		pr_info(" recorded size bytes:   %ld\n", total_size);
> +		if (total_lost)
> +			pr_info(" With dropped events, record len and size may not match\n"
> +				" alloced and written from above\n");
> +		if (!total_lost) {
> +			if (RB_WARN_ON(buffer, total_len != total_alloc ||
> +				       total_size != total_written))
> +				break;
> +		}
> +		if (RB_WARN_ON(buffer, total_lost + total_read != total_events))
> +			break;
> +
> +		ret = 0;
> +	}
> +	if (!ret)
> +		pr_info("Ring buffer PASSED!\n");
> +
> +	ring_buffer_free(buffer);
> +	return 0;
> +}
> +
> +late_initcall(test_ringbuffer);
> +#endif /* CONFIG_RING_BUFFER_STARTUP_TEST */
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 4f1dade..829b2be 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1,7 +1,7 @@
>  /*
>   * ring buffer based function tracer
>   *
> - * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
> + * Copyright (C) 2007-2012 Steven Rostedt <srostedt@redhat.com>
>   * Copyright (C) 2008 Ingo Molnar <mingo@redhat.com>
>   *
>   * Originally taken from the RT patch by:
> @@ -19,7 +19,6 @@
>  #include <linux/seq_file.h>
>  #include <linux/notifier.h>
>  #include <linux/irqflags.h>
> -#include <linux/irq_work.h>
>  #include <linux/debugfs.h>
>  #include <linux/pagemap.h>
>  #include <linux/hardirq.h>
> @@ -48,7 +47,7 @@
>   * On boot up, the ring buffer is set to the minimum size, so that
>   * we do not waste memory on systems that are not using tracing.
>   */
> -int ring_buffer_expanded;
> +bool ring_buffer_expanded;
>  
>  /*
>   * We need to change this state when a selftest is running.
> @@ -87,14 +86,6 @@ static int dummy_set_flag(u32 old_flags, u32 bit, int set)
>  static DEFINE_PER_CPU(bool, trace_cmdline_save);
>  
>  /*
> - * When a reader is waiting for data, then this variable is
> - * set to true.
> - */
> -static bool trace_wakeup_needed;
> -
> -static struct irq_work trace_work_wakeup;
> -
> -/*
>   * Kill all tracing for good (never come back).
>   * It is initialized to 1 but will turn to zero if the initialization
>   * of the tracer is successful. But that is the only place that sets
> @@ -130,12 +121,14 @@ static int tracing_set_tracer(const char *buf);
>  static char bootup_tracer_buf[MAX_TRACER_SIZE] __initdata;
>  static char *default_bootup_tracer;
>  
> +static bool allocate_snapshot;
> +
>  static int __init set_cmdline_ftrace(char *str)
>  {
>  	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
>  	default_bootup_tracer = bootup_tracer_buf;
>  	/* We are using ftrace early, expand it */
> -	ring_buffer_expanded = 1;
> +	ring_buffer_expanded = true;
>  	return 1;
>  }
>  __setup("ftrace=", set_cmdline_ftrace);
> @@ -156,6 +149,15 @@ static int __init set_ftrace_dump_on_oops(char *str)
>  }
>  __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
>  
> +static int __init boot_alloc_snapshot(char *str)
> +{
> +	allocate_snapshot = true;
> +	/* We also need the main ring buffer expanded */
> +	ring_buffer_expanded = true;
> +	return 1;
> +}
> +__setup("alloc_snapshot", boot_alloc_snapshot);
> +
>  
>  static char trace_boot_options_buf[MAX_TRACER_SIZE] __initdata;
>  static char *trace_boot_options __initdata;
> @@ -189,7 +191,7 @@ unsigned long long ns2usecs(cycle_t nsec)
>   */
>  static struct trace_array	global_trace;
>  
> -static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
> +LIST_HEAD(ftrace_trace_arrays);
>  
>  int filter_current_check_discard(struct ring_buffer *buffer,
>  				 struct ftrace_event_call *call, void *rec,
> @@ -204,29 +206,15 @@ cycle_t ftrace_now(int cpu)
>  	u64 ts;
>  
>  	/* Early boot up does not have a buffer yet */
> -	if (!global_trace.buffer)
> +	if (!global_trace.trace_buffer.buffer)
>  		return trace_clock_local();
>  
> -	ts = ring_buffer_time_stamp(global_trace.buffer, cpu);
> -	ring_buffer_normalize_time_stamp(global_trace.buffer, cpu, &ts);
> +	ts = ring_buffer_time_stamp(global_trace.trace_buffer.buffer, cpu);
> +	ring_buffer_normalize_time_stamp(global_trace.trace_buffer.buffer, cpu, &ts);
>  
>  	return ts;
>  }
>  
> -/*
> - * The max_tr is used to snapshot the global_trace when a maximum
> - * latency is reached. Some tracers will use this to store a maximum
> - * trace while it continues examining live traces.
> - *
> - * The buffers for the max_tr are set up the same as the global_trace.
> - * When a snapshot is taken, the link list of the max_tr is swapped
> - * with the link list of the global_trace and the buffers are reset for
> - * the global_trace so the tracing can continue.
> - */
> -static struct trace_array	max_tr;
> -
> -static DEFINE_PER_CPU(struct trace_array_cpu, max_tr_data);
> -
>  int tracing_is_enabled(void)
>  {
>  	return tracing_is_on();
> @@ -249,9 +237,6 @@ static unsigned long		trace_buf_size = TRACE_BUF_SIZE_DEFAULT;
>  /* trace_types holds a link list of available tracers. */
>  static struct tracer		*trace_types __read_mostly;
>  
> -/* current_trace points to the tracer that is currently active */
> -static struct tracer		*current_trace __read_mostly = &nop_trace;
> -
>  /*
>   * trace_types_lock is used to protect the trace_types list.
>   */
> @@ -285,13 +270,13 @@ static DEFINE_PER_CPU(struct mutex, cpu_access_lock);
>  
>  static inline void trace_access_lock(int cpu)
>  {
> -	if (cpu == TRACE_PIPE_ALL_CPU) {
> +	if (cpu == RING_BUFFER_ALL_CPUS) {
>  		/* gain it for accessing the whole ring buffer. */
>  		down_write(&all_cpu_access_lock);
>  	} else {
>  		/* gain it for accessing a cpu ring buffer. */
>  
> -		/* Firstly block other trace_access_lock(TRACE_PIPE_ALL_CPU). */
> +		/* Firstly block other trace_access_lock(RING_BUFFER_ALL_CPUS). */
>  		down_read(&all_cpu_access_lock);
>  
>  		/* Secondly block other access to this @cpu ring buffer. */
> @@ -301,7 +286,7 @@ static inline void trace_access_lock(int cpu)
>  
>  static inline void trace_access_unlock(int cpu)
>  {
> -	if (cpu == TRACE_PIPE_ALL_CPU) {
> +	if (cpu == RING_BUFFER_ALL_CPUS) {
>  		up_write(&all_cpu_access_lock);
>  	} else {
>  		mutex_unlock(&per_cpu(cpu_access_lock, cpu));
> @@ -339,30 +324,11 @@ static inline void trace_access_lock_init(void)
>  
>  #endif
>  
> -/* trace_wait is a waitqueue for tasks blocked on trace_poll */
> -static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
> -
>  /* trace_flags holds trace_options default values */
>  unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
>  	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
>  	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
> -	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS;
> -
> -static int trace_stop_count;
> -static DEFINE_RAW_SPINLOCK(tracing_start_lock);
> -
> -/**
> - * trace_wake_up - wake up tasks waiting for trace input
> - *
> - * Schedules a delayed work to wake up any task that is blocked on the
> - * trace_wait queue. These is used with trace_poll for tasks polling the
> - * trace.
> - */
> -static void trace_wake_up(struct irq_work *work)
> -{
> -	wake_up_all(&trace_wait);
> -
> -}
> +	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION;
>  
>  /**
>   * tracing_on - enable tracing buffers
> @@ -372,8 +338,8 @@ static void trace_wake_up(struct irq_work *work)
>   */
>  void tracing_on(void)
>  {
> -	if (global_trace.buffer)
> -		ring_buffer_record_on(global_trace.buffer);
> +	if (global_trace.trace_buffer.buffer)
> +		ring_buffer_record_on(global_trace.trace_buffer.buffer);
>  	/*
>  	 * This flag is only looked at when buffers haven't been
>  	 * allocated yet. We don't really care about the race
> @@ -385,6 +351,196 @@ void tracing_on(void)
>  EXPORT_SYMBOL_GPL(tracing_on);
>  
>  /**
> + * __trace_puts - write a constant string into the trace buffer.
> + * @ip:	   The address of the caller
> + * @str:   The constant string to write
> + * @size:  The size of the string.
> + */
> +int __trace_puts(unsigned long ip, const char *str, int size)
> +{
> +	struct ring_buffer_event *event;
> +	struct ring_buffer *buffer;
> +	struct print_entry *entry;
> +	unsigned long irq_flags;
> +	int alloc;
> +
> +	alloc = sizeof(*entry) + size + 2; /* possible \n added */
> +
> +	local_save_flags(irq_flags);
> +	buffer = global_trace.trace_buffer.buffer;
> +	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, alloc, 
> +					  irq_flags, preempt_count());
> +	if (!event)
> +		return 0;
> +
> +	entry = ring_buffer_event_data(event);
> +	entry->ip = ip;
> +
> +	memcpy(&entry->buf, str, size);
> +
> +	/* Add a newline if necessary */
> +	if (entry->buf[size - 1] != '\n') {
> +		entry->buf[size] = '\n';
> +		entry->buf[size + 1] = '\0';
> +	} else
> +		entry->buf[size] = '\0';
> +
> +	__buffer_unlock_commit(buffer, event);
> +
> +	return size;
> +}
> +EXPORT_SYMBOL_GPL(__trace_puts);
> +
> +/**
> + * __trace_bputs - write the pointer to a constant string into trace buffer
> + * @ip:	   The address of the caller
> + * @str:   The constant string to write to the buffer to
> + */
> +int __trace_bputs(unsigned long ip, const char *str)
> +{
> +	struct ring_buffer_event *event;
> +	struct ring_buffer *buffer;
> +	struct bputs_entry *entry;
> +	unsigned long irq_flags;
> +	int size = sizeof(struct bputs_entry);
> +
> +	local_save_flags(irq_flags);
> +	buffer = global_trace.trace_buffer.buffer;
> +	event = trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,
> +					  irq_flags, preempt_count());
> +	if (!event)
> +		return 0;
> +
> +	entry = ring_buffer_event_data(event);
> +	entry->ip			= ip;
> +	entry->str			= str;
> +
> +	__buffer_unlock_commit(buffer, event);
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(__trace_bputs);
> +
> +#ifdef CONFIG_TRACER_SNAPSHOT
> +/**
> + * trace_snapshot - take a snapshot of the current buffer.
> + *
> + * This causes a swap between the snapshot buffer and the current live
> + * tracing buffer. You can use this to take snapshots of the live
> + * trace when some condition is triggered, but continue to trace.
> + *
> + * Note, make sure to allocate the snapshot with either
> + * a tracing_snapshot_alloc(), or by doing it manually
> + * with: echo 1 > /sys/kernel/debug/tracing/snapshot
> + *
> + * If the snapshot buffer is not allocated, it will stop tracing.
> + * Basically making a permanent snapshot.
> + */
> +void tracing_snapshot(void)
> +{
> +	struct trace_array *tr = &global_trace;
> +	struct tracer *tracer = tr->current_trace;
> +	unsigned long flags;
> +
> +	if (in_nmi()) {
> +		internal_trace_puts("*** SNAPSHOT CALLED FROM NMI CONTEXT ***\n");
> +		internal_trace_puts("*** snapshot is being ignored        ***\n");
> +		return;
> +	}
> +
> +	if (!tr->allocated_snapshot) {
> +		internal_trace_puts("*** SNAPSHOT NOT ALLOCATED ***\n");
> +		internal_trace_puts("*** stopping trace here!   ***\n");
> +		tracing_off();
> +		return;
> +	}
> +
> +	/* Note, snapshot can not be used when the tracer uses it */
> +	if (tracer->use_max_tr) {
> +		internal_trace_puts("*** LATENCY TRACER ACTIVE ***\n");
> +		internal_trace_puts("*** Can not use snapshot (sorry) ***\n");
> +		return;
> +	}
> +
> +	local_irq_save(flags);
> +	update_max_tr(tr, current, smp_processor_id());
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL_GPL(tracing_snapshot);
> +
> +static int resize_buffer_duplicate_size(struct trace_buffer *trace_buf,
> +					struct trace_buffer *size_buf, int cpu_id);
> +static void set_buffer_entries(struct trace_buffer *buf, unsigned long val);
> +
> +static int alloc_snapshot(struct trace_array *tr)
> +{
> +	int ret;
> +
> +	if (!tr->allocated_snapshot) {
> +
> +		/* allocate spare buffer */
> +		ret = resize_buffer_duplicate_size(&tr->max_buffer,
> +				   &tr->trace_buffer, RING_BUFFER_ALL_CPUS);
> +		if (ret < 0)
> +			return ret;
> +
> +		tr->allocated_snapshot = true;
> +	}
> +
> +	return 0;
> +}
> +
> +void free_snapshot(struct trace_array *tr)
> +{
> +	/*
> +	 * We don't free the ring buffer. instead, resize it because
> +	 * The max_tr ring buffer has some state (e.g. ring->clock) and
> +	 * we want preserve it.
> +	 */
> +	ring_buffer_resize(tr->max_buffer.buffer, 1, RING_BUFFER_ALL_CPUS);
> +	set_buffer_entries(&tr->max_buffer, 1);
> +	tracing_reset_online_cpus(&tr->max_buffer);
> +	tr->allocated_snapshot = false;
> +}
> +
> +/**
> + * trace_snapshot_alloc - allocate and take a snapshot of the current buffer.
> + *
> + * This is similar to trace_snapshot(), but it will allocate the
> + * snapshot buffer if it isn't already allocated. Use this only
> + * where it is safe to sleep, as the allocation may sleep.
> + *
> + * This causes a swap between the snapshot buffer and the current live
> + * tracing buffer. You can use this to take snapshots of the live
> + * trace when some condition is triggered, but continue to trace.
> + */
> +void tracing_snapshot_alloc(void)
> +{
> +	struct trace_array *tr = &global_trace;
> +	int ret;
> +
> +	ret = alloc_snapshot(tr);
> +	if (WARN_ON(ret < 0))
> +		return;
> +
> +	tracing_snapshot();
> +}
> +EXPORT_SYMBOL_GPL(tracing_snapshot_alloc);
> +#else
> +void tracing_snapshot(void)
> +{
> +	WARN_ONCE(1, "Snapshot feature not enabled, but internal snapshot used");
> +}
> +EXPORT_SYMBOL_GPL(tracing_snapshot);
> +void tracing_snapshot_alloc(void)
> +{
> +	/* Give warning */
> +	tracing_snapshot();
> +}
> +EXPORT_SYMBOL_GPL(tracing_snapshot_alloc);
> +#endif /* CONFIG_TRACER_SNAPSHOT */
> +
> +/**
>   * tracing_off - turn off tracing buffers
>   *
>   * This function stops the tracing buffers from recording data.
> @@ -394,8 +550,8 @@ EXPORT_SYMBOL_GPL(tracing_on);
>   */
>  void tracing_off(void)
>  {
> -	if (global_trace.buffer)
> -		ring_buffer_record_off(global_trace.buffer);
> +	if (global_trace.trace_buffer.buffer)
> +		ring_buffer_record_off(global_trace.trace_buffer.buffer);
>  	/*
>  	 * This flag is only looked at when buffers haven't been
>  	 * allocated yet. We don't really care about the race
> @@ -411,8 +567,8 @@ EXPORT_SYMBOL_GPL(tracing_off);
>   */
>  int tracing_is_on(void)
>  {
> -	if (global_trace.buffer)
> -		return ring_buffer_record_is_on(global_trace.buffer);
> +	if (global_trace.trace_buffer.buffer)
> +		return ring_buffer_record_is_on(global_trace.trace_buffer.buffer);
>  	return !global_trace.buffer_disabled;
>  }
>  EXPORT_SYMBOL_GPL(tracing_is_on);
> @@ -479,6 +635,7 @@ static const char *trace_options[] = {
>  	"disable_on_free",
>  	"irq-info",
>  	"markers",
> +	"function-trace",
>  	NULL
>  };
>  
> @@ -490,6 +647,8 @@ static struct {
>  	{ trace_clock_local,	"local",	1 },
>  	{ trace_clock_global,	"global",	1 },
>  	{ trace_clock_counter,	"counter",	0 },
> +	{ trace_clock_jiffies,	"uptime",	1 },
> +	{ trace_clock,		"perf",		1 },
>  	ARCH_TRACE_CLOCKS
>  };
>  
> @@ -670,13 +829,14 @@ unsigned long __read_mostly	tracing_max_latency;
>  static void
>  __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
>  {
> -	struct trace_array_cpu *data = tr->data[cpu];
> -	struct trace_array_cpu *max_data;
> +	struct trace_buffer *trace_buf = &tr->trace_buffer;
> +	struct trace_buffer *max_buf = &tr->max_buffer;
> +	struct trace_array_cpu *data = per_cpu_ptr(trace_buf->data, cpu);
> +	struct trace_array_cpu *max_data = per_cpu_ptr(max_buf->data, cpu);
>  
> -	max_tr.cpu = cpu;
> -	max_tr.time_start = data->preempt_timestamp;
> +	max_buf->cpu = cpu;
> +	max_buf->time_start = data->preempt_timestamp;
>  
> -	max_data = max_tr.data[cpu];
>  	max_data->saved_latency = tracing_max_latency;
>  	max_data->critical_start = data->critical_start;
>  	max_data->critical_end = data->critical_end;
> @@ -706,22 +866,22 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
>  {
>  	struct ring_buffer *buf;
>  
> -	if (trace_stop_count)
> +	if (tr->stop_count)
>  		return;
>  
>  	WARN_ON_ONCE(!irqs_disabled());
>  
> -	if (!current_trace->allocated_snapshot) {
> +	if (!tr->allocated_snapshot) {
>  		/* Only the nop tracer should hit this when disabling */
> -		WARN_ON_ONCE(current_trace != &nop_trace);
> +		WARN_ON_ONCE(tr->current_trace != &nop_trace);
>  		return;
>  	}
>  
>  	arch_spin_lock(&ftrace_max_lock);
>  
> -	buf = tr->buffer;
> -	tr->buffer = max_tr.buffer;
> -	max_tr.buffer = buf;
> +	buf = tr->trace_buffer.buffer;
> +	tr->trace_buffer.buffer = tr->max_buffer.buffer;
> +	tr->max_buffer.buffer = buf;
>  
>  	__update_max_tr(tr, tsk, cpu);
>  	arch_spin_unlock(&ftrace_max_lock);
> @@ -740,16 +900,16 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
>  {
>  	int ret;
>  
> -	if (trace_stop_count)
> +	if (tr->stop_count)
>  		return;
>  
>  	WARN_ON_ONCE(!irqs_disabled());
> -	if (WARN_ON_ONCE(!current_trace->allocated_snapshot))
> +	if (WARN_ON_ONCE(!tr->allocated_snapshot))
>  		return;
>  
>  	arch_spin_lock(&ftrace_max_lock);
>  
> -	ret = ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
> +	ret = ring_buffer_swap_cpu(tr->max_buffer.buffer, tr->trace_buffer.buffer, cpu);
>  
>  	if (ret == -EBUSY) {
>  		/*
> @@ -758,7 +918,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
>  		 * the max trace buffer (no one writes directly to it)
>  		 * and flag that it failed.
>  		 */
> -		trace_array_printk(&max_tr, _THIS_IP_,
> +		trace_array_printk_buf(tr->max_buffer.buffer, _THIS_IP_,
>  			"Failed to swap buffers due to commit in progress\n");
>  	}
>  
> @@ -771,37 +931,78 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
>  
>  static void default_wait_pipe(struct trace_iterator *iter)
>  {
> -	DEFINE_WAIT(wait);
> +	/* Iterators are static, they should be filled or empty */
> +	if (trace_buffer_iter(iter, iter->cpu_file))
> +		return;
> +
> +	ring_buffer_wait(iter->trace_buffer->buffer, iter->cpu_file);
> +}
> +
> +#ifdef CONFIG_FTRACE_STARTUP_TEST
> +static int run_tracer_selftest(struct tracer *type)
> +{
> +	struct trace_array *tr = &global_trace;
> +	struct tracer *saved_tracer = tr->current_trace;
> +	int ret;
>  
> -	prepare_to_wait(&trace_wait, &wait, TASK_INTERRUPTIBLE);
> +	if (!type->selftest || tracing_selftest_disabled)
> +		return 0;
>  
>  	/*
> -	 * The events can happen in critical sections where
> -	 * checking a work queue can cause deadlocks.
> -	 * After adding a task to the queue, this flag is set
> -	 * only to notify events to try to wake up the queue
> -	 * using irq_work.
> -	 *
> -	 * We don't clear it even if the buffer is no longer
> -	 * empty. The flag only causes the next event to run
> -	 * irq_work to do the work queue wake up. The worse
> -	 * that can happen if we race with !trace_empty() is that
> -	 * an event will cause an irq_work to try to wake up
> -	 * an empty queue.
> -	 *
> -	 * There's no reason to protect this flag either, as
> -	 * the work queue and irq_work logic will do the necessary
> -	 * synchronization for the wake ups. The only thing
> -	 * that is necessary is that the wake up happens after
> -	 * a task has been queued. It's OK for spurious wake ups.
> +	 * Run a selftest on this tracer.
> +	 * Here we reset the trace buffer, and set the current
> +	 * tracer to be this tracer. The tracer can then run some
> +	 * internal tracing to verify that everything is in order.
> +	 * If we fail, we do not register this tracer.
>  	 */
> -	trace_wakeup_needed = true;
> +	tracing_reset_online_cpus(&tr->trace_buffer);
>  
> -	if (trace_empty(iter))
> -		schedule();
> +	tr->current_trace = type;
> +
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	if (type->use_max_tr) {
> +		/* If we expanded the buffers, make sure the max is expanded too */
> +		if (ring_buffer_expanded)
> +			ring_buffer_resize(tr->max_buffer.buffer, trace_buf_size,
> +					   RING_BUFFER_ALL_CPUS);
> +		tr->allocated_snapshot = true;
> +	}
> +#endif
> +
> +	/* the test is responsible for initializing and enabling */
> +	pr_info("Testing tracer %s: ", type->name);
> +	ret = type->selftest(type, tr);
> +	/* the test is responsible for resetting too */
> +	tr->current_trace = saved_tracer;
> +	if (ret) {
> +		printk(KERN_CONT "FAILED!\n");
> +		/* Add the warning after printing 'FAILED' */
> +		WARN_ON(1);
> +		return -1;
> +	}
> +	/* Only reset on passing, to avoid touching corrupted buffers */
> +	tracing_reset_online_cpus(&tr->trace_buffer);
> +
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	if (type->use_max_tr) {
> +		tr->allocated_snapshot = false;
>  
> -	finish_wait(&trace_wait, &wait);
> +		/* Shrink the max buffer again */
> +		if (ring_buffer_expanded)
> +			ring_buffer_resize(tr->max_buffer.buffer, 1,
> +					   RING_BUFFER_ALL_CPUS);
> +	}
> +#endif
> +
> +	printk(KERN_CONT "PASSED\n");
> +	return 0;
> +}
> +#else
> +static inline int run_tracer_selftest(struct tracer *type)
> +{
> +	return 0;
>  }
> +#endif /* CONFIG_FTRACE_STARTUP_TEST */
>  
>  /**
>   * register_tracer - register a tracer with the ftrace system.
> @@ -848,57 +1049,9 @@ int register_tracer(struct tracer *type)
>  	if (!type->wait_pipe)
>  		type->wait_pipe = default_wait_pipe;
>  
> -
> -#ifdef CONFIG_FTRACE_STARTUP_TEST
> -	if (type->selftest && !tracing_selftest_disabled) {
> -		struct tracer *saved_tracer = current_trace;
> -		struct trace_array *tr = &global_trace;
> -
> -		/*
> -		 * Run a selftest on this tracer.
> -		 * Here we reset the trace buffer, and set the current
> -		 * tracer to be this tracer. The tracer can then run some
> -		 * internal tracing to verify that everything is in order.
> -		 * If we fail, we do not register this tracer.
> -		 */
> -		tracing_reset_online_cpus(tr);
> -
> -		current_trace = type;
> -
> -		if (type->use_max_tr) {
> -			/* If we expanded the buffers, make sure the max is expanded too */
> -			if (ring_buffer_expanded)
> -				ring_buffer_resize(max_tr.buffer, trace_buf_size,
> -						   RING_BUFFER_ALL_CPUS);
> -			type->allocated_snapshot = true;
> -		}
> -
> -		/* the test is responsible for initializing and enabling */
> -		pr_info("Testing tracer %s: ", type->name);
> -		ret = type->selftest(type, tr);
> -		/* the test is responsible for resetting too */
> -		current_trace = saved_tracer;
> -		if (ret) {
> -			printk(KERN_CONT "FAILED!\n");
> -			/* Add the warning after printing 'FAILED' */
> -			WARN_ON(1);
> -			goto out;
> -		}
> -		/* Only reset on passing, to avoid touching corrupted buffers */
> -		tracing_reset_online_cpus(tr);
> -
> -		if (type->use_max_tr) {
> -			type->allocated_snapshot = false;
> -
> -			/* Shrink the max buffer again */
> -			if (ring_buffer_expanded)
> -				ring_buffer_resize(max_tr.buffer, 1,
> -						   RING_BUFFER_ALL_CPUS);
> -		}
> -
> -		printk(KERN_CONT "PASSED\n");
> -	}
> -#endif
> +	ret = run_tracer_selftest(type);
> +	if (ret < 0)
> +		goto out;
>  
>  	type->next = trace_types;
>  	trace_types = type;
> @@ -918,7 +1071,7 @@ int register_tracer(struct tracer *type)
>  	tracing_set_tracer(type->name);
>  	default_bootup_tracer = NULL;
>  	/* disable other selftests, since this will break it. */
> -	tracing_selftest_disabled = 1;
> +	tracing_selftest_disabled = true;
>  #ifdef CONFIG_FTRACE_STARTUP_TEST
>  	printk(KERN_INFO "Disabling FTRACE selftests due to running tracer '%s'\n",
>  	       type->name);
> @@ -928,9 +1081,9 @@ int register_tracer(struct tracer *type)
>  	return ret;
>  }
>  
> -void tracing_reset(struct trace_array *tr, int cpu)
> +void tracing_reset(struct trace_buffer *buf, int cpu)
>  {
> -	struct ring_buffer *buffer = tr->buffer;
> +	struct ring_buffer *buffer = buf->buffer;
>  
>  	if (!buffer)
>  		return;
> @@ -944,9 +1097,9 @@ void tracing_reset(struct trace_array *tr, int cpu)
>  	ring_buffer_record_enable(buffer);
>  }
>  
> -void tracing_reset_online_cpus(struct trace_array *tr)
> +void tracing_reset_online_cpus(struct trace_buffer *buf)
>  {
> -	struct ring_buffer *buffer = tr->buffer;
> +	struct ring_buffer *buffer = buf->buffer;
>  	int cpu;
>  
>  	if (!buffer)
> @@ -957,7 +1110,7 @@ void tracing_reset_online_cpus(struct trace_array *tr)
>  	/* Make sure all commits have finished */
>  	synchronize_sched();
>  
> -	tr->time_start = ftrace_now(tr->cpu);
> +	buf->time_start = ftrace_now(buf->cpu);
>  
>  	for_each_online_cpu(cpu)
>  		ring_buffer_reset_cpu(buffer, cpu);
> @@ -967,12 +1120,21 @@ void tracing_reset_online_cpus(struct trace_array *tr)
>  
>  void tracing_reset_current(int cpu)
>  {
> -	tracing_reset(&global_trace, cpu);
> +	tracing_reset(&global_trace.trace_buffer, cpu);
>  }
>  
> -void tracing_reset_current_online_cpus(void)
> +void tracing_reset_all_online_cpus(void)
>  {
> -	tracing_reset_online_cpus(&global_trace);
> +	struct trace_array *tr;
> +
> +	mutex_lock(&trace_types_lock);
> +	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
> +		tracing_reset_online_cpus(&tr->trace_buffer);
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +		tracing_reset_online_cpus(&tr->max_buffer);
> +#endif
> +	}
> +	mutex_unlock(&trace_types_lock);
>  }
>  
>  #define SAVED_CMDLINES 128
> @@ -995,7 +1157,7 @@ static void trace_init_cmdlines(void)
>  
>  int is_tracing_stopped(void)
>  {
> -	return trace_stop_count;
> +	return global_trace.stop_count;
>  }
>  
>  /**
> @@ -1027,12 +1189,12 @@ void tracing_start(void)
>  	if (tracing_disabled)
>  		return;
>  
> -	raw_spin_lock_irqsave(&tracing_start_lock, flags);
> -	if (--trace_stop_count) {
> -		if (trace_stop_count < 0) {
> +	raw_spin_lock_irqsave(&global_trace.start_lock, flags);
> +	if (--global_trace.stop_count) {
> +		if (global_trace.stop_count < 0) {
>  			/* Someone screwed up their debugging */
>  			WARN_ON_ONCE(1);
> -			trace_stop_count = 0;
> +			global_trace.stop_count = 0;
>  		}
>  		goto out;
>  	}
> @@ -1040,19 +1202,52 @@ void tracing_start(void)
>  	/* Prevent the buffers from switching */
>  	arch_spin_lock(&ftrace_max_lock);
>  
> -	buffer = global_trace.buffer;
> +	buffer = global_trace.trace_buffer.buffer;
>  	if (buffer)
>  		ring_buffer_record_enable(buffer);
>  
> -	buffer = max_tr.buffer;
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	buffer = global_trace.max_buffer.buffer;
>  	if (buffer)
>  		ring_buffer_record_enable(buffer);
> +#endif
>  
>  	arch_spin_unlock(&ftrace_max_lock);
>  
>  	ftrace_start();
>   out:
> -	raw_spin_unlock_irqrestore(&tracing_start_lock, flags);
> +	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
> +}
> +
> +static void tracing_start_tr(struct trace_array *tr)
> +{
> +	struct ring_buffer *buffer;
> +	unsigned long flags;
> +
> +	if (tracing_disabled)
> +		return;
> +
> +	/* If global, we need to also start the max tracer */
> +	if (tr->flags & TRACE_ARRAY_FL_GLOBAL)
> +		return tracing_start();
> +
> +	raw_spin_lock_irqsave(&tr->start_lock, flags);
> +
> +	if (--tr->stop_count) {
> +		if (tr->stop_count < 0) {
> +			/* Someone screwed up their debugging */
> +			WARN_ON_ONCE(1);
> +			tr->stop_count = 0;
> +		}
> +		goto out;
> +	}
> +
> +	buffer = tr->trace_buffer.buffer;
> +	if (buffer)
> +		ring_buffer_record_enable(buffer);
> +
> + out:
> +	raw_spin_unlock_irqrestore(&tr->start_lock, flags);
>  }
>  
>  /**
> @@ -1067,25 +1262,48 @@ void tracing_stop(void)
>  	unsigned long flags;
>  
>  	ftrace_stop();
> -	raw_spin_lock_irqsave(&tracing_start_lock, flags);
> -	if (trace_stop_count++)
> +	raw_spin_lock_irqsave(&global_trace.start_lock, flags);
> +	if (global_trace.stop_count++)
>  		goto out;
>  
>  	/* Prevent the buffers from switching */
>  	arch_spin_lock(&ftrace_max_lock);
>  
> -	buffer = global_trace.buffer;
> +	buffer = global_trace.trace_buffer.buffer;
>  	if (buffer)
>  		ring_buffer_record_disable(buffer);
>  
> -	buffer = max_tr.buffer;
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	buffer = global_trace.max_buffer.buffer;
>  	if (buffer)
>  		ring_buffer_record_disable(buffer);
> +#endif
>  
>  	arch_spin_unlock(&ftrace_max_lock);
>  
>   out:
> -	raw_spin_unlock_irqrestore(&tracing_start_lock, flags);
> +	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
> +}
> +
> +static void tracing_stop_tr(struct trace_array *tr)
> +{
> +	struct ring_buffer *buffer;
> +	unsigned long flags;
> +
> +	/* If global, we need to also stop the max tracer */
> +	if (tr->flags & TRACE_ARRAY_FL_GLOBAL)
> +		return tracing_stop();
> +
> +	raw_spin_lock_irqsave(&tr->start_lock, flags);
> +	if (tr->stop_count++)
> +		goto out;
> +
> +	buffer = tr->trace_buffer.buffer;
> +	if (buffer)
> +		ring_buffer_record_disable(buffer);
> +
> + out:
> +	raw_spin_unlock_irqrestore(&tr->start_lock, flags);
>  }
>  
>  void trace_stop_cmdline_recording(void);
> @@ -1218,11 +1436,6 @@ void
>  __buffer_unlock_commit(struct ring_buffer *buffer, struct ring_buffer_event *event)
>  {
>  	__this_cpu_write(trace_cmdline_save, true);
> -	if (trace_wakeup_needed) {
> -		trace_wakeup_needed = false;
> -		/* irq_work_queue() supplies it's own memory barriers */
> -		irq_work_queue(&trace_work_wakeup);
> -	}
>  	ring_buffer_unlock_commit(buffer, event);
>  }
>  
> @@ -1246,11 +1459,23 @@ void trace_buffer_unlock_commit(struct ring_buffer *buffer,
>  EXPORT_SYMBOL_GPL(trace_buffer_unlock_commit);
>  
>  struct ring_buffer_event *
> +trace_event_buffer_lock_reserve(struct ring_buffer **current_rb,
> +			  struct ftrace_event_file *ftrace_file,
> +			  int type, unsigned long len,
> +			  unsigned long flags, int pc)
> +{
> +	*current_rb = ftrace_file->tr->trace_buffer.buffer;
> +	return trace_buffer_lock_reserve(*current_rb,
> +					 type, len, flags, pc);
> +}
> +EXPORT_SYMBOL_GPL(trace_event_buffer_lock_reserve);
> +
> +struct ring_buffer_event *
>  trace_current_buffer_lock_reserve(struct ring_buffer **current_rb,
>  				  int type, unsigned long len,
>  				  unsigned long flags, int pc)
>  {
> -	*current_rb = global_trace.buffer;
> +	*current_rb = global_trace.trace_buffer.buffer;
>  	return trace_buffer_lock_reserve(*current_rb,
>  					 type, len, flags, pc);
>  }
> @@ -1289,7 +1514,7 @@ trace_function(struct trace_array *tr,
>  	       int pc)
>  {
>  	struct ftrace_event_call *call = &event_function;
> -	struct ring_buffer *buffer = tr->buffer;
> +	struct ring_buffer *buffer = tr->trace_buffer.buffer;
>  	struct ring_buffer_event *event;
>  	struct ftrace_entry *entry;
>  
> @@ -1430,13 +1655,14 @@ void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
>  void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
>  		   int pc)
>  {
> -	__ftrace_trace_stack(tr->buffer, flags, skip, pc, NULL);
> +	__ftrace_trace_stack(tr->trace_buffer.buffer, flags, skip, pc, NULL);
>  }
>  
>  /**
>   * trace_dump_stack - record a stack back trace in the trace buffer
> + * @skip: Number of functions to skip (helper handlers)
>   */
> -void trace_dump_stack(void)
> +void trace_dump_stack(int skip)
>  {
>  	unsigned long flags;
>  
> @@ -1445,8 +1671,13 @@ void trace_dump_stack(void)
>  
>  	local_save_flags(flags);
>  
> -	/* skipping 3 traces, seems to get us at the caller of this function */
> -	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count(), NULL);
> +	/*
> +	 * Skip 3 more, seems to get us at the caller of
> +	 * this function.
> +	 */
> +	skip += 3;
> +	__ftrace_trace_stack(global_trace.trace_buffer.buffer,
> +			     flags, skip, preempt_count(), NULL);
>  }
>  
>  static DEFINE_PER_CPU(int, user_stack_count);
> @@ -1616,7 +1847,7 @@ void trace_printk_init_buffers(void)
>  	 * directly here. If the global_trace.buffer is already
>  	 * allocated here, then this was called by module code.
>  	 */
> -	if (global_trace.buffer)
> +	if (global_trace.trace_buffer.buffer)
>  		tracing_start_cmdline_record();
>  }
>  
> @@ -1676,7 +1907,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
>  
>  	local_save_flags(flags);
>  	size = sizeof(*entry) + sizeof(u32) * len;
> -	buffer = tr->buffer;
> +	buffer = tr->trace_buffer.buffer;
>  	event = trace_buffer_lock_reserve(buffer, TRACE_BPRINT, size,
>  					  flags, pc);
>  	if (!event)
> @@ -1699,27 +1930,12 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(trace_vbprintk);
>  
> -int trace_array_printk(struct trace_array *tr,
> -		       unsigned long ip, const char *fmt, ...)
> -{
> -	int ret;
> -	va_list ap;
> -
> -	if (!(trace_flags & TRACE_ITER_PRINTK))
> -		return 0;
> -
> -	va_start(ap, fmt);
> -	ret = trace_array_vprintk(tr, ip, fmt, ap);
> -	va_end(ap);
> -	return ret;
> -}
> -
> -int trace_array_vprintk(struct trace_array *tr,
> -			unsigned long ip, const char *fmt, va_list args)
> +static int
> +__trace_array_vprintk(struct ring_buffer *buffer,
> +		      unsigned long ip, const char *fmt, va_list args)
>  {
>  	struct ftrace_event_call *call = &event_print;
>  	struct ring_buffer_event *event;
> -	struct ring_buffer *buffer;
>  	int len = 0, size, pc;
>  	struct print_entry *entry;
>  	unsigned long flags;
> @@ -1747,7 +1963,6 @@ int trace_array_vprintk(struct trace_array *tr,
>  
>  	local_save_flags(flags);
>  	size = sizeof(*entry) + len + 1;
> -	buffer = tr->buffer;
>  	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
>  					  flags, pc);
>  	if (!event)
> @@ -1768,8 +1983,44 @@ int trace_array_vprintk(struct trace_array *tr,
>  	return len;
>  }
>  
> -int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
> -{
> +int trace_array_vprintk(struct trace_array *tr,
> +			unsigned long ip, const char *fmt, va_list args)
> +{
> +	return __trace_array_vprintk(tr->trace_buffer.buffer, ip, fmt, args);
> +}
> +
> +int trace_array_printk(struct trace_array *tr,
> +		       unsigned long ip, const char *fmt, ...)
> +{
> +	int ret;
> +	va_list ap;
> +
> +	if (!(trace_flags & TRACE_ITER_PRINTK))
> +		return 0;
> +
> +	va_start(ap, fmt);
> +	ret = trace_array_vprintk(tr, ip, fmt, ap);
> +	va_end(ap);
> +	return ret;
> +}
> +
> +int trace_array_printk_buf(struct ring_buffer *buffer,
> +			   unsigned long ip, const char *fmt, ...)
> +{
> +	int ret;
> +	va_list ap;
> +
> +	if (!(trace_flags & TRACE_ITER_PRINTK))
> +		return 0;
> +
> +	va_start(ap, fmt);
> +	ret = __trace_array_vprintk(buffer, ip, fmt, ap);
> +	va_end(ap);
> +	return ret;
> +}
> +
> +int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
> +{
>  	return trace_array_vprintk(&global_trace, ip, fmt, args);
>  }
>  EXPORT_SYMBOL_GPL(trace_vprintk);
> @@ -1793,7 +2044,7 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts,
>  	if (buf_iter)
>  		event = ring_buffer_iter_peek(buf_iter, ts);
>  	else
> -		event = ring_buffer_peek(iter->tr->buffer, cpu, ts,
> +		event = ring_buffer_peek(iter->trace_buffer->buffer, cpu, ts,
>  					 lost_events);
>  
>  	if (event) {
> @@ -1808,7 +2059,7 @@ static struct trace_entry *
>  __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
>  		  unsigned long *missing_events, u64 *ent_ts)
>  {
> -	struct ring_buffer *buffer = iter->tr->buffer;
> +	struct ring_buffer *buffer = iter->trace_buffer->buffer;
>  	struct trace_entry *ent, *next = NULL;
>  	unsigned long lost_events = 0, next_lost = 0;
>  	int cpu_file = iter->cpu_file;
> @@ -1821,7 +2072,7 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
>  	 * If we are in a per_cpu trace file, don't bother by iterating over
>  	 * all cpu and peek directly.
>  	 */
> -	if (cpu_file > TRACE_PIPE_ALL_CPU) {
> +	if (cpu_file > RING_BUFFER_ALL_CPUS) {
>  		if (ring_buffer_empty_cpu(buffer, cpu_file))
>  			return NULL;
>  		ent = peek_next_entry(iter, cpu_file, ent_ts, missing_events);
> @@ -1885,7 +2136,7 @@ void *trace_find_next_entry_inc(struct trace_iterator *iter)
>  
>  static void trace_consume(struct trace_iterator *iter)
>  {
> -	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts,
> +	ring_buffer_consume(iter->trace_buffer->buffer, iter->cpu, &iter->ts,
>  			    &iter->lost_events);
>  }
>  
> @@ -1918,13 +2169,12 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
>  
>  void tracing_iter_reset(struct trace_iterator *iter, int cpu)
>  {
> -	struct trace_array *tr = iter->tr;
>  	struct ring_buffer_event *event;
>  	struct ring_buffer_iter *buf_iter;
>  	unsigned long entries = 0;
>  	u64 ts;
>  
> -	tr->data[cpu]->skipped_entries = 0;
> +	per_cpu_ptr(iter->trace_buffer->data, cpu)->skipped_entries = 0;
>  
>  	buf_iter = trace_buffer_iter(iter, cpu);
>  	if (!buf_iter)
> @@ -1938,13 +2188,13 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
>  	 * by the timestamp being before the start of the buffer.
>  	 */
>  	while ((event = ring_buffer_iter_peek(buf_iter, &ts))) {
> -		if (ts >= iter->tr->time_start)
> +		if (ts >= iter->trace_buffer->time_start)
>  			break;
>  		entries++;
>  		ring_buffer_read(buf_iter, NULL);
>  	}
>  
> -	tr->data[cpu]->skipped_entries = entries;
> +	per_cpu_ptr(iter->trace_buffer->data, cpu)->skipped_entries = entries;
>  }
>  
>  /*
> @@ -1954,6 +2204,7 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
>  static void *s_start(struct seq_file *m, loff_t *pos)
>  {
>  	struct trace_iterator *iter = m->private;
> +	struct trace_array *tr = iter->tr;
>  	int cpu_file = iter->cpu_file;
>  	void *p = NULL;
>  	loff_t l = 0;
> @@ -1966,12 +2217,14 @@ static void *s_start(struct seq_file *m, loff_t *pos)
>  	 * will point to the same string as current_trace->name.
>  	 */
>  	mutex_lock(&trace_types_lock);
> -	if (unlikely(current_trace && iter->trace->name != current_trace->name))
> -		*iter->trace = *current_trace;
> +	if (unlikely(tr->current_trace && iter->trace->name != tr->current_trace->name))
> +		*iter->trace = *tr->current_trace;
>  	mutex_unlock(&trace_types_lock);
>  
> +#ifdef CONFIG_TRACER_MAX_TRACE
>  	if (iter->snapshot && iter->trace->use_max_tr)
>  		return ERR_PTR(-EBUSY);
> +#endif
>  
>  	if (!iter->snapshot)
>  		atomic_inc(&trace_record_cmdline_disabled);
> @@ -1981,7 +2234,7 @@ static void *s_start(struct seq_file *m, loff_t *pos)
>  		iter->cpu = 0;
>  		iter->idx = -1;
>  
> -		if (cpu_file == TRACE_PIPE_ALL_CPU) {
> +		if (cpu_file == RING_BUFFER_ALL_CPUS) {
>  			for_each_tracing_cpu(cpu)
>  				tracing_iter_reset(iter, cpu);
>  		} else
> @@ -2013,17 +2266,21 @@ static void s_stop(struct seq_file *m, void *p)
>  {
>  	struct trace_iterator *iter = m->private;
>  
> +#ifdef CONFIG_TRACER_MAX_TRACE
>  	if (iter->snapshot && iter->trace->use_max_tr)
>  		return;
> +#endif
>  
>  	if (!iter->snapshot)
>  		atomic_dec(&trace_record_cmdline_disabled);
> +
>  	trace_access_unlock(iter->cpu_file);
>  	trace_event_read_unlock();
>  }
>  
>  static void
> -get_total_entries(struct trace_array *tr, unsigned long *total, unsigned long *entries)
> +get_total_entries(struct trace_buffer *buf,
> +		  unsigned long *total, unsigned long *entries)
>  {
>  	unsigned long count;
>  	int cpu;
> @@ -2032,19 +2289,19 @@ get_total_entries(struct trace_array *tr, unsigned long *total, unsigned long *e
>  	*entries = 0;
>  
>  	for_each_tracing_cpu(cpu) {
> -		count = ring_buffer_entries_cpu(tr->buffer, cpu);
> +		count = ring_buffer_entries_cpu(buf->buffer, cpu);
>  		/*
>  		 * If this buffer has skipped entries, then we hold all
>  		 * entries for the trace and we need to ignore the
>  		 * ones before the time stamp.
>  		 */
> -		if (tr->data[cpu]->skipped_entries) {
> -			count -= tr->data[cpu]->skipped_entries;
> +		if (per_cpu_ptr(buf->data, cpu)->skipped_entries) {
> +			count -= per_cpu_ptr(buf->data, cpu)->skipped_entries;
>  			/* total is the same as the entries */
>  			*total += count;
>  		} else
>  			*total += count +
> -				ring_buffer_overrun_cpu(tr->buffer, cpu);
> +				ring_buffer_overrun_cpu(buf->buffer, cpu);
>  		*entries += count;
>  	}
>  }
> @@ -2061,27 +2318,27 @@ static void print_lat_help_header(struct seq_file *m)
>  	seq_puts(m, "#     \\   /      |||||  \\    |   /           \n");
>  }
>  
> -static void print_event_info(struct trace_array *tr, struct seq_file *m)
> +static void print_event_info(struct trace_buffer *buf, struct seq_file *m)
>  {
>  	unsigned long total;
>  	unsigned long entries;
>  
> -	get_total_entries(tr, &total, &entries);
> +	get_total_entries(buf, &total, &entries);
>  	seq_printf(m, "# entries-in-buffer/entries-written: %lu/%lu   #P:%d\n",
>  		   entries, total, num_online_cpus());
>  	seq_puts(m, "#\n");
>  }
>  
> -static void print_func_help_header(struct trace_array *tr, struct seq_file *m)
> +static void print_func_help_header(struct trace_buffer *buf, struct seq_file *m)
>  {
> -	print_event_info(tr, m);
> +	print_event_info(buf, m);
>  	seq_puts(m, "#           TASK-PID   CPU#      TIMESTAMP  FUNCTION\n");
>  	seq_puts(m, "#              | |       |          |         |\n");
>  }
>  
> -static void print_func_help_header_irq(struct trace_array *tr, struct seq_file *m)
> +static void print_func_help_header_irq(struct trace_buffer *buf, struct seq_file *m)
>  {
> -	print_event_info(tr, m);
> +	print_event_info(buf, m);
>  	seq_puts(m, "#                              _-----=> irqs-off\n");
>  	seq_puts(m, "#                             / _----=> need-resched\n");
>  	seq_puts(m, "#                            | / _---=> hardirq/softirq\n");
> @@ -2095,16 +2352,16 @@ void
>  print_trace_header(struct seq_file *m, struct trace_iterator *iter)
>  {
>  	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
> -	struct trace_array *tr = iter->tr;
> -	struct trace_array_cpu *data = tr->data[tr->cpu];
> -	struct tracer *type = current_trace;
> +	struct trace_buffer *buf = iter->trace_buffer;
> +	struct trace_array_cpu *data = per_cpu_ptr(buf->data, buf->cpu);
> +	struct tracer *type = iter->trace;
>  	unsigned long entries;
>  	unsigned long total;
>  	const char *name = "preemption";
>  
>  	name = type->name;
>  
> -	get_total_entries(tr, &total, &entries);
> +	get_total_entries(buf, &total, &entries);
>  
>  	seq_printf(m, "# %s latency trace v1.1.5 on %s\n",
>  		   name, UTS_RELEASE);
> @@ -2115,7 +2372,7 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
>  		   nsecs_to_usecs(data->saved_latency),
>  		   entries,
>  		   total,
> -		   tr->cpu,
> +		   buf->cpu,
>  #if defined(CONFIG_PREEMPT_NONE)
>  		   "server",
>  #elif defined(CONFIG_PREEMPT_VOLUNTARY)
> @@ -2166,7 +2423,7 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
>  	if (cpumask_test_cpu(iter->cpu, iter->started))
>  		return;
>  
> -	if (iter->tr->data[iter->cpu]->skipped_entries)
> +	if (per_cpu_ptr(iter->trace_buffer->data, iter->cpu)->skipped_entries)
>  		return;
>  
>  	cpumask_set_cpu(iter->cpu, iter->started);
> @@ -2289,14 +2546,14 @@ int trace_empty(struct trace_iterator *iter)
>  	int cpu;
>  
>  	/* If we are looking at one CPU buffer, only check that one */
> -	if (iter->cpu_file != TRACE_PIPE_ALL_CPU) {
> +	if (iter->cpu_file != RING_BUFFER_ALL_CPUS) {
>  		cpu = iter->cpu_file;
>  		buf_iter = trace_buffer_iter(iter, cpu);
>  		if (buf_iter) {
>  			if (!ring_buffer_iter_empty(buf_iter))
>  				return 0;
>  		} else {
> -			if (!ring_buffer_empty_cpu(iter->tr->buffer, cpu))
> +			if (!ring_buffer_empty_cpu(iter->trace_buffer->buffer, cpu))
>  				return 0;
>  		}
>  		return 1;
> @@ -2308,7 +2565,7 @@ int trace_empty(struct trace_iterator *iter)
>  			if (!ring_buffer_iter_empty(buf_iter))
>  				return 0;
>  		} else {
> -			if (!ring_buffer_empty_cpu(iter->tr->buffer, cpu))
> +			if (!ring_buffer_empty_cpu(iter->trace_buffer->buffer, cpu))
>  				return 0;
>  		}
>  	}
> @@ -2332,6 +2589,11 @@ enum print_line_t print_trace_line(struct trace_iterator *iter)
>  			return ret;
>  	}
>  
> +	if (iter->ent->type == TRACE_BPUTS &&
> +			trace_flags & TRACE_ITER_PRINTK &&
> +			trace_flags & TRACE_ITER_PRINTK_MSGONLY)
> +		return trace_print_bputs_msg_only(iter);
> +
>  	if (iter->ent->type == TRACE_BPRINT &&
>  			trace_flags & TRACE_ITER_PRINTK &&
>  			trace_flags & TRACE_ITER_PRINTK_MSGONLY)
> @@ -2386,9 +2648,9 @@ void trace_default_header(struct seq_file *m)
>  	} else {
>  		if (!(trace_flags & TRACE_ITER_VERBOSE)) {
>  			if (trace_flags & TRACE_ITER_IRQ_INFO)
> -				print_func_help_header_irq(iter->tr, m);
> +				print_func_help_header_irq(iter->trace_buffer, m);
>  			else
> -				print_func_help_header(iter->tr, m);
> +				print_func_help_header(iter->trace_buffer, m);
>  		}
>  	}
>  }
> @@ -2402,14 +2664,8 @@ static void test_ftrace_alive(struct seq_file *m)
>  }
>  
>  #ifdef CONFIG_TRACER_MAX_TRACE
> -static void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter)
> +static void show_snapshot_main_help(struct seq_file *m)
>  {
> -	if (iter->trace->allocated_snapshot)
> -		seq_printf(m, "#\n# * Snapshot is allocated *\n#\n");
> -	else
> -		seq_printf(m, "#\n# * Snapshot is freed *\n#\n");
> -
> -	seq_printf(m, "# Snapshot commands:\n");
>  	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
>  	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
>  	seq_printf(m, "#                      Takes a snapshot of the main buffer.\n");
> @@ -2417,6 +2673,35 @@ static void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter)
>  	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
>  	seq_printf(m, "#                       is not a '0' or '1')\n");
>  }
> +
> +static void show_snapshot_percpu_help(struct seq_file *m)
> +{
> +	seq_printf(m, "# echo 0 > snapshot : Invalid for per_cpu snapshot file.\n");
> +#ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
> +	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
> +	seq_printf(m, "#                      Takes a snapshot of the main buffer for this cpu.\n");
> +#else
> +	seq_printf(m, "# echo 1 > snapshot : Not supported with this kernel.\n");
> +	seq_printf(m, "#                     Must use main snapshot file to allocate.\n");
> +#endif
> +	seq_printf(m, "# echo 2 > snapshot : Clears this cpu's snapshot buffer (but does not allocate)\n");
> +	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
> +	seq_printf(m, "#                       is not a '0' or '1')\n");
> +}
> +
> +static void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter)
> +{
> +	if (iter->tr->allocated_snapshot)
> +		seq_printf(m, "#\n# * Snapshot is allocated *\n#\n");
> +	else
> +		seq_printf(m, "#\n# * Snapshot is freed *\n#\n");
> +
> +	seq_printf(m, "# Snapshot commands:\n");
> +	if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
> +		show_snapshot_main_help(m);
> +	else
> +		show_snapshot_percpu_help(m);
> +}
>  #else
>  /* Should never be called */
>  static inline void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter) { }
> @@ -2476,7 +2761,8 @@ static const struct seq_operations tracer_seq_ops = {
>  static struct trace_iterator *
>  __tracing_open(struct inode *inode, struct file *file, bool snapshot)
>  {
> -	long cpu_file = (long) inode->i_private;
> +	struct trace_cpu *tc = inode->i_private;
> +	struct trace_array *tr = tc->tr;
>  	struct trace_iterator *iter;
>  	int cpu;
>  
> @@ -2501,26 +2787,31 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
>  	if (!iter->trace)
>  		goto fail;
>  
> -	*iter->trace = *current_trace;
> +	*iter->trace = *tr->current_trace;
>  
>  	if (!zalloc_cpumask_var(&iter->started, GFP_KERNEL))
>  		goto fail;
>  
> -	if (current_trace->print_max || snapshot)
> -		iter->tr = &max_tr;
> +	iter->tr = tr;
> +
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	/* Currently only the top directory has a snapshot */
> +	if (tr->current_trace->print_max || snapshot)
> +		iter->trace_buffer = &tr->max_buffer;
>  	else
> -		iter->tr = &global_trace;
> +#endif
> +		iter->trace_buffer = &tr->trace_buffer;
>  	iter->snapshot = snapshot;
>  	iter->pos = -1;
>  	mutex_init(&iter->mutex);
> -	iter->cpu_file = cpu_file;
> +	iter->cpu_file = tc->cpu;
>  
>  	/* Notify the tracer early; before we stop tracing. */
>  	if (iter->trace && iter->trace->open)
>  		iter->trace->open(iter);
>  
>  	/* Annotate start of buffers if we had overruns */
> -	if (ring_buffer_overruns(iter->tr->buffer))
> +	if (ring_buffer_overruns(iter->trace_buffer->buffer))
>  		iter->iter_flags |= TRACE_FILE_ANNOTATE;
>  
>  	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
> @@ -2529,12 +2820,12 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
>  
>  	/* stop the trace while dumping if we are not opening "snapshot" */
>  	if (!iter->snapshot)
> -		tracing_stop();
> +		tracing_stop_tr(tr);
>  
> -	if (iter->cpu_file == TRACE_PIPE_ALL_CPU) {
> +	if (iter->cpu_file == RING_BUFFER_ALL_CPUS) {
>  		for_each_tracing_cpu(cpu) {
>  			iter->buffer_iter[cpu] =
> -				ring_buffer_read_prepare(iter->tr->buffer, cpu);
> +				ring_buffer_read_prepare(iter->trace_buffer->buffer, cpu);
>  		}
>  		ring_buffer_read_prepare_sync();
>  		for_each_tracing_cpu(cpu) {
> @@ -2544,12 +2835,14 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
>  	} else {
>  		cpu = iter->cpu_file;
>  		iter->buffer_iter[cpu] =
> -			ring_buffer_read_prepare(iter->tr->buffer, cpu);
> +			ring_buffer_read_prepare(iter->trace_buffer->buffer, cpu);
>  		ring_buffer_read_prepare_sync();
>  		ring_buffer_read_start(iter->buffer_iter[cpu]);
>  		tracing_iter_reset(iter, cpu);
>  	}
>  
> +	tr->ref++;
> +
>  	mutex_unlock(&trace_types_lock);
>  
>  	return iter;
> @@ -2576,14 +2869,20 @@ static int tracing_release(struct inode *inode, struct file *file)
>  {
>  	struct seq_file *m = file->private_data;
>  	struct trace_iterator *iter;
> +	struct trace_array *tr;
>  	int cpu;
>  
>  	if (!(file->f_mode & FMODE_READ))
>  		return 0;
>  
>  	iter = m->private;
> +	tr = iter->tr;
>  
>  	mutex_lock(&trace_types_lock);
> +
> +	WARN_ON(!tr->ref);
> +	tr->ref--;
> +
>  	for_each_tracing_cpu(cpu) {
>  		if (iter->buffer_iter[cpu])
>  			ring_buffer_read_finish(iter->buffer_iter[cpu]);
> @@ -2594,7 +2893,7 @@ static int tracing_release(struct inode *inode, struct file *file)
>  
>  	if (!iter->snapshot)
>  		/* reenable tracing if it was previously enabled */
> -		tracing_start();
> +		tracing_start_tr(tr);
>  	mutex_unlock(&trace_types_lock);
>  
>  	mutex_destroy(&iter->mutex);
> @@ -2613,12 +2912,13 @@ static int tracing_open(struct inode *inode, struct file *file)
>  	/* If this file was open for write, then erase contents */
>  	if ((file->f_mode & FMODE_WRITE) &&
>  	    (file->f_flags & O_TRUNC)) {
> -		long cpu = (long) inode->i_private;
> +		struct trace_cpu *tc = inode->i_private;
> +		struct trace_array *tr = tc->tr;
>  
> -		if (cpu == TRACE_PIPE_ALL_CPU)
> -			tracing_reset_online_cpus(&global_trace);
> +		if (tc->cpu == RING_BUFFER_ALL_CPUS)
> +			tracing_reset_online_cpus(&tr->trace_buffer);
>  		else
> -			tracing_reset(&global_trace, cpu);
> +			tracing_reset(&tr->trace_buffer, tc->cpu);
>  	}
>  
>  	if (file->f_mode & FMODE_READ) {
> @@ -2765,8 +3065,9 @@ static ssize_t
>  tracing_cpumask_write(struct file *filp, const char __user *ubuf,
>  		      size_t count, loff_t *ppos)
>  {
> -	int err, cpu;
> +	struct trace_array *tr = filp->private_data;
>  	cpumask_var_t tracing_cpumask_new;
> +	int err, cpu;
>  
>  	if (!alloc_cpumask_var(&tracing_cpumask_new, GFP_KERNEL))
>  		return -ENOMEM;
> @@ -2786,13 +3087,13 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
>  		 */
>  		if (cpumask_test_cpu(cpu, tracing_cpumask) &&
>  				!cpumask_test_cpu(cpu, tracing_cpumask_new)) {
> -			atomic_inc(&global_trace.data[cpu]->disabled);
> -			ring_buffer_record_disable_cpu(global_trace.buffer, cpu);
> +			atomic_inc(&per_cpu_ptr(tr->trace_buffer.data, cpu)->disabled);
> +			ring_buffer_record_disable_cpu(tr->trace_buffer.buffer, cpu);
>  		}
>  		if (!cpumask_test_cpu(cpu, tracing_cpumask) &&
>  				cpumask_test_cpu(cpu, tracing_cpumask_new)) {
> -			atomic_dec(&global_trace.data[cpu]->disabled);
> -			ring_buffer_record_enable_cpu(global_trace.buffer, cpu);
> +			atomic_dec(&per_cpu_ptr(tr->trace_buffer.data, cpu)->disabled);
> +			ring_buffer_record_enable_cpu(tr->trace_buffer.buffer, cpu);
>  		}
>  	}
>  	arch_spin_unlock(&ftrace_max_lock);
> @@ -2821,12 +3122,13 @@ static const struct file_operations tracing_cpumask_fops = {
>  static int tracing_trace_options_show(struct seq_file *m, void *v)
>  {
>  	struct tracer_opt *trace_opts;
> +	struct trace_array *tr = m->private;
>  	u32 tracer_flags;
>  	int i;
>  
>  	mutex_lock(&trace_types_lock);
> -	tracer_flags = current_trace->flags->val;
> -	trace_opts = current_trace->flags->opts;
> +	tracer_flags = tr->current_trace->flags->val;
> +	trace_opts = tr->current_trace->flags->opts;
>  
>  	for (i = 0; trace_options[i]; i++) {
>  		if (trace_flags & (1 << i))
> @@ -2890,15 +3192,15 @@ int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set)
>  	return 0;
>  }
>  
> -int set_tracer_flag(unsigned int mask, int enabled)
> +int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
>  {
>  	/* do nothing if flag is already set */
>  	if (!!(trace_flags & mask) == !!enabled)
>  		return 0;
>  
>  	/* Give the tracer a chance to approve the change */
> -	if (current_trace->flag_changed)
> -		if (current_trace->flag_changed(current_trace, mask, !!enabled))
> +	if (tr->current_trace->flag_changed)
> +		if (tr->current_trace->flag_changed(tr->current_trace, mask, !!enabled))
>  			return -EINVAL;
>  
>  	if (enabled)
> @@ -2910,9 +3212,9 @@ int set_tracer_flag(unsigned int mask, int enabled)
>  		trace_event_enable_cmd_record(enabled);
>  
>  	if (mask == TRACE_ITER_OVERWRITE) {
> -		ring_buffer_change_overwrite(global_trace.buffer, enabled);
> +		ring_buffer_change_overwrite(tr->trace_buffer.buffer, enabled);
>  #ifdef CONFIG_TRACER_MAX_TRACE
> -		ring_buffer_change_overwrite(max_tr.buffer, enabled);
> +		ring_buffer_change_overwrite(tr->max_buffer.buffer, enabled);
>  #endif
>  	}
>  
> @@ -2922,7 +3224,7 @@ int set_tracer_flag(unsigned int mask, int enabled)
>  	return 0;
>  }
>  
> -static int trace_set_options(char *option)
> +static int trace_set_options(struct trace_array *tr, char *option)
>  {
>  	char *cmp;
>  	int neg = 0;
> @@ -2940,14 +3242,14 @@ static int trace_set_options(char *option)
>  
>  	for (i = 0; trace_options[i]; i++) {
>  		if (strcmp(cmp, trace_options[i]) == 0) {
> -			ret = set_tracer_flag(1 << i, !neg);
> +			ret = set_tracer_flag(tr, 1 << i, !neg);
>  			break;
>  		}
>  	}
>  
>  	/* If no option could be set, test the specific tracer options */
>  	if (!trace_options[i])
> -		ret = set_tracer_option(current_trace, cmp, neg);
> +		ret = set_tracer_option(tr->current_trace, cmp, neg);
>  
>  	mutex_unlock(&trace_types_lock);
>  
> @@ -2958,6 +3260,8 @@ static ssize_t
>  tracing_trace_options_write(struct file *filp, const char __user *ubuf,
>  			size_t cnt, loff_t *ppos)
>  {
> +	struct seq_file *m = filp->private_data;
> +	struct trace_array *tr = m->private;
>  	char buf[64];
>  	int ret;
>  
> @@ -2969,7 +3273,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
>  
>  	buf[cnt] = 0;
>  
> -	ret = trace_set_options(buf);
> +	ret = trace_set_options(tr, buf);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -2982,7 +3286,8 @@ static int tracing_trace_options_open(struct inode *inode, struct file *file)
>  {
>  	if (tracing_disabled)
>  		return -ENODEV;
> -	return single_open(file, tracing_trace_options_show, NULL);
> +
> +	return single_open(file, tracing_trace_options_show, inode->i_private);
>  }
>  
>  static const struct file_operations tracing_iter_fops = {
> @@ -2995,20 +3300,84 @@ static const struct file_operations tracing_iter_fops = {
>  
>  static const char readme_msg[] =
>  	"tracing mini-HOWTO:\n\n"
> -	"# mount -t debugfs nodev /sys/kernel/debug\n\n"
> -	"# cat /sys/kernel/debug/tracing/available_tracers\n"
> -	"wakeup wakeup_rt preemptirqsoff preemptoff irqsoff function nop\n\n"
> -	"# cat /sys/kernel/debug/tracing/current_tracer\n"
> -	"nop\n"
> -	"# echo wakeup > /sys/kernel/debug/tracing/current_tracer\n"
> -	"# cat /sys/kernel/debug/tracing/current_tracer\n"
> -	"wakeup\n"
> -	"# cat /sys/kernel/debug/tracing/trace_options\n"
> -	"noprint-parent nosym-offset nosym-addr noverbose\n"
> -	"# echo print-parent > /sys/kernel/debug/tracing/trace_options\n"
> -	"# echo 1 > /sys/kernel/debug/tracing/tracing_on\n"
> -	"# cat /sys/kernel/debug/tracing/trace > /tmp/trace.txt\n"
> -	"# echo 0 > /sys/kernel/debug/tracing/tracing_on\n"
> +	"# echo 0 > tracing_on : quick way to disable tracing\n"
> +	"# echo 1 > tracing_on : quick way to re-enable tracing\n\n"
> +	" Important files:\n"
> +	"  trace\t\t\t- The static contents of the buffer\n"
> +	"\t\t\t  To clear the buffer write into this file: echo > trace\n"
> +	"  trace_pipe\t\t- A consuming read to see the contents of the buffer\n"
> +	"  current_tracer\t- function and latency tracers\n"
> +	"  available_tracers\t- list of configured tracers for current_tracer\n"
> +	"  buffer_size_kb\t- view and modify size of per cpu buffer\n"
> +	"  buffer_total_size_kb  - view total size of all cpu buffers\n\n"
> +	"  trace_clock\t\t-change the clock used to order events\n"
> +	"       local:   Per cpu clock but may not be synced across CPUs\n"
> +	"      global:   Synced across CPUs but slows tracing down.\n"
> +	"     counter:   Not a clock, but just an increment\n"
> +	"      uptime:   Jiffy counter from time of boot\n"
> +	"        perf:   Same clock that perf events use\n"
> +#ifdef CONFIG_X86_64
> +	"     x86-tsc:   TSC cycle counter\n"
> +#endif
> +	"\n  trace_marker\t\t- Writes into this file writes into the kernel buffer\n"
> +	"  tracing_cpumask\t- Limit which CPUs to trace\n"
> +	"  instances\t\t- Make sub-buffers with: mkdir instances/foo\n"
> +	"\t\t\t  Remove sub-buffer with rmdir\n"
> +	"  trace_options\t\t- Set format or modify how tracing happens\n"
> +	"\t\t\t  Disable an option by adding a suffix 'no' to the option name\n"
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +	"\n  available_filter_functions - list of functions that can be filtered on\n"
> +	"  set_ftrace_filter\t- echo function name in here to only trace these functions\n"
> +	"            accepts: func_full_name, *func_end, func_begin*, *func_middle*\n"
> +	"            modules: Can select a group via module\n"
> +	"             Format: :mod:<module-name>\n"
> +	"             example: echo :mod:ext3 > set_ftrace_filter\n"
> +	"            triggers: a command to perform when function is hit\n"
> +	"              Format: <function>:<trigger>[:count]\n"
> +	"             trigger: traceon, traceoff\n"
> +	"                      enable_event:<system>:<event>\n"
> +	"                      disable_event:<system>:<event>\n"
> +#ifdef CONFIG_STACKTRACE
> +	"                      stacktrace\n"
> +#endif
> +#ifdef CONFIG_TRACER_SNAPSHOT
> +	"                      snapshot\n"
> +#endif
> +	"             example: echo do_fault:traceoff > set_ftrace_filter\n"
> +	"                      echo do_trap:traceoff:3 > set_ftrace_filter\n"
> +	"             The first one will disable tracing every time do_fault is hit\n"
> +	"             The second will disable tracing at most 3 times when do_trap is hit\n"
> +	"               The first time do trap is hit and it disables tracing, the counter\n"
> +	"               will decrement to 2. If tracing is already disabled, the counter\n"
> +	"               will not decrement. It only decrements when the trigger did work\n"
> +	"             To remove trigger without count:\n"
> +	"               echo '!<function>:<trigger> > set_ftrace_filter\n"
> +	"             To remove trigger with a count:\n"
> +	"               echo '!<function>:<trigger>:0 > set_ftrace_filter\n"
> +	"  set_ftrace_notrace\t- echo function name in here to never trace.\n"
> +	"            accepts: func_full_name, *func_end, func_begin*, *func_middle*\n"
> +	"            modules: Can select a group via module command :mod:\n"
> +	"            Does not accept triggers\n"
> +#endif /* CONFIG_DYNAMIC_FTRACE */
> +#ifdef CONFIG_FUNCTION_TRACER
> +	"  set_ftrace_pid\t- Write pid(s) to only function trace those pids (function)\n"
> +#endif
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	"  set_graph_function\t- Trace the nested calls of a function (function_graph)\n"
> +	"  max_graph_depth\t- Trace a limited depth of nested calls (0 is unlimited)\n"
> +#endif
> +#ifdef CONFIG_TRACER_SNAPSHOT
> +	"\n  snapshot\t\t- Like 'trace' but shows the content of the static snapshot buffer\n"
> +	"\t\t\t  Read the contents for more information\n"
> +#endif
> +#ifdef CONFIG_STACKTRACE
> +	"  stack_trace\t\t- Shows the max stack trace when active\n"
> +	"  stack_max_size\t- Shows current max stack size that was traced\n"
> +	"\t\t\t  Write into this file to reset the max size (trigger a new trace)\n"
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +	"  stack_trace_filter\t- Like set_ftrace_filter but limits what stack_trace traces\n"
> +#endif
> +#endif /* CONFIG_STACKTRACE */
>  ;
>  
>  static ssize_t
> @@ -3080,11 +3449,12 @@ static ssize_t
>  tracing_set_trace_read(struct file *filp, char __user *ubuf,
>  		       size_t cnt, loff_t *ppos)
>  {
> +	struct trace_array *tr = filp->private_data;
>  	char buf[MAX_TRACER_SIZE+2];
>  	int r;
>  
>  	mutex_lock(&trace_types_lock);
> -	r = sprintf(buf, "%s\n", current_trace->name);
> +	r = sprintf(buf, "%s\n", tr->current_trace->name);
>  	mutex_unlock(&trace_types_lock);
>  
>  	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
> @@ -3092,43 +3462,48 @@ tracing_set_trace_read(struct file *filp, char __user *ubuf,
>  
>  int tracer_init(struct tracer *t, struct trace_array *tr)
>  {
> -	tracing_reset_online_cpus(tr);
> +	tracing_reset_online_cpus(&tr->trace_buffer);
>  	return t->init(tr);
>  }
>  
> -static void set_buffer_entries(struct trace_array *tr, unsigned long val)
> +static void set_buffer_entries(struct trace_buffer *buf, unsigned long val)
>  {
>  	int cpu;
> +
>  	for_each_tracing_cpu(cpu)
> -		tr->data[cpu]->entries = val;
> +		per_cpu_ptr(buf->data, cpu)->entries = val;
>  }
>  
> +#ifdef CONFIG_TRACER_MAX_TRACE
>  /* resize @tr's buffer to the size of @size_tr's entries */
> -static int resize_buffer_duplicate_size(struct trace_array *tr,
> -					struct trace_array *size_tr, int cpu_id)
> +static int resize_buffer_duplicate_size(struct trace_buffer *trace_buf,
> +					struct trace_buffer *size_buf, int cpu_id)
>  {
>  	int cpu, ret = 0;
>  
>  	if (cpu_id == RING_BUFFER_ALL_CPUS) {
>  		for_each_tracing_cpu(cpu) {
> -			ret = ring_buffer_resize(tr->buffer,
> -					size_tr->data[cpu]->entries, cpu);
> +			ret = ring_buffer_resize(trace_buf->buffer,
> +				 per_cpu_ptr(size_buf->data, cpu)->entries, cpu);
>  			if (ret < 0)
>  				break;
> -			tr->data[cpu]->entries = size_tr->data[cpu]->entries;
> +			per_cpu_ptr(trace_buf->data, cpu)->entries =
> +				per_cpu_ptr(size_buf->data, cpu)->entries;
>  		}
>  	} else {
> -		ret = ring_buffer_resize(tr->buffer,
> -					size_tr->data[cpu_id]->entries, cpu_id);
> +		ret = ring_buffer_resize(trace_buf->buffer,
> +				 per_cpu_ptr(size_buf->data, cpu_id)->entries, cpu_id);
>  		if (ret == 0)
> -			tr->data[cpu_id]->entries =
> -				size_tr->data[cpu_id]->entries;
> +			per_cpu_ptr(trace_buf->data, cpu_id)->entries =
> +				per_cpu_ptr(size_buf->data, cpu_id)->entries;
>  	}
>  
>  	return ret;
>  }
> +#endif /* CONFIG_TRACER_MAX_TRACE */
>  
> -static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
> +static int __tracing_resize_ring_buffer(struct trace_array *tr,
> +					unsigned long size, int cpu)
>  {
>  	int ret;
>  
> @@ -3137,23 +3512,25 @@ static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
>  	 * we use the size that was given, and we can forget about
>  	 * expanding it later.
>  	 */
> -	ring_buffer_expanded = 1;
> +	ring_buffer_expanded = true;
>  
>  	/* May be called before buffers are initialized */
> -	if (!global_trace.buffer)
> +	if (!tr->trace_buffer.buffer)
>  		return 0;
>  
> -	ret = ring_buffer_resize(global_trace.buffer, size, cpu);
> +	ret = ring_buffer_resize(tr->trace_buffer.buffer, size, cpu);
>  	if (ret < 0)
>  		return ret;
>  
> -	if (!current_trace->use_max_tr)
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	if (!(tr->flags & TRACE_ARRAY_FL_GLOBAL) ||
> +	    !tr->current_trace->use_max_tr)
>  		goto out;
>  
> -	ret = ring_buffer_resize(max_tr.buffer, size, cpu);
> +	ret = ring_buffer_resize(tr->max_buffer.buffer, size, cpu);
>  	if (ret < 0) {
> -		int r = resize_buffer_duplicate_size(&global_trace,
> -						     &global_trace, cpu);
> +		int r = resize_buffer_duplicate_size(&tr->trace_buffer,
> +						     &tr->trace_buffer, cpu);
>  		if (r < 0) {
>  			/*
>  			 * AARGH! We are left with different
> @@ -3176,20 +3553,23 @@ static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
>  	}
>  
>  	if (cpu == RING_BUFFER_ALL_CPUS)
> -		set_buffer_entries(&max_tr, size);
> +		set_buffer_entries(&tr->max_buffer, size);
>  	else
> -		max_tr.data[cpu]->entries = size;
> +		per_cpu_ptr(tr->max_buffer.data, cpu)->entries = size;
>  
>   out:
> +#endif /* CONFIG_TRACER_MAX_TRACE */
> +
>  	if (cpu == RING_BUFFER_ALL_CPUS)
> -		set_buffer_entries(&global_trace, size);
> +		set_buffer_entries(&tr->trace_buffer, size);
>  	else
> -		global_trace.data[cpu]->entries = size;
> +		per_cpu_ptr(tr->trace_buffer.data, cpu)->entries = size;
>  
>  	return ret;
>  }
>  
> -static ssize_t tracing_resize_ring_buffer(unsigned long size, int cpu_id)
> +static ssize_t tracing_resize_ring_buffer(struct trace_array *tr,
> +					  unsigned long size, int cpu_id)
>  {
>  	int ret = size;
>  
> @@ -3203,7 +3583,7 @@ static ssize_t tracing_resize_ring_buffer(unsigned long size, int cpu_id)
>  		}
>  	}
>  
> -	ret = __tracing_resize_ring_buffer(size, cpu_id);
> +	ret = __tracing_resize_ring_buffer(tr, size, cpu_id);
>  	if (ret < 0)
>  		ret = -ENOMEM;
>  
> @@ -3230,7 +3610,7 @@ int tracing_update_buffers(void)
>  
>  	mutex_lock(&trace_types_lock);
>  	if (!ring_buffer_expanded)
> -		ret = __tracing_resize_ring_buffer(trace_buf_size,
> +		ret = __tracing_resize_ring_buffer(&global_trace, trace_buf_size,
>  						RING_BUFFER_ALL_CPUS);
>  	mutex_unlock(&trace_types_lock);
>  
> @@ -3240,7 +3620,7 @@ int tracing_update_buffers(void)
>  struct trace_option_dentry;
>  
>  static struct trace_option_dentry *
> -create_trace_option_files(struct tracer *tracer);
> +create_trace_option_files(struct trace_array *tr, struct tracer *tracer);
>  
>  static void
>  destroy_trace_option_files(struct trace_option_dentry *topts);
> @@ -3250,13 +3630,15 @@ static int tracing_set_tracer(const char *buf)
>  	static struct trace_option_dentry *topts;
>  	struct trace_array *tr = &global_trace;
>  	struct tracer *t;
> +#ifdef CONFIG_TRACER_MAX_TRACE
>  	bool had_max_tr;
> +#endif
>  	int ret = 0;
>  
>  	mutex_lock(&trace_types_lock);
>  
>  	if (!ring_buffer_expanded) {
> -		ret = __tracing_resize_ring_buffer(trace_buf_size,
> +		ret = __tracing_resize_ring_buffer(tr, trace_buf_size,
>  						RING_BUFFER_ALL_CPUS);
>  		if (ret < 0)
>  			goto out;
> @@ -3271,18 +3653,21 @@ static int tracing_set_tracer(const char *buf)
>  		ret = -EINVAL;
>  		goto out;
>  	}
> -	if (t == current_trace)
> +	if (t == tr->current_trace)
>  		goto out;
>  
>  	trace_branch_disable();
>  
> -	current_trace->enabled = false;
> +	tr->current_trace->enabled = false;
>  
> -	if (current_trace->reset)
> -		current_trace->reset(tr);
> +	if (tr->current_trace->reset)
> +		tr->current_trace->reset(tr);
>  
> -	had_max_tr = current_trace->allocated_snapshot;
> -	current_trace = &nop_trace;
> +	/* Current trace needs to be nop_trace before synchronize_sched */
> +	tr->current_trace = &nop_trace;
> +
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	had_max_tr = tr->allocated_snapshot;
>  
>  	if (had_max_tr && !t->use_max_tr) {
>  		/*
> @@ -3293,27 +3678,20 @@ static int tracing_set_tracer(const char *buf)
>  		 * so a synchronized_sched() is sufficient.
>  		 */
>  		synchronize_sched();
> -		/*
> -		 * We don't free the ring buffer. instead, resize it because
> -		 * The max_tr ring buffer has some state (e.g. ring->clock) and
> -		 * we want preserve it.
> -		 */
> -		ring_buffer_resize(max_tr.buffer, 1, RING_BUFFER_ALL_CPUS);
> -		set_buffer_entries(&max_tr, 1);
> -		tracing_reset_online_cpus(&max_tr);
> -		current_trace->allocated_snapshot = false;
> +		free_snapshot(tr);
>  	}
> +#endif
>  	destroy_trace_option_files(topts);
>  
> -	topts = create_trace_option_files(t);
> +	topts = create_trace_option_files(tr, t);
> +
> +#ifdef CONFIG_TRACER_MAX_TRACE
>  	if (t->use_max_tr && !had_max_tr) {
> -		/* we need to make per cpu buffer sizes equivalent */
> -		ret = resize_buffer_duplicate_size(&max_tr, &global_trace,
> -						   RING_BUFFER_ALL_CPUS);
> +		ret = alloc_snapshot(tr);
>  		if (ret < 0)
>  			goto out;
> -		t->allocated_snapshot = true;
>  	}
> +#endif
>  
>  	if (t->init) {
>  		ret = tracer_init(t, tr);
> @@ -3321,8 +3699,8 @@ static int tracing_set_tracer(const char *buf)
>  			goto out;
>  	}
>  
> -	current_trace = t;
> -	current_trace->enabled = true;
> +	tr->current_trace = t;
> +	tr->current_trace->enabled = true;
>  	trace_branch_enable(tr);
>   out:
>  	mutex_unlock(&trace_types_lock);
> @@ -3396,7 +3774,8 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
>  
>  static int tracing_open_pipe(struct inode *inode, struct file *filp)
>  {
> -	long cpu_file = (long) inode->i_private;
> +	struct trace_cpu *tc = inode->i_private;
> +	struct trace_array *tr = tc->tr;
>  	struct trace_iterator *iter;
>  	int ret = 0;
>  
> @@ -3421,7 +3800,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
>  		ret = -ENOMEM;
>  		goto fail;
>  	}
> -	*iter->trace = *current_trace;
> +	*iter->trace = *tr->current_trace;
>  
>  	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL)) {
>  		ret = -ENOMEM;
> @@ -3438,8 +3817,9 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
>  	if (trace_clocks[trace_clock_id].in_ns)
>  		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
>  
> -	iter->cpu_file = cpu_file;
> -	iter->tr = &global_trace;
> +	iter->cpu_file = tc->cpu;
> +	iter->tr = tc->tr;
> +	iter->trace_buffer = &tc->tr->trace_buffer;
>  	mutex_init(&iter->mutex);
>  	filp->private_data = iter;
>  
> @@ -3478,24 +3858,28 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
>  }
>  
>  static unsigned int
> -tracing_poll_pipe(struct file *filp, poll_table *poll_table)
> +trace_poll(struct trace_iterator *iter, struct file *filp, poll_table *poll_table)
>  {
> -	struct trace_iterator *iter = filp->private_data;
> +	/* Iterators are static, they should be filled or empty */
> +	if (trace_buffer_iter(iter, iter->cpu_file))
> +		return POLLIN | POLLRDNORM;
>  
> -	if (trace_flags & TRACE_ITER_BLOCK) {
> +	if (trace_flags & TRACE_ITER_BLOCK)
>  		/*
>  		 * Always select as readable when in blocking mode
>  		 */
>  		return POLLIN | POLLRDNORM;
> -	} else {
> -		if (!trace_empty(iter))
> -			return POLLIN | POLLRDNORM;
> -		poll_wait(filp, &trace_wait, poll_table);
> -		if (!trace_empty(iter))
> -			return POLLIN | POLLRDNORM;
> +	else
> +		return ring_buffer_poll_wait(iter->trace_buffer->buffer, iter->cpu_file,
> +					     filp, poll_table);
> +}
>  
> -		return 0;
> -	}
> +static unsigned int
> +tracing_poll_pipe(struct file *filp, poll_table *poll_table)
> +{
> +	struct trace_iterator *iter = filp->private_data;
> +
> +	return trace_poll(iter, filp, poll_table);
>  }
>  
>  /*
> @@ -3561,6 +3945,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
>  		  size_t cnt, loff_t *ppos)
>  {
>  	struct trace_iterator *iter = filp->private_data;
> +	struct trace_array *tr = iter->tr;
>  	ssize_t sret;
>  
>  	/* return any leftover data */
> @@ -3572,8 +3957,8 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
>  
>  	/* copy the tracer to avoid using a global lock all around */
>  	mutex_lock(&trace_types_lock);
> -	if (unlikely(iter->trace->name != current_trace->name))
> -		*iter->trace = *current_trace;
> +	if (unlikely(iter->trace->name != tr->current_trace->name))
> +		*iter->trace = *tr->current_trace;
>  	mutex_unlock(&trace_types_lock);
>  
>  	/*
> @@ -3729,6 +4114,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
>  		.ops		= &tracing_pipe_buf_ops,
>  		.spd_release	= tracing_spd_release_pipe,
>  	};
> +	struct trace_array *tr = iter->tr;
>  	ssize_t ret;
>  	size_t rem;
>  	unsigned int i;
> @@ -3738,8 +4124,8 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
>  
>  	/* copy the tracer to avoid using a global lock all around */
>  	mutex_lock(&trace_types_lock);
> -	if (unlikely(iter->trace->name != current_trace->name))
> -		*iter->trace = *current_trace;
> +	if (unlikely(iter->trace->name != tr->current_trace->name))
> +		*iter->trace = *tr->current_trace;
>  	mutex_unlock(&trace_types_lock);
>  
>  	mutex_lock(&iter->mutex);
> @@ -3801,43 +4187,19 @@ out_err:
>  	goto out;
>  }
>  
> -struct ftrace_entries_info {
> -	struct trace_array	*tr;
> -	int			cpu;
> -};
> -
> -static int tracing_entries_open(struct inode *inode, struct file *filp)
> -{
> -	struct ftrace_entries_info *info;
> -
> -	if (tracing_disabled)
> -		return -ENODEV;
> -
> -	info = kzalloc(sizeof(*info), GFP_KERNEL);
> -	if (!info)
> -		return -ENOMEM;
> -
> -	info->tr = &global_trace;
> -	info->cpu = (unsigned long)inode->i_private;
> -
> -	filp->private_data = info;
> -
> -	return 0;
> -}
> -
>  static ssize_t
>  tracing_entries_read(struct file *filp, char __user *ubuf,
>  		     size_t cnt, loff_t *ppos)
>  {
> -	struct ftrace_entries_info *info = filp->private_data;
> -	struct trace_array *tr = info->tr;
> +	struct trace_cpu *tc = filp->private_data;
> +	struct trace_array *tr = tc->tr;
>  	char buf[64];
>  	int r = 0;
>  	ssize_t ret;
>  
>  	mutex_lock(&trace_types_lock);
>  
> -	if (info->cpu == RING_BUFFER_ALL_CPUS) {
> +	if (tc->cpu == RING_BUFFER_ALL_CPUS) {
>  		int cpu, buf_size_same;
>  		unsigned long size;
>  
> @@ -3847,8 +4209,8 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
>  		for_each_tracing_cpu(cpu) {
>  			/* fill in the size from first enabled cpu */
>  			if (size == 0)
> -				size = tr->data[cpu]->entries;
> -			if (size != tr->data[cpu]->entries) {
> +				size = per_cpu_ptr(tr->trace_buffer.data, cpu)->entries;
> +			if (size != per_cpu_ptr(tr->trace_buffer.data, cpu)->entries) {
>  				buf_size_same = 0;
>  				break;
>  			}
> @@ -3864,7 +4226,7 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
>  		} else
>  			r = sprintf(buf, "X\n");
>  	} else
> -		r = sprintf(buf, "%lu\n", tr->data[info->cpu]->entries >> 10);
> +		r = sprintf(buf, "%lu\n", per_cpu_ptr(tr->trace_buffer.data, tc->cpu)->entries >> 10);
>  
>  	mutex_unlock(&trace_types_lock);
>  
> @@ -3876,7 +4238,7 @@ static ssize_t
>  tracing_entries_write(struct file *filp, const char __user *ubuf,
>  		      size_t cnt, loff_t *ppos)
>  {
> -	struct ftrace_entries_info *info = filp->private_data;
> +	struct trace_cpu *tc = filp->private_data;
>  	unsigned long val;
>  	int ret;
>  
> @@ -3891,7 +4253,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>  	/* value is in KB */
>  	val <<= 10;
>  
> -	ret = tracing_resize_ring_buffer(val, info->cpu);
> +	ret = tracing_resize_ring_buffer(tc->tr, val, tc->cpu);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -3900,16 +4262,6 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>  	return cnt;
>  }
>  
> -static int
> -tracing_entries_release(struct inode *inode, struct file *filp)
> -{
> -	struct ftrace_entries_info *info = filp->private_data;
> -
> -	kfree(info);
> -
> -	return 0;
> -}
> -
>  static ssize_t
>  tracing_total_entries_read(struct file *filp, char __user *ubuf,
>  				size_t cnt, loff_t *ppos)
> @@ -3921,7 +4273,7 @@ tracing_total_entries_read(struct file *filp, char __user *ubuf,
>  
>  	mutex_lock(&trace_types_lock);
>  	for_each_tracing_cpu(cpu) {
> -		size += tr->data[cpu]->entries >> 10;
> +		size += per_cpu_ptr(tr->trace_buffer.data, cpu)->entries >> 10;
>  		if (!ring_buffer_expanded)
>  			expanded_size += trace_buf_size >> 10;
>  	}
> @@ -3951,11 +4303,13 @@ tracing_free_buffer_write(struct file *filp, const char __user *ubuf,
>  static int
>  tracing_free_buffer_release(struct inode *inode, struct file *filp)
>  {
> +	struct trace_array *tr = inode->i_private;
> +
>  	/* disable tracing ? */
>  	if (trace_flags & TRACE_ITER_STOP_ON_FREE)
>  		tracing_off();
>  	/* resize the ring buffer to 0 */
> -	tracing_resize_ring_buffer(0, RING_BUFFER_ALL_CPUS);
> +	tracing_resize_ring_buffer(tr, 0, RING_BUFFER_ALL_CPUS);
>  
>  	return 0;
>  }
> @@ -4024,7 +4378,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
>  
>  	local_save_flags(irq_flags);
>  	size = sizeof(*entry) + cnt + 2; /* possible \n added */
> -	buffer = global_trace.buffer;
> +	buffer = global_trace.trace_buffer.buffer;
>  	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
>  					  irq_flags, preempt_count());
>  	if (!event) {
> @@ -4066,13 +4420,14 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
>  
>  static int tracing_clock_show(struct seq_file *m, void *v)
>  {
> +	struct trace_array *tr = m->private;
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++)
>  		seq_printf(m,
>  			"%s%s%s%s", i ? " " : "",
> -			i == trace_clock_id ? "[" : "", trace_clocks[i].name,
> -			i == trace_clock_id ? "]" : "");
> +			i == tr->clock_id ? "[" : "", trace_clocks[i].name,
> +			i == tr->clock_id ? "]" : "");
>  	seq_putc(m, '\n');
>  
>  	return 0;
> @@ -4081,6 +4436,8 @@ static int tracing_clock_show(struct seq_file *m, void *v)
>  static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
>  				   size_t cnt, loff_t *fpos)
>  {
> +	struct seq_file *m = filp->private_data;
> +	struct trace_array *tr = m->private;
>  	char buf[64];
>  	const char *clockstr;
>  	int i;
> @@ -4102,20 +4459,23 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
>  	if (i == ARRAY_SIZE(trace_clocks))
>  		return -EINVAL;
>  
> -	trace_clock_id = i;
> -
>  	mutex_lock(&trace_types_lock);
>  
> -	ring_buffer_set_clock(global_trace.buffer, trace_clocks[i].func);
> -	if (max_tr.buffer)
> -		ring_buffer_set_clock(max_tr.buffer, trace_clocks[i].func);
> +	tr->clock_id = i;
> +
> +	ring_buffer_set_clock(tr->trace_buffer.buffer, trace_clocks[i].func);
>  
>  	/*
>  	 * New clock may not be consistent with the previous clock.
>  	 * Reset the buffer so that it doesn't have incomparable timestamps.
>  	 */
> -	tracing_reset_online_cpus(&global_trace);
> -	tracing_reset_online_cpus(&max_tr);
> +	tracing_reset_online_cpus(&global_trace.trace_buffer);
> +
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	if (tr->flags & TRACE_ARRAY_FL_GLOBAL && tr->max_buffer.buffer)
> +		ring_buffer_set_clock(tr->max_buffer.buffer, trace_clocks[i].func);
> +	tracing_reset_online_cpus(&global_trace.max_buffer);
> +#endif
>  
>  	mutex_unlock(&trace_types_lock);
>  
> @@ -4128,20 +4488,45 @@ static int tracing_clock_open(struct inode *inode, struct file *file)
>  {
>  	if (tracing_disabled)
>  		return -ENODEV;
> -	return single_open(file, tracing_clock_show, NULL);
> +
> +	return single_open(file, tracing_clock_show, inode->i_private);
>  }
>  
> +struct ftrace_buffer_info {
> +	struct trace_iterator	iter;
> +	void			*spare;
> +	unsigned int		read;
> +};
> +
>  #ifdef CONFIG_TRACER_SNAPSHOT
>  static int tracing_snapshot_open(struct inode *inode, struct file *file)
>  {
> +	struct trace_cpu *tc = inode->i_private;
>  	struct trace_iterator *iter;
> +	struct seq_file *m;
>  	int ret = 0;
>  
>  	if (file->f_mode & FMODE_READ) {
>  		iter = __tracing_open(inode, file, true);
>  		if (IS_ERR(iter))
>  			ret = PTR_ERR(iter);
> +	} else {
> +		/* Writes still need the seq_file to hold the private data */
> +		m = kzalloc(sizeof(*m), GFP_KERNEL);
> +		if (!m)
> +			return -ENOMEM;
> +		iter = kzalloc(sizeof(*iter), GFP_KERNEL);
> +		if (!iter) {
> +			kfree(m);
> +			return -ENOMEM;
> +		}
> +		iter->tr = tc->tr;
> +		iter->trace_buffer = &tc->tr->max_buffer;
> +		iter->cpu_file = tc->cpu;
> +		m->private = iter;
> +		file->private_data = m;
>  	}
> +
>  	return ret;
>  }
>  
> @@ -4149,6 +4534,9 @@ static ssize_t
>  tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  		       loff_t *ppos)
>  {
> +	struct seq_file *m = filp->private_data;
> +	struct trace_iterator *iter = m->private;
> +	struct trace_array *tr = iter->tr;
>  	unsigned long val;
>  	int ret;
>  
> @@ -4162,40 +4550,48 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  
>  	mutex_lock(&trace_types_lock);
>  
> -	if (current_trace->use_max_tr) {
> +	if (tr->current_trace->use_max_tr) {
>  		ret = -EBUSY;
>  		goto out;
>  	}
>  
>  	switch (val) {
>  	case 0:
> -		if (current_trace->allocated_snapshot) {
> -			/* free spare buffer */
> -			ring_buffer_resize(max_tr.buffer, 1,
> -					   RING_BUFFER_ALL_CPUS);
> -			set_buffer_entries(&max_tr, 1);
> -			tracing_reset_online_cpus(&max_tr);
> -			current_trace->allocated_snapshot = false;
> +		if (iter->cpu_file != RING_BUFFER_ALL_CPUS) {
> +			ret = -EINVAL;
> +			break;
>  		}
> +		if (tr->allocated_snapshot)
> +			free_snapshot(tr);
>  		break;
>  	case 1:
> -		if (!current_trace->allocated_snapshot) {
> -			/* allocate spare buffer */
> -			ret = resize_buffer_duplicate_size(&max_tr,
> -					&global_trace, RING_BUFFER_ALL_CPUS);
> +/* Only allow per-cpu swap if the ring buffer supports it */
> +#ifndef CONFIG_RING_BUFFER_ALLOW_SWAP
> +		if (iter->cpu_file != RING_BUFFER_ALL_CPUS) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +#endif
> +		if (!tr->allocated_snapshot) {
> +			ret = alloc_snapshot(tr);
>  			if (ret < 0)
>  				break;
> -			current_trace->allocated_snapshot = true;
>  		}
> -
>  		local_irq_disable();
>  		/* Now, we're going to swap */
> -		update_max_tr(&global_trace, current, smp_processor_id());
> +		if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
> +			update_max_tr(tr, current, smp_processor_id());
> +		else
> +			update_max_tr_single(tr, current, iter->cpu_file);
>  		local_irq_enable();
>  		break;
>  	default:
> -		if (current_trace->allocated_snapshot)
> -			tracing_reset_online_cpus(&max_tr);
> +		if (tr->allocated_snapshot) {
> +			if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
> +				tracing_reset_online_cpus(&tr->max_buffer);
> +			else
> +				tracing_reset(&tr->max_buffer, iter->cpu_file);
> +		}
>  		break;
>  	}
>  
> @@ -4207,6 +4603,51 @@ out:
>  	mutex_unlock(&trace_types_lock);
>  	return ret;
>  }
> +
> +static int tracing_snapshot_release(struct inode *inode, struct file *file)
> +{
> +	struct seq_file *m = file->private_data;
> +
> +	if (file->f_mode & FMODE_READ)
> +		return tracing_release(inode, file);
> +
> +	/* If write only, the seq_file is just a stub */
> +	if (m)
> +		kfree(m->private);
> +	kfree(m);
> +
> +	return 0;
> +}
> +
> +static int tracing_buffers_open(struct inode *inode, struct file *filp);
> +static ssize_t tracing_buffers_read(struct file *filp, char __user *ubuf,
> +				    size_t count, loff_t *ppos);
> +static int tracing_buffers_release(struct inode *inode, struct file *file);
> +static ssize_t tracing_buffers_splice_read(struct file *file, loff_t *ppos,
> +		   struct pipe_inode_info *pipe, size_t len, unsigned int flags);
> +
> +static int snapshot_raw_open(struct inode *inode, struct file *filp)
> +{
> +	struct ftrace_buffer_info *info;
> +	int ret;
> +
> +	ret = tracing_buffers_open(inode, filp);
> +	if (ret < 0)
> +		return ret;
> +
> +	info = filp->private_data;
> +
> +	if (info->iter.trace->use_max_tr) {
> +		tracing_buffers_release(inode, filp);
> +		return -EBUSY;
> +	}
> +
> +	info->iter.snapshot = true;
> +	info->iter.trace_buffer = &info->iter.tr->max_buffer;
> +
> +	return ret;
> +}
> +
>  #endif /* CONFIG_TRACER_SNAPSHOT */
>  
> 
> @@ -4234,10 +4675,9 @@ static const struct file_operations tracing_pipe_fops = {
>  };
>  
>  static const struct file_operations tracing_entries_fops = {
> -	.open		= tracing_entries_open,
> +	.open		= tracing_open_generic,
>  	.read		= tracing_entries_read,
>  	.write		= tracing_entries_write,
> -	.release	= tracing_entries_release,
>  	.llseek		= generic_file_llseek,
>  };
>  
> @@ -4272,20 +4712,23 @@ static const struct file_operations snapshot_fops = {
>  	.read		= seq_read,
>  	.write		= tracing_snapshot_write,
>  	.llseek		= tracing_seek,
> -	.release	= tracing_release,
> +	.release	= tracing_snapshot_release,
>  };
> -#endif /* CONFIG_TRACER_SNAPSHOT */
>  
> -struct ftrace_buffer_info {
> -	struct trace_array	*tr;
> -	void			*spare;
> -	int			cpu;
> -	unsigned int		read;
> +static const struct file_operations snapshot_raw_fops = {
> +	.open		= snapshot_raw_open,
> +	.read		= tracing_buffers_read,
> +	.release	= tracing_buffers_release,
> +	.splice_read	= tracing_buffers_splice_read,
> +	.llseek		= no_llseek,
>  };
>  
> +#endif /* CONFIG_TRACER_SNAPSHOT */
> +
>  static int tracing_buffers_open(struct inode *inode, struct file *filp)
>  {
> -	int cpu = (int)(long)inode->i_private;
> +	struct trace_cpu *tc = inode->i_private;
> +	struct trace_array *tr = tc->tr;
>  	struct ftrace_buffer_info *info;
>  
>  	if (tracing_disabled)
> @@ -4295,72 +4738,131 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
>  	if (!info)
>  		return -ENOMEM;
>  
> -	info->tr	= &global_trace;
> -	info->cpu	= cpu;
> -	info->spare	= NULL;
> +	mutex_lock(&trace_types_lock);
> +
> +	tr->ref++;
> +
> +	info->iter.tr		= tr;
> +	info->iter.cpu_file	= tc->cpu;
> +	info->iter.trace	= tr->current_trace;
> +	info->iter.trace_buffer = &tr->trace_buffer;
> +	info->spare		= NULL;
>  	/* Force reading ring buffer for first read */
> -	info->read	= (unsigned int)-1;
> +	info->read		= (unsigned int)-1;
>  
>  	filp->private_data = info;
>  
> +	mutex_unlock(&trace_types_lock);
> +
>  	return nonseekable_open(inode, filp);
>  }
>  
> +static unsigned int
> +tracing_buffers_poll(struct file *filp, poll_table *poll_table)
> +{
> +	struct ftrace_buffer_info *info = filp->private_data;
> +	struct trace_iterator *iter = &info->iter;
> +
> +	return trace_poll(iter, filp, poll_table);
> +}
> +
>  static ssize_t
>  tracing_buffers_read(struct file *filp, char __user *ubuf,
>  		     size_t count, loff_t *ppos)
>  {
>  	struct ftrace_buffer_info *info = filp->private_data;
> +	struct trace_iterator *iter = &info->iter;
>  	ssize_t ret;
> -	size_t size;
> +	ssize_t size;
>  
>  	if (!count)
>  		return 0;
>  
> +	mutex_lock(&trace_types_lock);
> +
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	if (iter->snapshot && iter->tr->current_trace->use_max_tr) {
> +		size = -EBUSY;
> +		goto out_unlock;
> +	}
> +#endif
> +
>  	if (!info->spare)
> -		info->spare = ring_buffer_alloc_read_page(info->tr->buffer, info->cpu);
> +		info->spare = ring_buffer_alloc_read_page(iter->trace_buffer->buffer,
> +							  iter->cpu_file);
> +	size = -ENOMEM;
>  	if (!info->spare)
> -		return -ENOMEM;
> +		goto out_unlock;
>  
>  	/* Do we have previous read data to read? */
>  	if (info->read < PAGE_SIZE)
>  		goto read;
>  
> -	trace_access_lock(info->cpu);
> -	ret = ring_buffer_read_page(info->tr->buffer,
> + again:
> +	trace_access_lock(iter->cpu_file);
> +	ret = ring_buffer_read_page(iter->trace_buffer->buffer,
>  				    &info->spare,
>  				    count,
> -				    info->cpu, 0);
> -	trace_access_unlock(info->cpu);
> -	if (ret < 0)
> -		return 0;
> +				    iter->cpu_file, 0);
> +	trace_access_unlock(iter->cpu_file);
>  
> -	info->read = 0;
> +	if (ret < 0) {
> +		if (trace_empty(iter)) {
> +			if ((filp->f_flags & O_NONBLOCK)) {
> +				size = -EAGAIN;
> +				goto out_unlock;
> +			}
> +			mutex_unlock(&trace_types_lock);
> +			iter->trace->wait_pipe(iter);
> +			mutex_lock(&trace_types_lock);
> +			if (signal_pending(current)) {
> +				size = -EINTR;
> +				goto out_unlock;
> +			}
> +			goto again;
> +		}
> +		size = 0;
> +		goto out_unlock;
> +	}
>  
> -read:
> +	info->read = 0;
> + read:
>  	size = PAGE_SIZE - info->read;
>  	if (size > count)
>  		size = count;
>  
>  	ret = copy_to_user(ubuf, info->spare + info->read, size);
> -	if (ret == size)
> -		return -EFAULT;
> +	if (ret == size) {
> +		size = -EFAULT;
> +		goto out_unlock;
> +	}
>  	size -= ret;
>  
>  	*ppos += size;
>  	info->read += size;
>  
> + out_unlock:
> +	mutex_unlock(&trace_types_lock);
> +
>  	return size;
>  }
>  
>  static int tracing_buffers_release(struct inode *inode, struct file *file)
>  {
>  	struct ftrace_buffer_info *info = file->private_data;
> +	struct trace_iterator *iter = &info->iter;
> +
> +	mutex_lock(&trace_types_lock);
> +
> +	WARN_ON(!iter->tr->ref);
> +	iter->tr->ref--;
>  
>  	if (info->spare)
> -		ring_buffer_free_read_page(info->tr->buffer, info->spare);
> +		ring_buffer_free_read_page(iter->trace_buffer->buffer, info->spare);
>  	kfree(info);
>  
> +	mutex_unlock(&trace_types_lock);
> +
>  	return 0;
>  }
>  
> @@ -4425,6 +4927,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
>  			    unsigned int flags)
>  {
>  	struct ftrace_buffer_info *info = file->private_data;
> +	struct trace_iterator *iter = &info->iter;
>  	struct partial_page partial_def[PIPE_DEF_BUFFERS];
>  	struct page *pages_def[PIPE_DEF_BUFFERS];
>  	struct splice_pipe_desc spd = {
> @@ -4437,10 +4940,21 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
>  	};
>  	struct buffer_ref *ref;
>  	int entries, size, i;
> -	size_t ret;
> +	ssize_t ret;
>  
> -	if (splice_grow_spd(pipe, &spd))
> -		return -ENOMEM;
> +	mutex_lock(&trace_types_lock);
> +
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	if (iter->snapshot && iter->tr->current_trace->use_max_tr) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +#endif
> +
> +	if (splice_grow_spd(pipe, &spd)) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
>  
>  	if (*ppos & (PAGE_SIZE - 1)) {
>  		ret = -EINVAL;
> @@ -4455,8 +4969,9 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
>  		len &= PAGE_MASK;
>  	}
>  
> -	trace_access_lock(info->cpu);
> -	entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
> + again:
> +	trace_access_lock(iter->cpu_file);
> +	entries = ring_buffer_entries_cpu(iter->trace_buffer->buffer, iter->cpu_file);
>  
>  	for (i = 0; i < pipe->buffers && len && entries; i++, len -= PAGE_SIZE) {
>  		struct page *page;
> @@ -4467,15 +4982,15 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
>  			break;
>  
>  		ref->ref = 1;
> -		ref->buffer = info->tr->buffer;
> -		ref->page = ring_buffer_alloc_read_page(ref->buffer, info->cpu);
> +		ref->buffer = iter->trace_buffer->buffer;
> +		ref->page = ring_buffer_alloc_read_page(ref->buffer, iter->cpu_file);
>  		if (!ref->page) {
>  			kfree(ref);
>  			break;
>  		}
>  
>  		r = ring_buffer_read_page(ref->buffer, &ref->page,
> -					  len, info->cpu, 1);
> +					  len, iter->cpu_file, 1);
>  		if (r < 0) {
>  			ring_buffer_free_read_page(ref->buffer, ref->page);
>  			kfree(ref);
> @@ -4499,31 +5014,40 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
>  		spd.nr_pages++;
>  		*ppos += PAGE_SIZE;
>  
> -		entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
> +		entries = ring_buffer_entries_cpu(iter->trace_buffer->buffer, iter->cpu_file);
>  	}
>  
> -	trace_access_unlock(info->cpu);
> +	trace_access_unlock(iter->cpu_file);
>  	spd.nr_pages = i;
>  
>  	/* did we read anything? */
>  	if (!spd.nr_pages) {
> -		if (flags & SPLICE_F_NONBLOCK)
> +		if ((file->f_flags & O_NONBLOCK) || (flags & SPLICE_F_NONBLOCK)) {
>  			ret = -EAGAIN;
> -		else
> -			ret = 0;
> -		/* TODO: block */
> -		goto out;
> +			goto out;
> +		}
> +		mutex_unlock(&trace_types_lock);
> +		iter->trace->wait_pipe(iter);
> +		mutex_lock(&trace_types_lock);
> +		if (signal_pending(current)) {
> +			ret = -EINTR;
> +			goto out;
> +		}
> +		goto again;
>  	}
>  
>  	ret = splice_to_pipe(pipe, &spd);
>  	splice_shrink_spd(&spd);
>  out:
> +	mutex_unlock(&trace_types_lock);
> +
>  	return ret;
>  }
>  
>  static const struct file_operations tracing_buffers_fops = {
>  	.open		= tracing_buffers_open,
>  	.read		= tracing_buffers_read,
> +	.poll		= tracing_buffers_poll,
>  	.release	= tracing_buffers_release,
>  	.splice_read	= tracing_buffers_splice_read,
>  	.llseek		= no_llseek,
> @@ -4533,12 +5057,14 @@ static ssize_t
>  tracing_stats_read(struct file *filp, char __user *ubuf,
>  		   size_t count, loff_t *ppos)
>  {
> -	unsigned long cpu = (unsigned long)filp->private_data;
> -	struct trace_array *tr = &global_trace;
> +	struct trace_cpu *tc = filp->private_data;
> +	struct trace_array *tr = tc->tr;
> +	struct trace_buffer *trace_buf = &tr->trace_buffer;
>  	struct trace_seq *s;
>  	unsigned long cnt;
>  	unsigned long long t;
>  	unsigned long usec_rem;
> +	int cpu = tc->cpu;
>  
>  	s = kmalloc(sizeof(*s), GFP_KERNEL);
>  	if (!s)
> @@ -4546,41 +5072,41 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
>  
>  	trace_seq_init(s);
>  
> -	cnt = ring_buffer_entries_cpu(tr->buffer, cpu);
> +	cnt = ring_buffer_entries_cpu(trace_buf->buffer, cpu);
>  	trace_seq_printf(s, "entries: %ld\n", cnt);
>  
> -	cnt = ring_buffer_overrun_cpu(tr->buffer, cpu);
> +	cnt = ring_buffer_overrun_cpu(trace_buf->buffer, cpu);
>  	trace_seq_printf(s, "overrun: %ld\n", cnt);
>  
> -	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
> +	cnt = ring_buffer_commit_overrun_cpu(trace_buf->buffer, cpu);
>  	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
>  
> -	cnt = ring_buffer_bytes_cpu(tr->buffer, cpu);
> +	cnt = ring_buffer_bytes_cpu(trace_buf->buffer, cpu);
>  	trace_seq_printf(s, "bytes: %ld\n", cnt);
>  
>  	if (trace_clocks[trace_clock_id].in_ns) {
>  		/* local or global for trace_clock */
> -		t = ns2usecs(ring_buffer_oldest_event_ts(tr->buffer, cpu));
> +		t = ns2usecs(ring_buffer_oldest_event_ts(trace_buf->buffer, cpu));
>  		usec_rem = do_div(t, USEC_PER_SEC);
>  		trace_seq_printf(s, "oldest event ts: %5llu.%06lu\n",
>  								t, usec_rem);
>  
> -		t = ns2usecs(ring_buffer_time_stamp(tr->buffer, cpu));
> +		t = ns2usecs(ring_buffer_time_stamp(trace_buf->buffer, cpu));
>  		usec_rem = do_div(t, USEC_PER_SEC);
>  		trace_seq_printf(s, "now ts: %5llu.%06lu\n", t, usec_rem);
>  	} else {
>  		/* counter or tsc mode for trace_clock */
>  		trace_seq_printf(s, "oldest event ts: %llu\n",
> -				ring_buffer_oldest_event_ts(tr->buffer, cpu));
> +				ring_buffer_oldest_event_ts(trace_buf->buffer, cpu));
>  
>  		trace_seq_printf(s, "now ts: %llu\n",
> -				ring_buffer_time_stamp(tr->buffer, cpu));
> +				ring_buffer_time_stamp(trace_buf->buffer, cpu));
>  	}
>  
> -	cnt = ring_buffer_dropped_events_cpu(tr->buffer, cpu);
> +	cnt = ring_buffer_dropped_events_cpu(trace_buf->buffer, cpu);
>  	trace_seq_printf(s, "dropped events: %ld\n", cnt);
>  
> -	cnt = ring_buffer_read_events_cpu(tr->buffer, cpu);
> +	cnt = ring_buffer_read_events_cpu(trace_buf->buffer, cpu);
>  	trace_seq_printf(s, "read events: %ld\n", cnt);
>  
>  	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
> @@ -4632,60 +5158,161 @@ static const struct file_operations tracing_dyn_info_fops = {
>  	.read		= tracing_read_dyn_info,
>  	.llseek		= generic_file_llseek,
>  };
> -#endif
> +#endif /* CONFIG_DYNAMIC_FTRACE */
> +
> +#if defined(CONFIG_TRACER_SNAPSHOT) && defined(CONFIG_DYNAMIC_FTRACE)
> +static void
> +ftrace_snapshot(unsigned long ip, unsigned long parent_ip, void **data)
> +{
> +	tracing_snapshot();
> +}
>  
> -static struct dentry *d_tracer;
> +static void
> +ftrace_count_snapshot(unsigned long ip, unsigned long parent_ip, void **data)
> +{
> +	unsigned long *count = (long *)data;
>  
> -struct dentry *tracing_init_dentry(void)
> +	if (!*count)
> +		return;
> +
> +	if (*count != -1)
> +		(*count)--;
> +
> +	tracing_snapshot();
> +}
> +
> +static int
> +ftrace_snapshot_print(struct seq_file *m, unsigned long ip,
> +		      struct ftrace_probe_ops *ops, void *data)
> +{
> +	long count = (long)data;
> +
> +	seq_printf(m, "%ps:", (void *)ip);
> +
> +	seq_printf(m, "snapshot");
> +
> +	if (count == -1)
> +		seq_printf(m, ":unlimited\n");
> +	else
> +		seq_printf(m, ":count=%ld\n", count);
> +
> +	return 0;
> +}
> +
> +static struct ftrace_probe_ops snapshot_probe_ops = {
> +	.func			= ftrace_snapshot,
> +	.print			= ftrace_snapshot_print,
> +};
> +
> +static struct ftrace_probe_ops snapshot_count_probe_ops = {
> +	.func			= ftrace_count_snapshot,
> +	.print			= ftrace_snapshot_print,
> +};
> +
> +static int
> +ftrace_trace_snapshot_callback(struct ftrace_hash *hash,
> +			       char *glob, char *cmd, char *param, int enable)
>  {
> -	static int once;
> +	struct ftrace_probe_ops *ops;
> +	void *count = (void *)-1;
> +	char *number;
> +	int ret;
> +
> +	/* hash funcs only work with set_ftrace_filter */
> +	if (!enable)
> +		return -EINVAL;
> +
> +	ops = param ? &snapshot_count_probe_ops :  &snapshot_probe_ops;
> +
> +	if (glob[0] == '!') {
> +		unregister_ftrace_function_probe_func(glob+1, ops);
> +		return 0;
> +	}
> +
> +	if (!param)
> +		goto out_reg;
> +
> +	number = strsep(&param, ":");
> +
> +	if (!strlen(number))
> +		goto out_reg;
> +
> +	/*
> +	 * We use the callback data field (which is a pointer)
> +	 * as our counter.
> +	 */
> +	ret = kstrtoul(number, 0, (unsigned long *)&count);
> +	if (ret)
> +		return ret;
> +
> + out_reg:
> +	ret = register_ftrace_function_probe(glob, ops, count);
> +
> +	if (ret >= 0)
> +		alloc_snapshot(&global_trace);
> +
> +	return ret < 0 ? ret : 0;
> +}
> +
> +static struct ftrace_func_command ftrace_snapshot_cmd = {
> +	.name			= "snapshot",
> +	.func			= ftrace_trace_snapshot_callback,
> +};
> +
> +static int register_snapshot_cmd(void)
> +{
> +	return register_ftrace_command(&ftrace_snapshot_cmd);
> +}
> +#else
> +static inline int register_snapshot_cmd(void) { return 0; }
> +#endif /* defined(CONFIG_TRACER_SNAPSHOT) && defined(CONFIG_DYNAMIC_FTRACE) */
>  
> -	if (d_tracer)
> -		return d_tracer;
> +struct dentry *tracing_init_dentry_tr(struct trace_array *tr)
> +{
> +	if (tr->dir)
> +		return tr->dir;
>  
>  	if (!debugfs_initialized())
>  		return NULL;
>  
> -	d_tracer = debugfs_create_dir("tracing", NULL);
> +	if (tr->flags & TRACE_ARRAY_FL_GLOBAL)
> +		tr->dir = debugfs_create_dir("tracing", NULL);
>  
> -	if (!d_tracer && !once) {
> -		once = 1;
> -		pr_warning("Could not create debugfs directory 'tracing'\n");
> -		return NULL;
> -	}
> +	if (!tr->dir)
> +		pr_warn_once("Could not create debugfs directory 'tracing'\n");
>  
> -	return d_tracer;
> +	return tr->dir;
>  }
>  
> -static struct dentry *d_percpu;
> +struct dentry *tracing_init_dentry(void)
> +{
> +	return tracing_init_dentry_tr(&global_trace);
> +}
>  
> -static struct dentry *tracing_dentry_percpu(void)
> +static struct dentry *tracing_dentry_percpu(struct trace_array *tr, int cpu)
>  {
> -	static int once;
>  	struct dentry *d_tracer;
>  
> -	if (d_percpu)
> -		return d_percpu;
> -
> -	d_tracer = tracing_init_dentry();
> +	if (tr->percpu_dir)
> +		return tr->percpu_dir;
>  
> +	d_tracer = tracing_init_dentry_tr(tr);
>  	if (!d_tracer)
>  		return NULL;
>  
> -	d_percpu = debugfs_create_dir("per_cpu", d_tracer);
> +	tr->percpu_dir = debugfs_create_dir("per_cpu", d_tracer);
>  
> -	if (!d_percpu && !once) {
> -		once = 1;
> -		pr_warning("Could not create debugfs directory 'per_cpu'\n");
> -		return NULL;
> -	}
> +	WARN_ONCE(!tr->percpu_dir,
> +		  "Could not create debugfs directory 'per_cpu/%d'\n", cpu);
>  
> -	return d_percpu;
> +	return tr->percpu_dir;
>  }
>  
> -static void tracing_init_debugfs_percpu(long cpu)
> +static void
> +tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
>  {
> -	struct dentry *d_percpu = tracing_dentry_percpu();
> +	struct trace_array_cpu *data = per_cpu_ptr(tr->trace_buffer.data, cpu);
> +	struct dentry *d_percpu = tracing_dentry_percpu(tr, cpu);
>  	struct dentry *d_cpu;
>  	char cpu_dir[30]; /* 30 characters should be more than enough */
>  
> @@ -4701,20 +5328,28 @@ static void tracing_init_debugfs_percpu(long cpu)
>  
>  	/* per cpu trace_pipe */
>  	trace_create_file("trace_pipe", 0444, d_cpu,
> -			(void *) cpu, &tracing_pipe_fops);
> +			(void *)&data->trace_cpu, &tracing_pipe_fops);
>  
>  	/* per cpu trace */
>  	trace_create_file("trace", 0644, d_cpu,
> -			(void *) cpu, &tracing_fops);
> +			(void *)&data->trace_cpu, &tracing_fops);
>  
>  	trace_create_file("trace_pipe_raw", 0444, d_cpu,
> -			(void *) cpu, &tracing_buffers_fops);
> +			(void *)&data->trace_cpu, &tracing_buffers_fops);
>  
>  	trace_create_file("stats", 0444, d_cpu,
> -			(void *) cpu, &tracing_stats_fops);
> +			(void *)&data->trace_cpu, &tracing_stats_fops);
>  
>  	trace_create_file("buffer_size_kb", 0444, d_cpu,
> -			(void *) cpu, &tracing_entries_fops);
> +			(void *)&data->trace_cpu, &tracing_entries_fops);
> +
> +#ifdef CONFIG_TRACER_SNAPSHOT
> +	trace_create_file("snapshot", 0644, d_cpu,
> +			  (void *)&data->trace_cpu, &snapshot_fops);
> +
> +	trace_create_file("snapshot_raw", 0444, d_cpu,
> +			(void *)&data->trace_cpu, &snapshot_raw_fops);
> +#endif
>  }
>  
>  #ifdef CONFIG_FTRACE_SELFTEST
> @@ -4725,6 +5360,7 @@ static void tracing_init_debugfs_percpu(long cpu)
>  struct trace_option_dentry {
>  	struct tracer_opt		*opt;
>  	struct tracer_flags		*flags;
> +	struct trace_array		*tr;
>  	struct dentry			*entry;
>  };
>  
> @@ -4760,7 +5396,7 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  
>  	if (!!(topt->flags->val & topt->opt->bit) != val) {
>  		mutex_lock(&trace_types_lock);
> -		ret = __set_tracer_option(current_trace, topt->flags,
> +		ret = __set_tracer_option(topt->tr->current_trace, topt->flags,
>  					  topt->opt, !val);
>  		mutex_unlock(&trace_types_lock);
>  		if (ret)
> @@ -4799,6 +5435,7 @@ static ssize_t
>  trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  			 loff_t *ppos)
>  {
> +	struct trace_array *tr = &global_trace;
>  	long index = (long)filp->private_data;
>  	unsigned long val;
>  	int ret;
> @@ -4811,7 +5448,7 @@ trace_options_core_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  		return -EINVAL;
>  
>  	mutex_lock(&trace_types_lock);
> -	ret = set_tracer_flag(1 << index, val);
> +	ret = set_tracer_flag(tr, 1 << index, val);
>  	mutex_unlock(&trace_types_lock);
>  
>  	if (ret < 0)
> @@ -4845,40 +5482,41 @@ struct dentry *trace_create_file(const char *name,
>  }
>  
> 
> -static struct dentry *trace_options_init_dentry(void)
> +static struct dentry *trace_options_init_dentry(struct trace_array *tr)
>  {
>  	struct dentry *d_tracer;
> -	static struct dentry *t_options;
>  
> -	if (t_options)
> -		return t_options;
> +	if (tr->options)
> +		return tr->options;
>  
> -	d_tracer = tracing_init_dentry();
> +	d_tracer = tracing_init_dentry_tr(tr);
>  	if (!d_tracer)
>  		return NULL;
>  
> -	t_options = debugfs_create_dir("options", d_tracer);
> -	if (!t_options) {
> +	tr->options = debugfs_create_dir("options", d_tracer);
> +	if (!tr->options) {
>  		pr_warning("Could not create debugfs directory 'options'\n");
>  		return NULL;
>  	}
>  
> -	return t_options;
> +	return tr->options;
>  }
>  
>  static void
> -create_trace_option_file(struct trace_option_dentry *topt,
> +create_trace_option_file(struct trace_array *tr,
> +			 struct trace_option_dentry *topt,
>  			 struct tracer_flags *flags,
>  			 struct tracer_opt *opt)
>  {
>  	struct dentry *t_options;
>  
> -	t_options = trace_options_init_dentry();
> +	t_options = trace_options_init_dentry(tr);
>  	if (!t_options)
>  		return;
>  
>  	topt->flags = flags;
>  	topt->opt = opt;
> +	topt->tr = tr;
>  
>  	topt->entry = trace_create_file(opt->name, 0644, t_options, topt,
>  				    &trace_options_fops);
> @@ -4886,7 +5524,7 @@ create_trace_option_file(struct trace_option_dentry *topt,
>  }
>  
>  static struct trace_option_dentry *
> -create_trace_option_files(struct tracer *tracer)
> +create_trace_option_files(struct trace_array *tr, struct tracer *tracer)
>  {
>  	struct trace_option_dentry *topts;
>  	struct tracer_flags *flags;
> @@ -4911,7 +5549,7 @@ create_trace_option_files(struct tracer *tracer)
>  		return NULL;
>  
>  	for (cnt = 0; opts[cnt].name; cnt++)
> -		create_trace_option_file(&topts[cnt], flags,
> +		create_trace_option_file(tr, &topts[cnt], flags,
>  					 &opts[cnt]);
>  
>  	return topts;
> @@ -4934,11 +5572,12 @@ destroy_trace_option_files(struct trace_option_dentry *topts)
>  }
>  
>  static struct dentry *
> -create_trace_option_core_file(const char *option, long index)
> +create_trace_option_core_file(struct trace_array *tr,
> +			      const char *option, long index)
>  {
>  	struct dentry *t_options;
>  
> -	t_options = trace_options_init_dentry();
> +	t_options = trace_options_init_dentry(tr);
>  	if (!t_options)
>  		return NULL;
>  
> @@ -4946,17 +5585,17 @@ create_trace_option_core_file(const char *option, long index)
>  				    &trace_options_core_fops);
>  }
>  
> -static __init void create_trace_options_dir(void)
> +static __init void create_trace_options_dir(struct trace_array *tr)
>  {
>  	struct dentry *t_options;
>  	int i;
>  
> -	t_options = trace_options_init_dentry();
> +	t_options = trace_options_init_dentry(tr);
>  	if (!t_options)
>  		return;
>  
>  	for (i = 0; trace_options[i]; i++)
> -		create_trace_option_core_file(trace_options[i], i);
> +		create_trace_option_core_file(tr, trace_options[i], i);
>  }
>  
>  static ssize_t
> @@ -4964,7 +5603,7 @@ rb_simple_read(struct file *filp, char __user *ubuf,
>  	       size_t cnt, loff_t *ppos)
>  {
>  	struct trace_array *tr = filp->private_data;
> -	struct ring_buffer *buffer = tr->buffer;
> +	struct ring_buffer *buffer = tr->trace_buffer.buffer;
>  	char buf[64];
>  	int r;
>  
> @@ -4983,7 +5622,7 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
>  		size_t cnt, loff_t *ppos)
>  {
>  	struct trace_array *tr = filp->private_data;
> -	struct ring_buffer *buffer = tr->buffer;
> +	struct ring_buffer *buffer = tr->trace_buffer.buffer;
>  	unsigned long val;
>  	int ret;
>  
> @@ -4995,12 +5634,12 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
>  		mutex_lock(&trace_types_lock);
>  		if (val) {
>  			ring_buffer_record_on(buffer);
> -			if (current_trace->start)
> -				current_trace->start(tr);
> +			if (tr->current_trace->start)
> +				tr->current_trace->start(tr);
>  		} else {
>  			ring_buffer_record_off(buffer);
> -			if (current_trace->stop)
> -				current_trace->stop(tr);
> +			if (tr->current_trace->stop)
> +				tr->current_trace->stop(tr);
>  		}
>  		mutex_unlock(&trace_types_lock);
>  	}
> @@ -5017,23 +5656,308 @@ static const struct file_operations rb_simple_fops = {
>  	.llseek		= default_llseek,
>  };
>  
> +struct dentry *trace_instance_dir;
> +
> +static void
> +init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer);
> +
> +static void init_trace_buffers(struct trace_array *tr, struct trace_buffer *buf)
> +{
> +	int cpu;
> +
> +	for_each_tracing_cpu(cpu) {
> +		memset(per_cpu_ptr(buf->data, cpu), 0, sizeof(struct trace_array_cpu));
> +		per_cpu_ptr(buf->data, cpu)->trace_cpu.cpu = cpu;
> +		per_cpu_ptr(buf->data, cpu)->trace_cpu.tr = tr;
> +	}
> +}
> +
> +static int
> +allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size)
> +{
> +	enum ring_buffer_flags rb_flags;
> +
> +	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
> +
> +	buf->buffer = ring_buffer_alloc(size, rb_flags);
> +	if (!buf->buffer)
> +		return -ENOMEM;
> +
> +	buf->data = alloc_percpu(struct trace_array_cpu);
> +	if (!buf->data) {
> +		ring_buffer_free(buf->buffer);
> +		return -ENOMEM;
> +	}
> +
> +	init_trace_buffers(tr, buf);
> +
> +	/* Allocate the first page for all buffers */
> +	set_buffer_entries(&tr->trace_buffer,
> +			   ring_buffer_size(tr->trace_buffer.buffer, 0));
> +
> +	return 0;
> +}
> +
> +static int allocate_trace_buffers(struct trace_array *tr, int size)
> +{
> +	int ret;
> +
> +	ret = allocate_trace_buffer(tr, &tr->trace_buffer, size);
> +	if (ret)
> +		return ret;
> +
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	ret = allocate_trace_buffer(tr, &tr->max_buffer,
> +				    allocate_snapshot ? size : 1);
> +	if (WARN_ON(ret)) {
> +		ring_buffer_free(tr->trace_buffer.buffer);
> +		free_percpu(tr->trace_buffer.data);
> +		return -ENOMEM;
> +	}
> +	tr->allocated_snapshot = allocate_snapshot;
> +
> +	/*
> +	 * Only the top level trace array gets its snapshot allocated
> +	 * from the kernel command line.
> +	 */
> +	allocate_snapshot = false;
> +#endif
> +	return 0;
> +}
> +
> +static int new_instance_create(const char *name)
> +{
> +	struct trace_array *tr;
> +	int ret;
> +
> +	mutex_lock(&trace_types_lock);
> +
> +	ret = -EEXIST;
> +	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
> +		if (tr->name && strcmp(tr->name, name) == 0)
> +			goto out_unlock;
> +	}
> +
> +	ret = -ENOMEM;
> +	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
> +	if (!tr)
> +		goto out_unlock;
> +
> +	tr->name = kstrdup(name, GFP_KERNEL);
> +	if (!tr->name)
> +		goto out_free_tr;
> +
> +	raw_spin_lock_init(&tr->start_lock);
> +
> +	tr->current_trace = &nop_trace;
> +
> +	INIT_LIST_HEAD(&tr->systems);
> +	INIT_LIST_HEAD(&tr->events);
> +
> +	if (allocate_trace_buffers(tr, trace_buf_size) < 0)
> +		goto out_free_tr;
> +
> +	/* Holder for file callbacks */
> +	tr->trace_cpu.cpu = RING_BUFFER_ALL_CPUS;
> +	tr->trace_cpu.tr = tr;
> +
> +	tr->dir = debugfs_create_dir(name, trace_instance_dir);
> +	if (!tr->dir)
> +		goto out_free_tr;
> +
> +	ret = event_trace_add_tracer(tr->dir, tr);
> +	if (ret)
> +		goto out_free_tr;
> +
> +	init_tracer_debugfs(tr, tr->dir);
> +
> +	list_add(&tr->list, &ftrace_trace_arrays);
> +
> +	mutex_unlock(&trace_types_lock);
> +
> +	return 0;
> +
> + out_free_tr:
> +	if (tr->trace_buffer.buffer)
> +		ring_buffer_free(tr->trace_buffer.buffer);
> +	kfree(tr->name);
> +	kfree(tr);
> +
> + out_unlock:
> +	mutex_unlock(&trace_types_lock);
> +
> +	return ret;
> +
> +}
> +
> +static int instance_delete(const char *name)
> +{
> +	struct trace_array *tr;
> +	int found = 0;
> +	int ret;
> +
> +	mutex_lock(&trace_types_lock);
> +
> +	ret = -ENODEV;
> +	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
> +		if (tr->name && strcmp(tr->name, name) == 0) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +	if (!found)
> +		goto out_unlock;
> +
> +	ret = -EBUSY;
> +	if (tr->ref)
> +		goto out_unlock;
> +
> +	list_del(&tr->list);
> +
> +	event_trace_del_tracer(tr);
> +	debugfs_remove_recursive(tr->dir);
> +	free_percpu(tr->trace_buffer.data);
> +	ring_buffer_free(tr->trace_buffer.buffer);
> +
> +	kfree(tr->name);
> +	kfree(tr);
> +
> +	ret = 0;
> +
> + out_unlock:
> +	mutex_unlock(&trace_types_lock);
> +
> +	return ret;
> +}
> +
> +static int instance_mkdir (struct inode *inode, struct dentry *dentry, umode_t mode)
> +{
> +	struct dentry *parent;
> +	int ret;
> +
> +	/* Paranoid: Make sure the parent is the "instances" directory */
> +	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
> +	if (WARN_ON_ONCE(parent != trace_instance_dir))
> +		return -ENOENT;
> +
> +	/*
> +	 * The inode mutex is locked, but debugfs_create_dir() will also
> +	 * take the mutex. As the instances directory can not be destroyed
> +	 * or changed in any other way, it is safe to unlock it, and
> +	 * let the dentry try. If two users try to make the same dir at
> +	 * the same time, then the new_instance_create() will determine the
> +	 * winner.
> +	 */
> +	mutex_unlock(&inode->i_mutex);
> +
> +	ret = new_instance_create(dentry->d_iname);
> +
> +	mutex_lock(&inode->i_mutex);
> +
> +	return ret;
> +}
> +
> +static int instance_rmdir(struct inode *inode, struct dentry *dentry)
> +{
> +	struct dentry *parent;
> +	int ret;
> +
> +	/* Paranoid: Make sure the parent is the "instances" directory */
> +	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
> +	if (WARN_ON_ONCE(parent != trace_instance_dir))
> +		return -ENOENT;
> +
> +	/* The caller did a dget() on dentry */
> +	mutex_unlock(&dentry->d_inode->i_mutex);
> +
> +	/*
> +	 * The inode mutex is locked, but debugfs_create_dir() will also
> +	 * take the mutex. As the instances directory can not be destroyed
> +	 * or changed in any other way, it is safe to unlock it, and
> +	 * let the dentry try. If two users try to make the same dir at
> +	 * the same time, then the instance_delete() will determine the
> +	 * winner.
> +	 */
> +	mutex_unlock(&inode->i_mutex);
> +
> +	ret = instance_delete(dentry->d_iname);
> +
> +	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
> +	mutex_lock(&dentry->d_inode->i_mutex);
> +
> +	return ret;
> +}
> +
> +static const struct inode_operations instance_dir_inode_operations = {
> +	.lookup		= simple_lookup,
> +	.mkdir		= instance_mkdir,
> +	.rmdir		= instance_rmdir,
> +};
> +
> +static __init void create_trace_instances(struct dentry *d_tracer)
> +{
> +	trace_instance_dir = debugfs_create_dir("instances", d_tracer);
> +	if (WARN_ON(!trace_instance_dir))
> +		return;
> +
> +	/* Hijack the dir inode operations, to allow mkdir */
> +	trace_instance_dir->d_inode->i_op = &instance_dir_inode_operations;
> +}
> +
> +static void
> +init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
> +{
> +	int cpu;
> +
> +	trace_create_file("trace_options", 0644, d_tracer,
> +			  tr, &tracing_iter_fops);
> +
> +	trace_create_file("trace", 0644, d_tracer,
> +			(void *)&tr->trace_cpu, &tracing_fops);
> +
> +	trace_create_file("trace_pipe", 0444, d_tracer,
> +			(void *)&tr->trace_cpu, &tracing_pipe_fops);
> +
> +	trace_create_file("buffer_size_kb", 0644, d_tracer,
> +			(void *)&tr->trace_cpu, &tracing_entries_fops);
> +
> +	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
> +			  tr, &tracing_total_entries_fops);
> +
> +	trace_create_file("free_buffer", 0644, d_tracer,
> +			  tr, &tracing_free_buffer_fops);
> +
> +	trace_create_file("trace_marker", 0220, d_tracer,
> +			  tr, &tracing_mark_fops);
> +
> +	trace_create_file("trace_clock", 0644, d_tracer, tr,
> +			  &trace_clock_fops);
> +
> +	trace_create_file("tracing_on", 0644, d_tracer,
> +			    tr, &rb_simple_fops);
> +
> +#ifdef CONFIG_TRACER_SNAPSHOT
> +	trace_create_file("snapshot", 0644, d_tracer,
> +			  (void *)&tr->trace_cpu, &snapshot_fops);
> +#endif
> +
> +	for_each_tracing_cpu(cpu)
> +		tracing_init_debugfs_percpu(tr, cpu);
> +
> +}
> +
>  static __init int tracer_init_debugfs(void)
>  {
>  	struct dentry *d_tracer;
> -	int cpu;
>  
>  	trace_access_lock_init();
>  
>  	d_tracer = tracing_init_dentry();
>  
> -	trace_create_file("trace_options", 0644, d_tracer,
> -			NULL, &tracing_iter_fops);
> +	init_tracer_debugfs(&global_trace, d_tracer);
>  
>  	trace_create_file("tracing_cpumask", 0644, d_tracer,
> -			NULL, &tracing_cpumask_fops);
> -
> -	trace_create_file("trace", 0644, d_tracer,
> -			(void *) TRACE_PIPE_ALL_CPU, &tracing_fops);
> +			&global_trace, &tracing_cpumask_fops);
>  
>  	trace_create_file("available_tracers", 0444, d_tracer,
>  			&global_trace, &show_traces_fops);
> @@ -5052,44 +5976,17 @@ static __init int tracer_init_debugfs(void)
>  	trace_create_file("README", 0444, d_tracer,
>  			NULL, &tracing_readme_fops);
>  
> -	trace_create_file("trace_pipe", 0444, d_tracer,
> -			(void *) TRACE_PIPE_ALL_CPU, &tracing_pipe_fops);
> -
> -	trace_create_file("buffer_size_kb", 0644, d_tracer,
> -			(void *) RING_BUFFER_ALL_CPUS, &tracing_entries_fops);
> -
> -	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
> -			&global_trace, &tracing_total_entries_fops);
> -
> -	trace_create_file("free_buffer", 0644, d_tracer,
> -			&global_trace, &tracing_free_buffer_fops);
> -
> -	trace_create_file("trace_marker", 0220, d_tracer,
> -			NULL, &tracing_mark_fops);
> -
>  	trace_create_file("saved_cmdlines", 0444, d_tracer,
>  			NULL, &tracing_saved_cmdlines_fops);
>  
> -	trace_create_file("trace_clock", 0644, d_tracer, NULL,
> -			  &trace_clock_fops);
> -
> -	trace_create_file("tracing_on", 0644, d_tracer,
> -			    &global_trace, &rb_simple_fops);
> -
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
>  			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
>  #endif
>  
> -#ifdef CONFIG_TRACER_SNAPSHOT
> -	trace_create_file("snapshot", 0644, d_tracer,
> -			  (void *) TRACE_PIPE_ALL_CPU, &snapshot_fops);
> -#endif
> -
> -	create_trace_options_dir();
> +	create_trace_instances(d_tracer);
>  
> -	for_each_tracing_cpu(cpu)
> -		tracing_init_debugfs_percpu(cpu);
> +	create_trace_options_dir(&global_trace);
>  
>  	return 0;
>  }
> @@ -5145,8 +6042,8 @@ void
>  trace_printk_seq(struct trace_seq *s)
>  {
>  	/* Probably should print a warning here. */
> -	if (s->len >= 1000)
> -		s->len = 1000;
> +	if (s->len >= TRACE_MAX_PRINT)
> +		s->len = TRACE_MAX_PRINT;
>  
>  	/* should be zero ended, but we are paranoid. */
>  	s->buffer[s->len] = 0;
> @@ -5159,46 +6056,43 @@ trace_printk_seq(struct trace_seq *s)
>  void trace_init_global_iter(struct trace_iterator *iter)
>  {
>  	iter->tr = &global_trace;
> -	iter->trace = current_trace;
> -	iter->cpu_file = TRACE_PIPE_ALL_CPU;
> +	iter->trace = iter->tr->current_trace;
> +	iter->cpu_file = RING_BUFFER_ALL_CPUS;
> +	iter->trace_buffer = &global_trace.trace_buffer;
>  }
>  
> -static void
> -__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
> +void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
>  {
> -	static arch_spinlock_t ftrace_dump_lock =
> -		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
>  	/* use static because iter can be a bit big for the stack */
>  	static struct trace_iterator iter;
> +	static atomic_t dump_running;
>  	unsigned int old_userobj;
> -	static int dump_ran;
>  	unsigned long flags;
>  	int cnt = 0, cpu;
>  
> -	/* only one dump */
> -	local_irq_save(flags);
> -	arch_spin_lock(&ftrace_dump_lock);
> -	if (dump_ran)
> -		goto out;
> -
> -	dump_ran = 1;
> +	/* Only allow one dump user at a time. */
> +	if (atomic_inc_return(&dump_running) != 1) {
> +		atomic_dec(&dump_running);
> +		return;
> +	}
>  
> +	/*
> +	 * Always turn off tracing when we dump.
> +	 * We don't need to show trace output of what happens
> +	 * between multiple crashes.
> +	 *
> +	 * If the user does a sysrq-z, then they can re-enable
> +	 * tracing with echo 1 > tracing_on.
> +	 */
>  	tracing_off();
>  
> -	/* Did function tracer already get disabled? */
> -	if (ftrace_is_dead()) {
> -		printk("# WARNING: FUNCTION TRACING IS CORRUPTED\n");
> -		printk("#          MAY BE MISSING FUNCTION EVENTS\n");
> -	}
> -
> -	if (disable_tracing)
> -		ftrace_kill();
> +	local_irq_save(flags);
>  
>  	/* Simulate the iterator */
>  	trace_init_global_iter(&iter);
>  
>  	for_each_tracing_cpu(cpu) {
> -		atomic_inc(&iter.tr->data[cpu]->disabled);
> +		atomic_inc(&per_cpu_ptr(iter.tr->trace_buffer.data, cpu)->disabled);
>  	}
>  
>  	old_userobj = trace_flags & TRACE_ITER_SYM_USEROBJ;
> @@ -5208,7 +6102,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
>  
>  	switch (oops_dump_mode) {
>  	case DUMP_ALL:
> -		iter.cpu_file = TRACE_PIPE_ALL_CPU;
> +		iter.cpu_file = RING_BUFFER_ALL_CPUS;
>  		break;
>  	case DUMP_ORIG:
>  		iter.cpu_file = raw_smp_processor_id();
> @@ -5217,11 +6111,17 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
>  		goto out_enable;
>  	default:
>  		printk(KERN_TRACE "Bad dumping mode, switching to all CPUs dump\n");
> -		iter.cpu_file = TRACE_PIPE_ALL_CPU;
> +		iter.cpu_file = RING_BUFFER_ALL_CPUS;
>  	}
>  
>  	printk(KERN_TRACE "Dumping ftrace buffer:\n");
>  
> +	/* Did function tracer already get disabled? */
> +	if (ftrace_is_dead()) {
> +		printk("# WARNING: FUNCTION TRACING IS CORRUPTED\n");
> +		printk("#          MAY BE MISSING FUNCTION EVENTS\n");
> +	}
> +
>  	/*
>  	 * We need to stop all tracing on all CPUS to read the
>  	 * the next buffer. This is a bit expensive, but is
> @@ -5261,33 +6161,19 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
>  		printk(KERN_TRACE "---------------------------------\n");
>  
>   out_enable:
> -	/* Re-enable tracing if requested */
> -	if (!disable_tracing) {
> -		trace_flags |= old_userobj;
> +	trace_flags |= old_userobj;
>  
> -		for_each_tracing_cpu(cpu) {
> -			atomic_dec(&iter.tr->data[cpu]->disabled);
> -		}
> -		tracing_on();
> +	for_each_tracing_cpu(cpu) {
> +		atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
>  	}
> -
> - out:
> -	arch_spin_unlock(&ftrace_dump_lock);
> + 	atomic_dec(&dump_running);
>  	local_irq_restore(flags);
>  }
> -
> -/* By default: disable tracing after the dump */
> -void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
> -{
> -	__ftrace_dump(true, oops_dump_mode);
> -}
>  EXPORT_SYMBOL_GPL(ftrace_dump);
>  
>  __init static int tracer_alloc_buffers(void)
>  {
>  	int ring_buf_size;
> -	enum ring_buffer_flags rb_flags;
> -	int i;
>  	int ret = -ENOMEM;
>  
> 
> @@ -5308,49 +6194,27 @@ __init static int tracer_alloc_buffers(void)
>  	else
>  		ring_buf_size = 1;
>  
> -	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
> -
>  	cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
>  	cpumask_copy(tracing_cpumask, cpu_all_mask);
>  
> +	raw_spin_lock_init(&global_trace.start_lock);
> +
>  	/* TODO: make the number of buffers hot pluggable with CPUS */
> -	global_trace.buffer = ring_buffer_alloc(ring_buf_size, rb_flags);
> -	if (!global_trace.buffer) {
> +	if (allocate_trace_buffers(&global_trace, ring_buf_size) < 0) {
>  		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
>  		WARN_ON(1);
>  		goto out_free_cpumask;
>  	}
> +
>  	if (global_trace.buffer_disabled)
>  		tracing_off();
>  
> -
> -#ifdef CONFIG_TRACER_MAX_TRACE
> -	max_tr.buffer = ring_buffer_alloc(1, rb_flags);
> -	if (!max_tr.buffer) {
> -		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
> -		WARN_ON(1);
> -		ring_buffer_free(global_trace.buffer);
> -		goto out_free_cpumask;
> -	}
> -#endif
> -
> -	/* Allocate the first page for all buffers */
> -	for_each_tracing_cpu(i) {
> -		global_trace.data[i] = &per_cpu(global_trace_cpu, i);
> -		max_tr.data[i] = &per_cpu(max_tr_data, i);
> -	}
> -
> -	set_buffer_entries(&global_trace,
> -			   ring_buffer_size(global_trace.buffer, 0));
> -#ifdef CONFIG_TRACER_MAX_TRACE
> -	set_buffer_entries(&max_tr, 1);
> -#endif
> -
>  	trace_init_cmdlines();
> -	init_irq_work(&trace_work_wakeup, trace_wake_up);
>  
>  	register_tracer(&nop_trace);
>  
> +	global_trace.current_trace = &nop_trace;
> +
>  	/* All seems OK, enable tracing */
>  	tracing_disabled = 0;
>  
> @@ -5359,16 +6223,32 @@ __init static int tracer_alloc_buffers(void)
>  
>  	register_die_notifier(&trace_die_notifier);
>  
> +	global_trace.flags = TRACE_ARRAY_FL_GLOBAL;
> +
> +	/* Holder for file callbacks */
> +	global_trace.trace_cpu.cpu = RING_BUFFER_ALL_CPUS;
> +	global_trace.trace_cpu.tr = &global_trace;
> +
> +	INIT_LIST_HEAD(&global_trace.systems);
> +	INIT_LIST_HEAD(&global_trace.events);
> +	list_add(&global_trace.list, &ftrace_trace_arrays);
> +
>  	while (trace_boot_options) {
>  		char *option;
>  
>  		option = strsep(&trace_boot_options, ",");
> -		trace_set_options(option);
> +		trace_set_options(&global_trace, option);
>  	}
>  
> +	register_snapshot_cmd();
> +
>  	return 0;
>  
>  out_free_cpumask:
> +	free_percpu(global_trace.trace_buffer.data);
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	free_percpu(global_trace.max_buffer.data);
> +#endif
>  	free_cpumask_var(tracing_cpumask);
>  out_free_buffer_mask:
>  	free_cpumask_var(tracing_buffer_mask);
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 2081971..9e01458 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -13,6 +13,11 @@
>  #include <linux/trace_seq.h>
>  #include <linux/ftrace_event.h>
>  
> +#ifdef CONFIG_FTRACE_SYSCALLS
> +#include <asm/unistd.h>		/* For NR_SYSCALLS	     */
> +#include <asm/syscall.h>	/* some archs define it here */
> +#endif
> +
>  enum trace_type {
>  	__TRACE_FIRST_TYPE = 0,
>  
> @@ -29,6 +34,7 @@ enum trace_type {
>  	TRACE_GRAPH_ENT,
>  	TRACE_USER_STACK,
>  	TRACE_BLK,
> +	TRACE_BPUTS,
>  
>  	__TRACE_LAST_TYPE,
>  };
> @@ -127,12 +133,21 @@ enum trace_flag_type {
>  
>  #define TRACE_BUF_SIZE		1024
>  
> +struct trace_array;
> +
> +struct trace_cpu {
> +	struct trace_array	*tr;
> +	struct dentry		*dir;
> +	int			cpu;
> +};
> +
>  /*
>   * The CPU trace array - it consists of thousands of trace entries
>   * plus some other descriptor data: (for example which task started
>   * the trace, etc.)
>   */
>  struct trace_array_cpu {
> +	struct trace_cpu	trace_cpu;
>  	atomic_t		disabled;
>  	void			*buffer_page;	/* ring buffer spare */
>  
> @@ -151,20 +166,83 @@ struct trace_array_cpu {
>  	char			comm[TASK_COMM_LEN];
>  };
>  
> +struct tracer;
> +
> +struct trace_buffer {
> +	struct trace_array		*tr;
> +	struct ring_buffer		*buffer;
> +	struct trace_array_cpu __percpu	*data;
> +	cycle_t				time_start;
> +	int				cpu;
> +};
> +
>  /*
>   * The trace array - an array of per-CPU trace arrays. This is the
>   * highest level data structure that individual tracers deal with.
>   * They have on/off state as well:
>   */
>  struct trace_array {
> -	struct ring_buffer	*buffer;
> -	int			cpu;
> +	struct list_head	list;
> +	char			*name;
> +	struct trace_buffer	trace_buffer;
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	/*
> +	 * The max_buffer is used to snapshot the trace when a maximum
> +	 * latency is reached, or when the user initiates a snapshot.
> +	 * Some tracers will use this to store a maximum trace while
> +	 * it continues examining live traces.
> +	 *
> +	 * The buffers for the max_buffer are set up the same as the trace_buffer
> +	 * When a snapshot is taken, the buffer of the max_buffer is swapped
> +	 * with the buffer of the trace_buffer and the buffers are reset for
> +	 * the trace_buffer so the tracing can continue.
> +	 */
> +	struct trace_buffer	max_buffer;
> +	bool			allocated_snapshot;
> +#endif
>  	int			buffer_disabled;
> -	cycle_t			time_start;
> +	struct trace_cpu	trace_cpu;	/* place holder */
> +#ifdef CONFIG_FTRACE_SYSCALLS
> +	int			sys_refcount_enter;
> +	int			sys_refcount_exit;
> +	DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
> +	DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
> +#endif
> +	int			stop_count;
> +	int			clock_id;
> +	struct tracer		*current_trace;
> +	unsigned int		flags;
> +	raw_spinlock_t		start_lock;
> +	struct dentry		*dir;
> +	struct dentry		*options;
> +	struct dentry		*percpu_dir;
> +	struct dentry		*event_dir;
> +	struct list_head	systems;
> +	struct list_head	events;
>  	struct task_struct	*waiter;
> -	struct trace_array_cpu	*data[NR_CPUS];
> +	int			ref;
>  };
>  
> +enum {
> +	TRACE_ARRAY_FL_GLOBAL	= (1 << 0)
> +};
> +
> +extern struct list_head ftrace_trace_arrays;
> +
> +/*
> + * The global tracer (top) should be the first trace array added,
> + * but we check the flag anyway.
> + */
> +static inline struct trace_array *top_trace_array(void)
> +{
> +	struct trace_array *tr;
> +
> +	tr = list_entry(ftrace_trace_arrays.prev,
> +			typeof(*tr), list);
> +	WARN_ON(!(tr->flags & TRACE_ARRAY_FL_GLOBAL));
> +	return tr;
> +}
> +
>  #define FTRACE_CMP_TYPE(var, type) \
>  	__builtin_types_compatible_p(typeof(var), type *)
>  
> @@ -200,6 +278,7 @@ extern void __ftrace_bad_type(void);
>  		IF_ASSIGN(var, ent, struct userstack_entry, TRACE_USER_STACK);\
>  		IF_ASSIGN(var, ent, struct print_entry, TRACE_PRINT);	\
>  		IF_ASSIGN(var, ent, struct bprint_entry, TRACE_BPRINT);	\
> +		IF_ASSIGN(var, ent, struct bputs_entry, TRACE_BPUTS);	\
>  		IF_ASSIGN(var, ent, struct trace_mmiotrace_rw,		\
>  			  TRACE_MMIO_RW);				\
>  		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
> @@ -289,9 +368,10 @@ struct tracer {
>  	struct tracer		*next;
>  	struct tracer_flags	*flags;
>  	bool			print_max;
> -	bool			use_max_tr;
> -	bool			allocated_snapshot;
>  	bool			enabled;
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +	bool			use_max_tr;
> +#endif
>  };
>  
> 
> @@ -427,8 +507,6 @@ static __always_inline void trace_clear_recursion(int bit)
>  	current->trace_recursion = val;
>  }
>  
> -#define TRACE_PIPE_ALL_CPU	-1
> -
>  static inline struct ring_buffer_iter *
>  trace_buffer_iter(struct trace_iterator *iter, int cpu)
>  {
> @@ -439,10 +517,10 @@ trace_buffer_iter(struct trace_iterator *iter, int cpu)
>  
>  int tracer_init(struct tracer *t, struct trace_array *tr);
>  int tracing_is_enabled(void);
> -void tracing_reset(struct trace_array *tr, int cpu);
> -void tracing_reset_online_cpus(struct trace_array *tr);
> +void tracing_reset(struct trace_buffer *buf, int cpu);
> +void tracing_reset_online_cpus(struct trace_buffer *buf);
>  void tracing_reset_current(int cpu);
> -void tracing_reset_current_online_cpus(void);
> +void tracing_reset_all_online_cpus(void);
>  int tracing_open_generic(struct inode *inode, struct file *filp);
>  struct dentry *trace_create_file(const char *name,
>  				 umode_t mode,
> @@ -450,6 +528,7 @@ struct dentry *trace_create_file(const char *name,
>  				 void *data,
>  				 const struct file_operations *fops);
>  
> +struct dentry *tracing_init_dentry_tr(struct trace_array *tr);
>  struct dentry *tracing_init_dentry(void);
>  
>  struct ring_buffer_event;
> @@ -583,7 +662,7 @@ extern int DYN_FTRACE_TEST_NAME(void);
>  #define DYN_FTRACE_TEST_NAME2 trace_selftest_dynamic_test_func2
>  extern int DYN_FTRACE_TEST_NAME2(void);
>  
> -extern int ring_buffer_expanded;
> +extern bool ring_buffer_expanded;
>  extern bool tracing_selftest_disabled;
>  DECLARE_PER_CPU(int, ftrace_cpu_disabled);
>  
> @@ -619,6 +698,8 @@ trace_array_vprintk(struct trace_array *tr,
>  		    unsigned long ip, const char *fmt, va_list args);
>  int trace_array_printk(struct trace_array *tr,
>  		       unsigned long ip, const char *fmt, ...);
> +int trace_array_printk_buf(struct ring_buffer *buffer,
> +			   unsigned long ip, const char *fmt, ...);
>  void trace_printk_seq(struct trace_seq *s);
>  enum print_line_t print_trace_line(struct trace_iterator *iter);
>  
> @@ -786,6 +867,7 @@ enum trace_iterator_flags {
>  	TRACE_ITER_STOP_ON_FREE		= 0x400000,
>  	TRACE_ITER_IRQ_INFO		= 0x800000,
>  	TRACE_ITER_MARKERS		= 0x1000000,
> +	TRACE_ITER_FUNCTION		= 0x2000000,
>  };
>  
>  /*
> @@ -832,8 +914,8 @@ enum {
>  
>  struct ftrace_event_field {
>  	struct list_head	link;
> -	char			*name;
> -	char			*type;
> +	const char		*name;
> +	const char		*type;
>  	int			filter_type;
>  	int			offset;
>  	int			size;
> @@ -851,12 +933,19 @@ struct event_filter {
>  struct event_subsystem {
>  	struct list_head	list;
>  	const char		*name;
> -	struct dentry		*entry;
>  	struct event_filter	*filter;
> -	int			nr_events;
>  	int			ref_count;
>  };
>  
> +struct ftrace_subsystem_dir {
> +	struct list_head		list;
> +	struct event_subsystem		*subsystem;
> +	struct trace_array		*tr;
> +	struct dentry			*entry;
> +	int				ref_count;
> +	int				nr_events;
> +};
> +
>  #define FILTER_PRED_INVALID	((unsigned short)-1)
>  #define FILTER_PRED_IS_RIGHT	(1 << 15)
>  #define FILTER_PRED_FOLD	(1 << 15)
> @@ -906,22 +995,20 @@ struct filter_pred {
>  	unsigned short		right;
>  };
>  
> -extern struct list_head ftrace_common_fields;
> -
>  extern enum regex_type
>  filter_parse_regex(char *buff, int len, char **search, int *not);
>  extern void print_event_filter(struct ftrace_event_call *call,
>  			       struct trace_seq *s);
>  extern int apply_event_filter(struct ftrace_event_call *call,
>  			      char *filter_string);
> -extern int apply_subsystem_event_filter(struct event_subsystem *system,
> +extern int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
>  					char *filter_string);
>  extern void print_subsystem_event_filter(struct event_subsystem *system,
>  					 struct trace_seq *s);
>  extern int filter_assign_type(const char *type);
>  
> -struct list_head *
> -trace_get_fields(struct ftrace_event_call *event_call);
> +struct ftrace_event_field *
> +trace_find_event_field(struct ftrace_event_call *call, char *name);
>  
>  static inline int
>  filter_check_discard(struct ftrace_event_call *call, void *rec,
> @@ -938,6 +1025,8 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
>  }
>  
>  extern void trace_event_enable_cmd_record(bool enable);
> +extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
> +extern int event_trace_del_tracer(struct trace_array *tr);
>  
>  extern struct mutex event_mutex;
>  extern struct list_head ftrace_events;
> @@ -948,7 +1037,18 @@ extern const char *__stop___trace_bprintk_fmt[];
>  void trace_printk_init_buffers(void);
>  void trace_printk_start_comm(void);
>  int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set);
> -int set_tracer_flag(unsigned int mask, int enabled);
> +int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled);
> +
> +/*
> + * Normal trace_printk() and friends allocates special buffers
> + * to do the manipulation, as well as saves the print formats
> + * into sections to display. But the trace infrastructure wants
> + * to use these without the added overhead at the price of being
> + * a bit slower (used mainly for warnings, where we don't care
> + * about performance). The internal_trace_puts() is for such
> + * a purpose.
> + */
> +#define internal_trace_puts(str) __trace_puts(_THIS_IP_, str, strlen(str))
>  
>  #undef FTRACE_ENTRY
>  #define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> index 95e9684..d594da0 100644
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -32,6 +32,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  {
>  	struct ftrace_event_call *call = &event_branch;
>  	struct trace_array *tr = branch_tracer;
> +	struct trace_array_cpu *data;
>  	struct ring_buffer_event *event;
>  	struct trace_branch *entry;
>  	struct ring_buffer *buffer;
> @@ -51,11 +52,12 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  
>  	local_irq_save(flags);
>  	cpu = raw_smp_processor_id();
> -	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
> +	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
> +	if (atomic_inc_return(&data->disabled) != 1)
>  		goto out;
>  
>  	pc = preempt_count();
> -	buffer = tr->buffer;
> +	buffer = tr->trace_buffer.buffer;
>  	event = trace_buffer_lock_reserve(buffer, TRACE_BRANCH,
>  					  sizeof(*entry), flags, pc);
>  	if (!event)
> @@ -80,7 +82,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  		__buffer_unlock_commit(buffer, event);
>  
>   out:
> -	atomic_dec(&tr->data[cpu]->disabled);
> +	atomic_dec(&data->disabled);
>  	local_irq_restore(flags);
>  }
>  
> diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
> index aa8f5f4..26dc348 100644
> --- a/kernel/trace/trace_clock.c
> +++ b/kernel/trace/trace_clock.c
> @@ -57,6 +57,16 @@ u64 notrace trace_clock(void)
>  	return local_clock();
>  }
>  
> +/*
> + * trace_jiffy_clock(): Simply use jiffies as a clock counter.
> + */
> +u64 notrace trace_clock_jiffies(void)
> +{
> +	u64 jiffy = jiffies - INITIAL_JIFFIES;
> +
> +	/* Return nsecs */
> +	return (u64)jiffies_to_usecs(jiffy) * 1000ULL;
> +}
>  
>  /*
>   * trace_clock_global(): special globally coherent trace clock
> diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
> index 4108e12..e2d027a 100644
> --- a/kernel/trace/trace_entries.h
> +++ b/kernel/trace/trace_entries.h
> @@ -223,8 +223,8 @@ FTRACE_ENTRY(bprint, bprint_entry,
>  		__dynamic_array(	u32,	buf	)
>  	),
>  
> -	F_printk("%08lx fmt:%p",
> -		 __entry->ip, __entry->fmt),
> +	F_printk("%pf: %s",
> +		 (void *)__entry->ip, __entry->fmt),
>  
>  	FILTER_OTHER
>  );
> @@ -238,8 +238,23 @@ FTRACE_ENTRY(print, print_entry,
>  		__dynamic_array(	char,	buf	)
>  	),
>  
> -	F_printk("%08lx %s",
> -		 __entry->ip, __entry->buf),
> +	F_printk("%pf: %s",
> +		 (void *)__entry->ip, __entry->buf),
> +
> +	FILTER_OTHER
> +);
> +
> +FTRACE_ENTRY(bputs, bputs_entry,
> +
> +	TRACE_BPUTS,
> +
> +	F_STRUCT(
> +		__field(	unsigned long,	ip	)
> +		__field(	const char *,	str	)
> +	),
> +
> +	F_printk("%pf: %s",
> +		 (void *)__entry->ip, __entry->str),
>  
>  	FILTER_OTHER
>  );
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 57e9b28..53582e9 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -34,9 +34,27 @@ char event_storage[EVENT_STORAGE_SIZE];
>  EXPORT_SYMBOL_GPL(event_storage);
>  
>  LIST_HEAD(ftrace_events);
> -LIST_HEAD(ftrace_common_fields);
> +static LIST_HEAD(ftrace_common_fields);
>  
> -struct list_head *
> +#define GFP_TRACE (GFP_KERNEL | __GFP_ZERO)
> +
> +static struct kmem_cache *field_cachep;
> +static struct kmem_cache *file_cachep;
> +
> +/* Double loops, do not use break, only goto's work */
> +#define do_for_each_event_file(tr, file)			\
> +	list_for_each_entry(tr, &ftrace_trace_arrays, list) {	\
> +		list_for_each_entry(file, &tr->events, list)
> +
> +#define do_for_each_event_file_safe(tr, file)			\
> +	list_for_each_entry(tr, &ftrace_trace_arrays, list) {	\
> +		struct ftrace_event_file *___n;				\
> +		list_for_each_entry_safe(file, ___n, &tr->events, list)
> +
> +#define while_for_each_event_file()		\
> +	}
> +
> +static struct list_head *
>  trace_get_fields(struct ftrace_event_call *event_call)
>  {
>  	if (!event_call->class->get_fields)
> @@ -44,23 +62,45 @@ trace_get_fields(struct ftrace_event_call *event_call)
>  	return event_call->class->get_fields(event_call);
>  }
>  
> +static struct ftrace_event_field *
> +__find_event_field(struct list_head *head, char *name)
> +{
> +	struct ftrace_event_field *field;
> +
> +	list_for_each_entry(field, head, link) {
> +		if (!strcmp(field->name, name))
> +			return field;
> +	}
> +
> +	return NULL;
> +}
> +
> +struct ftrace_event_field *
> +trace_find_event_field(struct ftrace_event_call *call, char *name)
> +{
> +	struct ftrace_event_field *field;
> +	struct list_head *head;
> +
> +	field = __find_event_field(&ftrace_common_fields, name);
> +	if (field)
> +		return field;
> +
> +	head = trace_get_fields(call);
> +	return __find_event_field(head, name);
> +}
> +
>  static int __trace_define_field(struct list_head *head, const char *type,
>  				const char *name, int offset, int size,
>  				int is_signed, int filter_type)
>  {
>  	struct ftrace_event_field *field;
>  
> -	field = kzalloc(sizeof(*field), GFP_KERNEL);
> +	field = kmem_cache_alloc(field_cachep, GFP_TRACE);
>  	if (!field)
>  		goto err;
>  
> -	field->name = kstrdup(name, GFP_KERNEL);
> -	if (!field->name)
> -		goto err;
> -
> -	field->type = kstrdup(type, GFP_KERNEL);
> -	if (!field->type)
> -		goto err;
> +	field->name = name;
> +	field->type = type;
>  
>  	if (filter_type == FILTER_OTHER)
>  		field->filter_type = filter_assign_type(type);
> @@ -76,9 +116,7 @@ static int __trace_define_field(struct list_head *head, const char *type,
>  	return 0;
>  
>  err:
> -	if (field)
> -		kfree(field->name);
> -	kfree(field);
> +	kmem_cache_free(field_cachep, field);
>  
>  	return -ENOMEM;
>  }
> @@ -120,7 +158,7 @@ static int trace_define_common_fields(void)
>  	return ret;
>  }
>  
> -void trace_destroy_fields(struct ftrace_event_call *call)
> +static void trace_destroy_fields(struct ftrace_event_call *call)
>  {
>  	struct ftrace_event_field *field, *next;
>  	struct list_head *head;
> @@ -128,9 +166,7 @@ void trace_destroy_fields(struct ftrace_event_call *call)
>  	head = trace_get_fields(call);
>  	list_for_each_entry_safe(field, next, head, link) {
>  		list_del(&field->link);
> -		kfree(field->type);
> -		kfree(field->name);
> -		kfree(field);
> +		kmem_cache_free(field_cachep, field);
>  	}
>  }
>  
> @@ -149,15 +185,17 @@ EXPORT_SYMBOL_GPL(trace_event_raw_init);
>  int ftrace_event_reg(struct ftrace_event_call *call,
>  		     enum trace_reg type, void *data)
>  {
> +	struct ftrace_event_file *file = data;
> +
>  	switch (type) {
>  	case TRACE_REG_REGISTER:
>  		return tracepoint_probe_register(call->name,
>  						 call->class->probe,
> -						 call);
> +						 file);
>  	case TRACE_REG_UNREGISTER:
>  		tracepoint_probe_unregister(call->name,
>  					    call->class->probe,
> -					    call);
> +					    file);
>  		return 0;
>  
>  #ifdef CONFIG_PERF_EVENTS
> @@ -183,54 +221,100 @@ EXPORT_SYMBOL_GPL(ftrace_event_reg);
>  
>  void trace_event_enable_cmd_record(bool enable)
>  {
> -	struct ftrace_event_call *call;
> +	struct ftrace_event_file *file;
> +	struct trace_array *tr;
>  
>  	mutex_lock(&event_mutex);
> -	list_for_each_entry(call, &ftrace_events, list) {
> -		if (!(call->flags & TRACE_EVENT_FL_ENABLED))
> +	do_for_each_event_file(tr, file) {
> +
> +		if (!(file->flags & FTRACE_EVENT_FL_ENABLED))
>  			continue;
>  
>  		if (enable) {
>  			tracing_start_cmdline_record();
> -			call->flags |= TRACE_EVENT_FL_RECORDED_CMD;
> +			set_bit(FTRACE_EVENT_FL_RECORDED_CMD_BIT, &file->flags);
>  		} else {
>  			tracing_stop_cmdline_record();
> -			call->flags &= ~TRACE_EVENT_FL_RECORDED_CMD;
> +			clear_bit(FTRACE_EVENT_FL_RECORDED_CMD_BIT, &file->flags);
>  		}
> -	}
> +	} while_for_each_event_file();
>  	mutex_unlock(&event_mutex);
>  }
>  
> -static int ftrace_event_enable_disable(struct ftrace_event_call *call,
> -					int enable)
> +static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
> +					 int enable, int soft_disable)
>  {
> +	struct ftrace_event_call *call = file->event_call;
>  	int ret = 0;
> +	int disable;
>  
>  	switch (enable) {
>  	case 0:
> -		if (call->flags & TRACE_EVENT_FL_ENABLED) {
> -			call->flags &= ~TRACE_EVENT_FL_ENABLED;
> -			if (call->flags & TRACE_EVENT_FL_RECORDED_CMD) {
> +		/*
> +		 * When soft_disable is set and enable is cleared, we want
> +		 * to clear the SOFT_DISABLED flag but leave the event in the
> +		 * state that it was. That is, if the event was enabled and
> +		 * SOFT_DISABLED isn't set, then do nothing. But if SOFT_DISABLED
> +		 * is set we do not want the event to be enabled before we
> +		 * clear the bit.
> +		 *
> +		 * When soft_disable is not set but the SOFT_MODE flag is,
> +		 * we do nothing. Do not disable the tracepoint, otherwise
> +		 * "soft enable"s (clearing the SOFT_DISABLED bit) wont work.
> +		 */
> +		if (soft_disable) {
> +			disable = file->flags & FTRACE_EVENT_FL_SOFT_DISABLED;
> +			clear_bit(FTRACE_EVENT_FL_SOFT_MODE_BIT, &file->flags);
> +		} else
> +			disable = !(file->flags & FTRACE_EVENT_FL_SOFT_MODE);
> +
> +		if (disable && (file->flags & FTRACE_EVENT_FL_ENABLED)) {
> +			clear_bit(FTRACE_EVENT_FL_ENABLED_BIT, &file->flags);
> +			if (file->flags & FTRACE_EVENT_FL_RECORDED_CMD) {
>  				tracing_stop_cmdline_record();
> -				call->flags &= ~TRACE_EVENT_FL_RECORDED_CMD;
> +				clear_bit(FTRACE_EVENT_FL_RECORDED_CMD_BIT, &file->flags);
>  			}
> -			call->class->reg(call, TRACE_REG_UNREGISTER, NULL);
> +			call->class->reg(call, TRACE_REG_UNREGISTER, file);
>  		}
> +		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT */
> +		if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
> +			set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
>  		break;
>  	case 1:
> -		if (!(call->flags & TRACE_EVENT_FL_ENABLED)) {
> +		/*
> +		 * When soft_disable is set and enable is set, we want to
> +		 * register the tracepoint for the event, but leave the event
> +		 * as is. That means, if the event was already enabled, we do
> +		 * nothing (but set SOFT_MODE). If the event is disabled, we
> +		 * set SOFT_DISABLED before enabling the event tracepoint, so
> +		 * it still seems to be disabled.
> +		 */
> +		if (!soft_disable)
> +			clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
> +		else
> +			set_bit(FTRACE_EVENT_FL_SOFT_MODE_BIT, &file->flags);
> +
> +		if (!(file->flags & FTRACE_EVENT_FL_ENABLED)) {
> +
> +			/* Keep the event disabled, when going to SOFT_MODE. */
> +			if (soft_disable)
> +				set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
> +
>  			if (trace_flags & TRACE_ITER_RECORD_CMD) {
>  				tracing_start_cmdline_record();
> -				call->flags |= TRACE_EVENT_FL_RECORDED_CMD;
> +				set_bit(FTRACE_EVENT_FL_RECORDED_CMD_BIT, &file->flags);
>  			}
> -			ret = call->class->reg(call, TRACE_REG_REGISTER, NULL);
> +			ret = call->class->reg(call, TRACE_REG_REGISTER, file);
>  			if (ret) {
>  				tracing_stop_cmdline_record();
>  				pr_info("event trace: Could not enable event "
>  					"%s\n", call->name);
>  				break;
>  			}
> -			call->flags |= TRACE_EVENT_FL_ENABLED;
> +			set_bit(FTRACE_EVENT_FL_ENABLED_BIT, &file->flags);
> +
> +			/* WAS_ENABLED gets set but never cleared. */
> +			call->flags |= TRACE_EVENT_FL_WAS_ENABLED;
>  		}
>  		break;
>  	}
> @@ -238,13 +322,19 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
>  	return ret;
>  }
>  
> -static void ftrace_clear_events(void)
> +static int ftrace_event_enable_disable(struct ftrace_event_file *file,
> +				       int enable)
>  {
> -	struct ftrace_event_call *call;
> +	return __ftrace_event_enable_disable(file, enable, 0);
> +}
> +
> +static void ftrace_clear_events(struct trace_array *tr)
> +{
> +	struct ftrace_event_file *file;
>  
>  	mutex_lock(&event_mutex);
> -	list_for_each_entry(call, &ftrace_events, list) {
> -		ftrace_event_enable_disable(call, 0);
> +	list_for_each_entry(file, &tr->events, list) {
> +		ftrace_event_enable_disable(file, 0);
>  	}
>  	mutex_unlock(&event_mutex);
>  }
> @@ -257,11 +347,12 @@ static void __put_system(struct event_subsystem *system)
>  	if (--system->ref_count)
>  		return;
>  
> +	list_del(&system->list);
> +
>  	if (filter) {
>  		kfree(filter->filter_string);
>  		kfree(filter);
>  	}
> -	kfree(system->name);
>  	kfree(system);
>  }
>  
> @@ -271,24 +362,45 @@ static void __get_system(struct event_subsystem *system)
>  	system->ref_count++;
>  }
>  
> -static void put_system(struct event_subsystem *system)
> +static void __get_system_dir(struct ftrace_subsystem_dir *dir)
> +{
> +	WARN_ON_ONCE(dir->ref_count == 0);
> +	dir->ref_count++;
> +	__get_system(dir->subsystem);
> +}
> +
> +static void __put_system_dir(struct ftrace_subsystem_dir *dir)
> +{
> +	WARN_ON_ONCE(dir->ref_count == 0);
> +	/* If the subsystem is about to be freed, the dir must be too */
> +	WARN_ON_ONCE(dir->subsystem->ref_count == 1 && dir->ref_count != 1);
> +
> +	__put_system(dir->subsystem);
> +	if (!--dir->ref_count)
> +		kfree(dir);
> +}
> +
> +static void put_system(struct ftrace_subsystem_dir *dir)
>  {
>  	mutex_lock(&event_mutex);
> -	__put_system(system);
> +	__put_system_dir(dir);
>  	mutex_unlock(&event_mutex);
>  }
>  
>  /*
>   * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
>   */
> -static int __ftrace_set_clr_event(const char *match, const char *sub,
> -				  const char *event, int set)
> +static int __ftrace_set_clr_event(struct trace_array *tr, const char *match,
> +				  const char *sub, const char *event, int set)
>  {
> +	struct ftrace_event_file *file;
>  	struct ftrace_event_call *call;
>  	int ret = -EINVAL;
>  
>  	mutex_lock(&event_mutex);
> -	list_for_each_entry(call, &ftrace_events, list) {
> +	list_for_each_entry(file, &tr->events, list) {
> +
> +		call = file->event_call;
>  
>  		if (!call->name || !call->class || !call->class->reg)
>  			continue;
> @@ -307,7 +419,7 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
>  		if (event && strcmp(event, call->name) != 0)
>  			continue;
>  
> -		ftrace_event_enable_disable(call, set);
> +		ftrace_event_enable_disable(file, set);
>  
>  		ret = 0;
>  	}
> @@ -316,7 +428,7 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
>  	return ret;
>  }
>  
> -static int ftrace_set_clr_event(char *buf, int set)
> +static int ftrace_set_clr_event(struct trace_array *tr, char *buf, int set)
>  {
>  	char *event = NULL, *sub = NULL, *match;
>  
> @@ -344,7 +456,7 @@ static int ftrace_set_clr_event(char *buf, int set)
>  			event = NULL;
>  	}
>  
> -	return __ftrace_set_clr_event(match, sub, event, set);
> +	return __ftrace_set_clr_event(tr, match, sub, event, set);
>  }
>  
>  /**
> @@ -361,7 +473,9 @@ static int ftrace_set_clr_event(char *buf, int set)
>   */
>  int trace_set_clr_event(const char *system, const char *event, int set)
>  {
> -	return __ftrace_set_clr_event(NULL, system, event, set);
> +	struct trace_array *tr = top_trace_array();
> +
> +	return __ftrace_set_clr_event(tr, NULL, system, event, set);
>  }
>  EXPORT_SYMBOL_GPL(trace_set_clr_event);
>  
> @@ -373,6 +487,8 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
>  		   size_t cnt, loff_t *ppos)
>  {
>  	struct trace_parser parser;
> +	struct seq_file *m = file->private_data;
> +	struct trace_array *tr = m->private;
>  	ssize_t read, ret;
>  
>  	if (!cnt)
> @@ -395,7 +511,7 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
>  
>  		parser.buffer[parser.idx] = 0;
>  
> -		ret = ftrace_set_clr_event(parser.buffer + !set, set);
> +		ret = ftrace_set_clr_event(tr, parser.buffer + !set, set);
>  		if (ret)
>  			goto out_put;
>  	}
> @@ -411,17 +527,20 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
>  static void *
>  t_next(struct seq_file *m, void *v, loff_t *pos)
>  {
> -	struct ftrace_event_call *call = v;
> +	struct ftrace_event_file *file = v;
> +	struct ftrace_event_call *call;
> +	struct trace_array *tr = m->private;
>  
>  	(*pos)++;
>  
> -	list_for_each_entry_continue(call, &ftrace_events, list) {
> +	list_for_each_entry_continue(file, &tr->events, list) {
> +		call = file->event_call;
>  		/*
>  		 * The ftrace subsystem is for showing formats only.
>  		 * They can not be enabled or disabled via the event files.
>  		 */
>  		if (call->class && call->class->reg)
> -			return call;
> +			return file;
>  	}
>  
>  	return NULL;
> @@ -429,30 +548,32 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
>  
>  static void *t_start(struct seq_file *m, loff_t *pos)
>  {
> -	struct ftrace_event_call *call;
> +	struct ftrace_event_file *file;
> +	struct trace_array *tr = m->private;
>  	loff_t l;
>  
>  	mutex_lock(&event_mutex);
>  
> -	call = list_entry(&ftrace_events, struct ftrace_event_call, list);
> +	file = list_entry(&tr->events, struct ftrace_event_file, list);
>  	for (l = 0; l <= *pos; ) {
> -		call = t_next(m, call, &l);
> -		if (!call)
> +		file = t_next(m, file, &l);
> +		if (!file)
>  			break;
>  	}
> -	return call;
> +	return file;
>  }
>  
>  static void *
>  s_next(struct seq_file *m, void *v, loff_t *pos)
>  {
> -	struct ftrace_event_call *call = v;
> +	struct ftrace_event_file *file = v;
> +	struct trace_array *tr = m->private;
>  
>  	(*pos)++;
>  
> -	list_for_each_entry_continue(call, &ftrace_events, list) {
> -		if (call->flags & TRACE_EVENT_FL_ENABLED)
> -			return call;
> +	list_for_each_entry_continue(file, &tr->events, list) {
> +		if (file->flags & FTRACE_EVENT_FL_ENABLED)
> +			return file;
>  	}
>  
>  	return NULL;
> @@ -460,23 +581,25 @@ s_next(struct seq_file *m, void *v, loff_t *pos)
>  
>  static void *s_start(struct seq_file *m, loff_t *pos)
>  {
> -	struct ftrace_event_call *call;
> +	struct ftrace_event_file *file;
> +	struct trace_array *tr = m->private;
>  	loff_t l;
>  
>  	mutex_lock(&event_mutex);
>  
> -	call = list_entry(&ftrace_events, struct ftrace_event_call, list);
> +	file = list_entry(&tr->events, struct ftrace_event_file, list);
>  	for (l = 0; l <= *pos; ) {
> -		call = s_next(m, call, &l);
> -		if (!call)
> +		file = s_next(m, file, &l);
> +		if (!file)
>  			break;
>  	}
> -	return call;
> +	return file;
>  }
>  
>  static int t_show(struct seq_file *m, void *v)
>  {
> -	struct ftrace_event_call *call = v;
> +	struct ftrace_event_file *file = v;
> +	struct ftrace_event_call *call = file->event_call;
>  
>  	if (strcmp(call->class->system, TRACE_SYSTEM) != 0)
>  		seq_printf(m, "%s:", call->class->system);
> @@ -494,25 +617,31 @@ static ssize_t
>  event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
>  		  loff_t *ppos)
>  {
> -	struct ftrace_event_call *call = filp->private_data;
> +	struct ftrace_event_file *file = filp->private_data;
>  	char *buf;
>  
> -	if (call->flags & TRACE_EVENT_FL_ENABLED)
> -		buf = "1\n";
> -	else
> +	if (file->flags & FTRACE_EVENT_FL_ENABLED) {
> +		if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED)
> +			buf = "0*\n";
> +		else
> +			buf = "1\n";
> +	} else
>  		buf = "0\n";
>  
> -	return simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, strlen(buf));
>  }
>  
>  static ssize_t
>  event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  		   loff_t *ppos)
>  {
> -	struct ftrace_event_call *call = filp->private_data;
> +	struct ftrace_event_file *file = filp->private_data;
>  	unsigned long val;
>  	int ret;
>  
> +	if (!file)
> +		return -EINVAL;
> +
>  	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
>  	if (ret)
>  		return ret;
> @@ -525,7 +654,7 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  	case 0:
>  	case 1:
>  		mutex_lock(&event_mutex);
> -		ret = ftrace_event_enable_disable(call, val);
> +		ret = ftrace_event_enable_disable(file, val);
>  		mutex_unlock(&event_mutex);
>  		break;
>  
> @@ -543,14 +672,18 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
>  		   loff_t *ppos)
>  {
>  	const char set_to_char[4] = { '?', '0', '1', 'X' };
> -	struct event_subsystem *system = filp->private_data;
> +	struct ftrace_subsystem_dir *dir = filp->private_data;
> +	struct event_subsystem *system = dir->subsystem;
>  	struct ftrace_event_call *call;
> +	struct ftrace_event_file *file;
> +	struct trace_array *tr = dir->tr;
>  	char buf[2];
>  	int set = 0;
>  	int ret;
>  
>  	mutex_lock(&event_mutex);
> -	list_for_each_entry(call, &ftrace_events, list) {
> +	list_for_each_entry(file, &tr->events, list) {
> +		call = file->event_call;
>  		if (!call->name || !call->class || !call->class->reg)
>  			continue;
>  
> @@ -562,7 +695,7 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
>  		 * or if all events or cleared, or if we have
>  		 * a mixture.
>  		 */
> -		set |= (1 << !!(call->flags & TRACE_EVENT_FL_ENABLED));
> +		set |= (1 << !!(file->flags & FTRACE_EVENT_FL_ENABLED));
>  
>  		/*
>  		 * If we have a mixture, no need to look further.
> @@ -584,7 +717,8 @@ static ssize_t
>  system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  		    loff_t *ppos)
>  {
> -	struct event_subsystem *system = filp->private_data;
> +	struct ftrace_subsystem_dir *dir = filp->private_data;
> +	struct event_subsystem *system = dir->subsystem;
>  	const char *name = NULL;
>  	unsigned long val;
>  	ssize_t ret;
> @@ -607,7 +741,7 @@ system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  	if (system)
>  		name = system->name;
>  
> -	ret = __ftrace_set_clr_event(NULL, name, NULL, val);
> +	ret = __ftrace_set_clr_event(dir->tr, NULL, name, NULL, val);
>  	if (ret)
>  		goto out;
>  
> @@ -845,43 +979,75 @@ static LIST_HEAD(event_subsystems);
>  static int subsystem_open(struct inode *inode, struct file *filp)
>  {
>  	struct event_subsystem *system = NULL;
> +	struct ftrace_subsystem_dir *dir = NULL; /* Initialize for gcc */
> +	struct trace_array *tr;
>  	int ret;
>  
> -	if (!inode->i_private)
> -		goto skip_search;
> -
>  	/* Make sure the system still exists */
>  	mutex_lock(&event_mutex);
> -	list_for_each_entry(system, &event_subsystems, list) {
> -		if (system == inode->i_private) {
> -			/* Don't open systems with no events */
> -			if (!system->nr_events) {
> -				system = NULL;
> -				break;
> +	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
> +		list_for_each_entry(dir, &tr->systems, list) {
> +			if (dir == inode->i_private) {
> +				/* Don't open systems with no events */
> +				if (dir->nr_events) {
> +					__get_system_dir(dir);
> +					system = dir->subsystem;
> +				}
> +				goto exit_loop;
>  			}
> -			__get_system(system);
> -			break;
>  		}
>  	}
> + exit_loop:
>  	mutex_unlock(&event_mutex);
>  
> -	if (system != inode->i_private)
> +	if (!system)
>  		return -ENODEV;
>  
> - skip_search:
> +	/* Some versions of gcc think dir can be uninitialized here */
> +	WARN_ON(!dir);
> +
> +	ret = tracing_open_generic(inode, filp);
> +	if (ret < 0)
> +		put_system(dir);
> +
> +	return ret;
> +}
> +
> +static int system_tr_open(struct inode *inode, struct file *filp)
> +{
> +	struct ftrace_subsystem_dir *dir;
> +	struct trace_array *tr = inode->i_private;
> +	int ret;
> +
> +	/* Make a temporary dir that has no system but points to tr */
> +	dir = kzalloc(sizeof(*dir), GFP_KERNEL);
> +	if (!dir)
> +		return -ENOMEM;
> +
> +	dir->tr = tr;
> +
>  	ret = tracing_open_generic(inode, filp);
> -	if (ret < 0 && system)
> -		put_system(system);
> +	if (ret < 0)
> +		kfree(dir);
> +
> +	filp->private_data = dir;
>  
>  	return ret;
>  }
>  
>  static int subsystem_release(struct inode *inode, struct file *file)
>  {
> -	struct event_subsystem *system = inode->i_private;
> +	struct ftrace_subsystem_dir *dir = file->private_data;
>  
> -	if (system)
> -		put_system(system);
> +	/*
> +	 * If dir->subsystem is NULL, then this is a temporary
> +	 * descriptor that was made for a trace_array to enable
> +	 * all subsystems.
> +	 */
> +	if (dir->subsystem)
> +		put_system(dir);
> +	else
> +		kfree(dir);
>  
>  	return 0;
>  }
> @@ -890,7 +1056,8 @@ static ssize_t
>  subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
>  		      loff_t *ppos)
>  {
> -	struct event_subsystem *system = filp->private_data;
> +	struct ftrace_subsystem_dir *dir = filp->private_data;
> +	struct event_subsystem *system = dir->subsystem;
>  	struct trace_seq *s;
>  	int r;
>  
> @@ -915,7 +1082,7 @@ static ssize_t
>  subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  		       loff_t *ppos)
>  {
> -	struct event_subsystem *system = filp->private_data;
> +	struct ftrace_subsystem_dir *dir = filp->private_data;
>  	char *buf;
>  	int err;
>  
> @@ -932,7 +1099,7 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  	}
>  	buf[cnt] = '\0';
>  
> -	err = apply_subsystem_event_filter(system, buf);
> +	err = apply_subsystem_event_filter(dir, buf);
>  	free_page((unsigned long) buf);
>  	if (err < 0)
>  		return err;
> @@ -1041,30 +1208,35 @@ static const struct file_operations ftrace_system_enable_fops = {
>  	.release = subsystem_release,
>  };
>  
> +static const struct file_operations ftrace_tr_enable_fops = {
> +	.open = system_tr_open,
> +	.read = system_enable_read,
> +	.write = system_enable_write,
> +	.llseek = default_llseek,
> +	.release = subsystem_release,
> +};
> +
>  static const struct file_operations ftrace_show_header_fops = {
>  	.open = tracing_open_generic,
>  	.read = show_header,
>  	.llseek = default_llseek,
>  };
>  
> -static struct dentry *event_trace_events_dir(void)
> +static int
> +ftrace_event_open(struct inode *inode, struct file *file,
> +		  const struct seq_operations *seq_ops)
>  {
> -	static struct dentry *d_tracer;
> -	static struct dentry *d_events;
> -
> -	if (d_events)
> -		return d_events;
> -
> -	d_tracer = tracing_init_dentry();
> -	if (!d_tracer)
> -		return NULL;
> +	struct seq_file *m;
> +	int ret;
>  
> -	d_events = debugfs_create_dir("events", d_tracer);
> -	if (!d_events)
> -		pr_warning("Could not create debugfs "
> -			   "'events' directory\n");
> +	ret = seq_open(file, seq_ops);
> +	if (ret < 0)
> +		return ret;
> +	m = file->private_data;
> +	/* copy tr over to seq ops */
> +	m->private = inode->i_private;
>  
> -	return d_events;
> +	return ret;
>  }
>  
>  static int
> @@ -1072,117 +1244,165 @@ ftrace_event_avail_open(struct inode *inode, struct file *file)
>  {
>  	const struct seq_operations *seq_ops = &show_event_seq_ops;
>  
> -	return seq_open(file, seq_ops);
> +	return ftrace_event_open(inode, file, seq_ops);
>  }
>  
>  static int
>  ftrace_event_set_open(struct inode *inode, struct file *file)
>  {
>  	const struct seq_operations *seq_ops = &show_set_event_seq_ops;
> +	struct trace_array *tr = inode->i_private;
>  
>  	if ((file->f_mode & FMODE_WRITE) &&
>  	    (file->f_flags & O_TRUNC))
> -		ftrace_clear_events();
> +		ftrace_clear_events(tr);
> +
> +	return ftrace_event_open(inode, file, seq_ops);
> +}
> +
> +static struct event_subsystem *
> +create_new_subsystem(const char *name)
> +{
> +	struct event_subsystem *system;
> +
> +	/* need to create new entry */
> +	system = kmalloc(sizeof(*system), GFP_KERNEL);
> +	if (!system)
> +		return NULL;
> +
> +	system->ref_count = 1;
> +	system->name = name;
> +
> +	system->filter = NULL;
> +
> +	system->filter = kzalloc(sizeof(struct event_filter), GFP_KERNEL);
> +	if (!system->filter)
> +		goto out_free;
> +
> +	list_add(&system->list, &event_subsystems);
> +
> +	return system;
>  
> -	return seq_open(file, seq_ops);
> + out_free:
> +	kfree(system);
> +	return NULL;
>  }
>  
>  static struct dentry *
> -event_subsystem_dir(const char *name, struct dentry *d_events)
> +event_subsystem_dir(struct trace_array *tr, const char *name,
> +		    struct ftrace_event_file *file, struct dentry *parent)
>  {
> +	struct ftrace_subsystem_dir *dir;
>  	struct event_subsystem *system;
>  	struct dentry *entry;
>  
>  	/* First see if we did not already create this dir */
> -	list_for_each_entry(system, &event_subsystems, list) {
> +	list_for_each_entry(dir, &tr->systems, list) {
> +		system = dir->subsystem;
>  		if (strcmp(system->name, name) == 0) {
> -			system->nr_events++;
> -			return system->entry;
> +			dir->nr_events++;
> +			file->system = dir;
> +			return dir->entry;
>  		}
>  	}
>  
> -	/* need to create new entry */
> -	system = kmalloc(sizeof(*system), GFP_KERNEL);
> -	if (!system) {
> -		pr_warning("No memory to create event subsystem %s\n",
> -			   name);
> -		return d_events;
> +	/* Now see if the system itself exists. */
> +	list_for_each_entry(system, &event_subsystems, list) {
> +		if (strcmp(system->name, name) == 0)
> +			break;
>  	}
> +	/* Reset system variable when not found */
> +	if (&system->list == &event_subsystems)
> +		system = NULL;
>  
> -	system->entry = debugfs_create_dir(name, d_events);
> -	if (!system->entry) {
> -		pr_warning("Could not create event subsystem %s\n",
> -			   name);
> -		kfree(system);
> -		return d_events;
> -	}
> +	dir = kmalloc(sizeof(*dir), GFP_KERNEL);
> +	if (!dir)
> +		goto out_fail;
>  
> -	system->nr_events = 1;
> -	system->ref_count = 1;
> -	system->name = kstrdup(name, GFP_KERNEL);
> -	if (!system->name) {
> -		debugfs_remove(system->entry);
> -		kfree(system);
> -		return d_events;
> +	if (!system) {
> +		system = create_new_subsystem(name);
> +		if (!system)
> +			goto out_free;
> +	} else
> +		__get_system(system);
> +
> +	dir->entry = debugfs_create_dir(name, parent);
> +	if (!dir->entry) {
> +		pr_warning("Failed to create system directory %s\n", name);
> +		__put_system(system);
> +		goto out_free;
>  	}
>  
> -	list_add(&system->list, &event_subsystems);
> -
> -	system->filter = NULL;
> -
> -	system->filter = kzalloc(sizeof(struct event_filter), GFP_KERNEL);
> -	if (!system->filter) {
> -		pr_warning("Could not allocate filter for subsystem "
> -			   "'%s'\n", name);
> -		return system->entry;
> -	}
> +	dir->tr = tr;
> +	dir->ref_count = 1;
> +	dir->nr_events = 1;
> +	dir->subsystem = system;
> +	file->system = dir;
>  
> -	entry = debugfs_create_file("filter", 0644, system->entry, system,
> +	entry = debugfs_create_file("filter", 0644, dir->entry, dir,
>  				    &ftrace_subsystem_filter_fops);
>  	if (!entry) {
>  		kfree(system->filter);
>  		system->filter = NULL;
> -		pr_warning("Could not create debugfs "
> -			   "'%s/filter' entry\n", name);
> +		pr_warning("Could not create debugfs '%s/filter' entry\n", name);
>  	}
>  
> -	trace_create_file("enable", 0644, system->entry, system,
> +	trace_create_file("enable", 0644, dir->entry, dir,
>  			  &ftrace_system_enable_fops);
>  
> -	return system->entry;
> +	list_add(&dir->list, &tr->systems);
> +
> +	return dir->entry;
> +
> + out_free:
> +	kfree(dir);
> + out_fail:
> +	/* Only print this message if failed on memory allocation */
> +	if (!dir || !system)
> +		pr_warning("No memory to create event subsystem %s\n",
> +			   name);
> +	return NULL;
>  }
>  
>  static int
> -event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
> +event_create_dir(struct dentry *parent,
> +		 struct ftrace_event_file *file,
>  		 const struct file_operations *id,
>  		 const struct file_operations *enable,
>  		 const struct file_operations *filter,
>  		 const struct file_operations *format)
>  {
> +	struct ftrace_event_call *call = file->event_call;
> +	struct trace_array *tr = file->tr;
>  	struct list_head *head;
> +	struct dentry *d_events;
>  	int ret;
>  
>  	/*
>  	 * If the trace point header did not define TRACE_SYSTEM
>  	 * then the system would be called "TRACE_SYSTEM".
>  	 */
> -	if (strcmp(call->class->system, TRACE_SYSTEM) != 0)
> -		d_events = event_subsystem_dir(call->class->system, d_events);
> -
> -	call->dir = debugfs_create_dir(call->name, d_events);
> -	if (!call->dir) {
> -		pr_warning("Could not create debugfs "
> -			   "'%s' directory\n", call->name);
> +	if (strcmp(call->class->system, TRACE_SYSTEM) != 0) {
> +		d_events = event_subsystem_dir(tr, call->class->system, file, parent);
> +		if (!d_events)
> +			return -ENOMEM;
> +	} else
> +		d_events = parent;
> +
> +	file->dir = debugfs_create_dir(call->name, d_events);
> +	if (!file->dir) {
> +		pr_warning("Could not create debugfs '%s' directory\n",
> +			   call->name);
>  		return -1;
>  	}
>  
>  	if (call->class->reg && !(call->flags & TRACE_EVENT_FL_IGNORE_ENABLE))
> -		trace_create_file("enable", 0644, call->dir, call,
> +		trace_create_file("enable", 0644, file->dir, file,
>  				  enable);
>  
>  #ifdef CONFIG_PERF_EVENTS
>  	if (call->event.type && call->class->reg)
> -		trace_create_file("id", 0444, call->dir, call,
> +		trace_create_file("id", 0444, file->dir, call,
>  		 		  id);
>  #endif
>  
> @@ -1196,23 +1416,76 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
>  		if (ret < 0) {
>  			pr_warning("Could not initialize trace point"
>  				   " events/%s\n", call->name);
> -			return ret;
> +			return -1;
>  		}
>  	}
> -	trace_create_file("filter", 0644, call->dir, call,
> +	trace_create_file("filter", 0644, file->dir, call,
>  			  filter);
>  
> -	trace_create_file("format", 0444, call->dir, call,
> +	trace_create_file("format", 0444, file->dir, call,
>  			  format);
>  
>  	return 0;
>  }
>  
> +static void remove_subsystem(struct ftrace_subsystem_dir *dir)
> +{
> +	if (!dir)
> +		return;
> +
> +	if (!--dir->nr_events) {
> +		debugfs_remove_recursive(dir->entry);
> +		list_del(&dir->list);
> +		__put_system_dir(dir);
> +	}
> +}
> +
> +static void remove_event_from_tracers(struct ftrace_event_call *call)
> +{
> +	struct ftrace_event_file *file;
> +	struct trace_array *tr;
> +
> +	do_for_each_event_file_safe(tr, file) {
> +
> +		if (file->event_call != call)
> +			continue;
> +
> +		list_del(&file->list);
> +		debugfs_remove_recursive(file->dir);
> +		remove_subsystem(file->system);
> +		kmem_cache_free(file_cachep, file);
> +
> +		/*
> +		 * The do_for_each_event_file_safe() is
> +		 * a double loop. After finding the call for this
> +		 * trace_array, we use break to jump to the next
> +		 * trace_array.
> +		 */
> +		break;
> +	} while_for_each_event_file();
> +}
> +
>  static void event_remove(struct ftrace_event_call *call)
>  {
> -	ftrace_event_enable_disable(call, 0);
> +	struct trace_array *tr;
> +	struct ftrace_event_file *file;
> +
> +	do_for_each_event_file(tr, file) {
> +		if (file->event_call != call)
> +			continue;
> +		ftrace_event_enable_disable(file, 0);
> +		/*
> +		 * The do_for_each_event_file() is
> +		 * a double loop. After finding the call for this
> +		 * trace_array, we use break to jump to the next
> +		 * trace_array.
> +		 */
> +		break;
> +	} while_for_each_event_file();
> +
>  	if (call->event.funcs)
>  		__unregister_ftrace_event(&call->event);
> +	remove_event_from_tracers(call);
>  	list_del(&call->list);
>  }
>  
> @@ -1234,82 +1507,99 @@ static int event_init(struct ftrace_event_call *call)
>  }
>  
>  static int
> -__trace_add_event_call(struct ftrace_event_call *call, struct module *mod,
> -		       const struct file_operations *id,
> -		       const struct file_operations *enable,
> -		       const struct file_operations *filter,
> -		       const struct file_operations *format)
> +__register_event(struct ftrace_event_call *call, struct module *mod)
>  {
> -	struct dentry *d_events;
>  	int ret;
>  
>  	ret = event_init(call);
>  	if (ret < 0)
>  		return ret;
>  
> -	d_events = event_trace_events_dir();
> -	if (!d_events)
> -		return -ENOENT;
> -
> -	ret = event_create_dir(call, d_events, id, enable, filter, format);
> -	if (!ret)
> -		list_add(&call->list, &ftrace_events);
> +	list_add(&call->list, &ftrace_events);
>  	call->mod = mod;
>  
> -	return ret;
> +	return 0;
> +}
> +
> +/* Add an event to a trace directory */
> +static int
> +__trace_add_new_event(struct ftrace_event_call *call,
> +		      struct trace_array *tr,
> +		      const struct file_operations *id,
> +		      const struct file_operations *enable,
> +		      const struct file_operations *filter,
> +		      const struct file_operations *format)
> +{
> +	struct ftrace_event_file *file;
> +
> +	file = kmem_cache_alloc(file_cachep, GFP_TRACE);
> +	if (!file)
> +		return -ENOMEM;
> +
> +	file->event_call = call;
> +	file->tr = tr;
> +	list_add(&file->list, &tr->events);
> +
> +	return event_create_dir(tr->event_dir, file, id, enable, filter, format);
> +}
> +
> +/*
> + * Just create a decriptor for early init. A descriptor is required
> + * for enabling events at boot. We want to enable events before
> + * the filesystem is initialized.
> + */
> +static __init int
> +__trace_early_add_new_event(struct ftrace_event_call *call,
> +			    struct trace_array *tr)
> +{
> +	struct ftrace_event_file *file;
> +
> +	file = kmem_cache_alloc(file_cachep, GFP_TRACE);
> +	if (!file)
> +		return -ENOMEM;
> +
> +	file->event_call = call;
> +	file->tr = tr;
> +	list_add(&file->list, &tr->events);
> +
> +	return 0;
>  }
>  
> +struct ftrace_module_file_ops;
> +static void __add_event_to_tracers(struct ftrace_event_call *call,
> +				   struct ftrace_module_file_ops *file_ops);
> +
>  /* Add an additional event_call dynamically */
>  int trace_add_event_call(struct ftrace_event_call *call)
>  {
>  	int ret;
>  	mutex_lock(&event_mutex);
> -	ret = __trace_add_event_call(call, NULL, &ftrace_event_id_fops,
> -				     &ftrace_enable_fops,
> -				     &ftrace_event_filter_fops,
> -				     &ftrace_event_format_fops);
> -	mutex_unlock(&event_mutex);
> -	return ret;
> -}
>  
> -static void remove_subsystem_dir(const char *name)
> -{
> -	struct event_subsystem *system;
> -
> -	if (strcmp(name, TRACE_SYSTEM) == 0)
> -		return;
> +	ret = __register_event(call, NULL);
> +	if (ret >= 0)
> +		__add_event_to_tracers(call, NULL);
>  
> -	list_for_each_entry(system, &event_subsystems, list) {
> -		if (strcmp(system->name, name) == 0) {
> -			if (!--system->nr_events) {
> -				debugfs_remove_recursive(system->entry);
> -				list_del(&system->list);
> -				__put_system(system);
> -			}
> -			break;
> -		}
> -	}
> +	mutex_unlock(&event_mutex);
> +	return ret;
>  }
>  
>  /*
> - * Must be called under locking both of event_mutex and trace_event_mutex.
> + * Must be called under locking both of event_mutex and trace_event_sem.
>   */
>  static void __trace_remove_event_call(struct ftrace_event_call *call)
>  {
>  	event_remove(call);
>  	trace_destroy_fields(call);
>  	destroy_preds(call);
> -	debugfs_remove_recursive(call->dir);
> -	remove_subsystem_dir(call->class->system);
>  }
>  
>  /* Remove an event_call */
>  void trace_remove_event_call(struct ftrace_event_call *call)
>  {
>  	mutex_lock(&event_mutex);
> -	down_write(&trace_event_mutex);
> +	down_write(&trace_event_sem);
>  	__trace_remove_event_call(call);
> -	up_write(&trace_event_mutex);
> +	up_write(&trace_event_sem);
>  	mutex_unlock(&event_mutex);
>  }
>  
> @@ -1336,6 +1626,26 @@ struct ftrace_module_file_ops {
>  };
>  
>  static struct ftrace_module_file_ops *
> +find_ftrace_file_ops(struct ftrace_module_file_ops *file_ops, struct module *mod)
> +{
> +	/*
> +	 * As event_calls are added in groups by module,
> +	 * when we find one file_ops, we don't need to search for
> +	 * each call in that module, as the rest should be the
> +	 * same. Only search for a new one if the last one did
> +	 * not match.
> +	 */
> +	if (file_ops && mod == file_ops->mod)
> +		return file_ops;
> +
> +	list_for_each_entry(file_ops, &ftrace_module_file_list, list) {
> +		if (file_ops->mod == mod)
> +			return file_ops;
> +	}
> +	return NULL;
> +}
> +
> +static struct ftrace_module_file_ops *
>  trace_create_file_ops(struct module *mod)
>  {
>  	struct ftrace_module_file_ops *file_ops;
> @@ -1386,9 +1696,8 @@ static void trace_module_add_events(struct module *mod)
>  		return;
>  
>  	for_each_event(call, start, end) {
> -		__trace_add_event_call(*call, mod,
> -				       &file_ops->id, &file_ops->enable,
> -				       &file_ops->filter, &file_ops->format);
> +		__register_event(*call, mod);
> +		__add_event_to_tracers(*call, file_ops);
>  	}
>  }
>  
> @@ -1396,12 +1705,13 @@ static void trace_module_remove_events(struct module *mod)
>  {
>  	struct ftrace_module_file_ops *file_ops;
>  	struct ftrace_event_call *call, *p;
> -	bool found = false;
> +	bool clear_trace = false;
>  
> -	down_write(&trace_event_mutex);
> +	down_write(&trace_event_sem);
>  	list_for_each_entry_safe(call, p, &ftrace_events, list) {
>  		if (call->mod == mod) {
> -			found = true;
> +			if (call->flags & TRACE_EVENT_FL_WAS_ENABLED)
> +				clear_trace = true;
>  			__trace_remove_event_call(call);
>  		}
>  	}
> @@ -1415,14 +1725,18 @@ static void trace_module_remove_events(struct module *mod)
>  		list_del(&file_ops->list);
>  		kfree(file_ops);
>  	}
> +	up_write(&trace_event_sem);
>  
>  	/*
>  	 * It is safest to reset the ring buffer if the module being unloaded
> -	 * registered any events.
> +	 * registered any events that were used. The only worry is if
> +	 * a new module gets loaded, and takes on the same id as the events
> +	 * of this module. When printing out the buffer, traced events left
> +	 * over from this module may be passed to the new module events and
> +	 * unexpected results may occur.
>  	 */
> -	if (found)
> -		tracing_reset_current_online_cpus();
> -	up_write(&trace_event_mutex);
> +	if (clear_trace)
> +		tracing_reset_all_online_cpus();
>  }
>  
>  static int trace_module_notify(struct notifier_block *self,
> @@ -1443,36 +1757,575 @@ static int trace_module_notify(struct notifier_block *self,
>  
>  	return 0;
>  }
> +
> +static int
> +__trace_add_new_mod_event(struct ftrace_event_call *call,
> +			  struct trace_array *tr,
> +			  struct ftrace_module_file_ops *file_ops)
> +{
> +	return __trace_add_new_event(call, tr,
> +				     &file_ops->id, &file_ops->enable,
> +				     &file_ops->filter, &file_ops->format);
> +}
> +
>  #else
> -static int trace_module_notify(struct notifier_block *self,
> -			       unsigned long val, void *data)
> +static inline struct ftrace_module_file_ops *
> +find_ftrace_file_ops(struct ftrace_module_file_ops *file_ops, struct module *mod)
> +{
> +	return NULL;
> +}
> +static inline int trace_module_notify(struct notifier_block *self,
> +				      unsigned long val, void *data)
>  {
>  	return 0;
>  }
> +static inline int
> +__trace_add_new_mod_event(struct ftrace_event_call *call,
> +			  struct trace_array *tr,
> +			  struct ftrace_module_file_ops *file_ops)
> +{
> +	return -ENODEV;
> +}
>  #endif /* CONFIG_MODULES */
>  
> -static struct notifier_block trace_module_nb = {
> -	.notifier_call = trace_module_notify,
> -	.priority = 0,
> -};
> -
> -extern struct ftrace_event_call *__start_ftrace_events[];
> -extern struct ftrace_event_call *__stop_ftrace_events[];
> -
> -static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
> -
> -static __init int setup_trace_event(char *str)
> +/* Create a new event directory structure for a trace directory. */
> +static void
> +__trace_add_event_dirs(struct trace_array *tr)
>  {
> -	strlcpy(bootup_event_buf, str, COMMAND_LINE_SIZE);
> -	ring_buffer_expanded = 1;
> -	tracing_selftest_disabled = 1;
> +	struct ftrace_module_file_ops *file_ops = NULL;
> +	struct ftrace_event_call *call;
> +	int ret;
> +
> +	list_for_each_entry(call, &ftrace_events, list) {
> +		if (call->mod) {
> +			/*
> +			 * Directories for events by modules need to
> +			 * keep module ref counts when opened (as we don't
> +			 * want the module to disappear when reading one
> +			 * of these files). The file_ops keep account of
> +			 * the module ref count.
> +			 */
> +			file_ops = find_ftrace_file_ops(file_ops, call->mod);
> +			if (!file_ops)
> +				continue; /* Warn? */
> +			ret = __trace_add_new_mod_event(call, tr, file_ops);
> +			if (ret < 0)
> +				pr_warning("Could not create directory for event %s\n",
> +					   call->name);
> +			continue;
> +		}
> +		ret = __trace_add_new_event(call, tr,
> +					    &ftrace_event_id_fops,
> +					    &ftrace_enable_fops,
> +					    &ftrace_event_filter_fops,
> +					    &ftrace_event_format_fops);
> +		if (ret < 0)
> +			pr_warning("Could not create directory for event %s\n",
> +				   call->name);
> +	}
> +}
> +
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +
> +/* Avoid typos */
> +#define ENABLE_EVENT_STR	"enable_event"
> +#define DISABLE_EVENT_STR	"disable_event"
> +
> +struct event_probe_data {
> +	struct ftrace_event_file	*file;
> +	unsigned long			count;
> +	int				ref;
> +	bool				enable;
> +};
> +
> +static struct ftrace_event_file *
> +find_event_file(struct trace_array *tr, const char *system,  const char *event)
> +{
> +	struct ftrace_event_file *file;
> +	struct ftrace_event_call *call;
> +
> +	list_for_each_entry(file, &tr->events, list) {
> +
> +		call = file->event_call;
> +
> +		if (!call->name || !call->class || !call->class->reg)
> +			continue;
> +
> +		if (call->flags & TRACE_EVENT_FL_IGNORE_ENABLE)
> +			continue;
> +
> +		if (strcmp(event, call->name) == 0 &&
> +		    strcmp(system, call->class->system) == 0)
> +			return file;
> +	}
> +	return NULL;
> +}
> +
> +static void
> +event_enable_probe(unsigned long ip, unsigned long parent_ip, void **_data)
> +{
> +	struct event_probe_data **pdata = (struct event_probe_data **)_data;
> +	struct event_probe_data *data = *pdata;
> +
> +	if (!data)
> +		return;
> +
> +	if (data->enable)
> +		clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &data->file->flags);
> +	else
> +		set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &data->file->flags);
> +}
> +
> +static void
> +event_enable_count_probe(unsigned long ip, unsigned long parent_ip, void **_data)
> +{
> +	struct event_probe_data **pdata = (struct event_probe_data **)_data;
> +	struct event_probe_data *data = *pdata;
> +
> +	if (!data)
> +		return;
> +
> +	if (!data->count)
> +		return;
> +
> +	/* Skip if the event is in a state we want to switch to */
> +	if (data->enable == !(data->file->flags & FTRACE_EVENT_FL_SOFT_DISABLED))
> +		return;
> +
> +	if (data->count != -1)
> +		(data->count)--;
> +
> +	event_enable_probe(ip, parent_ip, _data);
> +}
> +
> +static int
> +event_enable_print(struct seq_file *m, unsigned long ip,
> +		      struct ftrace_probe_ops *ops, void *_data)
> +{
> +	struct event_probe_data *data = _data;
> +
> +	seq_printf(m, "%ps:", (void *)ip);
> +
> +	seq_printf(m, "%s:%s:%s",
> +		   data->enable ? ENABLE_EVENT_STR : DISABLE_EVENT_STR,
> +		   data->file->event_call->class->system,
> +		   data->file->event_call->name);
> +
> +	if (data->count == -1)
> +		seq_printf(m, ":unlimited\n");
> +	else
> +		seq_printf(m, ":count=%ld\n", data->count);
> +
> +	return 0;
> +}
> +
> +static int
> +event_enable_init(struct ftrace_probe_ops *ops, unsigned long ip,
> +		  void **_data)
> +{
> +	struct event_probe_data **pdata = (struct event_probe_data **)_data;
> +	struct event_probe_data *data = *pdata;
> +
> +	data->ref++;
> +	return 0;
> +}
> +
> +static void
> +event_enable_free(struct ftrace_probe_ops *ops, unsigned long ip,
> +		  void **_data)
> +{
> +	struct event_probe_data **pdata = (struct event_probe_data **)_data;
> +	struct event_probe_data *data = *pdata;
> +
> +	if (WARN_ON_ONCE(data->ref <= 0))
> +		return;
> +
> +	data->ref--;
> +	if (!data->ref) {
> +		/* Remove the SOFT_MODE flag */
> +		__ftrace_event_enable_disable(data->file, 0, 1);
> +		module_put(data->file->event_call->mod);
> +		kfree(data);
> +	}
> +	*pdata = NULL;
> +}
> +
> +static struct ftrace_probe_ops event_enable_probe_ops = {
> +	.func			= event_enable_probe,
> +	.print			= event_enable_print,
> +	.init			= event_enable_init,
> +	.free			= event_enable_free,
> +};
> +
> +static struct ftrace_probe_ops event_enable_count_probe_ops = {
> +	.func			= event_enable_count_probe,
> +	.print			= event_enable_print,
> +	.init			= event_enable_init,
> +	.free			= event_enable_free,
> +};
> +
> +static struct ftrace_probe_ops event_disable_probe_ops = {
> +	.func			= event_enable_probe,
> +	.print			= event_enable_print,
> +	.init			= event_enable_init,
> +	.free			= event_enable_free,
> +};
> +
> +static struct ftrace_probe_ops event_disable_count_probe_ops = {
> +	.func			= event_enable_count_probe,
> +	.print			= event_enable_print,
> +	.init			= event_enable_init,
> +	.free			= event_enable_free,
> +};
> +
> +static int
> +event_enable_func(struct ftrace_hash *hash,
> +		  char *glob, char *cmd, char *param, int enabled)
> +{
> +	struct trace_array *tr = top_trace_array();
> +	struct ftrace_event_file *file;
> +	struct ftrace_probe_ops *ops;
> +	struct event_probe_data *data;
> +	const char *system;
> +	const char *event;
> +	char *number;
> +	bool enable;
> +	int ret;
> +
> +	/* hash funcs only work with set_ftrace_filter */
> +	if (!enabled)
> +		return -EINVAL;
> +
> +	if (!param)
> +		return -EINVAL;
> +
> +	system = strsep(&param, ":");
> +	if (!param)
> +		return -EINVAL;
> +
> +	event = strsep(&param, ":");
> +
> +	mutex_lock(&event_mutex);
> +
> +	ret = -EINVAL;
> +	file = find_event_file(tr, system, event);
> +	if (!file)
> +		goto out;
> +
> +	enable = strcmp(cmd, ENABLE_EVENT_STR) == 0;
> +
> +	if (enable)
> +		ops = param ? &event_enable_count_probe_ops : &event_enable_probe_ops;
> +	else
> +		ops = param ? &event_disable_count_probe_ops : &event_disable_probe_ops;
> +
> +	if (glob[0] == '!') {
> +		unregister_ftrace_function_probe_func(glob+1, ops);
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	ret = -ENOMEM;
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		goto out;
> +
> +	data->enable = enable;
> +	data->count = -1;
> +	data->file = file;
> +
> +	if (!param)
> +		goto out_reg;
> +
> +	number = strsep(&param, ":");
> +
> +	ret = -EINVAL;
> +	if (!strlen(number))
> +		goto out_free;
> +
> +	/*
> +	 * We use the callback data field (which is a pointer)
> +	 * as our counter.
> +	 */
> +	ret = kstrtoul(number, 0, &data->count);
> +	if (ret)
> +		goto out_free;
> +
> + out_reg:
> +	/* Don't let event modules unload while probe registered */
> +	ret = try_module_get(file->event_call->mod);
> +	if (!ret)
> +		goto out_free;
> +
> +	ret = __ftrace_event_enable_disable(file, 1, 1);
> +	if (ret < 0)
> +		goto out_put;
> +	ret = register_ftrace_function_probe(glob, ops, data);
> +	if (!ret)
> +		goto out_disable;
> + out:
> +	mutex_unlock(&event_mutex);
> +	return ret;
> +
> + out_disable:
> +	__ftrace_event_enable_disable(file, 0, 1);
> + out_put:
> +	module_put(file->event_call->mod);
> + out_free:
> +	kfree(data);
> +	goto out;
> +}
> +
> +static struct ftrace_func_command event_enable_cmd = {
> +	.name			= ENABLE_EVENT_STR,
> +	.func			= event_enable_func,
> +};
> +
> +static struct ftrace_func_command event_disable_cmd = {
> +	.name			= DISABLE_EVENT_STR,
> +	.func			= event_enable_func,
> +};
> +
> +static __init int register_event_cmds(void)
> +{
> +	int ret;
> +
> +	ret = register_ftrace_command(&event_enable_cmd);
> +	if (WARN_ON(ret < 0))
> +		return ret;
> +	ret = register_ftrace_command(&event_disable_cmd);
> +	if (WARN_ON(ret < 0))
> +		unregister_ftrace_command(&event_enable_cmd);
> +	return ret;
> +}
> +#else
> +static inline int register_event_cmds(void) { return 0; }
> +#endif /* CONFIG_DYNAMIC_FTRACE */
> +
> +/*
> + * The top level array has already had its ftrace_event_file
> + * descriptors created in order to allow for early events to
> + * be recorded. This function is called after the debugfs has been
> + * initialized, and we now have to create the files associated
> + * to the events.
> + */
> +static __init void
> +__trace_early_add_event_dirs(struct trace_array *tr)
> +{
> +	struct ftrace_event_file *file;
> +	int ret;
> +
> +
> +	list_for_each_entry(file, &tr->events, list) {
> +		ret = event_create_dir(tr->event_dir, file,
> +				       &ftrace_event_id_fops,
> +				       &ftrace_enable_fops,
> +				       &ftrace_event_filter_fops,
> +				       &ftrace_event_format_fops);
> +		if (ret < 0)
> +			pr_warning("Could not create directory for event %s\n",
> +				   file->event_call->name);
> +	}
> +}
> +
> +/*
> + * For early boot up, the top trace array requires to have
> + * a list of events that can be enabled. This must be done before
> + * the filesystem is set up in order to allow events to be traced
> + * early.
> + */
> +static __init void
> +__trace_early_add_events(struct trace_array *tr)
> +{
> +	struct ftrace_event_call *call;
> +	int ret;
> +
> +	list_for_each_entry(call, &ftrace_events, list) {
> +		/* Early boot up should not have any modules loaded */
> +		if (WARN_ON_ONCE(call->mod))
> +			continue;
> +
> +		ret = __trace_early_add_new_event(call, tr);
> +		if (ret < 0)
> +			pr_warning("Could not create early event %s\n",
> +				   call->name);
> +	}
> +}
> +
> +/* Remove the event directory structure for a trace directory. */
> +static void
> +__trace_remove_event_dirs(struct trace_array *tr)
> +{
> +	struct ftrace_event_file *file, *next;
> +
> +	list_for_each_entry_safe(file, next, &tr->events, list) {
> +		list_del(&file->list);
> +		debugfs_remove_recursive(file->dir);
> +		remove_subsystem(file->system);
> +		kmem_cache_free(file_cachep, file);
> +	}
> +}
> +
> +static void
> +__add_event_to_tracers(struct ftrace_event_call *call,
> +		       struct ftrace_module_file_ops *file_ops)
> +{
> +	struct trace_array *tr;
> +
> +	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
> +		if (file_ops)
> +			__trace_add_new_mod_event(call, tr, file_ops);
> +		else
> +			__trace_add_new_event(call, tr,
> +					      &ftrace_event_id_fops,
> +					      &ftrace_enable_fops,
> +					      &ftrace_event_filter_fops,
> +					      &ftrace_event_format_fops);
> +	}
> +}
> +
> +static struct notifier_block trace_module_nb = {
> +	.notifier_call = trace_module_notify,
> +	.priority = 0,
> +};
> +
> +extern struct ftrace_event_call *__start_ftrace_events[];
> +extern struct ftrace_event_call *__stop_ftrace_events[];
> +
> +static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
> +
> +static __init int setup_trace_event(char *str)
> +{
> +	strlcpy(bootup_event_buf, str, COMMAND_LINE_SIZE);
> +	ring_buffer_expanded = true;
> +	tracing_selftest_disabled = true;
>  
>  	return 1;
>  }
>  __setup("trace_event=", setup_trace_event);
>  
> +/* Expects to have event_mutex held when called */
> +static int
> +create_event_toplevel_files(struct dentry *parent, struct trace_array *tr)
> +{
> +	struct dentry *d_events;
> +	struct dentry *entry;
> +
> +	entry = debugfs_create_file("set_event", 0644, parent,
> +				    tr, &ftrace_set_event_fops);
> +	if (!entry) {
> +		pr_warning("Could not create debugfs 'set_event' entry\n");
> +		return -ENOMEM;
> +	}
> +
> +	d_events = debugfs_create_dir("events", parent);
> +	if (!d_events) {
> +		pr_warning("Could not create debugfs 'events' directory\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* ring buffer internal formats */
> +	trace_create_file("header_page", 0444, d_events,
> +			  ring_buffer_print_page_header,
> +			  &ftrace_show_header_fops);
> +
> +	trace_create_file("header_event", 0444, d_events,
> +			  ring_buffer_print_entry_header,
> +			  &ftrace_show_header_fops);
> +
> +	trace_create_file("enable", 0644, d_events,
> +			  tr, &ftrace_tr_enable_fops);
> +
> +	tr->event_dir = d_events;
> +
> +	return 0;
> +}
> +
> +/**
> + * event_trace_add_tracer - add a instance of a trace_array to events
> + * @parent: The parent dentry to place the files/directories for events in
> + * @tr: The trace array associated with these events
> + *
> + * When a new instance is created, it needs to set up its events
> + * directory, as well as other files associated with events. It also
> + * creates the event hierachry in the @parent/events directory.
> + *
> + * Returns 0 on success.
> + */
> +int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr)
> +{
> +	int ret;
> +
> +	mutex_lock(&event_mutex);
> +
> +	ret = create_event_toplevel_files(parent, tr);
> +	if (ret)
> +		goto out_unlock;
> +
> +	down_write(&trace_event_sem);
> +	__trace_add_event_dirs(tr);
> +	up_write(&trace_event_sem);
> +
> + out_unlock:
> +	mutex_unlock(&event_mutex);
> +
> +	return ret;
> +}
> +
> +/*
> + * The top trace array already had its file descriptors created.
> + * Now the files themselves need to be created.
> + */
> +static __init int
> +early_event_add_tracer(struct dentry *parent, struct trace_array *tr)
> +{
> +	int ret;
> +
> +	mutex_lock(&event_mutex);
> +
> +	ret = create_event_toplevel_files(parent, tr);
> +	if (ret)
> +		goto out_unlock;
> +
> +	down_write(&trace_event_sem);
> +	__trace_early_add_event_dirs(tr);
> +	up_write(&trace_event_sem);
> +
> + out_unlock:
> +	mutex_unlock(&event_mutex);
> +
> +	return ret;
> +}
> +
> +int event_trace_del_tracer(struct trace_array *tr)
> +{
> +	/* Disable any running events */
> +	__ftrace_set_clr_event(tr, NULL, NULL, NULL, 0);
> +
> +	mutex_lock(&event_mutex);
> +
> +	down_write(&trace_event_sem);
> +	__trace_remove_event_dirs(tr);
> +	debugfs_remove_recursive(tr->event_dir);
> +	up_write(&trace_event_sem);
> +
> +	tr->event_dir = NULL;
> +
> +	mutex_unlock(&event_mutex);
> +
> +	return 0;
> +}
> +
> +static __init int event_trace_memsetup(void)
> +{
> +	field_cachep = KMEM_CACHE(ftrace_event_field, SLAB_PANIC);
> +	file_cachep = KMEM_CACHE(ftrace_event_file, SLAB_PANIC);
> +	return 0;
> +}
> +
>  static __init int event_trace_enable(void)
>  {
> +	struct trace_array *tr = top_trace_array();
>  	struct ftrace_event_call **iter, *call;
>  	char *buf = bootup_event_buf;
>  	char *token;
> @@ -1486,6 +2339,14 @@ static __init int event_trace_enable(void)
>  			list_add(&call->list, &ftrace_events);
>  	}
>  
> +	/*
> +	 * We need the top trace array to have a working set of trace
> +	 * points at early init, before the debug files and directories
> +	 * are created. Create the file entries now, and attach them
> +	 * to the actual file dentries later.
> +	 */
> +	__trace_early_add_events(tr);
> +
>  	while (true) {
>  		token = strsep(&buf, ",");
>  
> @@ -1494,73 +2355,43 @@ static __init int event_trace_enable(void)
>  		if (!*token)
>  			continue;
>  
> -		ret = ftrace_set_clr_event(token, 1);
> +		ret = ftrace_set_clr_event(tr, token, 1);
>  		if (ret)
>  			pr_warn("Failed to enable trace event: %s\n", token);
>  	}
>  
>  	trace_printk_start_comm();
>  
> +	register_event_cmds();
> +
>  	return 0;
>  }
>  
>  static __init int event_trace_init(void)
>  {
> -	struct ftrace_event_call *call;
> +	struct trace_array *tr;
>  	struct dentry *d_tracer;
>  	struct dentry *entry;
> -	struct dentry *d_events;
>  	int ret;
>  
> +	tr = top_trace_array();
> +
>  	d_tracer = tracing_init_dentry();
>  	if (!d_tracer)
>  		return 0;
>  
>  	entry = debugfs_create_file("available_events", 0444, d_tracer,
> -				    NULL, &ftrace_avail_fops);
> +				    tr, &ftrace_avail_fops);
>  	if (!entry)
>  		pr_warning("Could not create debugfs "
>  			   "'available_events' entry\n");
>  
> -	entry = debugfs_create_file("set_event", 0644, d_tracer,
> -				    NULL, &ftrace_set_event_fops);
> -	if (!entry)
> -		pr_warning("Could not create debugfs "
> -			   "'set_event' entry\n");
> -
> -	d_events = event_trace_events_dir();
> -	if (!d_events)
> -		return 0;
> -
> -	/* ring buffer internal formats */
> -	trace_create_file("header_page", 0444, d_events,
> -			  ring_buffer_print_page_header,
> -			  &ftrace_show_header_fops);
> -
> -	trace_create_file("header_event", 0444, d_events,
> -			  ring_buffer_print_entry_header,
> -			  &ftrace_show_header_fops);
> -
> -	trace_create_file("enable", 0644, d_events,
> -			  NULL, &ftrace_system_enable_fops);
> -
>  	if (trace_define_common_fields())
>  		pr_warning("tracing: Failed to allocate common fields");
>  
> -	/*
> -	 * Early initialization already enabled ftrace event.
> -	 * Now it's only necessary to create the event directory.
> -	 */
> -	list_for_each_entry(call, &ftrace_events, list) {
> -
> -		ret = event_create_dir(call, d_events,
> -				       &ftrace_event_id_fops,
> -				       &ftrace_enable_fops,
> -				       &ftrace_event_filter_fops,
> -				       &ftrace_event_format_fops);
> -		if (ret < 0)
> -			event_remove(call);
> -	}
> +	ret = early_event_add_tracer(d_tracer, tr);
> +	if (ret)
> +		return ret;
>  
>  	ret = register_module_notifier(&trace_module_nb);
>  	if (ret)
> @@ -1568,6 +2399,7 @@ static __init int event_trace_init(void)
>  
>  	return 0;
>  }
> +early_initcall(event_trace_memsetup);
>  core_initcall(event_trace_enable);
>  fs_initcall(event_trace_init);
>  
> @@ -1627,13 +2459,20 @@ static __init void event_test_stuff(void)
>   */
>  static __init void event_trace_self_tests(void)
>  {
> +	struct ftrace_subsystem_dir *dir;
> +	struct ftrace_event_file *file;
>  	struct ftrace_event_call *call;
>  	struct event_subsystem *system;
> +	struct trace_array *tr;
>  	int ret;
>  
> +	tr = top_trace_array();
> +
>  	pr_info("Running tests on trace events:\n");
>  
> -	list_for_each_entry(call, &ftrace_events, list) {
> +	list_for_each_entry(file, &tr->events, list) {
> +
> +		call = file->event_call;
>  
>  		/* Only test those that have a probe */
>  		if (!call->class || !call->class->probe)
> @@ -1657,15 +2496,15 @@ static __init void event_trace_self_tests(void)
>  		 * If an event is already enabled, someone is using
>  		 * it and the self test should not be on.
>  		 */
> -		if (call->flags & TRACE_EVENT_FL_ENABLED) {
> +		if (file->flags & FTRACE_EVENT_FL_ENABLED) {
>  			pr_warning("Enabled event during self test!\n");
>  			WARN_ON_ONCE(1);
>  			continue;
>  		}
>  
> -		ftrace_event_enable_disable(call, 1);
> +		ftrace_event_enable_disable(file, 1);
>  		event_test_stuff();
> -		ftrace_event_enable_disable(call, 0);
> +		ftrace_event_enable_disable(file, 0);
>  
>  		pr_cont("OK\n");
>  	}
> @@ -1674,7 +2513,9 @@ static __init void event_trace_self_tests(void)
>  
>  	pr_info("Running tests on trace event systems:\n");
>  
> -	list_for_each_entry(system, &event_subsystems, list) {
> +	list_for_each_entry(dir, &tr->systems, list) {
> +
> +		system = dir->subsystem;
>  
>  		/* the ftrace system is special, skip it */
>  		if (strcmp(system->name, "ftrace") == 0)
> @@ -1682,7 +2523,7 @@ static __init void event_trace_self_tests(void)
>  
>  		pr_info("Testing event system %s: ", system->name);
>  
> -		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 1);
> +		ret = __ftrace_set_clr_event(tr, NULL, system->name, NULL, 1);
>  		if (WARN_ON_ONCE(ret)) {
>  			pr_warning("error enabling system %s\n",
>  				   system->name);
> @@ -1691,7 +2532,7 @@ static __init void event_trace_self_tests(void)
>  
>  		event_test_stuff();
>  
> -		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 0);
> +		ret = __ftrace_set_clr_event(tr, NULL, system->name, NULL, 0);
>  		if (WARN_ON_ONCE(ret)) {
>  			pr_warning("error disabling system %s\n",
>  				   system->name);
> @@ -1706,7 +2547,7 @@ static __init void event_trace_self_tests(void)
>  	pr_info("Running tests on all trace events:\n");
>  	pr_info("Testing all events: ");
>  
> -	ret = __ftrace_set_clr_event(NULL, NULL, NULL, 1);
> +	ret = __ftrace_set_clr_event(tr, NULL, NULL, NULL, 1);
>  	if (WARN_ON_ONCE(ret)) {
>  		pr_warning("error enabling all events\n");
>  		return;
> @@ -1715,7 +2556,7 @@ static __init void event_trace_self_tests(void)
>  	event_test_stuff();
>  
>  	/* reset sysname */
> -	ret = __ftrace_set_clr_event(NULL, NULL, NULL, 0);
> +	ret = __ftrace_set_clr_event(tr, NULL, NULL, NULL, 0);
>  	if (WARN_ON_ONCE(ret)) {
>  		pr_warning("error disabling all events\n");
>  		return;
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index e5b0ca8..a636117 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -658,33 +658,6 @@ void print_subsystem_event_filter(struct event_subsystem *system,
>  	mutex_unlock(&event_mutex);
>  }
>  
> -static struct ftrace_event_field *
> -__find_event_field(struct list_head *head, char *name)
> -{
> -	struct ftrace_event_field *field;
> -
> -	list_for_each_entry(field, head, link) {
> -		if (!strcmp(field->name, name))
> -			return field;
> -	}
> -
> -	return NULL;
> -}
> -
> -static struct ftrace_event_field *
> -find_event_field(struct ftrace_event_call *call, char *name)
> -{
> -	struct ftrace_event_field *field;
> -	struct list_head *head;
> -
> -	field = __find_event_field(&ftrace_common_fields, name);
> -	if (field)
> -		return field;
> -
> -	head = trace_get_fields(call);
> -	return __find_event_field(head, name);
> -}
> -
>  static int __alloc_pred_stack(struct pred_stack *stack, int n_preds)
>  {
>  	stack->preds = kcalloc(n_preds + 1, sizeof(*stack->preds), GFP_KERNEL);
> @@ -1337,7 +1310,7 @@ static struct filter_pred *create_pred(struct filter_parse_state *ps,
>  		return NULL;
>  	}
>  
> -	field = find_event_field(call, operand1);
> +	field = trace_find_event_field(call, operand1);
>  	if (!field) {
>  		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
>  		return NULL;
> @@ -1907,16 +1880,17 @@ out_unlock:
>  	return err;
>  }
>  
> -int apply_subsystem_event_filter(struct event_subsystem *system,
> +int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
>  				 char *filter_string)
>  {
> +	struct event_subsystem *system = dir->subsystem;
>  	struct event_filter *filter;
>  	int err = 0;
>  
>  	mutex_lock(&event_mutex);
>  
>  	/* Make sure the system still has events */
> -	if (!system->nr_events) {
> +	if (!dir->nr_events) {
>  		err = -ENODEV;
>  		goto out_unlock;
>  	}
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index e039906..d21a746 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -129,7 +129,7 @@ static void __always_unused ____ftrace_check_##name(void)		\
>  
>  #undef FTRACE_ENTRY
>  #define FTRACE_ENTRY(name, struct_name, id, tstruct, print, filter)	\
> -int									\
> +static int __init							\
>  ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
>  {									\
>  	struct struct_name field;					\
> @@ -168,7 +168,7 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
>  #define FTRACE_ENTRY_REG(call, struct_name, etype, tstruct, print, filter,\
>  			 regfn)						\
>  									\
> -struct ftrace_event_class event_class_ftrace_##call = {			\
> +struct ftrace_event_class __refdata event_class_ftrace_##call = {	\
>  	.system			= __stringify(TRACE_SYSTEM),		\
>  	.define_fields		= ftrace_define_fields_##call,		\
>  	.fields			= LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index 6011525..c4d6d71 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -28,7 +28,7 @@ static void tracing_stop_function_trace(void);
>  static int function_trace_init(struct trace_array *tr)
>  {
>  	func_trace = tr;
> -	tr->cpu = get_cpu();
> +	tr->trace_buffer.cpu = get_cpu();
>  	put_cpu();
>  
>  	tracing_start_cmdline_record();
> @@ -44,7 +44,7 @@ static void function_trace_reset(struct trace_array *tr)
>  
>  static void function_trace_start(struct trace_array *tr)
>  {
> -	tracing_reset_online_cpus(tr);
> +	tracing_reset_online_cpus(&tr->trace_buffer);
>  }
>  
>  /* Our option */
> @@ -76,7 +76,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip,
>  		goto out;
>  
>  	cpu = smp_processor_id();
> -	data = tr->data[cpu];
> +	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
>  	if (!atomic_read(&data->disabled)) {
>  		local_save_flags(flags);
>  		trace_function(tr, ip, parent_ip, flags, pc);
> @@ -107,7 +107,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
>  	 */
>  	local_irq_save(flags);
>  	cpu = raw_smp_processor_id();
> -	data = tr->data[cpu];
> +	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
>  	disabled = atomic_inc_return(&data->disabled);
>  
>  	if (likely(disabled == 1)) {
> @@ -214,66 +214,89 @@ static struct tracer function_trace __read_mostly =
>  };
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
> -static void
> -ftrace_traceon(unsigned long ip, unsigned long parent_ip, void **data)
> +static int update_count(void **data)
>  {
> -	long *count = (long *)data;
> -
> -	if (tracing_is_on())
> -		return;
> +	unsigned long *count = (long *)data;
>  
>  	if (!*count)
> -		return;
> +		return 0;
>  
>  	if (*count != -1)
>  		(*count)--;
>  
> -	tracing_on();
> +	return 1;
>  }
>  
>  static void
> -ftrace_traceoff(unsigned long ip, unsigned long parent_ip, void **data)
> +ftrace_traceon_count(unsigned long ip, unsigned long parent_ip, void **data)
>  {
> -	long *count = (long *)data;
> +	if (tracing_is_on())
> +		return;
> +
> +	if (update_count(data))
> +		tracing_on();
> +}
>  
> +static void
> +ftrace_traceoff_count(unsigned long ip, unsigned long parent_ip, void **data)
> +{
>  	if (!tracing_is_on())
>  		return;
>  
> -	if (!*count)
> +	if (update_count(data))
> +		tracing_off();
> +}
> +
> +static void
> +ftrace_traceon(unsigned long ip, unsigned long parent_ip, void **data)
> +{
> +	if (tracing_is_on())
>  		return;
>  
> -	if (*count != -1)
> -		(*count)--;
> +	tracing_on();
> +}
> +
> +static void
> +ftrace_traceoff(unsigned long ip, unsigned long parent_ip, void **data)
> +{
> +	if (!tracing_is_on())
> +		return;
>  
>  	tracing_off();
>  }
>  
> -static int
> -ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
> -			 struct ftrace_probe_ops *ops, void *data);
> +/*
> + * Skip 4:
> + *   ftrace_stacktrace()
> + *   function_trace_probe_call()
> + *   ftrace_ops_list_func()
> + *   ftrace_call()
> + */
> +#define STACK_SKIP 4
>  
> -static struct ftrace_probe_ops traceon_probe_ops = {
> -	.func			= ftrace_traceon,
> -	.print			= ftrace_trace_onoff_print,
> -};
> +static void
> +ftrace_stacktrace(unsigned long ip, unsigned long parent_ip, void **data)
> +{
> +	trace_dump_stack(STACK_SKIP);
> +}
>  
> -static struct ftrace_probe_ops traceoff_probe_ops = {
> -	.func			= ftrace_traceoff,
> -	.print			= ftrace_trace_onoff_print,
> -};
> +static void
> +ftrace_stacktrace_count(unsigned long ip, unsigned long parent_ip, void **data)
> +{
> +	if (!tracing_is_on())
> +		return;
> +
> +	if (update_count(data))
> +		trace_dump_stack(STACK_SKIP);
> +}
>  
>  static int
> -ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
> -			 struct ftrace_probe_ops *ops, void *data)
> +ftrace_probe_print(const char *name, struct seq_file *m,
> +		   unsigned long ip, void *data)
>  {
>  	long count = (long)data;
>  
> -	seq_printf(m, "%ps:", (void *)ip);
> -
> -	if (ops == &traceon_probe_ops)
> -		seq_printf(m, "traceon");
> -	else
> -		seq_printf(m, "traceoff");
> +	seq_printf(m, "%ps:%s", (void *)ip, name);
>  
>  	if (count == -1)
>  		seq_printf(m, ":unlimited\n");
> @@ -284,26 +307,61 @@ ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
>  }
>  
>  static int
> -ftrace_trace_onoff_unreg(char *glob, char *cmd, char *param)
> +ftrace_traceon_print(struct seq_file *m, unsigned long ip,
> +			 struct ftrace_probe_ops *ops, void *data)
>  {
> -	struct ftrace_probe_ops *ops;
> -
> -	/* we register both traceon and traceoff to this callback */
> -	if (strcmp(cmd, "traceon") == 0)
> -		ops = &traceon_probe_ops;
> -	else
> -		ops = &traceoff_probe_ops;
> +	return ftrace_probe_print("traceon", m, ip, data);
> +}
>  
> -	unregister_ftrace_function_probe_func(glob, ops);
> +static int
> +ftrace_traceoff_print(struct seq_file *m, unsigned long ip,
> +			 struct ftrace_probe_ops *ops, void *data)
> +{
> +	return ftrace_probe_print("traceoff", m, ip, data);
> +}
>  
> -	return 0;
> +static int
> +ftrace_stacktrace_print(struct seq_file *m, unsigned long ip,
> +			struct ftrace_probe_ops *ops, void *data)
> +{
> +	return ftrace_probe_print("stacktrace", m, ip, data);
>  }
>  
> +static struct ftrace_probe_ops traceon_count_probe_ops = {
> +	.func			= ftrace_traceon_count,
> +	.print			= ftrace_traceon_print,
> +};
> +
> +static struct ftrace_probe_ops traceoff_count_probe_ops = {
> +	.func			= ftrace_traceoff_count,
> +	.print			= ftrace_traceoff_print,
> +};
> +
> +static struct ftrace_probe_ops stacktrace_count_probe_ops = {
> +	.func			= ftrace_stacktrace_count,
> +	.print			= ftrace_stacktrace_print,
> +};
> +
> +static struct ftrace_probe_ops traceon_probe_ops = {
> +	.func			= ftrace_traceon,
> +	.print			= ftrace_traceon_print,
> +};
> +
> +static struct ftrace_probe_ops traceoff_probe_ops = {
> +	.func			= ftrace_traceoff,
> +	.print			= ftrace_traceoff_print,
> +};
> +
> +static struct ftrace_probe_ops stacktrace_probe_ops = {
> +	.func			= ftrace_stacktrace,
> +	.print			= ftrace_stacktrace_print,
> +};
> +
>  static int
> -ftrace_trace_onoff_callback(struct ftrace_hash *hash,
> -			    char *glob, char *cmd, char *param, int enable)
> +ftrace_trace_probe_callback(struct ftrace_probe_ops *ops,
> +			    struct ftrace_hash *hash, char *glob,
> +			    char *cmd, char *param, int enable)
>  {
> -	struct ftrace_probe_ops *ops;
>  	void *count = (void *)-1;
>  	char *number;
>  	int ret;
> @@ -312,14 +370,10 @@ ftrace_trace_onoff_callback(struct ftrace_hash *hash,
>  	if (!enable)
>  		return -EINVAL;
>  
> -	if (glob[0] == '!')
> -		return ftrace_trace_onoff_unreg(glob+1, cmd, param);
> -
> -	/* we register both traceon and traceoff to this callback */
> -	if (strcmp(cmd, "traceon") == 0)
> -		ops = &traceon_probe_ops;
> -	else
> -		ops = &traceoff_probe_ops;
> +	if (glob[0] == '!') {
> +		unregister_ftrace_function_probe_func(glob+1, ops);
> +		return 0;
> +	}
>  
>  	if (!param)
>  		goto out_reg;
> @@ -343,6 +397,34 @@ ftrace_trace_onoff_callback(struct ftrace_hash *hash,
>  	return ret < 0 ? ret : 0;
>  }
>  
> +static int
> +ftrace_trace_onoff_callback(struct ftrace_hash *hash,
> +			    char *glob, char *cmd, char *param, int enable)
> +{
> +	struct ftrace_probe_ops *ops;
> +
> +	/* we register both traceon and traceoff to this callback */
> +	if (strcmp(cmd, "traceon") == 0)
> +		ops = param ? &traceon_count_probe_ops : &traceon_probe_ops;
> +	else
> +		ops = param ? &traceoff_count_probe_ops : &traceoff_probe_ops;
> +
> +	return ftrace_trace_probe_callback(ops, hash, glob, cmd,
> +					   param, enable);
> +}
> +
> +static int
> +ftrace_stacktrace_callback(struct ftrace_hash *hash,
> +			   char *glob, char *cmd, char *param, int enable)
> +{
> +	struct ftrace_probe_ops *ops;
> +
> +	ops = param ? &stacktrace_count_probe_ops : &stacktrace_probe_ops;
> +
> +	return ftrace_trace_probe_callback(ops, hash, glob, cmd,
> +					   param, enable);
> +}
> +
>  static struct ftrace_func_command ftrace_traceon_cmd = {
>  	.name			= "traceon",
>  	.func			= ftrace_trace_onoff_callback,
> @@ -353,6 +435,11 @@ static struct ftrace_func_command ftrace_traceoff_cmd = {
>  	.func			= ftrace_trace_onoff_callback,
>  };
>  
> +static struct ftrace_func_command ftrace_stacktrace_cmd = {
> +	.name			= "stacktrace",
> +	.func			= ftrace_stacktrace_callback,
> +};
> +
>  static int __init init_func_cmd_traceon(void)
>  {
>  	int ret;
> @@ -364,6 +451,12 @@ static int __init init_func_cmd_traceon(void)
>  	ret = register_ftrace_command(&ftrace_traceon_cmd);
>  	if (ret)
>  		unregister_ftrace_command(&ftrace_traceoff_cmd);
> +
> +	ret = register_ftrace_command(&ftrace_stacktrace_cmd);
> +	if (ret) {
> +		unregister_ftrace_command(&ftrace_traceoff_cmd);
> +		unregister_ftrace_command(&ftrace_traceon_cmd);
> +	}
>  	return ret;
>  }
>  #else
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 39ada66..8388bc9 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -218,7 +218,7 @@ int __trace_graph_entry(struct trace_array *tr,
>  {
>  	struct ftrace_event_call *call = &event_funcgraph_entry;
>  	struct ring_buffer_event *event;
> -	struct ring_buffer *buffer = tr->buffer;
> +	struct ring_buffer *buffer = tr->trace_buffer.buffer;
>  	struct ftrace_graph_ent_entry *entry;
>  
>  	if (unlikely(__this_cpu_read(ftrace_cpu_disabled)))
> @@ -265,7 +265,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
>  
>  	local_irq_save(flags);
>  	cpu = raw_smp_processor_id();
> -	data = tr->data[cpu];
> +	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
>  	disabled = atomic_inc_return(&data->disabled);
>  	if (likely(disabled == 1)) {
>  		pc = preempt_count();
> @@ -323,7 +323,7 @@ void __trace_graph_return(struct trace_array *tr,
>  {
>  	struct ftrace_event_call *call = &event_funcgraph_exit;
>  	struct ring_buffer_event *event;
> -	struct ring_buffer *buffer = tr->buffer;
> +	struct ring_buffer *buffer = tr->trace_buffer.buffer;
>  	struct ftrace_graph_ret_entry *entry;
>  
>  	if (unlikely(__this_cpu_read(ftrace_cpu_disabled)))
> @@ -350,7 +350,7 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
>  
>  	local_irq_save(flags);
>  	cpu = raw_smp_processor_id();
> -	data = tr->data[cpu];
> +	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
>  	disabled = atomic_inc_return(&data->disabled);
>  	if (likely(disabled == 1)) {
>  		pc = preempt_count();
> @@ -560,9 +560,9 @@ get_return_for_leaf(struct trace_iterator *iter,
>  			 * We need to consume the current entry to see
>  			 * the next one.
>  			 */
> -			ring_buffer_consume(iter->tr->buffer, iter->cpu,
> +			ring_buffer_consume(iter->trace_buffer->buffer, iter->cpu,
>  					    NULL, NULL);
> -			event = ring_buffer_peek(iter->tr->buffer, iter->cpu,
> +			event = ring_buffer_peek(iter->trace_buffer->buffer, iter->cpu,
>  						 NULL, NULL);
>  		}
>  
> diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
> index 443b25b..b19d065 100644
> --- a/kernel/trace/trace_irqsoff.c
> +++ b/kernel/trace/trace_irqsoff.c
> @@ -33,6 +33,7 @@ enum {
>  static int trace_type __read_mostly;
>  
>  static int save_flags;
> +static bool function_enabled;
>  
>  static void stop_irqsoff_tracer(struct trace_array *tr, int graph);
>  static int start_irqsoff_tracer(struct trace_array *tr, int graph);
> @@ -121,7 +122,7 @@ static int func_prolog_dec(struct trace_array *tr,
>  	if (!irqs_disabled_flags(*flags))
>  		return 0;
>  
> -	*data = tr->data[cpu];
> +	*data = per_cpu_ptr(tr->trace_buffer.data, cpu);
>  	disabled = atomic_inc_return(&(*data)->disabled);
>  
>  	if (likely(disabled == 1))
> @@ -175,7 +176,7 @@ static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
>  		per_cpu(tracing_cpu, cpu) = 0;
>  
>  	tracing_max_latency = 0;
> -	tracing_reset_online_cpus(irqsoff_trace);
> +	tracing_reset_online_cpus(&irqsoff_trace->trace_buffer);
>  
>  	return start_irqsoff_tracer(irqsoff_trace, set);
>  }
> @@ -380,7 +381,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
>  	if (per_cpu(tracing_cpu, cpu))
>  		return;
>  
> -	data = tr->data[cpu];
> +	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
>  
>  	if (unlikely(!data) || atomic_read(&data->disabled))
>  		return;
> @@ -418,7 +419,7 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
>  	if (!tracer_enabled)
>  		return;
>  
> -	data = tr->data[cpu];
> +	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
>  
>  	if (unlikely(!data) ||
>  	    !data->critical_start || atomic_read(&data->disabled))
> @@ -528,15 +529,60 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
>  }
>  #endif /* CONFIG_PREEMPT_TRACER */
>  
> -static int start_irqsoff_tracer(struct trace_array *tr, int graph)
> +static int register_irqsoff_function(int graph, int set)
>  {
> -	int ret = 0;
> +	int ret;
>  
> -	if (!graph)
> -		ret = register_ftrace_function(&trace_ops);
> -	else
> +	/* 'set' is set if TRACE_ITER_FUNCTION is about to be set */
> +	if (function_enabled || (!set && !(trace_flags & TRACE_ITER_FUNCTION)))
> +		return 0;
> +
> +	if (graph)
>  		ret = register_ftrace_graph(&irqsoff_graph_return,
>  					    &irqsoff_graph_entry);
> +	else
> +		ret = register_ftrace_function(&trace_ops);
> +
> +	if (!ret)
> +		function_enabled = true;
> +
> +	return ret;
> +}
> +
> +static void unregister_irqsoff_function(int graph)
> +{
> +	if (!function_enabled)
> +		return;
> +
> +	if (graph)
> +		unregister_ftrace_graph();
> +	else
> +		unregister_ftrace_function(&trace_ops);
> +
> +	function_enabled = false;
> +}
> +
> +static void irqsoff_function_set(int set)
> +{
> +	if (set)
> +		register_irqsoff_function(is_graph(), 1);
> +	else
> +		unregister_irqsoff_function(is_graph());
> +}
> +
> +static int irqsoff_flag_changed(struct tracer *tracer, u32 mask, int set)
> +{
> +	if (mask & TRACE_ITER_FUNCTION)
> +		irqsoff_function_set(set);
> +
> +	return trace_keep_overwrite(tracer, mask, set);
> +}
> +
> +static int start_irqsoff_tracer(struct trace_array *tr, int graph)
> +{
> +	int ret;
> +
> +	ret = register_irqsoff_function(graph, 0);
>  
>  	if (!ret && tracing_is_enabled())
>  		tracer_enabled = 1;
> @@ -550,10 +596,7 @@ static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
>  {
>  	tracer_enabled = 0;
>  
> -	if (!graph)
> -		unregister_ftrace_function(&trace_ops);
> -	else
> -		unregister_ftrace_graph();
> +	unregister_irqsoff_function(graph);
>  }
>  
>  static void __irqsoff_tracer_init(struct trace_array *tr)
> @@ -561,14 +604,14 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
>  	save_flags = trace_flags;
>  
>  	/* non overwrite screws up the latency tracers */
> -	set_tracer_flag(TRACE_ITER_OVERWRITE, 1);
> -	set_tracer_flag(TRACE_ITER_LATENCY_FMT, 1);
> +	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
> +	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, 1);
>  
>  	tracing_max_latency = 0;
>  	irqsoff_trace = tr;
>  	/* make sure that the tracer is visible */
>  	smp_wmb();
> -	tracing_reset_online_cpus(tr);
> +	tracing_reset_online_cpus(&tr->trace_buffer);
>  
>  	if (start_irqsoff_tracer(tr, is_graph()))
>  		printk(KERN_ERR "failed to start irqsoff tracer\n");
> @@ -581,8 +624,8 @@ static void irqsoff_tracer_reset(struct trace_array *tr)
>  
>  	stop_irqsoff_tracer(tr, is_graph());
>  
> -	set_tracer_flag(TRACE_ITER_LATENCY_FMT, lat_flag);
> -	set_tracer_flag(TRACE_ITER_OVERWRITE, overwrite_flag);
> +	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, lat_flag);
> +	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, overwrite_flag);
>  }
>  
>  static void irqsoff_tracer_start(struct trace_array *tr)
> @@ -615,7 +658,7 @@ static struct tracer irqsoff_tracer __read_mostly =
>  	.print_line     = irqsoff_print_line,
>  	.flags		= &tracer_flags,
>  	.set_flag	= irqsoff_set_flag,
> -	.flag_changed	= trace_keep_overwrite,
> +	.flag_changed	= irqsoff_flag_changed,
>  #ifdef CONFIG_FTRACE_SELFTEST
>  	.selftest    = trace_selftest_startup_irqsoff,
>  #endif
> @@ -649,7 +692,7 @@ static struct tracer preemptoff_tracer __read_mostly =
>  	.print_line     = irqsoff_print_line,
>  	.flags		= &tracer_flags,
>  	.set_flag	= irqsoff_set_flag,
> -	.flag_changed	= trace_keep_overwrite,
> +	.flag_changed	= irqsoff_flag_changed,
>  #ifdef CONFIG_FTRACE_SELFTEST
>  	.selftest    = trace_selftest_startup_preemptoff,
>  #endif
> @@ -685,7 +728,7 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
>  	.print_line     = irqsoff_print_line,
>  	.flags		= &tracer_flags,
>  	.set_flag	= irqsoff_set_flag,
> -	.flag_changed	= trace_keep_overwrite,
> +	.flag_changed	= irqsoff_flag_changed,
>  #ifdef CONFIG_FTRACE_SELFTEST
>  	.selftest    = trace_selftest_startup_preemptirqsoff,
>  #endif
> diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
> index 3c5c5df..bd90e1b 100644
> --- a/kernel/trace/trace_kdb.c
> +++ b/kernel/trace/trace_kdb.c
> @@ -26,7 +26,7 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
>  	trace_init_global_iter(&iter);
>  
>  	for_each_tracing_cpu(cpu) {
> -		atomic_inc(&iter.tr->data[cpu]->disabled);
> +		atomic_inc(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
>  	}
>  
>  	old_userobj = trace_flags;
> @@ -43,17 +43,17 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
>  	iter.iter_flags |= TRACE_FILE_LAT_FMT;
>  	iter.pos = -1;
>  
> -	if (cpu_file == TRACE_PIPE_ALL_CPU) {
> +	if (cpu_file == RING_BUFFER_ALL_CPUS) {
>  		for_each_tracing_cpu(cpu) {
>  			iter.buffer_iter[cpu] =
> -			ring_buffer_read_prepare(iter.tr->buffer, cpu);
> +			ring_buffer_read_prepare(iter.trace_buffer->buffer, cpu);
>  			ring_buffer_read_start(iter.buffer_iter[cpu]);
>  			tracing_iter_reset(&iter, cpu);
>  		}
>  	} else {
>  		iter.cpu_file = cpu_file;
>  		iter.buffer_iter[cpu_file] =
> -			ring_buffer_read_prepare(iter.tr->buffer, cpu_file);
> +			ring_buffer_read_prepare(iter.trace_buffer->buffer, cpu_file);
>  		ring_buffer_read_start(iter.buffer_iter[cpu_file]);
>  		tracing_iter_reset(&iter, cpu_file);
>  	}
> @@ -83,7 +83,7 @@ out:
>  	trace_flags = old_userobj;
>  
>  	for_each_tracing_cpu(cpu) {
> -		atomic_dec(&iter.tr->data[cpu]->disabled);
> +		atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
>  	}
>  
>  	for_each_tracing_cpu(cpu)
> @@ -115,7 +115,7 @@ static int kdb_ftdump(int argc, const char **argv)
>  		    !cpu_online(cpu_file))
>  			return KDB_BADINT;
>  	} else {
> -		cpu_file = TRACE_PIPE_ALL_CPU;
> +		cpu_file = RING_BUFFER_ALL_CPUS;
>  	}
>  
>  	kdb_trap_printk++;
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index fd3c8aa..a5e8f48 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -31,7 +31,7 @@ static void mmio_reset_data(struct trace_array *tr)
>  	overrun_detected = false;
>  	prev_overruns = 0;
>  
> -	tracing_reset_online_cpus(tr);
> +	tracing_reset_online_cpus(&tr->trace_buffer);
>  }
>  
>  static int mmio_trace_init(struct trace_array *tr)
> @@ -128,7 +128,7 @@ static void mmio_close(struct trace_iterator *iter)
>  static unsigned long count_overruns(struct trace_iterator *iter)
>  {
>  	unsigned long cnt = atomic_xchg(&dropped_count, 0);
> -	unsigned long over = ring_buffer_overruns(iter->tr->buffer);
> +	unsigned long over = ring_buffer_overruns(iter->trace_buffer->buffer);
>  
>  	if (over > prev_overruns)
>  		cnt += over - prev_overruns;
> @@ -309,7 +309,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
>  				struct mmiotrace_rw *rw)
>  {
>  	struct ftrace_event_call *call = &event_mmiotrace_rw;
> -	struct ring_buffer *buffer = tr->buffer;
> +	struct ring_buffer *buffer = tr->trace_buffer.buffer;
>  	struct ring_buffer_event *event;
>  	struct trace_mmiotrace_rw *entry;
>  	int pc = preempt_count();
> @@ -330,7 +330,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
>  void mmio_trace_rw(struct mmiotrace_rw *rw)
>  {
>  	struct trace_array *tr = mmio_trace_array;
> -	struct trace_array_cpu *data = tr->data[smp_processor_id()];
> +	struct trace_array_cpu *data = per_cpu_ptr(tr->trace_buffer.data, smp_processor_id());
>  	__trace_mmiotrace_rw(tr, data, rw);
>  }
>  
> @@ -339,7 +339,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
>  				struct mmiotrace_map *map)
>  {
>  	struct ftrace_event_call *call = &event_mmiotrace_map;
> -	struct ring_buffer *buffer = tr->buffer;
> +	struct ring_buffer *buffer = tr->trace_buffer.buffer;
>  	struct ring_buffer_event *event;
>  	struct trace_mmiotrace_map *entry;
>  	int pc = preempt_count();
> @@ -363,7 +363,7 @@ void mmio_trace_mapping(struct mmiotrace_map *map)
>  	struct trace_array_cpu *data;
>  
>  	preempt_disable();
> -	data = tr->data[smp_processor_id()];
> +	data = per_cpu_ptr(tr->trace_buffer.data, smp_processor_id());
>  	__trace_mmiotrace_map(tr, data, map);
>  	preempt_enable();
>  }
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index 194d796..f475b2a 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -14,7 +14,7 @@
>  /* must be a power of 2 */
>  #define EVENT_HASHSIZE	128
>  
> -DECLARE_RWSEM(trace_event_mutex);
> +DECLARE_RWSEM(trace_event_sem);
>  
>  static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
>  
> @@ -37,6 +37,22 @@ int trace_print_seq(struct seq_file *m, struct trace_seq *s)
>  	return ret;
>  }
>  
> +enum print_line_t trace_print_bputs_msg_only(struct trace_iterator *iter)
> +{
> +	struct trace_seq *s = &iter->seq;
> +	struct trace_entry *entry = iter->ent;
> +	struct bputs_entry *field;
> +	int ret;
> +
> +	trace_assign_type(field, entry);
> +
> +	ret = trace_seq_puts(s, field->str);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	return TRACE_TYPE_HANDLED;
> +}
> +
>  enum print_line_t trace_print_bprintk_msg_only(struct trace_iterator *iter)
>  {
>  	struct trace_seq *s = &iter->seq;
> @@ -397,6 +413,32 @@ ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
>  }
>  EXPORT_SYMBOL(ftrace_print_hex_seq);
>  
> +int ftrace_raw_output_prep(struct trace_iterator *iter,
> +			   struct trace_event *trace_event)
> +{
> +	struct ftrace_event_call *event;
> +	struct trace_seq *s = &iter->seq;
> +	struct trace_seq *p = &iter->tmp_seq;
> +	struct trace_entry *entry;
> +	int ret;
> +
> +	event = container_of(trace_event, struct ftrace_event_call, event);
> +	entry = iter->ent;
> +
> +	if (entry->type != event->event.type) {
> +		WARN_ON_ONCE(1);
> +		return TRACE_TYPE_UNHANDLED;
> +	}
> +
> +	trace_seq_init(p);
> +	ret = trace_seq_printf(s, "%s: ", event->name);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ftrace_raw_output_prep);
> +
>  #ifdef CONFIG_KRETPROBES
>  static inline const char *kretprobed(const char *name)
>  {
> @@ -617,7 +659,7 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
>  {
>  	unsigned long verbose = trace_flags & TRACE_ITER_VERBOSE;
>  	unsigned long in_ns = iter->iter_flags & TRACE_FILE_TIME_IN_NS;
> -	unsigned long long abs_ts = iter->ts - iter->tr->time_start;
> +	unsigned long long abs_ts = iter->ts - iter->trace_buffer->time_start;
>  	unsigned long long rel_ts = next_ts - iter->ts;
>  	struct trace_seq *s = &iter->seq;
>  
> @@ -784,12 +826,12 @@ static int trace_search_list(struct list_head **list)
>  
>  void trace_event_read_lock(void)
>  {
> -	down_read(&trace_event_mutex);
> +	down_read(&trace_event_sem);
>  }
>  
>  void trace_event_read_unlock(void)
>  {
> -	up_read(&trace_event_mutex);
> +	up_read(&trace_event_sem);
>  }
>  
>  /**
> @@ -812,7 +854,7 @@ int register_ftrace_event(struct trace_event *event)
>  	unsigned key;
>  	int ret = 0;
>  
> -	down_write(&trace_event_mutex);
> +	down_write(&trace_event_sem);
>  
>  	if (WARN_ON(!event))
>  		goto out;
> @@ -867,14 +909,14 @@ int register_ftrace_event(struct trace_event *event)
>  
>  	ret = event->type;
>   out:
> -	up_write(&trace_event_mutex);
> +	up_write(&trace_event_sem);
>  
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(register_ftrace_event);
>  
>  /*
> - * Used by module code with the trace_event_mutex held for write.
> + * Used by module code with the trace_event_sem held for write.
>   */
>  int __unregister_ftrace_event(struct trace_event *event)
>  {
> @@ -889,9 +931,9 @@ int __unregister_ftrace_event(struct trace_event *event)
>   */
>  int unregister_ftrace_event(struct trace_event *event)
>  {
> -	down_write(&trace_event_mutex);
> +	down_write(&trace_event_sem);
>  	__unregister_ftrace_event(event);
> -	up_write(&trace_event_mutex);
> +	up_write(&trace_event_sem);
>  
>  	return 0;
>  }
> @@ -1218,6 +1260,64 @@ static struct trace_event trace_user_stack_event = {
>  	.funcs		= &trace_user_stack_funcs,
>  };
>  
> +/* TRACE_BPUTS */
> +static enum print_line_t
> +trace_bputs_print(struct trace_iterator *iter, int flags,
> +		   struct trace_event *event)
> +{
> +	struct trace_entry *entry = iter->ent;
> +	struct trace_seq *s = &iter->seq;
> +	struct bputs_entry *field;
> +
> +	trace_assign_type(field, entry);
> +
> +	if (!seq_print_ip_sym(s, field->ip, flags))
> +		goto partial;
> +
> +	if (!trace_seq_puts(s, ": "))
> +		goto partial;
> +
> +	if (!trace_seq_puts(s, field->str))
> +		goto partial;
> +
> +	return TRACE_TYPE_HANDLED;
> +
> + partial:
> +	return TRACE_TYPE_PARTIAL_LINE;
> +}
> +
> +
> +static enum print_line_t
> +trace_bputs_raw(struct trace_iterator *iter, int flags,
> +		struct trace_event *event)
> +{
> +	struct bputs_entry *field;
> +	struct trace_seq *s = &iter->seq;
> +
> +	trace_assign_type(field, iter->ent);
> +
> +	if (!trace_seq_printf(s, ": %lx : ", field->ip))
> +		goto partial;
> +
> +	if (!trace_seq_puts(s, field->str))
> +		goto partial;
> +
> +	return TRACE_TYPE_HANDLED;
> +
> + partial:
> +	return TRACE_TYPE_PARTIAL_LINE;
> +}
> +
> +static struct trace_event_functions trace_bputs_funcs = {
> +	.trace		= trace_bputs_print,
> +	.raw		= trace_bputs_raw,
> +};
> +
> +static struct trace_event trace_bputs_event = {
> +	.type		= TRACE_BPUTS,
> +	.funcs		= &trace_bputs_funcs,
> +};
> +
>  /* TRACE_BPRINT */
>  static enum print_line_t
>  trace_bprint_print(struct trace_iterator *iter, int flags,
> @@ -1330,6 +1430,7 @@ static struct trace_event *events[] __initdata = {
>  	&trace_wake_event,
>  	&trace_stack_event,
>  	&trace_user_stack_event,
> +	&trace_bputs_event,
>  	&trace_bprint_event,
>  	&trace_print_event,
>  	NULL
> diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
> index c038eba..127a9d8 100644
> --- a/kernel/trace/trace_output.h
> +++ b/kernel/trace/trace_output.h
> @@ -5,6 +5,8 @@
>  #include "trace.h"
>  
>  extern enum print_line_t
> +trace_print_bputs_msg_only(struct trace_iterator *iter);
> +extern enum print_line_t
>  trace_print_bprintk_msg_only(struct trace_iterator *iter);
>  extern enum print_line_t
>  trace_print_printk_msg_only(struct trace_iterator *iter);
> @@ -31,7 +33,7 @@ trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry);
>  
>  /* used by module unregistering */
>  extern int __unregister_ftrace_event(struct trace_event *event);
> -extern struct rw_semaphore trace_event_mutex;
> +extern struct rw_semaphore trace_event_sem;
>  
>  #define MAX_MEMHEX_BYTES	8
>  #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
> diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
> index 3374c79..4e98e3b 100644
> --- a/kernel/trace/trace_sched_switch.c
> +++ b/kernel/trace/trace_sched_switch.c
> @@ -28,7 +28,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
>  			   unsigned long flags, int pc)
>  {
>  	struct ftrace_event_call *call = &event_context_switch;
> -	struct ring_buffer *buffer = tr->buffer;
> +	struct ring_buffer *buffer = tr->trace_buffer.buffer;
>  	struct ring_buffer_event *event;
>  	struct ctx_switch_entry *entry;
>  
> @@ -69,7 +69,7 @@ probe_sched_switch(void *ignore, struct task_struct *prev, struct task_struct *n
>  	pc = preempt_count();
>  	local_irq_save(flags);
>  	cpu = raw_smp_processor_id();
> -	data = ctx_trace->data[cpu];
> +	data = per_cpu_ptr(ctx_trace->trace_buffer.data, cpu);
>  
>  	if (likely(!atomic_read(&data->disabled)))
>  		tracing_sched_switch_trace(ctx_trace, prev, next, flags, pc);
> @@ -86,7 +86,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
>  	struct ftrace_event_call *call = &event_wakeup;
>  	struct ring_buffer_event *event;
>  	struct ctx_switch_entry *entry;
> -	struct ring_buffer *buffer = tr->buffer;
> +	struct ring_buffer *buffer = tr->trace_buffer.buffer;
>  
>  	event = trace_buffer_lock_reserve(buffer, TRACE_WAKE,
>  					  sizeof(*entry), flags, pc);
> @@ -123,7 +123,7 @@ probe_sched_wakeup(void *ignore, struct task_struct *wakee, int success)
>  	pc = preempt_count();
>  	local_irq_save(flags);
>  	cpu = raw_smp_processor_id();
> -	data = ctx_trace->data[cpu];
> +	data = per_cpu_ptr(ctx_trace->trace_buffer.data, cpu);
>  
>  	if (likely(!atomic_read(&data->disabled)))
>  		tracing_sched_wakeup_trace(ctx_trace, wakee, current,
> diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
> index fde652c..fee77e1 100644
> --- a/kernel/trace/trace_sched_wakeup.c
> +++ b/kernel/trace/trace_sched_wakeup.c
> @@ -37,6 +37,7 @@ static int wakeup_graph_entry(struct ftrace_graph_ent *trace);
>  static void wakeup_graph_return(struct ftrace_graph_ret *trace);
>  
>  static int save_flags;
> +static bool function_enabled;
>  
>  #define TRACE_DISPLAY_GRAPH     1
>  
> @@ -89,7 +90,7 @@ func_prolog_preempt_disable(struct trace_array *tr,
>  	if (cpu != wakeup_current_cpu)
>  		goto out_enable;
>  
> -	*data = tr->data[cpu];
> +	*data = per_cpu_ptr(tr->trace_buffer.data, cpu);
>  	disabled = atomic_inc_return(&(*data)->disabled);
>  	if (unlikely(disabled != 1))
>  		goto out;
> @@ -134,15 +135,60 @@ static struct ftrace_ops trace_ops __read_mostly =
>  };
>  #endif /* CONFIG_FUNCTION_TRACER */
>  
> -static int start_func_tracer(int graph)
> +static int register_wakeup_function(int graph, int set)
>  {
>  	int ret;
>  
> -	if (!graph)
> -		ret = register_ftrace_function(&trace_ops);
> -	else
> +	/* 'set' is set if TRACE_ITER_FUNCTION is about to be set */
> +	if (function_enabled || (!set && !(trace_flags & TRACE_ITER_FUNCTION)))
> +		return 0;
> +
> +	if (graph)
>  		ret = register_ftrace_graph(&wakeup_graph_return,
>  					    &wakeup_graph_entry);
> +	else
> +		ret = register_ftrace_function(&trace_ops);
> +
> +	if (!ret)
> +		function_enabled = true;
> +
> +	return ret;
> +}
> +
> +static void unregister_wakeup_function(int graph)
> +{
> +	if (!function_enabled)
> +		return;
> +
> +	if (graph)
> +		unregister_ftrace_graph();
> +	else
> +		unregister_ftrace_function(&trace_ops);
> +
> +	function_enabled = false;
> +}
> +
> +static void wakeup_function_set(int set)
> +{
> +	if (set)
> +		register_wakeup_function(is_graph(), 1);
> +	else
> +		unregister_wakeup_function(is_graph());
> +}
> +
> +static int wakeup_flag_changed(struct tracer *tracer, u32 mask, int set)
> +{
> +	if (mask & TRACE_ITER_FUNCTION)
> +		wakeup_function_set(set);
> +
> +	return trace_keep_overwrite(tracer, mask, set);
> +}
> +
> +static int start_func_tracer(int graph)
> +{
> +	int ret;
> +
> +	ret = register_wakeup_function(graph, 0);
>  
>  	if (!ret && tracing_is_enabled())
>  		tracer_enabled = 1;
> @@ -156,10 +202,7 @@ static void stop_func_tracer(int graph)
>  {
>  	tracer_enabled = 0;
>  
> -	if (!graph)
> -		unregister_ftrace_function(&trace_ops);
> -	else
> -		unregister_ftrace_graph();
> +	unregister_wakeup_function(graph);
>  }
>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> @@ -353,7 +396,7 @@ probe_wakeup_sched_switch(void *ignore,
>  
>  	/* disable local data, not wakeup_cpu data */
>  	cpu = raw_smp_processor_id();
> -	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
> +	disabled = atomic_inc_return(&per_cpu_ptr(wakeup_trace->trace_buffer.data, cpu)->disabled);
>  	if (likely(disabled != 1))
>  		goto out;
>  
> @@ -365,7 +408,7 @@ probe_wakeup_sched_switch(void *ignore,
>  		goto out_unlock;
>  
>  	/* The task we are waiting for is waking up */
> -	data = wakeup_trace->data[wakeup_cpu];
> +	data = per_cpu_ptr(wakeup_trace->trace_buffer.data, wakeup_cpu);
>  
>  	__trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
>  	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
> @@ -387,7 +430,7 @@ out_unlock:
>  	arch_spin_unlock(&wakeup_lock);
>  	local_irq_restore(flags);
>  out:
> -	atomic_dec(&wakeup_trace->data[cpu]->disabled);
> +	atomic_dec(&per_cpu_ptr(wakeup_trace->trace_buffer.data, cpu)->disabled);
>  }
>  
>  static void __wakeup_reset(struct trace_array *tr)
> @@ -405,7 +448,7 @@ static void wakeup_reset(struct trace_array *tr)
>  {
>  	unsigned long flags;
>  
> -	tracing_reset_online_cpus(tr);
> +	tracing_reset_online_cpus(&tr->trace_buffer);
>  
>  	local_irq_save(flags);
>  	arch_spin_lock(&wakeup_lock);
> @@ -435,7 +478,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
>  		return;
>  
>  	pc = preempt_count();
> -	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
> +	disabled = atomic_inc_return(&per_cpu_ptr(wakeup_trace->trace_buffer.data, cpu)->disabled);
>  	if (unlikely(disabled != 1))
>  		goto out;
>  
> @@ -458,7 +501,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
>  
>  	local_save_flags(flags);
>  
> -	data = wakeup_trace->data[wakeup_cpu];
> +	data = per_cpu_ptr(wakeup_trace->trace_buffer.data, wakeup_cpu);
>  	data->preempt_timestamp = ftrace_now(cpu);
>  	tracing_sched_wakeup_trace(wakeup_trace, p, current, flags, pc);
>  
> @@ -472,7 +515,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
>  out_locked:
>  	arch_spin_unlock(&wakeup_lock);
>  out:
> -	atomic_dec(&wakeup_trace->data[cpu]->disabled);
> +	atomic_dec(&per_cpu_ptr(wakeup_trace->trace_buffer.data, cpu)->disabled);
>  }
>  
>  static void start_wakeup_tracer(struct trace_array *tr)
> @@ -543,8 +586,8 @@ static int __wakeup_tracer_init(struct trace_array *tr)
>  	save_flags = trace_flags;
>  
>  	/* non overwrite screws up the latency tracers */
> -	set_tracer_flag(TRACE_ITER_OVERWRITE, 1);
> -	set_tracer_flag(TRACE_ITER_LATENCY_FMT, 1);
> +	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
> +	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, 1);
>  
>  	tracing_max_latency = 0;
>  	wakeup_trace = tr;
> @@ -573,8 +616,8 @@ static void wakeup_tracer_reset(struct trace_array *tr)
>  	/* make sure we put back any tasks we are tracing */
>  	wakeup_reset(tr);
>  
> -	set_tracer_flag(TRACE_ITER_LATENCY_FMT, lat_flag);
> -	set_tracer_flag(TRACE_ITER_OVERWRITE, overwrite_flag);
> +	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, lat_flag);
> +	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, overwrite_flag);
>  }
>  
>  static void wakeup_tracer_start(struct trace_array *tr)
> @@ -600,7 +643,7 @@ static struct tracer wakeup_tracer __read_mostly =
>  	.print_line	= wakeup_print_line,
>  	.flags		= &tracer_flags,
>  	.set_flag	= wakeup_set_flag,
> -	.flag_changed	= trace_keep_overwrite,
> +	.flag_changed	= wakeup_flag_changed,
>  #ifdef CONFIG_FTRACE_SELFTEST
>  	.selftest    = trace_selftest_startup_wakeup,
>  #endif
> @@ -622,7 +665,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =
>  	.print_line	= wakeup_print_line,
>  	.flags		= &tracer_flags,
>  	.set_flag	= wakeup_set_flag,
> -	.flag_changed	= trace_keep_overwrite,
> +	.flag_changed	= wakeup_flag_changed,
>  #ifdef CONFIG_FTRACE_SELFTEST
>  	.selftest    = trace_selftest_startup_wakeup,
>  #endif
> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index 51c819c..55e2cf6 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -21,13 +21,13 @@ static inline int trace_valid_entry(struct trace_entry *entry)
>  	return 0;
>  }
>  
> -static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
> +static int trace_test_buffer_cpu(struct trace_buffer *buf, int cpu)
>  {
>  	struct ring_buffer_event *event;
>  	struct trace_entry *entry;
>  	unsigned int loops = 0;
>  
> -	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL, NULL))) {
> +	while ((event = ring_buffer_consume(buf->buffer, cpu, NULL, NULL))) {
>  		entry = ring_buffer_event_data(event);
>  
>  		/*
> @@ -58,7 +58,7 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
>   * Test the trace buffer to see if all the elements
>   * are still sane.
>   */
> -static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
> +static int trace_test_buffer(struct trace_buffer *buf, unsigned long *count)
>  {
>  	unsigned long flags, cnt = 0;
>  	int cpu, ret = 0;
> @@ -67,7 +67,7 @@ static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
>  	local_irq_save(flags);
>  	arch_spin_lock(&ftrace_max_lock);
>  
> -	cnt = ring_buffer_entries(tr->buffer);
> +	cnt = ring_buffer_entries(buf->buffer);
>  
>  	/*
>  	 * The trace_test_buffer_cpu runs a while loop to consume all data.
> @@ -78,7 +78,7 @@ static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
>  	 */
>  	tracing_off();
>  	for_each_possible_cpu(cpu) {
> -		ret = trace_test_buffer_cpu(tr, cpu);
> +		ret = trace_test_buffer_cpu(buf, cpu);
>  		if (ret)
>  			break;
>  	}
> @@ -355,7 +355,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
>  	msleep(100);
>  
>  	/* we should have nothing in the buffer */
> -	ret = trace_test_buffer(tr, &count);
> +	ret = trace_test_buffer(&tr->trace_buffer, &count);
>  	if (ret)
>  		goto out;
>  
> @@ -376,7 +376,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
>  	ftrace_enabled = 0;
>  
>  	/* check the trace buffer */
> -	ret = trace_test_buffer(tr, &count);
> +	ret = trace_test_buffer(&tr->trace_buffer, &count);
>  	tracing_start();
>  
>  	/* we should only have one item */
> @@ -666,7 +666,7 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
>  	ftrace_enabled = 0;
>  
>  	/* check the trace buffer */
> -	ret = trace_test_buffer(tr, &count);
> +	ret = trace_test_buffer(&tr->trace_buffer, &count);
>  	trace->reset(tr);
>  	tracing_start();
>  
> @@ -703,8 +703,6 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
>  /* Maximum number of functions to trace before diagnosing a hang */
>  #define GRAPH_MAX_FUNC_TEST	100000000
>  
> -static void
> -__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode);
>  static unsigned int graph_hang_thresh;
>  
>  /* Wrap the real function entry probe to avoid possible hanging */
> @@ -714,8 +712,11 @@ static int trace_graph_entry_watchdog(struct ftrace_graph_ent *trace)
>  	if (unlikely(++graph_hang_thresh > GRAPH_MAX_FUNC_TEST)) {
>  		ftrace_graph_stop();
>  		printk(KERN_WARNING "BUG: Function graph tracer hang!\n");
> -		if (ftrace_dump_on_oops)
> -			__ftrace_dump(false, DUMP_ALL);
> +		if (ftrace_dump_on_oops) {
> +			ftrace_dump(DUMP_ALL);
> +			/* ftrace_dump() disables tracing */
> +			tracing_on();
> +		}
>  		return 0;
>  	}
>  
> @@ -737,7 +738,7 @@ trace_selftest_startup_function_graph(struct tracer *trace,
>  	 * Simulate the init() callback but we attach a watchdog callback
>  	 * to detect and recover from possible hangs
>  	 */
> -	tracing_reset_online_cpus(tr);
> +	tracing_reset_online_cpus(&tr->trace_buffer);
>  	set_graph_array(tr);
>  	ret = register_ftrace_graph(&trace_graph_return,
>  				    &trace_graph_entry_watchdog);
> @@ -760,7 +761,7 @@ trace_selftest_startup_function_graph(struct tracer *trace,
>  	tracing_stop();
>  
>  	/* check the trace buffer */
> -	ret = trace_test_buffer(tr, &count);
> +	ret = trace_test_buffer(&tr->trace_buffer, &count);
>  
>  	trace->reset(tr);
>  	tracing_start();
> @@ -815,9 +816,9 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
>  	/* stop the tracing. */
>  	tracing_stop();
>  	/* check both trace buffers */
> -	ret = trace_test_buffer(tr, NULL);
> +	ret = trace_test_buffer(&tr->trace_buffer, NULL);
>  	if (!ret)
> -		ret = trace_test_buffer(&max_tr, &count);
> +		ret = trace_test_buffer(&tr->max_buffer, &count);
>  	trace->reset(tr);
>  	tracing_start();
>  
> @@ -877,9 +878,9 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
>  	/* stop the tracing. */
>  	tracing_stop();
>  	/* check both trace buffers */
> -	ret = trace_test_buffer(tr, NULL);
> +	ret = trace_test_buffer(&tr->trace_buffer, NULL);
>  	if (!ret)
> -		ret = trace_test_buffer(&max_tr, &count);
> +		ret = trace_test_buffer(&tr->max_buffer, &count);
>  	trace->reset(tr);
>  	tracing_start();
>  
> @@ -943,11 +944,11 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
>  	/* stop the tracing. */
>  	tracing_stop();
>  	/* check both trace buffers */
> -	ret = trace_test_buffer(tr, NULL);
> +	ret = trace_test_buffer(&tr->trace_buffer, NULL);
>  	if (ret)
>  		goto out;
>  
> -	ret = trace_test_buffer(&max_tr, &count);
> +	ret = trace_test_buffer(&tr->max_buffer, &count);
>  	if (ret)
>  		goto out;
>  
> @@ -973,11 +974,11 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
>  	/* stop the tracing. */
>  	tracing_stop();
>  	/* check both trace buffers */
> -	ret = trace_test_buffer(tr, NULL);
> +	ret = trace_test_buffer(&tr->trace_buffer, NULL);
>  	if (ret)
>  		goto out;
>  
> -	ret = trace_test_buffer(&max_tr, &count);
> +	ret = trace_test_buffer(&tr->max_buffer, &count);
>  
>  	if (!ret && !count) {
>  		printk(KERN_CONT ".. no entries found ..");
> @@ -1084,10 +1085,10 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
>  	/* stop the tracing. */
>  	tracing_stop();
>  	/* check both trace buffers */
> -	ret = trace_test_buffer(tr, NULL);
> +	ret = trace_test_buffer(&tr->trace_buffer, NULL);
>  	printk("ret = %d\n", ret);
>  	if (!ret)
> -		ret = trace_test_buffer(&max_tr, &count);
> +		ret = trace_test_buffer(&tr->max_buffer, &count);
>  
> 
>  	trace->reset(tr);
> @@ -1126,7 +1127,7 @@ trace_selftest_startup_sched_switch(struct tracer *trace, struct trace_array *tr
>  	/* stop the tracing. */
>  	tracing_stop();
>  	/* check the trace buffer */
> -	ret = trace_test_buffer(tr, &count);
> +	ret = trace_test_buffer(&tr->trace_buffer, &count);
>  	trace->reset(tr);
>  	tracing_start();
>  
> diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
> index 42ca822..aab277b 100644
> --- a/kernel/trace/trace_stack.c
> +++ b/kernel/trace/trace_stack.c
> @@ -20,13 +20,24 @@
>  
>  #define STACK_TRACE_ENTRIES 500
>  
> +#ifdef CC_USING_FENTRY
> +# define fentry		1
> +#else
> +# define fentry		0
> +#endif
> +
>  static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES+1] =
>  	 { [0 ... (STACK_TRACE_ENTRIES)] = ULONG_MAX };
>  static unsigned stack_dump_index[STACK_TRACE_ENTRIES];
>  
> +/*
> + * Reserve one entry for the passed in ip. This will allow
> + * us to remove most or all of the stack size overhead
> + * added by the stack tracer itself.
> + */
>  static struct stack_trace max_stack_trace = {
> -	.max_entries		= STACK_TRACE_ENTRIES,
> -	.entries		= stack_dump_trace,
> +	.max_entries		= STACK_TRACE_ENTRIES - 1,
> +	.entries		= &stack_dump_trace[1],
>  };
>  
>  static unsigned long max_stack_size;
> @@ -39,25 +50,34 @@ static DEFINE_MUTEX(stack_sysctl_mutex);
>  int stack_tracer_enabled;
>  static int last_stack_tracer_enabled;
>  
> -static inline void check_stack(void)
> +static inline void
> +check_stack(unsigned long ip, unsigned long *stack)
>  {
>  	unsigned long this_size, flags;
>  	unsigned long *p, *top, *start;
> +	static int tracer_frame;
> +	int frame_size = ACCESS_ONCE(tracer_frame);
>  	int i;
>  
> -	this_size = ((unsigned long)&this_size) & (THREAD_SIZE-1);
> +	this_size = ((unsigned long)stack) & (THREAD_SIZE-1);
>  	this_size = THREAD_SIZE - this_size;
> +	/* Remove the frame of the tracer */
> +	this_size -= frame_size;
>  
>  	if (this_size <= max_stack_size)
>  		return;
>  
>  	/* we do not handle interrupt stacks yet */
> -	if (!object_is_on_stack(&this_size))
> +	if (!object_is_on_stack(stack))
>  		return;
>  
>  	local_irq_save(flags);
>  	arch_spin_lock(&max_stack_lock);
>  
> +	/* In case another CPU set the tracer_frame on us */
> +	if (unlikely(!frame_size))
> +		this_size -= tracer_frame;
> +
>  	/* a race could have already updated it */
>  	if (this_size <= max_stack_size)
>  		goto out;
> @@ -70,10 +90,18 @@ static inline void check_stack(void)
>  	save_stack_trace(&max_stack_trace);
>  
>  	/*
> +	 * Add the passed in ip from the function tracer.
> +	 * Searching for this on the stack will skip over
> +	 * most of the overhead from the stack tracer itself.
> +	 */
> +	stack_dump_trace[0] = ip;
> +	max_stack_trace.nr_entries++;
> +
> +	/*
>  	 * Now find where in the stack these are.
>  	 */
>  	i = 0;
> -	start = &this_size;
> +	start = stack;
>  	top = (unsigned long *)
>  		(((unsigned long)start & ~(THREAD_SIZE-1)) + THREAD_SIZE);
>  
> @@ -97,6 +125,18 @@ static inline void check_stack(void)
>  				found = 1;
>  				/* Start the search from here */
>  				start = p + 1;
> +				/*
> +				 * We do not want to show the overhead
> +				 * of the stack tracer stack in the
> +				 * max stack. If we haven't figured
> +				 * out what that is, then figure it out
> +				 * now.
> +				 */
> +				if (unlikely(!tracer_frame) && i == 1) {
> +					tracer_frame = (p - stack) *
> +						sizeof(unsigned long);
> +					max_stack_size -= tracer_frame;
> +				}
>  			}
>  		}
>  
> @@ -113,6 +153,7 @@ static void
>  stack_trace_call(unsigned long ip, unsigned long parent_ip,
>  		 struct ftrace_ops *op, struct pt_regs *pt_regs)
>  {
> +	unsigned long stack;
>  	int cpu;
>  
>  	preempt_disable_notrace();
> @@ -122,7 +163,26 @@ stack_trace_call(unsigned long ip, unsigned long parent_ip,
>  	if (per_cpu(trace_active, cpu)++ != 0)
>  		goto out;
>  
> -	check_stack();
> +	/*
> +	 * When fentry is used, the traced function does not get
> +	 * its stack frame set up, and we lose the parent.
> +	 * The ip is pretty useless because the function tracer
> +	 * was called before that function set up its stack frame.
> +	 * In this case, we use the parent ip.
> +	 *
> +	 * By adding the return address of either the parent ip
> +	 * or the current ip we can disregard most of the stack usage
> +	 * caused by the stack tracer itself.
> +	 *
> +	 * The function tracer always reports the address of where the
> +	 * mcount call was, but the stack will hold the return address.
> +	 */
> +	if (fentry)
> +		ip = parent_ip;
> +	else
> +		ip += MCOUNT_INSN_SIZE;
> +
> +	check_stack(ip, &stack);
>  
>   out:
>  	per_cpu(trace_active, cpu)--;
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 7a809e3..8f2ac73 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -12,10 +12,6 @@
>  #include "trace.h"
>  
>  static DEFINE_MUTEX(syscall_trace_lock);
> -static int sys_refcount_enter;
> -static int sys_refcount_exit;
> -static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
> -static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
>  
>  static int syscall_enter_register(struct ftrace_event_call *event,
>  				 enum trace_reg type, void *data);
> @@ -41,7 +37,7 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
>  	/*
>  	 * Only compare after the "sys" prefix. Archs that use
>  	 * syscall wrappers may have syscalls symbols aliases prefixed
> -	 * with "SyS" instead of "sys", leading to an unwanted
> +	 * with ".SyS" or ".sys" instead of "sys", leading to an unwanted
>  	 * mismatch.
>  	 */
>  	return !strcmp(sym + 3, name + 3);
> @@ -265,7 +261,7 @@ static void free_syscall_print_fmt(struct ftrace_event_call *call)
>  		kfree(call->print_fmt);
>  }
>  
> -static int syscall_enter_define_fields(struct ftrace_event_call *call)
> +static int __init syscall_enter_define_fields(struct ftrace_event_call *call)
>  {
>  	struct syscall_trace_enter trace;
>  	struct syscall_metadata *meta = call->data;
> @@ -288,7 +284,7 @@ static int syscall_enter_define_fields(struct ftrace_event_call *call)
>  	return ret;
>  }
>  
> -static int syscall_exit_define_fields(struct ftrace_event_call *call)
> +static int __init syscall_exit_define_fields(struct ftrace_event_call *call)
>  {
>  	struct syscall_trace_exit trace;
>  	int ret;
> @@ -303,8 +299,9 @@ static int syscall_exit_define_fields(struct ftrace_event_call *call)
>  	return ret;
>  }
>  
> -static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
> +static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  {
> +	struct trace_array *tr = data;
>  	struct syscall_trace_enter *entry;
>  	struct syscall_metadata *sys_data;
>  	struct ring_buffer_event *event;
> @@ -315,7 +312,7 @@ static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
>  	syscall_nr = trace_get_syscall_nr(current, regs);
>  	if (syscall_nr < 0)
>  		return;
> -	if (!test_bit(syscall_nr, enabled_enter_syscalls))
> +	if (!test_bit(syscall_nr, tr->enabled_enter_syscalls))
>  		return;
>  
>  	sys_data = syscall_nr_to_meta(syscall_nr);
> @@ -324,7 +321,8 @@ static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
>  
>  	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
>  
> -	event = trace_current_buffer_lock_reserve(&buffer,
> +	buffer = tr->trace_buffer.buffer;
> +	event = trace_buffer_lock_reserve(buffer,
>  			sys_data->enter_event->event.type, size, 0, 0);
>  	if (!event)
>  		return;
> @@ -338,8 +336,9 @@ static void ftrace_syscall_enter(void *ignore, struct pt_regs *regs, long id)
>  		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
>  }
>  
> -static void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
> +static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
>  {
> +	struct trace_array *tr = data;
>  	struct syscall_trace_exit *entry;
>  	struct syscall_metadata *sys_data;
>  	struct ring_buffer_event *event;
> @@ -349,14 +348,15 @@ static void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
>  	syscall_nr = trace_get_syscall_nr(current, regs);
>  	if (syscall_nr < 0)
>  		return;
> -	if (!test_bit(syscall_nr, enabled_exit_syscalls))
> +	if (!test_bit(syscall_nr, tr->enabled_exit_syscalls))
>  		return;
>  
>  	sys_data = syscall_nr_to_meta(syscall_nr);
>  	if (!sys_data)
>  		return;
>  
> -	event = trace_current_buffer_lock_reserve(&buffer,
> +	buffer = tr->trace_buffer.buffer;
> +	event = trace_buffer_lock_reserve(buffer,
>  			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
>  	if (!event)
>  		return;
> @@ -370,8 +370,10 @@ static void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
>  		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
>  }
>  
> -static int reg_event_syscall_enter(struct ftrace_event_call *call)
> +static int reg_event_syscall_enter(struct ftrace_event_file *file,
> +				   struct ftrace_event_call *call)
>  {
> +	struct trace_array *tr = file->tr;
>  	int ret = 0;
>  	int num;
>  
> @@ -379,33 +381,37 @@ static int reg_event_syscall_enter(struct ftrace_event_call *call)
>  	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
>  		return -ENOSYS;
>  	mutex_lock(&syscall_trace_lock);
> -	if (!sys_refcount_enter)
> -		ret = register_trace_sys_enter(ftrace_syscall_enter, NULL);
> +	if (!tr->sys_refcount_enter)
> +		ret = register_trace_sys_enter(ftrace_syscall_enter, tr);
>  	if (!ret) {
> -		set_bit(num, enabled_enter_syscalls);
> -		sys_refcount_enter++;
> +		set_bit(num, tr->enabled_enter_syscalls);
> +		tr->sys_refcount_enter++;
>  	}
>  	mutex_unlock(&syscall_trace_lock);
>  	return ret;
>  }
>  
> -static void unreg_event_syscall_enter(struct ftrace_event_call *call)
> +static void unreg_event_syscall_enter(struct ftrace_event_file *file,
> +				      struct ftrace_event_call *call)
>  {
> +	struct trace_array *tr = file->tr;
>  	int num;
>  
>  	num = ((struct syscall_metadata *)call->data)->syscall_nr;
>  	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
>  		return;
>  	mutex_lock(&syscall_trace_lock);
> -	sys_refcount_enter--;
> -	clear_bit(num, enabled_enter_syscalls);
> -	if (!sys_refcount_enter)
> -		unregister_trace_sys_enter(ftrace_syscall_enter, NULL);
> +	tr->sys_refcount_enter--;
> +	clear_bit(num, tr->enabled_enter_syscalls);
> +	if (!tr->sys_refcount_enter)
> +		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
>  	mutex_unlock(&syscall_trace_lock);
>  }
>  
> -static int reg_event_syscall_exit(struct ftrace_event_call *call)
> +static int reg_event_syscall_exit(struct ftrace_event_file *file,
> +				  struct ftrace_event_call *call)
>  {
> +	struct trace_array *tr = file->tr;
>  	int ret = 0;
>  	int num;
>  
> @@ -413,28 +419,30 @@ static int reg_event_syscall_exit(struct ftrace_event_call *call)
>  	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
>  		return -ENOSYS;
>  	mutex_lock(&syscall_trace_lock);
> -	if (!sys_refcount_exit)
> -		ret = register_trace_sys_exit(ftrace_syscall_exit, NULL);
> +	if (!tr->sys_refcount_exit)
> +		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
>  	if (!ret) {
> -		set_bit(num, enabled_exit_syscalls);
> -		sys_refcount_exit++;
> +		set_bit(num, tr->enabled_exit_syscalls);
> +		tr->sys_refcount_exit++;
>  	}
>  	mutex_unlock(&syscall_trace_lock);
>  	return ret;
>  }
>  
> -static void unreg_event_syscall_exit(struct ftrace_event_call *call)
> +static void unreg_event_syscall_exit(struct ftrace_event_file *file,
> +				     struct ftrace_event_call *call)
>  {
> +	struct trace_array *tr = file->tr;
>  	int num;
>  
>  	num = ((struct syscall_metadata *)call->data)->syscall_nr;
>  	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
>  		return;
>  	mutex_lock(&syscall_trace_lock);
> -	sys_refcount_exit--;
> -	clear_bit(num, enabled_exit_syscalls);
> -	if (!sys_refcount_exit)
> -		unregister_trace_sys_exit(ftrace_syscall_exit, NULL);
> +	tr->sys_refcount_exit--;
> +	clear_bit(num, tr->enabled_exit_syscalls);
> +	if (!tr->sys_refcount_exit)
> +		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
>  	mutex_unlock(&syscall_trace_lock);
>  }
>  
> @@ -471,7 +479,7 @@ struct trace_event_functions exit_syscall_print_funcs = {
>  	.trace		= print_syscall_exit,
>  };
>  
> -struct ftrace_event_class event_class_syscall_enter = {
> +struct ftrace_event_class __refdata event_class_syscall_enter = {
>  	.system		= "syscalls",
>  	.reg		= syscall_enter_register,
>  	.define_fields	= syscall_enter_define_fields,
> @@ -479,7 +487,7 @@ struct ftrace_event_class event_class_syscall_enter = {
>  	.raw_init	= init_syscall_trace,
>  };
>  
> -struct ftrace_event_class event_class_syscall_exit = {
> +struct ftrace_event_class __refdata event_class_syscall_exit = {
>  	.system		= "syscalls",
>  	.reg		= syscall_exit_register,
>  	.define_fields	= syscall_exit_define_fields,
> @@ -685,11 +693,13 @@ static void perf_sysexit_disable(struct ftrace_event_call *call)
>  static int syscall_enter_register(struct ftrace_event_call *event,
>  				 enum trace_reg type, void *data)
>  {
> +	struct ftrace_event_file *file = data;
> +
>  	switch (type) {
>  	case TRACE_REG_REGISTER:
> -		return reg_event_syscall_enter(event);
> +		return reg_event_syscall_enter(file, event);
>  	case TRACE_REG_UNREGISTER:
> -		unreg_event_syscall_enter(event);
> +		unreg_event_syscall_enter(file, event);
>  		return 0;
>  
>  #ifdef CONFIG_PERF_EVENTS
> @@ -711,11 +721,13 @@ static int syscall_enter_register(struct ftrace_event_call *event,
>  static int syscall_exit_register(struct ftrace_event_call *event,
>  				 enum trace_reg type, void *data)
>  {
> +	struct ftrace_event_file *file = data;
> +
>  	switch (type) {
>  	case TRACE_REG_REGISTER:
> -		return reg_event_syscall_exit(event);
> +		return reg_event_syscall_exit(file, event);
>  	case TRACE_REG_UNREGISTER:
> -		unreg_event_syscall_exit(event);
> +		unreg_event_syscall_exit(file, event);
>  		return 0;
>  
>  #ifdef CONFIG_PERF_EVENTS
> 


