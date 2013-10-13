Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3JMGQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 02:16:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56263 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726Ab3JMGQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 02:16:10 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: jirislaby@gmail.com, arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] misc: phantom: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 08:16:07 +0200
Message-Id: <1381644967-9419-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/misc/phantom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 68b7c77..3075492 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -395,7 +395,7 @@ static int phantom_probe(struct pci_dev *pdev,
 	iowrite32(0, pht->caddr + PHN_IRQCTL);
 	ioread32(pht->caddr + PHN_IRQCTL); /* PCI posting */
 	retval = request_irq(pdev->irq, phantom_isr,
-			IRQF_SHARED | IRQF_DISABLED, "phantom", pht);
+			IRQF_SHARED, "phantom", pht);
 	if (retval) {
 		dev_err(&pdev->dev, "can't establish ISR\n");
 		goto err_unmo;
-- 
1.8.1.2

