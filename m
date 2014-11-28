Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaK1K6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:58:03 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:35295 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaK1K57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:57:59 -0500
MIME-Version: 1.0
In-Reply-To: <1417084891-17990-3-git-send-email-peter.ujfalusi@ti.com>
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com>
	<1417084891-17990-3-git-send-email-peter.ujfalusi@ti.com>
Date: Fri, 28 Nov 2014 11:57:58 +0100
Message-ID: <CAPDyKFpB_06x1OMLJ1bWWcf4c0Tob4k=TfEOkE1JpaA+uXouPw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: edma: Rename header file for dmaengine filter
 function definition
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, nsekhar@ti.com,
        Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, dmaengine@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2014 at 11:41, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Rename the include/linux/edma.h to include/linux/edma-dmaengine.h
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

For the mmc parts:

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
>  arch/arm/common/edma.c         |  2 +-
>  drivers/mmc/host/davinci_mmc.c |  3 +--
>  drivers/spi/spi-davinci.c      |  2 +-
>  include/linux/edma-dmaengine.h | 29 +++++++++++++++++++++++++++++
>  include/linux/edma.h           | 29 -----------------------------
>  sound/soc/davinci/edma-pcm.c   |  2 +-
>  6 files changed, 33 insertions(+), 34 deletions(-)
>  create mode 100644 include/linux/edma-dmaengine.h
>  delete mode 100644 include/linux/edma.h
>
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index 5662a872689b..bac677e65c76 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -25,7 +25,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> -#include <linux/edma.h>
> +#include <linux/edma-dmaengine.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/of_address.h>
>  #include <linux/of_device.h>
> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index 1625f908dc70..47323662c818 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -32,12 +32,11 @@
>  #include <linux/delay.h>
>  #include <linux/dmaengine.h>
>  #include <linux/dma-mapping.h>
> -#include <linux/edma.h>
> +#include <linux/edma-dmaengine.h>
>  #include <linux/mmc/mmc.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
>
> -#include <linux/platform_data/edma.h>
>  #include <linux/platform_data/mmc-davinci.h>
>
>  /*
> diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
> index b3707badb1e5..d61b7cdb2deb 100644
> --- a/drivers/spi/spi-davinci.c
> +++ b/drivers/spi/spi-davinci.c
> @@ -27,7 +27,7 @@
>  #include <linux/clk.h>
>  #include <linux/dmaengine.h>
>  #include <linux/dma-mapping.h>
> -#include <linux/edma.h>
> +#include <linux/edma-dmaengine.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/of_gpio.h>
> diff --git a/include/linux/edma-dmaengine.h b/include/linux/edma-dmaengine.h
> new file mode 100644
> index 000000000000..8a2602809a77
> --- /dev/null
> +++ b/include/linux/edma-dmaengine.h
> @@ -0,0 +1,29 @@
> +/*
> + * TI EDMA DMA engine driver
> + *
> + * Copyright 2012 Texas Instruments
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#ifndef __LINUX_EDMA_DMAENGINE_H
> +#define __LINUX_EDMA_DMAENGINE_H
> +
> +struct dma_chan;
> +
> +#if defined(CONFIG_TI_EDMA) || defined(CONFIG_TI_EDMA_MODULE)
> +bool edma_filter_fn(struct dma_chan *, void *);
> +#else
> +static inline bool edma_filter_fn(struct dma_chan *chan, void *param)
> +{
> +       return false;
> +}
> +#endif
> +
> +#endif
> diff --git a/include/linux/edma.h b/include/linux/edma.h
> deleted file mode 100644
> index a1307e7827e8..000000000000
> --- a/include/linux/edma.h
> +++ /dev/null
> @@ -1,29 +0,0 @@
> -/*
> - * TI EDMA DMA engine driver
> - *
> - * Copyright 2012 Texas Instruments
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> - * kind, whether express or implied; without even the implied warranty
> - * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -#ifndef __LINUX_EDMA_H
> -#define __LINUX_EDMA_H
> -
> -struct dma_chan;
> -
> -#if defined(CONFIG_TI_EDMA) || defined(CONFIG_TI_EDMA_MODULE)
> -bool edma_filter_fn(struct dma_chan *, void *);
> -#else
> -static inline bool edma_filter_fn(struct dma_chan *chan, void *param)
> -{
> -       return false;
> -}
> -#endif
> -
> -#endif
> diff --git a/sound/soc/davinci/edma-pcm.c b/sound/soc/davinci/edma-pcm.c
> index 59e588abe54b..873c8a090427 100644
> --- a/sound/soc/davinci/edma-pcm.c
> +++ b/sound/soc/davinci/edma-pcm.c
> @@ -23,7 +23,7 @@
>  #include <sound/pcm_params.h>
>  #include <sound/soc.h>
>  #include <sound/dmaengine_pcm.h>
> -#include <linux/edma.h>
> +#include <linux/edma-dmaengine.h>
>
>  #include "edma-pcm.h"
>
> --
> 2.1.3
>
