Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab3KDIv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:51:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45030 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3KDIv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:51:57 -0500
Date: Mon, 4 Nov 2013 09:51:46 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: removed unused MACH_MXLADS Kconfig parameter
Message-ID: <20131104085146.GT24559@pengutronix.de>
Mail-Followup-To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
	kernel@pengutronix.de, linux@arm.linux.org.uk,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1383542366-6270-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383542366-6270-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:41:44 up 71 days, 18:12, 40 users,  load average: 0.04, 0.04,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 06:19:26AM +0100, Michael Opdenacker wrote:
> This removes the MACH_MXLADS Kconfig parameter,
> which was no longer used anywhere in the source code
> and Makefiles.

Hehe, this one is a bit tricky. Indeed MACH_MXLADS isn't used directly
anywhere. Nevertheless having CONFIG_MACH_MXLADS defined makes
machine_is_mxlads() become true when the kernel is started with a
machine id of 1851.

machine_is_mxlads() is unused in the kernel, so this patch indeed
doesn't hurt. Anyway, the code is correct currently, so I suggest
keeping it until the mx[1l]ads is either removed or converted to
devicetree.

Sascha


> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  arch/arm/mach-imx/Kconfig | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 29a8af6922a8..d84a772bbc68 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -158,14 +158,11 @@ config	SOC_IMX51
>  if ARCH_MULTI_V4T
>  
>  comment "MX1 platforms:"
> -config MACH_MXLADS
> -	bool
>  
>  config ARCH_MX1ADS
>  	bool "MX1ADS platform"
>  	select IMX_HAVE_PLATFORM_IMX_I2C
>  	select IMX_HAVE_PLATFORM_IMX_UART
> -	select MACH_MXLADS
>  	select SOC_IMX1
>  	help
>  	  Say Y here if you are using Motorola MX1ADS/MXLADS boards
> -- 
> 1.8.1.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
