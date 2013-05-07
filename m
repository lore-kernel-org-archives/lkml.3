Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab3EGUsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:48:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:12433 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab3EGUqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:46:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,629,1363158000"; 
   d="scan'208";a="330469299"
Subject: [PATCH 5/7] group locking debugging options
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 07 May 2013 13:46:49 -0700
References: <20130507204642.D010DDC1@viggo.jf.intel.com>
In-Reply-To: <20130507204642.D010DDC1@viggo.jf.intel.com>
Message-Id: <20130507204649.0188E6DB@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave@linux.vnet.ibm.com>

There are quite a few of these, and we want to make sure that
there is one-stop-shopping for lock debugging.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/lib/Kconfig.debug |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN lib/Kconfig.debug~order-lock-debugging-options lib/Kconfig.debug
--- linux.git/lib/Kconfig.debug~order-lock-debugging-options	2013-05-07 13:41:38.156522402 -0700
+++ linux.git-davehans/lib/Kconfig.debug	2013-05-07 13:41:38.160522578 -0700
@@ -703,6 +703,8 @@ config DEBUG_PREEMPT
 	  if kernel code uses it in a preemption-unsafe way. Also, the kernel
 	  will detect preemption count underflows.
 
+menu "Lock Debugging (spinlocks, mutexes, etc...)"
+
 config DEBUG_RT_MUTEXES
 	bool "RT Mutex debugging, deadlock detection"
 	depends on DEBUG_KERNEL && RT_MUTEXES
@@ -832,12 +834,6 @@ config DEBUG_LOCKDEP
 	  additional runtime checks to debug itself, at the price
 	  of more runtime overhead.
 
-config TRACE_IRQFLAGS
-	bool
-	help
-	  Enables hooks to interrupt enabling and disabling for
-	  either tracing or lock debugging.
-
 config DEBUG_ATOMIC_SLEEP
 	bool "Sleep inside atomic section checking"
 	select PREEMPT_COUNT
@@ -859,6 +855,14 @@ config DEBUG_LOCKING_API_SELFTESTS
 	  The following locking APIs are covered: spinlocks, rwlocks,
 	  mutexes and rwsems.
 
+endmenu # lock debugging
+
+config TRACE_IRQFLAGS
+	bool
+	help
+	  Enables hooks to interrupt enabling and disabling for
+	  either tracing or lock debugging.
+
 config STACKTRACE
 	bool
 	depends on STACKTRACE_SUPPORT
_
