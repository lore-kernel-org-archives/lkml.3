Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3C2IlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 04:41:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51289 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab3C2IlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 04:41:19 -0400
Date: Fri, 29 Mar 2013 09:41:14 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, tomi.valkeinen@ti.com,
        FlorianSchandinat@gmx.de, plagnioj@jcrosoft.com
Subject: Re: [PATCH RESEND] fbmon: use VESA_DMT_VSYNC_HIGH to fix typo
Message-ID: <20130329084114.GB32161@pengutronix.de>
References: <8984685.165951364521249756.JavaMail.weblogic@epml18>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8984685.165951364521249756.JavaMail.weblogic@epml18>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:37:13 up 278 days, 23:48, 47 users,  load average: 0.46, 0.44,
 0.42
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 01:40:52AM +0000, Jingoo Han wrote:
> VESA_DMT_VSYNC_HIGH should be used instead of VESA_DMT_HSYNC_HIGH,
> because FB_SYNC_VERT_HIGH_ACT is related to vsync, not to hsync.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> ---
>  drivers/video/fbmon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> index 94ad0f7..7f67099 100644
> --- a/drivers/video/fbmon.c
> +++ b/drivers/video/fbmon.c
> @@ -1400,7 +1400,7 @@ int fb_videomode_from_videomode(const struct videomode *vm,
>  	fbmode->vmode = 0;
>  	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
>  		fbmode->sync |= FB_SYNC_HOR_HIGH_ACT;
> -	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
> +	if (vm->dmt_flags & VESA_DMT_VSYNC_HIGH)
>  		fbmode->sync |= FB_SYNC_VERT_HIGH_ACT;
>  	if (vm->data_flags & DISPLAY_FLAGS_INTERLACED)
>  		fbmode->vmode |= FB_VMODE_INTERLACED;
> -- 
> 1.7.2.5

Hi,

I already implied this on the original mail, but to be clear:

Acked-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>

Thanks,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
