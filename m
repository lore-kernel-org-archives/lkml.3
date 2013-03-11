Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab3CKXS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:18:29 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:64244 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3CKXS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:18:28 -0400
From: Fabio Estevam <festevam@gmail.com>
To: zbr@ioremap.net
Cc: gregkh@linuxfoundation.org, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/2] w1: mxc_w1: Convert to devm_ioremap_resource()
Date: Mon, 11 Mar 2013 20:18:15 -0300
Message-Id: <1363043896-16140-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

According to Documentation/driver-model/devres.txt:

  devm_request_and_ioremap() : obsoleted by devm_ioremap_resource()

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/w1/masters/mxc_w1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 950d354..47e12cf 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -121,9 +121,9 @@ static int mxc_w1_probe(struct platform_device *pdev)
 	mdev->clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	mdev->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!mdev->regs)
-		return -EBUSY;
+	mdev->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mdev->regs))
+		return PTR_ERR(mdev->regs);
 
 	clk_prepare_enable(mdev->clk);
 	__raw_writeb(mdev->clkdiv, mdev->regs + MXC_W1_TIME_DIVIDER);
-- 
1.7.9.5

