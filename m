Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbaGRNEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:04:06 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17240 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934699AbaGRND1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:03:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 118/170] irqchip: spear_shirq: Fix interrupt offset
Date: Fri, 18 Jul 2014 14:12:03 +0200
Message-Id: <a2fb66a874c1729e9246f18cba7afaf5b773ff94.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4f4366033945419b0c52118c29d3057d7c558765 upstream.

The ras3 block on spear320 claims to have 3 interrupts. In fact it has
one and 6 reserved interrupts. Account the 6 reserved to this block so
it has 7 interrupts total. That matches the datasheet and the device
tree entries.

Broken since commit 80515a5a(ARM: SPEAr3xx: shirq: simplify and move
the shared irq multiplexor to DT). Testing is overrated....

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20140619212712.872379208@linutronix.de
Fixes: 80515a5a2e3c ('ARM: SPEAr3xx: shirq: simplify and move the shared irq multiplexor to DT')
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/irqchip/spear-shirq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/spear-shirq.c b/drivers/irqchip/spear-shirq.c
index 8527743b5cef..391b9cea73ed 100644
--- a/drivers/irqchip/spear-shirq.c
+++ b/drivers/irqchip/spear-shirq.c
@@ -125,7 +125,7 @@ static struct spear_shirq spear320_shirq_ras2 = {
 };
 
 static struct spear_shirq spear320_shirq_ras3 = {
-	.irq_nr = 3,
+	.irq_nr = 7,
 	.irq_bit_off = 0,
 	.invalid_irq = 1,
 	.regs = {
-- 
2.0.0

