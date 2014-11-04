Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaKDC0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:26:04 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:45443 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaKDCZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:25:57 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 27/27] renesas_usbhs: common: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:34 +0530
Message-Id: <1415067694-9473-28-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
References: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkab@cdac.in>

Sanity check on resource happening with devm_ioremap_resource().

Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 drivers/usb/renesas_usbhs/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/common.c b/drivers/usb/renesas_usbhs/common.c
index 6dae115..169307b 100644
--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -496,9 +496,8 @@ static int usbhs_probe(struct platform_device *pdev)
 	}
 
 	/* platform data */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res || !irq_res) {
+	if (!irq_res) {
 		dev_err(&pdev->dev, "Not enough Renesas USB platform resources.\n");
 		return -ENODEV;
 	}
@@ -508,6 +507,7 @@ static int usbhs_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
-- 
1.7.9.5

