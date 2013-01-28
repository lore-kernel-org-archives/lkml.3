Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3A1IdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:33:16 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:28815 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3A1IdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:33:15 -0500
Message-ID: <510637CA.7010305@atmel.com>
Date: Mon, 28 Jan 2013 09:33:14 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        <spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 14/19] spi/atmel: remove incorrect __exit_p()
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359153858-31992-1-git-send-email-arnd@arndb.de> <1359153858-31992-15-git-send-email-arnd@arndb.de>
In-Reply-To: <1359153858-31992-15-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 11:44 PM, Arnd Bergmann :
> Since we no longer allow building without hotplug, the
> atmel_spi_remove function is always present and we should
> not use __exit_p() to refer to it.
> 
> Without this patch, building at91_dt_defconfig results in:
> 
> drivers/spi/spi-atmel.c:1006:12: warning: 'atmel_spi_remove' defined but not used [-Wunused-function]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: spi-devel-general@lists.sourceforge.net
> ---
>  drivers/spi/spi-atmel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> index ab34497..656d137 100644
> --- a/drivers/spi/spi-atmel.c
> +++ b/drivers/spi/spi-atmel.c
> @@ -1088,7 +1088,7 @@ static struct platform_driver atmel_spi_driver = {
>  	.suspend	= atmel_spi_suspend,
>  	.resume		= atmel_spi_resume,
>  	.probe		= atmel_spi_probe,
> -	.remove		= __exit_p(atmel_spi_remove),
> +	.remove		= atmel_spi_remove,
>  };
>  module_platform_driver(atmel_spi_driver);
>  
> 


-- 
Nicolas Ferre
