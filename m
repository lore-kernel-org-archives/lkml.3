Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaJESrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 14:47:41 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35611 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaJESrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 14:47:40 -0400
Date: Sun, 5 Oct 2014 11:47:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, jiri@resnulli.us
Subject: Re: [PATCH v2 2/2] workqueue: use cond_resched_rcu_qs macro
Message-ID: <20141005184734.GU5015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1412529862-17954-1-git-send-email-joe.lawrence@stratus.com>
 <1412529862-17954-3-git-send-email-joe.lawrence@stratus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412529862-17954-3-git-send-email-joe.lawrence@stratus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100518-6688-0000-0000-000005506C56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 01:24:22PM -0400, Joe Lawrence wrote:
> Tidy up and use cond_resched_rcu_qs when calling cond_resched and
> reporting potential quiescent state to RCU.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/workqueue.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 345bec9..09b685d 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2046,8 +2046,7 @@ __acquires(&pool->lock)
>  	 * stop_machine. At the same time, report a quiescent RCU state so
>  	 * the same condition doesn't freeze RCU.
>  	 */
> -	rcu_note_voluntary_context_switch(current);
> -	cond_resched();
> +	cond_resched_rcu_qs();
> 
>  	spin_lock_irq(&pool->lock);
> 
> -- 
> 1.7.10.4
> 

