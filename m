Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3IIDaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:30:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52595 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751784Ab3IIDaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:30:15 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: prabhakar.csengg@gmail.com, m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] davinci: remove deprecated IRQF_DISABLED
Date: Mon,  9 Sep 2013 05:30:11 +0200
Message-Id: <1378697411-4619-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from
davinci media platform drivers.

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 2 +-
 drivers/media/platform/davinci/vpfe_capture.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 04609cc6..eac472b 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1785,7 +1785,7 @@ static int vpbe_display_probe(struct platform_device *pdev)
 	}
 
 	irq = res->start;
-	err = devm_request_irq(&pdev->dev, irq, venc_isr, IRQF_DISABLED,
+	err = devm_request_irq(&pdev->dev, irq, venc_isr, 0,
 			       VPBE_DISPLAY_DRIVER, disp_dev);
 	if (err) {
 		v4l2_err(&disp_dev->vpbe_dev->v4l2_dev,
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 9360909..d762246 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -688,7 +688,7 @@ static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
 	frame_format = ccdc_dev->hw_ops.get_frame_format();
 	if (frame_format == CCDC_FRMFMT_PROGRESSIVE) {
 		return request_irq(vpfe_dev->ccdc_irq1, vdint1_isr,
-				    IRQF_DISABLED, "vpfe_capture1",
+				    0, "vpfe_capture1",
 				    vpfe_dev);
 	}
 	return 0;
@@ -1863,7 +1863,7 @@ static int vpfe_probe(struct platform_device *pdev)
 	}
 	vpfe_dev->ccdc_irq1 = res1->start;
 
-	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, IRQF_DISABLED,
+	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, 0,
 			  "vpfe_capture0", vpfe_dev);
 
 	if (0 != ret) {
-- 
1.8.1.2

