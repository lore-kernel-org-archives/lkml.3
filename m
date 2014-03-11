Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaCKK3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:29:22 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52134 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaCKK3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:29:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Simon Horman <horms+renesas@verge.net.au>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 1/4] serial: sh-sci: Replace printk() by pr_*()
Date: Tue, 11 Mar 2014 11:30:52 +0100
Message-ID: <1738100.8MZc8BUIum@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394532680-4264-1-git-send-email-geert@linux-m68k.org>
References: <1394532680-4264-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patches.

I had patches similar to 3/4 and 4/4 in my tree, that's a sign you're going in 
the right direction (or at least the direction I consider to be right :-)). 
For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

On Tuesday 11 March 2014 11:11:17 Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Make banner const while we're at it
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> ---
>  drivers/tty/serial/sh-sci.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
> index 7958115e6a51..24ec6ef67984 100644
> --- a/drivers/tty/serial/sh-sci.c
> +++ b/drivers/tty/serial/sh-sci.c
> @@ -428,7 +428,7 @@ static int sci_probe_regmap(struct plat_sci_port *cfg)
>  		cfg->regtype = SCIx_HSCIF_REGTYPE;
>  		break;
>  	default:
> -		printk(KERN_ERR "Can't probe register map for given port\n");
> +		pr_err("Can't probe register map for given port\n");
>  		return -EINVAL;
>  	}
> 
> @@ -2389,8 +2389,7 @@ static inline int sci_probe_earlyprintk(struct
> platform_device *pdev)
> 
>  #endif /* CONFIG_SERIAL_SH_SCI_CONSOLE */
> 
> -static char banner[] __initdata =
> -	KERN_INFO "SuperH (H)SCI(F) driver initialized\n";
> +static const char banner[] __initconst = "SuperH (H)SCI(F) driver
> initialized";
> 
>  static struct uart_driver sci_uart_driver = {
>  	.owner		= THIS_MODULE,
> @@ -2616,7 +2615,7 @@ static int __init sci_init(void)
>  {
>  	int ret;
> 
> -	printk(banner);
> +	pr_info("%s\n", banner);
> 
>  	ret = uart_register_driver(&sci_uart_driver);
>  	if (likely(ret == 0)) {

-- 
Regards,

Laurent Pinchart

