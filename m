Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab3GYRfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:35:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab3GYRff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:35:35 -0400
Date: Thu, 25 Jul 2013 13:35:26 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: bskeggs@redhat.com
Subject: nouveau: remove pointless assignment.
Message-ID: <20130725173526.GA855@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, bskeggs@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assigning a pointer to itself and then overwriting it seems unnecessary.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 4e7ee5f..9b2c939 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -977,7 +977,7 @@ nouveau_bo_move_m2mf(struct ttm_buffer_object *bo, int evict, bool intr,
 		     bool no_wait_gpu, struct ttm_mem_reg *new_mem)
 {
 	struct nouveau_drm *drm = nouveau_bdev(bo->bdev);
-	struct nouveau_channel *chan = chan = drm->ttm.chan;
+	struct nouveau_channel *chan = drm->ttm.chan;
 	struct nouveau_bo *nvbo = nouveau_bo(bo);
 	struct ttm_mem_reg *old_mem = &bo->mem;
 	int ret;
