Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031013AbaDJNdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:33:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030980AbaDJNdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:33:01 -0400
Date: Thu, 10 Apr 2014 15:33:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RESEND 1/2] tracing: syscall_*regfunc() can race with
	copy_process()
Message-ID: <20140410133305.GA12228@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com> <1397059882-23063-3-git-send-email-fweisbec@gmail.com> <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com> <20140409124249.4081e665@gandalf.local.home> <20140409170505.GA27638@redhat.com> <20140409170542.GB27638@redhat.com> <20140410090452.6b7677fc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410090452.6b7677fc@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Steven Rostedt wrote:
>
> On Wed, 9 Apr 2014 19:05:42 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > syscall_regfunc() and syscall_unregfunc() should set/clear
> > TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
> > with copy_process() and miss the new child which was not added to
> > init_task.tasks list yet.
> >
> > Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
> > under tasklist.
> >
> > While at it,
> >
> > 	- remove _irqsafe from syscall_regfunc/syscall_unregfunc,
> > 	  read_lock(tasklist) doesn't need to disable irqs.
> >
> > 	- change syscall_unregfunc() to check PF_KTHREAD to skip
> > 	  the kernel threads, ->mm != NULL is the common mistake.
> >
> > 	  Note: probably this check should be simply removed, needs
> > 	  another patch.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> BTW, how important is this fix? Something we should aim for the current
> merge window? stable? Or can it wait till 3.16?

I think this all can wait till 3.16. The problem is really minor.

Oleg.

