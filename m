Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaBKJk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:40:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36790 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaBKJky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:40:54 -0500
Message-ID: <52F9F020.6090504@ti.com>
Date: Tue, 11 Feb 2014 11:40:48 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Colin King <colin.king@canonical.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v2] mfd: omap-usb-tll: fix cppcheck sizeof warning
References: <1392111533-23053-1-git-send-email-colin.king@canonical.com>
In-Reply-To: <1392111533-23053-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 11:38 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Static analysis from cppcheck issued the following warning:
> 
> [drivers/mfd/omap-usb-tll.c:255]: (warning) Found calculation
>   inside sizeof().
> 
> The current size calculation is not obvious and is easy to
> miscomprehend, so re-work the size of the allocation based
> on the size of the struct pointer and quantity to allocate.
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
> 

Thanks for the patch Colin.

Acked-by: Roger Quadros <rogerq@ti.com>

--
cheers,
-roger
