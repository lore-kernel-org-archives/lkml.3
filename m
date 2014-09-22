Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaIVQaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:30:17 -0400
Received: from smtprelay0106.hostedemail.com ([216.40.44.106]:37621 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753572AbaIVQaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:30:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3867:3870:3871:4250:4605:5007:6119:7652:7903:8603:9592:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12555:12683:13069:13161:13229:13311:13357:14095:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: care71_3c19193481c30
X-Filterd-Recvd-Size: 2407
Message-ID: <1411403411.2952.36.camel@joe-AO725>
Subject: [PATCH] drm: change drm_err return type to void
From: Joe Perches <joe@perches.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 22 Sep 2014 09:30:11 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value is not used by callers of this function
nor by uses of the DRM_ERROR macro so change the function
to return void.

Signed-off-by: Joe Perches <joe@perches.com>
---
This change is associated to a desire to eventually
change printk to return void.

No x86 change in output size for drm_drv.o

 drivers/gpu/drm/drm_drv.c | 7 ++-----
 include/drm/drmP.h        | 2 +-
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 6a11902..8889f8e 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -56,22 +56,19 @@ static struct idr drm_minors_idr;
 struct class *drm_class;
 static struct dentry *drm_debugfs_root;
 
-int drm_err(const char *func, const char *format, ...)
+void drm_err(const char *func, const char *format, ...)
 {
 	struct va_format vaf;
 	va_list args;
-	int r;
 
 	va_start(args, format);
 
 	vaf.fmt = format;
 	vaf.va = &args;
 
-	r = printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* %pV", func, &vaf);
+	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* %pV", func, &vaf);
 
 	va_end(args);
-
-	return r;
 }
 EXPORT_SYMBOL(drm_err);
 
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 5c60d38..2163ccb 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -124,7 +124,7 @@ extern __printf(2, 3)
 void drm_ut_debug_printk(const char *function_name,
 			 const char *format, ...);
 extern __printf(2, 3)
-int drm_err(const char *func, const char *format, ...);
+void drm_err(const char *func, const char *format, ...);
 
 /***********************************************************************/
 /** \name DRM template customization defaults */


