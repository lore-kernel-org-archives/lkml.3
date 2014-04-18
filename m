Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaDRJn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:43:56 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45896 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Martin Koegler <martin.koegler@chello.at>,
        Takashi Iwai <tiwai@suse.de>, Dave Airlie <airlied@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 15/72] drm/cirrus: Fix cirrus drm driver for fbdev + qemu
Date: Fri, 18 Apr 2014 11:21:48 +0200
Message-Id: <929476d0b102eceaed62173ffb2acb6ac97e5796.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Koegler <martin.koegler@chello.at>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 99d4a8ae93ead27b5a88cdbd09dc556fe96ac3a8 upstream.

Xorg fbdev driver requires smem_start/smem_len, otherwise
it tries to map 0 bytes as video memory.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=856760
Signed-off-by: Martin Koegler <martin.koegler@chello.at>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/cirrus/cirrus_fbdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index 86d779a9c245..32bbba0a787b 100644
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
1.9.2

