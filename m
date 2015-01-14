Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbbANHcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:32:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbbANHb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:31:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.18 143/150] nouveau: bring back legacy mmap handler
Date: Tue, 13 Jan 2015 23:23:34 -0800
Message-Id: <20150114072102.321620758@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 2036eaa74031b11028ee8fc1f44f128fdc871dda upstream.

nouveau userspace back at 1.0.1 used to call the X server
DRIOpenDRMMaster interface even for DRI2 (doh!), this attempts
to map the sarea and fails if it can't.

Since 884c6dabb0eafe7227f099c9e78e514191efaf13 from Daniel,
this fails, but only ancient drivers would see it.

Revert the nouveau bits of that fix.

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_ttm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -28,6 +28,7 @@
 #include "nouveau_ttm.h"
 #include "nouveau_gem.h"
 
+#include "drm_legacy.h"
 static int
 nouveau_vram_manager_init(struct ttm_mem_type_manager *man, unsigned long psize)
 {
@@ -281,7 +282,7 @@ nouveau_ttm_mmap(struct file *filp, stru
 	struct nouveau_drm *drm = nouveau_drm(file_priv->minor->dev);
 
 	if (unlikely(vma->vm_pgoff < DRM_FILE_PAGE_OFFSET))
-		return -EINVAL;
+		return drm_legacy_mmap(filp, vma);
 
 	return ttm_bo_mmap(filp, vma, &drm->ttm.bdev);
 }


