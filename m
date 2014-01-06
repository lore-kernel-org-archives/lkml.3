Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaAFQoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:44:15 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57966 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbaAFQoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:44:13 -0500
Date: Mon, 6 Jan 2014 22:11:59 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 77/85] drivers: gpu: Mark function as static in sis_drv.c
Message-ID: <79a23a4793355037f0ea39189aa5ce29ca77a356.1389018325.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static because it is not used outside the file
drm/sis/sis_drv.c.

This eliminates the following warning in drm/sis/sis_drv.c:
drivers/gpu/drm/sis/sis_drv.c:97:6: warning: no previous prototype for ‘sis_driver_postclose’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/sis/sis_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sis/sis_drv.c b/drivers/gpu/drm/sis/sis_drv.c
index 4383b74..756f787 100644
--- a/drivers/gpu/drm/sis/sis_drv.c
+++ b/drivers/gpu/drm/sis/sis_drv.c
@@ -94,7 +94,7 @@ static int sis_driver_open(struct drm_device *dev, struct drm_file *file)
 	return 0;
 }
 
-void sis_driver_postclose(struct drm_device *dev, struct drm_file *file)
+static void sis_driver_postclose(struct drm_device *dev, struct drm_file *file)
 {
 	struct sis_file_private *file_priv = file->driver_priv;
 
-- 
1.7.9.5

