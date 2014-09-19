Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbaISLtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:49:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56360 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbaISLtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:49:49 -0400
Date: Fri, 19 Sep 2014 04:49:39 -0700
From: "tip-bot for David E. Box" <tipbot@zytor.com>
Message-ID: <tip-ced3ce760b8df08e8bafba44f6b40407df2d0402@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1411017231-20807-3-git-send-email-david.e.box@linux.intel.com>
References: <1411017231-20807-3-git-send-email-david.e.box@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/platform/intel/iosf:
  Add better description of IOSF driver in config
Git-Commit-ID: ced3ce760b8df08e8bafba44f6b40407df2d0402
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ced3ce760b8df08e8bafba44f6b40407df2d0402
Gitweb:     http://git.kernel.org/tip/ced3ce760b8df08e8bafba44f6b40407df2d0402
Author:     David E. Box <david.e.box@linux.intel.com>
AuthorDate: Wed, 17 Sep 2014 22:13:50 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 13:08:42 +0200

x86/platform/intel/iosf: Add better description of IOSF driver in config

Adds better description of IOSF driver to determine when it
should be enabled. Also moves the Kconfig option to "Processor
type and features" menu from main configuration menu.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: http://lkml.kernel.org/r/1411017231-20807-3-git-send-email-david.e.box@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a99988f..d6334f4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -479,6 +479,23 @@ config X86_INTEL_LPSS
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
@@ -2432,21 +2449,6 @@ config X86_DMA_REMAP
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
