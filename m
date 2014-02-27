Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaB0QZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:25:43 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42941 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaB0QZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:25:42 -0500
Date: Thu, 27 Feb 2014 08:25:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@freedesktop.org>,
        josh@joshtriplett.org
Subject: Re: [PATCH 16/46] kernel: Mark function as static in
 kernel/rcu/torture.c
Message-ID: <20140227162537.GP8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
 <49b484c2399a29c2b28d0ccec218b26ed36bf9fd.1393493277.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49b484c2399a29c2b28d0ccec218b26ed36bf9fd.1393493277.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022716-1542-0000-0000-000006AF5723
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 05:16:57PM +0530, Rashika Kheria wrote:
> Mark functions as static in kernel/rcu/torture.c because they are not
> used outside this file.
> 
> This eliminates the following warning in kernel/rcu/torture.c:
> kernel/rcu/torture.c:902:6: warning: no previous prototype for ‘rcutorture_trace_dump’ [-Wmissing-prototypes]
> kernel/rcu/torture.c:1572:6: warning: no previous prototype for ‘rcu_torture_barrier_cbf’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Queued for 3.16, thank you both!

I had to hand-apply the patch due to recent changes in my -rcu tree
compared to mainline.  The resulting commit is shown below.  If there
are problems with it, please let me know.

							Thanx, Paul

> ---
>  kernel/rcu/torture.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/torture.c b/kernel/rcu/torture.c
> index 732f8ae..dd3a431 100644
> --- a/kernel/rcu/torture.c
> +++ b/kernel/rcu/torture.c
> @@ -899,7 +899,7 @@ rcu_torture_fakewriter(void *arg)
>  	return 0;
>  }
> 
> -void rcutorture_trace_dump(void)
> +static void rcutorture_trace_dump(void)
>  {
>  	static atomic_t beenhere = ATOMIC_INIT(0);
> 
> @@ -1569,7 +1569,7 @@ static void rcu_torture_stall_cleanup(void)
>  }
> 
>  /* Callback function for RCU barrier testing. */
> -void rcu_torture_barrier_cbf(struct rcu_head *rcu)
> +static void rcu_torture_barrier_cbf(struct rcu_head *rcu)
>  {
>  	atomic_inc(&barrier_cbs_invoked);
>  }
> -- 
> 1.7.9.5
> 

------------------------------------------------------------------------

commit b386536bde22f505cb01f21ac6a63e687657c3df
Author: Rashika Kheria <rashika.kheria@gmail.com>
Date:   Thu Feb 27 17:16:57 2014 +0530

    kernel: Mark function as static in kernel/rcu/torture.c
    
    Mark functions as static in kernel/rcu/torture.c because they are not
    used outside this file.
    
    This eliminates the following warning in kernel/rcu/torture.c:
    kernel/rcu/torture.c:902:6: warning: no previous prototype for ‘rcutorture_trace_dump’ [-Wmissing-prototypes]
    kernel/rcu/torture.c:1572:6: warning: no previous prototype for ‘rcu_torture_barrier_cbf’ [-Wmissing-prototypes]
    
    Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
    Reviewed-by: Josh Triplett <josh@joshtriplett.org>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 0d973f893c18..d78331666bca 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -806,7 +806,7 @@ rcu_torture_fakewriter(void *arg)
 	return 0;
 }
 
-void rcutorture_trace_dump(void)
+static void rcutorture_trace_dump(void)
 {
 	static atomic_t beenhere = ATOMIC_INIT(0);
 
@@ -1183,7 +1183,7 @@ static int __init rcu_torture_stall_init(void)
 }
 
 /* Callback function for RCU barrier testing. */
-void rcu_torture_barrier_cbf(struct rcu_head *rcu)
+static void rcu_torture_barrier_cbf(struct rcu_head *rcu)
 {
 	atomic_inc(&barrier_cbs_invoked);
 }

