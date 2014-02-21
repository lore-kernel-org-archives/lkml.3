Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbaBUNzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:55:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59066 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaBUNy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:54:56 -0500
Date: Fri, 21 Feb 2014 14:54:54 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        tomi.valkeinen@ti.com, plagnioj@jcrosoft.com
Subject: Re: [PATCH v5] video: add OpenCores VGA/LCD framebuffer driver
Message-ID: <20140221135454.GA12555@pengutronix.de>
References: <1389384793-4710-1-git-send-email-stefan.kristiansson@saunalahti.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389384793-4710-1-git-send-email-stefan.kristiansson@saunalahti.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 10, 2014 at 10:13:13PM +0200, Stefan Kristiansson wrote:
> This adds support for the VGA/LCD core available from OpenCores:
> http://opencores.org/project,vga_lcd
> 
> The driver have been tested together with both OpenRISC and
> ARM (socfpga) processors.
> 
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> ---
> Changes in v2:
> - Add Microblaze as an example user and fix a typo in Xilinx Zynq
> 
> Changes in v3:
> - Use devm_kzalloc instead of kzalloc
> - Remove superflous MODULE #ifdef
> 
> Changes in v4:
> - Remove 'default n' in Kconfig
> - Simplify ioremap/request_mem_region by using devm_ioremap_resource
> - Remove release_mem_region
> 
> Changes in v5:
> - Remove static structs to support multiple devices
> ---
>  drivers/video/Kconfig  |  16 ++
>  drivers/video/Makefile |   1 +
>  drivers/video/ocfb.c   | 440 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 457 insertions(+)
>  create mode 100644 drivers/video/ocfb.c
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 84b685f..8e41a1e 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -979,6 +979,22 @@ config FB_PVR2
>  	  (<file:drivers/video/pvr2fb.c>). Please see the file
>  	  <file:Documentation/fb/pvr2fb.txt>.
>  
> +config FB_OPENCORES
> +	tristate "OpenCores VGA/LCD core 2.0 framebuffer support"
> +	depends on FB

Maybe add something like:

	depends on ARCH_SOCFPGA || ARCH_ZYNQ || MICROBLAZE || OPENRISC || COMPILE_TEST

(Sorry for being late with that suggestion, this attracted my attention
only during make oldconfig on v3.14-rc, so if you agree this is a good
idea you need a seperate patch :-)

Best regards
Uwe

> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
