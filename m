Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750775Ab3HSDWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 23:22:39 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:20345
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab3HSDWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 23:22:38 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1155h)
Date: Mon, 19 Aug 2013 09:24:01 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Felipe Balbi <balbi@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] usb: chipidea: USB_CHIPIDEA should depend on
 HAS_DMA
Message-ID: <20130819012400.GA2895@shlinux1.ap.freescale.net>
References: <1376857245-2088-1-git-send-email-geert@linux-m68k.org>
 <1376857245-2088-4-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1376857245-2088-4-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 10:20:44PM +0200, Geert Uytterhoeven wrote:
> If NO_DMA=y:
> 
> drivers/built-in.o: In function `dma_set_coherent_mask':
> include/linux/dma-mapping.h:93: undefined reference to `dma_supported'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/usb/chipidea/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/chipidea/Kconfig b/drivers/usb/chipidea/Kconfig
> index d1bd8ef..dbd5232 100644
> --- a/drivers/usb/chipidea/Kconfig
> +++ b/drivers/usb/chipidea/Kconfig
> @@ -1,6 +1,6 @@
>  config USB_CHIPIDEA
>  	tristate "ChipIdea Highspeed Dual Role Controller"
> -	depends on USB || USB_GADGET
> +	depends on (USB || USB_GADGET) && HAS_DMA
>  	help
>  	  Say Y here if your system has a dual role high speed USB
>  	  controller based on ChipIdea silicon IP. Currently, only the

I can't understand why the DMA can't be changed to fix this instead
of changing every driver?

-- 

Best Regards,
Peter Chen

