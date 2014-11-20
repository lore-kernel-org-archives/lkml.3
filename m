Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaKTEWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 23:22:44 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35952 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbaKTEWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 23:22:43 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        David Airlie <airlied@linux.ie>, <dri-devel@lists.freedesktop.org>
CC: LKML <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Thu, 20 Nov 2014 05:22:37 +0100
Message-ID: <149cb7002e0.2771.879d79c6f3490faa837fa11cb97f42bf@gmail.com>
In-Reply-To: <546CCB7E.3050109@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <546CCB7E.3050109@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0 AquaMail/1.5.0.19 (build: 2100846)
Subject: Re: [PATCH 1/1] DRM-vmwgfx: Deletion of an unnecessary check before the function call "vfree"
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On November 19, 2014 5:57:13 PM SF Markus Elfring 
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 19 Nov 2014 17:50:19 +0100
>
> The vfree() function performes also input parameter validation. Thus the test
> around the call is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c 
> b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> index 14b2f50..f9a67b8 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> @@ -889,8 +889,7 @@ static int vmw_driver_unload(struct drm_device *dev)
>
>  	if (dev_priv->ctx.res_ht_initialized)
>  		drm_ht_remove(&dev_priv->ctx.res_ht);
> -	if (dev_priv->ctx.cmd_bounce)
> -		vfree(dev_priv->ctx.cmd_bounce);
> +	vfree(dev_priv->ctx.cmd_bounce);
>  	if (dev_priv->enable_fb) {
>  		vmw_fb_close(dev_priv);
>  		vmw_kms_restore_vga(dev_priv);

Reviewed-by: Thierry Reding <thierry.reding@gmail.com>


