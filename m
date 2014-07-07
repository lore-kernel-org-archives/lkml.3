Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaGGKun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:50:43 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:44166 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaGGKul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:50:41 -0400
Date: Mon, 7 Jul 2014 11:50:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: backlight: jornada720_lcd.c:  Cleaning up
 variable that is never used
Message-ID: <20140707105035.GC6407@lee--X1>
References: <1404562325-18471-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404562325-18471-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Jul 2014, Rickard Strandqvist wrote:

> From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>
> 
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/video/backlight/jornada720_lcd.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Is this different from the patch I just NACKed?

> diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
> index da3876c..b304319 100644
> --- a/drivers/video/backlight/jornada720_lcd.c
> +++ b/drivers/video/backlight/jornada720_lcd.c
> @@ -56,12 +56,10 @@ static int jornada_lcd_get_contrast(struct lcd_device *ld)
>  
>  static int jornada_lcd_set_contrast(struct lcd_device *ld, int value)
>  {
> -	int ret;
> -
>  	jornada_ssp_start();
>  
>  	/* start by sending our set contrast cmd to mcu */
> -	ret = jornada_ssp_byte(SETCONTRAST);
> +	jornada_ssp_byte(SETCONTRAST);
>  
>  	/* push the new value */
>  	if (jornada_ssp_byte(value) != TXDUMMY) {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
