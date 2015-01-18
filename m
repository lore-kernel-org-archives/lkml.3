Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbbARKLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 05:11:20 -0500
Received: from server.atrad.com.au ([150.101.241.2]:43627 "EHLO
	server.atrad.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbARKLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 05:11:18 -0500
X-Greylist: delayed 775 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2015 05:11:16 EST
Date: Sun, 18 Jan 2015 20:24:44 +1030
From: Jonathan Woithe <jwoithe@just42.net>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Karcher <karcher@physik.fu-berlin.de>
Subject: Re: [PATCH] fujitsu-laptop: use FB_BLANK_* constants
Message-ID: <20150118095443.GB16157@marvin.atrad.com.au>
References: <1421537580-28554-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
 <1421539331-32515-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421539331-32515-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-MIMEDefang-action: accept
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 01:02:11AM +0100, Michael Karcher wrote:
> From: Michael Karcher <karcher@physik.fu-berlin.de>

This looks ok to me.

Acked-by: Jonathan Woithe <jwoithe@just42.net>

> Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> ---
>  drivers/platform/x86/fujitsu-laptop.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index 7c21c1c..2a9afa2 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -64,6 +64,7 @@
>  #include <linux/acpi.h>
>  #include <linux/dmi.h>
>  #include <linux/backlight.h>
> +#include <linux/fb.h>
>  #include <linux/input.h>
>  #include <linux/kfifo.h>
>  #include <linux/platform_device.h>
> @@ -398,7 +399,7 @@ static int bl_get_brightness(struct backlight_device *b)
>  static int bl_update_status(struct backlight_device *b)
>  {
>  	int ret;
> -	if (b->props.power == 4)
> +	if (b->props.power == FB_BLANK_POWERDOWN)
>  		ret = call_fext_func(FUNC_BACKLIGHT, 0x1, 0x4, 0x3);
>  	else
>  		ret = call_fext_func(FUNC_BACKLIGHT, 0x1, 0x4, 0x0);
> @@ -1139,9 +1140,9 @@ static int __init fujitsu_init(void)
>  
>  	if (!acpi_video_backlight_support()) {
>  		if (call_fext_func(FUNC_BACKLIGHT, 0x2, 0x4, 0x0) == 3)
> -			fujitsu->bl_device->props.power = 4;
> +			fujitsu->bl_device->props.power = FB_BLANK_POWERDOWN;
>  		else
> -			fujitsu->bl_device->props.power = 0;
> +			fujitsu->bl_device->props.power = FB_BLANK_UNBLANK;
>  	}
>  
>  	pr_info("driver " FUJITSU_DRIVER_VERSION " successfully loaded\n");
> -- 
> 2.1.3
