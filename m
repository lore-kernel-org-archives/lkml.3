Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaGGSuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:50:12 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:43086 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbaGGSuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:50:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmQNAPbqulNXQCU9/2dsb2JhbABZgw6segUBAQEBAQEFAW4BkiiHRYEbF3WECwIkLyOBCRE3iEYByUUXhXCJMh2ELQWYCoJsi0yIQINFOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Alex Deucher <alexander.deucher@amd.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 1/1] drm: replace ALIGN(PAGE_SIZE) by PAGE_ALIGN
Date: Mon,  7 Jul 2014 20:48:48 +0200
Message-Id: <1404758928-10936-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/gpu/drm/radeon/radeon_fb.c     | 2 +-
 drivers/gpu/drm/radeon/radeon_gem.c    | 2 +-
 drivers/gpu/drm/radeon/radeon_object.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index 665ced3..9f82605 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -124,7 +124,7 @@ static int radeonfb_create_pinned_object(struct radeon_fbdev *rfbdev,
 	if (rdev->family >= CHIP_R600)
 		height = ALIGN(mode_cmd->height, 8);
 	size = mode_cmd->pitches[0] * height;
-	aligned_size = ALIGN(size, PAGE_SIZE);
+	aligned_size = PAGE_ALIGN(size);
 	ret = radeon_gem_object_create(rdev, aligned_size, 0,
 				       RADEON_GEM_DOMAIN_VRAM,
 				       false, true,
diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index d09650c..ae14fa4 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -569,7 +569,7 @@ int radeon_mode_dumb_create(struct drm_file *file_priv,
 
 	args->pitch = radeon_align_pitch(rdev, args->width, args->bpp, 0) * ((args->bpp + 1) / 8);
 	args->size = args->pitch * args->height;
-	args->size = ALIGN(args->size, PAGE_SIZE);
+	args->size = PAGE_ALIGN(args->size);
 
 	r = radeon_gem_object_create(rdev, args->size, 0,
 				     RADEON_GEM_DOMAIN_VRAM,
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 6c717b2..80cb77e 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -154,7 +154,7 @@ int radeon_bo_create(struct radeon_device *rdev,
 	size_t acc_size;
 	int r;
 
-	size = ALIGN(size, PAGE_SIZE);
+	size = PAGE_ALIGN(size);
 
 	if (kernel) {
 		type = ttm_bo_type_kernel;
-- 
1.8.4.5

