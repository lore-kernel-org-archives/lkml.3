Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaJKGXM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 02:23:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:64025 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbaJKGXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 02:23:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,697,1406617200"; 
   d="scan'208";a="612847523"
Date: Sat, 11 Oct 2014 06:23:20 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [sched] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000040
Message-ID: <20141010222320.GA5044@intel.com>
References: <20141011051530.GA21803@wfg-t540p.sh.intel.com>
 <20141011010048.7b9bfd54@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141011010048.7b9bfd54@as>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, thanks.

How come it is sent to whole list. Please ignore this. Sorry.

On Sat, Oct 11, 2014 at 01:00:48AM -0500, Chuck Ebbert wrote:
> On Sat, 11 Oct 2014 13:15:30 +0800
> Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > FYI, we noticed the below changes on commit
> > 
> > 445d95d7c384741d133251a9adac935866591c92 ("sched: Remove update_rq_runnable_avg")
> > 
> > [   67.303839] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> > [   67.304014] IP: [<ffffffff810b1d52>] print_cfs_rq+0x4a3/0xa96
> 
> Well that one's pretty obvious:
> 
> 
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -68,14 +68,6 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
>  #define PN(F) \
>  	SEQ_printf(m, "  .%-30s: %lld.%06ld\n", #F, SPLIT_NS((long long)F))
>  
> -	if (!se) {
> -		struct sched_avg *avg = &cpu_rq(cpu)->avg;
> -		P(avg->runnable_avg_sum);
> -		P(avg->runnable_avg_period);
> -		return;
> -	}
> -
> -
>  	PN(se->exec_start);
>  	PN(se->vruntime);
>  	PN(se->sum_exec_runtime);
> 
> 
> You can remove the P() calls from that if statement, but you can't
> remove the whole thing because you will try to dereference a NULL se
> immediately afterward if you do.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
