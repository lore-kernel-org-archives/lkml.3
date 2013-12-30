Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab3L3SnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:43:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:46372 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224Ab3L3SlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:41:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,575,1384329600"; 
   d="scan'208";a="457777534"
Subject: [PATCH 07/12] x86 Kconfig: move memtest
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 30 Dec 2013 10:40:55 -0800
References: <20131230184046.F5E42919@viggo.jf.intel.com>
In-Reply-To: <20131230184046.F5E42919@viggo.jf.intel.com>
Message-Id: <20131230184055.36ABB146@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Move the "Memtest" option over to the "Memory Debugging" menu.
The code is not x86 specific at all, but it still resides in
arch/x86, so keep the x86 dependency.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig |   11 -----------
 linux.git-davehans/mm/Kconfig.debug |   12 ++++++++++++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff -puN arch/x86/Kconfig~move-memtest arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~move-memtest	2013-12-30 10:37:45.390241326 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2013-12-30 10:37:45.396241596 -0800
@@ -1186,17 +1186,6 @@ endif #HYPERVISOR_GUEST
 config NO_BOOTMEM
 	def_bool y
 
-config MEMTEST
-	bool "Memtest"
-	---help---
-	  This option adds a kernel parameter 'memtest', which allows memtest
-	  to be set.
-	        memtest=0, mean disabled; -- default
-	        memtest=1, mean do 1 test pattern;
-	        ...
-	        memtest=4, mean do 4 test patterns.
-	  If you are unsure how to answer this question, answer N.
-
 config X86_SUMMIT_NUMA
 	def_bool y
 	depends on X86_32 && NUMA && X86_32_NON_STANDARD
diff -puN mm/Kconfig.debug~move-memtest mm/Kconfig.debug
--- linux.git/mm/Kconfig.debug~move-memtest	2013-12-30 10:37:45.392241416 -0800
+++ linux.git-davehans/mm/Kconfig.debug	2013-12-30 10:37:45.396241596 -0800
@@ -1,3 +1,15 @@
+config MEMTEST
+	bool "Memtest"
+	depends on X86
+	---help---
+	  This option adds a kernel parameter 'memtest', which allows memtest
+	  to be set.
+	        memtest=0, mean disabled; -- default
+	        memtest=1, mean do 1 test pattern;
+	        ...
+	        memtest=4, mean do 4 test patterns.
+	  If you are unsure how to answer this question, answer N.
+
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
 	depends on DEBUG_KERNEL
_
