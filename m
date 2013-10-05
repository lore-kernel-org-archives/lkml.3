Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab3JEEWy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 00:22:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49344 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751076Ab3JEEWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 00:22:53 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: jreuter@yaina.de
Cc: linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] net: hamradio/scc: remove deprecated IRQF_DISABLED
Date: Sat,  5 Oct 2013 06:22:30 +0200
Message-Id: <1380946950-3482-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/net/hamradio/scc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index bc1d521..4bc6ee8 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -1734,7 +1734,7 @@ static int scc_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			if (!Ivec[hwcfg.irq].used && hwcfg.irq)
 			{
 				if (request_irq(hwcfg.irq, scc_isr,
-						IRQF_DISABLED, "AX.25 SCC",
+						0, "AX.25 SCC",
 						(void *)(long) hwcfg.irq))
 					printk(KERN_WARNING "z8530drv: warning, cannot get IRQ %d\n", hwcfg.irq);
 				else
-- 
1.8.1.2

