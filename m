Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224Ab3HSSjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab3HSSjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:39:06 -0400
Date: Mon, 19 Aug 2013 20:33:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
Message-ID: <20130819183319.GA24846@redhat.com>
References: <20130819172524.GA22268@redhat.com> <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Andy Lutomirski wrote:
>
> On Mon, Aug 19, 2013 at 10:25 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Hello.
> >
> > Colin reports that vfork() doesn't work after unshare(PIDNS). The
> > reason is trivial, copy_process() does:
> >
> >         /*
> >          * If the new process will be in a different pid namespace
> >          * don't allow the creation of threads.
> >          */
> >         if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
> >             (task_active_pid_ns(current) != current->nsproxy->pid_ns))
> >                 return ERR_PTR(-EINVAL);
> >
> > and CLONE_VM obviously nacks vfork(). So perhaps we can relax
> > this check to CLONE_THREAD? Or should we really nack CLONE_VM
> > by security reasons?
> >
> > OTOH. Perhaps we should also deny CLONE_PARENT in this case?
> >
> > In short. So far I am thinking about the patch below but I got
> > lost and totally confused. Will try to think more tomorrow, but
> > I would like to see the fix from someone who still understands
> > this all.
> >
> > Oleg.
>
> By way of (partial) explanation:
>
> http://marc.info/?l=linux-kernel&m=135545831607095

Thanks... too late for me to even try to read this discussion today.

and I am a bit confused,

> (tl;dr: I think that CLONE_VM is irrelevant here, but there may be
> other issues lurking around.)

So do you think this change is fine or not (ignoring the fact it needs
cleanups) ?

Oleg.

