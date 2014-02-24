Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaBXEmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 23:42:10 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59090 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaBXEmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 23:42:07 -0500
Date: Sun, 23 Feb 2014 20:42:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: Re: linux-next: manual merge of the rcu tree with the tip tree
Message-ID: <20140224044159.GG8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140224151801.198f04c4341f449d9eae09d4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224151801.198f04c4341f449d9eae09d4@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022404-1542-0000-0000-0000068E967B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 03:18:01PM +1100, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the rcu tree got a conflict in
> kernel/rcu/rcutorture.c between commit d277d868dab6 ("rcu: Use MAX_NICE
> to replace hardcoding of 19") from the tip tree (where this file is
> called kernel/rcu/torture.c) and commit 5ccf60f23d33 ("rcutorture: Rename
> PRINTK to TOROUT") from the rcu tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Hello, Stephen,

Looks correct at first glance, thank you!

							Thanx, Paul

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc kernel/rcu/rcutorture.c
> index 219761db1a46,f59d48597dde..000000000000
> --- a/kernel/rcu/rcutorture.c
> +++ b/kernel/rcu/rcutorture.c
> @@@ -802,10 -693,10 +693,10 @@@ rcu_torture_writer(void *arg
>   	struct rcu_torture *rp;
>   	struct rcu_torture *rp1;
>   	struct rcu_torture *old_rp;
> - 	static DEFINE_RCU_RANDOM(rand);
> + 	static DEFINE_TORTURE_RANDOM(rand);
>   
> - 	VERBOSE_PRINTK_STRING("rcu_torture_writer task started");
> + 	VERBOSE_TOROUT_STRING("rcu_torture_writer task started");
>  -	set_user_nice(current, 19);
>  +	set_user_nice(current, MAX_NICE);
>   
>   	do {
>   		schedule_timeout_uninterruptible(1);
> @@@ -868,19 -756,19 +756,19 @@@
>   static int
>   rcu_torture_fakewriter(void *arg)
>   {
> - 	DEFINE_RCU_RANDOM(rand);
> + 	DEFINE_TORTURE_RANDOM(rand);
>   
> - 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
> + 	VERBOSE_TOROUT_STRING("rcu_torture_fakewriter task started");
>  -	set_user_nice(current, 19);
>  +	set_user_nice(current, MAX_NICE);
>   
>   	do {
> - 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
> - 		udelay(rcu_random(&rand) & 0x3ff);
> + 		schedule_timeout_uninterruptible(1 + torture_random(&rand)%10);
> + 		udelay(torture_random(&rand) & 0x3ff);
>   		if (cur_ops->cb_barrier != NULL &&
> - 		    rcu_random(&rand) % (nfakewriters * 8) == 0) {
> + 		    torture_random(&rand) % (nfakewriters * 8) == 0) {
>   			cur_ops->cb_barrier();
>   		} else if (gp_normal == gp_exp) {
> - 			if (rcu_random(&rand) & 0x80)
> + 			if (torture_random(&rand) & 0x80)
>   				cur_ops->sync();
>   			else
>   				cur_ops->exp_sync();
> @@@ -986,8 -871,8 +871,8 @@@ rcu_torture_reader(void *arg
>   	struct timer_list t;
>   	unsigned long long ts;
>   
> - 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
> + 	VERBOSE_TOROUT_STRING("rcu_torture_reader task started");
>  -	set_user_nice(current, 19);
>  +	set_user_nice(current, MAX_NICE);
>   	if (irqreader && cur_ops->irq_capable)
>   		setup_timer_on_stack(&t, rcu_torture_timer, 0);
>   
> @@@ -1583,8 -1160,8 +1160,8 @@@ static int rcu_torture_barrier_cbs(voi
>   	struct rcu_head rcu;
>   
>   	init_rcu_head_on_stack(&rcu);
> - 	VERBOSE_PRINTK_STRING("rcu_torture_barrier_cbs task started");
> + 	VERBOSE_TOROUT_STRING("rcu_torture_barrier_cbs task started");
>  -	set_user_nice(current, 19);
>  +	set_user_nice(current, MAX_NICE);
>   	do {
>   		wait_event(barrier_cbs_wq[myid],
>   			   (newphase =


