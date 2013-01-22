Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3AVDZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:25:33 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:7929
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752947Ab3AVDZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:25:28 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 22 Jan 2013 11:54:04 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Javier Martin <javier.martin@vista-silicon.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH 09/15] media: coda: don't build on multiplatform
Message-ID: <20130122035402.GC29677@S2100-06.ap.freescale.net>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <1358788568-11137-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1358788568-11137-10-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 05:16:02PM +0000, Arnd Bergmann wrote:
> The coda video codec driver depends on a mach-imx or mach-mxs specific
> header file "mach/iram.h". This is not available when building for
> multiplatform, so let us disable this driver for v3.8 when building
> multiplatform, and hopefully find a proper fix for v3.9.
> 
> drivers/media/platform/coda.c:27:23: fatal error: mach/iram.h: No such file or directory
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Javier Martin <javier.martin@vista-silicon.com>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/platform/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 3dcfea6..049d2b2 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -142,7 +142,7 @@ if V4L_MEM2MEM_DRIVERS
>  
>  config VIDEO_CODA
>  	tristate "Chips&Media Coda multi-standard codec IP"
> -	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
> +	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC && !ARCH_MULTIPLATFORM
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
>  	select IRAM_ALLOC if SOC_IMX53
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

