Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaFEHtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:49:53 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:32887 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbaFEHtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:49:43 -0400
X-Greylist: delayed 654 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2014 03:49:41 EDT
X-Yandex-Uniq: ae1e4d44-1543-4cde-917d-fd71c4ac4973
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Thu, 5 Jun 2014 11:38:39 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, jovi.zhangwei@huawei.com,
        namhyung.kim@lge.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] tracing: let user specify tracing_thresh after
 selecting function_graph
Message-ID: <20140605073839.GG26511@stfomichev-desktop.yandex.net>
References: <1401815569-10513-1-git-send-email-stfomichev@yandex-team.ru>
 <20140603185720.79552fb8@gandalf.local.home>
 <20140604133350.GC26511@stfomichev-desktop.yandex.net>
 <20140604154149.3c2857dc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604154149.3c2857dc@gandalf.local.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You mean inside the function tracers. I could envision problems with
> that, but I don't know exactly what would cause those problems. Have
> patches to show? You may have done something unrelated that caused the
> issue.
Maybe I'm using jump labels incorrectly, patch attached below.
And, when I set tracing_thresh after selecting function_graph, I get:

[   42.337679] PANIC: double fault, error_code: 0x0
[   42.337357] PANIC: double fault, error_code: 0x0
[   42.337357] CPU: 1 PID: 1388 Comm: bash Not tainted 3.15.0-upstream #33
[   42.337357] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   42.337357] task: ffff88001f5b3aa0 ti: ffff8800185d4000 task.ti: ffff8800185d4000
[   42.337357] RIP: 0010:[<ffffffff811006d4>]  [<ffffffff811006d4>] trace_buffer_lock_reserve+0x4/0x80
[   42.337357] RSP: 0000:ffff88001f7ffff0  EFLAGS: 00010086
[   42.337357] RAX: 0000000000000000 RBX: ffff88001e409d80 RCX: 0000000000000046
[   42.337357] RDX: 0000000000000018 RSI: 000000000000000b RDI: ffff88001e409d80
[   42.337357] RBP: ffff88001f800070 R08: 0000000000000000 R09: 0000000000000554
[   42.337357] R10: 0000000000000000 R11: 0000000000000013 R12: ffffffff81054e30
[   42.337357] R13: 0000000000000000 R14: 0000000000000286 R15: 0000000000000003
[   42.337357] FS:  00007f5a6cd83700(0000) GS:ffff88001fd00000(0000) knlGS:0000000000000000
[   42.337357] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.337357] CR2: ffff88001f7fffe8 CR3: 0000000000e20000 CR4: 00000000000006e0
[   42.337357] Stack:
[   42.337357]  ffffffffa0010f50 ffffffffa0011170
[   42.337357] Call Trace:
[   42.337357]  <UNK> 
[   42.337357] Code: 02 00 00 48 63 ca 89 14 bd a0 4b ed 81 89 34 8d 60 43 eb 81 89 35 bd 44 dd 00 e9 45 ff ff ff 0f 1f 84 00 00 00 00 00 48 83 ec 28 <48> 89 1c 24 89 f3 48 8
9 d6 48 89 6c 24 08 4c 89 64 24 10 48 89 
[   42.337357] Kernel panic - not syncing: Machine halted.
[   42.337357] CPU: 1 PID: 1388 Comm: bash Not tainted 3.15.0-upstream #33
[   42.337357] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   42.337357]  0000000000000000 ffffffff810184f5 ffffffff816673d3 ffffffff8193437f
[   42.337357]  ffffffff8166223e 0000000000000000 ffffffff00000008 ffff88001fd06f28
[   42.337357]  ffff88001fd06ec8 00000000000012cc 0000000000000082 0000000000000082
[   42.337357] Call Trace:
[   42.337357]  <#DF>  [<ffffffff810184f5>] ? show_stack+0x5/0x50
[   42.337357]  [<ffffffff816673d3>] ? dump_stack+0x41/0x51
[   42.337357]  [<ffffffff8166223e>] ? panic+0xca/0x1e7
[   42.337357]  [<ffffffff8104d89d>] ? df_debug+0x2d/0x30
[   42.337357]  [<ffffffff81015518>] ? do_double_fault+0x58/0x80
[   42.337357]  [<ffffffff81054e30>] ? perf_trace_x86_exceptions+0x130/0x130
[   42.337357]  [<ffffffff81670d08>] ? double_fault+0x28/0x30
[   42.337357]  [<ffffffff81054e30>] ? perf_trace_x86_exceptions+0x130/0x130
[   42.337357]  [<ffffffff811006d4>] ? trace_buffer_lock_reserve+0x4/0x80
[   42.337679]  <<EOE>>  <UNK> 
[   42.337679] CPU: 0 PID: 1386 Comm: sshd Not tainted 3.15.0-upstream #33
[   42.337679] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   42.337679] task: ffff88001f5b29e0 ti: ffff88001849c000 task.ti: ffff88001849c000
[   42.337679] RIP: 0010:[<ffffffff811006d4>]  [<ffffffff811006d4>] trace_buffer_lock_reserve+0x4/0x80
[   42.337679] RSP: 0018:ffff88001f7ffff0  EFLAGS: 00010086
[   42.337679] RAX: 0000000000000000 RBX: ffff88001e409d80 RCX: 0000000000000046
[   42.337679] RDX: 0000000000000018 RSI: 000000000000000b RDI: ffff88001e409d80
[   42.337679] RBP: ffff88001f800070 R08: 0000000000010000 R09: 00000000000000f4
[   42.337679] R10: 0000000000000000 R11: 0000000000000010 R12: ffffffff81054e30
[   42.337679] R13: 0000000000000000 R14: ffff88001fc0dff8 R15: 0000000000000003
[   42.337679] FS:  00007f2b388a87c0(0000) GS:ffff88001fc00000(0000) knlGS:0000000000000000
[   42.337679] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   42.337679] CR2: ffff88001f7fffe8 CR3: 00000000179ea000 CR4: 00000000000006f0
[   42.337679] Stack:
[   42.337679]  ffffffffa0010f50 ffffffffa0011170
[   42.337679] Call Trace:
[   42.337679]  <UNK> 
[   42.337679] Code: 02 00 00 48 63 ca 89 14 bd a0 4b ed 81 89 34 8d 60 43 eb 81 89 35 bd 44 dd 00 e9 45 ff ff ff 0f 1f 84 00 00 00 00 00 48 83 ec 28 <48> 89 1c 24 89 f3 48 89 d6 48 89 6c 24 08 4c 89 64 24 10 48 89 
[   42.337357] Shutting down cpus with NMI
[   42.337357] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[   42.337357] ---[ end Kernel panic - not syncing: Machine halted.

--

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 737b0efa1a62..0b58d2ff94f6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -750,6 +750,14 @@ static int __init set_buf_size(char *str)
 }
 __setup("trace_buf_size=", set_buf_size);
 
+static void update_tracing_thresh_enabled(void)
+{
+	if (tracing_thresh && !static_key_enabled(&__tracing_thresh_enabled))
+		static_key_slow_inc(&__tracing_thresh_enabled);
+	if (!tracing_thresh && static_key_enabled(&__tracing_thresh_enabled))
+		static_key_slow_dec(&__tracing_thresh_enabled);
+}
+
 static int __init set_tracing_thresh(char *str)
 {
 	unsigned long threshold;
@@ -761,6 +769,7 @@ static int __init set_tracing_thresh(char *str)
 	if (ret < 0)
 		return 0;
 	tracing_thresh = threshold * 1000;
+	update_tracing_thresh_enabled();
 	return 1;
 }
 __setup("tracing_thresh=", set_tracing_thresh);
@@ -980,6 +989,7 @@ static arch_spinlock_t ftrace_max_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
 unsigned long __read_mostly	tracing_thresh;
+struct static_key		__tracing_thresh_enabled;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 unsigned long __read_mostly	tracing_max_latency;
@@ -4104,6 +4114,7 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
 		return ret;
 
 	*ptr = val * 1000;
+	update_tracing_thresh_enabled();
 
 	return cnt;
 }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2e29d7ba5a52..ab32c1f33917 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -606,6 +606,12 @@ extern cpumask_var_t __read_mostly tracing_buffer_mask;
 extern unsigned long nsecs_to_usecs(unsigned long nsecs);
 
 extern unsigned long tracing_thresh;
+extern struct static_key __tracing_thresh_enabled;
+
+static inline bool tracing_thresh_enabled(void)
+{
+	return static_key_false(&__tracing_thresh_enabled);
+}
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 extern unsigned long tracing_max_latency;
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index deff11200261..0a893120c05a 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -332,7 +332,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 
 int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
 {
-	if (tracing_thresh)
+	if (tracing_thresh_enabled())
 		return 1;
 	else
 		return trace_graph_entry(trace);
@@ -421,7 +421,7 @@ void set_graph_array(struct trace_array *tr)
 
 void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
 {
-	if (tracing_thresh &&
+	if (tracing_thresh_enabled() &&
 	    (trace->rettime - trace->calltime < tracing_thresh))
 		return;
 	else
@@ -433,12 +433,8 @@ static int graph_trace_init(struct trace_array *tr)
 	int ret;
 
 	set_graph_array(tr);
-	if (tracing_thresh)
-		ret = register_ftrace_graph(&trace_graph_thresh_return,
-					    &trace_graph_thresh_entry);
-	else
-		ret = register_ftrace_graph(&trace_graph_return,
-					    &trace_graph_entry);
+	ret = register_ftrace_graph(&trace_graph_thresh_return,
+				    &trace_graph_thresh_entry);
 	if (ret)
 		return ret;
 	tracing_start_cmdline_record();
