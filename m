Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3IKE7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab3IKE5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:08 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=jk-gpCBcZ2IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jPhU8xnq6hgA:10 a=iox4zFpeAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=QN6lD7u48q-N2EPQO0YA:9 a=n9GBPR9yFnkA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042922.006025966@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michal Srb <msrb@suse.com>, Dave Airlie <airlied@redhat.com>
Subject: [179/251] drm/cirrus: Invalidate page tables when pinning a BO
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0179-drm-cirrus-Invalidate-page-tables-when-pinning-a-BO.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michal Srb <msrb@suse.com>

[ Upstream commit 109a51598869a39fdcec2d49672a9a39b6d89481 ]

This is a cirrus version of Egbert Eich's patch for mgag200.

Without bo.bdev->dev_mapping set, the ttm_bo_unmap_virtual_locked
called from ttm_bo_handle_move_mem returns with no effect. If any
application accessed the memory before it was moved, it will
access wrong memory next time. This causes crashes when changing
resolution down.

Signed-off-by: Michal Srb <msrb@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/cirrus/cirrus_ttm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/cirrus/cirrus_ttm.c b/drivers/gpu/drm/cirrus/cirrus_ttm.c
index d4b1b1d..d57bcc8 100644
--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -353,6 +353,7 @@ int cirrus_bo_create(struct drm_device *dev, int size, int align,
 
 	cirrusbo->gem.driver_private = NULL;
 	cirrusbo->bo.bdev = &cirrus->ttm.bdev;
+	cirrusbo->bo.bdev->dev_mapping = dev->dev_mapping;
 
 	cirrus_ttm_placement(cirrusbo, TTM_PL_FLAG_VRAM | TTM_PL_FLAG_SYSTEM);
 
-- 
1.7.10.4


