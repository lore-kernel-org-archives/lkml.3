Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbaAFQnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:43:04 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:58611 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbaAFQnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:43:03 -0500
Date: Mon, 6 Jan 2014 22:12:58 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 78/85] drivers: gpu: Mark function as static in ttm_bo.c
Message-ID: <8e6973505071300c3d011272d5498597fd24a387.1389018325.git.rashika.kheria@gmail.com>
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

Mark function as static because it is not used outside file
drm/ttm/ttm_bo.c.

This eliminates the following warning in drm/ttm/ttm_bo.c:
drivers/gpu/drm/ttm/ttm_bo.c:960:5: warning: no previous prototype for ‘ttm_bo_move_buffer’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 07e02c4..a066513 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -957,7 +957,7 @@ int ttm_bo_mem_space(struct ttm_buffer_object *bo,
 }
 EXPORT_SYMBOL(ttm_bo_mem_space);
 
-int ttm_bo_move_buffer(struct ttm_buffer_object *bo,
+static int ttm_bo_move_buffer(struct ttm_buffer_object *bo,
 			struct ttm_placement *placement,
 			bool interruptible,
 			bool no_wait_gpu)
-- 
1.7.9.5

