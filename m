Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3IQTb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:31:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46369 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab3IQTbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:31:55 -0400
From: Suman Anna <s-anna@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCHv2 9/9] ARM: AM33xx: hwmod_data: add the sysc configuration for spinlock
Date: Tue, 17 Sep 2013 14:31:26 -0500
Message-ID: <760966ea7566835b151043bf1d806803c8b9f9c8.1379445653.git.s-anna@ti.com>
X-Mailer: git-send-email 1.8.3.3
In-Reply-To: <cover.1379445653.git.s-anna@ti.com>
References: <cover.1379445653.git.s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing sysc configuration to the AM335 spinlock hwmod
data. This ensures that smart-idle is enabled whenever the module
is enabled by the driver.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
index 215894f..1084f2c 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
@@ -1278,8 +1278,21 @@ static struct omap_hwmod am33xx_spi1_hwmod = {
  * spinlock provides hardware assistance for synchronizing the
  * processes running on multiple processors
  */
+
+static struct omap_hwmod_class_sysconfig am33xx_spinlock_sysc = {
+	.rev_offs	= 0x0000,
+	.sysc_offs	= 0x0010,
+	.syss_offs	= 0x0014,
+	.sysc_flags	= (SYSC_HAS_AUTOIDLE | SYSC_HAS_CLOCKACTIVITY |
+			   SYSC_HAS_ENAWAKEUP | SYSC_HAS_SIDLEMODE |
+			   SYSC_HAS_SOFTRESET | SYSS_HAS_RESET_STATUS),
+	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
+	.sysc_fields	= &omap_hwmod_sysc_type1,
+};
+
 static struct omap_hwmod_class am33xx_spinlock_hwmod_class = {
 	.name		= "spinlock",
+	.sysc		= &am33xx_spinlock_sysc,
 };
 
 static struct omap_hwmod am33xx_spinlock_hwmod = {
-- 
1.8.3.3

