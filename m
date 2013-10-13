Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JMF6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 01:58:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56208 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751873Ab3JMF6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 01:58:43 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com, jtp.park@samsung.com,
        m.chehab@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] s5p-mfc: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 07:58:39 +0200
Message-Id: <1381643919-9016-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 084263d..4660d24 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1101,7 +1101,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	}
 	dev->irq = res->start;
 	ret = devm_request_irq(&pdev->dev, dev->irq, s5p_mfc_irq,
-					IRQF_DISABLED, pdev->name, dev);
+					0, pdev->name, dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to install irq (%d)\n", ret);
 		goto err_res;
-- 
1.8.1.2

