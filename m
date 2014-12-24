Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaLXSHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 13:07:37 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55997 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaLXSHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 13:07:35 -0500
Date: Wed, 24 Dec 2014 10:00:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?utf-8?B?6JSh5q2j6b6Z?= <zhenglong.cai@cs2c.com.cn>,
        Bertrand Jacquin <beber@meleeweb.net>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Fabian Frederick <fabf@skynet.be>,
        Andy Lutomirski <luto@amacapital.net>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Peter Foley <pefoley2@pefoley.com>, Mel Gorman <mgorman@suse.de>,
        Clark Williams <clark.williams@gmail.com>
Subject: Re: [PATCH] rcu: remove "select IRQ_WORK" from config TREE_RCU
Message-ID: <20141224180000.GF11609@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1419414940-5082-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419414940-5082-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122418-0029-0000-0000-000006A8C257
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 05:55:28PM +0800, Lai Jiangshan wrote:
> The 48a7639ce80c ("rcu: Make callers awaken grace-period kthread")
> removed the irq_work_queue(), so the TREE_RCU doesn't need
> irq work any more.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Good catch, queued for 3.20.  Thank you!

							Thanx, Paul

> ---
>  init/Kconfig      |    2 --
>  kernel/rcu/tree.h |    1 -
>  2 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 9afb971..39b4313 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -470,7 +470,6 @@ choice
>  config TREE_RCU
>  	bool "Tree-based hierarchical RCU"
>  	depends on !PREEMPT && SMP
> -	select IRQ_WORK
>  	help
>  	  This option selects the RCU implementation that is
>  	  designed for very large SMP system with hundreds or
> @@ -480,7 +479,6 @@ config TREE_RCU
>  config PREEMPT_RCU
>  	bool "Preemptible tree-based hierarchical RCU"
>  	depends on PREEMPT
> -	select IRQ_WORK
>  	help
>  	  This option selects the RCU implementation that is
>  	  designed for very large SMP systems with hundreds or
> diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> index 8e7b184..a47a13c 100644
> --- a/kernel/rcu/tree.h
> +++ b/kernel/rcu/tree.h
> @@ -27,7 +27,6 @@
>  #include <linux/threads.h>
>  #include <linux/cpumask.h>
>  #include <linux/seqlock.h>
> -#include <linux/irq_work.h>
> 
>  /*
>   * Define shape of hierarchy based on NR_CPUS, CONFIG_RCU_FANOUT, and
> -- 
> 1.7.4.4
> 

