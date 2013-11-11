Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3KKSCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:02:20 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:36998 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3KKSCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:02:12 -0500
Date: Mon, 11 Nov 2013 19:02:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/iommu changes for v3.13
Message-ID: <20131111180209.GA14936@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-iommu-for-linus

   # HEAD: ced3c42c9fcba049ec9c76c8461ac194cafb20ba x86/iommu: Clean up the CONFIG_GART_IOMMU config option a bit

Make it easier to turn off the old AMD GART code.

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      x86/iommu: Don't make AMD_GART depend on EXPERT and default y

Ingo Molnar (1):
      x86/iommu: Clean up the CONFIG_GART_IOMMU config option a bit


 arch/x86/Kconfig | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee2fb9d..7081958 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -756,20 +756,25 @@ config DMI
 	  BIOS code.
 
 config GART_IOMMU
-	bool "GART IOMMU support" if EXPERT
-	default y
+	bool "Old AMD GART IOMMU support"
 	select SWIOTLB
 	depends on X86_64 && PCI && AMD_NB
 	---help---
-	  Support for full DMA access of devices with 32bit memory access only
-	  on systems with more than 3GB. This is usually needed for USB,
-	  sound, many IDE/SATA chipsets and some other devices.
-	  Provides a driver for the AMD Athlon64/Opteron/Turion/Sempron GART
-	  based hardware IOMMU and a software bounce buffer based IOMMU used
-	  on Intel systems and as fallback.
-	  The code is only active when needed (enough memory and limited
-	  device) unless CONFIG_IOMMU_DEBUG or iommu=force is specified
-	  too.
+	  Provides a driver for older AMD Athlon64/Opteron/Turion/Sempron
+	  GART based hardware IOMMUs.
+
+	  The GART supports full DMA access for devices with 32-bit access
+	  limitations, on systems with more than 3 GB. This is usually needed
+	  for USB, sound, many IDE/SATA chipsets and some other devices.
+
+	  Newer systems typically have a modern AMD IOMMU, supported via
+	  the CONFIG_AMD_IOMMU=y config option.
+
+	  In normal configurations this driver is only active when needed:
+	  there's more than 3 GB of memory and the system contains a
+	  32-bit limited device.
+
+	  If unsure, say Y.
 
 config CALGARY_IOMMU
 	bool "IBM Calgary IOMMU support"
