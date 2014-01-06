Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbaAFQlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:41:10 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60889 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785AbaAFQlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:41:09 -0500
Date: Mon, 6 Jan 2014 22:11:04 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 76/85] drivers: gpu: Move prototype declaration to header
 file radeon_drv.h from radeon_drv.c
Message-ID: <4218b28ed65d616abc33aaf6fcc2424a3b14b03b.1389018325.git.rashika.kheria@gmail.com>
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

Move prototype declaration of function radeon_kms_compat_ioctl() to
header file drm/radeon/radeon_drv.h because it is used by more than one
file.

This eliminates the following warning in
drivers/gpu/drm/radeon/radeon_ioc32.c:413:6: warning: no previous prototype for ‘radeon_kms_compat_ioctl’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/radeon/radeon_drv.c |    2 --
 drivers/gpu/drm/radeon/radeon_drv.h |    3 ++-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 9f5ff28..7868d4e 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -127,8 +127,6 @@ int radeon_gem_prime_pin(struct drm_gem_object *obj);
 void radeon_gem_prime_unpin(struct drm_gem_object *obj);
 void *radeon_gem_prime_vmap(struct drm_gem_object *obj);
 void radeon_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr);
-extern long radeon_kms_compat_ioctl(struct file *filp, unsigned int cmd,
-				    unsigned long arg);
 
 #if defined(CONFIG_DEBUG_FS)
 int radeon_debugfs_init(struct drm_minor *minor);
diff --git a/drivers/gpu/drm/radeon/radeon_drv.h b/drivers/gpu/drm/radeon/radeon_drv.h
index 00e0d44..7e1f2215 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.h
+++ b/drivers/gpu/drm/radeon/radeon_drv.h
@@ -425,7 +425,8 @@ extern int radeon_driver_open(struct drm_device *dev,
 			      struct drm_file *file_priv);
 extern long radeon_compat_ioctl(struct file *filp, unsigned int cmd,
 				unsigned long arg);
-
+extern long radeon_kms_compat_ioctl(struct file *filp, unsigned int cmd,
+				    unsigned long arg);
 extern int radeon_master_create(struct drm_device *dev, struct drm_master *master);
 extern void radeon_master_destroy(struct drm_device *dev, struct drm_master *master);
 extern void radeon_cp_dispatch_flip(struct drm_device *dev, struct drm_master *master);
-- 
1.7.9.5

