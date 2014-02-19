Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaBSSPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:15:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbaBSSPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:15:32 -0500
Date: Wed, 19 Feb 2014 13:15:01 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, eparis@redhat.com, sgrubb@redhat.com,
        peterz@infradead.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7][RFC] pid: changes to support audit
Message-ID: <20140219181501.GO16640@madcap2.tricolour.ca>
References: <20131220140417.GE14884@madcap2.tricolour.ca>
 <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com>
 <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
 <20131217095801.GF21999@twins.programming.kicks-ass.net>
 <20131220044826.GF14944@madcap2.tricolour.ca>
 <20131220085846.GA21999@twins.programming.kicks-ass.net>
 <cover.1390495874.git.rgb@redhat.com>
 <20140219161858.GN16640@madcap2.tricolour.ca>
 <20140219174745.GA9784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219174745.GA9784@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/19, Oleg Nesterov wrote:
> Richard,

Hi Oleg,

> I am sorry for delay, I'll try to review this series tomorrow.
> 
> But at first glance, can't you send 2/7 first and join 1/7 and 3/7?

Yes, Peter made the same observation.  I thought it was more useful to
have them seperated out, but I'll join them.

> And since you change is_global_init() perhaps you can also fix it?
> It actually needs tgid.

Sure.  Can you explain why?  We only want init killing off its own
threads?

> On 02/19, Richard Guy Briggs wrote:
> > Andrew,
> >
> > Are you willing to shepherd this patchset?
> >
> > On 14/01/23, Richard Guy Briggs wrote:
> > > These are a number of patches inspired by ebiederman's container work that were
> > > included by me 2013-08-20 as the patchset:
> > > 	RFC: steps to make audit pid namespace-safe
> > >
> > > They have been seperated out for the pid maintainer since there are no direct
> > > dependencies from the audit pid namespace patchset with the exception of:
> > > 	pid: get pid_t ppid of task in init_pid_ns
> > >
> > > Andrew, are you willing to adopt these?
> > >
> > > In particular, there is discussion around read-only task_struct::pid here:
> > > 	https://lkml.org/lkml/2013/12/16/552
> > >
> > > Richard Guy Briggs (7):
> > >   pid: change task_struct::pid to read-only
> > >   compiler: CONST_CAST makes writing const vars easier and obvious
> > >   pid: use the CONST_CAST macro instead to write to const
> > >     task_struct::pid
> > >   pid: modify task_tgid_nr to work without task->tgid.
> > >   pid: rewrite task helper function is_global_init() avoiding task->pid
> > >   pid: mark struct task const in helper functions
> > >   pid: get pid_t ppid of task in init_pid_ns
> > >
> > >  arch/x86/kernel/process.c |    2 +-
> > >  fs/exec.c                 |    2 +-
> > >  include/linux/compiler.h  |    8 ++++++
> > >  include/linux/sched.h     |   60 +++++++++++++++++++++++++++++---------------
> > >  kernel/fork.c             |    5 ++-
> > >  kernel/pid.c              |    4 +-
> > >  6 files changed, 54 insertions(+), 27 deletions(-)
> >
> > - RGB

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
