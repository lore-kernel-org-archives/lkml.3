Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaBJTya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:54:30 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:33324 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaBJTy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:54:27 -0500
Date: Mon, 10 Feb 2014 19:54:21 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Colin King <colin.king@canonical.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        rogerq@ti.com
Subject: Re: [PATCH] mfd: omap-usb-tll: allocate correct size for ch_clk
Message-ID: <20140210195421.GB31864@lee--X1>
References: <1392059407-15452-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392059407-15452-1-git-send-email-colin.king@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Colin Ian King <colin.king@canonical.com>
> 
> ch_clk was erroneously being allocated the incorrect size which
> can be problematic for larger sizes of tll->nch
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/mfd/omap-usb-tll.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
> index 5ee50f7..532eacab 100644
> --- a/drivers/mfd/omap-usb-tll.c
> +++ b/drivers/mfd/omap-usb-tll.c
> @@ -252,7 +252,7 @@ static int usbtll_omap_probe(struct platform_device *pdev)
>  		break;
>  	}
>  
> -	tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk * [tll->nch]),
> +	tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk *) * tll->nch,
>  						GFP_KERNEL);
>  	if (!tll->ch_clk) {
>  		ret = -ENOMEM;

Thanks Colin, patch looks good to me.

Roger, fancy finishing this off with an Acked-by?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
