Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbaBUQLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:11:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125AbaBUQLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:11:48 -0500
Date: Fri, 21 Feb 2014 11:10:58 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, eparis@redhat.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 5/7] pid: rewrite task helper function is_global_init()
 avoiding task->pid
Message-ID: <20140221161058.GY16640@madcap2.tricolour.ca>
References: <cover.1390495874.git.rgb@redhat.com>
 <a8c13f38e0ecfa2c842f0075dbbde77f3e6befc9.1390495874.git.rgb@redhat.com>
 <20140220183958.GB23993@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220183958.GB23993@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/20, Oleg Nesterov wrote:
> On 01/23, Richard Guy Briggs wrote:
> >
> >  static inline int is_global_init(struct task_struct *tsk)
> >  {
> > -	return tsk->pid == 1;
> > +	return task_pid_nr(tsk) == 1;
> >  }
> 
> ACK, but we need to fix it.
> 
> With or without this change is_global_init() actually means
> is-the-main-thread-of-global-init.
> 
> This is not what the callers actually want. Just look at
> oom_unkillable_task(). Suppose that p is the sub-thread of
> /sbin/init, if we kill this thread we kill the whole process.
> 
> The same of other callers. is_global_init() should return T
> if this task is the part of init's thread group.

Good.  Updated in my tree.

> Oleg.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
