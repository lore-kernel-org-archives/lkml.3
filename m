Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbaAFPXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:23:13 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:49206 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaAFPXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:23:12 -0500
Date: Mon, 6 Jan 2014 20:53:07 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jerome Glisse <jglisse@redhat.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 23/85] drivers: gpu: Mark function as static in radeon_kms.c
Message-ID: <0acf5b7232d8ca7d63ba9889e23bc2ad630b84c5.1389018325.git.rashika.kheria@gmail.com>
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

Mark function radeon_info_ioctl() as static in drm/radeon/radeon_kms.c
because it is not used outside this file.

This eliminates the following warning in drm/radeon/radeon_kms.c:
drivers/gpu/drm/radeon/radeon_kms.c:194:5: warning: no previous prototype for ‘radeon_info_ioctl’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_kms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 55d0b47..03cbb6b 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -191,7 +191,7 @@ static void radeon_set_filp_rights(struct drm_device *dev,
  * etc. (all asics).
  * Returns 0 on success, -EINVAL on failure.
  */
-int radeon_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
+static int radeon_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 {
 	struct radeon_device *rdev = dev->dev_private;
 	struct drm_radeon_info *info = data;
-- 
1.7.9.5

