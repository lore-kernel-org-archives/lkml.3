Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaCEKPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:15:42 -0500
Received: from smtp-79.nebula.fi ([83.145.220.79]:44210 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752625AbaCEKPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:15:37 -0500
X-Greylist: delayed 652 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 05:15:37 EST
Date: Wed, 5 Mar 2014 12:01:51 +0200
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbdev: FB_OPENCORES should depend on HAS_DMA
Message-ID: <20140305100150.GA17085@chokladfabriken.org>
References: <1393012569-22560-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393012569-22560-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 08:56:09PM +0100, Geert Uytterhoeven wrote:
> If NO_DMA=y:
> 
>     drivers/built-in.o: In function `ocfb_remove':
>     ocfb.c:(.text+0x27fee): undefined reference to `dma_free_coherent'
>     drivers/built-in.o: In function `ocfb_probe':
>     ocfb.c:(.text+0x28418): undefined reference to `dma_alloc_coherent'
>     ocfb.c:(.text+0x284d2): undefined reference to `dma_free_coherent'
> 

I obviously had neglected compiling against that configuration,
thanks for the catch.

Acked-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/video/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 0192900dd183..fb8d31e717bc 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -982,7 +982,7 @@ config FB_PVR2
>  
>  config FB_OPENCORES
>  	tristate "OpenCores VGA/LCD core 2.0 framebuffer support"
> -	depends on FB
> +	depends on FB && HAS_DMA
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
> -- 
> 1.7.9.5
> 
