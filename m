Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3JMFYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 01:24:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56131 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991Ab3JMFYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 01:24:34 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: mac@melware.de, isdn@linux-pingi.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] isdn: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 07:24:29 +0200
Message-Id: <1381641869-7709-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/isdn/hardware/eicon/divasmain.c | 2 +-
 drivers/isdn/sc/init.c                  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/divasmain.c b/drivers/isdn/hardware/eicon/divasmain.c
index 52377b4..a2e0ed6 100644
--- a/drivers/isdn/hardware/eicon/divasmain.c
+++ b/drivers/isdn/hardware/eicon/divasmain.c
@@ -481,7 +481,7 @@ void __inline__ outpp(void __iomem *addr, word p)
 int diva_os_register_irq(void *context, byte irq, const char *name)
 {
 	int result = request_irq(irq, diva_os_irq_wrapper,
-				 IRQF_DISABLED | IRQF_SHARED, name, context);
+				 IRQF_SHARED, name, context);
 	return (result);
 }
 
diff --git a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
index ca997bd..92acc81 100644
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -336,7 +336,7 @@ static int __init sc_init(void)
 		 */
 		sc_adapter[cinst]->interrupt = irq[b];
 		if (request_irq(sc_adapter[cinst]->interrupt, interrupt_handler,
-				IRQF_DISABLED, interface->id,
+				0, interface->id,
 				(void *)(unsigned long) cinst))
 		{
 			kfree(sc_adapter[cinst]->channel);
-- 
1.8.1.2

