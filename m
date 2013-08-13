Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab3HMGti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:49:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab3HMGde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Egbert Eich <eich@suse.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 40/60] drm/mgag200: Invalidate page tables when pinning a BO
Date: Mon, 12 Aug 2013 23:34:07 -0700
Message-Id: <20130813063337.543184197@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/mgag200/mgag200_ttm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -347,6 +347,7 @@ int mgag200_bo_create(struct drm_device
 
 	mgabo->gem.driver_private = NULL;
 	mgabo->bo.bdev = &mdev->ttm.bdev;
+	mgabo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	mgag200_ttm_placement(mgabo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 


