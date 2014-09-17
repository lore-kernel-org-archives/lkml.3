Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbaIQTBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:01:03 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:5946 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756507AbaIQTA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:00:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNAL/ZGVRXQCIg/2dsb2JhbABhgw22FQUBcAGbFwGBFhcBeYQEAQUnLyMQUTkeGYhCAb9nGIYJiW4HhEsFhh+WbYwyiRaCG4FFOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: daniel.vetter@intel.com, Fabian Frederick <fabf@skynet.be>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH 5/6] video: fbdev: pxafb.c: use container_of to resolve pxafb_info/layer from fb_info
Date: Wed, 17 Sep 2014 21:00:18 +0200
Message-Id: <1410980419-5326-6-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410980419-5326-1-git-send-email-fabf@skynet.be>
References: <1410980419-5326-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
ARM-PXA cross-compiled but untested.

 drivers/video/fbdev/pxafb.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/video/fbdev/pxafb.c b/drivers/video/fbdev/pxafb.c
index 1ecd9ce..a5acca8 100644
--- a/drivers/video/fbdev/pxafb.c
+++ b/drivers/video/fbdev/pxafb.c
@@ -138,7 +138,7 @@ static int
 pxafb_setpalettereg(u_int regno, u_int red, u_int green, u_int blue,
 		       u_int trans, struct fb_info *info)
 {
-	struct pxafb_info *fbi = (struct pxafb_info *)info;
+	struct pxafb_info *fbi = container_of(info, struct pxafb_info, fb);
 	u_int val;
 
 	if (regno >= fbi->palette_size)
@@ -183,7 +183,7 @@ static int
 pxafb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 		   u_int trans, struct fb_info *info)
 {
-	struct pxafb_info *fbi = (struct pxafb_info *)info;
+	struct pxafb_info *fbi = container_of(info, struct pxafb_info, fb);
 	unsigned int val;
 	int ret = 1;
 
@@ -456,7 +456,7 @@ static int pxafb_adjust_timing(struct pxafb_info *fbi,
  */
 static int pxafb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
-	struct pxafb_info *fbi = (struct pxafb_info *)info;
+	struct pxafb_info *fbi = container_of(info, struct pxafb_info, fb);
 	struct pxafb_mach_info *inf = dev_get_platdata(fbi->dev);
 	int err;
 
@@ -494,7 +494,7 @@ static int pxafb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
  */
 static int pxafb_set_par(struct fb_info *info)
 {
-	struct pxafb_info *fbi = (struct pxafb_info *)info;
+	struct pxafb_info *fbi = container_of(info, struct pxafb_info, fb);
 	struct fb_var_screeninfo *var = &info->var;
 
 	if (var->bits_per_pixel >= 16)
@@ -533,7 +533,7 @@ static int pxafb_set_par(struct fb_info *info)
 static int pxafb_pan_display(struct fb_var_screeninfo *var,
 			     struct fb_info *info)
 {
-	struct pxafb_info *fbi = (struct pxafb_info *)info;
+	struct pxafb_info *fbi = container_of(info, struct pxafb_info, fb);
 	struct fb_var_screeninfo newvar;
 	int dma = DMA_MAX + DMA_BASE;
 
@@ -566,7 +566,7 @@ static int pxafb_pan_display(struct fb_var_screeninfo *var,
  */
 static int pxafb_blank(int blank, struct fb_info *info)
 {
-	struct pxafb_info *fbi = (struct pxafb_info *)info;
+	struct pxafb_info *fbi = container_of(info, struct pxafb_info, fb);
 	int i;
 
 	switch (blank) {
@@ -725,7 +725,7 @@ static struct pxafb_layer_ops ofb_ops[] = {
 
 static int overlayfb_open(struct fb_info *info, int user)
 {
-	struct pxafb_layer *ofb = (struct pxafb_layer *)info;
+	struct pxafb_layer *ofb = container_of(info, struct pxafb_layer, fb);
 
 	/* no support for framebuffer console on overlay */
 	if (user == 0)
@@ -743,7 +743,7 @@ static int overlayfb_open(struct fb_info *info, int user)
 
 static int overlayfb_release(struct fb_info *info, int user)
 {
-	struct pxafb_layer *ofb = (struct pxafb_layer*) info;
+	struct pxafb_layer *ofb = container_of(info, struct pxafb_layer, fb);
 
 	if (ofb->usage == 1) {
 		ofb->ops->disable(ofb);
@@ -760,7 +760,7 @@ static int overlayfb_release(struct fb_info *info, int user)
 static int overlayfb_check_var(struct fb_var_screeninfo *var,
 			       struct fb_info *info)
 {
-	struct pxafb_layer *ofb = (struct pxafb_layer *)info;
+	struct pxafb_layer *ofb = container_of(info, struct pxafb_layer, fb);
 	struct fb_var_screeninfo *base_var = &ofb->fbi->fb.var;
 	int xpos, ypos, pfor, bpp;
 
@@ -836,7 +836,7 @@ static int overlayfb_check_video_memory(struct pxafb_layer *ofb)
 
 static int overlayfb_set_par(struct fb_info *info)
 {
-	struct pxafb_layer *ofb = (struct pxafb_layer *)info;
+	struct pxafb_layer *ofb = container_of(info, struct pxafb_layer, fb);
 	struct fb_var_screeninfo *var = &info->var;
 	int xpos, ypos, pfor, bpp, ret;
 
-- 
2.1.0

