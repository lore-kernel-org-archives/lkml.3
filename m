Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab3K2Lmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:42:32 -0500
Received: from fallback5.mail.ru ([94.100.176.59]:49791 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3K2LmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:42:22 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 1/3] w1: mxc_w1: Remove unused field "clkdiv" from private structure
Date: Fri, 29 Nov 2013 15:39:28 +0400
Message-Id: <1385725170-31515-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Private field "clkdiv" is not used outside "probe", so there are
no reason to keep it in driver.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/w1/masters/mxc_w1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 15c7251..5de3ca9 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -46,7 +46,6 @@
 
 struct mxc_w1_device {
 	void __iomem *regs;
-	unsigned int clkdiv;
 	struct clk *clk;
 	struct w1_bus_master bus_master;
 };
@@ -107,6 +106,7 @@ static int mxc_w1_probe(struct platform_device *pdev)
 {
 	struct mxc_w1_device *mdev;
 	struct resource *res;
+	unsigned int clkdiv;
 	int err = 0;
 
 	mdev = devm_kzalloc(&pdev->dev, sizeof(struct mxc_w1_device),
@@ -118,7 +118,7 @@ static int mxc_w1_probe(struct platform_device *pdev)
 	if (IS_ERR(mdev->clk))
 		return PTR_ERR(mdev->clk);
 
-	mdev->clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;
+	clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mdev->regs = devm_ioremap_resource(&pdev->dev, res);
@@ -126,7 +126,7 @@ static int mxc_w1_probe(struct platform_device *pdev)
 		return PTR_ERR(mdev->regs);
 
 	clk_prepare_enable(mdev->clk);
-	__raw_writeb(mdev->clkdiv, mdev->regs + MXC_W1_TIME_DIVIDER);
+	__raw_writeb(clkdiv, mdev->regs + MXC_W1_TIME_DIVIDER);
 
 	mdev->bus_master.data = mdev;
 	mdev->bus_master.reset_bus = mxc_w1_ds2_reset_bus;
-- 
1.8.3.2

