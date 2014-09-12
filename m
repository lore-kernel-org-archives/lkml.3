Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbaILRvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:51:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52736 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaILRvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:51:33 -0400
Date: Fri, 12 Sep 2014 10:51:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 1/9] locktorture: Rename locktorture_runnable parameter
Message-ID: <20140912175128.GA20270@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
 <1410493224-3312-2-git-send-email-dave@stgolabs.net>
 <20140912174026.GD4775@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912174026.GD4775@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091217-6688-0000-0000-000004B7CE6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 10:40:26AM -0700, Paul E. McKenney wrote:

[ . . . ]

> locktorture: Make torture scripting account for new _runnable name
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
> index 9746ea1cd6c7..252aae618984 100644
> --- a/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
> +++ b/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
> @@ -38,6 +38,6 @@ per_version_boot_params () {
>  	echo $1 `locktorture_param_onoff "$1" "$2"` \
>  		locktorture.stat_interval=15 \
>  		locktorture.shutdown_secs=$3 \
> -		locktorture.locktorture_runnable=1 \
> +		locktorture.torture_runnable=1 \
>  		locktorture.verbose=1
>  }

And I apparently forgot to document locktorture's kernel parameters...

							Thanx, Paul

------------------------------------------------------------------------

locktorture: Document boot/module parameters
    
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c8b6beb3edda..c04fb60f4cb3 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1704,6 +1704,49 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	lockd.nlm_udpport=M	[NFS] Assign UDP port.
 			Format: <integer>
 
+	locktorture.nreaders_stress= [KNL]
+			Set the number of locking read-acquisition kthreads.
+			Defaults to being automatically set based on the
+			number of online CPUs.
+
+	locktorture.nwriters_stress= [KNL]
+			Set the number of locking write-acquisition kthreads.
+
+	locktorture.onoff_holdoff= [KNL]
+			Set time (s) after boot for CPU-hotplug testing.
+
+	locktorture.onoff_interval= [KNL]
+			Set time (s) between CPU-hotplug operations, or
+			zero to disable CPU-hotplug testing.
+
+	locktorture.shuffle_interval= [KNL]
+			Set task-shuffle interval (jiffies).  Shuffling
+			tasks allows some CPUs to go into dyntick-idle
+			mode during the locktorture test.
+
+	locktorture.shutdown_secs= [KNL]
+			Set time (s) after boot system shutdown.  This
+			is useful for hands-off automated testing.
+
+	locktorture.stat_interval= [KNL]
+			Time (s) between statistics printk()s.
+
+	locktorture.stutter= [KNL]
+			Time (s) to stutter testing, for example,
+			specifying five seconds causes the test to run for
+			five seconds, wait for five seconds, and so on.
+			This tests the locking primitive's ability to
+			transition abruptly to and from idle.
+
+	locktorture.torture_runnable= [BOOT]
+			Start locktorture running at boot time.
+
+	locktorture.torture_type= [KNL]
+			Specify the locking implementation to test.
+
+	locktorture.verbose= [KNL]
+			Enable additional printk() statements.
+
 	logibm.irq=	[HW,MOUSE] Logitech Bus Mouse Driver
 			Format: <irq>
 

