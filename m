Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3GAUEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:04:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:31861 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab3GAUEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:04:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,975,1363158000"; 
   d="scan'208";a="338872154"
Subject: [PATCH 7/7] hang and lockup detection menu
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 01 Jul 2013 13:04:50 -0700
References: <20130701200440.712D8B4E@viggo.jf.intel.com>
In-Reply-To: <20130701200440.712D8B4E@viggo.jf.intel.com>
Message-Id: <20130701200450.A8AF31EA@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The hard/softlockup and hung-task entries take up 6 lines
of screen real-estate when enabled.  I bet folks don't
mess with these _that_ often, so move them in a group
down a level.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/lib/Kconfig.debug |   42 +++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff -puN lib/Kconfig.debug~lockup-detection lib/Kconfig.debug
--- linux.git/lib/Kconfig.debug~lockup-detection	2013-07-01 12:53:22.040554999 -0700
+++ linux.git-davehans/lib/Kconfig.debug	2013-07-01 12:53:22.044555177 -0700
@@ -604,6 +604,8 @@ config DEBUG_SHIRQ
 	  Drivers ought to be able to handle interrupts coming in at those
 	  points; some don't and need to be caught.
 
+menu "Debug Lockups and Hangs"
+
 config LOCKUP_DETECTOR
 	bool "Detect Hard and Soft Lockups"
 	depends on DEBUG_KERNEL && !S390
@@ -675,25 +677,6 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
 
-config PANIC_ON_OOPS
-	bool "Panic on Oops"
-	help
-	  Say Y here to enable the kernel to panic when it oopses. This
-	  has the same effect as setting oops=panic on the kernel command
-	  line.
-
-	  This feature is useful to ensure that the kernel does not do
-	  anything erroneous after an oops which could result in data
-	  corruption or other issues.
-
-	  Say N if unsure.
-
-config PANIC_ON_OOPS_VALUE
-	int
-	range 0 1
-	default 0 if !PANIC_ON_OOPS
-	default 1 if PANIC_ON_OOPS
-
 config DETECT_HUNG_TASK
 	bool "Detect Hung Tasks"
 	depends on DEBUG_KERNEL
@@ -748,6 +731,27 @@ config BOOTPARAM_HUNG_TASK_PANIC_VALUE
 	default 0 if !BOOTPARAM_HUNG_TASK_PANIC
 	default 1 if BOOTPARAM_HUNG_TASK_PANIC
 
+endmenu # "Debug lockups and hangs"
+
+config PANIC_ON_OOPS
+	bool "Panic on Oops"
+	help
+	  Say Y here to enable the kernel to panic when it oopses. This
+	  has the same effect as setting oops=panic on the kernel command
+	  line.
+
+	  This feature is useful to ensure that the kernel does not do
+	  anything erroneous after an oops which could result in data
+	  corruption or other issues.
+
+	  Say N if unsure.
+
+config PANIC_ON_OOPS_VALUE
+	int
+	range 0 1
+	default 0 if !PANIC_ON_OOPS
+	default 1 if PANIC_ON_OOPS
+
 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
 	depends on DEBUG_KERNEL && PROC_FS
_
