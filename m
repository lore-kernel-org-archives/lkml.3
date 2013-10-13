Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab3JMFwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 01:52:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56185 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863Ab3JMFwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 01:52:43 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: m.chehab@samsung.com
Cc: mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] zoran: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 07:52:32 +0200
Message-Id: <1381643552-8896-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/media/pci/zoran/zoran_card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index 923d59a..cec5b75 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -1293,7 +1293,7 @@ static int zoran_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	result = request_irq(zr->pci_dev->irq, zoran_irq,
-			     IRQF_SHARED | IRQF_DISABLED, ZR_DEVNAME(zr), zr);
+			     IRQF_SHARED, ZR_DEVNAME(zr), zr);
 	if (result < 0) {
 		if (result == -EINVAL) {
 			dprintk(1,
-- 
1.8.1.2

