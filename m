Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbaGIWmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:42:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaGIWmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:42:22 -0400
Date: Wed, 9 Jul 2014 15:46:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Emil Goode <emilgoode@gmail.com>
Cc: Mark Brown <broonie@linaro.org>, Olof Johansson <olof@lixom.net>,
        Dongjin Kim <tobetter@gmail.com>, Julius Werner <jwerner@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] usb: usb5303: make use of uninitialized err variable
Message-ID: <20140709224647.GA23929@kroah.com>
References: <1401731125-19780-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401731125-19780-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 07:45:25PM +0200, Emil Goode wrote:
> The variable err is not initialized here, this patch uses it
> to store an eventual error value from devm_clk_get().
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/usb/misc/usb3503.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
> index f43c619..c86c3fa 100644
> --- a/drivers/usb/misc/usb3503.c
> +++ b/drivers/usb/misc/usb3503.c
> @@ -191,9 +191,13 @@ static int usb3503_probe(struct usb3503 *hub)
>  		hub->port_off_mask = 0;
>  
>  		clk = devm_clk_get(dev, "refclk");
> -		if (IS_ERR(clk) && PTR_ERR(clk) != -ENOENT) {
> -			dev_err(dev, "unable to request refclk (%d)\n", err);
> -			return PTR_ERR(clk);
> +		if (IS_ERR(clk)) {
> +			err = PTR_ERR(clk);
> +			if (err != -ENOENT) {
> +				dev_err(dev, "unable to request refclk (%d)\n",
> +					err);
> +				return err;
> +			}
>  		}
>  
>  		if (!IS_ERR(clk)) {
> -- 
> 1.7.10.4

This patch fails to apply to my tree :(
