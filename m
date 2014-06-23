Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaFWMhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:37:35 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:43067 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaFWMhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:37:34 -0400
Message-ID: <53A81F79.4080903@linaro.org>
Date: Mon, 23 Jun 2014 13:37:13 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tushar Behera <tushar.b@samsung.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, jslaby@suse.cz,
        gregkh@linuxfoundation.org, linux@arm.linux.org.uk
CC: trblinux@gmail.com
Subject: Re: [PATCH 1/2] serial: amba-pl011: Remove redundant label
References: <1403503151-4166-1-git-send-email-tushar.b@samsung.com> <1403503151-4166-2-git-send-email-tushar.b@samsung.com>
In-Reply-To: <1403503151-4166-2-git-send-email-tushar.b@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/06/14 06:59, Tushar Behera wrote:
> The label 'out' is only used to return the error code. We can return the
> error code directly and remove 'out' label.
> 
> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
> ---
>  drivers/tty/serial/amba-pl011.c |   30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
> index 0e26dcb..8572f2a 100644
> --- a/drivers/tty/serial/amba-pl011.c
> +++ b/drivers/tty/serial/amba-pl011.c
> @@ -1484,7 +1484,7 @@ static int pl011_hwinit(struct uart_port *port)
>  	 */
>  	retval = clk_prepare_enable(uap->clk);
>  	if (retval)
> -		goto out;
> +		return retval;
>  
>  	uap->port.uartclk = clk_get_rate(uap->clk);
>  
> @@ -1507,8 +1507,6 @@ static int pl011_hwinit(struct uart_port *port)
>  			plat->init();
>  	}
>  	return 0;
> - out:
> -	return retval;
>  }
>  
>  static void pl011_write_lcr_h(struct uart_amba_port *uap, unsigned int lcr_h)
> @@ -2131,32 +2129,24 @@ static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
>  		if (amba_ports[i] == NULL)
>  			break;
>  
> -	if (i == ARRAY_SIZE(amba_ports)) {
> -		ret = -EBUSY;
> -		goto out;
> -	}
> +	if (i == ARRAY_SIZE(amba_ports))
> +		return -EBUSY;
>  
>  	uap = devm_kzalloc(&dev->dev, sizeof(struct uart_amba_port),
>  			   GFP_KERNEL);
> -	if (uap == NULL) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> +	if (uap == NULL)
> +		return -ENOMEM;
>  
>  	i = pl011_probe_dt_alias(i, &dev->dev);
>  
>  	base = devm_ioremap(&dev->dev, dev->res.start,
>  			    resource_size(&dev->res));
> -	if (!base) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> +	if (!base)
> +		return -ENOMEM;
>  
>  	uap->clk = devm_clk_get(&dev->dev, NULL);
> -	if (IS_ERR(uap->clk)) {
> -		ret = PTR_ERR(uap->clk);
> -		goto out;
> -	}
> +	if (IS_ERR(uap->clk))
> +		return PTR_ERR(uap->clk);
>  
>  	uap->vendor = vendor;
>  	uap->lcrh_rx = vendor->lcrh_rx;
> @@ -2198,7 +2188,7 @@ static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
>  		uart_unregister_driver(&amba_reg);
>  		pl011_dma_remove(uap);
>  	}
> - out:
> +
>  	return ret;
>  }

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>


