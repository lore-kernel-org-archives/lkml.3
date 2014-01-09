Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaAIJFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:05:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbaAIJFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:05:08 -0500
From: Takashi Iwai <tiwai@suse.de>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Martin Koegler <martin.koegler@chello.at>
Subject: [PATCH] drm/cirrus: Fix cirrus drm driver for fbdev + qemu
Date: Thu,  9 Jan 2014 10:05:07 +0100
Message-Id: <1389258307-27839-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Koegler <martin.koegler@chello.at>

Xorg fbdev driver requires smem_start/smem_len, otherwise
it tries to map 0 bytes as video memory.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=856760
Signed-off-by: Martin Koegler <martin.koegler@chello.at>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/gpu/drm/cirrus/cirrus_fbdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index b27e95666fab..e63a7533f849 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -233,6 +233,9 @@ static int cirrusfb_create(struct drm_fb_helper *helper,
 	info->apertures->ranges[0].base = cdev->dev->mode_config.fb_base;
 	info->apertures->ranges[0].size = cdev->mc.vram_size;
 
+	info->fix.smem_start = cdev->dev->mode_config.fb_base;
+	info->fix.smem_len = cdev->mc.vram_size;
+
 	info->screen_base = sysram;
 	info->screen_size = size;
 
-- 
1.8.5.2

