Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaAFQt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:49:26 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64852 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbaAFQtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:49:24 -0500
Date: Mon, 6 Jan 2014 22:19:19 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>, Dave Airlie <airlied@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 83/85] drivers: gpu: Mark functions as static and remove
 unused function in vmwgfx_resource.c
Message-ID: <c978c014a4b7f62c875b2bb53f55cb288cc72cb9.1389018325.git.rashika.kheria@gmail.com>
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
drm/vmwgfx/vmwgfx_resource.c. Also, remove unused function
vmw_user_dmabuf_reference() from drm/vmwgfx/vmwgfx_resource.c.

This eliminates the following warnings in drm/vmwgfx/vmwgfx_resource.c:
drivers/gpu/drm/vmwgfx/vmwgfx_resource.c:252:22: warning: no previous prototype for ‘vmw_resource_lookup’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_resource.c:456:5: warning: no previous prototype for ‘vmw_user_dmabuf_alloc’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_resource.c:593:5: warning: no previous prototype for ‘vmw_user_dmabuf_reference’ [-Wmissing-prototypes]
drivers/gpu/drm/vmwgfx/vmwgfx_resource.c:1145:5: warning: no previous prototype for ‘vmw_resource_do_evict’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index 9b5ea2a..5fefc65 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -249,7 +249,7 @@ void vmw_resource_activate(struct vmw_resource *res,
 	write_unlock(&dev_priv->resource_lock);
 }
 
-struct vmw_resource *vmw_resource_lookup(struct vmw_private *dev_priv,
+static struct vmw_resource *vmw_resource_lookup(struct vmw_private *dev_priv,
 					 struct idr *idr, int id)
 {
 	struct vmw_resource *res;
@@ -453,7 +453,7 @@ static void vmw_user_dmabuf_release(struct ttm_base_object **p_base)
  * @p_dma_buf: Pointer to where the refcounted struct vmw_dma_buffer pointer
  * should be assigned.
  */
-int vmw_user_dmabuf_alloc(struct vmw_private *dev_priv,
+static int vmw_user_dmabuf_alloc(struct vmw_private *dev_priv,
 			  struct ttm_object_file *tfile,
 			  uint32_t size,
 			  bool shareable,
@@ -590,19 +590,6 @@ int vmw_user_dmabuf_lookup(struct ttm_object_file *tfile,
 	return 0;
 }
 
-int vmw_user_dmabuf_reference(struct ttm_object_file *tfile,
-			      struct vmw_dma_buffer *dma_buf)
-{
-	struct vmw_user_dma_buffer *user_bo;
-
-	if (dma_buf->base.destroy != vmw_user_dmabuf_destroy)
-		return -EINVAL;
-
-	user_bo = container_of(dma_buf, struct vmw_user_dma_buffer, dma);
-	return ttm_ref_object_add(tfile, &user_bo->prime.base,
-				  TTM_REF_USAGE, NULL);
-}
-
 /*
  * Stream management
  */
@@ -1142,7 +1129,7 @@ vmw_resource_backoff_reservation(struct ttm_validate_buffer *val_buf)
  * @res:            The resource to evict.
  * @interruptible:  Whether to wait interruptible.
  */
-int vmw_resource_do_evict(struct vmw_resource *res, bool interruptible)
+static int vmw_resource_do_evict(struct vmw_resource *res, bool interruptible)
 {
 	struct ttm_validate_buffer val_buf;
 	const struct vmw_res_func *func = res->func;
-- 
1.7.9.5

