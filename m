Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbaGIXIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:08:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbaGIXIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:08:34 -0400
Date: Wed, 9 Jul 2014 16:13:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Colin King <colin.king@canonical.com>
Cc: Mark Brown <broonie@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: usb3503: return correct error return on failure
Message-ID: <20140709231300.GA28238@kroah.com>
References: <1404078173-11921-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404078173-11921-1-git-send-email-colin.king@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 10:42:53PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Fix warning: drivers/usb/misc/usb3503.c:195:11: warning: 'err'
>   may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> err is not initialized, the error return should be PTR_ERR(clk)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/usb/misc/usb3503.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
> index f43c619..c0c898d 100644
> --- a/drivers/usb/misc/usb3503.c
> +++ b/drivers/usb/misc/usb3503.c
> @@ -192,7 +192,8 @@ static int usb3503_probe(struct usb3503 *hub)
>  
>  		clk = devm_clk_get(dev, "refclk");
>  		if (IS_ERR(clk) && PTR_ERR(clk) != -ENOENT) {
> -			dev_err(dev, "unable to request refclk (%d)\n", err);
> +			dev_err(dev, "unable to request refclk (%ld)\n",
> +				PTR_ERR(clk));
>  			return PTR_ERR(clk);
>  		}
>  

This doesn't apply to my tree at all :(
