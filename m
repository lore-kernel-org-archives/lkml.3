Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab3HPWkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:40:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51745 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3HPWkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Srb <msrb@suse.com>, Dave Airlie <airlied@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 103/133] drm/cirrus: Invalidate page tables when pinning a BO
Date: Fri, 16 Aug 2013 15:34:05 -0700
Message-Id: <1376692475-28413-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Srb <msrb@suse.com>

commit 109a51598869a39fdcec2d49672a9a39b6d89481 upstream.

This is a cirrus version of Egbert Eich's patch for mgag200.

Without bo.bdev->dev_mapping set, the ttm_bo_unmap_virtual_locked
called from ttm_bo_handle_move_mem returns with no effect. If any
application accessed the memory before it was moved, it will
access wrong memory next time. This causes crashes when changing
resolution down.

Signed-off-by: Michal Srb <msrb@suse.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/cirrus/cirrus_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/cirrus/cirrus_ttm.c b/drivers/gpu/drm/cirrus/cirrus_ttm.c
index 2ed8cfc..c18faff 100644
--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -353,6 +353,7 @@ int cirrus_bo_create(struct drm_device *dev, int size, int align,
 
 	cirrusbo->gem.driver_private = NULL;
 	cirrusbo->bo.bdev = &cirrus->ttm.bdev;
+	cirrusbo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	cirrus_ttm_placement(cirrusbo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
-- 
1.8.1.2

