Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbaGWSaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:30:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932598AbaGWSay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:30:54 -0400
Date: Wed, 23 Jul 2014 20:29:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: kill global_start_up
Message-ID: <20140723182911.GA19253@redhat.com>
References: <20140720151814.GA32439@redhat.com> <20140721094706.60eb3877@gandalf.local.home> <20140721095046.4343746d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721095046.4343746d@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21, Steven Rostedt wrote:
>
> On Mon, 21 Jul 2014 09:47:06 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > On Sun, 20 Jul 2014 17:18:14 +0200
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > global_start_up is read-only and always zero. It seems that 4104d326
> > > "ftrace: Remove global function list and call function directly" simply
> > > forgot to remove this no longer used variable.
> > >
> >
> > Sure, just after I got done testing my entire 3.17 queue and posted it
> > for linux-next, you decide to send me yet another fix! ;-)
> >
> > Thanks, applied.
> >
> > I'll wait and see what other fixes you send me before I run my 10 hour
> > tests.
> >
>
> Nevermind, seems that Namhyung Kim beat you to it (and it's already in
> my for-next branch).
>
> http://lkml.kernel.org/r/1402584972-17824-1-git-send-email-namhyung@kernel.org

Thanks for your report Steven, I updated my ~/people-i-hate file.


This motivated me to try to find something else unused. And it seems that
almost all code in kernel/trace/trace_sched_switch.c is dead? Hmm, and
probably even event_context_switch... I'll recheck and send the patch.

But is there any documentation about /sys/kernel/debug/tracing/events/ftrace/*
files ?

OK, as I just figured out ftrace/function is special, it is visible to
perf and thus "record ftrace:function" should work.

But what a user can do with other files? You obviously can't enable, say,
ftrace/bputs, if I understand correctly this is for trace_puts().

Confused...

Oleg.

