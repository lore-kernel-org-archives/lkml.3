Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab3IZO7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:59:03 -0400
Received: from shell.v3.sk ([195.168.3.45]:46068 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab3IZO65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:58:57 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] drm/radeon: Don't limit fb console on 32M cards to 8 bpp
Date: Thu, 26 Sep 2013 16:58:45 +0200
Message-Id: <1380207525-13088-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment suggests that intention was to limit 16M cards to save memory while
code did something a bit different.

32bpp is a lot more useful with today's apps, such as Weston's fbdev backend
and 32M cards are probably hardly used in apps where dedicating a bit more to
pinned console would matter.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/gpu/drm/radeon/radeon_fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index 665ced3..cef3bc7 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -344,7 +344,7 @@ int radeon_fbdev_init(struct radeon_device *rdev)
 	int ret;
 
 	/* select 8 bpp console on RN50 or 16MB cards */
-	if (ASIC_IS_RN50(rdev) || rdev->mc.real_vram_size <= (32*1024*1024))
+	if (ASIC_IS_RN50(rdev) || rdev->mc.real_vram_size <= (16*1024*1024))
 		bpp_sel = 8;
 
 	rfbdev = kzalloc(sizeof(struct radeon_fbdev), GFP_KERNEL);
-- 
1.7.1

