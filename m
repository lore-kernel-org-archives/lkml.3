Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaBRA3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:29:33 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:40766 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaBRA3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:29:32 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 17 Feb 2014 16:29:18 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 21/55] rcutorture: Export torture_type and
 verbose module parameters
Message-ID: <20140218002917.GG19929@thin>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392675179-11560-21-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392675179-11560-21-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 02:12:25PM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The torture_type and verbose module parameters are needed for log messages,
> so this commit exports them to include/linux/torture.h.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Assuming this doesn't go away (which I really hope it does), this needs
to occur *before* the introduction of the macros using these variables.

- Josh Triplett

>  include/linux/torture.h | 4 ++++
>  kernel/rcu/rcutorture.c | 8 ++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/torture.h b/include/linux/torture.h
> index c61b4ce18a13..9b6a4834de8f 100644
> --- a/include/linux/torture.h
> +++ b/include/linux/torture.h
> @@ -49,6 +49,10 @@ extern int fullstop;
>  /* Protect fullstop transitions and spawning of kthreads.  */
>  extern struct mutex fullstop_mutex;
>  
> +/* Common module parameters. */
> +extern char *torture_type;
> +extern bool verbose;
> +
>  #define TORTURE_FLAG "-torture:"
>  #define TOROUT_STRING(s) \
>  	pr_alert("%s" TORTURE_FLAG s "\n", torture_type)
> diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
> index 3687619b243a..49cdeeaaa54b 100644
> --- a/kernel/rcu/rcutorture.c
> +++ b/kernel/rcu/rcutorture.c
> @@ -90,11 +90,15 @@ torture_parm(int, test_boost_interval, 7,
>  	     "Interval between boost tests, seconds.");
>  torture_parm(bool, test_no_idle_hz, true,
>  	     "Test support for tickless idle CPUs");
> -torture_parm(bool, verbose, false, "Enable verbose debugging printk()s");
>  
> -static char *torture_type = "rcu";
> +char *torture_type = "rcu";
> +EXPORT_SYMBOL_GPL(torture_type);
>  module_param(torture_type, charp, 0444);
>  MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, ...)");
> +bool verbose;
> +EXPORT_SYMBOL_GPL(verbose);
> +module_param(verbose, bool, 0444);
> +MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
>  
>  static int nrealreaders;
>  static struct task_struct *writer_task;
> -- 
> 1.8.1.5
> 
