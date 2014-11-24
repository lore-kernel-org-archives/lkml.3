Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaKXKKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:10:15 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:46924 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaKXKKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:10:13 -0500
Date: Mon, 24 Nov 2014 10:10:06 +0000
From: Lee Jones <lee.jones@linaro.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Bryan Wu <cooloney@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] backlight: lp8788: Deletion of an unnecessary check
 before the function call "backlight_device_unregister"
Message-ID: <20141124101006.GD4241@x1>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54720DEB.4060109@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54720DEB.4060109@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2014, SF Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 23 Nov 2014 17:33:08 +0100
> 
> The backlight_device_unregister() function tests whether its argument is NULL
> and then returns immediately. Thus the test around the call is not needed.

Also the $SUBJECT should be less than 75 chars.

> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/video/backlight/lp8788_bl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/lp8788_bl.c b/drivers/video/backlight/lp8788_bl.c
> index d6c4f6a..24a055c 100644
> --- a/drivers/video/backlight/lp8788_bl.c
> +++ b/drivers/video/backlight/lp8788_bl.c
> @@ -221,8 +221,7 @@ static void lp8788_backlight_unregister(struct lp8788_bl *bl)
>  {
>  	struct backlight_device *bl_dev = bl->bl_dev;
>  
> -	if (bl_dev)
> -		backlight_device_unregister(bl_dev);
> +	backlight_device_unregister(bl_dev);
>  }
>  
>  static ssize_t lp8788_get_bl_ctl_mode(struct device *dev,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
