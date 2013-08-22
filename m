Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3HVUGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:06:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34423 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab3HVUGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:06:14 -0400
Date: Thu, 22 Aug 2013 22:05:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
 task->pid and task->tgid
Message-ID: <20130822200555.GN31370@twins.programming.kicks-ass.net>
References: <cover.1377032086.git.rgb@redhat.com>
 <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 05:32:03PM -0400, Richard Guy Briggs wrote:
> This stops these four task helper functions from using the deprecated and
> error-prone task->pid and task->tgid.
> 
> (informed by ebiederman's ea5a4d01)
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/sched.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8e69807..46e739d 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1579,7 +1579,7 @@ static inline int pid_alive(struct task_struct *p)
>   */
>  static inline int is_global_init(struct task_struct *tsk)
>  {
> -	return tsk->pid == 1;
> +	return task_pid_nr(tsk) == 1;
>  }
>  
>  extern struct pid *cad_pid;
> @@ -1930,7 +1930,7 @@ extern struct task_struct *idle_task(int cpu);
>   */
>  static inline bool is_idle_task(const struct task_struct *p)
>  {
> -	return p->pid == 0;
> +	return task_pid(p) == &init_struct_pid;
>  }
>  extern struct task_struct *curr_task(int cpu);
>  extern void set_curr_task(int cpu, struct task_struct *p);

Why would you ever want to do this? It just makes these tests more
expensive for no gain what so ff'ing ever.
