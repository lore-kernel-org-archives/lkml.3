Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaIYSKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:10:31 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42420 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbaIYSK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:10:29 -0400
Date: Thu, 25 Sep 2014 11:10:24 -0700
From: josh@joshtriplett.org
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] rcu: Add sparse check for RCU_INIT_POINTER()
Message-ID: <20140925181024.GA9360@cloud>
References: <1411668214-19199-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411668214-19199-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 02:03:34PM -0400, Pranith Kumar wrote:
> Add a sparse check when RCU_INIT_POINTER() is used to assign a non __rcu
> annotated pointer. 
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Have you checked if this introduces a significant number of new warnings
in the kernel?

If not:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  include/linux/rcupdate.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index a4a819f..a033d8b 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -1047,6 +1047,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
>   */
>  #define RCU_INIT_POINTER(p, v) \
>  	do { \
> +		rcu_dereference_sparse(p, __rcu); \
>  		p = RCU_INITIALIZER(v); \
>  	} while (0)
>  
> -- 
> 2.1.0
> 
