Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaEFWew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:34:52 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58569 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaEFWev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:34:51 -0400
Date: Tue, 6 May 2014 15:34:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] kernel/rcu/tree.c: make rcu node arrays static const
 char * const
Message-ID: <20140506223446.GZ8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140506192114.60ed15ab76cba9fc10a6e7f3@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506192114.60ed15ab76cba9fc10a6e7f3@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050622-7164-0000-0000-000001901790
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 07:21:14PM +0200, Fabian Frederick wrote:
> Those 2 arrays are being passed to lockdep_init_map with const char *
> and stored in lockdep_map the same way
> 
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Queued for 3.17, thank you Fabian!

							Thanx, Paul

> ---
>  kernel/rcu/tree.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 0c47e30..90ebc83 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -3357,14 +3357,16 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
>  static void __init rcu_init_one(struct rcu_state *rsp,
>  		struct rcu_data __percpu *rda)
>  {
> -	static char *buf[] = { "rcu_node_0",
> -			       "rcu_node_1",
> -			       "rcu_node_2",
> -			       "rcu_node_3" };  /* Match MAX_RCU_LVLS */
> -	static char *fqs[] = { "rcu_node_fqs_0",
> -			       "rcu_node_fqs_1",
> -			       "rcu_node_fqs_2",
> -			       "rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
> +	static const char * const buf[] = {
> +		"rcu_node_0",
> +		"rcu_node_1",
> +		"rcu_node_2",
> +		"rcu_node_3" };  /* Match MAX_RCU_LVLS */
> +	static const char * const fqs[] = {
> +		"rcu_node_fqs_0",
> +		"rcu_node_fqs_1",
> +		"rcu_node_fqs_2",
> +		"rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
>  	int cpustride = 1;
>  	int i;
>  	int j;
> -- 
> 1.8.4.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

