Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423235AbaDKQba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:31:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422897AbaDKQb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:31:27 -0400
Date: Fri, 11 Apr 2014 17:58:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RESEND 1/2] tracing: syscall_*regfunc() can race with
	copy_process()
Message-ID: <20140411155845.GA30199@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com> <1397059882-23063-3-git-send-email-fweisbec@gmail.com> <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com> <20140409124249.4081e665@gandalf.local.home> <20140409170505.GA27638@redhat.com> <20140409170542.GB27638@redhat.com> <20140410090643.46ca2226@gandalf.local.home> <20140410133435.GB12228@redhat.com> <20140411112259.79f0a0ba@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411112259.79f0a0ba@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Steven Rostedt wrote:
>
> On Thu, 10 Apr 2014 15:34:35 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 04/10, Steven Rostedt wrote:
> > >
> > > On Wed, 9 Apr 2014 19:05:42 +0200
> > > Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > > --- a/kernel/fork.c
> > > > +++ b/kernel/fork.c
> > > > @@ -1472,7 +1472,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> > > >
> > > >  	total_forks++;
> > > >  	spin_unlock(&current->sighand->siglock);
> > > > +	syscall_tracepoint_update(p);
> > > >  	write_unlock_irq(&tasklist_lock);
> > > > +
> > >
> > > So this looks to be a fix that probably should go to stable?
> >
> > Not sure, this is up to you.
>
> I'll have to think about this one, whether or not it should go to
> stable.

...

> > > These changes should be in a separate patch, as they can wait till 3.16.
> >
> > OK, I'll split this change.
>
> Are you going to send a new series?

Yes, will do. I will split 1/2, and I need to update the changelog
in 2/2.

Oleg.

