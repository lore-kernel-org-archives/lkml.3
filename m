Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbaCQKH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:07:27 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:41996 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbaCQKH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:07:26 -0400
Date: Mon, 17 Mar 2014 11:07:21 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: enable render-nodes by default
Message-ID: <20140317100721.GS30571@phenom.ffwll.local>
Mail-Followup-To: David Herrmann <dh.herrmann@gmail.com>,
	dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
	linux-kernel@vger.kernel.org
References: <1394977400-10465-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394977400-10465-1-git-send-email-dh.herrmann@gmail.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2014 at 02:43:20PM +0100, David Herrmann wrote:
> We introduced render-nodes about 1/2 year ago and no problems showed up.
> Remove the drm_rnodes argument and enable them by default now.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
> Hi Dave
> 
> This does _not_ depend on the "drm-minor" branch. We decided to not provide
> reliable minor-numbers. User-space should just properly enumerate devices
> instead of relying on some minor-math-magic. Furthermore, so far no-one
> complained about any render-node issues, so I don't think there's any reason to
> keep them experimential.
> 
> Thanks
> David
> 
>  drivers/gpu/drm/drm_stub.c | 7 +------
>  include/drm/drmP.h         | 1 -
>  2 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
> index 98a33c580..be3ad89 100644
> --- a/drivers/gpu/drm/drm_stub.c
> +++ b/drivers/gpu/drm/drm_stub.c
> @@ -40,9 +40,6 @@
>  unsigned int drm_debug = 0;	/* 1 to enable debug output */
>  EXPORT_SYMBOL(drm_debug);
>  
> -unsigned int drm_rnodes = 0;	/* 1 to enable experimental render nodes API */
> -EXPORT_SYMBOL(drm_rnodes);
> -
>  unsigned int drm_vblank_offdelay = 5000;    /* Default to 5000 msecs. */
>  EXPORT_SYMBOL(drm_vblank_offdelay);
>  
> @@ -59,13 +56,11 @@ MODULE_AUTHOR(CORE_AUTHOR);
>  MODULE_DESCRIPTION(CORE_DESC);
>  MODULE_LICENSE("GPL and additional rights");
>  MODULE_PARM_DESC(debug, "Enable debug output");
> -MODULE_PARM_DESC(rnodes, "Enable experimental render nodes API");
>  MODULE_PARM_DESC(vblankoffdelay, "Delay until vblank irq auto-disable [msecs]");
>  MODULE_PARM_DESC(timestamp_precision_usec, "Max. error on timestamps [usecs]");
>  MODULE_PARM_DESC(timestamp_monotonic, "Use monotonic timestamps");
>  
>  module_param_named(debug, drm_debug, int, 0600);
> -module_param_named(rnodes, drm_rnodes, int, 0600);
>  module_param_named(vblankoffdelay, drm_vblank_offdelay, int, 0600);
>  module_param_named(timestamp_precision_usec, drm_timestamp_precision, int, 0600);
>  module_param_named(timestamp_monotonic, drm_timestamp_monotonic, int, 0600);
> @@ -533,7 +528,7 @@ int drm_dev_register(struct drm_device *dev, unsigned long flags)
>  			goto out_unlock;
>  	}
>  
> -	if (drm_core_check_feature(dev, DRIVER_RENDER) && drm_rnodes) {
> +	if (drm_core_check_feature(dev, DRIVER_RENDER)) {
>  		ret = drm_get_minor(dev, &dev->render, DRM_MINOR_RENDER);
>  		if (ret)
>  			goto err_control_node;
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index 04a7f31..5c91f1f 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -1448,7 +1448,6 @@ extern void drm_master_put(struct drm_master **master);
>  extern void drm_put_dev(struct drm_device *dev);
>  extern void drm_unplug_dev(struct drm_device *dev);
>  extern unsigned int drm_debug;
> -extern unsigned int drm_rnodes;
>  
>  extern unsigned int drm_vblank_offdelay;
>  extern unsigned int drm_timestamp_precision;
> -- 
> 1.9.0
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
