Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762318Ab3ECCRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 22:17:18 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:28500
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757804Ab3ECCRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 22:17:03 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 3 May 2013 10:16:51 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH, RFC 04/22] staging/drm: imx: add missing dependencies
Message-ID: <20130503021650.GL3442@S2101-09.ap.freescale.net>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
 <1367507786-505303-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1367507786-505303-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 05:16:08PM +0200, Arnd Bergmann wrote:
> The imx DRM driver needs a couple of extra Kconfig dependencies
> to avoid random build failures:
> 
> drivers/staging/imx-drm/ipuv3-crtc.c:448:
>  undefined reference to `ipu_idmac_put'
>  drivers/staging/imx-drm/ipuv3-crtc.c:450: undefined reference to
>  `ipu_dmfc_put' drivers/staging/imx-drm/ipuv3-crtc.c:452:
>  undefined reference to `ipu_dp_put'
>  drivers/staging/imx-drm/ipuv3-crtc.c:454: undefined reference to
>  `ipu_di_put'
> drivers/built-in.o: In function `ipu_probe':
>  :(.text+0x4b4174): undefined reference to `device_reset'
> drivers/built-in.o: In function `imx_tve_probe':
>  drivers/staging/imx-drm/imx-tve.c:648: undefined reference to
>  `devm_regmap_init_mmio_clk'
> drivers/built-in.o: In function
>  `imx_pd_connector_get_modes':

>  drivers/staging/imx-drm/parallel-display.c:78: undefined
>  reference to `of_get_drm_display_mode'

There is a patch [1] from Marek fixing this one.

Shawn

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/233449

> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/staging/imx-drm/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/staging/imx-drm/Kconfig b/drivers/staging/imx-drm/Kconfig
> index 8c9e403..35ccda5 100644
> --- a/drivers/staging/imx-drm/Kconfig
> +++ b/drivers/staging/imx-drm/Kconfig
> @@ -1,6 +1,7 @@
>  config DRM_IMX
>  	tristate "DRM Support for Freescale i.MX"
>  	select DRM_KMS_HELPER
> +	select VIDEOMODE_HELPERS
>  	select DRM_GEM_CMA_HELPER
>  	select DRM_KMS_CMA_HELPER
>  	depends on DRM && (ARCH_MXC || ARCH_MULTIPLATFORM)
> @@ -23,6 +24,7 @@ config DRM_IMX_PARALLEL_DISPLAY
>  config DRM_IMX_TVE
>  	tristate "Support for TV and VGA displays"
>  	depends on DRM_IMX
> +	select REGMAP_MMIO
>  	help
>  	  Choose this to enable the internal Television Encoder (TVe)
>  	  found on i.MX53 processors.
> @@ -30,6 +32,7 @@ config DRM_IMX_TVE
>  config DRM_IMX_IPUV3_CORE
>  	tristate "IPUv3 core support"
>  	depends on DRM_IMX
> +	depends on RESET_CONTROLLER
>  	help
>  	  Choose this if you have a i.MX5/6 system and want
>  	  to use the IPU. This option only enables IPU base
> @@ -38,5 +41,6 @@ config DRM_IMX_IPUV3_CORE
>  config DRM_IMX_IPUV3
>  	tristate "DRM Support for i.MX IPUv3"
>  	depends on DRM_IMX
> +	depends on DRM_IMX_IPUV3_CORE
>  	help
>  	  Choose this if you have a i.MX5 or i.MX6 processor.
> -- 
> 1.8.1.2
> 

