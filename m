Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab3CYJet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:34:49 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:52484 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755522Ab3CYJes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:34:48 -0400
Message-ID: <1364204086.1390.257.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] irq: versatile: rename Kconfig macro in printk
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 10:34:46 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 09:34:46.0030 (UTC) FILETIME=[FCBBD2E0:01CE293B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2389d5014342e9535aad212d0c68d439aaf534ba ("ARM: plat-versatile:
move FPGA irq driver to drivers/irqchip") changed Kconfig symbol
PLAT_VERSATILE_FPGA_IRQ_NR to VERSATILE_FPGA_IRQ_NR. It forgot to change
one reference to the related macro in a printk.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Patch triggers a checkpatch 80 character warning that I chose
to ignore.

 drivers/irqchip/irq-versatile-fpga.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-versatile-fpga.c b/drivers/irqchip/irq-versatile-fpga.c
index 9dbd82b..065b7a3 100644
--- a/drivers/irqchip/irq-versatile-fpga.c
+++ b/drivers/irqchip/irq-versatile-fpga.c
@@ -139,7 +139,7 @@ void __init fpga_irq_init(void __iomem *base, const char *name, int irq_start,
 	int i;
 
 	if (fpga_irq_id >= ARRAY_SIZE(fpga_irq_devices)) {
-		pr_err("%s: too few FPGA IRQ controllers, increase CONFIG_PLAT_VERSATILE_FPGA_IRQ_NR\n", __func__);
+		pr_err("%s: too few FPGA IRQ controllers, increase CONFIG_VERSATILE_FPGA_IRQ_NR\n", __func__);
 		return;
 	}
 	f = &fpga_irq_devices[fpga_irq_id];
-- 
1.7.11.7

