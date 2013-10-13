Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3JMGBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 02:01:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56225 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751833Ab3JMGBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 02:01:53 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: g.liakhovetski@gmx.de, m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] sh_mobile_ceu_camera: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 08:01:46 +0200
Message-Id: <1381644106-9086-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 8df22f7..150bd4d 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1800,7 +1800,7 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 
 	/* request irq */
 	err = devm_request_irq(&pdev->dev, pcdev->irq, sh_mobile_ceu_irq,
-			       IRQF_DISABLED, dev_name(&pdev->dev), pcdev);
+			       0, dev_name(&pdev->dev), pcdev);
 	if (err) {
 		dev_err(&pdev->dev, "Unable to register CEU interrupt.\n");
 		goto exit_release_mem;
-- 
1.8.1.2

