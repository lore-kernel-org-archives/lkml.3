Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaKYLzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:55:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58204 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbaKYKkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Sven Joachim <svenjoac@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 048/254] drm/nouveau/kms: restore acceleration before fb_set_suspend() resumes
Date: Tue, 25 Nov 2014 10:36:38 +0000
Message-Id: <1416912004-5928-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 04384435fbcd2c5cb70b2e58c8b643822d7e337f upstream.

This *should* be safe these days.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 02dc2a1e1d28..2ef2842aacbf 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -550,13 +550,13 @@ nouveau_fbcon_set_suspend(struct drm_device *dev, int state)
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	if (drm->fbcon) {
 		console_lock();
-		if (state == 1)
-			nouveau_fbcon_accel_save_disable(dev);
-		fb_set_suspend(drm->fbcon->helper.fbdev, state);
 		if (state == 0) {
 			nouveau_fbcon_accel_restore(dev);
 			nouveau_fbcon_zfill(dev, drm->fbcon);
 		}
+		fb_set_suspend(drm->fbcon->helper.fbdev, state);
+		if (state == 1)
+			nouveau_fbcon_accel_save_disable(dev);
 		console_unlock();
 	}
 }
-- 
2.1.0

