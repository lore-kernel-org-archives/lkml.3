Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbaIQTAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:00:55 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:5946 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755786AbaIQTAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:00:52 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNAL/ZGVRXQCIg/2dsb2JhbABhgw22FQUBcAGbFwGBFhcBeYQEAQUnLyMQUTkeGYhCAb9nGIYJiW4HFoQ1BZ0MjDKJFoIbgUU7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: daniel.vetter@intel.com, Fabian Frederick <fabf@skynet.be>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH 2/6] video: fbdev: sa1100fb.c: use container_of to resolve sa1100fb_info from fb_info
Date: Wed, 17 Sep 2014 21:00:15 +0200
Message-Id: <1410980419-5326-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410980419-5326-1-git-send-email-fabf@skynet.be>
References: <1410980419-5326-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
ARM/SA1100 cross-compiled but untested.

 drivers/video/fbdev/sa1100fb.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/sa1100fb.c b/drivers/video/fbdev/sa1100fb.c
index 580c444e..9690216 100644
--- a/drivers/video/fbdev/sa1100fb.c
+++ b/drivers/video/fbdev/sa1100fb.c
@@ -268,7 +268,8 @@ static int
 sa1100fb_setpalettereg(u_int regno, u_int red, u_int green, u_int blue,
 		       u_int trans, struct fb_info *info)
 {
-	struct sa1100fb_info *fbi = (struct sa1100fb_info *)info;
+	struct sa1100fb_info *fbi =
+		container_of(info, struct sa1100fb_info, fb);
 	u_int val, ret = 1;
 
 	if (regno < fbi->palette_size) {
@@ -289,7 +290,8 @@ static int
 sa1100fb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 		   u_int trans, struct fb_info *info)
 {
-	struct sa1100fb_info *fbi = (struct sa1100fb_info *)info;
+	struct sa1100fb_info *fbi =
+		container_of(info, struct sa1100fb_info, fb);
 	unsigned int val;
 	int ret = 1;
 
@@ -366,7 +368,8 @@ static inline unsigned int sa1100fb_display_dma_period(struct fb_var_screeninfo
 static int
 sa1100fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
-	struct sa1100fb_info *fbi = (struct sa1100fb_info *)info;
+	struct sa1100fb_info *fbi =
+		container_of(info, struct sa1100fb_info, fb);
 	int rgbidx;
 
 	if (var->xres < MIN_XRES)
@@ -433,7 +436,8 @@ static void sa1100fb_set_visual(struct sa1100fb_info *fbi, u32 visual)
  */
 static int sa1100fb_set_par(struct fb_info *info)
 {
-	struct sa1100fb_info *fbi = (struct sa1100fb_info *)info;
+	struct sa1100fb_info *fbi =
+		container_of(info, struct sa1100fb_info, fb);
 	struct fb_var_screeninfo *var = &info->var;
 	unsigned long palette_mem_size;
 
@@ -526,7 +530,8 @@ sa1100fb_set_cmap(struct fb_cmap *cmap, int kspc, int con,
  */
 static int sa1100fb_blank(int blank, struct fb_info *info)
 {
-	struct sa1100fb_info *fbi = (struct sa1100fb_info *)info;
+	struct sa1100fb_info *fbi =
+		container_of(info, struct sa1100fb_info, fb);
 	int i;
 
 	dev_dbg(fbi->dev, "sa1100fb_blank: blank=%d\n", blank);
@@ -555,7 +560,8 @@ static int sa1100fb_blank(int blank, struct fb_info *info)
 static int sa1100fb_mmap(struct fb_info *info,
 			 struct vm_area_struct *vma)
 {
-	struct sa1100fb_info *fbi = (struct sa1100fb_info *)info;
+	struct sa1100fb_info *fbi =
+		container_of(info, struct sa1100fb_info, fb);
 	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
 
 	if (off < info->fix.smem_len) {
-- 
2.1.0

