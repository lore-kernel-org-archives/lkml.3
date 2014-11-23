Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875AbaKWKpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 05:45:19 -0500
Received: from mout.web.de ([212.227.15.14]:60822 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaKWKpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 05:45:16 -0500
Message-ID: <5471BAA3.3010409@users.sourceforge.net>
Date: Sun, 23 Nov 2014 11:44:51 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] video: udlfb: Deletion of unnecessary checks before the
 function call "vfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:wwnSJfYbCVDJabEuFPvtiW001M5EG8ApmzRMNrv7uoDITP7Gt9a
 5cBKI+aP2g4njhTED5Zik7QemDIe4Zp1YB9vg1BP8PEoz4x4dP/insg9+xrIhcLq/a3QAzq
 knB4PwUzYlEKztvHqn9UaAfuduRWB3vASzmrfCu38Rh4JgyiiH+qLYofFw0fuqIznueFcl8
 Dse/B2ENc9R30IG35RQlA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 23 Nov 2014 11:40:47 +0100

The vfree() function performs also input parameter validation. Thus the test
around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/udlfb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index 77b890e..01fff0c 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -922,8 +922,7 @@ static void dlfb_free(struct kref *kref)
 {
 	struct dlfb_data *dev = container_of(kref, struct dlfb_data, kref);
 
-	if (dev->backing_buffer)
-		vfree(dev->backing_buffer);
+	vfree(dev->backing_buffer);
 
 	kfree(dev->edid);
 
@@ -953,8 +952,7 @@ static void dlfb_free_framebuffer(struct dlfb_data *dev)
 			fb_dealloc_cmap(&info->cmap);
 		if (info->monspecs.modedb)
 			fb_destroy_modedb(info->monspecs.modedb);
-		if (info->screen_base)
-			vfree(info->screen_base);
+		vfree(info->screen_base);
 
 		fb_destroy_modelist(&info->modelist);
 
@@ -1203,8 +1201,7 @@ static int dlfb_realloc_framebuffer(struct dlfb_data *dev, struct fb_info *info)
 		if (!new_back)
 			pr_info("No shadow/backing buffer allocated\n");
 		else {
-			if (dev->backing_buffer)
-				vfree(dev->backing_buffer);
+			vfree(dev->backing_buffer);
 			dev->backing_buffer = new_back;
 		}
 	}
-- 
2.1.3

