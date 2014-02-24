Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaBXOS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:18:56 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:52122 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaBXOSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:18:55 -0500
Date: Mon, 24 Feb 2014 06:18:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Liu Ping Fan <kernelfans@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH] rcu: fix incorrect notes for code
Message-ID: <20140224141847.GI8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1393228603-30785-1-git-send-email-pingfank@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393228603-30785-1-git-send-email-pingfank@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022414-0928-0000-0000-000007044872
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 03:56:43PM +0800, Liu Ping Fan wrote:
> -/* Is the specified CPU a no-CPUs CPU? */
> +/* Is the specified CPU a no-CBs CPU? */
>  bool rcu_is_nocb_cpu(int cpu)
> 
> Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

Good catch, queued for 3.16.

							Thanx, Paul

> ---
>  kernel/rcu/tree_plugin.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 6e2ef4b..ec6cb76 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2101,7 +2101,7 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
>  	init_waitqueue_head(&rnp->nocb_gp_wq[1]);
>  }
> 
> -/* Is the specified CPU a no-CPUs CPU? */
> +/* Is the specified CPU a no-CBs CPU? */
>  bool rcu_is_nocb_cpu(int cpu)
>  {
>  	if (have_rcu_nocb_mask)
> -- 
> 1.8.1.4
> 

