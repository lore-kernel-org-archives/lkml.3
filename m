Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3JMFhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 01:37:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56157 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991Ab3JMFhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 01:37:40 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: awalls@md.metrocast.net, m.chehab@samsung.com
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] cx18: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 07:37:35 +0200
Message-Id: <1381642655-8143-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/media/pci/cx18/cx18-driver.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 004d8ac..ff72320 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -1031,8 +1031,7 @@ static int cx18_probe(struct pci_dev *pci_dev,
 
 	/* Register IRQ */
 	retval = request_irq(cx->pci_dev->irq, cx18_irq_handler,
-			     IRQF_SHARED | IRQF_DISABLED,
-			     cx->v4l2_dev.name, (void *)cx);
+			     IRQF_SHARED, cx->v4l2_dev.name, (void *)cx);
 	if (retval) {
 		CX18_ERR("Failed to register irq %d\n", retval);
 		goto free_i2c;
-- 
1.8.1.2

