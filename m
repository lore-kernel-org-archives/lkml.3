Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaLYR5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 12:57:48 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41778 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaLYR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 12:57:01 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jaedon.shin@gmail.com, abrestic@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V6 01/25] MIPS: bcm3384: Fix outdated use of mips_cpu_intc_init()
Date: Thu, 25 Dec 2014 09:48:56 -0800
Message-Id: <1419529760-9520-2-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
References: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was renamed to mips_cpu_irq_of_init(), so fix it to avoid
a compile error.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/bcm3384/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/bcm3384/irq.c b/arch/mips/bcm3384/irq.c
index 0fb5134..fd94fe8 100644
--- a/arch/mips/bcm3384/irq.c
+++ b/arch/mips/bcm3384/irq.c
@@ -180,7 +180,7 @@ static int __init intc_of_init(struct device_node *node,
 
 static struct of_device_id of_irq_ids[] __initdata = {
 	{ .compatible = "mti,cpu-interrupt-controller",
-	  .data = mips_cpu_intc_init },
+	  .data = mips_cpu_irq_of_init },
 	{ .compatible = "brcm,bcm3384-intc",
 	  .data = intc_of_init },
 	{},
-- 
2.1.1

