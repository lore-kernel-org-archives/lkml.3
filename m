Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbaAFQsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:48:19 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51565 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbaAFQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:48:16 -0500
Date: Mon, 6 Jan 2014 22:18:10 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Rob Clark <rob@ti.com>, Jakob Bornecrantz <jakob@vmware.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 82/85] drivers: gpu: Mark functions as static in vmwgfx_kms.c
Message-ID: <477dcfde0b9247c91030dedcbf71af7dafdb7bf4.1389018325.git.rashika.kheria@gmail.com>
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
drm/vmwgfx/vmwgfx_kms.c.

This eliminates the following warnings in drm/vmwgfx/vmwgfx_kms.c:
drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:43:6: warning: no previous prototype for ‘vmw_clip_cliprects’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:426:6: warning: no previous prototype for ‘vmw_framebuffer_surface_destroy’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:592:5: warning: no previous prototype for ‘vmw_framebuffer_surface_dirty’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:757:6: warning: no previous prototype for ‘vmw_framebuffer_dmabuf_destroy’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:943:5: warning: no previous prototype for ‘vmw_framebuffer_dmabuf_dirty’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_kms.c:1666:5: warning: no previous prototype for ‘vmw_du_update_layout’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 03f1c20..6af4816 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -40,7 +40,7 @@ struct vmw_clip_rect {
  * Clip @num_rects number of @rects against @clip storing the
  * results in @out_rects and the number of passed rects in @out_num.
  */
-void vmw_clip_cliprects(struct drm_clip_rect *rects,
+static void vmw_clip_cliprects(struct drm_clip_rect *rects,
 			int num_rects,
 			struct vmw_clip_rect clip,
 			SVGASignedRect *out_rects,
@@ -423,7 +423,7 @@ struct vmw_framebuffer_surface {
 	struct drm_master *master;
 };
 
-void vmw_framebuffer_surface_destroy(struct drm_framebuffer *framebuffer)
+static void vmw_framebuffer_surface_destroy(struct drm_framebuffer *framebuffer)
 {
 	struct vmw_framebuffer_surface *vfbs =
 		vmw_framebuffer_to_vfbs(framebuffer);
@@ -589,7 +589,7 @@ out_free_tmp:
 	return ret;
 }
 
-int vmw_framebuffer_surface_dirty(struct drm_framebuffer *framebuffer,
+static int vmw_framebuffer_surface_dirty(struct drm_framebuffer *framebuffer,
 				  struct drm_file *file_priv,
 				  unsigned flags, unsigned color,
 				  struct drm_clip_rect *clips,
@@ -754,7 +754,7 @@ struct vmw_framebuffer_dmabuf {
 	struct vmw_dma_buffer *buffer;
 };
 
-void vmw_framebuffer_dmabuf_destroy(struct drm_framebuffer *framebuffer)
+static void vmw_framebuffer_dmabuf_destroy(struct drm_framebuffer *framebuffer)
 {
 	struct vmw_framebuffer_dmabuf *vfbd =
 		vmw_framebuffer_to_vfbd(framebuffer);
@@ -940,7 +940,7 @@ static int do_dmabuf_dirty_sou(struct drm_file *file_priv,
 	return ret;
 }
 
-int vmw_framebuffer_dmabuf_dirty(struct drm_framebuffer *framebuffer,
+static int vmw_framebuffer_dmabuf_dirty(struct drm_framebuffer *framebuffer,
 				 struct drm_file *file_priv,
 				 unsigned flags, unsigned color,
 				 struct drm_clip_rect *clips,
@@ -1663,7 +1663,7 @@ void vmw_disable_vblank(struct drm_device *dev, int crtc)
  * Small shared kms functions.
  */
 
-int vmw_du_update_layout(struct vmw_private *dev_priv, unsigned num,
+static int vmw_du_update_layout(struct vmw_private *dev_priv, unsigned num,
 			 struct drm_vmw_rect *rects)
 {
 	struct drm_device *dev = dev_priv->dev;
-- 
1.7.9.5

