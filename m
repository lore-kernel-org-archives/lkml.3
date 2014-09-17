Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbaIQTCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:02:42 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:5946 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756351AbaIQTAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:00:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNAL/ZGVRXQCIg/2dsb2JhbABhgw22FQUBcAGbFwGBFhcBeYQEAQUnLyMQUTkeGYhCAb9nGIYJiW4HFoQ1BZ0MjDKJFoIbgUU7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: daniel.vetter@intel.com, Fabian Frederick <fabf@skynet.be>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH 3/6] video: fbdev: controlfb.c: use container_of to resolve fb_info_control from fb_info
Date: Wed, 17 Sep 2014 21:00:16 +0200
Message-Id: <1410980419-5326-4-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410980419-5326-1-git-send-email-fabf@skynet.be>
References: <1410980419-5326-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
PPC32 cross-compiled but untested.

 drivers/video/fbdev/controlfb.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/controlfb.c b/drivers/video/fbdev/controlfb.c
index fdadef9..080fdd2 100644
--- a/drivers/video/fbdev/controlfb.c
+++ b/drivers/video/fbdev/controlfb.c
@@ -218,7 +218,8 @@ static int controlfb_check_var (struct fb_var_screeninfo *var, struct fb_info *i
  */
 static int controlfb_set_par (struct fb_info *info)
 {
-	struct fb_info_control *p = (struct fb_info_control *) info;
+	struct fb_info_control *p =
+		container_of(info, struct fb_info_control, info);
 	struct fb_par_control par;
 	int err;
 
@@ -258,7 +259,8 @@ static int controlfb_pan_display(struct fb_var_screeninfo *var,
 				 struct fb_info *info)
 {
 	unsigned int xoffset, hstep;
-	struct fb_info_control *p = (struct fb_info_control *)info;
+	struct fb_info_control *p =
+		container_of(info, struct fb_info_control, info);
 	struct fb_par_control *par = &p->par;
 
 	/*
@@ -309,7 +311,8 @@ static int controlfb_mmap(struct fb_info *info,
 
 static int controlfb_blank(int blank_mode, struct fb_info *info)
 {
-	struct fb_info_control *p = (struct fb_info_control *) info;
+	struct fb_info_control *p =
+		container_of(info, struct fb_info_control, info);
 	unsigned ctrl;
 
 	ctrl = ld_le32(CNTRL_REG(p,ctrl));
@@ -342,7 +345,8 @@ static int controlfb_blank(int blank_mode, struct fb_info *info)
 static int controlfb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 			     u_int transp, struct fb_info *info)
 {
-	struct fb_info_control *p = (struct fb_info_control *) info;
+	struct fb_info_control *p =
+		container_of(info, struct fb_info_control, info);
 	__u8 r, g, b;
 
 	if (regno > 255)
@@ -833,7 +837,8 @@ static int control_var_to_par(struct fb_var_screeninfo *var,
 	unsigned hperiod, hssync, hsblank, hesync, heblank, piped, heq, hlfln,
 		 hserr, vperiod, vssync, vesync, veblank, vsblank, vswin, vewin;
 	unsigned long pixclock;
-	struct fb_info_control *p = (struct fb_info_control *) fb_info;
+	struct fb_info_control *p =
+		container_of(fb_info, struct fb_info_control, info);
 	struct control_regvals *r = &par->regvals;
 
 	switch (var->bits_per_pixel) {
-- 
2.1.0

