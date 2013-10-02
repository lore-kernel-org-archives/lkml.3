Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab3JBLUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:20:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab3JBLUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:20:19 -0400
Date: Wed, 2 Oct 2013 13:19:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [BUG] perf timechart segfault
Message-ID: <20131002111958.GC10099@krava.brq.redhat.com>
References: <CALkWK0k5sQ9WCGevFQ3D18=Fs3ziS8imVVvasE0QR9e0r91cYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0k5sQ9WCGevFQ3D18=Fs3ziS8imVVvasE0QR9e0r91cYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:36:45PM +0530, Ramkumar Ramachandra wrote:
> Hi,
> 
> I tried using the `perf timechart` command after a `sudo perf
> timechart record -- git status`, and it segfaulted. Backtrace follows:
> 
> Program received signal SIGSEGV, Segmentation fault.
> 0x0000000000000000 in ?? ()
> (gdb) bt
> #0  0x0000000000000000 in ?? ()
> #1  0x000000000047d728 in perf_session_deliver_event
> (session=session@entry=0x8ea450, event=event@entry=0x7ffff7f13f98,
>     sample=sample@entry=0x7fffffffd530,
> tool=tool@entry=0x7fffffffd7a0, file_offset=file_offset@entry=8088)
>     at util/session.c:1006
> #2  0x000000000047faec in perf_session__process_event
> (file_offset=8088, tool=0x7fffffffd7a0, event=0x7ffff7f13f98,
>     session=0x8ea450) at util/session.c:1098
> #3  __perf_session__process_events (session=session@entry=0x8ea450,
> data_offset=<optimized out>,
>     data_size=<optimized out>, file_size=635384,
> tool=tool@entry=0x7fffffffd7a0) at util/session.c:1360
> #4  0x000000000047ff81 in perf_session__process_events
> (self=self@entry=0x8ea450, tool=tool@entry=0x7fffffffd7a0)
>     at util/session.c:1403
> #5  0x000000000042f12a in __cmd_timechart (output_name=0x4ee399
> "output.svg") at builtin-timechart.c:1009
> #6  cmd_timechart (argc=0, argv=0x7fffffffdf20, prefix=<optimized
> out>) at builtin-timechart.c:1116
> #7  0x0000000000419925 in run_builtin (p=p@entry=0x725f90
> <commands+240>, argc=argc@entry=1,
>     argv=argv@entry=0x7fffffffdf20) at perf.c:319
> #8  0x0000000000419199 in handle_internal_command
> (argv=0x7fffffffdf20, argc=1) at perf.c:376
> #9  run_argv (argv=0x7fffffffdd20, argcp=0x7fffffffdd2c) at perf.c:420
> #10 main (argc=1, argv=0x7fffffffdf20) at perf.c:521
> 
> I compiled it with EXTRA_CFLAGS="-O0 -g", so all the debugging symbols
> should be available. Not sure what's going on, or why I needed sudo to
> record data in the first place.

hi,
what perf version are you running? I can't hit the issue
and also the file lines in backtrace indicate it's not
current one.

thanks,
jirka
