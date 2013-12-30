Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab3L3Sla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:41:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:35345 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab3L3Sl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:41:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,575,1384329600"; 
   d="scan'208";a="459530733"
Subject: [PATCH 06/12] x86 Kconfig: scheduler options
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 30 Dec 2013 10:40:54 -0800
References: <20131230184046.F5E42919@viggo.jf.intel.com>
In-Reply-To: <20131230184046.F5E42919@viggo.jf.intel.com>
Message-Id: <20131230184054.9E481541@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

These are a few architecture-specific options that affect the
scheduler.  Group them together.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/Kconfig |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN arch/x86/Kconfig~x86-scheduler-options arch/x86/Kconfig
--- linux.git/arch/x86/Kconfig~x86-scheduler-options	2013-12-30 10:37:45.108228650 -0800
+++ linux.git-davehans/arch/x86/Kconfig	2013-12-30 10:37:45.112228830 -0800
@@ -1100,18 +1100,6 @@ config X86_32_IRIS
 
 	  If unused, say N.
 
-config SCHED_OMIT_FRAME_POINTER
-	def_bool y
-	prompt "Single-depth WCHAN output"
-	depends on X86
-	---help---
-	  Calculate simpler /proc/<PID>/wchan values. If this option
-	  is disabled then wchan values will recurse back to the
-	  caller function. This provides more accurate wchan values,
-	  at the expense of slightly more scheduling overhead.
-
-	  If in doubt, say "Y".
-
 menuconfig HYPERVISOR_GUEST
 	bool "Linux guest support"
 	---help---
@@ -1327,6 +1315,8 @@ config IOMMU_HELPER
 	def_bool y
 	depends on CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU
 
+menu "x86 Scheduler Options"
+
 config SCHED_SMT
 	bool "SMT (Hyperthreading) scheduler support"
 	depends on X86_HT
@@ -1345,6 +1335,20 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+config SCHED_OMIT_FRAME_POINTER
+	def_bool y
+	prompt "Single-depth WCHAN output"
+	depends on X86
+	---help---
+	  Calculate simpler /proc/<PID>/wchan values. If this option
+	  is disabled then wchan values will recurse back to the
+	  caller function. This provides more accurate wchan values,
+	  at the expense of slightly more scheduling overhead.
+
+	  If in doubt, say "Y".
+
+endmenu # x86 Scheduler Options
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
_
