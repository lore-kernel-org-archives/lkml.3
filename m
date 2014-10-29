Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbaJ2LCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:02:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaJ2LCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:02:08 -0400
Date: Wed, 29 Oct 2014 12:01:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com,
        Clark Williams <clark.williams@gmail.com>
Subject: Re: [PATCH tip/core/rcu 4/7] rcu: Unify boost and kthread priorities
Message-ID: <20141029110146.GA3337@twins.programming.kicks-ass.net>
References: <20141028222224.GA28263@linux.vnet.ibm.com>
 <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1414534982-29203-4-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414534982-29203-4-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:22:59PM -0700, Paul E. McKenney wrote:
> From: Clark Williams <clark.williams@gmail.com>
> 
> Rename CONFIG_RCU_BOOST_PRIO to CONFIG_RCU_KTHREAD_PRIO and use this
> value for both the per-CPU kthreads (rcuc/N) and the rcu boosting
> threads (rcub/n).
> 
> Also, create the module_parameter rcutree.kthread_prio to be used on
> the kernel command line at boot to set a new value (rcutree.kthread_prio=N).
> 
> Signed-off-by: Clark Williams <clark.williams@gmail.com>
> [ paulmck: Ported to rcu/dev, applied Paul Bolle feedback. ]
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  Documentation/kernel-parameters.txt                |  6 ++++++
>  init/Kconfig                                       | 23 +++++++++++-----------
>  kernel/rcu/tree_plugin.h                           | 20 +++++++++----------
>  .../selftests/rcutorture/configs/rcu/TREE03        |  2 +-
>  .../selftests/rcutorture/doc/TREE_RCU-kconfig.txt  |  4 ++--
>  5 files changed, 31 insertions(+), 24 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 7dbe5ec9d9cd..7d3b3328bf5c 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2922,6 +2922,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			quiescent states.  Units are jiffies, minimum
>  			value is one, and maximum value is HZ.
>  
> +	rcutree.kthread_prio= 	 [KNL,BOOT]
> +			Set the SCHED_FIFO priority of the RCU
> +			per-CPU kthreads (rcuc/N). This value is also
> +			used for the priority of the RCU boost threads
> +			(rcub/N). Valid values are 1-99.
> +

It would maybe be useful to mention the default?

Also, should we look at running this stuff as deadline in order to
provide interference guarantees etc.. ?
