Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab3JVUrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 16:47:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60922 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab3JVUrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 16:47:04 -0400
Date: Tue, 22 Oct 2013 22:46:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [sched] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84
 put_online_cpus()
Message-ID: <20131022204659.GE2490@laptop.programming.kicks-ass.net>
References: <20131019005129.GA5979@localhost>
 <52649F5E.2080303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52649F5E.2080303@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 11:28:30AM +0800, Michael wang wrote:
> Hi, Fengguang
> 
> On 10/19/2013 08:51 AM, Fengguang Wu wrote:
> > Greetings,
> 
> Will this do any helps?
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index c06b8d3..7c61f31 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3716,7 +3716,6 @@ long sched_setaffinity(pid_t pid, const struct
> cpumask *in_mask)
>         p = find_process_by_pid(pid);
>         if (!p) {
>                 rcu_read_unlock();
> -               put_online_cpus();
>                 return -ESRCH;
>         }

Just so..
