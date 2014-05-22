Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaEVSK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:10:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34073 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaEVSKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:10:55 -0400
Date: Thu, 22 May 2014 20:10:24 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Emil Goode <emilgoode@gmail.com>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: introduce function imx_free_mx3_camera
Message-ID: <20140522181024.GA20155@pengutronix.de>
References: <1400781080-6117-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400781080-6117-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Emil,

On Thu, May 22, 2014 at 07:51:19PM +0200, Emil Goode wrote:
> We forgot to free pdev->dev.dma_mask on error after
> having called the imx_alloc_mx3_camera function.
> This patch introduces the imx_free_mx3_camera function
> that adds the missing kfree call and is practical for
> future usage with imx_alloc_mx3_camera().
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>  arch/arm/mach-imx/devices-imx31.h             |    2 ++
>  arch/arm/mach-imx/devices-imx35.h             |    2 ++
>  arch/arm/mach-imx/devices/devices-common.h    |    1 +
>  arch/arm/mach-imx/devices/platform-ipu-core.c |   11 +++++++++--
>  arch/arm/mach-imx/mach-mx31_3ds.c             |    2 +-
>  arch/arm/mach-imx/mach-mx31moboard.c          |    3 +--
>  arch/arm/mach-imx/mach-mx35_3ds.c             |    2 +-
>  arch/arm/mach-imx/mach-pcm037.c               |    2 +-
>  8 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/devices-imx31.h b/arch/arm/mach-imx/devices-imx31.h
> index e8d1611..900d3b0 100644
> --- a/arch/arm/mach-imx/devices-imx31.h
> +++ b/arch/arm/mach-imx/devices-imx31.h
> @@ -45,6 +45,8 @@ extern const struct imx_ipu_core_data imx31_ipu_core_data;
>  	imx_add_ipu_core(&imx31_ipu_core_data)
>  #define imx31_alloc_mx3_camera(pdata)	\
>  	imx_alloc_mx3_camera(&imx31_ipu_core_data, pdata)
> +#define imx31_free_mx3_camera(pdev)	\
> +	imx_free_mx3_camera(pdev)
I wouldn't make this a globally visible function. Today all imx machines
should get their devices from an oftree, so the various functions to add
devices started to bitrot. Moreover there is no reason to remove a
device once it was successfully added.

Note that platform_device_register_full has the same problem (i.e.
pdev->dev.dma_mask isn't freed when the last reference to a device is
dropped.) You'd do a better deed if you picked up
http://thread.gmane.org/gmane.linux.kernel/1613364/focus=1635995
instead of fixing dead code. But feel free to choose yourself where you
want to patch.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
