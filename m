Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbbAMQPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:15:17 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49529 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbAMQPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:15:14 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-nvidia@lists.surfsouth.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: hgafb: remove unneeded comparison
Date: Tue, 13 Jan 2015 21:44:59 +0530
Message-Id: <1421165699-9033-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

var->yoffset is of the type __u32, hence the comparison will always
be false.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/video/fbdev/hgafb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
index 5ff9fe2..15d3ccf 100644
--- a/drivers/video/fbdev/hgafb.c
+++ b/drivers/video/fbdev/hgafb.c
@@ -417,8 +417,7 @@ static int hgafb_pan_display(struct fb_var_screeninfo *var,
 			     struct fb_info *info)
 {
 	if (var->vmode & FB_VMODE_YWRAP) {
-		if (var->yoffset < 0 || 
-		    var->yoffset >= info->var.yres_virtual ||
+		if (var->yoffset >= info->var.yres_virtual ||
 		    var->xoffset)
 			return -EINVAL;
 	} else {
-- 
1.8.1.2

