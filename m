Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab3HZIEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:04:30 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:59144 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755268Ab3HZIE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:04:29 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 04:04:29 EDT
From: Dmitry Torokhov <dtor@vmware.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: airlied@linux.ie, airlied@redhat.com, thellstrom@vmware.com,
        brianp@vmware.com, daniel.vetter@ffwll.ch,
        yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/vmwgfx: fix error return code in vmw_driver_load()
Date: Mon, 26 Aug 2013 00:56 -0700
Message-ID: <8371335.jOCe9OeWEl@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.10.5 (Linux/3.10.4-100.fc18.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAPgLHd-6AP74UFPzxU0dz2y+JyPSL1w+x5zd_hXCVLOuws8AYQ@mail.gmail.com>
References: <CAPgLHd-6AP74UFPzxU0dz2y+JyPSL1w+x5zd_hXCVLOuws8AYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 26, 2013 03:15:37 PM Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENOMEM in the fence manager init error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Dmitry Torokhov <dtor@vmware.com>

> ---
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c index 78e2164..6dafefc 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> @@ -622,8 +622,10 @@ static int vmw_driver_load(struct drm_device *dev,
> unsigned long chipset) }
> 
>  	dev_priv->fman = vmw_fence_manager_init(dev_priv);
> -	if (unlikely(dev_priv->fman == NULL))
> +	if (unlikely(dev_priv->fman == NULL)) {
> +		ret = -ENOMEM;
>  		goto out_no_fman;
> +	}
> 
>  	vmw_kms_save_vga(dev_priv);
