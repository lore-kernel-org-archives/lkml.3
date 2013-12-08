Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3LHCnW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 21:43:22 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51372 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3LHCnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 21:43:21 -0500
From: "ethan.zhao" <ethan.kernel@gmail.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-kernel@vger.kernel.org, "ethan.zhao" <ethan.kernel@gmail.com>
Subject: [PATCH] r_du_lvdsenc.c : Check return value of devm_ioremap_resource with IS_ERR
Date: Sun,  8 Dec 2013 10:41:46 +0800
Message-Id: <1386470506-553-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

function devm_ioremap_resource() doesn't return NULL, should check its return
value with helper IS_ERR().

Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
index a0f6a17..93190ab 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
@@ -151,7 +151,7 @@ static int rcar_du_lvdsenc_get_resources(struct rcar_du_lvdsenc *lvds,
 	}
 
 	lvds->mmio = devm_ioremap_resource(&pdev->dev, mem);
-	if (lvds->mmio == NULL) {
+	if (IS_ERR(lvds->mmio)) {
 		dev_err(&pdev->dev, "failed to remap memory resource for %s\n",
 			name);
 		return -ENOMEM;
-- 
1.8.3.4 (Apple Git-47)

