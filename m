Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab3AYQ6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:58:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:44362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab3AYQ6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:58:07 -0500
Message-ID: <5102B9DA.9080306@infradead.org>
Date: Fri, 25 Jan 2013 08:59:06 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: sfr@canb.auug.org.au, gregkh@linuxfoundation.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH] extcon: max77693: Fix bug of build error related to INPUT
 subsystem
References: <1359078970-11088-1-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1359078970-11088-1-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/13 17:56, Chanwoo Choi wrote:
> This patch fix build error of following log:
> 
> drivers/built-in.o: In function `max77693_muic_remove':
> extcon-max77693.c:(.text+0x664853): undefined reference to `input_unregister_device'
> drivers/built-in.o: In function `max77693_muic_probe':
> extcon-max77693.c:(.text+0x664971): undefined reference to `input_allocate_device'
> extcon-max77693.c:(.text+0x6649c1): undefined reference to `input_set_capability'
> extcon-max77693.c:(.text+0x6649d6): undefined reference to `input_set_capability'
> extcon-max77693.c:(.text+0x6649eb): undefined reference to `input_set_capability'
> extcon-max77693.c:(.text+0x664a00): undefined reference to `input_set_capability'
> extcon-max77693.c:(.text+0x664a15): undefined reference to `input_set_capability'
> extcon-max77693.c:(.text+0x664a20): undefined reference to `input_register_device'
> drivers/built-in.o: In function `max77693_muic_adc_handler':
> extcon-max77693.c:(.text+0x665318): undefined reference to `input_event'
> extcon-max77693.c:(.text+0x66532a): undefined reference to `input_event'
> make[1]: *** [vmlinux] Error 1
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/extcon/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
> index 07122a9..10df3fa 100644
> --- a/drivers/extcon/Kconfig
> +++ b/drivers/extcon/Kconfig
> @@ -29,7 +29,7 @@ config EXTCON_ADC_JACK
>  
>  config EXTCON_MAX77693
>  	tristate "MAX77693 EXTCON Support"
> -	depends on MFD_MAX77693
> +	depends on MFD_MAX77693 && INPUT
>  	select IRQ_DOMAIN
>  	select REGMAP_I2C
>  	help
> 


-- 
~Randy
