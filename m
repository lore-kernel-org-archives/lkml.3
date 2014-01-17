Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaAQJXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:23:05 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52120 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaAQJXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:23:00 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: i2c: mt9v032: Check return value of clk_prepare_enable/clk_set_rate
Date: Fri, 17 Jan 2014 14:52:47 +0530
Message-Id: <1389950567-32577-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

clk_set_rate(), clk_prepare_enable() functions can fail, so check the return
values to avoid surprises.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/mt9v032.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 36c504b..40172b8 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -317,8 +317,14 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
 	int ret;
 
-	clk_set_rate(mt9v032->clk, mt9v032->sysclk);
-	clk_prepare_enable(mt9v032->clk);
+	ret = clk_set_rate(mt9v032->clk, mt9v032->sysclk);
+	if (ret < 0)
+		return ret;
+
+	ret = clk_prepare_enable(mt9v032->clk);
+	if (ret)
+		return ret;
+
 	udelay(1);
 
 	/* Reset the chip and stop data read out */
-- 
1.7.9.5

