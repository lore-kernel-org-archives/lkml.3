Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3LVMck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 07:32:40 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45231 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3LVMci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 07:32:38 -0500
Subject: Re: [PATCHSET 00/17] tracing/uprobes: Add support for more fetch
 methods (v9)
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
In-Reply-To: <20131221002218.673bdb32@gandalf.local.home>
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
	 <20131221002218.673bdb32@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Dec 2013 21:32:29 +0900
Message-ID: <1387715550.1740.9.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

2013-12-21 (토), 00:22 -0500, Steven Rostedt:
> I applied all the patches and started testing and it failed to build,
> with this error:
> 
> 
> /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_kprobe.c: In function ‘kprobe_trace_self_tests_init’:
> /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_kprobe.c:1400:7: error: ‘create_trace_probe’ undeclared (first use in this function)
> /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_kprobe.c:1400:7: note: each undeclared identifier is reported only once for each function it appears in
> /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_kprobe.c:1406:3: error: implicit declaration of function ‘find_trace_probe’ [-Werror=implicit-function-declaration]
> /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_kprobe.c:1406:6: warning: assignment makes pointer from integer without a cast [enabled by default]
> /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_kprobe.c:1416:5: error: implicit declaration of function ‘enable_trace_probe’ [-Werror=implicit-function-declaration]
> /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_kprobe.c:1427:6: warning: assignment makes pointer from integer without a cast [enabled by default]
> /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_kprobe.c:1447:5: warning: assignment makes pointer from integer without a cast [enabled by default]
> /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_kprobe.c:1457:4: error: implicit declaration of function ‘disable_trace_probe’ [-Werror=implicit-function-declaration]
> /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_kprobe.c:1460:5: warning: assignment makes pointer from integer without a cast [enabled by default]
> /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_kprobe.c:1486:2: error: implicit declaration of function ‘release_all_trace_probes’ [-Werror=implicit-function-declaration
> ]
> cc1: some warnings being treated as errors
> distcc[17703] ERROR: compile /home/rostedt/work/git/linux-trace.git/kernel/trace/trace_kprobe.c on localhost failed
> make[3]: *** [kernel/trace/trace_kprobe.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> 
> I applied it to my "ftrace/core" branch.
> 
> I attached my config.

Oops, sorry.  I forgot to enable FTRACE_STARTUP_TEST.  I've fixed it,
rebased it onto ftrace/core and pushed to my "uprobe/fetch-v10" branch.
Please test it again when you have time. :)

Thanks,
Namhyung



