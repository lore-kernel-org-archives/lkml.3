Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab3FERaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:30:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56104 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab3FERaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:30:09 -0400
From: Emil Goode <emilgoode@gmail.com>
To: archit@ti.com, axel.lin@gmail.com
Cc: linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] OMAPDSS: Remove kfree for memory allocated with devm_kzalloc
Date: Wed,  5 Jun 2013 19:29:56 +0200
Message-Id: <1370453396-18043-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not necessary to free memory allocated with devm_kzalloc
in a remove function and using kfree leads to a double free.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/video/omap2/displays/panel-picodlp.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/omap2/displays/panel-picodlp.c b/drivers/video/omap2/displays/panel-picodlp.c
index 62f2db0..859e111 100644
--- a/drivers/video/omap2/displays/panel-picodlp.c
+++ b/drivers/video/omap2/displays/panel-picodlp.c
@@ -469,8 +469,6 @@ static void picodlp_panel_remove(struct omap_dss_device *dssdev)
 	i2c_unregister_device(picod->picodlp_i2c_client);
 	dev_set_drvdata(&dssdev->dev, NULL);
 	dev_dbg(&dssdev->dev, "removing picodlp panel\n");
-
-	kfree(picod);
 }
 
 static int picodlp_panel_enable(struct omap_dss_device *dssdev)
-- 
1.7.10.4

