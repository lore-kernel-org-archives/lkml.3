Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3LXJ4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 04:56:52 -0500
Received: from fep34.mx.upcmail.net ([62.179.121.52]:50651 "EHLO
	fep34.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3LXJ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 04:56:51 -0500
X-Greylist: delayed 943 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Dec 2013 04:56:51 EST
X-SourceIP: 213.47.25.108
Date: Tue, 24 Dec 2013 10:41:03 +0100
From: Martin Koegler <martin.koegler@chello.at>
To: airlied@redhat.com, linux-kernel@vger.kernel.org
Subject: Fix cirrus drm driver for qemu use
Message-ID: <20131224094103.GA9365@mail.zuhause>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On openSuSE, Xorg start fails, if modeset is enabled (https://bugzilla.novell.com/show_bug.cgi?id=856760).

This is caused by the fact, that the fbhwdev part in Xorg uses smem_start/len of the "fix" part, which is
not initialized by the the cirrus drm driver.

The attached patch fixes this problem. I can't spot such a initialisation in HEAD,
so I forward this patch.

Regards,
Martin

--G4iJoqBmSsgzjUCe
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Fix-cirrus-drm-driver-for-fbdev-qemu.patch"

>From 15952972eff90b19c4063b54d5f1e820987b4605 Mon Sep 17 00:00:00 2001
From: Martin Koegler <martin.koegler@chello.at>
Date: Sun, 22 Dec 2013 16:00:52 +0100
Subject: [PATCH] Fix cirrus drm driver for fbdev + qemu

---
 drivers/gpu/drm/cirrus/cirrus_fbdev.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index b27e956..e63a753 100644
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
1.7.10.4


--G4iJoqBmSsgzjUCe--
