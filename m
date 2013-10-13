Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3JMF1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 01:27:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56139 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863Ab3JMF1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 01:27:52 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: hverkuil@xs4all.nl, m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] saa7146: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 07:27:49 +0200
Message-Id: <1381642069-7770-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/media/common/saa7146/saa7146_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/saa7146/saa7146_core.c b/drivers/media/common/saa7146/saa7146_core.c
index bb6ee51..291a598 100644
--- a/drivers/media/common/saa7146/saa7146_core.c
+++ b/drivers/media/common/saa7146/saa7146_core.c
@@ -411,7 +411,7 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	saa7146_write(dev, MC2, 0xf8000000);
 
 	/* request an interrupt for the saa7146 */
-	err = request_irq(pci->irq, interrupt_hw, IRQF_SHARED | IRQF_DISABLED,
+	err = request_irq(pci->irq, interrupt_hw, IRQF_SHARED,
 			  dev->name, dev);
 	if (err < 0) {
 		ERR("request_irq() failed\n");
-- 
1.8.1.2

