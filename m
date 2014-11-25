Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaKYKmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:42:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58603 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaKYKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 122/254] drm/vmwgfx: Fix drm.h include
Date: Tue, 25 Nov 2014 10:37:52 +0000
Message-Id: <1416912004-5928-123-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@fedoraproject.org>

commit e351943b081f4d9e6f692ce1a6117e8d2e71f478 upstream.

The userspace drm.h include doesn't prefix the drm directory.  This can lead
to compile failures as /usr/include/drm/ isn't in the standard gcc include
paths.  Fix it to be <drm/drm.h>, which matches the rest of the driver drm
header files that get installed into /usr/include/drm.

Red Hat Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1138759

Fixes: 1d7a5cbf8f74e
Reported-by: Jeffrey Bastian <jbastian@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/uapi/drm/vmwgfx_drm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/drm/vmwgfx_drm.h b/include/uapi/drm/vmwgfx_drm.h
index 4fc66f6b12ce..c472bedbe38e 100644
--- a/include/uapi/drm/vmwgfx_drm.h
+++ b/include/uapi/drm/vmwgfx_drm.h
@@ -29,7 +29,7 @@
 #define __VMWGFX_DRM_H__
 
 #ifndef __KERNEL__
-#include <drm.h>
+#include <drm/drm.h>
 #endif
 
 #define DRM_VMW_MAX_SURFACE_FACES 6
-- 
2.1.0

