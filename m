Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3EIFCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:02:07 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:50814 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3EIFCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:02:04 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <stern@rowland.harvard.edu>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <lizefan@huawei.com>,
        Libo Chen <chenlibo.3@gmail.com>, Libo Chen <libo.chen@huawei.com>
Subject: [PATCH 3/4] usb: ohci: fix goto wrong tag in err case
Date: Thu, 9 May 2013 12:58:10 +0800
Message-ID: <1368075491-38728-4-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1368075491-38728-1-git-send-email-libo.chen@huawei.com>
References: <1368075491-38728-1-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libo Chen <chenlibo.3@gmail.com>

fix goto wrong tag in usb_hcd_nxp_probe

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/host/ohci-nxp.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index f4988fb..eb294a9 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -234,7 +234,7 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	if (usb_disabled()) {
 		dev_err(&pdev->dev, "USB is disabled\n");
 		ret = -ENODEV;
-		goto out;
+		goto out1;
 	}
 
 	/* Enable AHB slave USB clock, needed for further USB clock control */
@@ -265,13 +265,13 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	if (IS_ERR(usb_dev_clk)) {
 		dev_err(&pdev->dev, "failed to acquire USB DEV Clock\n");
 		ret = PTR_ERR(usb_dev_clk);
-		goto out4;
+		goto out3;
 	}
 
 	ret = clk_enable(usb_dev_clk);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to start USB DEV Clock\n");
-		goto out5;
+		goto out4;
 	}
 
 	/* Enable USB otg clocks */
@@ -279,7 +279,7 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	if (IS_ERR(usb_otg_clk)) {
 		dev_err(&pdev->dev, "failed to acquire USB DEV Clock\n");
 		ret = PTR_ERR(usb_otg_clk);
-		goto out6;
+		goto out5;
 	}
 
 	__raw_writel(__raw_readl(USB_CTRL) | USB_HOST_NEED_CLK_EN, USB_CTRL);
@@ -287,7 +287,7 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	ret = clk_enable(usb_otg_clk);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to start USB DEV Clock\n");
-		goto out7;
+		goto out6;
 	}
 
 	isp1301_configure();
@@ -296,7 +296,7 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	if (!hcd) {
 		dev_err(&pdev->dev, "Failed to allocate HC buffer\n");
 		ret = -ENOMEM;
-		goto out8;
+		goto out7;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.7.1


