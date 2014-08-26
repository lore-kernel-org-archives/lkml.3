Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaHZQ2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:28:24 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:46420 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaHZQ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:28:23 -0400
Date: Tue, 26 Aug 2014 17:28:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 17/18] backlight: jornada720: remove 'else' after a return
Message-ID: <20140826162817.GD26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00bb01cfc12d$fb662c20$f2328460$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00bb01cfc12d$fb662c20$f2328460$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Jingoo Han wrote:

> Fixed the following checkpatch warning.
> 
>   WARNING: else is not generally useful after a break or return
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/jornada720_lcd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
> index 228bc319de19..1cf3d59f1e7f 100644
> --- a/drivers/video/backlight/jornada720_lcd.c
> +++ b/drivers/video/backlight/jornada720_lcd.c
> @@ -30,8 +30,8 @@ static int jornada_lcd_get_power(struct lcd_device *ld)
>  	/* LDD2 in PPC = LCD POWER */
>  	if (PPSR & PPC_LDD2)
>  		return FB_BLANK_UNBLANK;	/* PW ON */
> -	else
> -		return FB_BLANK_POWERDOWN;	/* PW OFF */
> +
> +	return FB_BLANK_POWERDOWN;	/* PW OFF */

How about:

  return PPSR & PPC_LDD2 ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;

>  }
>  
>  static int jornada_lcd_get_contrast(struct lcd_device *ld)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
