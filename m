Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbbANNwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:52:02 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:38659 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbbANNv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:51:59 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>, Lee Jones <lee.jones@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 3/3] backlight: 88pm860x_bl: Use of_get_child_by_name() instead of refcount hack
Date: Wed, 14 Jan 2015 14:51:59 +0100
Message-Id: <1421243519-6257-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421243519-6257-1-git-send-email-geert+renesas@glider.be>
References: <1421243519-6257-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name() calls of_node_put() on its "from" parameter.
To counter this, pm860x_backlight_dt_init() calls of_node_get() first.

Use of_get_child_by_name() instead to get rid of the refcount hack.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-fbdev@vger.kernel.org
---
Compile-tested only
---
 drivers/video/backlight/88pm860x_bl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index 9a23698b6fe8398c..2da5862876d1fe78 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -168,10 +168,7 @@ static int pm860x_backlight_dt_init(struct platform_device *pdev,
 	struct device_node *nproot, *np;
 	int iset = 0;
 
-	nproot = of_node_get(pdev->dev.parent->of_node);
-	if (!nproot)
-		return -ENODEV;
-	nproot = of_find_node_by_name(nproot, "backlights");
+	nproot = of_get_child_by_name(pdev->dev.parent->of_node, "backlights");
 	if (!nproot) {
 		dev_err(&pdev->dev, "failed to find backlights node\n");
 		return -ENODEV;
-- 
1.9.1

