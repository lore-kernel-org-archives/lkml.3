Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab3ILDwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:52:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37679 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752129Ab3ILDwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:52:53 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: davem@davemloft.net
Cc: rusty@rustcorp.com.au, benh@kernel.crashing.org,
        silviupopescu1990@gmail.com, geert@linux-m68k.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ethernet: amd: remove deprecated IRQF_DISABLED
Date: Thu, 12 Sep 2013 05:52:50 +0200
Message-Id: <1378957970-3666-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from
drivers/net/ethernet/amd/sun3lance.c

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/net/ethernet/amd/sun3lance.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/sun3lance.c b/drivers/net/ethernet/amd/sun3lance.c
index d6b2029..3d8c6b2 100644
--- a/drivers/net/ethernet/amd/sun3lance.c
+++ b/drivers/net/ethernet/amd/sun3lance.c
@@ -358,7 +358,7 @@ static int __init lance_probe( struct net_device *dev)
 
 	REGA(CSR0) = CSR0_STOP;
 
-	if (request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev) < 0) {
+	if (request_irq(LANCE_IRQ, lance_interrupt, 0, "SUN3 Lance", dev) < 0) {
 #ifdef CONFIG_SUN3
 		iounmap((void __iomem *)ioaddr);
 #endif
-- 
1.8.1.2

