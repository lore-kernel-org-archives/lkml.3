Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab3KEN1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:27:25 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63895 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab3KEN1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:27:24 -0500
Date: Tue, 5 Nov 2013 16:25:16 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jon Stanley <jonstanley@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [libtraceevent] hrtimer_expire_entry unknown op '{'
Message-ID: <20131105132516.GD2272@swordfish.minsk.epam.com>
References: <20131105093755.GB2272@swordfish.minsk.epam.com>
 <20131105081522.1c8e2012@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105081522.1c8e2012@gandalf.local.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/05/13 08:15), Steven Rostedt wrote:
> Date: Tue, 5 Nov 2013 08:15:22 -0500
> From: Steven Rostedt <rostedt@goodmis.org>
> To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Namhyung Kim
>  <namhyung@kernel.org>, Jon Stanley <jonstanley@gmail.com>, Sasha Levin
>  <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
> Subject: Re: [libtraceevent] hrtimer_expire_entry unknown op '{'
> X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
> 
> On Tue, 5 Nov 2013 12:37:55 +0300
> Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> 
> > Hello,
> > 
> > libtraceevent reports ` unknown op '{' ' while processing hrtimer_expire_entry event
> 
> Yes, we need to port the plugin code from trace-cmd to handle this and
> other cases. It's a known issue.
> 

oh, sorry for the noise then. thanks.

	-ss

> -- Steve
> 
> > 
> > cat /sys/kernel/debug/tracing/events/timer/hrtimer_expire_entry/format
> > 
> > name: hrtimer_expire_entry
> > ID: 91
> > format:
> > 	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
> > 	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
> > 	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
> > 	field:int common_pid;	offset:4;	size:4;	signed:1;
> > 
> > 	field:void * hrtimer;	offset:8;	size:8;	signed:0;
> > 	field:s64 now;	offset:16;	size:8;	signed:1;
> > 	field:void * function;	offset:24;	size:8;	signed:0;
> > 
> > print fmt: "hrtimer=%p function=%pf now=%llu", REC->hrtimer, REC->function, (unsigned long long)(((ktime_t) { .tv64 = REC->now }).tv64)
> > 
> > 
> > 	-ss
> 
