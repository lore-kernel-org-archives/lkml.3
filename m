Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3JBLHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:07:30 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:49195 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3JBLH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:07:26 -0400
MIME-Version: 1.0
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 2 Oct 2013 16:36:45 +0530
Message-ID: <CALkWK0k5sQ9WCGevFQ3D18=Fs3ziS8imVVvasE0QR9e0r91cYA@mail.gmail.com>
Subject: [BUG] perf timechart segfault
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried using the `perf timechart` command after a `sudo perf
timechart record -- git status`, and it segfaulted. Backtrace follows:

Program received signal SIGSEGV, Segmentation fault.
0x0000000000000000 in ?? ()
(gdb) bt
#0  0x0000000000000000 in ?? ()
#1  0x000000000047d728 in perf_session_deliver_event
(session=session@entry=0x8ea450, event=event@entry=0x7ffff7f13f98,
    sample=sample@entry=0x7fffffffd530,
tool=tool@entry=0x7fffffffd7a0, file_offset=file_offset@entry=8088)
    at util/session.c:1006
#2  0x000000000047faec in perf_session__process_event
(file_offset=8088, tool=0x7fffffffd7a0, event=0x7ffff7f13f98,
    session=0x8ea450) at util/session.c:1098
#3  __perf_session__process_events (session=session@entry=0x8ea450,
data_offset=<optimized out>,
    data_size=<optimized out>, file_size=635384,
tool=tool@entry=0x7fffffffd7a0) at util/session.c:1360
#4  0x000000000047ff81 in perf_session__process_events
(self=self@entry=0x8ea450, tool=tool@entry=0x7fffffffd7a0)
    at util/session.c:1403
#5  0x000000000042f12a in __cmd_timechart (output_name=0x4ee399
"output.svg") at builtin-timechart.c:1009
#6  cmd_timechart (argc=0, argv=0x7fffffffdf20, prefix=<optimized
out>) at builtin-timechart.c:1116
#7  0x0000000000419925 in run_builtin (p=p@entry=0x725f90
<commands+240>, argc=argc@entry=1,
    argv=argv@entry=0x7fffffffdf20) at perf.c:319
#8  0x0000000000419199 in handle_internal_command
(argv=0x7fffffffdf20, argc=1) at perf.c:376
#9  run_argv (argv=0x7fffffffdd20, argcp=0x7fffffffdd2c) at perf.c:420
#10 main (argc=1, argv=0x7fffffffdf20) at perf.c:521

I compiled it with EXTRA_CFLAGS="-O0 -g", so all the debugging symbols
should be available. Not sure what's going on, or why I needed sudo to
record data in the first place.

Any hints?
