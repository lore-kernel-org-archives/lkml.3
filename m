Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750836Ab3JLETg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 00:19:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54058 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750720Ab3JLETf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 00:19:35 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: josh.h.morris@us.ibm.com, pjk1939@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] rsxx: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 06:19:32 +0200
Message-Id: <1381551572-6172-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/block/rsxx/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index 6e85e21..93ecb78 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -890,7 +890,7 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 				"Failed to enable MSI\n");
 	}
 
-	st = request_irq(dev->irq, rsxx_isr, IRQF_DISABLED | IRQF_SHARED,
+	st = request_irq(dev->irq, rsxx_isr, IRQF_SHARED,
 			 DRIVER_NAME, card);
 	if (st) {
 		dev_err(CARD_TO_DEV(card),
-- 
1.8.1.2

