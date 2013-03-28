Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab3C1E7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:59:39 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:55200 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3C1E7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:59:25 -0400
Message-ID: <1364446793.15039.2.camel@gitbox>
Subject: Re: [PATCH] video: fixed missing iounmap coccinelle errors
From: Tony Prisk <linux@prisktech.co.nz>
To: Andrei Epure <epure.andrei@gmail.com>
Cc: FlorianSchandinat@gmx.de, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 17:59:53 +1300
In-Reply-To: <1364427805-11972-1-git-send-email-epure.andrei@gmail.com>
References: <1364427805-11972-1-git-send-email-epure.andrei@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-28 at 01:43 +0200, Andrei Epure wrote:
> Modified or added the necessary goto statements so that the ioremapped
> regions get unmapped before return.
> 
> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
> ---
>  drivers/video/vt8500lcdfb.c |    7 ++++---
>  drivers/video/wm8505fb.c    |    7 ++++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
> index aa2579c..b4ccca2 100644
> --- a/drivers/video/vt8500lcdfb.c
> +++ b/drivers/video/vt8500lcdfb.c
> @@ -350,7 +350,7 @@ static int vt8500lcd_probe(struct platform_device *pdev)
>  	if (!np) {
>  		pr_err("%s: No display description in Device Tree\n", __func__);
>  		ret = -EINVAL;
> -		goto failed_free_res;
> +		goto failed_free_io;
>  	}
>  
>  	/*
> @@ -369,7 +369,7 @@ static int vt8500lcd_probe(struct platform_device *pdev)
>  	ret |= of_property_read_u32(np, "bpp", &bpp);
>  	if (ret) {
>  		pr_err("%s: Unable to read display properties\n", __func__);
> -		goto failed_free_res;
> +		goto failed_free_io;
>  	}
>  	of_mode.vmode = FB_VMODE_NONINTERLACED;
>  
> @@ -379,7 +379,8 @@ static int vt8500lcd_probe(struct platform_device *pdev)
>  				GFP_KERNEL);
>  	if (!fb_mem_virt) {
>  		pr_err("%s: Failed to allocate framebuffer\n", __func__);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto failed_free_io;
>  	};
>  
>  	fbi->fb.fix.smem_start	= fb_mem_phys;
> diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
> index 4dd0580..2e8298e 100644
> --- a/drivers/video/wm8505fb.c
> +++ b/drivers/video/wm8505fb.c
> @@ -332,7 +332,7 @@ static int wm8505fb_probe(struct platform_device *pdev)
>  	if (!np) {
>  		pr_err("%s: No display description in Device Tree\n", __func__);
>  		ret = -EINVAL;
> -		goto failed_free_res;
> +		goto failed_free_io;
>  	}
>  
>  	/*
> @@ -351,7 +351,7 @@ static int wm8505fb_probe(struct platform_device *pdev)
>  	ret |= of_property_read_u32(np, "bpp", &bpp);
>  	if (ret) {
>  		pr_err("%s: Unable to read display properties\n", __func__);
> -		goto failed_free_res;
> +		goto failed_free_io;
>  	}
>  
>  	of_mode.vmode = FB_VMODE_NONINTERLACED;
> @@ -369,7 +369,8 @@ static int wm8505fb_probe(struct platform_device *pdev)
>  				GFP_KERNEL);
>  	if (!fb_mem_virt) {
>  		pr_err("%s: Failed to allocate framebuffer\n", __func__);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto failed_free_io;
>  	};
>  
>  	fbi->fb.var.xres_virtual	= of_mode.xres;

NACK
Already have a patch queued up for this from Julia Lawall

Regards
Tony P

