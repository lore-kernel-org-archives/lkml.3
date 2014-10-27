Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaJ0OrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:47:06 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:56323 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaJ0OrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <1413534398-22645-3-git-send-email-alexandre.belloni@free-electrons.com>
References: <1413534398-22645-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1413534398-22645-3-git-send-email-alexandre.belloni@free-electrons.com>
Date: Mon, 27 Oct 2014 15:47:02 +0100
Message-ID: <CAPDyKFo4-rKnQ3kMF46qmZ0raXZOM_CcRh+fzcKAGFweO7=N2Q@mail.gmail.com>
Subject: Re: [PATCHv2 2/3] ARM: at91: remove mach/atmel-mci.h
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <chris@printf.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2014 10:26, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> Use the generic platform_data header file instead of mach/atmel-mci.h
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Thanks! Applied for next!

Kind regards
Uffe


> ---
>  arch/arm/mach-at91/at91sam9g45_devices.c    |  2 +-
>  arch/arm/mach-at91/include/mach/atmel-mci.h | 17 -----------------
>  2 files changed, 1 insertion(+), 18 deletions(-)
>  delete mode 100644 arch/arm/mach-at91/include/mach/atmel-mci.h
>
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index 21ab782cc8e9..06ecbafd01ee 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -19,6 +19,7 @@
>  #include <linux/i2c-gpio.h>
>  #include <linux/atmel-mci.h>
>  #include <linux/platform_data/crypto-atmel.h>
> +#include <linux/platform_data/mmc-atmel-mci.h>
>
>  #include <linux/platform_data/at91_adc.h>
>
> @@ -30,7 +31,6 @@
>  #include <mach/at91_matrix.h>
>  #include <mach/at91sam9_smc.h>
>  #include <linux/platform_data/dma-atmel.h>
> -#include <mach/atmel-mci.h>
>  #include <mach/hardware.h>
>
>  #include <media/atmel-isi.h>
> diff --git a/arch/arm/mach-at91/include/mach/atmel-mci.h b/arch/arm/mach-at91/include/mach/atmel-mci.h
> deleted file mode 100644
> index 3069e4135573..000000000000
> --- a/arch/arm/mach-at91/include/mach/atmel-mci.h
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -#ifndef __MACH_ATMEL_MCI_H
> -#define __MACH_ATMEL_MCI_H
> -
> -#include <linux/platform_data/dma-atmel.h>
> -
> -/**
> - * struct mci_dma_data - DMA data for MCI interface
> - */
> -struct mci_dma_data {
> -       struct at_dma_slave     sdata;
> -};
> -
> -/* accessor macros */
> -#define        slave_data_ptr(s)       (&(s)->sdata)
> -#define find_slave_dev(s)      ((s)->sdata.dma_dev)
> -
> -#endif /* __MACH_ATMEL_MCI_H */
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
