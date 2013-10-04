Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3JDTeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:34:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38181 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751577Ab3JDTeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:34:04 -0400
Date: Fri, 4 Oct 2013 15:34:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <mgalbraith@suse.de>,
        tomk@rgmadvisors.com, Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: Re: [PATCH] sched/rt: Remove redundant nr_cpus_allowed test
Message-ID: <20131004153401.76fbbb0e@gandalf.local.home>
In-Reply-To: <1380914693-24634-1-git-send-email-shawn.bohrer@gmail.com>
References: <1380914693-24634-1-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Oct 2013 14:24:53 -0500
Shawn Bohrer <shawn.bohrer@gmail.com> wrote:

> From: Shawn Bohrer <sbohrer@rgmadvisors.com>
> 
> In 76854c7e8f3f4172fef091e78d88b3b751463ac6 "sched: Use
> rt.nr_cpus_allowed to recover select_task_rq() cycles" an optimization
> was added to select_task_rq_rt() that immediately returns when
> p->nr_cpus_allowed == 1 at the beginning of the function.  This makes
> the latter p->nr_cpus_allowed > 1 check redundant and can be removed.
> 
> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  kernel/sched/rt.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 01970c8..ceebfba 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1213,8 +1213,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
>  	 */
>  	if (curr && unlikely(rt_task(curr)) &&
>  	    (curr->nr_cpus_allowed < 2 ||
> -	     curr->prio <= p->prio) &&
> -	    (p->nr_cpus_allowed > 1)) {
> +	     curr->prio <= p->prio)) {
>  		int target = find_lowest_rq(p);
>  
>  		if (target != -1)

