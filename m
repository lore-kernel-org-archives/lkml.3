Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbaGOROt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:14:49 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41900 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbaGORCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:12 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Suman Anna <s-anna@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Paul Walmsley <paul@pwsan.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 35/94] ARM: OMAP3: PRM/CM: Add back macros used by TI DSP/Bridge driver
Date: Tue, 15 Jul 2014 20:00:50 +0300
Message-Id: <1405443709-15288-35-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

The commit 7be914f {ARM: OMAP3: PRM/CM: Cleanup unused header} removed
some of the macros used by the TI DSP/Bridge driver. This fixes the
following build errors when trying to build DSP/Bridge driver (disabled
at present), otherwise results in the following build errors:

drivers/staging/tidspbridge/core/tiomap3430.c:531:31: error: 'OMAP3430_AUTO_IVA2_DPLL_SHIFT' undeclared (first use in this function)
drivers/staging/tidspbridge/core/tiomap3430.c:531:31: note: each undeclared identifier is reported only once for each function it appears in
make[3]: *** [drivers/staging/tidspbridge/core/tiomap3430.o] Error 1
make[3]: *** Waiting for unfinished jobs....
drivers/staging/tidspbridge/core/tiomap_io.c: In function 'sm_interrupt_dsp':
drivers/staging/tidspbridge/core/tiomap_io.c:404:31: error: 'OMAP3430_AUTO_IVA2_DPLL_SHIFT' undeclared (first use in this function)
drivers/staging/tidspbridge/core/tiomap_io.c:404:31: note: each undeclared identifier is reported only once for each function it appears in
drivers/staging/tidspbridge/core/tiomap_io.c:414:12: error: 'OMAP3430_IVA2_DPLL_FREQSEL_SHIFT' undeclared (first use in this function)
drivers/staging/tidspbridge/core/tiomap_io.c:415:12: error: 'OMAP3430_EN_IVA2_DPLL_SHIFT' undeclared (first use in this function)
make[3]: *** [drivers/staging/tidspbridge/core/tiomap_io.o] Error 1
drivers/staging/tidspbridge/core/tiomap3430_pwr.c: In function 'dsp_clk_wakeup_event_ctrl':
drivers/staging/tidspbridge/core/tiomap3430_pwr.c:442:19: error: 'OMAP3430_GRPSEL_GPT5_MASK' undeclared (first use in this function)
drivers/staging/tidspbridge/core/tiomap3430_pwr.c:442:19: note: each undeclared identifier is reported only once for each function it appears in
drivers/staging/tidspbridge/core/tiomap3430_pwr.c:455:19: error: 'OMAP3430_GRPSEL_GPT6_MASK' undeclared (first use in this function)
drivers/staging/tidspbridge/core/tiomap3430_pwr.c:468:19: error: 'OMAP3430_GRPSEL_GPT7_MASK' undeclared (first use in this function)
drivers/staging/tidspbridge/core/tiomap3430_pwr.c:481:19: error: 'OMAP3430_GRPSEL_GPT8_MASK' undeclared (first use in this function)
drivers/staging/tidspbridge/core/tiomap3430_pwr.c:494:19: error: 'OMAP3430_GRPSEL_MCBSP1_MASK' undeclared (first use in this function)
drivers/staging/tidspbridge/core/tiomap3430_pwr.c:546:19: error: 'OMAP3430_GRPSEL_MCBSP5_MASK' undeclared (first use in this function)
make[3]: *** [drivers/staging/tidspbridge/core/tiomap3430_pwr.o] Error 1
make[2]: *** [drivers/staging/tidspbridge] Error 2

Fixes: 7be914f (ARM: OMAP3: PRM/CM: Cleanup unused header)
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/mach-omap2/cm-regbits-34xx.h  |    3 +++
 arch/arm/mach-omap2/prm-regbits-34xx.h |    6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/mach-omap2/cm-regbits-34xx.h b/arch/arm/mach-omap2/cm-regbits-34xx.h
index 04dab2f..ee6c784 100644
--- a/arch/arm/mach-omap2/cm-regbits-34xx.h
+++ b/arch/arm/mach-omap2/cm-regbits-34xx.h
@@ -26,11 +26,14 @@
 #define OMAP3430_EN_WDT3_SHIFT				12
 #define OMAP3430_CM_FCLKEN_IVA2_EN_IVA2_MASK		(1 << 0)
 #define OMAP3430_CM_FCLKEN_IVA2_EN_IVA2_SHIFT		0
+#define OMAP3430_IVA2_DPLL_FREQSEL_SHIFT		4
 #define OMAP3430_IVA2_DPLL_FREQSEL_MASK			(0xf << 4)
 #define OMAP3430_EN_IVA2_DPLL_DRIFTGUARD_SHIFT		3
+#define OMAP3430_EN_IVA2_DPLL_SHIFT			0
 #define OMAP3430_EN_IVA2_DPLL_MASK			(0x7 << 0)
 #define OMAP3430_ST_IVA2_SHIFT				0
 #define OMAP3430_ST_IVA2_CLK_MASK			(1 << 0)
+#define OMAP3430_AUTO_IVA2_DPLL_SHIFT			0
 #define OMAP3430_AUTO_IVA2_DPLL_MASK			(0x7 << 0)
 #define OMAP3430_IVA2_CLK_SRC_SHIFT			19
 #define OMAP3430_IVA2_CLK_SRC_WIDTH			3
diff --git a/arch/arm/mach-omap2/prm-regbits-34xx.h b/arch/arm/mach-omap2/prm-regbits-34xx.h
index 106132d..cbefbd7 100644
--- a/arch/arm/mach-omap2/prm-regbits-34xx.h
+++ b/arch/arm/mach-omap2/prm-regbits-34xx.h
@@ -35,6 +35,8 @@
 #define OMAP3430_LOGICSTATEST_MASK			(1 << 2)
 #define OMAP3430_LASTLOGICSTATEENTERED_MASK		(1 << 2)
 #define OMAP3430_LASTPOWERSTATEENTERED_MASK		(0x3 << 0)
+#define OMAP3430_GRPSEL_MCBSP5_MASK			(1 << 10)
+#define OMAP3430_GRPSEL_MCBSP1_MASK			(1 << 9)
 #define OMAP3630_GRPSEL_UART4_MASK			(1 << 18)
 #define OMAP3430_GRPSEL_GPIO6_MASK			(1 << 17)
 #define OMAP3430_GRPSEL_GPIO5_MASK			(1 << 16)
@@ -42,6 +44,10 @@
 #define OMAP3430_GRPSEL_GPIO3_MASK			(1 << 14)
 #define OMAP3430_GRPSEL_GPIO2_MASK			(1 << 13)
 #define OMAP3430_GRPSEL_UART3_MASK			(1 << 11)
+#define OMAP3430_GRPSEL_GPT8_MASK			(1 << 9)
+#define OMAP3430_GRPSEL_GPT7_MASK			(1 << 8)
+#define OMAP3430_GRPSEL_GPT6_MASK			(1 << 7)
+#define OMAP3430_GRPSEL_GPT5_MASK			(1 << 6)
 #define OMAP3430_GRPSEL_MCBSP4_MASK			(1 << 2)
 #define OMAP3430_GRPSEL_MCBSP3_MASK			(1 << 1)
 #define OMAP3430_GRPSEL_MCBSP2_MASK			(1 << 0)
-- 
1.7.10.4

