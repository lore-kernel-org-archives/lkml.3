Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaFRQjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:39:12 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59010 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaFRQjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:39:09 -0400
Date: Wed, 18 Jun 2014 18:39:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140618163900.GA13280@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: cf230918cda19532e4a5cc4f0d5c82fa7e5e94f6 Merge branch 'perf/core' into perf/urgent, to pick up the latest fixes

This is larger than usual: the main reason are the ARM symbol lookup 
speedups that came in late and were hard to resist. If it's not 
acceptable then I'll restructure it without those bits.

There's also a kprobes fix and various tooling fixes, plus the minimal 
re-enablement of the mmap2 support interface.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (2):
      perf tools: Emit more precise message for missing glibc static library
      perf tests: Show the inner make output when an error happens

Don Zickus (6):
      perf tools: Update mmap2 interface with protection and flag bits
      Revert "perf: Disable PERF_RECORD_MMAP2 support"
      perf report: Add mem-mode documentation to report command
      perf tools: Add cpumode to struct hist_entry
      perf tools: Add support to dynamically get cacheline size
      perf tools: Add dcacheline sort

Jiri Olsa (15):
      perf tools: Fix pipe check regression in attr event callback
      perf tools: Prettify the tags/TAGS/cscope targets output
      perf tools: Cache register accesses for unwind processing
      perf tools: Separate dso data related variables
      perf tools: Add data_fd into dso object
      perf tools: Add global list of opened dso objects
      perf tools: Add global count of opened dso objects
      perf tools: Cache dso data file descriptor
      perf tools: Add file size check and factor dso__data_read_offset
      perf tools: Allow to close dso fd in case of open failure
      perf tools: Add dso__data_* interface descriptons
      perf tests: Spawn child for each test
      perf tests: Allow reuse of test_file function
      perf tests: Add test for caching dso file descriptors
      perf tests: Add test for closing dso objects on EMFILE error

Masami Hiramatsu (5):
      perf probe: Improve error message for unknown member of data structure
      perf probe: Show error code and description in verbose mode
      perf probe: Improve an error message of perf probe --vars mode
      perf probe: Improve error messages in --line option
      x86/kprobes: Fix build errors and blacklist context_track_user

Namhyung Kim (2):
      perf script/python: Print array argument as string
      perf record: Fix to honor user freq/interval properly

Peter Zijlstra (1):
      perf: Pass protection and flags bits through mmap2 interface

Stanislav Fomichev (1):
      perf timechart: Reflow documentation

Steven Rostedt (1):
      tools lib traceevent: Add options to plugins

Steven Rostedt (Red Hat) (3):
      tools lib traceevent: Add flag to not load event plugins
      tools lib traceevent: Add options to function plugin
      tools lib traceevent: Added support for __get_bitmask() macro


 arch/x86/kernel/traps.c                            |   7 +-
 include/uapi/linux/perf_event.h                    |   1 +
 kernel/context_tracking.c                          |   3 +
 kernel/events/core.c                               |  37 ++-
 tools/lib/traceevent/event-parse.c                 | 113 +++++++++
 tools/lib/traceevent/event-parse.h                 |  25 +-
 tools/lib/traceevent/event-plugin.c                | 203 ++++++++++++++-
 tools/lib/traceevent/plugin_function.c             |  43 +++-
 tools/perf/Documentation/perf-report.txt           |  23 ++
 tools/perf/Documentation/perf-timechart.txt        |  41 ++-
 tools/perf/Makefile.perf                           |   6 +-
 tools/perf/builtin-inject.c                        |   2 +-
 tools/perf/builtin-probe.c                         |  23 +-
 tools/perf/config/Makefile                         |   6 +-
 tools/perf/perf.c                                  |   1 +
 tools/perf/tests/builtin-test.c                    |  42 +++-
 tools/perf/tests/dso-data.c                        | 214 +++++++++++++++-
 tools/perf/tests/dwarf-unwind.c                    |   2 +-
 tools/perf/tests/make                              |   7 +-
 tools/perf/tests/tests.h                           |   2 +
 tools/perf/util/dso.c                              | 279 +++++++++++++++++++--
 tools/perf/util/dso.h                              |  50 +++-
 tools/perf/util/event.c                            |  57 +++--
 tools/perf/util/event.h                            |   7 +
 tools/perf/util/evsel.c                            |   5 +-
 tools/perf/util/hist.c                             |   9 +-
 tools/perf/util/hist.h                             |   1 +
 tools/perf/util/machine.c                          |   4 +-
 tools/perf/util/map.c                              |   4 +-
 tools/perf/util/map.h                              |   4 +-
 tools/perf/util/perf_regs.c                        |  10 +-
 tools/perf/util/perf_regs.h                        |   4 +-
 tools/perf/util/probe-event.c                      |  13 +-
 tools/perf/util/probe-finder.c                     |  11 +-
 .../perf/util/scripting-engines/trace-event-perl.c |   1 +
 .../util/scripting-engines/trace-event-python.c    |   2 +
 tools/perf/util/sort.c                             | 107 ++++++++
 tools/perf/util/sort.h                             |   2 +
 tools/perf/util/unwind-libunwind.c                 |   2 -
 tools/perf/util/util.c                             |   1 +
 tools/perf/util/util.h                             |   1 +
 41 files changed, 1249 insertions(+), 126 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c6eb418..0d0e922 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -343,6 +343,7 @@ dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 	if (poke_int3_handler(regs))
 		return;
 
+	prev_state = exception_enter();
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 				SIGTRAP) == NOTIFY_STOP)
@@ -351,9 +352,8 @@ dotraplinkage void notrace do_int3(struct pt_regs *regs, long error_code)
 
 #ifdef CONFIG_KPROBES
 	if (kprobe_int3_handler(regs))
-		return;
+		goto exit;
 #endif
-	prev_state = exception_enter();
 
 	if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 			SIGTRAP) == NOTIFY_STOP)
@@ -433,6 +433,8 @@ dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 	unsigned long dr6;
 	int si_code;
 
+	prev_state = exception_enter();
+
 	get_debugreg(dr6, 6);
 
 	/* Filter out all the reserved bits which are preset to 1 */
@@ -465,7 +467,6 @@ dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 	if (kprobe_debug_handler(regs))
 		goto exit;
 #endif
-	prev_state = exception_enter();
 
 	if (notify_die(DIE_DEBUG, "debug", regs, (long)&dr6, error_code,
 							SIGTRAP) == NOTIFY_STOP)
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 5312fae..9269de2 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -705,6 +705,7 @@ enum perf_event_type {
 	 *	u32				min;
 	 *	u64				ino;
 	 *	u64				ino_generation;
+	 *	u32				prot, flags;
 	 *	char				filename[];
 	 * 	struct sample_id		sample_id;
 	 * };
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 019d450..5664985 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/hardirq.h>
 #include <linux/export.h>
+#include <linux/kprobes.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/context_tracking.h>
@@ -104,6 +105,7 @@ void context_tracking_user_enter(void)
 	}
 	local_irq_restore(flags);
 }
+NOKPROBE_SYMBOL(context_tracking_user_enter);
 
 #ifdef CONFIG_PREEMPT
 /**
@@ -181,6 +183,7 @@ void context_tracking_user_exit(void)
 	}
 	local_irq_restore(flags);
 }
+NOKPROBE_SYMBOL(context_tracking_user_exit);
 
 /**
  * __context_tracking_task_switch - context switch the syscall callbacks
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5fa58e4..a33d9a2b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -40,6 +40,7 @@
 #include <linux/mm_types.h>
 #include <linux/cgroup.h>
 #include <linux/module.h>
+#include <linux/mman.h>
 
 #include "internal.h"
 
@@ -5128,6 +5129,7 @@ struct perf_mmap_event {
 	int			maj, min;
 	u64			ino;
 	u64			ino_generation;
+	u32			prot, flags;
 
 	struct {
 		struct perf_event_header	header;
@@ -5169,6 +5171,8 @@ static void perf_event_mmap_output(struct perf_event *event,
 		mmap_event->event_id.header.size += sizeof(mmap_event->min);
 		mmap_event->event_id.header.size += sizeof(mmap_event->ino);
 		mmap_event->event_id.header.size += sizeof(mmap_event->ino_generation);
+		mmap_event->event_id.header.size += sizeof(mmap_event->prot);
+		mmap_event->event_id.header.size += sizeof(mmap_event->flags);
 	}
 
 	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
@@ -5187,6 +5191,8 @@ static void perf_event_mmap_output(struct perf_event *event,
 		perf_output_put(&handle, mmap_event->min);
 		perf_output_put(&handle, mmap_event->ino);
 		perf_output_put(&handle, mmap_event->ino_generation);
+		perf_output_put(&handle, mmap_event->prot);
+		perf_output_put(&handle, mmap_event->flags);
 	}
 
 	__output_copy(&handle, mmap_event->file_name,
@@ -5205,6 +5211,7 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	struct file *file = vma->vm_file;
 	int maj = 0, min = 0;
 	u64 ino = 0, gen = 0;
+	u32 prot = 0, flags = 0;
 	unsigned int size;
 	char tmp[16];
 	char *buf = NULL;
@@ -5235,6 +5242,28 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		gen = inode->i_generation;
 		maj = MAJOR(dev);
 		min = MINOR(dev);
+
+		if (vma->vm_flags & VM_READ)
+			prot |= PROT_READ;
+		if (vma->vm_flags & VM_WRITE)
+			prot |= PROT_WRITE;
+		if (vma->vm_flags & VM_EXEC)
+			prot |= PROT_EXEC;
+
+		if (vma->vm_flags & VM_MAYSHARE)
+			flags = MAP_SHARED;
+		else
+			flags = MAP_PRIVATE;
+
+		if (vma->vm_flags & VM_DENYWRITE)
+			flags |= MAP_DENYWRITE;
+		if (vma->vm_flags & VM_MAYEXEC)
+			flags |= MAP_EXECUTABLE;
+		if (vma->vm_flags & VM_LOCKED)
+			flags |= MAP_LOCKED;
+		if (vma->vm_flags & VM_HUGETLB)
+			flags |= MAP_HUGETLB;
+
 		goto got_name;
 	} else {
 		name = (char *)arch_vma_name(vma);
@@ -5275,6 +5304,8 @@ got_name:
 	mmap_event->min = min;
 	mmap_event->ino = ino;
 	mmap_event->ino_generation = gen;
+	mmap_event->prot = prot;
+	mmap_event->flags = flags;
 
 	if (!(vma->vm_flags & VM_EXEC))
 		mmap_event->event_id.header.misc |= PERF_RECORD_MISC_MMAP_DATA;
@@ -5315,6 +5346,8 @@ void perf_event_mmap(struct vm_area_struct *vma)
 		/* .min (attr_mmap2 only) */
 		/* .ino (attr_mmap2 only) */
 		/* .ino_generation (attr_mmap2 only) */
+		/* .prot (attr_mmap2 only) */
+		/* .flags (attr_mmap2 only) */
 	};
 
 	perf_event_mmap_event(&mmap_event);
@@ -6897,10 +6930,6 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (ret)
 		return -EFAULT;
 
-	/* disabled for now */
-	if (attr->mmap2)
-		return -EINVAL;
-
 	if (attr->__reserved_1)
 		return -EINVAL;
 
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b83184f..93825a1 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -765,6 +765,9 @@ static void free_arg(struct print_arg *arg)
 	case PRINT_BSTRING:
 		free(arg->string.string);
 		break;
+	case PRINT_BITMASK:
+		free(arg->bitmask.bitmask);
+		break;
 	case PRINT_DYNAMIC_ARRAY:
 		free(arg->dynarray.index);
 		break;
@@ -2268,6 +2271,7 @@ static int arg_num_eval(struct print_arg *arg, long long *val)
 	case PRINT_FIELD ... PRINT_SYMBOL:
 	case PRINT_STRING:
 	case PRINT_BSTRING:
+	case PRINT_BITMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		ret = 0;
@@ -2296,6 +2300,7 @@ static char *arg_eval (struct print_arg *arg)
 	case PRINT_FIELD ... PRINT_SYMBOL:
 	case PRINT_STRING:
 	case PRINT_BSTRING:
+	case PRINT_BITMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		break;
@@ -2683,6 +2688,35 @@ process_str(struct event_format *event __maybe_unused, struct print_arg *arg,
 	return EVENT_ERROR;
 }
 
+static enum event_type
+process_bitmask(struct event_format *event __maybe_unused, struct print_arg *arg,
+	    char **tok)
+{
+	enum event_type type;
+	char *token;
+
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto out_free;
+
+	arg->type = PRINT_BITMASK;
+	arg->bitmask.bitmask = token;
+	arg->bitmask.offset = -1;
+
+	if (read_expected(EVENT_DELIM, ")") < 0)
+		goto out_err;
+
+	type = read_token(&token);
+	*tok = token;
+
+	return type;
+
+ out_free:
+	free_token(token);
+ out_err:
+	*tok = NULL;
+	return EVENT_ERROR;
+}
+
 static struct pevent_function_handler *
 find_func_handler(struct pevent *pevent, char *func_name)
 {
@@ -2797,6 +2831,10 @@ process_function(struct event_format *event, struct print_arg *arg,
 		free_token(token);
 		return process_str(event, arg, tok);
 	}
+	if (strcmp(token, "__get_bitmask") == 0) {
+		free_token(token);
+		return process_bitmask(event, arg, tok);
+	}
 	if (strcmp(token, "__get_dynamic_array") == 0) {
 		free_token(token);
 		return process_dynamic_array(event, arg, tok);
@@ -3324,6 +3362,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		return eval_type(val, arg, 0);
 	case PRINT_STRING:
 	case PRINT_BSTRING:
+	case PRINT_BITMASK:
 		return 0;
 	case PRINT_FUNC: {
 		struct trace_seq s;
@@ -3556,6 +3595,60 @@ static void print_str_to_seq(struct trace_seq *s, const char *format,
 		trace_seq_printf(s, format, str);
 }
 
+static void print_bitmask_to_seq(struct pevent *pevent,
+				 struct trace_seq *s, const char *format,
+				 int len_arg, const void *data, int size)
+{
+	int nr_bits = size * 8;
+	int str_size = (nr_bits + 3) / 4;
+	int len = 0;
+	char buf[3];
+	char *str;
+	int index;
+	int i;
+
+	/*
+	 * The kernel likes to put in commas every 32 bits, we
+	 * can do the same.
+	 */
+	str_size += (nr_bits - 1) / 32;
+
+	str = malloc(str_size + 1);
+	if (!str) {
+		do_warning("%s: not enough memory!", __func__);
+		return;
+	}
+	str[str_size] = 0;
+
+	/* Start out with -2 for the two chars per byte */
+	for (i = str_size - 2; i >= 0; i -= 2) {
+		/*
+		 * data points to a bit mask of size bytes.
+		 * In the kernel, this is an array of long words, thus
+		 * endianess is very important.
+		 */
+		if (pevent->file_bigendian)
+			index = size - (len + 1);
+		else
+			index = len;
+
+		snprintf(buf, 3, "%02x", *((unsigned char *)data + index));
+		memcpy(str + i, buf, 2);
+		len++;
+		if (!(len & 3) && i > 0) {
+			i--;
+			str[i] = ',';
+		}
+	}
+
+	if (len_arg >= 0)
+		trace_seq_printf(s, format, len_arg, str);
+	else
+		trace_seq_printf(s, format, str);
+
+	free(str);
+}
+
 static void print_str_arg(struct trace_seq *s, void *data, int size,
 			  struct event_format *event, const char *format,
 			  int len_arg, struct print_arg *arg)
@@ -3691,6 +3784,23 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case PRINT_BSTRING:
 		print_str_to_seq(s, format, len_arg, arg->string.string);
 		break;
+	case PRINT_BITMASK: {
+		int bitmask_offset;
+		int bitmask_size;
+
+		if (arg->bitmask.offset == -1) {
+			struct format_field *f;
+
+			f = pevent_find_any_field(event, arg->bitmask.bitmask);
+			arg->bitmask.offset = f->offset;
+		}
+		bitmask_offset = data2host4(pevent, data + arg->bitmask.offset);
+		bitmask_size = bitmask_offset >> 16;
+		bitmask_offset &= 0xffff;
+		print_bitmask_to_seq(pevent, s, format, len_arg,
+				     data + bitmask_offset, bitmask_size);
+		break;
+	}
 	case PRINT_OP:
 		/*
 		 * The only op for string should be ? :
@@ -4822,6 +4932,9 @@ static void print_args(struct print_arg *args)
 	case PRINT_BSTRING:
 		printf("__get_str(%s)", args->string.string);
 		break;
+	case PRINT_BITMASK:
+		printf("__get_bitmask(%s)", args->bitmask.bitmask);
+		break;
 	case PRINT_TYPE:
 		printf("(%s)", args->typecast.type);
 		print_args(args->typecast.item);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index feab942..7a3873f 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -107,8 +107,8 @@ typedef int (*pevent_event_handler_func)(struct trace_seq *s,
 typedef int (*pevent_plugin_load_func)(struct pevent *pevent);
 typedef int (*pevent_plugin_unload_func)(struct pevent *pevent);
 
-struct plugin_option {
-	struct plugin_option		*next;
+struct pevent_plugin_option {
+	struct pevent_plugin_option	*next;
 	void				*handle;
 	char				*file;
 	char				*name;
@@ -135,7 +135,7 @@ struct plugin_option {
  * PEVENT_PLUGIN_OPTIONS:  (optional)
  *   Plugin options that can be set before loading
  *
- *   struct plugin_option PEVENT_PLUGIN_OPTIONS[] = {
+ *   struct pevent_plugin_option PEVENT_PLUGIN_OPTIONS[] = {
  *	{
  *		.name = "option-name",
  *		.plugin_alias = "overide-file-name", (optional)
@@ -208,6 +208,11 @@ struct print_arg_string {
 	int			offset;
 };
 
+struct print_arg_bitmask {
+	char			*bitmask;
+	int			offset;
+};
+
 struct print_arg_field {
 	char			*name;
 	struct format_field	*field;
@@ -274,6 +279,7 @@ enum print_arg_type {
 	PRINT_DYNAMIC_ARRAY,
 	PRINT_OP,
 	PRINT_FUNC,
+	PRINT_BITMASK,
 };
 
 struct print_arg {
@@ -288,6 +294,7 @@ struct print_arg {
 		struct print_arg_hex		hex;
 		struct print_arg_func		func;
 		struct print_arg_string		string;
+		struct print_arg_bitmask	bitmask;
 		struct print_arg_op		op;
 		struct print_arg_dynarray	dynarray;
 	};
@@ -354,6 +361,8 @@ enum pevent_func_arg_type {
 
 enum pevent_flag {
 	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
+	PEVENT_DISABLE_SYS_PLUGINS	= 1 << 1,
+	PEVENT_DISABLE_PLUGINS		= 1 << 2,
 };
 
 #define PEVENT_ERRORS 							      \
@@ -410,9 +419,19 @@ enum pevent_errno {
 
 struct plugin_list;
 
+#define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
+
 struct plugin_list *traceevent_load_plugins(struct pevent *pevent);
 void traceevent_unload_plugins(struct plugin_list *plugin_list,
 			       struct pevent *pevent);
+char **traceevent_plugin_list_options(void);
+void traceevent_plugin_free_options_list(char **list);
+int traceevent_plugin_add_options(const char *name,
+				  struct pevent_plugin_option *options);
+void traceevent_plugin_remove_options(struct pevent_plugin_option *options);
+void traceevent_print_plugins(struct trace_seq *s,
+			      const char *prefix, const char *suffix,
+			      const struct plugin_list *list);
 
 struct cmdline;
 struct cmdline_list;
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 0c8bf67..136162c 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -18,6 +18,7 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
+#include <stdio.h>
 #include <string.h>
 #include <dlfcn.h>
 #include <stdlib.h>
@@ -30,12 +31,207 @@
 
 #define LOCAL_PLUGIN_DIR ".traceevent/plugins"
 
+static struct registered_plugin_options {
+	struct registered_plugin_options	*next;
+	struct pevent_plugin_option		*options;
+} *registered_options;
+
+static struct trace_plugin_options {
+	struct trace_plugin_options	*next;
+	char				*plugin;
+	char				*option;
+	char				*value;
+} *trace_plugin_options;
+
 struct plugin_list {
 	struct plugin_list	*next;
 	char			*name;
 	void			*handle;
 };
 
+/**
+ * traceevent_plugin_list_options - get list of plugin options
+ *
+ * Returns an array of char strings that list the currently registered
+ * plugin options in the format of <plugin>:<option>. This list can be
+ * used by toggling the option.
+ *
+ * Returns NULL if there's no options registered. On error it returns
+ * INVALID_PLUGIN_LIST_OPTION
+ *
+ * Must be freed with traceevent_plugin_free_options_list().
+ */
+char **traceevent_plugin_list_options(void)
+{
+	struct registered_plugin_options *reg;
+	struct pevent_plugin_option *op;
+	char **list = NULL;
+	char *name;
+	int count = 0;
+
+	for (reg = registered_options; reg; reg = reg->next) {
+		for (op = reg->options; op->name; op++) {
+			char *alias = op->plugin_alias ? op->plugin_alias : op->file;
+			char **temp = list;
+
+			name = malloc(strlen(op->name) + strlen(alias) + 2);
+			if (!name)
+				goto err;
+
+			sprintf(name, "%s:%s", alias, op->name);
+			list = realloc(list, count + 2);
+			if (!list) {
+				list = temp;
+				free(name);
+				goto err;
+			}
+			list[count++] = name;
+			list[count] = NULL;
+		}
+	}
+	return list;
+
+ err:
+	while (--count >= 0)
+		free(list[count]);
+	free(list);
+
+	return INVALID_PLUGIN_LIST_OPTION;
+}
+
+void traceevent_plugin_free_options_list(char **list)
+{
+	int i;
+
+	if (!list)
+		return;
+
+	if (list == INVALID_PLUGIN_LIST_OPTION)
+		return;
+
+	for (i = 0; list[i]; i++)
+		free(list[i]);
+
+	free(list);
+}
+
+static int
+update_option(const char *file, struct pevent_plugin_option *option)
+{
+	struct trace_plugin_options *op;
+	char *plugin;
+
+	if (option->plugin_alias) {
+		plugin = strdup(option->plugin_alias);
+		if (!plugin)
+			return -1;
+	} else {
+		char *p;
+		plugin = strdup(file);
+		if (!plugin)
+			return -1;
+		p = strstr(plugin, ".");
+		if (p)
+			*p = '\0';
+	}
+
+	/* first look for named options */
+	for (op = trace_plugin_options; op; op = op->next) {
+		if (!op->plugin)
+			continue;
+		if (strcmp(op->plugin, plugin) != 0)
+			continue;
+		if (strcmp(op->option, option->name) != 0)
+			continue;
+
+		option->value = op->value;
+		option->set ^= 1;
+		goto out;
+	}
+
+	/* first look for unnamed options */
+	for (op = trace_plugin_options; op; op = op->next) {
+		if (op->plugin)
+			continue;
+		if (strcmp(op->option, option->name) != 0)
+			continue;
+
+		option->value = op->value;
+		option->set ^= 1;
+		break;
+	}
+
+ out:
+	free(plugin);
+	return 0;
+}
+
+/**
+ * traceevent_plugin_add_options - Add a set of options by a plugin
+ * @name: The name of the plugin adding the options
+ * @options: The set of options being loaded
+ *
+ * Sets the options with the values that have been added by user.
+ */
+int traceevent_plugin_add_options(const char *name,
+				  struct pevent_plugin_option *options)
+{
+	struct registered_plugin_options *reg;
+
+	reg = malloc(sizeof(*reg));
+	if (!reg)
+		return -1;
+	reg->next = registered_options;
+	reg->options = options;
+	registered_options = reg;
+
+	while (options->name) {
+		update_option(name, options);
+		options++;
+	}
+	return 0;
+}
+
+/**
+ * traceevent_plugin_remove_options - remove plugin options that were registered
+ * @options: Options to removed that were registered with traceevent_plugin_add_options
+ */
+void traceevent_plugin_remove_options(struct pevent_plugin_option *options)
+{
+	struct registered_plugin_options **last;
+	struct registered_plugin_options *reg;
+
+	for (last = &registered_options; *last; last = &(*last)->next) {
+		if ((*last)->options == options) {
+			reg = *last;
+			*last = reg->next;
+			free(reg);
+			return;
+		}
+	}
+}
+
+/**
+ * traceevent_print_plugins - print out the list of plugins loaded
+ * @s: the trace_seq descripter to write to
+ * @prefix: The prefix string to add before listing the option name
+ * @suffix: The suffix string ot append after the option name
+ * @list: The list of plugins (usually returned by traceevent_load_plugins()
+ *
+ * Writes to the trace_seq @s the list of plugins (files) that is
+ * returned by traceevent_load_plugins(). Use @prefix and @suffix for formating:
+ * @prefix = "  ", @suffix = "\n".
+ */
+void traceevent_print_plugins(struct trace_seq *s,
+			      const char *prefix, const char *suffix,
+			      const struct plugin_list *list)
+{
+	while (list) {
+		trace_seq_printf(s, "%s%s%s", prefix, list->name, suffix);
+		list = list->next;
+	}
+}
+
 static void
 load_plugin(struct pevent *pevent, const char *path,
 	    const char *file, void *data)
@@ -148,12 +344,17 @@ load_plugins(struct pevent *pevent, const char *suffix,
 	char *path;
 	char *envdir;
 
+	if (pevent->flags & PEVENT_DISABLE_PLUGINS)
+		return;
+
 	/*
 	 * If a system plugin directory was defined,
 	 * check that first.
 	 */
 #ifdef PLUGIN_DIR
-	load_plugins_dir(pevent, suffix, PLUGIN_DIR, load_plugin, data);
+	if (!(pevent->flags & PEVENT_DISABLE_SYS_PLUGINS))
+		load_plugins_dir(pevent, suffix, PLUGIN_DIR,
+				 load_plugin, data);
 #endif
 
 	/*
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 80ba4ff..a00ec19 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -33,6 +33,29 @@ static int cpus = -1;
 
 #define STK_BLK 10
 
+struct pevent_plugin_option plugin_options[] =
+{
+	{
+		.name = "parent",
+		.plugin_alias = "ftrace",
+		.description =
+		"Print parent of functions for function events",
+	},
+	{
+		.name = "indent",
+		.plugin_alias = "ftrace",
+		.description =
+		"Try to show function call indents, based on parents",
+		.set = 1,
+	},
+	{
+		.name = NULL,
+	}
+};
+
+static struct pevent_plugin_option *ftrace_parent = &plugin_options[0];
+static struct pevent_plugin_option *ftrace_indent = &plugin_options[1];
+
 static void add_child(struct func_stack *stack, const char *child, int pos)
 {
 	int i;
@@ -119,7 +142,8 @@ static int function_handler(struct trace_seq *s, struct pevent_record *record,
 
 	parent = pevent_find_function(pevent, pfunction);
 
-	index = add_and_get_index(parent, func, record->cpu);
+	if (parent && ftrace_indent->set)
+		index = add_and_get_index(parent, func, record->cpu);
 
 	trace_seq_printf(s, "%*s", index*3, "");
 
@@ -128,11 +152,13 @@ static int function_handler(struct trace_seq *s, struct pevent_record *record,
 	else
 		trace_seq_printf(s, "0x%llx", function);
 
-	trace_seq_printf(s, " <-- ");
-	if (parent)
-		trace_seq_printf(s, "%s", parent);
-	else
-		trace_seq_printf(s, "0x%llx", pfunction);
+	if (ftrace_parent->set) {
+		trace_seq_printf(s, " <-- ");
+		if (parent)
+			trace_seq_printf(s, "%s", parent);
+		else
+			trace_seq_printf(s, "0x%llx", pfunction);
+	}
 
 	return 0;
 }
@@ -141,6 +167,9 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 {
 	pevent_register_event_handler(pevent, -1, "ftrace", "function",
 				      function_handler, NULL);
+
+	traceevent_plugin_add_options("ftrace", plugin_options);
+
 	return 0;
 }
 
@@ -157,6 +186,8 @@ void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
 		free(fstack[i].stack);
 	}
 
+	traceevent_plugin_remove_options(plugin_options);
+
 	free(fstack);
 	fstack = NULL;
 	cpus = -1;
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index cefdf43..d2b59af 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -117,6 +117,22 @@ OPTIONS
 	By default, every sort keys not specified in -F will be appended
 	automatically.
 
+	If --mem-mode option is used, following sort keys are also available
+	(incompatible with --branch-stack):
+	symbol_daddr, dso_daddr, locked, tlb, mem, snoop, dcacheline.
+
+	- symbol_daddr: name of data symbol being executed on at the time of sample
+	- dso_daddr: name of library or module containing the data being executed
+	on at the time of sample
+	- locked: whether the bus was locked at the time of sample
+	- tlb: type of tlb access for the data at the time of sample
+	- mem: type of memory access for the data at the time of sample
+	- snoop: type of snoop (if any) for the data at the time of sample
+	- dcacheline: the cacheline the data address is on at the time of sample
+
+	And default sort keys are changed to local_weight, mem, sym, dso,
+	symbol_daddr, dso_daddr, snoop, tlb, locked, see '--mem-mode'.
+
 -p::
 --parent=<regex>::
         A regex filter to identify parent. The parent is a caller of this
@@ -260,6 +276,13 @@ OPTIONS
 	Demangle symbol names to human readable form. It's enabled by default,
 	disable with --no-demangle.
 
+--mem-mode::
+	Use the data addresses of samples in addition to instruction addresses
+	to build the histograms.  To generate meaningful output, the perf.data
+	file must have been obtained using perf record -d -W and using a
+	special event -e cpu/mem-loads/ or -e cpu/mem-stores/. See
+	'perf mem' for simpler access.
+
 --percent-limit::
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index bc5990c..5e0f986 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -43,27 +43,6 @@ TIMECHART OPTIONS
 
 --symfs=<directory>::
         Look for files with symbols relative to this directory.
-
-EXAMPLES
---------
-
-$ perf timechart record git pull
-
-  [ perf record: Woken up 13 times to write data ]
-  [ perf record: Captured and wrote 4.253 MB perf.data (~185801 samples) ]
-
-$ perf timechart
-
-  Written 10.2 seconds of trace to output.svg.
-
-Record system-wide timechart:
-
-  $ perf timechart record
-
-  then generate timechart and highlight 'gcc' tasks:
-
-  $ perf timechart --highlight gcc
-
 -n::
 --proc-num::
         Print task info for at least given number of tasks.
@@ -88,6 +67,26 @@ RECORD OPTIONS
 --callchain::
         Do call-graph (stack chain/backtrace) recording
 
+EXAMPLES
+--------
+
+$ perf timechart record git pull
+
+  [ perf record: Woken up 13 times to write data ]
+  [ perf record: Captured and wrote 4.253 MB perf.data (~185801 samples) ]
+
+$ perf timechart
+
+  Written 10.2 seconds of trace to output.svg.
+
+Record system-wide timechart:
+
+  $ perf timechart record
+
+  then generate timechart and highlight 'gcc' tasks:
+
+  $ perf timechart --highlight gcc
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index ae20edf..9670a16 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -819,15 +819,15 @@ TAG_FOLDERS= . ../lib/traceevent ../lib/api ../lib/symbol
 TAG_FILES= ../../include/uapi/linux/perf_event.h
 
 TAGS:
-	$(RM) TAGS
+	$(QUIET_GEN)$(RM) TAGS; \
 	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs etags -a $(TAG_FILES)
 
 tags:
-	$(RM) tags
+	$(QUIET_GEN)$(RM) tags; \
 	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs ctags -a $(TAG_FILES)
 
 cscope:
-	$(RM) cscope*
+	$(QUIET_GEN)$(RM) cscope*; \
 	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs cscope -b $(TAG_FILES)
 
 ### Detect prefix changes
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 6a3af00..16c7c11 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -72,7 +72,7 @@ static int perf_event__repipe_attr(struct perf_tool *tool,
 	if (ret)
 		return ret;
 
-	if (&inject->output.is_pipe)
+	if (!inject->output.is_pipe)
 		return 0;
 
 	return perf_event__repipe_synth(tool, event);
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index cdcd4eb..c63fa29 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -288,6 +288,13 @@ static void cleanup_params(void)
 	memset(&params, 0, sizeof(params));
 }
 
+static void pr_err_with_code(const char *msg, int err)
+{
+	pr_err("%s", msg);
+	pr_debug(" Reason: %s (Code: %d)", strerror(-err), err);
+	pr_err("\n");
+}
+
 static int
 __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 {
@@ -379,7 +386,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		}
 		ret = parse_probe_event_argv(argc, argv);
 		if (ret < 0) {
-			pr_err("  Error: Parse Error.  (%d)\n", ret);
+			pr_err_with_code("  Error: Command Parse Error.", ret);
 			return ret;
 		}
 	}
@@ -419,8 +426,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		}
 		ret = show_perf_probe_events();
 		if (ret < 0)
-			pr_err("  Error: Failed to show event list. (%d)\n",
-			       ret);
+			pr_err_with_code("  Error: Failed to show event list.", ret);
 		return ret;
 	}
 	if (params.show_funcs) {
@@ -445,8 +451,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		strfilter__delete(params.filter);
 		params.filter = NULL;
 		if (ret < 0)
-			pr_err("  Error: Failed to show functions."
-			       " (%d)\n", ret);
+			pr_err_with_code("  Error: Failed to show functions.", ret);
 		return ret;
 	}
 
@@ -464,7 +469,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 
 		ret = show_line_range(&params.line_range, params.target);
 		if (ret < 0)
-			pr_err("  Error: Failed to show lines. (%d)\n", ret);
+			pr_err_with_code("  Error: Failed to show lines.", ret);
 		return ret;
 	}
 	if (params.show_vars) {
@@ -485,7 +490,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		strfilter__delete(params.filter);
 		params.filter = NULL;
 		if (ret < 0)
-			pr_err("  Error: Failed to show vars. (%d)\n", ret);
+			pr_err_with_code("  Error: Failed to show vars.", ret);
 		return ret;
 	}
 #endif
@@ -493,7 +498,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (params.dellist) {
 		ret = del_perf_probe_events(params.dellist);
 		if (ret < 0) {
-			pr_err("  Error: Failed to delete events. (%d)\n", ret);
+			pr_err_with_code("  Error: Failed to delete events.", ret);
 			return ret;
 		}
 	}
@@ -504,7 +509,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 					    params.target,
 					    params.force_add);
 		if (ret < 0) {
-			pr_err("  Error: Failed to add events. (%d)\n", ret);
+			pr_err_with_code("  Error: Failed to add events.", ret);
 			return ret;
 		}
 	}
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 4f100b5..f30ac5e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -299,7 +299,11 @@ else
       NO_LIBUNWIND := 1
       NO_LIBDW_DWARF_UNWIND := 1
     else
-      msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
+      ifneq ($(filter s% -static%,$(LDFLAGS),),)
+        msg := $(error No static glibc found, please install glibc-static);
+      else
+        msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]);
+      endif
     endif
   else
     ifndef NO_LIBDW_DWARF_UNWIND
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 78f7b92..95c58fc 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -458,6 +458,7 @@ int main(int argc, const char **argv)
 
 	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
+	cacheline_size = sysconf(_SC_LEVEL1_DCACHE_LINESIZE);
 
 	cmd = perf_extract_argv0_path(argv[0]);
 	if (!cmd)
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 802e3cd..6f8b01b 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -3,6 +3,8 @@
  *
  * Builtin regression testing command: ever growing number of sanity tests
  */
+#include <unistd.h>
+#include <string.h>
 #include "builtin.h"
 #include "intlist.h"
 #include "tests.h"
@@ -50,10 +52,18 @@ static struct test {
 		.func = test__pmu,
 	},
 	{
-		.desc = "Test dso data interface",
+		.desc = "Test dso data read",
 		.func = test__dso_data,
 	},
 	{
+		.desc = "Test dso data cache",
+		.func = test__dso_data_cache,
+	},
+	{
+		.desc = "Test dso data reopen",
+		.func = test__dso_data_reopen,
+	},
+	{
 		.desc = "roundtrip evsel->name check",
 		.func = test__perf_evsel__roundtrip_name_test,
 	},
@@ -172,6 +182,34 @@ static bool perf_test__matches(int curr, int argc, const char *argv[])
 	return false;
 }
 
+static int run_test(struct test *test)
+{
+	int status, err = -1, child = fork();
+
+	if (child < 0) {
+		pr_err("failed to fork test: %s\n", strerror(errno));
+		return -1;
+	}
+
+	if (!child) {
+		pr_debug("test child forked, pid %d\n", getpid());
+		err = test->func();
+		exit(err);
+	}
+
+	wait(&status);
+
+	if (WIFEXITED(status)) {
+		err = WEXITSTATUS(status);
+		pr_debug("test child finished with %d\n", err);
+	} else if (WIFSIGNALED(status)) {
+		err = -1;
+		pr_debug("test child interrupted\n");
+	}
+
+	return err;
+}
+
 static int __cmd_test(int argc, const char *argv[], struct intlist *skiplist)
 {
 	int i = 0;
@@ -200,7 +238,7 @@ static int __cmd_test(int argc, const char *argv[], struct intlist *skiplist)
 		}
 
 		pr_debug("\n--- start ---\n");
-		err = tests[curr].func();
+		err = run_test(&tests[curr]);
 		pr_debug("---- end ----\n%s:", tests[curr].desc);
 
 		switch (err) {
diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index 3e6cb17..630808c 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -1,22 +1,27 @@
-#include "util.h"
-
 #include <stdlib.h>
 #include <linux/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <string.h>
-
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <api/fs/fs.h>
+#include "util.h"
 #include "machine.h"
 #include "symbol.h"
 #include "tests.h"
 
 static char *test_file(int size)
 {
-	static char buf_templ[] = "/tmp/test-XXXXXX";
+#define TEMPL "/tmp/perf-test-XXXXXX"
+	static char buf_templ[sizeof(TEMPL)];
 	char *templ = buf_templ;
 	int fd, i;
 	unsigned char *buf;
 
+	strcpy(buf_templ, TEMPL);
+#undef TEMPL
+
 	fd = mkstemp(templ);
 	if (fd < 0) {
 		perror("mkstemp failed");
@@ -150,3 +155,204 @@ int test__dso_data(void)
 	unlink(file);
 	return 0;
 }
+
+static long open_files_cnt(void)
+{
+	char path[PATH_MAX];
+	struct dirent *dent;
+	DIR *dir;
+	long nr = 0;
+
+	scnprintf(path, PATH_MAX, "%s/self/fd", procfs__mountpoint());
+	pr_debug("fd path: %s\n", path);
+
+	dir = opendir(path);
+	TEST_ASSERT_VAL("failed to open fd directory", dir);
+
+	while ((dent = readdir(dir)) != NULL) {
+		if (!strcmp(dent->d_name, ".") ||
+		    !strcmp(dent->d_name, ".."))
+			continue;
+
+		nr++;
+	}
+
+	closedir(dir);
+	return nr - 1;
+}
+
+static struct dso **dsos;
+
+static int dsos__create(int cnt, int size)
+{
+	int i;
+
+	dsos = malloc(sizeof(dsos) * cnt);
+	TEST_ASSERT_VAL("failed to alloc dsos array", dsos);
+
+	for (i = 0; i < cnt; i++) {
+		char *file;
+
+		file = test_file(size);
+		TEST_ASSERT_VAL("failed to get dso file", file);
+
+		dsos[i] = dso__new(file);
+		TEST_ASSERT_VAL("failed to get dso", dsos[i]);
+	}
+
+	return 0;
+}
+
+static void dsos__delete(int cnt)
+{
+	int i;
+
+	for (i = 0; i < cnt; i++) {
+		struct dso *dso = dsos[i];
+
+		unlink(dso->name);
+		dso__delete(dso);
+	}
+
+	free(dsos);
+}
+
+static int set_fd_limit(int n)
+{
+	struct rlimit rlim;
+
+	if (getrlimit(RLIMIT_NOFILE, &rlim))
+		return -1;
+
+	pr_debug("file limit %ld, new %d\n", (long) rlim.rlim_cur, n);
+
+	rlim.rlim_cur = n;
+	return setrlimit(RLIMIT_NOFILE, &rlim);
+}
+
+int test__dso_data_cache(void)
+{
+	struct machine machine;
+	long nr_end, nr = open_files_cnt();
+	int dso_cnt, limit, i, fd;
+
+	memset(&machine, 0, sizeof(machine));
+
+	/* set as system limit */
+	limit = nr * 4;
+	TEST_ASSERT_VAL("failed to set file limit", !set_fd_limit(limit));
+
+	/* and this is now our dso open FDs limit + 1 extra */
+	dso_cnt = limit / 2 + 1;
+	TEST_ASSERT_VAL("failed to create dsos\n",
+		!dsos__create(dso_cnt, TEST_FILE_SIZE));
+
+	for (i = 0; i < (dso_cnt - 1); i++) {
+		struct dso *dso = dsos[i];
+
+		/*
+		 * Open dsos via dso__data_fd or dso__data_read_offset.
+		 * Both opens the data file and keep it open.
+		 */
+		if (i % 2) {
+			fd = dso__data_fd(dso, &machine);
+			TEST_ASSERT_VAL("failed to get fd", fd > 0);
+		} else {
+			#define BUFSIZE 10
+			u8 buf[BUFSIZE];
+			ssize_t n;
+
+			n = dso__data_read_offset(dso, &machine, 0, buf, BUFSIZE);
+			TEST_ASSERT_VAL("failed to read dso", n == BUFSIZE);
+		}
+	}
+
+	/* open +1 dso over the allowed limit */
+	fd = dso__data_fd(dsos[i], &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	/* should force the first one to be closed */
+	TEST_ASSERT_VAL("failed to close dsos[0]", dsos[0]->data.fd == -1);
+
+	/* cleanup everything */
+	dsos__delete(dso_cnt);
+
+	/* Make sure we did not leak any file descriptor. */
+	nr_end = open_files_cnt();
+	pr_debug("nr start %ld, nr stop %ld\n", nr, nr_end);
+	TEST_ASSERT_VAL("failed leadking files", nr == nr_end);
+	return 0;
+}
+
+int test__dso_data_reopen(void)
+{
+	struct machine machine;
+	long nr_end, nr = open_files_cnt();
+	int fd, fd_extra;
+
+#define dso_0 (dsos[0])
+#define dso_1 (dsos[1])
+#define dso_2 (dsos[2])
+
+	memset(&machine, 0, sizeof(machine));
+
+	/*
+	 * Test scenario:
+	 * - create 3 dso objects
+	 * - set process file descriptor limit to current
+	 *   files count + 3
+	 * - test that the first dso gets closed when we
+	 *   reach the files count limit
+	 */
+
+	/* Make sure we are able to open 3 fds anyway */
+	TEST_ASSERT_VAL("failed to set file limit",
+			!set_fd_limit((nr + 3)));
+
+	TEST_ASSERT_VAL("failed to create dsos\n", !dsos__create(3, TEST_FILE_SIZE));
+
+	/* open dso_0 */
+	fd = dso__data_fd(dso_0, &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	/* open dso_1 */
+	fd = dso__data_fd(dso_1, &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	/*
+	 * open extra file descriptor and we just
+	 * reached the files count limit
+	 */
+	fd_extra = open("/dev/null", O_RDONLY);
+	TEST_ASSERT_VAL("failed to open extra fd", fd_extra > 0);
+
+	/* open dso_2 */
+	fd = dso__data_fd(dso_2, &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	/*
+	 * dso_0 should get closed, because we reached
+	 * the file descriptor limit
+	 */
+	TEST_ASSERT_VAL("failed to close dso_0", dso_0->data.fd == -1);
+
+	/* open dso_0 */
+	fd = dso__data_fd(dso_0, &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	/*
+	 * dso_1 should get closed, because we reached
+	 * the file descriptor limit
+	 */
+	TEST_ASSERT_VAL("failed to close dso_1", dso_1->data.fd == -1);
+
+	/* cleanup everything */
+	close(fd_extra);
+	dsos__delete(3);
+
+	/* Make sure we did not leak any file descriptor. */
+	nr_end = open_files_cnt();
+	pr_debug("nr start %ld, nr stop %ld\n", nr, nr_end);
+	TEST_ASSERT_VAL("failed leadking files", nr == nr_end);
+	return 0;
+}
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index 108f0cd..96adb73 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -15,7 +15,7 @@ static int mmap_handler(struct perf_tool *tool __maybe_unused,
 			struct perf_sample *sample __maybe_unused,
 			struct machine *machine)
 {
-	return machine__process_mmap_event(machine, event, NULL);
+	return machine__process_mmap2_event(machine, event, NULL);
 }
 
 static int init_live_machine(struct machine *machine)
diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 2f92d6e..69a71ff 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -205,8 +205,7 @@ $(run):
 	( eval $$cmd ) >> $@ 2>&1; \
 	echo "  test: $(call test,$@)" >> $@ 2>&1; \
 	$(call test,$@) && \
-	rm -f $@ \
-	rm -rf $$TMP_DEST
+	rm -rf $@ $$TMP_DEST || (cat $@ ; false)
 
 $(run_O):
 	$(call clean)
@@ -217,9 +216,7 @@ $(run_O):
 	( eval $$cmd ) >> $@ 2>&1 && \
 	echo "  test: $(call test_O,$@)" >> $@ 2>&1; \
 	$(call test_O,$@) && \
-	rm -f $@ && \
-	rm -rf $$TMP_O \
-	rm -rf $$TMP_DEST
+	rm -rf $@ $$TMP_O $$TMP_DEST || (cat $@ ; false)
 
 tarpkg:
 	@cmd="$(PERF)/tests/perf-targz-src-pkg $(PERF)"; \
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 022bb68..ed64790 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -28,6 +28,8 @@ int test__syscall_open_tp_fields(void);
 int test__pmu(void);
 int test__attr(void);
 int test__dso_data(void);
+int test__dso_data_cache(void);
+int test__dso_data_reopen(void);
 int test__parse_events(void);
 int test__hists_link(void);
 int test__python_use(void);
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 64453d6..819f104 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1,3 +1,6 @@
+#include <asm/bug.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 #include "symbol.h"
 #include "dso.h"
 #include "machine.h"
@@ -136,7 +139,48 @@ int dso__read_binary_type_filename(const struct dso *dso,
 	return ret;
 }
 
-static int open_dso(struct dso *dso, struct machine *machine)
+/*
+ * Global list of open DSOs and the counter.
+ */
+static LIST_HEAD(dso__data_open);
+static long dso__data_open_cnt;
+
+static void dso__list_add(struct dso *dso)
+{
+	list_add_tail(&dso->data.open_entry, &dso__data_open);
+	dso__data_open_cnt++;
+}
+
+static void dso__list_del(struct dso *dso)
+{
+	list_del(&dso->data.open_entry);
+	WARN_ONCE(dso__data_open_cnt <= 0,
+		  "DSO data fd counter out of bounds.");
+	dso__data_open_cnt--;
+}
+
+static void close_first_dso(void);
+
+static int do_open(char *name)
+{
+	int fd;
+
+	do {
+		fd = open(name, O_RDONLY);
+		if (fd >= 0)
+			return fd;
+
+		pr_debug("dso open failed, mmap: %s\n", strerror(errno));
+		if (!dso__data_open_cnt || errno != EMFILE)
+			break;
+
+		close_first_dso();
+	} while (1);
+
+	return -1;
+}
+
+static int __open_dso(struct dso *dso, struct machine *machine)
 {
 	int fd;
 	char *root_dir = (char *)"";
@@ -154,11 +198,130 @@ static int open_dso(struct dso *dso, struct machine *machine)
 		return -EINVAL;
 	}
 
-	fd = open(name, O_RDONLY);
+	fd = do_open(name);
 	free(name);
 	return fd;
 }
 
+static void check_data_close(void);
+
+/**
+ * dso_close - Open DSO data file
+ * @dso: dso object
+ *
+ * Open @dso's data file descriptor and updates
+ * list/count of open DSO objects.
+ */
+static int open_dso(struct dso *dso, struct machine *machine)
+{
+	int fd = __open_dso(dso, machine);
+
+	if (fd > 0) {
+		dso__list_add(dso);
+		/*
+		 * Check if we crossed the allowed number
+		 * of opened DSOs and close one if needed.
+		 */
+		check_data_close();
+	}
+
+	return fd;
+}
+
+static void close_data_fd(struct dso *dso)
+{
+	if (dso->data.fd >= 0) {
+		close(dso->data.fd);
+		dso->data.fd = -1;
+		dso->data.file_size = 0;
+		dso__list_del(dso);
+	}
+}
+
+/**
+ * dso_close - Close DSO data file
+ * @dso: dso object
+ *
+ * Close @dso's data file descriptor and updates
+ * list/count of open DSO objects.
+ */
+static void close_dso(struct dso *dso)
+{
+	close_data_fd(dso);
+}
+
+static void close_first_dso(void)
+{
+	struct dso *dso;
+
+	dso = list_first_entry(&dso__data_open, struct dso, data.open_entry);
+	close_dso(dso);
+}
+
+static rlim_t get_fd_limit(void)
+{
+	struct rlimit l;
+	rlim_t limit = 0;
+
+	/* Allow half of the current open fd limit. */
+	if (getrlimit(RLIMIT_NOFILE, &l) == 0) {
+		if (l.rlim_cur == RLIM_INFINITY)
+			limit = l.rlim_cur;
+		else
+			limit = l.rlim_cur / 2;
+	} else {
+		pr_err("failed to get fd limit\n");
+		limit = 1;
+	}
+
+	return limit;
+}
+
+static bool may_cache_fd(void)
+{
+	static rlim_t limit;
+
+	if (!limit)
+		limit = get_fd_limit();
+
+	if (limit == RLIM_INFINITY)
+		return true;
+
+	return limit > (rlim_t) dso__data_open_cnt;
+}
+
+/*
+ * Check and close LRU dso if we crossed allowed limit
+ * for opened dso file descriptors. The limit is half
+ * of the RLIMIT_NOFILE files opened.
+*/
+static void check_data_close(void)
+{
+	bool cache_fd = may_cache_fd();
+
+	if (!cache_fd)
+		close_first_dso();
+}
+
+/**
+ * dso__data_close - Close DSO data file
+ * @dso: dso object
+ *
+ * External interface to close @dso's data file descriptor.
+ */
+void dso__data_close(struct dso *dso)
+{
+	close_dso(dso);
+}
+
+/**
+ * dso__data_fd - Get dso's data file descriptor
+ * @dso: dso object
+ * @machine: machine object
+ *
+ * External interface to find dso's file, open it and
+ * returns file descriptor.
+ */
 int dso__data_fd(struct dso *dso, struct machine *machine)
 {
 	enum dso_binary_type binary_type_data[] = {
@@ -168,8 +331,13 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 	};
 	int i = 0;
 
-	if (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND)
-		return open_dso(dso, machine);
+	if (dso->data.fd >= 0)
+		return dso->data.fd;
+
+	if (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND) {
+		dso->data.fd = open_dso(dso, machine);
+		return dso->data.fd;
+	}
 
 	do {
 		int fd;
@@ -178,7 +346,7 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 
 		fd = open_dso(dso, machine);
 		if (fd >= 0)
-			return fd;
+			return dso->data.fd = fd;
 
 	} while (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND);
 
@@ -260,16 +428,10 @@ dso_cache__memcpy(struct dso_cache *cache, u64 offset,
 }
 
 static ssize_t
-dso_cache__read(struct dso *dso, struct machine *machine,
-		 u64 offset, u8 *data, ssize_t size)
+dso_cache__read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 {
 	struct dso_cache *cache;
 	ssize_t ret;
-	int fd;
-
-	fd = dso__data_fd(dso, machine);
-	if (fd < 0)
-		return -1;
 
 	do {
 		u64 cache_offset;
@@ -283,16 +445,16 @@ dso_cache__read(struct dso *dso, struct machine *machine,
 		cache_offset = offset & DSO__DATA_CACHE_MASK;
 		ret = -EINVAL;
 
-		if (-1 == lseek(fd, cache_offset, SEEK_SET))
+		if (-1 == lseek(dso->data.fd, cache_offset, SEEK_SET))
 			break;
 
-		ret = read(fd, cache->data, DSO__DATA_CACHE_SIZE);
+		ret = read(dso->data.fd, cache->data, DSO__DATA_CACHE_SIZE);
 		if (ret <= 0)
 			break;
 
 		cache->offset = cache_offset;
 		cache->size   = ret;
-		dso_cache__insert(&dso->cache, cache);
+		dso_cache__insert(&dso->data.cache, cache);
 
 		ret = dso_cache__memcpy(cache, offset, data, size);
 
@@ -301,24 +463,27 @@ dso_cache__read(struct dso *dso, struct machine *machine,
 	if (ret <= 0)
 		free(cache);
 
-	close(fd);
 	return ret;
 }
 
-static ssize_t dso_cache_read(struct dso *dso, struct machine *machine,
-			      u64 offset, u8 *data, ssize_t size)
+static ssize_t dso_cache_read(struct dso *dso, u64 offset,
+			      u8 *data, ssize_t size)
 {
 	struct dso_cache *cache;
 
-	cache = dso_cache__find(&dso->cache, offset);
+	cache = dso_cache__find(&dso->data.cache, offset);
 	if (cache)
 		return dso_cache__memcpy(cache, offset, data, size);
 	else
-		return dso_cache__read(dso, machine, offset, data, size);
+		return dso_cache__read(dso, offset, data, size);
 }
 
-ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
-			      u64 offset, u8 *data, ssize_t size)
+/*
+ * Reads and caches dso data DSO__DATA_CACHE_SIZE size chunks
+ * in the rb_tree. Any read to already cached data is served
+ * by cached data.
+ */
+static ssize_t cached_read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 {
 	ssize_t r = 0;
 	u8 *p = data;
@@ -326,7 +491,7 @@ ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 	do {
 		ssize_t ret;
 
-		ret = dso_cache_read(dso, machine, offset, p, size);
+		ret = dso_cache_read(dso, offset, p, size);
 		if (ret < 0)
 			return ret;
 
@@ -346,6 +511,67 @@ ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 	return r;
 }
 
+static int data_file_size(struct dso *dso)
+{
+	struct stat st;
+
+	if (!dso->data.file_size) {
+		if (fstat(dso->data.fd, &st)) {
+			pr_err("dso mmap failed, fstat: %s\n", strerror(errno));
+			return -1;
+		}
+		dso->data.file_size = st.st_size;
+	}
+
+	return 0;
+}
+
+static ssize_t data_read_offset(struct dso *dso, u64 offset,
+				u8 *data, ssize_t size)
+{
+	if (data_file_size(dso))
+		return -1;
+
+	/* Check the offset sanity. */
+	if (offset > dso->data.file_size)
+		return -1;
+
+	if (offset + size < offset)
+		return -1;
+
+	return cached_read(dso, offset, data, size);
+}
+
+/**
+ * dso__data_read_offset - Read data from dso file offset
+ * @dso: dso object
+ * @machine: machine object
+ * @offset: file offset
+ * @data: buffer to store data
+ * @size: size of the @data buffer
+ *
+ * External interface to read data from dso file offset. Open
+ * dso data file and use cached_read to get the data.
+ */
+ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
+			      u64 offset, u8 *data, ssize_t size)
+{
+	if (dso__data_fd(dso, machine) < 0)
+		return -1;
+
+	return data_read_offset(dso, offset, data, size);
+}
+
+/**
+ * dso__data_read_addr - Read data from dso address
+ * @dso: dso object
+ * @machine: machine object
+ * @add: virtual memory address
+ * @data: buffer to store data
+ * @size: size of the @data buffer
+ *
+ * External interface to read data from dso address.
+ */
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 			    struct machine *machine, u64 addr,
 			    u8 *data, ssize_t size)
@@ -473,7 +699,8 @@ struct dso *dso__new(const char *name)
 		dso__set_short_name(dso, dso->name, false);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
-		dso->cache = RB_ROOT;
+		dso->data.cache = RB_ROOT;
+		dso->data.fd = -1;
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->binary_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->loaded = 0;
@@ -485,6 +712,7 @@ struct dso *dso__new(const char *name)
 		dso->kernel = DSO_TYPE_USER;
 		dso->needs_swap = DSO_SWAP__UNSET;
 		INIT_LIST_HEAD(&dso->node);
+		INIT_LIST_HEAD(&dso->data.open_entry);
 	}
 
 	return dso;
@@ -506,7 +734,8 @@ void dso__delete(struct dso *dso)
 		dso->long_name_allocated = false;
 	}
 
-	dso_cache__free(&dso->cache);
+	dso__data_close(dso);
+	dso_cache__free(&dso->data.cache);
 	dso__free_a2l(dso);
 	zfree(&dso->symsrc_filename);
 	free(dso);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 38efe95..ad553ba 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -76,7 +76,6 @@ struct dso {
 	struct list_head node;
 	struct rb_root	 symbols[MAP__NR_TYPES];
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
-	struct rb_root	 cache;
 	void		 *a2l;
 	char		 *symsrc_filename;
 	unsigned int	 a2l_fails;
@@ -99,6 +98,15 @@ struct dso {
 	const char	 *long_name;
 	u16		 long_name_len;
 	u16		 short_name_len;
+
+	/* dso data file */
+	struct {
+		struct rb_root	 cache;
+		int		 fd;
+		size_t		 file_size;
+		struct list_head open_entry;
+	} data;
+
 	char		 name[0];
 };
 
@@ -141,7 +149,47 @@ char dso__symtab_origin(const struct dso *dso);
 int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type type,
 				   char *root_dir, char *filename, size_t size);
 
+/*
+ * The dso__data_* external interface provides following functions:
+ *   dso__data_fd
+ *   dso__data_close
+ *   dso__data_read_offset
+ *   dso__data_read_addr
+ *
+ * Please refer to the dso.c object code for each function and
+ * arguments documentation. Following text tries to explain the
+ * dso file descriptor caching.
+ *
+ * The dso__data* interface allows caching of opened file descriptors
+ * to speed up the dso data accesses. The idea is to leave the file
+ * descriptor opened ideally for the whole life of the dso object.
+ *
+ * The current usage of the dso__data_* interface is as follows:
+ *
+ * Get DSO's fd:
+ *   int fd = dso__data_fd(dso, machine);
+ *   USE 'fd' SOMEHOW
+ *
+ * Read DSO's data:
+ *   n = dso__data_read_offset(dso_0, &machine, 0, buf, BUFSIZE);
+ *   n = dso__data_read_addr(dso_0, &machine, 0, buf, BUFSIZE);
+ *
+ * Eventually close DSO's fd:
+ *   dso__data_close(dso);
+ *
+ * It is not necessary to close the DSO object data file. Each time new
+ * DSO data file is opened, the limit (RLIMIT_NOFILE/2) is checked. Once
+ * it is crossed, the oldest opened DSO object is closed.
+ *
+ * The dso__delete function calls close_dso function to ensure the
+ * data file descriptor gets closed/unmapped before the dso object
+ * is freed.
+ *
+ * TODO
+*/
 int dso__data_fd(struct dso *dso, struct machine *machine);
+void dso__data_close(struct dso *dso);
+
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 			      u64 offset, u8 *data, ssize_t size);
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 65795b8..d0281bd 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -1,4 +1,5 @@
 #include <linux/types.h>
+#include <sys/mman.h>
 #include "event.h"
 #include "debug.h"
 #include "hist.h"
@@ -178,13 +179,14 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		return -1;
 	}
 
-	event->header.type = PERF_RECORD_MMAP;
+	event->header.type = PERF_RECORD_MMAP2;
 
 	while (1) {
 		char bf[BUFSIZ];
 		char prot[5];
 		char execname[PATH_MAX];
 		char anonstr[] = "//anon";
+		unsigned int ino;
 		size_t size;
 		ssize_t n;
 
@@ -195,15 +197,20 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		strcpy(execname, "");
 
 		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
-		       &event->mmap.start, &event->mmap.len, prot,
-		       &event->mmap.pgoff,
-		       execname);
+		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %x:%x %u %s\n",
+		       &event->mmap2.start, &event->mmap2.len, prot,
+		       &event->mmap2.pgoff, &event->mmap2.maj,
+		       &event->mmap2.min,
+		       &ino, execname);
+
 		/*
  		 * Anon maps don't have the execname.
  		 */
-		if (n < 4)
+		if (n < 7)
 			continue;
+
+		event->mmap2.ino = (u64)ino;
+
 		/*
 		 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
 		 */
@@ -212,6 +219,21 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		else
 			event->header.misc = PERF_RECORD_MISC_GUEST_USER;
 
+		/* map protection and flags bits */
+		event->mmap2.prot = 0;
+		event->mmap2.flags = 0;
+		if (prot[0] == 'r')
+			event->mmap2.prot |= PROT_READ;
+		if (prot[1] == 'w')
+			event->mmap2.prot |= PROT_WRITE;
+		if (prot[2] == 'x')
+			event->mmap2.prot |= PROT_EXEC;
+
+		if (prot[3] == 's')
+			event->mmap2.flags |= MAP_SHARED;
+		else
+			event->mmap2.flags |= MAP_PRIVATE;
+
 		if (prot[2] != 'x') {
 			if (!mmap_data || prot[0] != 'r')
 				continue;
@@ -223,15 +245,15 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 			strcpy(execname, anonstr);
 
 		size = strlen(execname) + 1;
-		memcpy(event->mmap.filename, execname, size);
+		memcpy(event->mmap2.filename, execname, size);
 		size = PERF_ALIGN(size, sizeof(u64));
-		event->mmap.len -= event->mmap.start;
-		event->mmap.header.size = (sizeof(event->mmap) -
-					(sizeof(event->mmap.filename) - size));
-		memset(event->mmap.filename + size, 0, machine->id_hdr_size);
-		event->mmap.header.size += machine->id_hdr_size;
-		event->mmap.pid = tgid;
-		event->mmap.tid = pid;
+		event->mmap2.len -= event->mmap.start;
+		event->mmap2.header.size = (sizeof(event->mmap2) -
+					(sizeof(event->mmap2.filename) - size));
+		memset(event->mmap2.filename + size, 0, machine->id_hdr_size);
+		event->mmap2.header.size += machine->id_hdr_size;
+		event->mmap2.pid = tgid;
+		event->mmap2.tid = pid;
 
 		if (process(tool, event, &synth_sample, machine) != 0) {
 			rc = -1;
@@ -612,12 +634,15 @@ size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
 size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp)
 {
 	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64
-			   " %02x:%02x %"PRIu64" %"PRIu64"]: %c %s\n",
+			   " %02x:%02x %"PRIu64" %"PRIu64"]: %c%c%c%c %s\n",
 		       event->mmap2.pid, event->mmap2.tid, event->mmap2.start,
 		       event->mmap2.len, event->mmap2.pgoff, event->mmap2.maj,
 		       event->mmap2.min, event->mmap2.ino,
 		       event->mmap2.ino_generation,
-		       (event->header.misc & PERF_RECORD_MISC_MMAP_DATA) ? 'r' : 'x',
+		       (event->mmap2.prot & PROT_READ) ? 'r' : '-',
+		       (event->mmap2.prot & PROT_WRITE) ? 'w' : '-',
+		       (event->mmap2.prot & PROT_EXEC) ? 'x' : '-',
+		       (event->mmap2.flags & MAP_SHARED) ? 's' : 'p',
 		       event->mmap2.filename);
 }
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index d970232..e5dd40a 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -7,6 +7,7 @@
 #include "../perf.h"
 #include "map.h"
 #include "build-id.h"
+#include "perf_regs.h"
 
 struct mmap_event {
 	struct perf_event_header header;
@@ -27,6 +28,8 @@ struct mmap2_event {
 	u32 min;
 	u64 ino;
 	u64 ino_generation;
+	u32 prot;
+	u32 flags;
 	char filename[PATH_MAX];
 };
 
@@ -87,6 +90,10 @@ struct regs_dump {
 	u64 abi;
 	u64 mask;
 	u64 *regs;
+
+	/* Cached values/mask filled by first register access. */
+	u64 cache_regs[PERF_REGS_MAX];
+	u64 cache_mask;
 };
 
 struct stack_dump {
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 5c28d82..8606175 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -589,10 +589,10 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	}
 
 	/*
-	 * We default some events to a 1 default interval. But keep
+	 * We default some events to have a default interval. But keep
 	 * it a weak assumption overridable by the user.
 	 */
-	if (!attr->sample_period || (opts->user_freq != UINT_MAX &&
+	if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
 				     opts->user_interval != ULLONG_MAX)) {
 		if (opts->freq) {
 			perf_evsel__set_sample_bit(evsel, PERIOD);
@@ -659,6 +659,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		perf_evsel__set_sample_bit(evsel, WEIGHT);
 
 	attr->mmap  = track;
+	attr->mmap2 = track && !perf_missing_features.mmap2;
 	attr->comm  = track;
 
 	if (opts->sample_transaction)
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 5a0a4b2..30df618 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -128,6 +128,8 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 			       + unresolved_col_width + 2;
 			hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL,
 					   symlen);
+			hists__new_col_len(hists, HISTC_MEM_DCACHELINE,
+					   symlen + 1);
 		} else {
 			symlen = unresolved_col_width + 4 + 2;
 			hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL,
@@ -439,9 +441,10 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 			.map	= al->map,
 			.sym	= al->sym,
 		},
-		.cpu	= al->cpu,
-		.ip	= al->addr,
-		.level	= al->level,
+		.cpu	 = al->cpu,
+		.cpumode = al->cpumode,
+		.ip	 = al->addr,
+		.level	 = al->level,
 		.stat = {
 			.nr_events = 1,
 			.period	= period,
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d2bf035..742f49a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -72,6 +72,7 @@ enum hist_column {
 	HISTC_MEM_TLB,
 	HISTC_MEM_LVL,
 	HISTC_MEM_SNOOP,
+	HISTC_MEM_DCACHELINE,
 	HISTC_TRANSACTION,
 	HISTC_NR_COLS, /* Last entry */
 };
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 7409ac8..0e5fea9 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1060,6 +1060,8 @@ int machine__process_mmap2_event(struct machine *machine,
 			event->mmap2.pid, event->mmap2.maj,
 			event->mmap2.min, event->mmap2.ino,
 			event->mmap2.ino_generation,
+			event->mmap2.prot,
+			event->mmap2.flags,
 			event->mmap2.filename, type);
 
 	if (map == NULL)
@@ -1105,7 +1107,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 
 	map = map__new(&machine->user_dsos, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
-			event->mmap.pid, 0, 0, 0, 0,
+			event->mmap.pid, 0, 0, 0, 0, 0, 0,
 			event->mmap.filename,
 			type);
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 8ccbb32..25c571f 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -138,7 +138,7 @@ void map__init(struct map *map, enum map_type type,
 
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
-		     u64 ino_gen, char *filename,
+		     u64 ino_gen, u32 prot, u32 flags, char *filename,
 		     enum map_type type)
 {
 	struct map *map = malloc(sizeof(*map));
@@ -157,6 +157,8 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		map->min = d_min;
 		map->ino = ino;
 		map->ino_generation = ino_gen;
+		map->prot = prot;
+		map->flags = flags;
 
 		if ((anon || no_dso) && type == MAP__FUNCTION) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index ae2d451..7758c72 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -35,6 +35,8 @@ struct map {
 	bool			referenced;
 	bool			erange_warned;
 	u32			priv;
+	u32			prot;
+	u32			flags;
 	u64			pgoff;
 	u64			reloc;
 	u32			maj, min; /* only valid for MMAP2 record */
@@ -118,7 +120,7 @@ void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
-		     u64 ino_gen,
+		     u64 ino_gen, u32 prot, u32 flags,
 		     char *filename, enum map_type type);
 struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 void map__delete(struct map *map);
diff --git a/tools/perf/util/perf_regs.c b/tools/perf/util/perf_regs.c
index a3539ef..43168fb 100644
--- a/tools/perf/util/perf_regs.c
+++ b/tools/perf/util/perf_regs.c
@@ -1,11 +1,15 @@
 #include <errno.h>
 #include "perf_regs.h"
+#include "event.h"
 
 int perf_reg_value(u64 *valp, struct regs_dump *regs, int id)
 {
 	int i, idx = 0;
 	u64 mask = regs->mask;
 
+	if (regs->cache_mask & (1 << id))
+		goto out;
+
 	if (!(mask & (1 << id)))
 		return -EINVAL;
 
@@ -14,6 +18,10 @@ int perf_reg_value(u64 *valp, struct regs_dump *regs, int id)
 			idx++;
 	}
 
-	*valp = regs->regs[idx];
+	regs->cache_mask |= (1 << id);
+	regs->cache_regs[id] = regs->regs[idx];
+
+out:
+	*valp = regs->cache_regs[id];
 	return 0;
 }
diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index 79c78f7..980dbf7 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -2,7 +2,8 @@
 #define __PERF_REGS_H
 
 #include <linux/types.h>
-#include "event.h"
+
+struct regs_dump;
 
 #ifdef HAVE_PERF_REGS_SUPPORT
 #include <perf_regs.h>
@@ -11,6 +12,7 @@ int perf_reg_value(u64 *valp, struct regs_dump *regs, int id);
 
 #else
 #define PERF_REGS_MASK	0
+#define PERF_REGS_MAX	0
 
 static inline const char *perf_reg_name(int id __maybe_unused)
 {
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 0d1542f..9a0a183 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -628,11 +628,11 @@ static int __show_line_range(struct line_range *lr, const char *module)
 
 	ret = debuginfo__find_line_range(dinfo, lr);
 	debuginfo__delete(dinfo);
-	if (ret == 0) {
+	if (ret == 0 || ret == -ENOENT) {
 		pr_warning("Specified source line is not found.\n");
 		return -ENOENT;
 	} else if (ret < 0) {
-		pr_warning("Debuginfo analysis failed. (%d)\n", ret);
+		pr_warning("Debuginfo analysis failed.\n");
 		return ret;
 	}
 
@@ -641,7 +641,7 @@ static int __show_line_range(struct line_range *lr, const char *module)
 	ret = get_real_path(tmp, lr->comp_dir, &lr->path);
 	free(tmp);	/* Free old path */
 	if (ret < 0) {
-		pr_warning("Failed to find source file. (%d)\n", ret);
+		pr_warning("Failed to find source file path.\n");
 		return ret;
 	}
 
@@ -721,9 +721,14 @@ static int show_available_vars_at(struct debuginfo *dinfo,
 	ret = debuginfo__find_available_vars_at(dinfo, pev, &vls,
 						max_vls, externs);
 	if (ret <= 0) {
-		pr_err("Failed to find variables at %s (%d)\n", buf, ret);
+		if (ret == 0 || ret == -ENOENT) {
+			pr_err("Failed to find the address of %s\n", buf);
+			ret = -ENOENT;
+		} else
+			pr_warning("Debuginfo analysis failed.\n");
 		goto end;
 	}
+
 	/* Some variables are found */
 	fprintf(stdout, "Available variables at %s\n", buf);
 	for (i = 0; i < ret; i++) {
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 9d8eb26..98e3047 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -573,14 +573,13 @@ static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
 	if (!die_find_variable_at(sc_die, pf->pvar->var, pf->addr, &vr_die)) {
 		/* Search again in global variables */
 		if (!die_find_variable_at(&pf->cu_die, pf->pvar->var, 0, &vr_die))
+			pr_warning("Failed to find '%s' in this function.\n",
+				   pf->pvar->var);
 			ret = -ENOENT;
 	}
 	if (ret >= 0)
 		ret = convert_variable(&vr_die, pf);
 
-	if (ret < 0)
-		pr_warning("Failed to find '%s' in this function.\n",
-			   pf->pvar->var);
 	return ret;
 }
 
@@ -1281,7 +1280,11 @@ out:
 	return ret;
 }
 
-/* Find available variables at given probe point */
+/*
+ * Find available variables at given probe point
+ * Return the number of found probe points. Return 0 if there is no
+ * matched probe point. Return <0 if an error occurs.
+ */
 int debuginfo__find_available_vars_at(struct debuginfo *dbg,
 				      struct perf_probe_event *pev,
 				      struct variable_list **vls,
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index e108207..af7da56 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -215,6 +215,7 @@ static void define_event_symbols(struct event_format *event,
 	case PRINT_BSTRING:
 	case PRINT_DYNAMIC_ARRAY:
 	case PRINT_STRING:
+	case PRINT_BITMASK:
 		break;
 	case PRINT_TYPE:
 		define_event_symbols(event, ev_name, args->typecast.item);
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index cd9774d..1c41932 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -197,6 +197,7 @@ static void define_event_symbols(struct event_format *event,
 	case PRINT_BSTRING:
 	case PRINT_DYNAMIC_ARRAY:
 	case PRINT_FUNC:
+	case PRINT_BITMASK:
 		/* we should warn... */
 		return;
 	}
@@ -622,6 +623,7 @@ static int python_generate_script(struct pevent *pevent, const char *outfile)
 			fprintf(ofp, "%s=", f->name);
 			if (f->flags & FIELD_IS_STRING ||
 			    f->flags & FIELD_IS_FLAG ||
+			    f->flags & FIELD_IS_ARRAY ||
 			    f->flags & FIELD_IS_SYMBOLIC)
 				fprintf(ofp, "%%s");
 			else if (f->flags & FIELD_IS_SIGNED)
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 45512ba..1ec57dd 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,3 +1,4 @@
+#include <sys/mman.h>
 #include "sort.h"
 #include "hist.h"
 #include "comm.h"
@@ -784,6 +785,104 @@ static int hist_entry__snoop_snprintf(struct hist_entry *he, char *bf,
 	return repsep_snprintf(bf, size, "%-*s", width, out);
 }
 
+static inline  u64 cl_address(u64 address)
+{
+	/* return the cacheline of the address */
+	return (address & ~(cacheline_size - 1));
+}
+
+static int64_t
+sort__dcacheline_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	u64 l, r;
+	struct map *l_map, *r_map;
+
+	if (!left->mem_info)  return -1;
+	if (!right->mem_info) return 1;
+
+	/* group event types together */
+	if (left->cpumode > right->cpumode) return -1;
+	if (left->cpumode < right->cpumode) return 1;
+
+	l_map = left->mem_info->daddr.map;
+	r_map = right->mem_info->daddr.map;
+
+	/* if both are NULL, jump to sort on al_addr instead */
+	if (!l_map && !r_map)
+		goto addr;
+
+	if (!l_map) return -1;
+	if (!r_map) return 1;
+
+	if (l_map->maj > r_map->maj) return -1;
+	if (l_map->maj < r_map->maj) return 1;
+
+	if (l_map->min > r_map->min) return -1;
+	if (l_map->min < r_map->min) return 1;
+
+	if (l_map->ino > r_map->ino) return -1;
+	if (l_map->ino < r_map->ino) return 1;
+
+	if (l_map->ino_generation > r_map->ino_generation) return -1;
+	if (l_map->ino_generation < r_map->ino_generation) return 1;
+
+	/*
+	 * Addresses with no major/minor numbers are assumed to be
+	 * anonymous in userspace.  Sort those on pid then address.
+	 *
+	 * The kernel and non-zero major/minor mapped areas are
+	 * assumed to be unity mapped.  Sort those on address.
+	 */
+
+	if ((left->cpumode != PERF_RECORD_MISC_KERNEL) &&
+	    (!(l_map->flags & MAP_SHARED)) &&
+	    !l_map->maj && !l_map->min && !l_map->ino &&
+	    !l_map->ino_generation) {
+		/* userspace anonymous */
+
+		if (left->thread->pid_ > right->thread->pid_) return -1;
+		if (left->thread->pid_ < right->thread->pid_) return 1;
+	}
+
+addr:
+	/* al_addr does all the right addr - start + offset calculations */
+	l = cl_address(left->mem_info->daddr.al_addr);
+	r = cl_address(right->mem_info->daddr.al_addr);
+
+	if (l > r) return -1;
+	if (l < r) return 1;
+
+	return 0;
+}
+
+static int hist_entry__dcacheline_snprintf(struct hist_entry *he, char *bf,
+					  size_t size, unsigned int width)
+{
+
+	uint64_t addr = 0;
+	struct map *map = NULL;
+	struct symbol *sym = NULL;
+	char level = he->level;
+
+	if (he->mem_info) {
+		addr = cl_address(he->mem_info->daddr.al_addr);
+		map = he->mem_info->daddr.map;
+		sym = he->mem_info->daddr.sym;
+
+		/* print [s] for shared data mmaps */
+		if ((he->cpumode != PERF_RECORD_MISC_KERNEL) &&
+		     map && (map->type == MAP__VARIABLE) &&
+		    (map->flags & MAP_SHARED) &&
+		    (map->maj || map->min || map->ino ||
+		     map->ino_generation))
+			level = 's';
+		else if (!map)
+			level = 'X';
+	}
+	return _hist_entry__sym_snprintf(map, sym, addr, level, bf, size,
+					 width);
+}
+
 struct sort_entry sort_mispredict = {
 	.se_header	= "Branch Mispredicted",
 	.se_cmp		= sort__mispredict_cmp,
@@ -876,6 +975,13 @@ struct sort_entry sort_mem_snoop = {
 	.se_width_idx	= HISTC_MEM_SNOOP,
 };
 
+struct sort_entry sort_mem_dcacheline = {
+	.se_header	= "Data Cacheline",
+	.se_cmp		= sort__dcacheline_cmp,
+	.se_snprintf	= hist_entry__dcacheline_snprintf,
+	.se_width_idx	= HISTC_MEM_DCACHELINE,
+};
+
 static int64_t
 sort__abort_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -1043,6 +1149,7 @@ static struct sort_dimension memory_sort_dimensions[] = {
 	DIM(SORT_MEM_TLB, "tlb", sort_mem_tlb),
 	DIM(SORT_MEM_LVL, "mem", sort_mem_lvl),
 	DIM(SORT_MEM_SNOOP, "snoop", sort_mem_snoop),
+	DIM(SORT_MEM_DCACHELINE, "dcacheline", sort_mem_dcacheline),
 };
 
 #undef DIM
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 5bf0098..041f0c9 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -89,6 +89,7 @@ struct hist_entry {
 	u64			ip;
 	u64			transaction;
 	s32			cpu;
+	u8			cpumode;
 
 	struct hist_entry_diff	diff;
 
@@ -185,6 +186,7 @@ enum sort_type {
 	SORT_MEM_TLB,
 	SORT_MEM_LVL,
 	SORT_MEM_SNOOP,
+	SORT_MEM_DCACHELINE,
 };
 
 /*
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index bd5768d..25578b9 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -250,7 +250,6 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
 
 	/* Check the .eh_frame section for unwinding info */
 	offset = elf_section_offset(fd, ".eh_frame_hdr");
-	close(fd);
 
 	if (offset)
 		ret = unwind_spec_ehframe(dso, machine, offset,
@@ -271,7 +270,6 @@ static int read_unwind_spec_debug_frame(struct dso *dso,
 
 	/* Check the .debug_frame section for unwinding info */
 	*offset = elf_section_offset(fd, ".debug_frame");
-	close(fd);
 
 	if (*offset)
 		return 0;
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 7fff6be..95aefa7 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -17,6 +17,7 @@
  * XXX We need to find a better place for these things...
  */
 unsigned int page_size;
+int cacheline_size;
 
 bool test_attr__enabled;
 
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index b03da44..6686436 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -304,6 +304,7 @@ char *rtrim(char *s);
 void dump_stack(void);
 
 extern unsigned int page_size;
+extern int cacheline_size;
 
 void get_term_dimensions(struct winsize *ws);
 
