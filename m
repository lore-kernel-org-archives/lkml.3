Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbaJ3HcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 03:32:12 -0400
Received: from mail-bl2on0123.outbound.protection.outlook.com ([65.55.169.123]:47104
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757886AbaJ3HcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 03:32:08 -0400
From: Zhao Qiang <B45475@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <B07421@freescale.com>
CC: <R63061@freescale.com>, Zhao Qiang <B45475@freescale.com>
Subject: [PATCH v3 3/3] rheap: move rheap.c from arch/powerpc/lib/ to lib/
Date: Thu, 30 Oct 2014 15:31:04 +0800
Message-ID: <1414654264-2596-3-git-send-email-B45475@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1414654264-2596-1-git-send-email-B45475@freescale.com>
References: <1414654264-2596-1-git-send-email-B45475@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(107046002)(104166001)(64706001)(48376002)(36756003)(50466002)(31966008)(229853001)(102836001)(26826002)(95666004)(77156001)(105606002)(50226001)(21056001)(85306004)(89996001)(87936001)(80022003)(93916002)(92566001)(4396001)(46102003)(2201001)(97736003)(88136002)(99396003)(104016003)(44976005)(19580405001)(19580395003)(84676001)(62966002)(20776003)(106466001)(47776003)(6806004)(87286001)(85852003)(92726001)(76482002)(68736004)(76176999)(50986999)(120916001)(42262002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0721;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0721;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=qiang.zhao@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qe need to use the rheap, so move it to public directory.

Signed-off-by: Zhao Qiang <B45475@freescale.com>
---
 arch/powerpc/Kconfig                                    | 3 ---
 arch/powerpc/include/asm/fsl_85xx_cache_sram.h          | 2 +-
 arch/powerpc/lib/Makefile                               | 2 --
 arch/powerpc/platforms/44x/Kconfig                      | 2 +-
 arch/powerpc/platforms/85xx/Kconfig                     | 2 +-
 arch/powerpc/platforms/Kconfig                          | 2 +-
 arch/powerpc/platforms/Kconfig.cputype                  | 2 +-
 arch/powerpc/sysdev/cpm1.c                              | 2 +-
 arch/powerpc/sysdev/cpm2.c                              | 2 +-
 arch/powerpc/sysdev/cpm_common.c                        | 2 +-
 arch/powerpc/sysdev/ppc4xx_ocm.c                        | 2 +-
 drivers/dma/bestcomm/Kconfig                            | 2 +-
 drivers/soc/fsl-qe/Kconfig                              | 2 +-
 drivers/soc/fsl-qe/qe.c                                 | 2 +-
 drivers/soc/fsl-qe/qe_common.c                          | 2 +-
 include/linux/fsl/bestcomm/sram.h                       | 2 +-
 {arch/powerpc/include/asm => include/linux/fsl}/rheap.h | 0
 lib/Kconfig                                             | 3 +++
 lib/Makefile                                            | 2 ++
 {arch/powerpc/lib => lib}/rheap.c                       | 2 +-
 20 files changed, 20 insertions(+), 20 deletions(-)
 rename {arch/powerpc/include/asm => include/linux/fsl}/rheap.h (100%)
 rename {arch/powerpc/lib => lib}/rheap.c (99%)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 007b052..d6a31a6 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -1067,7 +1067,4 @@ config KEYS_COMPAT
 
 source "crypto/Kconfig"
 
-config PPC_LIB_RHEAP
-	bool
-
 source "arch/powerpc/kvm/Kconfig"
diff --git a/arch/powerpc/include/asm/fsl_85xx_cache_sram.h b/arch/powerpc/include/asm/fsl_85xx_cache_sram.h
index 2af2bdc..e57888a 100644
--- a/arch/powerpc/include/asm/fsl_85xx_cache_sram.h
+++ b/arch/powerpc/include/asm/fsl_85xx_cache_sram.h
@@ -26,7 +26,7 @@
 #ifndef __ASM_POWERPC_FSL_85XX_CACHE_SRAM_H__
 #define __ASM_POWERPC_FSL_85XX_CACHE_SRAM_H__
 
-#include <asm/rheap.h>
+#include <linux/fsl/rheap.h>
 #include <linux/spinlock.h>
 
 /*
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 59fa2de..c73dff8 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -32,8 +32,6 @@ obj-$(CONFIG_SMP)	+= locks.o
 obj-$(CONFIG_ALTIVEC)	+= vmx-helper.o
 endif
 
-obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
-
 obj-y			+= code-patching.o
 obj-y			+= feature-fixups.o
 obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 4d88f6a..c7994ff 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -282,7 +282,7 @@ config PPC4xx_GPIO
 config PPC4xx_OCM
 	bool "PPC4xx On Chip Memory (OCM) support"
 	depends on 4xx
-	select PPC_LIB_RHEAP
+	select LIB_RHEAP
 	help
 	  Enable OCM support for PowerPC 4xx platforms with on chip memory,
 	  OCM provides the fast place for memory access to improve performance.
diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index f22635a..0a7cb9d 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -16,7 +16,7 @@ if PPC32
 
 config FSL_85XX_CACHE_SRAM
 	bool
-	select PPC_LIB_RHEAP
+	select LIB_RHEAP
 	help
 	  When selected, this option enables cache-sram support
 	  for memory allocation on P1/P2 QorIQ platforms.
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index ae8879c..25740c4 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -281,7 +281,7 @@ config CPM2
 	bool "Enable support for the CPM2 (Communications Processor Module)"
 	depends on (FSL_SOC_BOOKE && PPC32) || 8260
 	select CPM
-	select PPC_LIB_RHEAP
+	select LIB_RHEAP
 	select PPC_PCI_CHOICE
 	select ARCH_REQUIRE_GPIOLIB
 	help
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index a41bd02..0bb8c58 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -33,7 +33,7 @@ config PPC_8xx
 	bool "Freescale 8xx"
 	select FSL_SOC
 	select 8xx
-	select PPC_LIB_RHEAP
+	select LIB_RHEAP
 
 config 40x
 	bool "AMCC 40x"
diff --git a/arch/powerpc/sysdev/cpm1.c b/arch/powerpc/sysdev/cpm1.c
index 5e6ff38..c6f5762 100644
--- a/arch/powerpc/sysdev/cpm1.c
+++ b/arch/powerpc/sysdev/cpm1.c
@@ -38,7 +38,7 @@
 #include <asm/cpm1.h>
 #include <asm/io.h>
 #include <asm/tlbflush.h>
-#include <asm/rheap.h>
+#include <linux/fsl/rheap.h>
 #include <asm/prom.h>
 #include <asm/cpm.h>
 
diff --git a/arch/powerpc/sysdev/cpm2.c b/arch/powerpc/sysdev/cpm2.c
index 8dc1e24..5a63d35 100644
--- a/arch/powerpc/sysdev/cpm2.c
+++ b/arch/powerpc/sysdev/cpm2.c
@@ -41,7 +41,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/cpm2.h>
-#include <asm/rheap.h>
+#include <linux/fsl/rheap.h>
 #include <asm/fs_pd.h>
 
 #include <sysdev/fsl_soc.h>
diff --git a/arch/powerpc/sysdev/cpm_common.c b/arch/powerpc/sysdev/cpm_common.c
index 4f78695..3e06505 100644
--- a/arch/powerpc/sysdev/cpm_common.c
+++ b/arch/powerpc/sysdev/cpm_common.c
@@ -27,7 +27,7 @@
 
 #include <asm/udbg.h>
 #include <asm/io.h>
-#include <asm/rheap.h>
+#include <linux/fsl/rheap.h>
 #include <asm/cpm.h>
 
 #include <mm/mmu_decl.h>
diff --git a/arch/powerpc/sysdev/ppc4xx_ocm.c b/arch/powerpc/sysdev/ppc4xx_ocm.c
index 85d9e37..cfe2e19 100644
--- a/arch/powerpc/sysdev/ppc4xx_ocm.c
+++ b/arch/powerpc/sysdev/ppc4xx_ocm.c
@@ -27,7 +27,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <asm/rheap.h>
+#include <linux/fsl/rheap.h>
 #include <asm/ppc4xx_ocm.h>
 #include <linux/slab.h>
 #include <linux/debugfs.h>
diff --git a/drivers/dma/bestcomm/Kconfig b/drivers/dma/bestcomm/Kconfig
index 29e4270..9bb1bf8 100644
--- a/drivers/dma/bestcomm/Kconfig
+++ b/drivers/dma/bestcomm/Kconfig
@@ -6,7 +6,7 @@ config PPC_BESTCOMM
 	tristate "Bestcomm DMA engine support"
 	depends on PPC_MPC52xx
 	default n
-	select PPC_LIB_RHEAP
+	select LIB_RHEAP
 	help
 	  BestComm is the name of the communication coprocessor found
 	  on the Freescale MPC5200 family of processor.  Its usage is
diff --git a/drivers/soc/fsl-qe/Kconfig b/drivers/soc/fsl-qe/Kconfig
index 8b03ca2..6241819 100644
--- a/drivers/soc/fsl-qe/Kconfig
+++ b/drivers/soc/fsl-qe/Kconfig
@@ -4,7 +4,7 @@
 config QUICC_ENGINE
 	bool "Freescale QUICC Engine (QE) Support"
 	depends on FSL_SOC && PPC32
-	select PPC_LIB_RHEAP
+	select LIB_RHEAP
 	select CRC32
 	help
 	  The QUICC Engine (QE) is a new generation of communications
diff --git a/drivers/soc/fsl-qe/qe.c b/drivers/soc/fsl-qe/qe.c
index 1c5beef..504bbd6 100644
--- a/drivers/soc/fsl-qe/qe.c
+++ b/drivers/soc/fsl-qe/qe.c
@@ -35,7 +35,7 @@
 #include <linux/fsl/immap_qe.h>
 #include <linux/fsl/qe.h>
 #include <asm/prom.h>
-#include <asm/rheap.h>
+#include <linux/fsl/rheap.h>
 
 static void qe_snums_init(void);
 static int qe_sdma_init(void);
diff --git a/drivers/soc/fsl-qe/qe_common.c b/drivers/soc/fsl-qe/qe_common.c
index c82ddcc..e7fdd02 100644
--- a/drivers/soc/fsl-qe/qe_common.c
+++ b/drivers/soc/fsl-qe/qe_common.c
@@ -26,7 +26,7 @@
 #include <linux/slab.h>
 
 #include <linux/io.h>
-#include <asm/rheap.h>
+#include <linux/fsl/rheap.h>
 #include <linux/fsl/qe.h>
 
 static spinlock_t qe_muram_lock;
diff --git a/include/linux/fsl/bestcomm/sram.h b/include/linux/fsl/bestcomm/sram.h
index b6d6689..117eaa1 100644
--- a/include/linux/fsl/bestcomm/sram.h
+++ b/include/linux/fsl/bestcomm/sram.h
@@ -12,7 +12,7 @@
 #ifndef __BESTCOMM_SRAM_H__
 #define __BESTCOMM_SRAM_H__
 
-#include <asm/rheap.h>
+#include <linux/fsl/rheap.h>
 #include <asm/mmu.h>
 #include <linux/spinlock.h>
 
diff --git a/arch/powerpc/include/asm/rheap.h b/include/linux/fsl/rheap.h
similarity index 100%
rename from arch/powerpc/include/asm/rheap.h
rename to include/linux/fsl/rheap.h
diff --git a/lib/Kconfig b/lib/Kconfig
index 334f772..f5d5e99 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -393,6 +393,9 @@ config CPU_RMAP
 	bool
 	depends on SMP
 
+config LIB_RHEAP
+	bool
+
 config DQL
 	bool
 
diff --git a/lib/Makefile b/lib/Makefile
index ba967a1..dccdef1 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -193,3 +193,5 @@ quiet_cmd_build_OID_registry = GEN     $@
 clean-files	+= oid_registry_data.c
 
 obj-$(CONFIG_UCS2_STRING) += ucs2_string.o
+
+obj-$(CONFIG_LIB_RHEAP) += rheap.o
diff --git a/arch/powerpc/lib/rheap.c b/lib/rheap.c
similarity index 99%
rename from arch/powerpc/lib/rheap.c
rename to lib/rheap.c
index a1060a8..af180fd 100644
--- a/arch/powerpc/lib/rheap.c
+++ b/lib/rheap.c
@@ -20,7 +20,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 
-#include <asm/rheap.h>
+#include <linux/fsl/rheap.h>
 
 /*
  * Fixup a list_head, needed when copying lists.  If the pointers fall
-- 
2.1.0.27.g96db324

