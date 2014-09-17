Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbaIQTBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:01:10 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:5985 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755807AbaIQTBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:01:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNAL/ZGVRXQCIg/2dsb2JhbABhgw22FQUBcAGbFwGBFhcBeYQEAQUnLyMQUTkeGYhCAb9nGIYJiW4HFoQ1BZ0MjDKJFoIbgUU7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: daniel.vetter@intel.com, Fabian Frederick <fabf@skynet.be>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH 6/6] video: fbdev: valkyriefb.c: use container_of to resolve fb_info_valkyrie from fb_info
Date: Wed, 17 Sep 2014 21:00:19 +0200
Message-Id: <1410980419-5326-7-git-send-email-fabf@skynet.be>
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

 drivers/video/fbdev/valkyriefb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/valkyriefb.c b/drivers/video/fbdev/valkyriefb.c
index 97cb9bd..9c98945 100644
--- a/drivers/video/fbdev/valkyriefb.c
+++ b/drivers/video/fbdev/valkyriefb.c
@@ -136,7 +136,8 @@ static struct fb_ops valkyriefb_ops = {
 /* Sets the video mode according to info->var */
 static int valkyriefb_set_par(struct fb_info *info)
 {
-	struct fb_info_valkyrie *p = (struct fb_info_valkyrie *) info;
+	struct fb_info_valkyrie *p =
+		container_of(info, struct fb_info_valkyrie, info);
 	volatile struct valkyrie_regs __iomem *valkyrie_regs = p->valkyrie_regs;
 	struct fb_par_valkyrie *par = info->par;
 	struct valkyrie_regvals	*init;
@@ -194,7 +195,8 @@ valkyriefb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
  */
 static int valkyriefb_blank(int blank_mode, struct fb_info *info)
 {
-	struct fb_info_valkyrie *p = (struct fb_info_valkyrie *) info;
+	struct fb_info_valkyrie *p =
+		container_of(info, struct fb_info_valkyrie, info);
 	struct fb_par_valkyrie *par = info->par;
 	struct valkyrie_regvals	*init = par->init;
 
@@ -226,7 +228,8 @@ static int valkyriefb_blank(int blank_mode, struct fb_info *info)
 static int valkyriefb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 			     u_int transp, struct fb_info *info)
 {
-	struct fb_info_valkyrie *p = (struct fb_info_valkyrie *) info;
+	struct fb_info_valkyrie *p =
+		container_of(info, struct fb_info_valkyrie, info);
 	volatile struct cmap_regs __iomem *cmap_regs = p->cmap_regs;
 	struct fb_par_valkyrie *par = info->par;
 
@@ -465,7 +468,8 @@ static int valkyrie_var_to_par(struct fb_var_screeninfo *var,
 {
 	int vmode, cmode;
 	struct valkyrie_regvals *init;
-	struct fb_info_valkyrie *p = (struct fb_info_valkyrie *) fb_info;
+	struct fb_info_valkyrie *p =
+		container_of(fb_info, struct fb_info_valkyrie, info);
 
 	if (mac_var_to_vmode(var, &vmode, &cmode) != 0) {
 		printk(KERN_ERR "valkyriefb: can't do %dx%dx%d.\n",
-- 
2.1.0

