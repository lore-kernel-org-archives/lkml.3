Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964836AbaGDN3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:29:03 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:21059 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaGDN3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:29:00 -0400
Message-ID: <53B6AC14.3090403@atmel.com>
Date: Fri, 4 Jul 2014 15:28:52 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael Welling <mwelling@ieee.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH] drivers: video: fbdev: atmel_lcdfb.c: Add ability to
 inverted backlight PWM.
References: <1404440796-11090-1-git-send-email-mwelling@ieee.org>
In-Reply-To: <1404440796-11090-1-git-send-email-mwelling@ieee.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 04:26, Michael Welling :
> The code has a variable to change the polarity of the PWM backlight control but
> it was not being initialized. This patch adds a devicetree entry to set the
> variable if required.
> 
> Signed-off-by: Michael Welling <mwelling@ieee.org>

Seems good


Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


> ---
>  .../devicetree/bindings/video/atmel,lcdc.txt       |    1 +
>  drivers/video/fbdev/atmel_lcdfb.c                  |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/video/atmel,lcdc.txt b/Documentation/devicetree/bindings/video/atmel,lcdc.txt
> index 1ec175e..b75af94 100644
> --- a/Documentation/devicetree/bindings/video/atmel,lcdc.txt
> +++ b/Documentation/devicetree/bindings/video/atmel,lcdc.txt
> @@ -46,6 +46,7 @@ Required properties (as per of_videomode_helper):
>  
>  Optional properties (as per of_videomode_helper):
>   - atmel,lcdcon-backlight: enable backlight
> + - atmel,lcdcon-backlight-inverted: invert backlight PWM polarity
>   - atmel,lcd-wiring-mode: lcd wiring mode "RGB" or "BRG"
>   - atmel,power-control-gpio: gpio to power on or off the LCD (as many as needed)
>  
> diff --git a/drivers/video/fbdev/atmel_lcdfb.c b/drivers/video/fbdev/atmel_lcdfb.c
> index d36e830..92640d4 100644
> --- a/drivers/video/fbdev/atmel_lcdfb.c
> +++ b/drivers/video/fbdev/atmel_lcdfb.c
> @@ -290,7 +290,7 @@ static void init_contrast(struct atmel_lcdfb_info *sinfo)
>  
>  	/* contrast pwm can be 'inverted' */
>  	if (pdata->lcdcon_pol_negative)
> -			contrast_ctr &= ~(ATMEL_LCDC_POL_POSITIVE);
> +		contrast_ctr &= ~(ATMEL_LCDC_POL_POSITIVE);
>  
>  	/* have some default contrast/backlight settings */
>  	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, contrast_ctr);
> @@ -1097,6 +1097,7 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb_info *sinfo)
>  	pdata->lcd_wiring_mode = ret;
>  
>  	pdata->lcdcon_is_backlight = of_property_read_bool(display_np, "atmel,lcdcon-backlight");
> +	pdata->lcdcon_pol_negative = of_property_read_bool(display_np, "atmel,lcdcon-backlight-inverted");
>  
>  	timings = of_get_display_timings(display_np);
>  	if (!timings) {
> 


-- 
Nicolas Ferre
