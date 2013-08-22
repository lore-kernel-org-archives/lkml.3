Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3HVVoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:44:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab3HVVoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:44:20 -0400
Date: Thu, 22 Aug 2013 17:43:47 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
 task->pid and task->tgid
Message-ID: <20130822214347.GB21110@madcap2.tricolour.ca>
References: <cover.1377032086.git.rgb@redhat.com>
 <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
 <20130822200555.GN31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822200555.GN31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 10:05:55PM +0200, Peter Zijlstra wrote:
> On Tue, Aug 20, 2013 at 05:32:03PM -0400, Richard Guy Briggs wrote:
> > This stops these four task helper functions from using the deprecated and
> > error-prone task->pid and task->tgid.
> > 
> > (informed by ebiederman's ea5a4d01)
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/sched.h |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 8e69807..46e739d 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1579,7 +1579,7 @@ static inline int pid_alive(struct task_struct *p)
> >   */
> >  static inline int is_global_init(struct task_struct *tsk)
> >  {
> > -	return tsk->pid == 1;
> > +	return task_pid_nr(tsk) == 1;
> >  }
> >  
> >  extern struct pid *cad_pid;
> > @@ -1930,7 +1930,7 @@ extern struct task_struct *idle_task(int cpu);
> >   */
> >  static inline bool is_idle_task(const struct task_struct *p)
> >  {
> > -	return p->pid == 0;
> > +	return task_pid(p) == &init_struct_pid;
> >  }
> >  extern struct task_struct *curr_task(int cpu);
> >  extern void set_curr_task(int cpu, struct task_struct *p);
> 
> Why would you ever want to do this? It just makes these tests more
> expensive for no gain what so ff'ing ever.

Backups are generally considered a good idea, but in this case, I'd
quote:
	"A man with one watch knows what time it is. A man with two is
	never certain."

Reminds me of the twist of a phrase frequently seen in the US gov:
	"Government Duplicity, Do Not Propagate"   ;-)


Can you suggest a safe way to live with this duplicity?


- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
