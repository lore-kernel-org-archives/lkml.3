Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaETVfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:35:14 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:48659 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaETVfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:35:11 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] video: fbdev: grvga.c:  Fix for possible null pointer dereference
Date: Tue, 20 May 2014 23:35:59 +0200
Message-Id: <1400621759-7814-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/grvga.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/grvga.c b/drivers/video/fbdev/grvga.c
index c078701..2db5bb1 100644
--- a/drivers/video/fbdev/grvga.c
+++ b/drivers/video/fbdev/grvga.c
@@ -514,9 +514,10 @@ free_fb:
 static int grvga_remove(struct platform_device *device)
 {
 	struct fb_info *info = dev_get_drvdata(&device->dev);
-	struct grvga_par *par = info->par;
+	struct grvga_par *par;
 
 	if (info) {
+		par = info->par;
 		unregister_framebuffer(info);
 		fb_dealloc_cmap(&info->cmap);
 
-- 
1.7.10.4

