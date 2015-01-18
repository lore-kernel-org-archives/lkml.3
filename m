Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbbARMq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:46:26 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:47665 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbbARMqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:46:20 -0500
Date: Sun, 18 Jan 2015 12:46:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 3/3] backlight: 88pm860x_bl: Use of_get_child_by_name()
 instead of refcount hack
Message-ID: <20150118124604.GU3574@x1>
References: <1421243519-6257-1-git-send-email-geert+renesas@glider.be>
 <1421243519-6257-4-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421243519-6257-4-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015, Geert Uytterhoeven wrote:

> of_find_node_by_name() calls of_node_put() on its "from" parameter.
> To counter this, pm860x_backlight_dt_init() calls of_node_get() first.
> 
> Use of_get_child_by_name() instead to get rid of the refcount hack.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: linux-fbdev@vger.kernel.org
> ---
> Compile-tested only
> ---
>  drivers/video/backlight/88pm860x_bl.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Looks good, applied, thanks.

> diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
> index 9a23698b6fe8398c..2da5862876d1fe78 100644
> --- a/drivers/video/backlight/88pm860x_bl.c
> +++ b/drivers/video/backlight/88pm860x_bl.c
> @@ -168,10 +168,7 @@ static int pm860x_backlight_dt_init(struct platform_device *pdev,
>  	struct device_node *nproot, *np;
>  	int iset = 0;
>  
> -	nproot = of_node_get(pdev->dev.parent->of_node);
> -	if (!nproot)
> -		return -ENODEV;
> -	nproot = of_find_node_by_name(nproot, "backlights");
> +	nproot = of_get_child_by_name(pdev->dev.parent->of_node, "backlights");
>  	if (!nproot) {
>  		dev_err(&pdev->dev, "failed to find backlights node\n");
>  		return -ENODEV;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
