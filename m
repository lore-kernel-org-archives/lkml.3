Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3LTEyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:54:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab3LTEyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 23:54:40 -0500
Date: Thu, 19 Dec 2013 23:54:13 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
 task->pid and task->tgid
Message-ID: <20131220045413.GG14944@madcap2.tricolour.ca>
References: <cover.1377032086.git.rgb@redhat.com>
 <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
 <20130822190848.GA25053@redhat.com>
 <20130826220711.GA21098@madcap2.tricolour.ca>
 <20131216173547.GA21582@madcap2.tricolour.ca>
 <20131216210558.GA8565@redhat.com>
 <20131216222051.GA21056@madcap2.tricolour.ca>
 <20131217093442.GE21999@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217093442.GE21999@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/17, Peter Zijlstra wrote:
> On Mon, Dec 16, 2013 at 05:20:51PM -0500, Richard Guy Briggs wrote:
> 
>  >  static inline bool is_idle_task(const struct task_struct *p)
>  >  {
>  > -	return p->pid == 0;
>  > +	return task_pid(p) == &init_struct_pid;
>  >  }
> 
> > I'll stick with task_pid_nr(p) == 0.
> 
> We're going to probably switch to:
> 
>   return p->flags & PF_IDLE;
> 
> Soon, because people are playing silly tricks and want normal threads
> to temporarily appear to be the idle thread (idle time injection).

Ok, this addresses my concerns.  I'll stay out of the way.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
