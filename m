Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbaGENQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 09:16:25 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:48912 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaGENQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 09:16:23 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: omap2: dss: display-sysfs.c:  Cleaning up wrong type in format string
Date: Sat,  5 Jul 2014 15:17:38 +0200
Message-Id: <1404566258-22901-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>

Wrong type in printf format string, requires 'unsigned int'
but the argument type is 'int'

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/omap2/dss/display-sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/omap2/dss/display-sysfs.c b/drivers/video/fbdev/omap2/dss/display-sysfs.c
index 5a2095a..5928bc9 100644
--- a/drivers/video/fbdev/omap2/dss/display-sysfs.c
+++ b/drivers/video/fbdev/omap2/dss/display-sysfs.c
@@ -184,7 +184,7 @@ static ssize_t display_rotate_show(struct device *dev,
 	if (!dssdev->driver->get_rotate)
 		return -ENOENT;
 	rotate = dssdev->driver->get_rotate(dssdev);
-	return snprintf(buf, PAGE_SIZE, "%u\n", rotate);
+	return snprintf(buf, PAGE_SIZE, "%d\n", rotate);
 }
 
 static ssize_t display_rotate_store(struct device *dev,
@@ -215,7 +215,7 @@ static ssize_t display_mirror_show(struct device *dev,
 	if (!dssdev->driver->get_mirror)
 		return -ENOENT;
 	mirror = dssdev->driver->get_mirror(dssdev);
-	return snprintf(buf, PAGE_SIZE, "%u\n", mirror);
+	return snprintf(buf, PAGE_SIZE, "%d\n", mirror);
 }
 
 static ssize_t display_mirror_store(struct device *dev,
-- 
1.7.10.4

