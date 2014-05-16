Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaEPLYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 07:24:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59738 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaEPLYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 07:24:19 -0400
Date: Fri, 16 May 2014 13:24:14 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>, h@pengutronix.de
Cc: Shawn Guo <shawn.guo@freescale.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: imx: remove unused defines
Message-ID: <20140516112414.GW5858@pengutronix.de>
References: <1400140671.20469.7.camel@x220>
 <20140515122553.GF5858@pengutronix.de>
 <1400231369.20342.10.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400231369.20342.10.camel@x220>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:23:51 up 23 days,  4:55, 50 users,  load average: 0.02, 0.06,
 0.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 11:09:29AM +0200, Paul Bolle wrote:
> None of the defines "for modules using static and dynamic DMA channels"
> are used. Remove these.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
> 0) v1 was called "ARM: imx: remove check for CONFIG_SDMA_IRAM". This
> version just removes the entire block of defines, as Sascha suggested.
> 
> 1) Still untested.
> 
>  arch/arm/mach-imx/mx51.h | 33 ---------------------------------
>  1 file changed, 33 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mx51.h b/arch/arm/mach-imx/mx51.h
> index af844f76261a..3f6d4a674ffb 100644
> --- a/arch/arm/mach-imx/mx51.h
> +++ b/arch/arm/mach-imx/mx51.h
> @@ -145,39 +145,6 @@
>  #define MX51_SPBA_CTRL	0x3c
>  
>  /*
> - * Defines for modules using static and dynamic DMA channels
> - */
> -#define MX51_MXC_DMA_CHANNEL_IRAM	30
> -#define MX51_MXC_DMA_CHANNEL_SPDIF_TX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_UART1_RX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_UART1_TX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_UART2_RX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_UART2_TX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_UART3_RX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_UART3_TX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_MMC1	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_MMC2	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_SSI1_RX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_SSI1_TX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_SSI2_RX	MXC_DMA_DYNAMIC_CHANNEL
> -#ifdef CONFIG_SDMA_IRAM
> -#define MX51_MXC_DMA_CHANNEL_SSI2_TX	(MX51_MXC_DMA_CHANNEL_IRAM + 1)
> -#else				/*CONFIG_SDMA_IRAM */
> -#define MX51_MXC_DMA_CHANNEL_SSI2_TX	MXC_DMA_DYNAMIC_CHANNEL
> -#endif				/*CONFIG_SDMA_IRAM */
> -#define MX51_MXC_DMA_CHANNEL_CSPI1_RX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_CSPI1_TX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_CSPI2_RX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_CSPI2_TX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_CSPI3_RX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_CSPI3_TX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_ATA_RX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_ATA_TX	MXC_DMA_DYNAMIC_CHANNEL
> -#define MX51_MXC_DMA_CHANNEL_MEMORY	MXC_DMA_DYNAMIC_CHANNEL
> -
> -#define MX51_IS_MEM_DEVICE_NONSHARED(x)		0
> -
> -/*
>   * DMA request assignments
>   */
>  #define MX51_DMA_REQ_VPU		0
> -- 
> 1.9.0
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
