Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab3GaCjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 22:39:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57137 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3GaCji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 22:39:38 -0400
Message-ID: <51F878DA.3000206@huawei.com>
Date: Wed, 31 Jul 2013 10:39:22 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <ktap@freelists.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        <jovi.zhangwei@gmail.com>
Subject: [ANNOUNCE] ktap 0.2 released
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear,

I'm pleased to announce that ktap released v0.2, the archive is available at:

	https://github.com/ktap/ktap/archive/v0.2.tar.gz


= what's ktap?

   A New Scripting Dynamic Tracing Tool For Linux

   ktap have different design principles from Linux mainstream dynamic tracing
   language in that it's based on bytecode, so it doesn't depend upon GCC,
   doesn't require compiling kernel module for each script, safe to use in
   production environment, fulfilling the embedd ecosystem's tracing needs.

   ktap is released as GPL license.

   More information can be found at ktap/doc directory.

= Highlight features

   - support tracepoints, k(ret)probe, u(ret)probe, timer, function tracing, etc.
   - support x86, x86-64, powerpc, arm, and preempt-rt kernel.
   - support kernel 3.1 and later versions, include Linux mainline.

= Script highlight changes from v0.1

   * new tracing block syntax (introduce keywords: trace, trace_end)
	trace EVENTDEF function (e) { BODY }
	trace_end function () { BODY }

   * event became to a built-in type in language
	print(e) will output string presentation of event.

	for syscalls:sys_enter_write event, print(e) will output like:
	sys_write(fd: 3, buf: b9369c78, count: 60)

   * support trace filter
	trace 'sched:sched_switch /prev_comm == foo || next_comm == foo/

   * support kprobe/kretprobe (no debuginfo handing)
	trace "probe:do_sys_open dfd=%di filename=%dx flags=%cx mode=+4($stack)"
	trace "probe:do_sys_open%return fd=$retval"

   * support uprobe/uretprobe (no debuginfo handling)
	trace "probe:/lib/libc.so.6:0x000773c0"
	trace "probe:/lib/libc.so.6:0x000773c0%return"

   * support function tracing
	trace "ftrace:function /ip == mutex*/"

   * support oneline scripting
	ktap -e 'trace "syscalls:*" function (e) { print(e) }'

   * specific pid or cpu to tracing
	ktap -C cpu *.kp
	ktap -p pid *.kp

   * more sample scripts

   * support calling print_backtrace() in any context

   * support calling exit() in any context

= Backend highlight changes from v0.1

   * unified perf callback mechanism
   * use ring buffer transport instead of relayfs
   * reentrant in ktap tracing
   * performance boost(use percpu data in many case)
   * safe table/string manipulation
   * safe ktap exit
   * big code cleanups
   * fixed a lot of bugs, more stable than v0.1

= Source code

   Please get latest code from:
   https://github.com/ktap/ktap.git

= Building & Running

   [root@jovi]# git clone https://github.com/ktap/ktap.git

   [root@jovi]# cd ktap
   [root@jovi]# make	#generate ktapvm kernel module and ktap binary

   [root@jovi]# insmod ./ktapvm.ko
   [root@jovi]# ./ktap scripts/syscalls.kp

= Samples scripts

   There have many samples scripts in README and ktap/scripts.

= Documentation

   Documentation is in ktap/doc/

= Mailing list

   ktap@freelists.org
   You can subscribe ktap mailing list at link: http://www.freelists.org/list/ktap

= Feedback

   ktap is still under active development, so any feedback, bug reports, patches,
   feature requests, as always, is welcome.


.jovi







