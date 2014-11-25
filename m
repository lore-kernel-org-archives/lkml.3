Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaKYQ5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:57:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaKYQ5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:57:38 -0500
Date: Tue, 25 Nov 2014 17:57:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] exit/pid_ns: comments + simple fix
Message-ID: <20141125165726.GA28913@redhat.com>
References: <20141107201424.GA22209@redhat.com> <20141124200602.GA20575@redhat.com> <87ioi4fex5.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ioi4fex5.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > Eric, Pavel, could you review 1/2 ? (documentation only). It is based on the
> > code inspection, I didn't bother to verify that my understanding matches the
> > reality ;)
> >
> > On 11/20, Oleg Nesterov wrote:
> >>
> >>
> >> Probably this is not the last series... in particular it seems that we
> >> have some problems with sys_setns() in this area, but I need to recheck.
> >
> > So far only the documentation fix. I'll write another email (hopefully with the
> > patch), afaics at least setns() doesn't play well with PR_SET_CHILD_SUBREAPER.
> >
> > Contrary to what I thought zap_pid_ns_processes() looks fine, but it seems only
> > by accident. Unless I am totally confused, wait for "nr_hashed == init_pids"
> > could be removed after 0a01f2cc390e10633a "pidns: Make the pidns proc mount/
> > umount logic obvious". However, now that setns() + fork() can inject a task
> > into a child namespace, we need this code again for another reason.
> >
> > I _think_ we can actually remove it and simplify free_pid() as well, but lets
> > discuss this later and fix the wrong/confusing documentation first.
>
> At the very least there is the issue of rusage being wrong if we allow
> the init process to be reaped before all of it's children are reaped.

Do you mean cstime/cutime/c* accounting?

Firstly it is not clear what makes child_reaper special in _this_ sense, but
this doesn't matter at all.

The auotoreaping/EXIT_DEAD children are not accounted, only wait_task_zombie()
accumulates these counters. (just in case, accounting in __exit_signal() is
another thing).

> There is also a huge level of weird non-intuitive behavior that would
> require some substantial benefits to justify an optimization of letting
> a child exist longer than init.

Sure. That is why I said "lets discuss this later". This patch doesn't try
to change the rules. It only tries to document the current code.

Oleg.

