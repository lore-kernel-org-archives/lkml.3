Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaFZWoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 18:44:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38422 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751883AbaFZWnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:43:51 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ARM: imx6q: Use the new function scu_standby_enable()
Date: Fri, 27 Jun 2014 00:43:28 +0200
Message-Id: <1403822608-31158-6-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
References: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling the SCU standby is now done in smp_scu.c. We don't need
anymore to manipulate the SCU register outside of this file.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-imx/platsmp.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/mach-imx/platsmp.c b/arch/arm/mach-imx/platsmp.c
index 5b57c17c06bd..d57ff2c24c2e 100644
--- a/arch/arm/mach-imx/platsmp.c
+++ b/arch/arm/mach-imx/platsmp.c
@@ -20,8 +20,6 @@
 #include "common.h"
 #include "hardware.h"
 
-#define SCU_STANDBY_ENABLE	(1 << 5)
-
 u32 g_diag_reg;
 static void __iomem *scu_base;
 
@@ -47,10 +45,7 @@ void __init imx_scu_map_io(void)
 
 void imx_scu_standby_enable(void)
 {
-	u32 val = readl_relaxed(scu_base);
-
-	val |= SCU_STANDBY_ENABLE;
-	writel_relaxed(val, scu_base);
+	scu_standby_enable(scu_base, true);
 }
 
 static int imx_boot_secondary(unsigned int cpu, struct task_struct *idle)
-- 
1.8.1.2

