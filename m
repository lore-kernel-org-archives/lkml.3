Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaAOREH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:04:07 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:37305 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaAORD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:03:58 -0500
X-AuditID: cbfec372-b7fa96d000006a7b-19-52d6bf7cb212
Date: Wed, 15 Jan 2014 15:03:49 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        ccross@google.com, linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        dri-devel@lists.freedesktop.org, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/7] dma-buf: use reservation objects
Message-id: <20140115150349.42656fe4@samsung.com>
In-reply-to: <20140113123206.20574.68235.stgit@patser>
References: <20140113122818.20574.34710.stgit@patser>
 <20140113123206.20574.68235.stgit@patser>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/hEN2a/deCDL6ssbFYMKOd2eL/tonM
	Fle+vmez+HLlIZNFx66vLBaXd81hs+jZsJXV4unTC2wWzxf+YLY4dfczuwOXx6yGXjaPvd8W
	sHjsnHWX3WPBplKPO9f2sHnc7z7O5HH732Nmj8+b5AI4orhsUlJzMstSi/TtErgybp76zlzw
	Iq9i4p2NzA2MN6O7GDk5JARMJB7PO8cKYYtJXLi3ng3EFhJYwijx/E95FyMXkN3NJHFt/jGw
	IhYBVYlrq08zg9hsAkYSrxpbwOIiAuYSnUceMYI0MAt8YpTY9eMnWEJYwFLi6JZpTCA2r4Ch
	RM/cPWBxTgEziVcr7zNBbEuUuHJwLnsXIwfQFU4Suw9IQZQLSvyYfI8FxGYW0JLYvK2JFcKW
	l9i85i3zBEaBWUjKZiEpm4WkbAEj8ypG0dLi5ILipPRcQ73ixNzi0rx0veT83E2MkPgo2sH4
	bIPVIUYBDkYlHt4f4VeDhFgTy4orcw8xSnAwK4nwNm++FiTEm5JYWZValB9fVJqTWnyIkYmD
	U6qB0cbx0MarprxfpkSZeQQ5pn4//dh5knhWR2lxnNoRrzCzhh/b11h3PnJr55r17GA65+f3
	WVHHTzx49SJZ5R7rGz/VZUIL/P5+2vki3v94S5/K3pRpbUviRJMMUnn0LAPvLgj1fTh5lpa+
	77Gdvo5W4tenxV3KuTGrf0bVyv8pUk1Rj1ufWfW2KLEUZyQaajEXFScCAOSUX+VtAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 13 Jan 2014 13:32:16 +0100
Maarten Lankhorst <maarten.lankhorst@canonical.com> escreveu:

> This allows reservation objects to be used in dma-buf. it's required
> for implementing polling support on the fences that belong to a dma-buf.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> ---
>  drivers/base/dma-buf.c                         |   22 ++++++++++++++++++++--
>  drivers/gpu/drm/drm_prime.c                    |    8 +++++++-
>  drivers/gpu/drm/exynos/exynos_drm_dmabuf.c     |    2 +-
>  drivers/gpu/drm/i915/i915_gem_dmabuf.c         |    2 +-
>  drivers/gpu/drm/nouveau/nouveau_drm.c          |    1 +
>  drivers/gpu/drm/nouveau/nouveau_gem.h          |    1 +
>  drivers/gpu/drm/nouveau/nouveau_prime.c        |    7 +++++++
>  drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c      |    2 +-
>  drivers/gpu/drm/radeon/radeon_drv.c            |    2 ++
>  drivers/gpu/drm/radeon/radeon_prime.c          |    8 ++++++++
>  drivers/gpu/drm/ttm/ttm_object.c               |    2 +-

>  drivers/media/v4l2-core/videobuf2-dma-contig.c |    2 +-

With regards to this small change on VB2-dma-contig:
Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>


>  include/drm/drmP.h                             |    2 ++
>  include/linux/dma-buf.h                        |    9 ++++++---
>  14 files changed, 59 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index 1e16cbd61da2..85e792c2c909 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -25,10 +25,12 @@
>  #include <linux/fs.h>
>  #include <linux/slab.h>
>  #include <linux/dma-buf.h>
> +#include <linux/fence.h>
>  #include <linux/anon_inodes.h>
>  #include <linux/export.h>
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
> +#include <linux/reservation.h>
>  
>  static inline int is_dma_buf_file(struct file *);
>  
> @@ -56,6 +58,9 @@ static int dma_buf_release(struct inode *inode, struct file *file)
>  	list_del(&dmabuf->list_node);
>  	mutex_unlock(&db_list.lock);
>  
> +	if (dmabuf->resv == (struct reservation_object*)&dmabuf[1])
> +		reservation_object_fini(dmabuf->resv);
> +
>  	kfree(dmabuf);
>  	return 0;
>  }
> @@ -128,6 +133,7 @@ static inline int is_dma_buf_file(struct file *file)
>   * @size:	[in]	Size of the buffer
>   * @flags:	[in]	mode flags for the file.
>   * @exp_name:	[in]	name of the exporting module - useful for debugging.
> + * @resv:	[in]	reservation-object, NULL to allocate default one.
>   *
>   * Returns, on success, a newly created dma_buf object, which wraps the
>   * supplied private data and operations for dma_buf_ops. On either missing
> @@ -135,10 +141,17 @@ static inline int is_dma_buf_file(struct file *file)
>   *
>   */
>  struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
> -				size_t size, int flags, const char *exp_name)
> +				size_t size, int flags, const char *exp_name,
> +				struct reservation_object *resv)
>  {
>  	struct dma_buf *dmabuf;
>  	struct file *file;
> +	size_t alloc_size = sizeof(struct dma_buf);
> +	if (!resv)
> +		alloc_size += sizeof(struct reservation_object);
> +	else
> +		/* prevent &dma_buf[1] == dma_buf->resv */
> +		alloc_size += 1;
>  
>  	if (WARN_ON(!priv || !ops
>  			  || !ops->map_dma_buf
> @@ -150,7 +163,7 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
>  		return ERR_PTR(-EINVAL);
>  	}
>  
> -	dmabuf = kzalloc(sizeof(struct dma_buf), GFP_KERNEL);
> +	dmabuf = kzalloc(alloc_size, GFP_KERNEL);
>  	if (dmabuf == NULL)
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -158,6 +171,11 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
>  	dmabuf->ops = ops;
>  	dmabuf->size = size;
>  	dmabuf->exp_name = exp_name;
> +	if (!resv) {
> +		resv = (struct reservation_object*)&dmabuf[1];
> +		reservation_object_init(resv);
> +	}
> +	dmabuf->resv = resv;
>  
>  	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf, flags);
>  	if (IS_ERR(file)) {
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index 56805c39c906..a13e90245adf 100644
> --- a/drivers/gpu/drm/drm_prime.c
> +++ b/drivers/gpu/drm/drm_prime.c
> @@ -318,7 +318,13 @@ static const struct dma_buf_ops drm_gem_prime_dmabuf_ops =  {
>  struct dma_buf *drm_gem_prime_export(struct drm_device *dev,
>  				     struct drm_gem_object *obj, int flags)
>  {
> -	return dma_buf_export(obj, &drm_gem_prime_dmabuf_ops, obj->size, flags);
> +	struct reservation_object *robj = NULL;
> +
> +	if (dev->driver->gem_prime_res_obj)
> +		robj = dev->driver->gem_prime_res_obj(obj);
> +
> +	return dma_buf_export(obj, &drm_gem_prime_dmabuf_ops, obj->size,
> +			      flags, robj);
>  }
>  EXPORT_SYMBOL(drm_gem_prime_export);
>  
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
> index 59827cc5e770..b5e89f46326e 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
> @@ -187,7 +187,7 @@ struct dma_buf *exynos_dmabuf_prime_export(struct drm_device *drm_dev,
>  	struct exynos_drm_gem_obj *exynos_gem_obj = to_exynos_gem_obj(obj);
>  
>  	return dma_buf_export(obj, &exynos_dmabuf_ops,
> -				exynos_gem_obj->base.size, flags);
> +				exynos_gem_obj->base.size, flags, NULL);
>  }
>  
>  struct drm_gem_object *exynos_dmabuf_prime_import(struct drm_device *drm_dev,
> diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> index 9bb533e0d762..ea66f40e95b3 100644
> --- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> +++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> @@ -233,7 +233,7 @@ static const struct dma_buf_ops i915_dmabuf_ops =  {
>  struct dma_buf *i915_gem_prime_export(struct drm_device *dev,
>  				      struct drm_gem_object *gem_obj, int flags)
>  {
> -	return dma_buf_export(gem_obj, &i915_dmabuf_ops, gem_obj->size, flags);
> +	return dma_buf_export(gem_obj, &i915_dmabuf_ops, gem_obj->size, flags, NULL);
>  }
>  
>  static int i915_gem_object_get_pages_dmabuf(struct drm_i915_gem_object *obj)
> diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
> index 98a22e6e27a1..c7cff8163882 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_drm.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
> @@ -808,6 +808,7 @@ driver = {
>  	.gem_prime_export = drm_gem_prime_export,
>  	.gem_prime_import = drm_gem_prime_import,
>  	.gem_prime_pin = nouveau_gem_prime_pin,
> +	.gem_prime_res_obj = nouveau_gem_prime_res_obj,
>  	.gem_prime_unpin = nouveau_gem_prime_unpin,
>  	.gem_prime_get_sg_table = nouveau_gem_prime_get_sg_table,
>  	.gem_prime_import_sg_table = nouveau_gem_prime_import_sg_table,
> diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.h b/drivers/gpu/drm/nouveau/nouveau_gem.h
> index 7caca057bc38..ddab762d81fe 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_gem.h
> +++ b/drivers/gpu/drm/nouveau/nouveau_gem.h
> @@ -35,6 +35,7 @@ extern int nouveau_gem_ioctl_info(struct drm_device *, void *,
>  				  struct drm_file *);
>  
>  extern int nouveau_gem_prime_pin(struct drm_gem_object *);
> +struct reservation_object *nouveau_gem_prime_res_obj(struct drm_gem_object *);
>  extern void nouveau_gem_prime_unpin(struct drm_gem_object *);
>  extern struct sg_table *nouveau_gem_prime_get_sg_table(struct drm_gem_object *);
>  extern struct drm_gem_object *nouveau_gem_prime_import_sg_table(
> diff --git a/drivers/gpu/drm/nouveau/nouveau_prime.c b/drivers/gpu/drm/nouveau/nouveau_prime.c
> index 51a2cb102b44..1f51008e4d26 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_prime.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
> @@ -102,3 +102,10 @@ void nouveau_gem_prime_unpin(struct drm_gem_object *obj)
>  
>  	nouveau_bo_unpin(nvbo);
>  }
> +
> +struct reservation_object *nouveau_gem_prime_res_obj(struct drm_gem_object *obj)
> +{
> +	struct nouveau_bo *nvbo = nouveau_gem_object(obj);
> +
> +	return nvbo->bo.resv;
> +}
> diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> index 4fcca8d42796..a2dbfb1737b4 100644
> --- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> +++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
> @@ -171,7 +171,7 @@ static struct dma_buf_ops omap_dmabuf_ops = {
>  struct dma_buf *omap_gem_prime_export(struct drm_device *dev,
>  		struct drm_gem_object *obj, int flags)
>  {
> -	return dma_buf_export(obj, &omap_dmabuf_ops, obj->size, flags);
> +	return dma_buf_export(obj, &omap_dmabuf_ops, obj->size, flags, NULL);
>  }
>  
>  struct drm_gem_object *omap_gem_prime_import(struct drm_device *dev,
> diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
> index db39ea36bf22..1ee9c9697be8 100644
> --- a/drivers/gpu/drm/radeon/radeon_drv.c
> +++ b/drivers/gpu/drm/radeon/radeon_drv.c
> @@ -126,6 +126,7 @@ struct drm_gem_object *radeon_gem_prime_import_sg_table(struct drm_device *dev,
>  							struct sg_table *sg);
>  int radeon_gem_prime_pin(struct drm_gem_object *obj);
>  void radeon_gem_prime_unpin(struct drm_gem_object *obj);
> +struct reservation_object *radeon_gem_prime_res_obj(struct drm_gem_object *);
>  void *radeon_gem_prime_vmap(struct drm_gem_object *obj);
>  void radeon_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr);
>  extern long radeon_kms_compat_ioctl(struct file *filp, unsigned int cmd,
> @@ -549,6 +550,7 @@ static struct drm_driver kms_driver = {
>  	.gem_prime_import = drm_gem_prime_import,
>  	.gem_prime_pin = radeon_gem_prime_pin,
>  	.gem_prime_unpin = radeon_gem_prime_unpin,
> +	.gem_prime_res_obj = radeon_gem_prime_res_obj,
>  	.gem_prime_get_sg_table = radeon_gem_prime_get_sg_table,
>  	.gem_prime_import_sg_table = radeon_gem_prime_import_sg_table,
>  	.gem_prime_vmap = radeon_gem_prime_vmap,
> diff --git a/drivers/gpu/drm/radeon/radeon_prime.c b/drivers/gpu/drm/radeon/radeon_prime.c
> index 20074560fc25..28d71070c389 100644
> --- a/drivers/gpu/drm/radeon/radeon_prime.c
> +++ b/drivers/gpu/drm/radeon/radeon_prime.c
> @@ -103,3 +103,11 @@ void radeon_gem_prime_unpin(struct drm_gem_object *obj)
>  	radeon_bo_unpin(bo);
>  	radeon_bo_unreserve(bo);
>  }
> +
> +
> +struct reservation_object *radeon_gem_prime_res_obj(struct drm_gem_object *obj)
> +{
> +	struct radeon_bo *bo = gem_to_radeon_bo(obj);
> +
> +	return bo->tbo.resv;
> +}
> diff --git a/drivers/gpu/drm/ttm/ttm_object.c b/drivers/gpu/drm/ttm/ttm_object.c
> index 6fe7b92a82d1..411bbe4617d9 100644
> --- a/drivers/gpu/drm/ttm/ttm_object.c
> +++ b/drivers/gpu/drm/ttm/ttm_object.c
> @@ -631,7 +631,7 @@ int ttm_prime_handle_to_fd(struct ttm_object_file *tfile,
>  		}
>  
>  		dma_buf = dma_buf_export(prime, &tdev->ops,
> -					 prime->size, flags);
> +					 prime->size, flags, NULL);
>  		if (IS_ERR(dma_buf)) {
>  			ret = PTR_ERR(dma_buf);
>  			ttm_mem_global_free(tdev->mem_glob,
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index 33d3871d1e13..93bd2230ab0b 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -404,7 +404,7 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
>  	if (WARN_ON(!buf->sgt_base))
>  		return NULL;
>  
> -	dbuf = dma_buf_export(buf, &vb2_dc_dmabuf_ops, buf->size, flags);
> +	dbuf = dma_buf_export(buf, &vb2_dc_dmabuf_ops, buf->size, flags, NULL);
>  	if (IS_ERR(dbuf))
>  		return NULL;
>  
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index 1d4a920ef7ff..1725225eb6ab 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -81,6 +81,7 @@ struct drm_device;
>  
>  struct device_node;
>  struct videomode;
> +struct reservation_object;
>  
>  #include <drm/drm_os_linux.h>
>  #include <drm/drm_hashtab.h>
> @@ -950,6 +951,7 @@ struct drm_driver {
>  	/* low-level interface used by drm_gem_prime_{import,export} */
>  	int (*gem_prime_pin)(struct drm_gem_object *obj);
>  	void (*gem_prime_unpin)(struct drm_gem_object *obj);
> +	struct reservation_object *(*gem_prime_res_obj)(struct drm_gem_object *);
>  	struct sg_table *(*gem_prime_get_sg_table)(struct drm_gem_object *obj);
>  	struct drm_gem_object *(*gem_prime_import_sg_table)(
>  				struct drm_device *dev, size_t size,
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index dfac5ed31120..34cfbac52c03 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -115,6 +115,7 @@ struct dma_buf_ops {
>   * @exp_name: name of the exporter; useful for debugging.
>   * @list_node: node for dma_buf accounting and debugging.
>   * @priv: exporter specific private data for this buffer object.
> + * @resv: reservation object linked to this dma-buf
>   */
>  struct dma_buf {
>  	size_t size;
> @@ -128,6 +129,7 @@ struct dma_buf {
>  	const char *exp_name;
>  	struct list_head list_node;
>  	void *priv;
> +	struct reservation_object *resv;
>  };
>  
>  /**
> @@ -168,10 +170,11 @@ void dma_buf_detach(struct dma_buf *dmabuf,
>  				struct dma_buf_attachment *dmabuf_attach);
>  
>  struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
> -			       size_t size, int flags, const char *);
> +			       size_t size, int flags, const char *,
> +			       struct reservation_object *);
>  
> -#define dma_buf_export(priv, ops, size, flags)	\
> -	dma_buf_export_named(priv, ops, size, flags, __FILE__)
> +#define dma_buf_export(priv, ops, size, flags, resv)	\
> +	dma_buf_export_named(priv, ops, size, flags, __FILE__, resv)
>  
>  int dma_buf_fd(struct dma_buf *dmabuf, int flags);
>  struct dma_buf *dma_buf_get(int fd);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
