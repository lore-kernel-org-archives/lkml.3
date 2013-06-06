Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab3FFNzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:55:43 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:36787 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3FFNzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:55:42 -0400
From: Emil Goode <emilgoode@gmail.com>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] uio: uio_pruss: Fix potential NULL pointer dereference
Date: Thu,  6 Jun 2013 15:55:28 +0200
Message-Id: <1370526928-20619-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function pruss_probe we free gdev and try to use
it on the next line. I have moved the dereference to
above the kfree of gdev.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/uio/uio_pruss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_pruss.c b/drivers/uio/uio_pruss.c
index 6e2ab00..21f7a72 100644
--- a/drivers/uio/uio_pruss.c
+++ b/drivers/uio/uio_pruss.c
@@ -136,9 +136,9 @@ static int pruss_probe(struct platform_device *dev)
 	gdev->pruss_clk = clk_get(&dev->dev, "pruss");
 	if (IS_ERR(gdev->pruss_clk)) {
 		dev_err(&dev->dev, "Failed to get clock\n");
+		ret = PTR_ERR(gdev->pruss_clk);
 		kfree(gdev->info);
 		kfree(gdev);
-		ret = PTR_ERR(gdev->pruss_clk);
 		return ret;
 	} else {
 		clk_enable(gdev->pruss_clk);
-- 
1.7.10.4

