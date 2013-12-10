Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3LJLMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:12:39 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59172 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab3LJLMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:12:34 -0500
Date: Tue, 10 Dec 2013 12:12:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Ben Cheng <bccheng@google.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/21] perf/core improvements and fixes
Message-ID: <20131210111229.GB26659@gmail.com>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hm, I've unpulled it because 'perf top' crashes on exit, in 
dso__delete():

[Thread 0x7ffff70df700 (LWP 29561) exited]
*** Error in `/fast/mingo/tip/tools/perf/perf': munmap_chunk(): invalid pointer: 0x0000000000587371 ***
======= Backtrace: =========
/lib64/libc.so.6[0x3e5907bbe7]
/fast/mingo/tip/tools/perf/perf(dso__delete+0xd9)[0x46da89]
/fast/mingo/tip/tools/perf/perf(machines__exit+0xad)[0x482e7d]
/fast/mingo/tip/tools/perf/perf(perf_session__delete+0xb6)[0x488c66]
/fast/mingo/tip/tools/perf/perf(cmd_top+0xf44)[0x4345f4]
/fast/mingo/tip/tools/perf/perf[0x419f95]
/fast/mingo/tip/tools/perf/perf(main+0x600)[0x419830]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x3e59021b45]
/fast/mingo/tip/tools/perf/perf[0x4198fd]
======= Memory map: ========

Program received signal SIGABRT, Aborted.
0x0000003e590359e9 in raise () from /lib64/libc.so.6
Missing separate debuginfos, use: debuginfo-install audit-libs-2.3.2-1.fc19.x86_64 bzip2-libs-1.0.6-8.fc19.x86_64 elfutils-libelf-0.156-5.fc19.x86_64 elfutils-libs-0.156-5.fc19.x86_64 glibc-2.17-19.fc19.x86_64 libgcc-4.8.2-1.fc19.x86_64 libunwind-1.1-2.fc19.x86_64 nss-softokn-freebl-3.15.2-2.fc19.x86_64 numactl-libs-2.0.8-4.fc19.x86_64 perl-libs-5.16.3-266.fc19.x86_64 python-libs-2.7.5-9.fc19.x86_64 slang-2.2.4-8.fc19.x86_64 xz-libs-5.1.2-4alpha.fc19.x86_64 zlib-1.2.7-10.fc19.x86_64
(gdb) 
(gdb) bt
#0  0x0000003e590359e9 in raise () from /lib64/libc.so.6
#1  0x0000003e590370f8 in abort () from /lib64/libc.so.6
#2  0x0000003e59075d17 in __libc_message () from /lib64/libc.so.6
#3  0x0000003e5907bbe7 in malloc_printerr () from /lib64/libc.so.6
#4  0x000000000046da89 in dso__delete (dso=0x8e46f0) at util/dso.c:496
#5  0x0000000000482e7d in dsos__delete (dsos=0x8e4490) at util/machine.c:72
#6  machine__exit (machine=<optimized out>) at util/machine.c:103
#7  machines__exit (machines=machines@entry=0x8e4438) at util/machine.c:123
#8  0x0000000000488c66 in perf_session__delete (session=0x8e4360) at util/session.c:155
#9  0x00000000004345f4 in __cmd_top (top=0x7fffffffb140) at builtin-top.c:985
#10 cmd_top (argc=<optimized out>, argv=<optimized out>, prefix=<optimized out>) at builtin-top.c:1210
#11 0x0000000000419f95 in run_builtin (p=p@entry=0x7ece88 <commands+264>, argc=argc@entry=2, argv=argv@entry=0x7fffffffe420) at perf.c:319
#12 0x0000000000419830 in handle_internal_command (argv=0x7fffffffe420, argc=2) at perf.c:376
#13 run_argv (argv=0x7fffffffe220, argcp=0x7fffffffe22c) at perf.c:420
#14 main (argc=2, argv=0x7fffffffe420) at perf.c:529
(gdb) 

Running it on an up-to-date installation of Fedora 19.

Thanks,

	Ingo
