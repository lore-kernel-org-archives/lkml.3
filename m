Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbaFUNQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 09:16:30 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:49023 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbaFUNQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 09:16:28 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: skeletonfb.c:  Adding code to managing allocation error
Date: Sat, 21 Jun 2014 15:17:26 +0200
Message-Id: <1403356646-29443-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding missing code for managing a memory allocation error that may occur.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/skeletonfb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/skeletonfb.c b/drivers/video/fbdev/skeletonfb.c
index fefde7c..ee6dc7e 100644
--- a/drivers/video/fbdev/skeletonfb.c
+++ b/drivers/video/fbdev/skeletonfb.c
@@ -692,6 +692,7 @@ static int xxxfb_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 
     if (!info) {
 	    /* goto error path */
+	    return -ENOMEM;
     }
 
     par = info->par;
@@ -746,6 +747,7 @@ static int xxxfb_probe(struct pci_dev *dev, const struct pci_device_id *ent)
     info->pixmap.addr = kmalloc(PIXMAP_SIZE, GFP_KERNEL);
     if (!info->pixmap.addr) {
 	    /* goto error */
+	    return -ENOMEM;
     }
 
     info->pixmap.size = PIXMAP_SIZE;
-- 
1.7.10.4

