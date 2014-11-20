Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbaKTELq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 23:11:46 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:61596 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbaKTELo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 23:11:44 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        David Airlie <airlied@linux.ie>, <dri-devel@lists.freedesktop.org>
CC: LKML <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Date: Thu, 20 Nov 2014 05:11:38 +0100
Message-ID: <149cb65f4a8.2771.879d79c6f3490faa837fa11cb97f42bf@gmail.com>
In-Reply-To: <546CC1DE.3020105@users.sourceforge.net>
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
 <546CC1DE.3020105@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0 AquaMail/1.5.0.19 (build: 2100846)
Subject: Re: [PATCH 1/1] DRM-tilcdc: Deletion of an unnecessary check before the function call "drm_fbdev_cma_hotplug_event"
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On November 19, 2014 5:28:59 PM SF Markus Elfring 
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 19 Nov 2014 17:05:20 +0100
>
> The drm_fbdev_cma_hotplug_event() function tests whether its argument is NULL
> and then returns immediately. Thus the test around the call is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/gpu/drm/tilcdc/tilcdc_drv.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c 
> b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
> index 000428e..335b1dc 100644
> --- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
> +++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
> @@ -58,8 +58,7 @@ static struct drm_framebuffer *tilcdc_fb_create(struct 
> drm_device *dev,
>  static void tilcdc_fb_output_poll_changed(struct drm_device *dev)
>  {
>  	struct tilcdc_drm_private *priv = dev->dev_private;
> -	if (priv->fbdev)
> -		drm_fbdev_cma_hotplug_event(priv->fbdev);
> +	drm_fbdev_cma_hotplug_event(priv->fbdev);
>  }
>
>  static const struct drm_mode_config_funcs mode_config_funcs = {

Reviewed-by: Thierry Reding <thierry.reding@gmail.com>


