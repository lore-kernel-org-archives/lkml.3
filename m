Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab3HMGuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:50:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab3HMGda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Srb <msrb@suse.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 39/60] drm/cirrus: Invalidate page tables when pinning a BO
Date: Mon, 12 Aug 2013 23:34:06 -0700
Message-Id: <20130813063337.463966880@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/cirrus/cirrus_ttm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -353,6 +353,7 @@ int cirrus_bo_create(struct drm_device *
 
 	cirrusbo->gem.driver_private = NULL;
 	cirrusbo->bo.bdev = &cirrus->ttm.bdev;
+	cirrusbo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	cirrus_ttm_placement(cirrusbo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 


