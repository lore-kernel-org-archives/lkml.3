Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934689Ab3CZQYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:24:33 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44457 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934656Ab3CZQYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:24:30 -0400
Date: Tue, 26 Mar 2013 09:24:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: dipankar@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: don't allocate bootmem from rcu_init
Message-ID: <20130326162412.GK4379@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1364312116-11641-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364312116-11641-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032616-3620-0000-0000-000001C6E0D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 11:35:16AM -0400, Sasha Levin wrote:
> When rcu_init is called we already have slab working, allocating bootmem
> at that point results in warnings and an allocation from slab.

Good catch, queued for 3.11, thank you!

							Thanx, Paul

> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  kernel/rcutree_plugin.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index d084ae3..73bac82 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -87,7 +87,7 @@ static void __init rcu_bootup_announce_oddness(void)
>  #ifdef CONFIG_RCU_NOCB_CPU
>  #ifndef CONFIG_RCU_NOCB_CPU_NONE
>  	if (!have_rcu_nocb_mask) {
> -		alloc_bootmem_cpumask_var(&rcu_nocb_mask);
> +		alloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
>  		have_rcu_nocb_mask = true;
>  	}
>  #ifdef CONFIG_RCU_NOCB_CPU_ZERO
> -- 
> 1.8.1.5
> 

