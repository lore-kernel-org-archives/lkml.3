Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbaIRFRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:17:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:14198 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450AbaIRFQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:16:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,544,1406617200"; 
   d="scan'208";a="604607011"
From: "David E. Box" <david.e.box@linux.intel.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/3] x86: iosf: Add better description of IOSF driver in config
Date: Wed, 17 Sep 2014 22:13:50 -0700
Message-Id: <1411017231-20807-3-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411017231-20807-1-git-send-email-david.e.box@linux.intel.com>
References: <1411017231-20807-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1410924386-16977-1-git-send-email-david.e.box@linux.intel.com>
References: <1410924386-16977-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds better description of IOSF driver to determinine when it should be enabled.
Also moves the Kconfig option to "Processor type and features" menu from main
configuration menu.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 arch/x86/Kconfig | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bcbb57d..b075873 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -480,6 +480,23 @@ config X86_INTEL_LPSS
 	  things like clock tree (common clock framework) and pincontrol
 	  which are needed by the LPSS peripheral drivers.
 
+config IOSF_MBI
+	tristate "Intel SoC IOSF Sideband support for SoC platforms"
+	depends on PCI
+	---help---
+	  This option enables sideband register access support for Intel SoC
+	  platforms. On these platforms the IOSF sideband is used in lieu of
+	  MSR's for some register accesses, mostly but not limited to thermal
+	  and power. Drivers may query the availability of this device to
+	  determine if they need the sideband in order to work on these
+	  platforms. The sideband is available on the following SoC products.
+	  This list is not meant to be exclusive.
+	   - BayTrail
+	   - Braswell
+	   - Quark
+
+	  You should say Y if you are running a kernel on one of these SoC's.
+
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
@@ -2443,21 +2460,6 @@ config X86_DMA_REMAP
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

