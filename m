Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3A2FTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 00:19:11 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35100 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab3A2FTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 00:19:09 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <linux@arm.linux.org.uk>, <nsekhar@ti.com>,
        <khilman@deeprootsystems.com>, <hs@denx.de>, <anilkumar.v@ti.com>
Subject: [PATCH 2/2] ARM: davinci: da850: configure CS2(aemif) for norflash
Date: Tue, 29 Jan 2013 10:49:56 +0530
Message-ID: <1359436796-25135-3-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359436796-25135-1-git-send-email-anilkumar.v@ti.com>
References: <1359436796-25135-1-git-send-email-anilkumar.v@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configure 16 bit data bus width for CS2(aemif) to use the norflash on
DA850.

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
---
:100644 100644 37c27af... 540e284... M	arch/arm/mach-davinci/da8xx-dt.c
 arch/arm/mach-davinci/da8xx-dt.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
index 37c27af..540e284 100644
--- a/arch/arm/mach-davinci/da8xx-dt.c
+++ b/arch/arm/mach-davinci/da8xx-dt.c
@@ -38,12 +38,29 @@ static void __init da8xx_init_irq(void)
 }
 
 #ifdef CONFIG_ARCH_DAVINCI_DA850
+#define DA8XX_AEMIF_CE2CFG_OFFSET       0x10
+#define DA8XX_AEMIF_ASIZE_16BIT         0x1
+
+static void __init da8xx_init_nor(void)
+{
+	void __iomem *aemif_addr;
+
+	aemif_addr = ioremap(DA8XX_AEMIF_CTL_BASE, SZ_32K);
+
+	/* Configure data bus width of CS2 to 16 bit */
+	writel(readl(aemif_addr + DA8XX_AEMIF_CE2CFG_OFFSET) |
+			DA8XX_AEMIF_ASIZE_16BIT,
+			aemif_addr + DA8XX_AEMIF_CE2CFG_OFFSET);
+
+	iounmap(aemif_addr);
+}
 
 static void __init da850_init_machine(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 
 	da8xx_uart_clk_enable();
+	da8xx_init_nor();
 }
 
 static const char *da850_boards_compat[] __initdata = {
-- 
1.7.4.1

