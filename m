Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaILRkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:40:33 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47451 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaILRkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:40:31 -0400
Date: Fri, 12 Sep 2014 10:40:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 1/9] locktorture: Rename locktorture_runnable parameter
Message-ID: <20140912174026.GD4775@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
 <1410493224-3312-2-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410493224-3312-2-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091217-6688-0000-0000-000004B7BA80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 08:40:16PM -0700, Davidlohr Bueso wrote:
> ... to just 'torture_runnable'. It follows other variable naming
> and is shorter.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

Looks good -- and please see below for the corresponding change to the
locktorture scripting.  (Which I have queued separately after this change.)

> ---
>  kernel/locking/locktorture.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
> index 0955b88..8c770b2 100644
> --- a/kernel/locking/locktorture.c
> +++ b/kernel/locking/locktorture.c
> @@ -87,9 +87,9 @@ static struct lock_writer_stress_stats *lwsa;
>  #else
>  #define LOCKTORTURE_RUNNABLE_INIT 0
>  #endif
> -int locktorture_runnable = LOCKTORTURE_RUNNABLE_INIT;
> -module_param(locktorture_runnable, int, 0444);
> -MODULE_PARM_DESC(locktorture_runnable, "Start locktorture at module init");
> +int torture_runnable = LOCKTORTURE_RUNNABLE_INIT;
> +module_param(torture_runnable, int, 0444);
> +MODULE_PARM_DESC(torture_runnable, "Start locktorture at module init");
> 
>  /* Forward reference. */
>  static void lock_torture_cleanup(void);
> @@ -355,7 +355,7 @@ static int __init lock_torture_init(void)
>  		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
>  	};
> 
> -	if (!torture_init_begin(torture_type, verbose, &locktorture_runnable))
> +	if (!torture_init_begin(torture_type, verbose, &torture_runnable))
>  		return -EBUSY;
> 
>  	/* Process args and tell the world that the torturer is on the job. */
> -- 
> 1.8.4.5

locktorture: Make torture scripting account for new _runnable name

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
index 9746ea1cd6c7..252aae618984 100644
--- a/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
+++ b/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
@@ -38,6 +38,6 @@ per_version_boot_params () {
 	echo $1 `locktorture_param_onoff "$1" "$2"` \
 		locktorture.stat_interval=15 \
 		locktorture.shutdown_secs=$3 \
-		locktorture.locktorture_runnable=1 \
+		locktorture.torture_runnable=1 \
 		locktorture.verbose=1
 }

