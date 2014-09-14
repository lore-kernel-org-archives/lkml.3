Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaINQl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:41:27 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:12808 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbaINQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:41:26 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIOANrEFVRbsGnM/2dsb2JhbABggw2zSAEBAQEBAQUBbwGdfAGBBBd4hAQBBScvIxBROR4ZiEIBqQ2PAxiFfIhtZAcWhDUFnQiMMIkPghuBRTsvgQaBRAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, Fabian Frederick <fabf@skynet.be>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 3/9 linux-next] drm/radeon: use container_of to resolve radeon_fbdev from drm_fb_helper
Date: Sun, 14 Sep 2014 18:40:16 +0200
Message-Id: <1410712823-29137-4-git-send-email-fabf@skynet.be>
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

 drivers/gpu/drm/radeon/radeon_fb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index 94b0f2a..0ea1db8 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -189,7 +189,8 @@ out_unref:
 static int radeonfb_create(struct drm_fb_helper *helper,
 			   struct drm_fb_helper_surface_size *sizes)
 {
-	struct radeon_fbdev *rfbdev = (struct radeon_fbdev *)helper;
+	struct radeon_fbdev *rfbdev =
+		container_of(helper, struct radeon_fbdev, helper);
 	struct radeon_device *rdev = rfbdev->rdev;
 	struct fb_info *info;
 	struct drm_framebuffer *fb = NULL;
-- 
1.9.1

