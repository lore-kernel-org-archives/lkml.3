Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaLaGzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 01:55:51 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36954 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaLaGzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 01:55:50 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fbdev: geocode: remove unneeded NULL check
Date: Wed, 31 Dec 2014 12:25:38 +0530
Message-Id: <1420008938-18423-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the check for info is not required as we are checking it immediately
after gx1fb_init_fbinfo() and returnig -ENOMEM if it is NULL.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/video/fbdev/geode/gx1fb_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/geode/gx1fb_core.c b/drivers/video/fbdev/geode/gx1fb_core.c
index 2794ba1..9bee874 100644
--- a/drivers/video/fbdev/geode/gx1fb_core.c
+++ b/drivers/video/fbdev/geode/gx1fb_core.c
@@ -374,10 +374,8 @@ static int gx1fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		release_mem_region(gx1_gx_base() + 0x8300, 0x100);
 	}
 
-	if (info) {
-		fb_dealloc_cmap(&info->cmap);
-		framebuffer_release(info);
-	}
+	fb_dealloc_cmap(&info->cmap);
+	framebuffer_release(info);
 
 	return ret;
 }
-- 
1.8.1.2

