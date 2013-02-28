Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669Ab3B1PWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:22:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41913 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab3B1OqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linuxppc-dev@ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 014/139] uprobes/powerpc: Add dependency on single step emulation
Date: Thu, 28 Feb 2013 14:42:44 +0000
Message-Id: <1362062689-2567-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Suzuki K. Poulose" <suzuki@in.ibm.com>

commit 5e249d4528528c9a77da051a89ec7f99d31b83eb upstream.

Uprobes uses emulate_step in sstep.c, but we haven't explicitly specified
the dependency. On pseries HAVE_HW_BREAKPOINT protects us, but 44x has no
such luxury.

Consolidate other users that depend on sstep and create a new config option.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Cc: linuxppc-dev@ozlabs.org
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/Kconfig      | 4 ++++
 arch/powerpc/lib/Makefile | 4 +---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 050cb37..4d8336c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -264,6 +264,10 @@ config PPC_ADV_DEBUG_DAC_RANGE
 	depends on PPC_ADV_DEBUG_REGS && 44x
 	default y
 
+config PPC_EMULATE_SSTEP
+	bool
+	default y if KPROBES || UPROBES || XMON || HAVE_HW_BREAKPOINT
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 7735a2c..3230bc1 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -18,9 +18,7 @@ obj-$(CONFIG_PPC64)	+= copypage_64.o copyuser_64.o \
 			   memcpy_64.o usercopy_64.o mem_64.o string.o \
 			   checksum_wrappers_64.o hweight_64.o \
 			   copyuser_power7.o
-obj-$(CONFIG_XMON)	+= sstep.o ldstfp.o
-obj-$(CONFIG_KPROBES)	+= sstep.o ldstfp.o
-obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= sstep.o ldstfp.o
+obj-$(CONFIG_PPC_EMULATE_SSTEP)	+= sstep.o ldstfp.o
 
 ifeq ($(CONFIG_PPC64),y)
 obj-$(CONFIG_SMP)	+= locks.o
-- 
1.8.1.2

