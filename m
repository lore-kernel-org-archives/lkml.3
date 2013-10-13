Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3JMFyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 01:54:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56197 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726Ab3JMFyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 01:54:44 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: awalls@md.metrocast.net, m.chehab@samsung.com
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] ivtv: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 07:54:40 +0200
Message-Id: <1381643680-8953-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/media/pci/ivtv/ivtv-driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index c08ae3e..802642d 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -1261,7 +1261,7 @@ static int ivtv_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 
 	/* Register IRQ */
 	retval = request_irq(itv->pdev->irq, ivtv_irq_handler,
-	     IRQF_SHARED | IRQF_DISABLED, itv->v4l2_dev.name, (void *)itv);
+	     IRQF_SHARED, itv->v4l2_dev.name, (void *)itv);
 	if (retval) {
 		IVTV_ERR("Failed to register irq %d\n", retval);
 		goto free_i2c;
-- 
1.8.1.2

