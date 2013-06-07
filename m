Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab3FGXEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:04:48 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49656 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721Ab3FGXD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:56 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 30/31] mips/kvm: Enable MIPSVZ in Kconfig/Makefile
Date: Fri,  7 Jun 2013 16:03:34 -0700
Message-Id: <1370646215-6543-31-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Also let CPU_CAVIUM_OCTEON select KVM.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/Kconfig      | 1 +
 arch/mips/kvm/Kconfig  | 9 +++++++++
 arch/mips/kvm/Makefile | 1 +
 3 files changed, 11 insertions(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 7a58ab9..16e3d22 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1426,6 +1426,7 @@ config CPU_CAVIUM_OCTEON
 	select LIBFDT
 	select USE_OF
 	select USB_EHCI_BIG_ENDIAN_MMIO
+	select HAVE_KVM
 	help
 	  The Cavium Octeon processor is a highly integrated chip containing
 	  many ethernet hardware widgets for networking tasks. The processor
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 95c0d22..32a5016 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -48,6 +48,15 @@ config KVM_MIPS_DEBUG_COP0_COUNTERS
 
 	  If unsure, say N.
 
+config KVM_MIPSVZ
+	bool "Kernel-based Virtual Machine (KVM) using hardware MIPS-VZ support"
+	depends on HAVE_KVM
+	select KVM
+	---help---
+	  Support for hosting Guest kernels on hardware with the
+	  MIPS-VZ hardware module.
+
+
 source drivers/vhost/Kconfig
 
 endif # VIRTUALIZATION
diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 3377197..595358f 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -13,3 +13,4 @@ kvm_mipste-objs		:= kvm_mips_emul.o kvm_locore.o kvm_mips_int.o \
 
 obj-$(CONFIG_KVM)		+= $(common-objs) kvm_mips.o
 obj-$(CONFIG_KVM_MIPSTE)	+= kvm_mipste.o
+obj-$(CONFIG_KVM_MIPSVZ)	+= kvm_mipsvz.o kvm_mipsvz_guest.o
-- 
1.7.11.7

