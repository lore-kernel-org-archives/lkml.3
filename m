Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3GAUEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:04:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:54329 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab3GAUEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:04:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,975,1363158000"; 
   d="scan'208";a="325365193"
Subject: [PATCH 3/7] consolidate runtime testing configs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 01 Jul 2013 13:04:44 -0700
References: <20130701200440.712D8B4E@viggo.jf.intel.com>
In-Reply-To: <20130701200440.712D8B4E@viggo.jf.intel.com>
Message-Id: <20130701200444.09573F69@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave@linux.vnet.ibm.com>
Original posting:

	http://lkml.kernel.org/r/20121214184206.FC11422F@kernel.stglabs.ibm.com

These runtime tests are great, except that there are a lot of them,
and they are very rarely needed.  Give them their own menu so that
only the folks who need them will have to go looking for them.

Note that there are some other runtime tests that are not in here,
like for RCU or locking.  This menu should only be used for tests
that do not have a more appropriate home.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/lib/Kconfig.debug |  157 ++++++++++++++++++-----------------
 1 file changed, 81 insertions(+), 76 deletions(-)

diff -puN lib/Kconfig.debug~consolidat-runtime-testing-configs lib/Kconfig.debug
--- linux.git/lib/Kconfig.debug~consolidat-runtime-testing-configs	2013-07-01 12:53:21.002508983 -0700
+++ linux.git-davehans/lib/Kconfig.debug	2013-07-01 12:53:21.006509160 -0700
@@ -861,15 +861,6 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
-config TEST_LIST_SORT
-	bool "Linked list sorting test"
-	depends on DEBUG_KERNEL
-	help
-	  Enable this to turn on 'list_sort()' function test. This test is
-	  executed only once during system boot, so affects only boot time.
-
-	  If unsure, say N.
-
 config DEBUG_SG
 	bool "Debug SG table operations"
 	depends on DEBUG_KERNEL
@@ -1082,33 +1073,6 @@ config RCU_TRACE
 
 endmenu # "RCU Debugging"
 
-config KPROBES_SANITY_TEST
-	bool "Kprobes sanity tests"
-	depends on DEBUG_KERNEL
-	depends on KPROBES
-	default n
-	help
-	  This option provides for testing basic kprobes functionality on
-	  boot. A sample kprobe, jprobe and kretprobe are inserted and
-	  verified for functionality.
-
-	  Say N if you are unsure.
-
-config BACKTRACE_SELF_TEST
-	tristate "Self test for the backtrace code"
-	depends on DEBUG_KERNEL
-	default n
-	help
-	  This option provides a kernel module that can be used to test
-	  the kernel stack backtrace code. This option is not useful
-	  for distributions or general kernels, but only for kernel
-	  developers working on architecture code.
-
-	  Note that if you want to also test saved backtraces, you will
-	  have to enable STACKTRACE as well.
-
-	  Say N if you are unsure.
-
 config DEBUG_BLOCK_EXT_DEVT
         bool "Force extended block device numbers and spread them"
 	depends on DEBUG_KERNEL
@@ -1151,21 +1115,6 @@ config DEBUG_FORCE_WEAK_PER_CPU
 	  To ensure that generic code follows the above rules, this
 	  option forces all percpu variables to be defined as weak.
 
-config LKDTM
-	tristate "Linux Kernel Dump Test Tool Module"
-	depends on DEBUG_FS
-	depends on BLOCK
-	default n
-	help
-	This module enables testing of the different dumping mechanisms by
-	inducing system failures at predefined crash points.
-	If you don't need it: say N
-	Choose M here to compile this code as a module. The module will be
-	called lkdtm.
-
-	Documentation on how to use the module can be found in
-	Documentation/fault-injection/provoke-crashes.txt
-
 config NOTIFIER_ERROR_INJECTION
 	tristate "Notifier error injection"
 	depends on DEBUG_KERNEL
@@ -1341,6 +1290,59 @@ config DEBUG_STRICT_USER_COPY_CHECKS
 
 source kernel/trace/Kconfig
 
+menu "Runtime Testing"
+
+config LKDTM
+	tristate "Linux Kernel Dump Test Tool Module"
+	depends on DEBUG_FS
+	depends on BLOCK
+	default n
+	help
+	This module enables testing of the different dumping mechanisms by
+	inducing system failures at predefined crash points.
+	If you don't need it: say N
+	Choose M here to compile this code as a module. The module will be
+	called lkdtm.
+
+	Documentation on how to use the module can be found in
+	Documentation/fault-injection/provoke-crashes.txt
+
+config TEST_LIST_SORT
+	bool "Linked list sorting test"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on 'list_sort()' function test. This test is
+	  executed only once during system boot, so affects only boot time.
+
+	  If unsure, say N.
+
+config KPROBES_SANITY_TEST
+	bool "Kprobes sanity tests"
+	depends on DEBUG_KERNEL
+	depends on KPROBES
+	default n
+	help
+	  This option provides for testing basic kprobes functionality on
+	  boot. A sample kprobe, jprobe and kretprobe are inserted and
+	  verified for functionality.
+
+	  Say N if you are unsure.
+
+config BACKTRACE_SELF_TEST
+	tristate "Self test for the backtrace code"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  This option provides a kernel module that can be used to test
+	  the kernel stack backtrace code. This option is not useful
+	  for distributions or general kernels, but only for kernel
+	  developers working on architecture code.
+
+	  Note that if you want to also test saved backtraces, you will
+	  have to enable STACKTRACE as well.
+
+	  Say N if you are unsure.
+
 config RBTREE_TEST
 	tristate "Red-Black tree test"
 	depends on m && DEBUG_KERNEL
@@ -1354,6 +1356,34 @@ config INTERVAL_TREE_TEST
 	help
 	  A benchmark measuring the performance of the interval tree library
 
+config ATOMIC64_SELFTEST
+	bool "Perform an atomic64_t self-test at boot"
+	help
+	  Enable this option to test the atomic64_t functions at boot.
+
+	  If unsure, say N.
+
+config ASYNC_RAID6_TEST
+	tristate "Self test for hardware accelerated raid6 recovery"
+	depends on ASYNC_RAID6_RECOV
+	select ASYNC_MEMCPY
+	---help---
+	  This is a one-shot self test that permutes through the
+	  recovery of all the possible two disk failure scenarios for a
+	  N-disk array.  Recovery is performed with the asynchronous
+	  raid6 recovery routines, and will optionally use an offload
+	  engine if one is available.
+
+	  If unsure, say N.
+
+config TEST_STRING_HELPERS
+	tristate "Test functions located in the string_helpers module at runtime"
+
+config TEST_KSTRTOX
+	tristate "Test kstrto*() family of functions at runtime"
+
+endmenu # runtime tests
+
 config PROVIDE_OHCI1394_DMA_INIT
 	bool "Remote debugging over FireWire early on boot"
 	depends on PCI && X86
@@ -1483,32 +1513,7 @@ config DMA_API_DEBUG
 	  This option causes a performance degredation.  Use only if you want
 	  to debug device drivers. If unsure, say N.
 
-config ATOMIC64_SELFTEST
-	bool "Perform an atomic64_t self-test at boot"
-	help
-	  Enable this option to test the atomic64_t functions at boot.
-
-	  If unsure, say N.
-
-config ASYNC_RAID6_TEST
-	tristate "Self test for hardware accelerated raid6 recovery"
-	depends on ASYNC_RAID6_RECOV
-	select ASYNC_MEMCPY
-	---help---
-	  This is a one-shot self test that permutes through the
-	  recovery of all the possible two disk failure scenarios for a
-	  N-disk array.  Recovery is performed with the asynchronous
-	  raid6 recovery routines, and will optionally use an offload
-	  engine if one is available.
-
-	  If unsure, say N.
-
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
 
-config TEST_STRING_HELPERS
-	tristate "Test functions located in the string_helpers module at runtime"
-
-config TEST_KSTRTOX
-	tristate "Test kstrto*() family of functions at runtime"
_
