Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbbAFMpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:45:21 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33768 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbbAFMpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:45:19 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fbdev: geocode: remove unneeded NULL check
Date: Tue,  6 Jan 2015 18:15:02 +0530
Message-Id: <1420548302-11489-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1420548302-11489-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1420548302-11489-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the check for info is not required as we are checking it immediately
after gxfb_init_fbinfo() and lxfb_init_fbinfo() and returnig -ENOMEM
if it is NULL.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
Hi Tomi,
This patch is similar to my last patch which you have already queued
for 3.20. if you can revert that then i can send you a single patch
with all these three changes together.

 drivers/video/fbdev/geode/gxfb_core.c | 6 ++----
 drivers/video/fbdev/geode/lxfb_core.c | 6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/video/fbdev/geode/gxfb_core.c b/drivers/video/fbdev/geode/gxfb_core.c
index 1790f14..124d7c7 100644
--- a/drivers/video/fbdev/geode/gxfb_core.c
+++ b/drivers/video/fbdev/geode/gxfb_core.c
@@ -444,10 +444,8 @@ static int gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		pci_release_region(pdev, 1);
 	}
 
-	if (info) {
-		fb_dealloc_cmap(&info->cmap);
-		framebuffer_release(info);
-	}
+	fb_dealloc_cmap(&info->cmap);
+	framebuffer_release(info);
 	return ret;
 }
 
diff --git a/drivers/video/fbdev/geode/lxfb_core.c b/drivers/video/fbdev/geode/lxfb_core.c
index 9e1d19d..138da6c 100644
--- a/drivers/video/fbdev/geode/lxfb_core.c
+++ b/drivers/video/fbdev/geode/lxfb_core.c
@@ -577,10 +577,8 @@ err:
 		pci_release_region(pdev, 3);
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

