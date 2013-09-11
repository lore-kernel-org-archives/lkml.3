Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3IKE7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab3IKE5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:08 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0UZ1q6JFeJQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QooKz9Q_xsUA:10 a=iox4zFpeAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=J_abgXCv8mw5qMUjYRgA:9 a=n9GBPR9yFnkA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042922.159696695@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Egbert Eich <eich@suse.com>, Dave Airlie <airlied@redhat.com>
Subject: [180/251] drm/mgag200: Invalidate page tables when pinning a BO
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0180-drm-mgag200-Invalidate-page-tables-when-pinning-a-BO.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Egbert Eich <eich@suse.com>

[ Upstream commit ecaac1c866bcda4780a963b3d18cd310d971aea3 ]

When a BO gets pinned the placement may get changed. If the memory is
mapped into user space and user space has already accessed the mapped
range the page tables are set up but now point to the wrong memory.
Set bo.mdev->dev_mapping in mgag200_bo_create() to make sure that
ttm_bo_unmap_virtual() called from ttm_bo_handle_move_mem() will take
care of this.

v2: Don't call ttm_bo_unmap_virtual() in mgag200_bo_pin(), fix comment.

Signed-off-by: Egbert Eich <eich@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/mgag200/mgag200_ttm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mgag200/mgag200_ttm.c b/drivers/gpu/drm/mgag200/mgag200_ttm.c
index a707394..95b5377 100644
--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -347,6 +347,7 @@ int mgag200_bo_create(struct drm_device *dev, int size, int align,
 
 	mgabo->gem.driver_private = NULL;
 	mgabo->bo.bdev = &mdev->ttm.bdev;
+	mgabo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	mgag200_ttm_placement(mgabo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
-- 
1.7.10.4


