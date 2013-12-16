Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab3LPRgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:36:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab3LPRgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:36:19 -0500
Date: Mon, 16 Dec 2013 12:35:47 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
 task->pid and task->tgid
Message-ID: <20131216173547.GA21582@madcap2.tricolour.ca>
References: <cover.1377032086.git.rgb@redhat.com>
 <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
 <20130822190848.GA25053@redhat.com>
 <20130826220711.GA21098@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826220711.GA21098@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/26, Richard Guy Briggs wrote:
> On Thu, Aug 22, 2013 at 09:08:48PM +0200, Oleg Nesterov wrote:
> > On 08/20, Richard Guy Briggs wrote:
> > >
> > >  static inline int is_global_init(struct task_struct *tsk)
> > >  {
> > > -	return tsk->pid == 1;
> > > +	return task_pid_nr(tsk) == 1;
> > >  }
> > 
> > Probably it would be better to simply kill it. Almost every usage is
> > wrong.
> 
> Can you be more clear?  I don't follow.  It should instead return a
> boolean.  Usage of is_global_init() or task_pid_nr()?
> 
> If is_global_init(), is that because they could be unaware of pid
> namespaces?
> 
> If task_pid_nr(), is that for the same reason?

Oleg,  I still don't understand your comment above.  Kill what,
"is_global_init()"?  If so, how is almost every usage of it wrong?

There are a number of functions that call is_global_init().  Might any
of them be called from inside the namespace context of a container and
hence should return true?

> > >  static inline bool is_idle_task(const struct task_struct *p)
> > >  {
> > > -	return p->pid == 0;
> > > +	return task_pid(p) == &init_struct_pid;
> > >  }
> > 
> > hmm. there should be a simpler check for this...
> 
> Other than the original, this one is pretty simple.  What did you have
> in mind?

I vaguely remember a clarification to this, but don't remember and can't
find it.  What sort of simplification did you have in mind?  I'd like to
go at least to:
	task_pid_nr(p) == 0

> > Oleg.
> 
> - RGB

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
