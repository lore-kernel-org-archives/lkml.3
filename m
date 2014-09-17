Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbaIQTBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:01:00 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:5946 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756485AbaIQTA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:00:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNAL/ZGVRXQCIg/2dsb2JhbABhgw22FQUBcAGbFwGBFhcBeYQEAQUnLyMQUTkeGYhCAb9nGIYJiW4HhEsFnQyMMokWghuBRTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: daniel.vetter@intel.com, Fabian Frederick <fabf@skynet.be>,
        Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Subject: [PATCH 4/6] video: fbdev: cyber2000fb.c: use container_of to resolve cfb_info from fb_info
Date: Wed, 17 Sep 2014 21:00:17 +0200
Message-Id: <1410980419-5326-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410980419-5326-1-git-send-email-fabf@skynet.be>
References: <1410980419-5326-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
Compiled but untested.

 drivers/video/fbdev/cyber2000fb.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/video/fbdev/cyber2000fb.c b/drivers/video/fbdev/cyber2000fb.c
index b0a950f..99acf53 100644
--- a/drivers/video/fbdev/cyber2000fb.c
+++ b/drivers/video/fbdev/cyber2000fb.c
@@ -159,7 +159,7 @@ cyber2000_seqw(unsigned int reg, unsigned int val, struct cfb_info *cfb)
 static void
 cyber2000fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 {
-	struct cfb_info *cfb = (struct cfb_info *)info;
+	struct cfb_info *cfb = container_of(info, struct cfb_info, fb);
 	unsigned long dst, col;
 
 	if (!(cfb->fb.var.accel_flags & FB_ACCELF_TEXT)) {
@@ -191,7 +191,7 @@ cyber2000fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 static void
 cyber2000fb_copyarea(struct fb_info *info, const struct fb_copyarea *region)
 {
-	struct cfb_info *cfb = (struct cfb_info *)info;
+	struct cfb_info *cfb = container_of(info, struct cfb_info, fb);
 	unsigned int cmd = CO_CMD_L_PATTERN_FGCOL;
 	unsigned long src, dst;
 
@@ -241,7 +241,7 @@ cyber2000fb_imageblit(struct fb_info *info, const struct fb_image *image)
 
 static int cyber2000fb_sync(struct fb_info *info)
 {
-	struct cfb_info *cfb = (struct cfb_info *)info;
+	struct cfb_info *cfb = container_of(info, struct cfb_info, fb);
 	int count = 100000;
 
 	if (!(cfb->fb.var.accel_flags & FB_ACCELF_TEXT))
@@ -276,7 +276,7 @@ static int
 cyber2000fb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 		      u_int transp, struct fb_info *info)
 {
-	struct cfb_info *cfb = (struct cfb_info *)info;
+	struct cfb_info *cfb = container_of(info, struct cfb_info, fb);
 	struct fb_var_screeninfo *var = &cfb->fb.var;
 	u32 pseudo_val;
 	int ret = 1;
@@ -758,7 +758,7 @@ cyber2000fb_decode_clock(struct par_info *hw, struct cfb_info *cfb,
 static int
 cyber2000fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
-	struct cfb_info *cfb = (struct cfb_info *)info;
+	struct cfb_info *cfb = container_of(info, struct cfb_info, fb);
 	struct par_info hw;
 	unsigned int mem;
 	int err;
@@ -861,7 +861,7 @@ cyber2000fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 
 static int cyber2000fb_set_par(struct fb_info *info)
 {
-	struct cfb_info *cfb = (struct cfb_info *)info;
+	struct cfb_info *cfb = container_of(info, struct cfb_info, fb);
 	struct fb_var_screeninfo *var = &cfb->fb.var;
 	struct par_info hw;
 	unsigned int mem;
@@ -971,7 +971,7 @@ static int cyber2000fb_set_par(struct fb_info *info)
 static int
 cyber2000fb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info)
 {
-	struct cfb_info *cfb = (struct cfb_info *)info;
+	struct cfb_info *cfb = container_of(info, struct cfb_info, fb);
 
 	if (cyber2000fb_update_start(cfb, var))
 		return -EINVAL;
@@ -1007,7 +1007,7 @@ cyber2000fb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info)
  */
 static int cyber2000fb_blank(int blank, struct fb_info *info)
 {
-	struct cfb_info *cfb = (struct cfb_info *)info;
+	struct cfb_info *cfb = container_of(info, struct cfb_info, fb);
 	unsigned int sync = 0;
 	int i;
 
-- 
2.1.0

