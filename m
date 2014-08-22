Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbaHVNvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:51:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33333 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459AbaHVNuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:50:19 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/7] ARM: OMAP5: powerdomain data: fix powerdomain powerstate
Date: Fri, 22 Aug 2014 08:49:28 -0500
Message-ID: <1408715373-25791-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408715373-25791-1-git-send-email-nm@ti.com>
References: <1408715373-25791-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the power domain power states for final production chip
capability. OFF mode, OSWR etc have been descoped for various domains.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/powerdomains54xx_data.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/powerdomains54xx_data.c b/arch/arm/mach-omap2/powerdomains54xx_data.c
index ce1d752..60d7ed8 100644
--- a/arch/arm/mach-omap2/powerdomains54xx_data.c
+++ b/arch/arm/mach-omap2/powerdomains54xx_data.c
@@ -35,7 +35,7 @@ static struct powerdomain core_54xx_pwrdm = {
 	.prcm_offs	  = OMAP54XX_PRM_CORE_INST,
 	.prcm_partition	  = OMAP54XX_PRM_PARTITION,
 	.pwrsts		  = PWRSTS_RET_ON,
-	.pwrsts_logic_ret = PWRSTS_OFF_RET,
+	.pwrsts_logic_ret = PWRSTS_RET,
 	.banks		  = 5,
 	.pwrsts_mem_ret	= {
 		[0] = PWRSTS_OFF_RET,	/* core_nret_bank */
@@ -107,8 +107,8 @@ static struct powerdomain cpu0_54xx_pwrdm = {
 	.voltdm		  = { .name = "mpu" },
 	.prcm_offs	  = OMAP54XX_PRCM_MPU_PRM_C0_INST,
 	.prcm_partition	  = OMAP54XX_PRCM_MPU_PARTITION,
-	.pwrsts		  = PWRSTS_OFF_RET_ON,
-	.pwrsts_logic_ret = PWRSTS_OFF_RET,
+	.pwrsts		  = PWRSTS_RET_ON,
+	.pwrsts_logic_ret = PWRSTS_RET,
 	.banks		  = 1,
 	.pwrsts_mem_ret	= {
 		[0] = PWRSTS_OFF_RET,	/* cpu0_l1 */
@@ -124,8 +124,8 @@ static struct powerdomain cpu1_54xx_pwrdm = {
 	.voltdm		  = { .name = "mpu" },
 	.prcm_offs	  = OMAP54XX_PRCM_MPU_PRM_C1_INST,
 	.prcm_partition	  = OMAP54XX_PRCM_MPU_PARTITION,
-	.pwrsts		  = PWRSTS_OFF_RET_ON,
-	.pwrsts_logic_ret = PWRSTS_OFF_RET,
+	.pwrsts		  = PWRSTS_RET_ON,
+	.pwrsts_logic_ret = PWRSTS_RET,
 	.banks		  = 1,
 	.pwrsts_mem_ret	= {
 		[0] = PWRSTS_OFF_RET,	/* cpu1_l1 */
@@ -158,7 +158,7 @@ static struct powerdomain mpu_54xx_pwrdm = {
 	.prcm_offs	  = OMAP54XX_PRM_MPU_INST,
 	.prcm_partition	  = OMAP54XX_PRM_PARTITION,
 	.pwrsts		  = PWRSTS_RET_ON,
-	.pwrsts_logic_ret = PWRSTS_OFF_RET,
+	.pwrsts_logic_ret = PWRSTS_RET,
 	.banks		  = 2,
 	.pwrsts_mem_ret	= {
 		[0] = PWRSTS_OFF_RET,	/* mpu_l2 */
-- 
1.7.9.5

