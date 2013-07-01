Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3GAUFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:05:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:16137 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab3GAUFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:05:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,975,1363158000"; 
   d="scan'208";a="363033473"
Subject: [PATCH 5/7] group locking debugging options
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 01 Jul 2013 13:04:47 -0700
References: <20130701200440.712D8B4E@viggo.jf.intel.com>
In-Reply-To: <20130701200440.712D8B4E@viggo.jf.intel.com>
Message-Id: <20130701200447.C1FED10A@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave@linux.vnet.ibm.com>

Original posting:

	http://lkml.kernel.org/r/20121214184208.D9E5804D@kernel.stglabs.ibm.com

There are quite a few of these, and we want to make sure that
there is one-stop-shopping for lock debugging.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/lib/Kconfig.debug |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN lib/Kconfig.debug~order-lock-debugging-options lib/Kconfig.debug
--- linux.git/lib/Kconfig.debug~order-lock-debugging-options	2013-07-01 12:53:21.523532080 -0700
+++ linux.git-davehans/lib/Kconfig.debug	2013-07-01 12:53:21.526532213 -0700
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
