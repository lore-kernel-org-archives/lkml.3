Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab3KLWEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:04:08 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:46961 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab3KLWEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:04:05 -0500
Date: Wed, 13 Nov 2013 01:01:53 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [libtraceevent] hrtimer_expire_entry unknown op '{'
Message-ID: <20131112220153.GC5709@swordfish>
References: <20131105093755.GB2272@swordfish.minsk.epam.com>
 <20131105081522.1c8e2012@gandalf.local.home>
 <20131112213152.GB5709@swordfish>
 <20131112165237.3273f4b7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112165237.3273f4b7@gandalf.local.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/12/13 16:52), Steven Rostedt wrote:
> > On (11/05/13 08:15), Steven Rostedt wrote:
> > > > Hello,
> > > > 
> > > > libtraceevent reports ` unknown op '{' ' while processing hrtimer_expire_entry event
> > > 
> > > Yes, we need to port the plugin code from trace-cmd to handle this and
> > > other cases. It's a known issue.
> > > 
> > 
> > Hello Steven,
> > sorry if I'm bothering you with already known issue.
> > 
> > I cloned trace-cmd from
> > git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
> > 
> > and there seems to be problems with hrtimer events format.
> > 
> > # ./trace-cmd check-events
> > trace-cmd: No such file or directory
> 
> Do a make install, or copy all the *.so files into ~/.trace-cmd/plugins/
> and that will go away.
>

oh... thanks a lot!

I just quickly went through http://lwn.net/Articles/341902/
(' Just download it, go into the directory and run "make" ')

thank you once again!

	-ss

> -- Steve
> 
> >   bad op token {
> >   bad op token {
> >   bad op token {
> >   bad op token {
> >   function is_writable_pte not defined
> >   function scsi_trace_parse_cdb not defined
> >   function scsi_trace_parse_cdb not defined
> >   function scsi_trace_parse_cdb not defined
> >   function scsi_trace_parse_cdb not defined
> >   function jiffies_to_msecs not defined
> >   function jiffies_to_msecs not defined
> >   unknown op '{'
> >   unknown op '{'
> > 
> > 
> > trivial strace-ing shows that 'unknown op' comes from hrtimer_expire_entry
> > 
> > stat("/sys/kernel/debug/tracing/events/timer/hrtimer_expire_entry/format", {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
> > open("/sys/kernel/debug/tracing/events/timer/hrtimer_expire_entry/format", O_RDONLY) = 5
> > read(5, "name: hrtimer_expire_entry\nID: 9"..., 8192) = 577
> > read(5, "", 8192)                       = 0
> > close(5)                                = 0
> > write(2, "  ", 2)                       = 2
> > write(2, "unknown op '{'", 14)          = 14
> > write(2, "\n", 1)                       = 1
> > 
> > 
> > ./trace-cmd record -e timer ls /bin
> > ./trace-cmd report
> > 
> >      kworker/1:0-3925  [001]  1626.266585: hrtimer_cancel:       hrtimer=0xffff880157c8df80
> >                X-2175  [000]  1626.266585: hrtimer_cancel:       hrtimer=0xffff880157c0df80
> >                X-2175  [000]  1626.266586: hrtimer_expire_entry: [FAILED TO PARSE] hrtimer=0xffff880157c0df80 now=1625348004324 function=0xffffffff810cadf0
> >      kworker/1:0-3925  [001]  1626.266586: hrtimer_expire_entry: [FAILED TO PARSE] hrtimer=0xffff880157c8df80 now=1625348004320 function=0xffffffff810cadf0
> >      kworker/1:0-3925  [001]  1626.266591: hrtimer_expire_exit:  hrtimer=0xffff880157c8df80
> >      kworker/1:0-3925  [001]  1626.266592: hrtimer_start:        [FAILED TO PARSE] hrtimer=0xffff880157c8df80 function=0xffffffff810cadf0 expires=1625352000000 softexpires=1625352000000
> >                X-2175  [000]  1626.266593: hrtimer_expire_exit:  hrtimer=0xffff880157c0df80
> >                X-2175  [000]  1626.266594: hrtimer_start:        [FAILED TO PARSE] hrtimer=0xffff880157c0df80 function=0xffffffff810cadf0 expires=1625352000000 softexpires=1625352000000
> >      kworker/1:0-3925  [001]  1626.266596: timer_cancel:         timer=0xffff880157c8ff28
> >      kworker/1:0-3925  [001]  1626.266598: timer_expire_entry:   timer=0xffff880157c8ff28 function=delayed_work_timer_fn now=4295298633
> >                X-2175  [000]  1626.266599: timer_cancel:         timer=0xffff880157c0ff28
> >                X-2175  [000]  1626.266599: timer_expire_entry:   timer=0xffff880157c0ff28 function=delayed_work_timer_fn now=4295298633
> > 
> > thank you,
> > 
> > 	-ss
> > 
> > 
> > > -- Steve
> > > 
> > > > 
> > > > cat /sys/kernel/debug/tracing/events/timer/hrtimer_expire_entry/format
> > > > 
> > > > name: hrtimer_expire_entry
> > > > ID: 91
> > > > format:
> > > > 	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
> > > > 	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
> > > > 	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
> > > > 	field:int common_pid;	offset:4;	size:4;	signed:1;
> > > > 
> > > > 	field:void * hrtimer;	offset:8;	size:8;	signed:0;
> > > > 	field:s64 now;	offset:16;	size:8;	signed:1;
> > > > 	field:void * function;	offset:24;	size:8;	signed:0;
> > > > 
> > > > print fmt: "hrtimer=%p function=%pf now=%llu", REC->hrtimer, REC->function, (unsigned long long)(((ktime_t) { .tv64 = REC->now }).tv64)
> > > > 
> > > > 
> > > > 	-ss
> > > 
> 
