Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaBKPnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:43:41 -0500
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:47025 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaBKPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:43:40 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 11 Feb 2014 07:37:32 -0800
From: Josh Triplett <josh@freedesktop.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 5/9] rcu: Use MAX_NICE to replace hard coding of 19.
Message-ID: <20140211153732.GA2985@leaf>
References: <cover.1392103744.git.yangds.fnst@cn.fujitsu.com>
 <5b3bf232f41b33ab703a1595e94671b303e2d1fc.1392103744.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b3bf232f41b33ab703a1595e94671b303e2d1fc.1392103744.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 03:34:49PM +0800, Dongsheng Yang wrote:
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> cc: Josh Triplett <josh@freedesktop.org>
> cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> cc: Peter Zijlstra <peterz@infradead.org>
> cc: Ingo Molnar <mingo@kernel.org>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcu/torture.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/rcu/torture.c b/kernel/rcu/torture.c
> index 732f8ae..219761d 100644
> --- a/kernel/rcu/torture.c
> +++ b/kernel/rcu/torture.c
> @@ -805,7 +805,7 @@ rcu_torture_writer(void *arg)
>  	static DEFINE_RCU_RANDOM(rand);
>  
>  	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
> -	set_user_nice(current, 19);
> +	set_user_nice(current, MAX_NICE);
>  
>  	do {
>  		schedule_timeout_uninterruptible(1);
> @@ -871,7 +871,7 @@ rcu_torture_fakewriter(void *arg)
>  	DEFINE_RCU_RANDOM(rand);
>  
>  	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
> -	set_user_nice(current, 19);
> +	set_user_nice(current, MAX_NICE);
>  
>  	do {
>  		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
> @@ -987,7 +987,7 @@ rcu_torture_reader(void *arg)
>  	unsigned long long ts;
>  
>  	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
> -	set_user_nice(current, 19);
> +	set_user_nice(current, MAX_NICE);
>  	if (irqreader && cur_ops->irq_capable)
>  		setup_timer_on_stack(&t, rcu_torture_timer, 0);
>  
> @@ -1584,7 +1584,7 @@ static int rcu_torture_barrier_cbs(void *arg)
>  
>  	init_rcu_head_on_stack(&rcu);
>  	VERBOSE_PRINTK_STRING("rcu_torture_barrier_cbs task started");
> -	set_user_nice(current, 19);
> +	set_user_nice(current, MAX_NICE);
>  	do {
>  		wait_event(barrier_cbs_wq[myid],
>  			   (newphase =
> -- 
> 1.8.2.1
> 
