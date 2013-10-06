Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3JFOFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 10:05:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46671 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab3JFOFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 10:05:05 -0400
Date: Sun, 6 Oct 2013 07:04:48 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-ced3c42c9fcba049ec9c76c8461ac194cafb20ba@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, borislav.petkov@amd.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86/iommu:
  Clean up the CONFIG_GART_IOMMU config option a bit
Git-Commit-ID: ced3c42c9fcba049ec9c76c8461ac194cafb20ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 06 Oct 2013 07:04:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ced3c42c9fcba049ec9c76c8461ac194cafb20ba
Gitweb:     http://git.kernel.org/tip/ced3c42c9fcba049ec9c76c8461ac194cafb20ba
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sun, 6 Oct 2013 11:45:20 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 6 Oct 2013 15:58:41 +0200

x86/iommu: Clean up the CONFIG_GART_IOMMU config option a bit

Improve the explanation of this config option.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/n/tip-gUMmysvsbl3mccbyf6olmxqg@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c9d2b81..7081958 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -760,15 +760,21 @@ config GART_IOMMU
 	select SWIOTLB
 	depends on X86_64 && PCI && AMD_NB
 	---help---
-	  Support for full DMA access of devices with 32bit memory access only
-	  on systems with more than 3GB. This is usually needed for USB,
-	  sound, many IDE/SATA chipsets and some other devices.
-	  Provides a driver for the older AMD Athlon64/Opteron/Turion/Sempron GART
-	  based hardware IOMMU.
-	  Newer systems typically have a better AMD IOMMU.
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
