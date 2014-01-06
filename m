Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbaAFQod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:44:33 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:57994 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaAFQoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:44:32 -0500
Date: Mon, 6 Jan 2014 22:14:27 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jerome Glisse <jglisse@redhat.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 79/85] drivers: gpu: Mark function as static in ttm_bo_util.c
Message-ID: <31a06dc0572521216e5362e752603727f26dd9e5.1389018325.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static because they are not used outside the file
drm/ttm/ttm_bo_util.c.

This eliminates the following warnings in drm/ttm/ttm_bo_util.c:
drivers/gpu/drm/ttm/ttm_bo_util.c:190:5: warning: no previous prototype for ‘ttm_mem_reg_ioremap’ [-Wmissing-prototypes]
drivers/gpu/drm/ttm/ttm_bo_util.c:222:6: warning: no previous prototype for ‘ttm_mem_reg_iounmap’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 15b86a9..9bee27c 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -187,7 +187,7 @@ void ttm_mem_io_free_vm(struct ttm_buffer_object *bo)
 	}
 }
 
-int ttm_mem_reg_ioremap(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem,
+static int ttm_mem_reg_ioremap(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem,
 			void **virtual)
 {
 	struct ttm_mem_type_manager *man = &bdev->man[mem->mem_type];
@@ -219,7 +219,7 @@ int ttm_mem_reg_ioremap(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem,
 	return 0;
 }
 
-void ttm_mem_reg_iounmap(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem,
+static void ttm_mem_reg_iounmap(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem,
 			 void *virtual)
 {
 	struct ttm_mem_type_manager *man;
-- 
1.7.9.5

