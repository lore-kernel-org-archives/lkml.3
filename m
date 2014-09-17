Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaIQD3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 23:29:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:3914 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbaIQD3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 23:29:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,538,1406617200"; 
   d="scan'208";a="603948450"
From: "David E. Box" <david.e.box@linux.intel.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: iosf: Move Kconfig to proper submenu
Date: Tue, 16 Sep 2014 20:26:25 -0700
Message-Id: <1410924386-16977-3-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410924386-16977-1-git-send-email-david.e.box@linux.intel.com>
References: <1410924386-16977-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1409175640-32426-1-git-send-email-david.e.box@linux.intel.com>
References: <1409175640-32426-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moves Kconfig option to "Processor type and features" menu from main
configuration menu.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 arch/x86/Kconfig | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bcbb57d..2db4b1d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -480,6 +480,20 @@ config X86_INTEL_LPSS
 	  things like clock tree (common clock framework) and pincontrol
 	  which are needed by the LPSS peripheral drivers.
 
+config IOSF_MBI
+	tristate "Intel System On Chip IOSF Sideband support"
+	depends on PCI
+	---help---
+	  Enables sideband access to mailbox registers on SoC's. The sideband is
+	  available on the following platforms. This list is not meant to be
+	  exclusive.
+	   - BayTrail
+	   - Braswell
+	   - Quark
+
+	  You should say Y if you are running a kernel on one of these
+	  platforms.
+
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
@@ -2443,21 +2457,6 @@ config X86_DMA_REMAP
 	bool
 	depends on STA2X11
 
-config IOSF_MBI
-	tristate "Intel System On Chip IOSF Sideband support"
-	depends on PCI
-	---help---
-	  Enables sideband access to mailbox registers on SoC's. The sideband is
-	  available on the following platforms. This list is not meant to be
-	  exclusive.
-	   - BayTrail
-	   - Cherryview
-	   - Braswell
-	   - Quark
-
-	  You should say Y if you are running a kernel on one of these
-	  platforms.
-
 config PMC_ATOM
 	def_bool y
         depends on PCI
-- 
1.9.1

