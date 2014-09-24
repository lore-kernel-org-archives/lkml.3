Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaIXQTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:19:13 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:48701 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaIXQTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:19:11 -0400
Message-ID: <5422EEFA.7020303@atmel.com>
Date: Wed, 24 Sep 2014 18:19:06 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: enable new AIC driver even if the old one
 is selected
References: <1410254099-24680-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1410254099-24680-1-git-send-email-boris.brezillon@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 11:14, Boris BREZILLON :
> The new AIC driver is currently only selected when only DT board support
> is enabled (and not when both DT and non-DT boards are supported), thus,
> when booting a "DT + non-DT" kernel with a dtb, the irqchip is never
> initialized/registered which then triggers a panic.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

I'm not taking this right now. The Kconfig file is in flux. I'll try to
queue it during the 3.18-rc phase.

Bye,

> ---
>  arch/arm/mach-at91/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 7df2c9b..cd7c0cb 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -51,7 +51,7 @@ config HAVE_AT91_SMD
>  config SOC_AT91SAM9
>  	bool
>  	select AT91_SAM9_TIME
> -	select ATMEL_AIC_IRQ if !OLD_IRQ_AT91
> +	select ATMEL_AIC_IRQ
>  	select CPU_ARM926T
>  	select GENERIC_CLOCKEVENTS
>  
> @@ -111,7 +111,7 @@ endif
>  if SOC_SAM_V4_V5
>  config SOC_AT91RM9200
>  	bool "AT91RM9200"
> -	select ATMEL_AIC_IRQ if !OLD_IRQ_AT91
> +	select ATMEL_AIC_IRQ
>  	select CPU_ARM920T
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_AT91_DBGU0
> 


-- 
Nicolas Ferre
