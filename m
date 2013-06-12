Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3FLFsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 01:48:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:13575 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab3FLFsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 01:48:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,848,1363158000"; 
   d="scan'208";a="315698020"
Date: Wed, 12 Jun 2013 10:38:29 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        viresh.kumar@linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2 2/4] dma: move dw_dmac driver to an own directory
Message-ID: <20130612050829.GB4107@intel.com>
References: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1370435206-13474-3-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370435206-13474-3-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 03:26:44PM +0300, Andy Shevchenko wrote:
> The dw_dmac driver is going to be split into multiple files. To make this more
> convenient move it to an own directory.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
> +config DW_DMAC
> +	tristate "Synopsys DesignWare AHB DMA support"
> +	depends on GENERIC_HARDIRQS
> +	select DMA_ENGINE
> +	default y if CPU_AT32AP7000
> +	help
> +	  Support the Synopsys DesignWare AHB DMA controller. This
> +	  can be integrated in chips such as the Atmel AT32ap7000.
> +
> +config DW_DMAC_BIG_ENDIAN_IO
> +	bool "Use big endian I/O register access"
> +	default y if AVR32
> +	depends on DW_DMAC
> +	help
> +	  Say yes here to use big endian I/O access when reading and writing
> +	  to the DMA controller registers. This is needed on some platforms,
> +	  like the Atmel AVR32 architecture.
I know this is derived but should it be selected if AVR32 is defined, this stuff
should be user configurable..

> +
> +	  If unsure, use the default setting.
> diff --git a/drivers/dma/dw/Makefile b/drivers/dma/dw/Makefile
> new file mode 100644
> index 0000000..dd8d993
> --- /dev/null
> +++ b/drivers/dma/dw/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_DW_DMAC) += dw_dmac.o
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw/dw_dmac.c
> similarity index 99%
> rename from drivers/dma/dw_dmac.c
> rename to drivers/dma/dw/dw_dmac.c
> index 2b65ba6..15f3f4f 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw/dw_dmac.c
> @@ -28,8 +28,8 @@
>  #include <linux/acpi.h>
>  #include <linux/acpi_dma.h>
>  
> +#include "../dmaengine.h"
>  #include "dw_dmac_regs.h"
> -#include "dmaengine.h"
>  
>  /*
>   * This supports the Synopsys "DesignWare AHB Central DMA Controller",
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw/dw_dmac_regs.h
> similarity index 100%
> rename from drivers/dma/dw_dmac_regs.h
> rename to drivers/dma/dw/dw_dmac_regs.h
> -- 
> 1.8.2.rc0.22.gb3600c3
> 
--
~Vinod
-- 
