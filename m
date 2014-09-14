Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaINQmD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:42:03 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:63118 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960AbaINQmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:42:01 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIOANrEFVRbsGnM/2dsb2JhbABggw2zSAEBAQEBAQUBbwGdfAGBBBd4hAQBBScvIxBROR4ZiEIBqQ2PAxiFfIhtZAcWhDUFnQiMMIkPghuBRTsvgQaBRAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, Fabian Frederick <fabf@skynet.be>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 9/9 linux-next] drm/udl: use container_of to resolve udl_fbdev from drm_fb_helper
Date: Sun, 14 Sep 2014 18:40:22 +0200
Message-Id: <1410712823-29137-10-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410712823-29137-1-git-send-email-fabf@skynet.be>
References: <1410712823-29137-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
Compiled but untested.

 drivers/gpu/drm/udl/udl_fb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/udl/udl_fb.c b/drivers/gpu/drm/udl/udl_fb.c
index d1da339..8cbcb45 100644
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -472,7 +472,8 @@ udl_framebuffer_init(struct drm_device *dev,
 static int udlfb_create(struct drm_fb_helper *helper,
 			struct drm_fb_helper_surface_size *sizes)
 {
-	struct udl_fbdev *ufbdev = (struct udl_fbdev *)helper;
+	struct udl_fbdev *ufbdev =
+		container_of(helper, struct udl_fbdev, helper);
 	struct drm_device *dev = ufbdev->helper.dev;
 	struct fb_info *info;
 	struct device *device = dev->dev;
-- 
1.9.1

