Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaIERUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:20:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbaIERUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:20:06 -0400
Date: Fri, 5 Sep 2014 13:19:59 -0400
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Thomas Hellstrom <thellstrom@vmware.com>, Brian Paul <brianp@vmware.com>,
        David Airlie <airlied@linux.ie>
Cc: dmarlin@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/vmwgfx: Fix drm.h include
Message-ID: <20140905171959.GO5216@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace drm.h include doesn't prefix the drm directory.  This can lead
to compile failures as /usr/include/drm/ isn't in the standard gcc include
paths.  Fix it to be <drm/drm.h>, which matches the rest of the driver drm
header files that get installed into /usr/include/drm.

Red Hat Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1138759

Fixes: 1d7a5cbf8f74e
Reported-by: Jeffrey Bastian <jbastian@redhat.com>
Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
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
1.9.3
