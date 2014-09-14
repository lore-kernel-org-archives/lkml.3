Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaINQko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:40:44 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:55260 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbaINQkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:40:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIOALvDFVRbsGnM/2dsb2JhbABggw2zSAEBAQEBAQUBbwGdfAGBBBd4hAQBBScvIxBROR4ZiEIBqQyPAhiFfIhtZAcWhDUFnQiMMIkPghuBRTsvgQaBRAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, Fabian Frederick <fabf@skynet.be>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/9 linux-next] drm/cirrus: use container_of to resolve cirrus_fbdev from drm_fb_helper
Date: Sun, 14 Sep 2014 18:40:14 +0200
Message-Id: <1410712823-29137-2-git-send-email-fabf@skynet.be>
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

 drivers/gpu/drm/cirrus/cirrus_fbdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index 2a135f2..d231b1c 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -160,7 +160,8 @@ static int cirrusfb_create_object(struct cirrus_fbdev *afbdev,
 static int cirrusfb_create(struct drm_fb_helper *helper,
 			   struct drm_fb_helper_surface_size *sizes)
 {
-	struct cirrus_fbdev *gfbdev = (struct cirrus_fbdev *)helper;
+	struct cirrus_fbdev *gfbdev =
+		container_of(helper, struct cirrus_fbdev, helper);
 	struct drm_device *dev = gfbdev->helper.dev;
 	struct cirrus_device *cdev = gfbdev->helper.dev->dev_private;
 	struct fb_info *info;
-- 
1.9.1

