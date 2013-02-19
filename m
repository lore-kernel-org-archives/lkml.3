Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab3BSPad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:30:33 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33127 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180Ab3BSPab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:30:31 -0500
Date: Tue, 19 Feb 2013 15:30:24 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Make AB8500_CORE select POWER_SUPPLY to fix build
 error
Message-ID: <20130219153024.GA4098@gmail.com>
References: <1361287233.23734.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1361287233.23734.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Axel Lin wrote:

> This patch fixes below build error when CONFIG_POWER_SUPPLY is not set.
> 
> drivers/built-in.o: In function `ab8500_power_off':
> drivers/mfd/ab8500-sysctrl.c:37: undefined reference to `power_supply_get_by_name'
> drivers/mfd/ab8500-sysctrl.c:53: undefined reference to `power_supply_get_by_name'
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/mfd/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 671f5b1..c346941 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -858,6 +858,7 @@ config EZX_PCAP
>  config AB8500_CORE
>  	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
>  	depends on GENERIC_HARDIRQS && ABX500_CORE && MFD_DB8500_PRCMU
> +	select POWER_SUPPLY
>  	select MFD_CORE
>  	select IRQ_DOMAIN
>  	help

I noticed and was going to fix this up myself - it's the right thing
to do.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
