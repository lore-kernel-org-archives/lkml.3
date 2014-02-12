Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaBLKp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:45:28 -0500
Received: from top.free-electrons.com ([176.31.233.9]:43044 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751354AbaBLKpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:45:25 -0500
Message-ID: <52FB50BB.5070603@free-electrons.com>
Date: Wed, 12 Feb 2014 11:45:15 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, b.brezillon@overkiz.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/8] at91: dt: Adds support for the bus matrix declaration
 in the DT
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com> <1392199607-27452-2-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1392199607-27452-2-git-send-email-jjhiblot@traphandler.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Jacques,

Thanks for this new series, I have one little comment:

On 12/02/2014 11:06, Jean-Jacques Hiblot wrote:
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  arch/arm/mach-at91/setup.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index f7ca97b..b8d0b66 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -487,6 +487,28 @@ end:
>  	of_node_put(np);
>  }
>  
> +static struct of_device_id matrix_ids[] = {
> +	{ .compatible = "atmel,at91sam9261-bus-matrix", },
> +	{ /*sentinel*/ }
> +};
> +
> +static void at91_dt_matrix(void)
> +{
> +	struct device_node *np;
> +
> +	np = of_find_matching_node(NULL, matrix_ids);
> +	if (!np) {
> +		pr_debug("AT91: unable to find compatible bus matrix controller node in dtb\n");

I think that a panic here should be more consistent with the next check.
Indeed if it fails here then at91_matrix_base will be uninitialized too,
and it will make the kernel crash when at91_matrix_base will be accessed.

Thanks,

Gregory


> +		return;
> +	}
> +
> +	at91_matrix_base = of_iomap(np, 0);
> +	if (!at91_matrix_base)
> +		panic("Impossible to ioremap at91_matrix_base\n");
> +
> +	of_node_put(np);
> +}
> +
>  void __init at91rm9200_dt_initialize(void)
>  {
>  	at91_dt_ramc();
> @@ -506,6 +528,7 @@ void __init at91_dt_initialize(void)
>  	at91_dt_rstc();
>  	at91_dt_ramc();
>  	at91_dt_shdwc();
> +	at91_dt_matrix();
>  
>  	/* Init clock subsystem */
>  	at91_dt_clock_init();
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
