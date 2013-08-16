Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab3HPWk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:40:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51788 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3HPWkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Egbert Eich <eich@suse.com>, Dave Airlie <airlied@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 104/133] drm/mgag200: Invalidate page tables when pinning a BO
Date: Fri, 16 Aug 2013 15:34:06 -0700
Message-Id: <1376692475-28413-105-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Egbert Eich <eich@suse.com>

commit ecaac1c866bcda4780a963b3d18cd310d971aea3 upstream.

When a BO gets pinned the placement may get changed. If the memory is
mapped into user space and user space has already accessed the mapped
range the page tables are set up but now point to the wrong memory.
Set bo.mdev->dev_mapping in mgag200_bo_create() to make sure that
ttm_bo_unmap_virtual() called from ttm_bo_handle_move_mem() will take
care of this.

v2: Don't call ttm_bo_unmap_virtual() in mgag200_bo_pin(), fix comment.

Signed-off-by: Egbert Eich <eich@suse.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/mgag200/mgag200_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mgag200/mgag200_ttm.c b/drivers/gpu/drm/mgag200/mgag200_ttm.c
index 401c989..d2cb32f 100644
--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -347,6 +347,7 @@ int mgag200_bo_create(struct drm_device *dev, int size, int align,
 
 	mgabo->gem.driver_private = NULL;
 	mgabo->bo.bdev = &mdev->ttm.bdev;
+	mgabo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	mgag200_ttm_placement(mgabo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
-- 
1.8.1.2

