Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab3JaQLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:11:15 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51615 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3JaQLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:11:12 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/6] arm: zynq: Use of_platform_populate instead of bus_probe
Date: Thu, 31 Oct 2013 09:10:17 -0700
Message-Id: <1383235819-2552-5-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All new boards should be using this function instead of
of_platform_bus_probe.

Two side effects:
1. Possible to probe node which are not in the bus
2. Remove bus_id table from platform code

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/mach-zynq/common.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 5f252569c689..5690925519bf 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -39,11 +39,6 @@
 
 void __iomem *zynq_scu_base;
 
-static struct of_device_id zynq_of_bus_ids[] __initdata = {
-	{ .compatible = "simple-bus", },
-	{}
-};
-
 /**
  * zynq_init_machine - System specific initialization, intended to be
  *		       called from board specific initialization.
@@ -55,7 +50,7 @@ static void __init zynq_init_machine(void)
 	 */
 	l2x0_of_init(0x02060000, 0xF0F0FFFF);
 
-	of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
 static void __init zynq_timer_init(void)
-- 
1.8.4.1

