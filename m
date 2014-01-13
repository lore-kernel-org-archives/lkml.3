Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaAMQjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:39:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53309 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbaAMQDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Paul Walmsley <paul@pwsan.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 104/208] ARM: OMAP2+: hwmod_data: fix missing OMAP_INTC_START in irq data
Date: Mon, 13 Jan 2014 15:59:05 +0000
Message-Id: <1389628849-1614-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Anna <s-anna@ti.com>

commit 6d4c88304794442055eaea1c07f3c7b988b8c924 upstream.

Commit 7d7e1eb (ARM: OMAP2+: Prepare for irqs.h removal) and commit
ec2c082 (ARM: OMAP2+: Remove hardcoded IRQs and enable SPARSE_IRQ)
updated the way interrupts for OMAP2/3 devices are defined in the
HWMOD data structures to being an index plus a fixed offset (defined
by OMAP_INTC_START).

Couple of irqs in the OMAP2/3 hwmod data were misconfigured completely
as they were missing this OMAP_INTC_START relative offset. Add this
offset back to fix the incorrect irq data for the following modules:
	OMAP2 - GPMC, RNG
	OMAP3 - GPMC, ISP MMU & IVA MMU

Signed-off-by: Suman Anna <s-anna@ti.com>
Fixes: 7d7e1eba7e92 ("ARM: OMAP2+: Prepare for irqs.h removal")
Fixes: ec2c0825ca31 ("ARM: OMAP2+: Remove hardcoded IRQs and enable SPARSE_IRQ")
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c | 4 ++--
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c b/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
index 56cebb0..d23c77f 100644
--- a/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c
@@ -796,7 +796,7 @@ struct omap_hwmod omap2xxx_counter_32k_hwmod = {
 
 /* gpmc */
 static struct omap_hwmod_irq_info omap2xxx_gpmc_irqs[] = {
-	{ .irq = 20 },
+	{ .irq = 20 + OMAP_INTC_START, },
 	{ .irq = -1 }
 };
 
@@ -841,7 +841,7 @@ static struct omap_hwmod_class omap2_rng_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info omap2_rng_mpu_irqs[] = {
-	{ .irq = 52 },
+	{ .irq = 52 + OMAP_INTC_START, },
 	{ .irq = -1 }
 };
 
diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index f234cbe..60f2344 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -2165,7 +2165,7 @@ static struct omap_hwmod_class omap3xxx_gpmc_hwmod_class = {
 };
 
 static struct omap_hwmod_irq_info omap3xxx_gpmc_irqs[] = {
-	{ .irq = 20 },
+	{ .irq = 20 + OMAP_INTC_START, },
 	{ .irq = -1 }
 };
 
@@ -2999,7 +2999,7 @@ static struct omap_mmu_dev_attr mmu_isp_dev_attr = {
 
 static struct omap_hwmod omap3xxx_mmu_isp_hwmod;
 static struct omap_hwmod_irq_info omap3xxx_mmu_isp_irqs[] = {
-	{ .irq = 24 },
+	{ .irq = 24 + OMAP_INTC_START, },
 	{ .irq = -1 }
 };
 
@@ -3041,7 +3041,7 @@ static struct omap_mmu_dev_attr mmu_iva_dev_attr = {
 
 static struct omap_hwmod omap3xxx_mmu_iva_hwmod;
 static struct omap_hwmod_irq_info omap3xxx_mmu_iva_irqs[] = {
-	{ .irq = 28 },
+	{ .irq = 28 + OMAP_INTC_START, },
 	{ .irq = -1 }
 };
 
-- 
1.8.3.2

