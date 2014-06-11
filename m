Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbaFKVr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:47:56 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56382 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaFKVrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:47:55 -0400
Date: Wed, 11 Jun 2014 14:47:52 -0700
From: josh@joshtriplett.org
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] kernel/rcu/rcutorture.c:185 fix a sparse
 warning
Message-ID: <20140611214752.GC16940@cloud>
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
 <1402519183-12752-6-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402519183-12752-6-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:39:43PM -0400, Pranith Kumar wrote:
> fix the following sparse warning
> 
> kernel/rcu/rcutorture.c:185:1: warning: symbol 'boost_mutex' was not declared. Should it be static?
> 
> by marking boost_mutex as a static mutex
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Please preserve the comment alignment (by deleting a tab).  With that
fixed:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcu/rcutorture.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
> index 7fa34f8..1cd4b2d 100644
> --- a/kernel/rcu/rcutorture.c
> +++ b/kernel/rcu/rcutorture.c
> @@ -182,7 +182,7 @@ static u64 notrace rcu_trace_clock_local(void)
>  #endif /* #else #ifdef CONFIG_RCU_TRACE */
>  
>  static unsigned long boost_starttime;	/* jiffies of next boost test start. */
> -DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
> +static DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
>  					/*  and boost task create/destroy. */
>  static atomic_t barrier_cbs_count;	/* Barrier callbacks registered. */
>  static bool barrier_phase;		/* Test phase. */
> -- 
> 1.9.1
> 
