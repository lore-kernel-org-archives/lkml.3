Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3L0FSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 00:18:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3L0FSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 00:18:11 -0500
Date: Thu, 26 Dec 2013 21:18:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, jslaby@suse.cz,
        patches@linaro.org
Subject: Re: [PATCH] serial: samsung: Remove hard-coded major/minor numbers
Message-ID: <20131227051843.GA840@kroah.com>
References: <1388120848-15879-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388120848-15879-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 10:37:28AM +0530, Tushar Behera wrote:
> The hard-coded values clash with the values set for amba-pl011 serial
> driver. Because of this there is no serial output on Samsung boards
> if amba-pl011 is enabled alongwith samsung-serial driver.
> 
> Remove the hardcoded values and let the framework decide on
> appropriate major/minor number. This is required for multi-platform
> development work on Exynos platform.
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  drivers/tty/serial/samsung.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> index c1af04d..9c20543 100644
> --- a/drivers/tty/serial/samsung.c
> +++ b/drivers/tty/serial/samsung.c
> @@ -56,8 +56,6 @@
>  /* UART name and device definitions */
>  
>  #define S3C24XX_SERIAL_NAME	"ttySAC"
> -#define S3C24XX_SERIAL_MAJOR	204
> -#define S3C24XX_SERIAL_MINOR	64
>  
>  /* macros to change one thing to another */
>  
> @@ -951,8 +949,6 @@ static struct uart_driver s3c24xx_uart_drv = {
>  	.nr		= CONFIG_SERIAL_SAMSUNG_UARTS,
>  	.cons		= S3C24XX_SERIAL_CONSOLE,
>  	.dev_name	= S3C24XX_SERIAL_NAME,
> -	.major		= S3C24XX_SERIAL_MAJOR,
> -	.minor		= S3C24XX_SERIAL_MINOR,

Doesn't this break existing systems and configurations that are
expecting 204:64 as the location of this serial port?

Why change this one and not the amba-pl011 driver?

greg k-h
