Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaG2RVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:21:49 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62319 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG2RVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:21:48 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, Michal Simek <michal.simek@xilinx.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] ARM: smp_scu: Enable standby mode
Date: Tue, 29 Jul 2014 10:21:03 -0700
Message-Id: <1406654463-15475-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the SCU standby mode.
>From documentation:
  When set, SCU CLK is turned off when all processors are in WFI mode,
  there is no pending request on the ACP (if implemented), and there is
  no remaining activity in the SCU.

  When SCU CLK is off, ARREADYS, AWREADYS and WREADYS on the ACP are forced
  LOW. The clock is turned on when any processor leaves WFI mode, or if
  there is a new request on the ACP.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Hi,

I am working on some PM related patches for Zynq. One of them is
enabling the SCU standby mode. I was wondering whether this is probably
something that I should not do in platform specific code, but rather in
the common code for everybody?

	Thanks,
	Sören
---
 arch/arm/kernel/smp_scu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/smp_scu.c b/arch/arm/kernel/smp_scu.c
index 1aafa0d785eb..82548a76740d 100644
--- a/arch/arm/kernel/smp_scu.c
+++ b/arch/arm/kernel/smp_scu.c
@@ -22,6 +22,9 @@
 #define SCU_INVALIDATE		0x0c
 #define SCU_FPGA_REVISION	0x10
 
+#define SCU_CTRL_ENABLE		BIT(0)
+#define SCU_CTRL_STANDBY_ENABLE	BIT(5)
+
 #ifdef CONFIG_SMP
 /*
  * Get the number of CPU cores from the SCU configuration
@@ -53,7 +56,7 @@ void scu_enable(void __iomem *scu_base)
 	if (scu_ctrl & 1)
 		return;
 
-	scu_ctrl |= 1;
+	scu_ctrl |= SCU_CTRL_ENABLE | SCU_CTRL_STANDBY_ENABLE;
 	writel_relaxed(scu_ctrl, scu_base + SCU_CTRL);
 
 	/*
-- 
2.0.1.1.gfbfc394

