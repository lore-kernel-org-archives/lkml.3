Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaAFPgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:36:51 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:52333 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaAFPgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:36:49 -0500
Date: Mon, 6 Jan 2014 21:06:44 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jerome Glisse <jglisse@redhat.com>, dri-devel@lists.freedesktop.org,
        josh@joshtriplett.org
Subject: [PATCH 31/85] drivers: gpu: Add static keyword to the definition of
 KMS_INVALID_IOCTL in radeon_kms.c
Message-ID: <c1f386395d644e456ae1a2ea30e8b97531bc1380.1389018325.git.rashika.kheria@gmail.com>
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

Add static keyword to the definition of KMS_INVALID_IOCTL(name) in
radeon_kms.c because the functions passed to it as arguments are not
used anywhere else.

This eliminates the following warnings in drm/radeon/radeon_kms.c:
drivers/gpu/drm/radeon/radeon_kms.c:719:1: warning: no previous prototype for ‘radeon_cp_init_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:720:1: warning: no previous prototype for ‘radeon_cp_start_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:721:1: warning: no previous prototype for ‘radeon_cp_stop_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:722:1: warning: no previous prototype for ‘radeon_cp_reset_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:723:1: warning: no previous prototype for ‘radeon_cp_idle_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:724:1: warning: no previous prototype for ‘radeon_cp_resume_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:725:1: warning: no previous prototype for ‘radeon_engine_reset_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:726:1: warning: no previous prototype for ‘radeon_fullscreen_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:727:1: warning: no previous prototype for ‘radeon_cp_swap_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:728:1: warning: no previous rototype for ‘radeon_cp_clear_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:729:1: warning: no previous prototype for ‘radeon_cp_vertex_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:730:1: warning: no previous rototype for ‘radeon_cp_indices_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:731:1: warning: no previous prototype for ‘radeon_cp_texture_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:732:1: warning: no previous prototype for ‘radeon_cp_stipple_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:733:1: warning: no previous prototype for ‘radeon_cp_indirect_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:734:1: warning: no previous prototype for ‘radeon_cp_vertex2_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:735:1: warning: no previous prototype for ‘radeon_cp_cmdbuf_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:736:1: warning: no previous prototype for ‘radeon_cp_getparam_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:737:1: warning: no previous prototype for ‘radeon_cp_flip_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:738:1: warning: no previous prototype for ‘radeon_mem_alloc_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:739:1: warning: no previous prototype for ‘radeon_mem_free_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:740:1: warning: no previous rototype for ‘radeon_mem_init_heap_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:741:1: warning: no previous rototype for ‘radeon_irq_emit_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:742:1: warning: no previous prototype for ‘radeon_irq_wait_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:743:1: warning: no previous rototype for ‘radeon_cp_setparam_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:744:1: warning: no previous prototype for ‘radeon_surface_alloc_kms’ [-Wmissing-prototypes]
drivers/gpu/drm/radeon/radeon_kms.c:745:1: warning: no previous prototype for ‘radeon_surface_free_kms’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_kms.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 03cbb6b..4797b41 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -707,7 +707,8 @@ int radeon_get_vblank_timestamp_kms(struct drm_device *dev, int crtc,
 }
 
 #define KMS_INVALID_IOCTL(name)						\
-int name(struct drm_device *dev, void *data, struct drm_file *file_priv)\
+static int name(struct drm_device *dev, void *data, struct drm_file	\
+		*file_priv)						\
 {									\
 	DRM_ERROR("invalid ioctl with kms %s\n", __func__);		\
 	return -EINVAL;							\
-- 
1.7.9.5

