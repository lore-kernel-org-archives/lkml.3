Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966906Ab3HIKXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:23:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966425Ab3HIKXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:23:30 -0400
Date: Fri, 9 Aug 2013 12:23:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCHSET 00/17] perf tools: Introduce new 'ftrace' command (v4)
Message-ID: <20130809102306.GA1045@krava.brq.redhat.com>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375175954-798-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 06:18:57PM +0900, Namhyung Kim wrote:
> This patchset implements a front-end tool for kernel's ftrace.  It
> uses function_graph tracer by default and normal function tracer is
> also supported.  (Of course you need to enable those tracers in your
> kernel first.)
> 
> v4 changes:
>  * use pid instead of tid for -p option (David)
>  * not to poll() for reading ftrace pipes (Jiri)
>  * rename to create_perf_header() (Jiri)
>  * canonicalize directory name (Jiri)
>  * show more info when -D option was given (Jiri)
>  * update documentation (Jiri)
>  * and few more bug fixes
> 
> I pushed it out to 'perf/ftrace-v4' branch on my tree at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

got following for record:

[root@dhcp-26-214 perf]# ./perf ftrace record kill
usage: kill [ -s signal | -p ] [ -a ] pid ...
       kill -l [ signal ]
recorder failed for some reason on cpu0
recorder failed for some reason on cpu1


afterwards 'perf ftrace report' gets stuck with 2 processes:

[jolsa@dhcp-26-214 perf]$ sudo pstack 1470
#0  0x00007f23ab61e997 in munmap () from /lib64/libc.so.6
#1  0x000000000047b5f7 in __perf_session__process_events ()
#2  0x000000000043f230 in do_ftrace_report ()
#3  0x0000000000440555 in cmd_ftrace ()
#4  0x000000000041aad3 in run_builtin ()
#5  0x000000000041a379 in main ()
[jolsa@dhcp-26-214 perf]$ sudo pstack 1471
#0  0x00007f23ab61b623 in __select_nocancel () from /lib64/libc.so.6
#1  0x000000000046a337 in pager_preexec ()
#2  0x000000000045f5a3 in start_command ()
#3  0x000000000046a4ab in setup_pager ()
#4  0x0000000000440535 in cmd_ftrace ()
#5  0x000000000041aad3 in run_builtin ()
#6  0x000000000041a379 in main ()


jirka
