Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaETIGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:06:24 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:63407 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaETIGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:06:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140520165511.3f4bdc5d@canb.auug.org.au>
References: <20140520165511.3f4bdc5d@canb.auug.org.au>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 20 May 2014 13:35:59 +0530
Message-ID: <CAO_48GHfXW2wkaA0KNxa=66ERD5qzbH2gF6zosUc9WqUHYz95w@mail.gmail.com>
Subject: Re: linux-next: manual merge of the dma-buf tree with the drm-intel tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2014 12:25, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Sumit,
>
> Today's linux-next merge of the dma-buf tree got a conflict in
> drivers/gpu/drm/i915/i915_gem_dmabuf.c between commit 5cc9ed4b9a7a
> ("drm/i915: Introduce mapping of user pages into video memory (userptr)
> ioctl") from the drm-intel tree and commit 8dfb1f0f8103 ("dma-buf: use
> reservation objects") from the dma-buf tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>
Hi Stephen!

This seems good, thanks!

Best regards,
~Sumit.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/gpu/drm/i915/i915_gem_dmabuf.c
> index 580aa42443ed,817ec444c976..000000000000
> --- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> +++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
> @@@ -229,15 -233,8 +229,16 @@@ static const struct dma_buf_ops i915_dm
>   struct dma_buf *i915_gem_prime_export(struct drm_device *dev,
>                                       struct drm_gem_object *gem_obj, int flags)
>   {
>  +      struct drm_i915_gem_object *obj = to_intel_bo(gem_obj);
>  +
>  +      if (obj->ops->dmabuf_export) {
>  +              int ret = obj->ops->dmabuf_export(obj);
>  +              if (ret)
>  +                      return ERR_PTR(ret);
>  +      }
>  +
> -       return dma_buf_export(gem_obj, &i915_dmabuf_ops, gem_obj->size, flags);
> +       return dma_buf_export(gem_obj, &i915_dmabuf_ops, gem_obj->size, flags,
> +                               NULL);
>   }
>
>   static int i915_gem_object_get_pages_dmabuf(struct drm_i915_gem_object *obj)
