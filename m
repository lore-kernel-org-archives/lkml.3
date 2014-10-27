Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaJ0Os5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:48:57 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:65157 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaJ0Osy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:48:54 -0400
MIME-Version: 1.0
In-Reply-To: <1413534398-22645-4-git-send-email-alexandre.belloni@free-electrons.com>
References: <1413534398-22645-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1413534398-22645-4-git-send-email-alexandre.belloni@free-electrons.com>
Date: Mon, 27 Oct 2014 15:48:53 +0100
Message-ID: <CAPDyKFqLiTP6ZoqM788+W5qpaCYsRRiYe0UA5+fZWd73cgCLrw@mail.gmail.com>
Subject: Re: [PATCHv2 3/3] avr32: remove mach/atmel-mci.h
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

Do note, this one required me to resolve a conflict for removing the
header file. Please have a look to make sure I haven't broken
something.

Kind regards
Uffe


> ---
>  arch/avr32/mach-at32ap/at32ap700x.c             |  2 +-
>  arch/avr32/mach-at32ap/include/mach/atmel-mci.h | 17 -----------------
>  2 files changed, 1 insertion(+), 18 deletions(-)
>  delete mode 100644 arch/avr32/mach-at32ap/include/mach/atmel-mci.h
>
> diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index db85b5ec3351..f8deca560e4d 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -17,7 +17,7 @@
>  #include <linux/spi/spi.h>
>  #include <linux/usb/atmel_usba_udc.h>
>
> -#include <mach/atmel-mci.h>
> +#include <linux/platform_data/mmc-atmel-mci.h>
>  #include <linux/atmel-mci.h>
>
>  #include <asm/io.h>
> diff --git a/arch/avr32/mach-at32ap/include/mach/atmel-mci.h b/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
> deleted file mode 100644
> index 4bba58561d5c..000000000000
> --- a/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -#ifndef __MACH_ATMEL_MCI_H
> -#define __MACH_ATMEL_MCI_H
> -
> -#include <linux/dw_dmac.h>
> -
> -/**
> - * struct mci_dma_data - DMA data for MCI interface
> - */
> -struct mci_dma_data {
> -       struct dw_dma_slave     sdata;
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
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
