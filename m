Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3AVIWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:22:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42134 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3AVIWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:22:10 -0500
Date: Tue, 22 Jan 2013 09:21:58 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Javier Martin <javier.martin@vista-silicon.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 09/15] media: coda: don't build on multiplatform
Message-ID: <20130122082158.GC9414@pengutronix.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <1358788568-11137-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358788568-11137-10-git-send-email-arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:17:21 up 212 days, 23:29, 47 users,  load average: 3.12, 3.87,
 4.81
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
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

I just sent a pull request for this with a proper fix.

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

This breakage is not multiplatform related at all, it won't compile
without multiplatform support either. So depends on BROKEN would be
more appropriate if you want to go this way.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
