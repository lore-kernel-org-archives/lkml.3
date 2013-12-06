Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162453Ab3LFNqC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:46:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44169 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab3LFNCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 129/272] qxl: avoid an oops in the deferred io code.
Date: Fri,  6 Dec 2013 12:56:58 +0000
Message-Id: <1386334761-25517-130-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit cc87509d87696d7cd393882f5dedea01e03e41a9 upstream.

If we are using deferred io due to plymouth or X.org fbdev driver
we will oops in memcpy due to this pointless multiply here,

removing it fixes fbdev to start and not oops.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/qxl/qxl_fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/qxl/qxl_fb.c b/drivers/gpu/drm/qxl/qxl_fb.c
index 88722f2..f437b30 100644
--- a/drivers/gpu/drm/qxl/qxl_fb.c
+++ b/drivers/gpu/drm/qxl/qxl_fb.c
@@ -108,7 +108,7 @@ static void qxl_fb_dirty_flush(struct fb_info *info)
 	u32 x1, x2, y1, y2;
 
 	/* TODO: hard coding 32 bpp */
-	int stride = qfbdev->qfb.base.pitches[0] * 4;
+	int stride = qfbdev->qfb.base.pitches[0];
 
 	x1 = qfbdev->dirty.x1;
 	x2 = qfbdev->dirty.x2;
-- 
1.8.3.2

