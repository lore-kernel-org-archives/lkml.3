Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaC2PYL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:24:11 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60401 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaC2PXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:23:44 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH v2 03/29] ktap: add sample scripts(tools/ktap/samples/*)
Date: Fri, 28 Mar 2014 10:44:58 -0400
Message-Id: <1396017924-7754-4-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The samples directory is organized by different subsystems,
similar with Dtrace toolkit(http://www.brendangregg.com/dtracetoolkit.html)

It contains:
- helloworld.kp: simple hello world program
- ansi: ansi library for screen display
- basic: some simple examples
- game: tetris game wrote by ktap
- interrupt: collect hardirq and softirq time
- io: open and io related scripts
- mem: kernel memory allocation scripts
- network: networking scripts
- profiling: stack profile and function profile
- schedule: schedule scripts.
        schedtimes.kp was inspired by Systemtap schedtimes.stp
- syscalls: tracing syscalls
        syslatl.kp/opensnoop.kp/syslist.kp was contributed by Brendan Gregg(from Dtrace toolkit)
- tracepoints: kernel tracepoint count and histogram
- userspace: uprobe(include SDT) scripts

Besides these samples, "ktap Examples" posted by Brendan Gregg
(http://www.brendangregg.com/ktap.html) also have many sample
scripts, he mentioned how to can make flame graph by ktap.

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 tools/ktap/samples/ansi/ansi_color_demo.kp         |  22 ++
 tools/ktap/samples/basic/backtrace.kp              |   6 +
 tools/ktap/samples/basic/event_trigger.kp          |  27 ++
 tools/ktap/samples/basic/event_trigger_ftrace.kp   |  27 ++
 tools/ktap/samples/basic/ftrace.kp                 |   8 +
 tools/ktap/samples/basic/function_time.kp          |  62 +++++
 tools/ktap/samples/basic/kretprobe.kp              |   6 +
 tools/ktap/samples/basic/memcpy_memset.kp          |  23 ++
 tools/ktap/samples/game/tetris.kp                  | 297 +++++++++++++++++++++
 tools/ktap/samples/helloworld.kp                   |   3 +
 tools/ktap/samples/interrupt/hardirq_time.kp       |  25 ++
 tools/ktap/samples/interrupt/softirq_time.kp       |  24 ++
 tools/ktap/samples/io/kprobes-do-sys-open.kp       |  20 ++
 tools/ktap/samples/io/traceio.kp                   |  61 +++++
 tools/ktap/samples/mem/kmalloc-stack.kp            |  12 +
 tools/ktap/samples/mem/kmem_count.kp               |  29 ++
 tools/ktap/samples/network/tcp_ipaddr.kp           |  20 ++
 tools/ktap/samples/profiling/function_profiler.kp  |  41 +++
 .../profiling/kprobe_all_kernel_functions.kp       |  13 +
 tools/ktap/samples/profiling/stack_profile.kp      |  27 ++
 tools/ktap/samples/schedule/sched_transition.kp    |   5 +
 tools/ktap/samples/schedule/schedtimes.kp          | 131 +++++++++
 tools/ktap/samples/syscalls/errinfo.kp             | 145 ++++++++++
 tools/ktap/samples/syscalls/execve.kp              |   9 +
 tools/ktap/samples/syscalls/opensnoop.kp           |  31 +++
 tools/ktap/samples/syscalls/sctop.kp               |  13 +
 tools/ktap/samples/syscalls/syscalls.kp            |   6 +
 tools/ktap/samples/syscalls/syscalls_count.kp      |  54 ++++
 .../samples/syscalls/syscalls_count_by_proc.kp     |  22 ++
 tools/ktap/samples/syscalls/syslatl.kp             |  33 +++
 tools/ktap/samples/syscalls/syslist.kp             |  31 +++
 tools/ktap/samples/tracepoints/eventcount.kp       | 210 +++++++++++++++
 .../ktap/samples/tracepoints/eventcount_by_proc.kp |  57 ++++
 tools/ktap/samples/tracepoints/raw_tracepoint.kp   |  15 ++
 tools/ktap/samples/tracepoints/tracepoints.kp      |   6 +
 tools/ktap/samples/userspace/gcc_unwind.kp         |   9 +
 tools/ktap/samples/userspace/glibc_func_hist.kp    |  44 +++
 tools/ktap/samples/userspace/glibc_sdt.kp          |  11 +
 tools/ktap/samples/userspace/glibc_trace.kp        |  11 +
 tools/ktap/samples/userspace/malloc_free.kp        |  20 ++
 tools/ktap/samples/userspace/malloc_size_hist.kp   |  22 ++
 tools/ktap/samples/userspace/pthread.kp            |   8 +
 42 files changed, 1646 insertions(+)
 create mode 100644 tools/ktap/samples/ansi/ansi_color_demo.kp
 create mode 100644 tools/ktap/samples/basic/backtrace.kp
 create mode 100644 tools/ktap/samples/basic/event_trigger.kp
 create mode 100644 tools/ktap/samples/basic/event_trigger_ftrace.kp
 create mode 100644 tools/ktap/samples/basic/ftrace.kp
 create mode 100644 tools/ktap/samples/basic/function_time.kp
 create mode 100644 tools/ktap/samples/basic/kretprobe.kp
 create mode 100644 tools/ktap/samples/basic/memcpy_memset.kp
 create mode 100644 tools/ktap/samples/game/tetris.kp
 create mode 100644 tools/ktap/samples/helloworld.kp
 create mode 100644 tools/ktap/samples/interrupt/hardirq_time.kp
 create mode 100644 tools/ktap/samples/interrupt/softirq_time.kp
 create mode 100644 tools/ktap/samples/io/kprobes-do-sys-open.kp
 create mode 100644 tools/ktap/samples/io/traceio.kp
 create mode 100644 tools/ktap/samples/mem/kmalloc-stack.kp
 create mode 100644 tools/ktap/samples/mem/kmem_count.kp
 create mode 100644 tools/ktap/samples/network/tcp_ipaddr.kp
 create mode 100644 tools/ktap/samples/profiling/function_profiler.kp
 create mode 100644 tools/ktap/samples/profiling/kprobe_all_kernel_functions.kp
 create mode 100644 tools/ktap/samples/profiling/stack_profile.kp
 create mode 100644 tools/ktap/samples/schedule/sched_transition.kp
 create mode 100644 tools/ktap/samples/schedule/schedtimes.kp
 create mode 100644 tools/ktap/samples/syscalls/errinfo.kp
 create mode 100644 tools/ktap/samples/syscalls/execve.kp
 create mode 100644 tools/ktap/samples/syscalls/opensnoop.kp
 create mode 100644 tools/ktap/samples/syscalls/sctop.kp
 create mode 100644 tools/ktap/samples/syscalls/syscalls.kp
 create mode 100644 tools/ktap/samples/syscalls/syscalls_count.kp
 create mode 100644 tools/ktap/samples/syscalls/syscalls_count_by_proc.kp
 create mode 100644 tools/ktap/samples/syscalls/syslatl.kp
 create mode 100644 tools/ktap/samples/syscalls/syslist.kp
 create mode 100644 tools/ktap/samples/tracepoints/eventcount.kp
 create mode 100644 tools/ktap/samples/tracepoints/eventcount_by_proc.kp
 create mode 100644 tools/ktap/samples/tracepoints/raw_tracepoint.kp
 create mode 100644 tools/ktap/samples/tracepoints/tracepoints.kp
 create mode 100644 tools/ktap/samples/userspace/gcc_unwind.kp
 create mode 100644 tools/ktap/samples/userspace/glibc_func_hist.kp
 create mode 100644 tools/ktap/samples/userspace/glibc_sdt.kp
 create mode 100644 tools/ktap/samples/userspace/glibc_trace.kp
 create mode 100644 tools/ktap/samples/userspace/malloc_free.kp
 create mode 100644 tools/ktap/samples/userspace/malloc_size_hist.kp
 create mode 100644 tools/ktap/samples/userspace/pthread.kp

diff --git a/tools/ktap/samples/ansi/ansi_color_demo.kp b/tools/ktap/samples/ansi/ansi_color_demo.kp
new file mode 100644
index 0000000..2998fe0
--- /dev/null
+++ b/tools/ktap/samples/ansi/ansi_color_demo.kp
@@ -0,0 +1,22 @@
+#!/usr/bin/env ktap
+
+#this script demonstrate how to use ktap to output color text.
+
+ansi.clear_screen()
+
+ansi.set_color(32)
+printf("this line should be Green color\n")
+
+ansi.set_color(31)
+printf("this line should be Red color\n")
+
+ansi.set_color2(34, 43)
+printf("this line should be Blue color, with Yellow background\n")
+
+ansi.reset_color()
+ansi.set_color3(34, 46, 4)
+printf("this line should be Blue color, with Cyan background, underline single attribute\n")
+
+ansi.reset_color()
+ansi.new_line()
+
diff --git a/tools/ktap/samples/basic/backtrace.kp b/tools/ktap/samples/basic/backtrace.kp
new file mode 100644
index 0000000..4c13c1a
--- /dev/null
+++ b/tools/ktap/samples/basic/backtrace.kp
@@ -0,0 +1,6 @@
+#!/usr/bin/env ktap
+
+trace sched:sched_switch {
+	print(stack())
+}
+
diff --git a/tools/ktap/samples/basic/event_trigger.kp b/tools/ktap/samples/basic/event_trigger.kp
new file mode 100644
index 0000000..7bf4720
--- /dev/null
+++ b/tools/ktap/samples/basic/event_trigger.kp
@@ -0,0 +1,27 @@
+#!/usr/bin/env ktap
+
+#This ktap script will output all tracepoint events between
+#sys_enter_open and sys_exit_open, in one cpu.
+
+var soft_disabled = 1
+var this_cpu = 0
+
+trace syscalls:sys_enter_open {
+	print(argstr)
+	soft_disabled = 0
+	this_cpu = cpu
+}
+
+trace *:* {
+	if (soft_disabled == 0 && cpu == this_cpu) {
+		print(argstr)
+	}
+}
+
+trace syscalls:sys_exit_open {
+	print(argstr)
+	if (cpu == this_cpu) {
+		exit()
+	}
+}
+
diff --git a/tools/ktap/samples/basic/event_trigger_ftrace.kp b/tools/ktap/samples/basic/event_trigger_ftrace.kp
new file mode 100644
index 0000000..f2ebfa5
--- /dev/null
+++ b/tools/ktap/samples/basic/event_trigger_ftrace.kp
@@ -0,0 +1,27 @@
+#!/usr/bin/env ktap
+
+#This ktap script will output all function calling between
+#sys_enter_open and sys_exit_open, in one cpu.
+
+var soft_disabled = 1
+var this_cpu = 0
+
+trace syscalls:sys_enter_open {
+	print(argstr)
+	soft_disabled = 0
+	this_cpu = cpu
+}
+
+trace ftrace:function {
+	if (soft_disabled == 0 && cpu == this_cpu) {
+		print(argstr)
+	}
+}
+
+trace syscalls:sys_exit_open {
+	print(argstr)
+	if (cpu == this_cpu) {
+		exit()
+	}
+}
+
diff --git a/tools/ktap/samples/basic/ftrace.kp b/tools/ktap/samples/basic/ftrace.kp
new file mode 100644
index 0000000..22cff5d
--- /dev/null
+++ b/tools/ktap/samples/basic/ftrace.kp
@@ -0,0 +1,8 @@
+#!/usr/bin/env ktap
+
+#Description: output all mutex* function event
+
+trace ftrace:function /ip==mutex*/ {
+	print(cpu, pid, execname, argstr)
+}
+
diff --git a/tools/ktap/samples/basic/function_time.kp b/tools/ktap/samples/basic/function_time.kp
new file mode 100644
index 0000000..51d0f89
--- /dev/null
+++ b/tools/ktap/samples/basic/function_time.kp
@@ -0,0 +1,62 @@
+#!/usr/bin/env ktap
+
+#Demo for thread-local variable
+#
+#Note this kind of function time tracing already handled concurrent issue,
+#but not aware on the recursion problem, user need to aware this limitation,
+#so don't use this script to trace function which could be called recursive.
+
+var self = {}
+var count_max = 0
+var count_min = 0
+var count_num = 0
+var total_time = 0
+
+printf("measure time(us) of function vfs_read\n");
+
+trace probe:vfs_read {
+	if (execname == "ktap") {
+		return
+	}
+
+	self[tid] = gettimeofday_us()
+}
+
+trace probe:vfs_read%return {
+	if (execname == "ktap") {
+		return
+	}
+
+	if (self[tid] == nil) {
+		return
+	}
+
+	var durtion = gettimeofday_us() - self[tid]
+	if (durtion > count_max) {
+		count_max = durtion
+	}
+	var min = count_min
+	if (min == 0 || durtion < min) {
+		count_min = durtion
+	}
+
+	count_num = count_num + 1
+	total_time = total_time + durtion
+
+	self[tid] = nil
+}
+
+trace_end {
+	var avg
+	if (count_num == 0) {
+		avg = 0
+	} else {
+		avg = total_time/count_num
+	}
+
+	printf("avg\tmax\tmin\n");
+	printf("-------------------\n")
+	printf("%d\t%d\t%d\n", avg, count_max, count_min)
+}
+
+
diff --git a/tools/ktap/samples/basic/kretprobe.kp b/tools/ktap/samples/basic/kretprobe.kp
new file mode 100644
index 0000000..e03a7a2
--- /dev/null
+++ b/tools/ktap/samples/basic/kretprobe.kp
@@ -0,0 +1,6 @@
+#!/usr/bin/env ktap
+
+trace probe:vfs_read%return fd=$retval {
+	print(execname, argstr);
+}
+
diff --git a/tools/ktap/samples/basic/memcpy_memset.kp b/tools/ktap/samples/basic/memcpy_memset.kp
new file mode 100644
index 0000000..18008cc
--- /dev/null
+++ b/tools/ktap/samples/basic/memcpy_memset.kp
@@ -0,0 +1,23 @@
+#!/usr/bin/env ktap
+
+# This script collect kernel memcpy/memset size histgoram output.
+
+var h_memcpy = {}
+var h_memset = {}
+
+trace probe:memcpy size=%dx {
+	h_memcpy[arg1] += 1
+}
+
+trace probe:memset size=%dx {
+	h_memset[arg1] += 1
+}
+
+trace_end {
+	print("memcpy size hist:")
+	print_hist(h_memcpy)
+
+	print()
+	print("memset size hist:")
+	print_hist(h_memset)
+}
diff --git a/tools/ktap/samples/game/tetris.kp b/tools/ktap/samples/game/tetris.kp
new file mode 100644
index 0000000..f7fbbf2
--- /dev/null
+++ b/tools/ktap/samples/game/tetris.kp
@@ -0,0 +1,297 @@
+#!/usr/bin/env ktap
+ 
+#
+# Tetris KTAP Script
+#
+# Copyright (C) 2013/OCT/05 Tadaki SAKAI
+#
+# based on stapgames (Systemtap Game Collection)
+#   https://github.com/mhiramat/stapgames/blob/master/games/tetris.stp
+#
+#   - Requirements
+#     Kernel Configuration: CONFIG_KPROBE_EVENT=y
+#                           CONFIG_EVENT_TRACING=y
+#                           CONFIG_PERF_EVENTS=y
+#                           CONFIG_DEBUG_FS=y
+#     CPU Architecture : x86_64
+#
+#   - Setup
+#     $ sudo mount -t debugfs none /sys/kernel/debug/
+#
+#     $ git clone https://github.com/ktap/ktap
+#     $ cd ktap
+#     $ make 2>&1 | tee ../make.log
+#     $ sudo make load
+#     $ sudo sh -c 'echo 50000 > /sys/module/ktapvm/parameters/max_exec_count'
+#
+#   - Run Tetris
+#     $ sudo ./ktap samples/game/tetris.kp
+#
+ 
+#
+# global value
+#
+
+var empty = -1
+
+var key_code = 0
+var point = 0
+var block_number = 0
+var height = 0
+var height_update = 0
+
+var destination_position = {}
+ 
+var block_data0 = {}
+var block_data1 = {}
+var block_data2 = {}
+var block_data3 = {}
+var block_data4 = {}
+var block_data5 = {}
+var block_data6 = {}
+var block_table = {}
+ 
+#
+# utils
+#
+ 
+function rand(max) {
+	var r = gettimeofday_us()
+	if (r < 0) {
+		r = r * -1
+	}
+	return r % max
+}
+
+var display_buffer = {}
+
+function update_display() {
+	var tmp
+	for (i = 0, 239, 1) {
+		if ((i % 12 - 11) != 0) {
+			tmp = ""
+		} else {
+			tmp = "\n"
+		}
+
+		if (display_buffer[240 + i] == empty) {
+			printf("  %s", tmp)
+		} else {
+			var color = display_buffer[240 + i] + 40
+			ansi.set_color2(color, color)
+			printf("  %s", tmp)
+			ansi.reset_color()
+		}
+
+		# clear the display buffer
+		display_buffer[240 + i] = display_buffer[i]
+	}
+
+	printf("%d\n",point)
+}
+
+ 
+
+#
+# Initialize
+#
+ 
+# Create blocks
+# block is represented by the position from the center.
+# Every block has "L" part in the center except for a bar.
+block_data0[0] = -11 # non-"L" part for each block
+block_data1[0] = -24
+block_data2[0] = 2
+block_data3[0] = 13
+block_data4[0] = -13
+block_data5[0] = -1
+block_data6[0] = 2
+	
+block_table[0] = block_data0
+block_table[1] = block_data1
+block_table[2] = block_data2
+block_table[3] = block_data3
+block_table[4] = block_data4
+block_table[5] = block_data5
+block_table[6] = block_data6
+ 
+for (i = 0, len(block_table) - 1, 1) {
+	# common "L" part
+	block_table[i][1] = 0
+	block_table[i][2] = 1
+	block_table[i][3] = -12
+}
+ 
+block_table[6][3] = -1 # bar is not common
+# Position: 1 row has 12 columns, 
+# and (x, y) is represented by h = x + y * 12.p
+height = 17 # First block position (center)
+
+for (i = 0, 240, 1) {
+	var tmp
+	# Wall and Floor (sentinel)
+	if (((i % 12) < 2) || (i > 228)) {
+		tmp = 7 # White
+	} else {
+		tmp = empty
+	}
+	display_buffer[i - 1] = tmp
+	display_buffer[240 + i - 1] = tmp
+}
+
+block_number = rand(7)
+
+ansi.clear_screen()
+ 
+ 
+#
+# Key Input
+#
+ 
+trace probe:kbd_event handle=%di event_type=%si event_code=%dx value=%cx {
+	# Only can run it in x86_64
+	#
+	# Register follow x86_64 call conversion:
+	#
+	# x86_64:
+	#	%rcx	4 argument
+	#	%rdx	3 argument
+	#	%rsi	2 argument
+	#	%rdi	1 argument
+ 
+	var event_code = arg4
+	var value = arg5
+ 
+	if (value != 0) {
+		if ((event_code - 4) != 0) {
+			key_code = event_code
+		}
+	}
+}
+ 
+ 
+#
+# timer
+#
+ 
+tick-200ms {
+	ansi.clear_screen()
+ 
+	var f = 0 # move/rotate flag
+	var d
+ 
+	if (key_code != 0) { # if key is pressed
+		if(key_code != 103) { #move left or right
+			# d: movement direction
+			if ((key_code - 105) != 0) {
+				if ((key_code - 106) != 0) {
+					d = 0
+				} else {
+					d = 1
+				}
+			} else {
+				d = -1
+			}
+ 
+			for (i = 0, 3, 1) { # check if the block can be moved
+				# destination is free
+				if (display_buffer[height +
+					block_table[block_number][i] + d] 
+				    != empty) {
+					f = 1
+				}
+			}
+			# move if destinations of every block are free
+			if (f == 0) {
+				height = height + d
+			} 
+		} else { # rotate
+			for (i = 0, 3, 1) { # check if block can be rotated
+				# each block position
+				var p = block_table[block_number][i]
+ 
+				# destination x pos(p/12 rounded)
+				var v = (p * 2 + 252) / 24 - 10
+				var w = p - v * 12 # destination y pos
+ 
+				# destination position
+				destination_position[i] = w * 12 - v
+ 
+				# check if desetination is free
+				if (display_buffer[height +
+				    destination_position[i]] != empty) {
+					f = 1
+				}
+			}
+ 
+			if (f == 0) {
+				# rotate if destinations of every block
+				# are free
+				for (i = 0, 3, 1) {
+					block_table[block_number][i] = 
+						destination_position[i] 
+				}
+			}
+		}
+	}
+	key_code = 0 # clear the input key
+ 
+	f = 0
+	for (i = 0, 3, 1) { # drop 1 row
+		# check if destination is free
+		var p = height + block_table[block_number][i]
+		if (display_buffer[12 + p] != empty) {
+			f = 1
+		}
+ 
+		# copy the moving block to display buffer
+		display_buffer[240 + p] = block_number
+	}
+
+	if ((f == 1) && (height == 17)) {
+		update_display()
+		exit() # exit if there are block at initial position
+	}
+ 
+	height_update = !height_update
+	if (height_update != 0) {
+		if(f != 0) { # the block can't drop anymore
+			for (i = 0, 3, 1) {
+				# fix the block
+				display_buffer[height + 
+				  block_table[block_number][i]] = block_number
+			}
+			# determin the next block
+			block_number = rand(7)
+			height = 17 # make the block to initial position
+		} else {
+			height = height + 12 # drop the block 1 row
+		}
+	}
+ 
+	var k = 1
+	for (i = 18, 0, -1) { #check if line is filled
+		# search for filled line
+		var j = 10
+		while ((j > 0) && 
+		       (display_buffer[i * 12 + j] != empty)) {
+			j = j - 1
+		}
+ 
+		if (j == 0) { # filled!
+			# add a point: 1 line - 1 point, ..., tetris - 10points
+			point = point + k
+			k = k + 1
+ 
+			# drop every upper block
+			j = (i + 1) * 12
+			i = i + 1
+			while (j > 2 * 12) {
+				j = j - 1
+				display_buffer[j] = display_buffer[j - 12] 
+			}
+		}
+	}
+ 
+	update_display()
+}
diff --git a/tools/ktap/samples/helloworld.kp b/tools/ktap/samples/helloworld.kp
new file mode 100644
index 0000000..5673c15
--- /dev/null
+++ b/tools/ktap/samples/helloworld.kp
@@ -0,0 +1,3 @@
+#!/usr/bin/env ktap
+
+print("Hello World! I am ktap")
diff --git a/tools/ktap/samples/interrupt/hardirq_time.kp b/tools/ktap/samples/interrupt/hardirq_time.kp
new file mode 100644
index 0000000..f305a41
--- /dev/null
+++ b/tools/ktap/samples/interrupt/hardirq_time.kp
@@ -0,0 +1,25 @@
+#!/usr/bin/env ktap
+
+#this script output each average consumimg time of each hardirq
+
+var s = {}
+var map = {}
+
+trace irq:irq_handler_entry {
+	map[cpu] = gettimeofday_us()
+}
+
+trace irq:irq_handler_exit {
+	var entry_time = map[cpu]
+	if (entry_time == nil) {
+		return;
+	}
+
+	s[arg0] += gettimeofday_us() - entry_time
+	map[cpu] = nil
+}
+
+trace_end {
+	print_hist(s)
+}
+
diff --git a/tools/ktap/samples/interrupt/softirq_time.kp b/tools/ktap/samples/interrupt/softirq_time.kp
new file mode 100644
index 0000000..561733a
--- /dev/null
+++ b/tools/ktap/samples/interrupt/softirq_time.kp
@@ -0,0 +1,24 @@
+#!/usr/bin/env ktap
+
+#this script output each average consumimg time of each softirq line
+var s = {}
+var map = {}
+
+trace irq:softirq_entry {
+	map[cpu] = gettimeofday_us()
+}
+
+trace irq:softirq_exit {
+	var entry_time = map[cpu]
+	if (entry_time == nil) {
+		return;
+	}
+
+	s[arg0] += gettimeofday_us() - entry_time
+	map[cpu] = nil
+}
+
+trace_end {
+	print_hist(s)
+}
+
diff --git a/tools/ktap/samples/io/kprobes-do-sys-open.kp b/tools/ktap/samples/io/kprobes-do-sys-open.kp
new file mode 100644
index 0000000..692f6c4
--- /dev/null
+++ b/tools/ktap/samples/io/kprobes-do-sys-open.kp
@@ -0,0 +1,20 @@
+#!/usr/bin/env ktap
+
+#Only can run it in x86_64
+#
+#Register follow x86_64 call conversion:
+#
+#x86_64:
+#	%rcx	4 argument
+#	%rdx	3 argument
+#	%rsi	2 argument
+#	%rdi	1 argument
+
+trace probe:do_sys_open dfd=%di filename=%si flags=%dx mode=%cx {
+	printf("[do_sys_open entry]: (%s) open file (%s)\n",
+		execname,  user_string(arg2))
+}
+
+trace probe:do_sys_open%return fd=$retval {
+	printf("[do_sys_open exit]:  return fd (%d)\n", arg2)
+}
diff --git a/tools/ktap/samples/io/traceio.kp b/tools/ktap/samples/io/traceio.kp
new file mode 100644
index 0000000..1ef6588
--- /dev/null
+++ b/tools/ktap/samples/io/traceio.kp
@@ -0,0 +1,61 @@
+#! /usr/bin/env ktap
+
+# Based on systemtap traceio.stp
+
+var reads = {}
+var writes = {}
+var total_io = {}
+
+trace syscalls:sys_exit_read {
+	reads[execname] += arg1
+	total_io[execname] += arg1
+}
+
+trace syscalls:sys_exit_write {
+	writes[execname] += arg1
+	total_io[execname] += arg1
+}
+
+function humanread_digit(bytes) {
+	if (bytes > 1024*1024*1024) {
+		return bytes/1024/1024/1024
+	} elseif (bytes > 1024*1024) {
+		return bytes/1024/1024
+	} elseif (bytes > 1024) {
+		return bytes/1024
+	} else {
+		return bytes
+	}
+}
+
+function humanread_x(bytes) {
+	if (bytes > 1024*1024*1024) {
+		return " GiB"
+	} elseif (bytes > 1024*1024) {
+		return " MiB"
+	} elseif (bytes > 1024) {
+		return " KiB"
+	} else {
+		return "   B"
+	}
+}
+
+tick-1s {
+	ansi.clear_screen()
+	for (exec, _ in pairs(total_io)) {
+		var readnum = reads[exec]
+		var writenum = writes[exec]
+
+		if (readnum == nil) {
+			readnum = 0
+		}
+		if (writenum == nil) {
+			writenum = 0
+		}
+		printf("%15s r: %12d%s w: %12d%s\n", exec,
+			humanread_digit(readnum), humanread_x(readnum),
+			humanread_digit(writenum), humanread_x(writenum))
+	}
+	printf("\n")
+}
+
diff --git a/tools/ktap/samples/mem/kmalloc-stack.kp b/tools/ktap/samples/mem/kmalloc-stack.kp
new file mode 100644
index 0000000..8406461
--- /dev/null
+++ b/tools/ktap/samples/mem/kmalloc-stack.kp
@@ -0,0 +1,12 @@
+#!/usr/bin/env ktap
+
+var s = {}
+
+trace kmem:kmalloc {
+	s[stack()] += 1
+}
+
+tick-60s {
+	print_hist(s)
+}
+
diff --git a/tools/ktap/samples/mem/kmem_count.kp b/tools/ktap/samples/mem/kmem_count.kp
new file mode 100644
index 0000000..ab5c8a9
--- /dev/null
+++ b/tools/ktap/samples/mem/kmem_count.kp
@@ -0,0 +1,29 @@
+#!/usr/bin/env ktap
+
+var count1 = 0
+trace kmem:kmalloc {
+	count1 += 1
+}
+
+var count2 = 0
+trace kmem:kfree {
+	count2 += 1
+}
+
+var count3 = 0
+trace kmem:mm_page_alloc {
+	count3 += 1
+}
+
+var count4 = 0
+trace kmem:mm_page_free {
+	count4 += 1
+}
+
+trace_end {
+	print("\n")
+	print("kmem:kmalloc:\t", count1)
+	print("kmem:kfree:\t", count2)
+	print("kmem:mm_page_alloc:", count3)
+	print("kmem:mm_page_free:", count4)
+}
diff --git a/tools/ktap/samples/network/tcp_ipaddr.kp b/tools/ktap/samples/network/tcp_ipaddr.kp
new file mode 100644
index 0000000..6363aef
--- /dev/null
+++ b/tools/ktap/samples/network/tcp_ipaddr.kp
@@ -0,0 +1,20 @@
+#!/usr/bin/env ktap
+
+#This script print source and destination IP address of received tcp message
+#
+#Tested in x86_64
+#
+#function tcp_recvmsg prototype:
+#int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
+#                size_t len, int nonblock, int flags, int *addr_len)
+#
+
+var ip_sock_saddr = net.ip_sock_saddr
+var ip_sock_daddr = net.ip_sock_daddr
+var format_ip_addr = net.format_ip_addr
+
+trace probe:tcp_recvmsg sock=%si {
+	var saddr = format_ip_addr(ip_sock_saddr(arg1))
+	var daddr = format_ip_addr(ip_sock_daddr(arg1))
+	printf("%s -> %s\n", daddr, saddr)
+}
diff --git a/tools/ktap/samples/profiling/function_profiler.kp b/tools/ktap/samples/profiling/function_profiler.kp
new file mode 100644
index 0000000..1414936
--- /dev/null
+++ b/tools/ktap/samples/profiling/function_profiler.kp
@@ -0,0 +1,41 @@
+#!/usr/bin/env ktap
+
+#kernel function profile
+#You can use this script to know what function is called frequently,
+#without enable CONFIG_FUNCTION_PROFILER in kernel.
+
+var s = {}
+
+trace ftrace:function {
+	s[ipof(arg0)] += 1
+}
+
+trace_end {
+	print_hist(s)
+}
+
+#sample output
+#^C
+#                          value ------------- Distribution ------------- count
+#               sub_preempt_count | @@@@@                                  34904
+#               add_preempt_count | @@@@@                                  33435
+#              nsecs_to_jiffies64 | @@@                                    19919
+# irqtime_account_process_tick... | @                                      9970
+#               account_idle_time | @                                      9880
+#                  _raw_spin_lock |                                        5100
+#                _raw_spin_unlock |                                        5021
+#     _raw_spin_unlock_irqrestore |                                        4235
+#          _raw_spin_lock_irqsave |                                        4232
+#                 __rcu_read_lock |                                        3373
+#               __rcu_read_unlock |                                        3373
+#                  lookup_address |                                        2392
+#             pfn_range_is_mapped |                                        2384
+#      update_cfs_rq_blocked_load |                                        1983
+#                        idle_cpu |                                        1808
+#                       ktime_get |                                        1394
+#            _raw_spin_unlock_irq |                                        1270
+#              _raw_spin_lock_irq |                                        1091
+#                     update_curr |                                        950
+#             irqtime_account_irq |                                        950
+#                             ... |
+#
diff --git a/tools/ktap/samples/profiling/kprobe_all_kernel_functions.kp b/tools/ktap/samples/profiling/kprobe_all_kernel_functions.kp
new file mode 100644
index 0000000..d42f7de
--- /dev/null
+++ b/tools/ktap/samples/profiling/kprobe_all_kernel_functions.kp
@@ -0,0 +1,13 @@
+#!/usr/bin/env ktap
+
+#enable kprobe on all available kernel functios in /proc/kallsyms.
+#
+#This script is very dangerous, it will softlockup your system. 
+#and make your system extremely slow, but the reason is not
+#caused by ktap.
+#
+#DON'T use this script, at least for now.
+
+trace probe:* {
+	print(argstr)
+}
diff --git a/tools/ktap/samples/profiling/stack_profile.kp b/tools/ktap/samples/profiling/stack_profile.kp
new file mode 100644
index 0000000..3595a65
--- /dev/null
+++ b/tools/ktap/samples/profiling/stack_profile.kp
@@ -0,0 +1,27 @@
+#!/usr/bin/env ktap
+
+# This ktap script samples stacktrace of system per 10us,
+# you can use generated output to make a flame graph.
+#
+# Flame Graphs:
+# http://dtrace.org/blogs/brendan/2012/03/17/linux-kernel-performance-flame-graphs/
+#
+#
+# TODO: use aggregation instead of table.
+
+#pre-allocate 2000 record entries, enlarge it if it's not enough
+var s = table.new(0, 2000)
+
+profile-10us {
+	#skip 12 stack entries, and dump all remain entries.
+	s[stack(-1, 12)] += 1
+}
+
+tick-60s {
+	exit()
+}
+
+trace_end {
+	print_hist(s, 100000)
+}
+
diff --git a/tools/ktap/samples/schedule/sched_transition.kp b/tools/ktap/samples/schedule/sched_transition.kp
new file mode 100644
index 0000000..bad90e8
--- /dev/null
+++ b/tools/ktap/samples/schedule/sched_transition.kp
@@ -0,0 +1,5 @@
+#!/usr/bin/env ktap
+
+trace sched:sched_switch {
+	printf("%s ... ", arg0)
+}
diff --git a/tools/ktap/samples/schedule/schedtimes.kp b/tools/ktap/samples/schedule/schedtimes.kp
new file mode 100644
index 0000000..19de1bf
--- /dev/null
+++ b/tools/ktap/samples/schedule/schedtimes.kp
@@ -0,0 +1,131 @@
+#!/usr/vin/env ktap
+
+#schedtimer.kp
+#Initially inspired by Systemtap schedtimes.stp
+#and more bugfree compare with Systemtap's version
+#
+#Note that the time value is associate with pid, not with execname strictly,
+#sometime you will found there have sleep time for command "ls", the reason
+#is that sleep time is belong to parent process bash, so clear on this.
+
+var RUNNING = 0
+var QUEUED = 1
+var SLEEPING = 2
+var DEAD = 64
+
+var run_time = {}
+var queued_time = {}
+var sleep_time = {}
+var io_wait_time = {}
+
+var pid_state = {}
+var pid_names = {}
+var prev_timestamp = {}
+var io_wait = {}
+
+trace sched:sched_switch {
+	var prev_comm = arg0
+	var prev_pid = arg1
+	var prev_state = arg3
+	var next_comm = arg4
+	var next_pid = arg5
+	var t = gettimeofday_us()
+
+	if (pid_state[prev_pid] == nil) {
+		#do nothing
+	} elseif (pid_state[prev_pid] == RUNNING) {
+		run_time[prev_pid] += t - prev_timestamp[prev_pid]
+	} elseif (pid_state[prev_pid] == QUEUED) {
+		#found this:
+		#sched_wakeup comm=foo
+		#sched_switch prev_comm=foo
+		run_time[prev_pid] += t - prev_timestamp[prev_pid]
+	}
+
+	pid_names[prev_pid] = prev_comm
+	prev_timestamp[prev_pid] = t
+
+	if (prev_state == DEAD) {
+		pid_state[prev_pid] = DEAD
+	} elseif (prev_state > 0) {
+		if (in_iowait() == 1) {
+			io_wait[prev_pid] = 1
+		}
+		pid_state[prev_pid] = SLEEPING
+	} elseif (prev_state == 0) {
+		pid_state[prev_pid] = QUEUED
+	}
+
+	if (pid_state[next_pid] == nil) {
+		pid_state[next_pid] = RUNNING
+	} elseif (pid_state[next_pid] == QUEUED) {
+		queued_time[next_pid] += t - prev_timestamp[next_pid]
+		pid_state[next_pid] = RUNNING
+	}
+
+	pid_names[next_pid] = next_comm
+	prev_timestamp[next_pid] = t
+}
+
+trace sched:sched_wakeup, sched:sched_wakeup_new {
+	var comm = arg0
+	var wakeup_pid = arg1
+	var success = arg3
+	var t = gettimeofday_us()
+
+	if (pid_state[wakeup_pid] == nil) {
+		#do nothing
+	} elseif (pid_state[wakeup_pid] == SLEEPING) {
+		var durtion = t - prev_timestamp[wakeup_pid]
+
+		sleep_time[wakeup_pid] += durtion
+		if (io_wait[wakeup_pid] == 1) {
+			io_wait_time[wakeup_pid] += durtion
+			io_wait[wakeup_pid] = 0
+		}
+	} elseif (pid_state[wakeup_pid] == RUNNING) {
+		return
+	}
+
+	pid_names[wakeup_pid] = comm
+	prev_timestamp[wakeup_pid] = t
+	pid_state[wakeup_pid] = QUEUED
+}
+
+trace_end {
+	var t = gettimeofday_us()
+	
+	for (_pid, _state in pairs(pid_state)) {
+		var durtion = t - prev_timestamp[_pid]
+		if (_state == SLEEPING) {
+			sleep_time[_pid] += durtion
+		} elseif (_state == QUEUED) {
+			queued_time[_pid] += durtion
+		} elseif (_state == RUNNING) {
+			run_time[_pid] += durtion
+		}
+	}
+
+	printf ("%16s: %6s %10s %10s %10s %10s %10s\n\n",
+		"execname", "pid", "run(us)", "sleep(us)", "io_wait(us)",
+		"queued(us)", "total(us)")
+
+	for (_pid, _time in pairs(run_time)) {
+		if (sleep_time[_pid] == nil) {
+			sleep_time[_pid] = 0
+		}
+		if (queued_time[_pid] == nil) {
+			queued_time[_pid] = 0
+		}
+
+		if (io_wait_time[_pid] == nil) {
+			io_wait_time[_pid] = 0
+		}
+
+		printf("%16s: %6d %10d %10d %10d %10d %10d\n",
+			pid_names[_pid], _pid, run_time[_pid],
+			sleep_time[_pid], io_wait_time[_pid],
+			queued_time[_pid], run_time[_pid] + sleep_time[_pid] +
+			queued_time[_pid]);
+	}
+}
diff --git a/tools/ktap/samples/syscalls/errinfo.kp b/tools/ktap/samples/syscalls/errinfo.kp
new file mode 100644
index 0000000..5a0f7a6
--- /dev/null
+++ b/tools/ktap/samples/syscalls/errinfo.kp
@@ -0,0 +1,145 @@
+#!/usr/bin/env ktap
+
+#errdesc get from include/uapi/asm-generic/errno*.h
+var errdesc = {
+	[1] = "Operation not permitted",		#EPERM
+	[2] = "No such file or directory",		#ENOENT
+	[3] = "No such process",			#ESRCH
+	[4] = "Interrupted system call",		#EINRT
+	[5] = "I/O error",				#EIO
+	[6] = "No such device or address",		#ENXIO
+	[7] = "Argument list too long",			#E2BIG
+	[8] = "Exec format error",			#ENOEXEC
+	[9] = "Bad file number",			#EBADF
+	[10] = "No child processes",			#ECHILD
+	[11] = "Try again",				#EAGAIN
+	[12] = "Out of memory",				#ENOMEM
+	[13] = "Permission denied",			#EACCES
+	[14] = "Bad address",				#EFAULT
+	[15] = "Block device required",			#ENOTBLK
+	[16] = "Device or resource busy",		#EBUSY
+	[17] = "File exists",				#EEXIST
+	[18] = "Cross-device link",			#EXDEV
+	[19] = "No such device",			#ENODEV
+	[20] = "Not a directory",			#ENOTDIR
+	[21] = "Is a directory",			#EISDIR
+	[22] = "Invalid argument",			#EINVAL
+	[23] = "File table overflow",			#ENFILE
+	[24] = "Too many open files",			#EMFILE
+	[25] = "Not a typewriter",			#ENOTTY
+	[26] = "Text file busy",			#ETXTBSY
+	[27] = "File too large",			#EFBIG
+	[28] = "No space left on device",		#ENOSPC
+	[29] = "Illegal seek",				#ESPIPE
+	[30] = "Read-only file system",			#EROFS
+	[31] = "Too many links",			#EMLINK
+	[32] = "Broken pipe",				#EPIPE
+	[33] = "Math argument out of domain of func",	#EDOM
+	[34] = "Math result not representable",		#ERANGE
+
+	[35] = "Resource deadlock would occur",		#EDEADLK
+	[36] = "File name too long", 			#ENAMETOOLONG
+	[37] = "No record locks available",		#ENOLCK
+	[38] = "Function not implemented",		#ENOSYS
+	[39] = "Directory not empty",			#ENOTEMPTY		
+	[40] = "Too many symbolic links encountered",	#ELOOP
+	[42] = "No message of desired type",		#ENOMSG
+	[43] = "Identifier removed",			#EIDRM
+	[44] = "Channel number out of range",		#ECHRNG
+	[45] = "Level 2 not synchronized",		#EL2NSYNC
+	[46] = "Level 3 halted",			#EL3HLT
+	[47] = "Level 3 reset",				#EL3RST			
+	[48] = "Link number out of range",		#ELNRNG
+	[49] = "Protocol driver not attached",		#EUNATCH
+	[50] = "No CSI structure available",		#ENOCSI
+	[51] = "Level 2 halted",			#EL2HLT
+	[52] = "Invalid exchange",			#EBADE
+	[53] = "Invalid request descriptor",		#EBADR
+	[54] = "Exchange full",				#EXFULL
+	[55] = "No anode",				#ENOANO
+	[56] = "Invalid request code",			#EBADRQC
+	[57] = "Invalid slot",				#EBADSLT
+
+	[59] = "Bad font file format",			#EBFONT
+	[60] = "Device not a stream",			#ENOSTR
+	[61] = "No data available",			#ENODATA
+	[62] = "Timer expired",				#ETIME
+	[63] = "Out of streams resources",		#ENOSR
+	[64] = "Machine is not on the network",		#ENONET
+	[65] = "Package not installed",			#ENOPKG
+	[66] = "Object is remote",			#EREMOTE
+	[67] = "Link has been severed",			#ENOLINK
+	[68] = "Advertise error",			#EADV
+	[69] = "Srmount error",				#ESRMNT
+	[70] = "Communication error on send",		#ECOMM
+	[71] = "Protocol error",			#EPROTO
+	[72] = "Multihop attempted",			#EMULTIHOP
+	[73] = "RFS specific error",			#EDOTDOT
+	[74] = "Not a data message",			#EBADMSG
+	[75] = "Value too large for defined data type",	#EOVERFLOW
+	[76] = "Name not unique on network",		#ENOTUNIQ
+	[77] = "File descriptor in bad state",		#EBADFD
+	[78] = "Remote address changed",		#EREMCHG
+	[79] = "Can not access a needed shared library", #ELIBACC
+	[80] = "Accessing a corrupted shared library",	#ELIBBAD
+	[81] = ".lib section in a.out corrupted",	#ELIBSCN
+	[82] = "Attempting to link in too many shared libraries", #ELIBMAX
+	[83] = "Cannot exec a shared library directly",	#ELIBEXEC
+	[84] = "Illegal byte sequence",			#EILSEQ
+	[85] = "Interrupted system call should be restarted", #ERESTART
+	[86] = "Streams pipe error",			#ESTRPIPE
+	[87] = "Too many users",			#EUSERS
+	[88] = "Socket operation on non-socket",	#ENOTSOCK
+	[89] = "Destination address required",		#EDESTADDRREQ
+	[90] = "Message too long",			#EMSGSIZE
+	[91] = "Protocol wrong type for socket",	#EPROTOTYPE
+	[92] = "Protocol not available",		#ENOPROTOOPT
+	[93] = "Protocol not supported",		#EPROTONOSUPPORT
+	[94] = "Socket type not supported",		#ESOCKTNOSUPPORT
+	[95] = "Operation not supported on transport endpoint", #EOPNOTSUPP
+	[96] = "Protocol family not supported",		#EPFNOSUPPORT
+	[97] = "Address family not supported by protocol", #EAFNOSUPPORT
+	[98] = "Address already in use",		#EADDRINUSE
+	[99] = "Cannot assign requested address",	#EADDRNOTAVAIL
+	[100] = "Network is down",			#ENETDOWN
+	[101] = "Network is unreachable",		#ENETUNREACH
+	[102] = "Network dropped connection because of reset",	#ENETRESET
+	[103] = "Software caused connection abort",	#ECONNABORTED
+	[104] = "Connection reset by peer",		#ECONNRESET
+	[105] = "No buffer space available",		#ENOBUFS
+	[106] = "Transport endpoint is already connected", #EISCONN
+	[107] = "Transport endpoint is not connected",	#ENOTCONN
+	[108] = " Cannot send after transport endpoint shutdown", #ESHUTDOWN
+	[109] = "Too many references: cannot splice",	#ETOOMANYREFS
+	[110] = "Connection timed out",			#ETIMEDOUT
+	[111] = "Connection refused",			#ECONNREFUSED
+	[112] = "Host is down",				#EHOSTDOWN
+	[113] = "No route to host",			#EHOSTUNREACH
+	[114] = "Operation already in progress",	#EALREADY
+	[115] = "Operation now in progress",		#EINPROGRESS
+	[116] = "Stale NFS file handle",		#ESTALE
+	[117] = "Structure needs cleaning",		#EUCLEAN
+	[118] = "Not a XENIX named type file",		#ENOTNAM
+	[119] = "No XENIX semaphores available",	#ENAVAIL
+	[120] = "Is a named type file",			#EISNAM
+	[121] = "Remote I/O error",			#EREMOTEIO
+	[122] = "Quota exceeded",			#EDQUOT
+	[123] = "No medium found",			#ENOMEDIUM
+	[124] = "Wrong medium type",			#EMEDIUMTYPE
+	[125] = "Operation Canceled",			#ECANCELED
+	[126] = "Required key not available",		#ENOKEY
+	[127] = "Key has expired",			#EKEYEXPIRED
+	[128] = "Key has been revoked",			#EKEYREVOKED
+	[129] = "Key was rejected by service",		#EKEYREJECTED
+	[130] = "Owner died",				#EOWNERDEAD
+	[131] = "State not recoverable",		#ENOTRECOVERABLE
+
+}
+
+trace syscalls:sys_exit_* {
+	if (arg1 < 0) {
+		var errno = -arg1
+		printf("%-15s%-20s\t%d\t%-30s\n",
+			execname, probename, errno, errdesc[errno])
+	}
+}
diff --git a/tools/ktap/samples/syscalls/execve.kp b/tools/ktap/samples/syscalls/execve.kp
new file mode 100644
index 0000000..8b4115e
--- /dev/null
+++ b/tools/ktap/samples/syscalls/execve.kp
@@ -0,0 +1,9 @@
+#!/usr/bin/env ktap
+
+#This script trace filename of process execution
+#only tested in x86-64
+
+trace probe:do_execve filename=%di {
+	printf("[do_execve entry]: (%s) name=%s\n", execname,
+						    kernel_string(arg1))
+}
diff --git a/tools/ktap/samples/syscalls/opensnoop.kp b/tools/ktap/samples/syscalls/opensnoop.kp
new file mode 100644
index 0000000..5e561b2
--- /dev/null
+++ b/tools/ktap/samples/syscalls/opensnoop.kp
@@ -0,0 +1,31 @@
+#!/usr/local/bin/ktap -q
+#
+# opensnoop.kp	trace open syscalls with pathnames and basic info
+#
+# 23-Nov-2013	Brendan Gregg	Created this
+
+var path = {}
+
+printf("%5s %6s %-12s %3s %3s %s\n", "UID", "PID", "COMM", "FD", "ERR", "PATH");
+
+trace syscalls:sys_enter_open {
+	path[tid] = user_string(arg1)
+}
+
+trace syscalls:sys_exit_open {
+	var fd
+	var errno
+
+	if (arg1 < 0) {
+		fd = 0
+		errno = -arg1
+	} else {
+		fd = arg1
+		errno = 0
+	}
+
+	printf("%5d %6d %-12s %3d %3d %s\n", uid, pid, execname, fd,
+	    errno, path[tid])
+
+	path[tid] = 0
+}
diff --git a/tools/ktap/samples/syscalls/sctop.kp b/tools/ktap/samples/syscalls/sctop.kp
new file mode 100644
index 0000000..bd33d21
--- /dev/null
+++ b/tools/ktap/samples/syscalls/sctop.kp
@@ -0,0 +1,13 @@
+#! /usr/bin/env ktap
+
+var s = {}
+
+trace syscalls:sys_enter_* {
+	s[probename] += 1
+}
+
+tick-5s {
+	ansi.clear_screen()
+	print_hist(s)
+	delete(s)
+}
diff --git a/tools/ktap/samples/syscalls/syscalls.kp b/tools/ktap/samples/syscalls/syscalls.kp
new file mode 100644
index 0000000..4eb332a
--- /dev/null
+++ b/tools/ktap/samples/syscalls/syscalls.kp
@@ -0,0 +1,6 @@
+#!/usr/bin/env ktap
+
+trace syscalls:* {
+	print(cpu, pid, execname, argstr)
+}
+
diff --git a/tools/ktap/samples/syscalls/syscalls_count.kp b/tools/ktap/samples/syscalls/syscalls_count.kp
new file mode 100644
index 0000000..a355eef
--- /dev/null
+++ b/tools/ktap/samples/syscalls/syscalls_count.kp
@@ -0,0 +1,54 @@
+#!/usr/bin/env ktap
+
+var s = {}
+
+trace syscalls:sys_enter_* {
+	s[probename] += 1
+}
+
+trace_end {
+	print_hist(s)
+}
+
+#Result:
+#
+#[root@jovi ktap]# ./ktap samples/syscalls_count.kp
+#^C
+#                          value ------------- Distribution ------------- count
+#        sys_enter_rt_sigprocmask |@@@@@@                                 326
+#                  sys_enter_read |@@@@@                                  287
+#                 sys_enter_close |@@@@                                   236
+#                  sys_enter_open |@@@@                                   222
+#                sys_enter_stat64 |@@                                     132
+#                sys_enter_select |@@                                     123
+#          sys_enter_rt_sigaction |@@                                     107
+#                  sys_enter_poll |@                                      72
+#                 sys_enter_write |@                                      70
+#            sys_enter_mmap_pgoff |@                                      58
+#               sys_enter_fstat64 |                                       41
+#             sys_enter_nanosleep |                                       23
+#                sys_enter_access |                                       20
+#              sys_enter_mprotect |                                       18
+#               sys_enter_geteuid |                                       17
+#               sys_enter_getegid |                                       16
+#                sys_enter_getuid |                                       16
+#                sys_enter_getgid |                                       16
+#                   sys_enter_brk |                                       15
+#               sys_enter_waitpid |                                       11
+#                  sys_enter_time |                                       10
+#                 sys_enter_ioctl |                                       9
+#                sys_enter_munmap |                                       9
+#               sys_enter_fcntl64 |                                       7
+#                  sys_enter_dup2 |                                       7
+#                 sys_enter_clone |                                       6
+#            sys_enter_exit_group |                                       6
+#                sys_enter_execve |                                       4
+#                  sys_enter_pipe |                                       3
+#          sys_enter_gettimeofday |                                       3
+#              sys_enter_getdents |                                       2
+#             sys_enter_getgroups |                                       2
+#              sys_enter_statfs64 |                                       2
+#                 sys_enter_lseek |                                       2
+#                sys_enter_openat |                                       1
+#              sys_enter_newuname |                                       1
+
diff --git a/tools/ktap/samples/syscalls/syscalls_count_by_proc.kp b/tools/ktap/samples/syscalls/syscalls_count_by_proc.kp
new file mode 100644
index 0000000..fdd0eff
--- /dev/null
+++ b/tools/ktap/samples/syscalls/syscalls_count_by_proc.kp
@@ -0,0 +1,22 @@
+#!/usr/bin/env ktap
+
+var s = {}
+
+trace syscalls:sys_enter_* {
+	s[execname] += 1
+}
+
+trace_end {
+	print_hist(s)
+}
+
+#Result:
+#
+#[root@jovi ktap]# ./ktap samples/syscalls_count_by_proc.kp
+#^C
+#                          value ------------- Distribution ------------- count
+#                            sshd |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      196
+#                          iscsid |@@@@                                   24
+#                        sendmail |@                                      9
+
+
diff --git a/tools/ktap/samples/syscalls/syslatl.kp b/tools/ktap/samples/syscalls/syslatl.kp
new file mode 100644
index 0000000..e9cd91d
--- /dev/null
+++ b/tools/ktap/samples/syscalls/syslatl.kp
@@ -0,0 +1,33 @@
+#!/usr/bin/env ktap
+#
+# syslatl.kp	syscall latency linear aggregation
+#
+# 10-Nov-2013	Brendan Gregg	Created this
+
+var step = 10	# number of ms per step
+
+var self = {}
+var lats = {}
+var max = 0
+
+trace syscalls:sys_enter_* {
+	self[tid] = gettimeofday_us()
+}
+
+trace syscalls:sys_exit_* {
+	if (self[tid] == nil) { return }
+	var delta = (gettimeofday_us() - self[tid]) / (step * 1000)
+	if (delta > max) { max = delta }
+	lats[delta] += 1
+	self[tid] = nil
+}
+
+trace_end {
+	printf("   %8s %8s\n", "LAT(ms)+", "COUNT");
+	for (i = 0, max, 1) {
+		if (lats[i] == nil) {
+			lats[i] = 0
+		}
+		printf("   %8d %8d\n", i * step, lats[i]);
+	}
+}
diff --git a/tools/ktap/samples/syscalls/syslist.kp b/tools/ktap/samples/syscalls/syslist.kp
new file mode 100644
index 0000000..09f173d
--- /dev/null
+++ b/tools/ktap/samples/syscalls/syslist.kp
@@ -0,0 +1,31 @@
+#!/usr/bin/env ktap
+#
+# syslist.kp    syscall latency as a list with counts
+#
+# 10-Nov-2013   Brendan Gregg   Created this
+
+var self = {}
+var lats = {}
+var order = {}  # a workaround for key sorting
+
+trace syscalls:sys_enter_* {
+	self[tid] = gettimeofday_us()
+}
+
+trace syscalls:sys_exit_* {
+	if (self[tid] == nil) { return }
+	var delta = gettimeofday_us() - self[tid]
+	lats[delta] += 1
+	order[delta] = delta
+	self[tid] = nil
+}
+
+trace_end {
+	printf("   %8s %8s\n", "LAT(us)", "COUNT");
+	#TODO: use a more simple way to sort keys
+
+	#for (lat, dummy in sort_pairs(order, cmp)) {
+	#    printf("   %8d %8d\n", lat, lats[lat]);
+	#}
+	print_hist(lats)
+}
diff --git a/tools/ktap/samples/tracepoints/eventcount.kp b/tools/ktap/samples/tracepoints/eventcount.kp
new file mode 100644
index 0000000..a9e197b
--- /dev/null
+++ b/tools/ktap/samples/tracepoints/eventcount.kp
@@ -0,0 +1,210 @@
+#!/usr/bin/env ktap
+
+# showing all tracepoints in histogram style
+
+var s = {}
+
+trace *:* {
+	s[probename] += 1
+}
+
+trace_end {
+	print_hist(s)
+}
+
+#Results:
+#^C
+#
+#                          value ------------- Distribution ------------- count
+#                 rcu_utilization |@@@@@                                  225289
+#                        cpu_idle |@@@                                    120168
+#                    sched_wakeup |@@                                     91950
+#                    timer_cancel |@@                                     91232
+#                     timer_start |@@                                     91201
+#                sched_stat_sleep |@@                                     90981
+#               timer_expire_exit |@@                                     90634
+#              timer_expire_entry |@@                                     90625
+#                  hrtimer_cancel |@                                      75411
+#                   hrtimer_start |@                                      74946
+#                   softirq_raise |@                                      63117
+#                    softirq_exit |@                                      63109
+#                   softirq_entry |@                                      63094
+#                    sched_switch |@                                      62331
+#                 sched_stat_wait |@                                      60491
+#             hrtimer_expire_exit |@                                      47538
+#            hrtimer_expire_entry |@                                      47530
+#              sched_stat_runtime |                                       2780
+#                 kmem_cache_free |                                       2684
+#                kmem_cache_alloc |                                       2415
+#                           kfree |                                       2288
+#                        sys_exit |                                       2145
+#                       sys_enter |                                       2145
+#         sys_exit_rt_sigprocmask |                                       1000
+#        sys_enter_rt_sigprocmask |                                       1000
+#                      timer_init |                                       912
+#              sched_stat_blocked |                                       685
+#                         kmalloc |                                       667
+#           workqueue_execute_end |                                       621
+#         workqueue_execute_start |                                       621
+#                sys_enter_select |                                       566
+#                 sys_exit_select |                                       566
+#                  sys_enter_read |                                       526
+#                   sys_exit_read |                                       526
+#                    mm_page_free |                                       478
+#                   mm_page_alloc |                                       427
+#            mm_page_free_batched |                                       382
+#                   net_dev_queue |                                       296
+#                    net_dev_xmit |                                       296
+#                     consume_skb |                                       296
+#                  sys_exit_write |                                       290
+#                 sys_enter_write |                                       290
+#                       kfree_skb |                                       289
+#           kmem_cache_alloc_node |                                       269
+#                    kmalloc_node |                                       263
+#                 sys_enter_close |                                       249
+#                  sys_exit_close |                                       249
+#                    hrtimer_init |                                       248
+#               netif_receive_skb |                                       242
+#                  sys_enter_open |                                       237
+#                   sys_exit_open |                                       237
+#                       napi_poll |                                       226
+#              sched_migrate_task |                                       207
+#                   sys_exit_poll |                                       173
+#                  sys_enter_poll |                                       173
+#            workqueue_queue_work |                                       152
+#         workqueue_activate_work |                                       152
+#                sys_enter_stat64 |                                       133
+#                 sys_exit_stat64 |                                       133
+#           sys_exit_rt_sigaction |                                       133
+#          sys_enter_rt_sigaction |                                       133
+#               irq_handler_entry |                                       125
+#                irq_handler_exit |                                       125
+#       mm_page_alloc_zone_locked |                                       99
+#             sys_exit_mmap_pgoff |                                       66
+#            sys_enter_mmap_pgoff |                                       66
+#                sys_exit_fstat64 |                                       54
+#               sys_enter_fstat64 |                                       54
+#             sys_enter_nanosleep |                                       51
+#              sys_exit_nanosleep |                                       51
+#                 block_bio_queue |                                       46
+#                 block_bio_remap |                                       46
+#              block_bio_complete |                                       46
+#                  mix_pool_bytes |                                       44
+#              mm_page_pcpu_drain |                                       31
+#                   sys_exit_time |                                       23
+#                  sys_enter_time |                                       23
+#                 sys_exit_access |                                       20
+#                sys_enter_access |                                       20
+#           mix_pool_bytes_nolock |                                       18
+#              sys_enter_mprotect |                                       18
+#               sys_exit_mprotect |                                       18
+#               sys_enter_geteuid |                                       17
+#                sys_exit_geteuid |                                       17
+#                sys_enter_munmap |                                       17
+#                 sys_exit_munmap |                                       17
+#                     block_getrq |                                       16
+#                sys_enter_getuid |                                       16
+#                sys_enter_getgid |                                       16
+#                 sys_exit_getgid |                                       16
+#                 sys_exit_getuid |                                       16
+#                  block_rq_issue |                                       16
+#         scsi_dispatch_cmd_start |                                       16
+#               block_rq_complete |                                       16
+#          scsi_dispatch_cmd_done |                                       16
+#               sys_enter_getegid |                                       16
+#                sys_exit_getegid |                                       16
+#                 block_rq_insert |                                       16
+#         skb_copy_datagram_iovec |                                       15
+#                   sys_enter_brk |                                       15
+#                    sys_exit_brk |                                       15
+#             credit_entropy_bits |                                       14
+#                   wbc_writepage |                                       14
+#                  sys_exit_clone |                                       12
+#              block_touch_buffer |                                       12
+#              sched_process_wait |                                       11
+#               sys_enter_waitpid |                                       11
+#                sys_exit_waitpid |                                       11
+#               writeback_written |                                       10
+#                 writeback_start |                                       10
+#              writeback_queue_io |                                       10
+#     ext4_es_lookup_extent_enter |                                       9
+#                 sys_enter_ioctl |                                       9
+#                  sys_exit_ioctl |                                       9
+#       ext4_ext_map_blocks_enter |                                       9
+#        ext4_ext_map_blocks_exit |                                       9
+#      ext4_es_lookup_extent_exit |                                       9
+#           ext4_es_insert_extent |                                       9
+#            ext4_ext_show_extent |                                       8
+#                 extract_entropy |                                       8
+#ext4_es_find_delayed_extent_exit |                                       8
+# ext4_es_find_delayed_extent_... |                                       8
+#         writeback_pages_written |                                       7
+#                   sys_exit_dup2 |                                       7
+#                  sys_enter_dup2 |                                       7
+#                 signal_generate |                                       7
+#               sys_enter_fcntl64 |                                       7
+#                sys_exit_fcntl64 |                                       7
+#              global_dirty_state |                                       7
+#     writeback_dirty_inode_start |                                       7
+#             block_bio_backmerge |                                       7
+#           writeback_dirty_inode |                                       7
+#                sched_wakeup_new |                                       6
+#              sched_process_free |                                       6
+#            sys_enter_exit_group |                                       6
+#                    task_newtask |                                       6
+#                 sys_enter_clone |                                       6
+#              sched_process_fork |                                       6
+#              sched_process_exit |                                       6
+#           sys_exit_gettimeofday |                                       5
+#                  signal_deliver |                                       5
+#          sys_enter_gettimeofday |                                       5
+#          writeback_single_inode |                                       4
+#                sys_enter_execve |                                       4
+#                     task_rename |                                       4
+#              sched_process_exec |                                       4
+#              block_dirty_buffer |                                       4
+#                 sys_exit_execve |                                       4
+#                    block_unplug |                                       4
+#               sched_stat_iowait |                                       4
+#    writeback_single_inode_start |                                       4
+#                      block_plug |                                       4
+#           writeback_write_inode |                                       3
+#                  sys_enter_pipe |                                       3
+#            writeback_dirty_page |                                       3
+#     writeback_write_inode_start |                                       3
+#           ext4_mark_inode_dirty |                                       3
+#              ext4_journal_start |                                       3
+#                   sys_exit_pipe |                                       3
+#           jbd2_drop_transaction |                                       2
+#             jbd2_commit_locking |                                       2
+#            jbd2_commit_flushing |                                       2
+#               jbd2_handle_start |                                       2
+#                  jbd2_run_stats |                                       2
+#               sys_exit_getdents |                                       2
+#           jbd2_checkpoint_stats |                                       2
+#             sys_enter_getgroups |                                       2
+#               jbd2_start_commit |                                       2
+#                 jbd2_end_commit |                                       2
+#              ext4_da_writepages |                                       2
+#               jbd2_handle_stats |                                       2
+#              sys_enter_statfs64 |                                       2
+#               sys_exit_statfs64 |                                       2
+#              sys_exit_getgroups |                                       2
+#                  sys_exit_lseek |                                       2
+#                 sys_enter_lseek |                                       2
+#              sys_enter_getdents |                                       2
+#             ext4_da_write_pages |                                       2
+#             jbd2_commit_logging |                                       2
+#             ext4_request_blocks |                                       1
+#                 sys_exit_openat |                                       1
+#     ext4_discard_preallocations |                                       1
+#              ext4_mballoc_alloc |                                       1
+#                sys_enter_openat |                                       1
+#       ext4_da_writepages_result |                                       1
+#            ext4_allocate_blocks |                                       1
+#              sys_enter_newuname |                                       1
+#    ext4_da_update_reserve_space |                                       1
+# ext4_get_reserved_cluster_alloc |                                       1
+#               sys_exit_newuname |                                       1
+#           writeback_wake_thread |                                       1
+
diff --git a/tools/ktap/samples/tracepoints/eventcount_by_proc.kp b/tools/ktap/samples/tracepoints/eventcount_by_proc.kp
new file mode 100644
index 0000000..1b95f19
--- /dev/null
+++ b/tools/ktap/samples/tracepoints/eventcount_by_proc.kp
@@ -0,0 +1,57 @@
+#!/usr/bin/env ktap
+
+# showing all tracepoints in histogram style
+
+var s = {}
+
+trace *:* {
+	s[execname] += 1
+}
+
+trace_end {
+	print_hist(s)
+}
+
+#Results:
+#^C
+#                          value ------------- Distribution ------------- count
+#                       swapper/0 |@@@@@@@@@@@@                           354378
+#                       swapper/1 |@@@@@@@@@@                             284984
+#                              ps |@@@@                                   115697
+#                        ksmtuned |@@@                                    95857
+#                          iscsid |@@                                     80008
+#                             awk |@                                      30354
+#                      irqbalance |                                       16530
+#                       rcu_sched |                                       15892
+#                        sendmail |                                       14463
+#                     kworker/0:1 |                                       10540
+#                    kworker/u4:2 |                                       9250
+#                     kworker/1:2 |                                       7943
+#                           sleep |                                       7555
+#                           crond |                                       3911
+#                     ksoftirqd/0 |                                       3817
+#                            sshd |                                       2849
+#                 systemd-journal |                                       2209
+#                     migration/1 |                                       1601
+#                     migration/0 |                                       1350
+#                        dhclient |                                       1343
+#                 nm-dhcp-client. |                                       1208
+#                     ksoftirqd/1 |                                       1064
+#                      watchdog/1 |                                       966
+#                      watchdog/0 |                                       964
+#                      khugepaged |                                       776
+#                     dbus-daemon |                                       611
+#                         rpcbind |                                       607
+#                           gdbus |                                       529
+#                  NetworkManager |                                       399
+#                     jbd2/dm-1-8 |                                       378
+#                   modem-manager |                                       184
+#                  abrt-watch-log |                                       157
+#                         polkitd |                                       156
+#                   rs:main Q:Reg |                                       153
+#                    avahi-daemon |                                       151
+#                        rsyslogd |                                       102
+#                         systemd |                                       96
+#                    kworker/0:1H |                                       45
+#                          smartd |                                       30
+
diff --git a/tools/ktap/samples/tracepoints/raw_tracepoint.kp b/tools/ktap/samples/tracepoints/raw_tracepoint.kp
new file mode 100644
index 0000000..cffda45
--- /dev/null
+++ b/tools/ktap/samples/tracepoints/raw_tracepoint.kp
@@ -0,0 +1,15 @@
+#!/usr/bin/env ktap
+
+#This script use kdebug.tracepoint, not 'trace' keyword which use perf backend.
+#
+#The overhead of kdebug.tracepoint would be much little than normal perf
+#backend tracing.
+
+kdebug.tracepoint("sys_enter_open", function () {
+	printf("sys_enter_open: (%s) open file (%s)\n",
+		execname,  user_string(arg1))
+})
+
+kdebug.tracepoint("sys_exit_open", function () {
+	printf("sys_exit_open: return fd: (%d)\n", arg1)
+})
diff --git a/tools/ktap/samples/tracepoints/tracepoints.kp b/tools/ktap/samples/tracepoints/tracepoints.kp
new file mode 100644
index 0000000..3ff29b5
--- /dev/null
+++ b/tools/ktap/samples/tracepoints/tracepoints.kp
@@ -0,0 +1,6 @@
+#!/usr/bin/env ktap
+
+trace *:* {
+	print(cpu, pid, execname, argstr)
+}
+
diff --git a/tools/ktap/samples/userspace/gcc_unwind.kp b/tools/ktap/samples/userspace/gcc_unwind.kp
new file mode 100644
index 0000000..48db46e
--- /dev/null
+++ b/tools/ktap/samples/userspace/gcc_unwind.kp
@@ -0,0 +1,9 @@
+#!/usr/bin/env ktap
+
+#only tested in x86-64 system,
+#if you run this script in x86_32, change the libc path.
+
+trace sdt:/lib/x86_64-linux-gnu/libgcc_s.so.1:unwind {
+	print(execname, argstr)
+}
+
diff --git a/tools/ktap/samples/userspace/glibc_func_hist.kp b/tools/ktap/samples/userspace/glibc_func_hist.kp
new file mode 100644
index 0000000..bb3dd9f
--- /dev/null
+++ b/tools/ktap/samples/userspace/glibc_func_hist.kp
@@ -0,0 +1,44 @@
+#!/usr/bin/env ktap
+
+#This ktap script trace all glibc functions in histogram output
+
+#only tested in x86-64 system,
+#if you run this script in x86_32, change the libc path.
+
+var s = {}
+
+trace probe:/lib64/libc.so.6:* {
+	s[probename] += 1
+}
+
+trace_end {
+	print_hist(s)
+}
+
+# Example result:
+#[root@localhost ktap]# ./ktap ./glibc_func_hist.kp
+#Tracing... Ctrl-C to end.
+#^C
+#                          value ------------- Distribution ------------- count
+#                   _IO_sputbackc |                                       1536
+#                  __strncmp_sse2 |                                       1522
+#                    __GI_strncmp |                                       1522
+#                     __GI_memcpy |                                       1446
+#                   __memcpy_sse2 |                                       1446
+#        _dl_mcount_wrapper_check |                                       1433
+#   __GI__dl_mcount_wrapper_check |                                       1433
+# __gconv_transform_utf8_internal |                                       1429
+#                       __mbrtowc |                                       1425
+#                        mbrtoc32 |                                       1425
+#                  __GI___mbrtowc |                                       1425
+#                         mbrtowc |                                       1425
+#                    __GI_mbrtowc |                                       1425
+#                         strtouq |                                       1274
+#                        strtoull |                                       1274
+#                         strtoul |                                       1274
+#          __ctype_get_mb_cur_max |                                       984
+#         ____strtoull_l_internal |                                       970
+#     __GI_____strtoul_l_internal |                                       970
+#              __GI__IO_sputbackc |                                       960
+#                             ... |
+
diff --git a/tools/ktap/samples/userspace/glibc_sdt.kp b/tools/ktap/samples/userspace/glibc_sdt.kp
new file mode 100644
index 0000000..e396901
--- /dev/null
+++ b/tools/ktap/samples/userspace/glibc_sdt.kp
@@ -0,0 +1,11 @@
+#!/usr/bin/env ktap
+
+#This ktap script trace all sdt notes in glibc
+
+#only tested in x86-64 system,
+#if you run this script in x86_32, change the libc path.
+
+trace sdt:/lib64/libc.so.6:* {
+	print(execname, argstr)
+}
+
diff --git a/tools/ktap/samples/userspace/glibc_trace.kp b/tools/ktap/samples/userspace/glibc_trace.kp
new file mode 100644
index 0000000..9b8d16e
--- /dev/null
+++ b/tools/ktap/samples/userspace/glibc_trace.kp
@@ -0,0 +1,11 @@
+#!/usr/bin/env ktap
+
+#This ktap script trace all functions in glibc
+
+#only tested in x86-64 system,
+#if you run this script in x86_32, change the libc path.
+
+trace probe:/lib64/libc.so.6:* {
+	print(execname, argstr)
+}
+
diff --git a/tools/ktap/samples/userspace/malloc_free.kp b/tools/ktap/samples/userspace/malloc_free.kp
new file mode 100644
index 0000000..884d99a
--- /dev/null
+++ b/tools/ktap/samples/userspace/malloc_free.kp
@@ -0,0 +1,20 @@
+#!/usr/bin/env ktap
+
+#only tested in x86-64 system,
+#if you run this script in x86_32, change the libc path.
+
+trace probe:/lib64/libc.so.6:malloc {
+	print("malloc entry:", execname)
+}
+
+trace probe:/lib64/libc.so.6:malloc%return {
+	print("malloc exit:", execname)
+}
+
+trace probe:/lib64/libc.so.6:free {
+	print("free entry:", execname)
+}
+
+trace probe:/lib64/libc.so.6:free%return {
+	print("free exit:", execname)
+}
diff --git a/tools/ktap/samples/userspace/malloc_size_hist.kp b/tools/ktap/samples/userspace/malloc_size_hist.kp
new file mode 100644
index 0000000..41bd202
--- /dev/null
+++ b/tools/ktap/samples/userspace/malloc_size_hist.kp
@@ -0,0 +1,22 @@
+#!/usr/bin/env ktap
+
+# Aggregate system or process malloc size
+
+# only tested in x86-64 system,
+# if you run this script in x86_32, change the libc path and register name.
+#
+# Examples:
+#
+# ktap malloc_size_hist.kp
+# ktap malloc_size_hist.kp -- ls
+
+var s = {}
+
+trace probe:/lib64/libc.so.6:malloc size=%di {
+	#arg2 is argument "size" of malloc function
+	s[arg1] += 1
+}
+
+trace_end {
+	print_hist(s)
+}
diff --git a/tools/ktap/samples/userspace/pthread.kp b/tools/ktap/samples/userspace/pthread.kp
new file mode 100644
index 0000000..be693ac
--- /dev/null
+++ b/tools/ktap/samples/userspace/pthread.kp
@@ -0,0 +1,8 @@
+#!/usr/bin/env ktap
+
+# This script trace pthread_mutex* related call in libpthread
+# Tested in x86_64
+
+trace probe:/lib64/libpthread-2.17.so:pthread_mutex_* {
+	print(execname, argstr)
+}
-- 
1.8.1.4

