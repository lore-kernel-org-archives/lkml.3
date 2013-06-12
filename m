Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab3FLIxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:53:42 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:60422 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab3FLIxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:53:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130612081202.GK4107@intel.com>
References: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1370435206-13474-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130612050829.GB4107@intel.com>
	<CAHp75Ver2xo2f9crQZkAmJcTF=5cZZa3NgvufPqQW3+uTXffJA@mail.gmail.com>
	<20130612073806.GG4107@intel.com>
	<CAHp75VfsSDdLa_uPULbhVGproxnD5mofYm62O75y4xRbPBJ7pQ@mail.gmail.com>
	<20130612075225.GI4107@intel.com>
	<CAHp75Vc=hO_FF0WMvhPm6MMRuCb+=MhOEOCSYb_TaCRf-xQ=sg@mail.gmail.com>
	<20130612081202.GK4107@intel.com>
Date: Wed, 12 Jun 2013 14:23:39 +0530
Message-ID: <CAKohpok8jyUF33hatMJzLwokHM2Ou=N8rHQ4oQ5xQ2AiSSN__w@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] dma: move dw_dmac driver to an own directory
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2013 13:42, Vinod Koul <vinod.koul@intel.com> wrote:

> Never mind, am applying your patches and below fix, let me if you guys are okay

I am not :)

> diff --git a/drivers/dma/dw/Kconfig b/drivers/dma/dw/Kconfig
> index db2b41f..7be1cf8 100644
> --- a/drivers/dma/dw/Kconfig
> +++ b/drivers/dma/dw/Kconfig
> @@ -10,6 +10,7 @@ config DW_DMAC_CORE
>  config DW_DMAC
>         tristate "Synopsys DesignWare AHB DMA platform driver"
>         select DW_DMAC_CORE
> +       select DW_DMAC_BIG_ENDIAN_IO if ARCH=AVR32
>         default y if CPU_AT32AP7000
>         help
>           Support the Synopsys DesignWare AHB DMA controller. This
> @@ -25,12 +26,4 @@ config DW_DMAC_PCI
>           Intel Medfield has integrated this GPDMA controller.
>
>  config DW_DMAC_BIG_ENDIAN_IO
> -       bool "Use big endian I/O register access"
> -       default y if AVR32
> -       depends on DW_DMAC_CORE
> -       help
> -         Say yes here to use big endian I/O access when reading and writing
> -         to the DMA controller registers. This is needed on some platforms,
> -         like the Atmel AVR32 architecture.

This information was useful to understand this config option and must
be kept in some way.
