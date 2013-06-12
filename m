Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3FLJAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:00:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:12965 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab3FLJAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:00:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,850,1363158000"; 
   d="scan'208";a="348602220"
Message-ID: <1371027632.29283.332.camel@smile>
Subject: Re: [PATCH v2 2/4] dma: move dw_dmac driver to an own directory
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>, Hein Tibosch <hein@htibosch.net>
Date: Wed, 12 Jun 2013 12:00:32 +0300
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
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+ Hein]

On Wed, 2013-06-12 at 13:42 +0530, Vinod Koul wrote: 
> On Wed, Jun 12, 2013 at 11:38:37AM +0300, Andy Shevchenko wrote:
> > On Wed, Jun 12, 2013 at 10:52 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > > On Wed, Jun 12, 2013 at 11:27:51AM +0300, Andy Shevchenko wrote:
> > >> On Wed, Jun 12, 2013 at 10:39 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > >>
> > >> []
> > >>
> > >> > Something like
> > >> > config DW_DMAC_BIG_ENDIAN_IO
> > >> >         tristate
> > >> >
> > >> > config DW_DMAC
> > >> >         select DW_DMAC_BIG_ENDIAN_IO
> > >> >
> > >> > I belive DW_DMAC is for AVR support and the PCI ones is different right.
> > >> > The point is that these things should be selected by the required symbols based
> > >> > on what ARCH we are on and not be prompted for user to configure via menuconfig
> > >>
> > >> DW_DMAC is a generic platform driver which supports AVR32, ARM and
> > >> Intel (ACPI case) platforms.
> > >>
> > >> We may do that option invisible to user
> > > Yup
> > >>
> > >> and then use
> > >>
> > >> config DW_DMAC
> > >>          select DW_DMAC_BIG_ENDIAN_IO if ARCH=AVR32
> > > Thats would be the right way
> > 
> > Do you prefer to have this as separate patch or integrated in the split?
> > In my humble opinion I better to do separate patch.
> Never mind, am applying your patches and below fix, let me if you guys are okay


As far as I know we have at least one developer (Hein Tibosch) with such
board. Let him share his opinion.

> 
> diff --git a/drivers/dma/dw/Kconfig b/drivers/dma/dw/Kconfig
> index db2b41f..7be1cf8 100644
> --- a/drivers/dma/dw/Kconfig
> +++ b/drivers/dma/dw/Kconfig
> @@ -10,6 +10,7 @@ config DW_DMAC_CORE
>  config DW_DMAC
>  	tristate "Synopsys DesignWare AHB DMA platform driver"
>  	select DW_DMAC_CORE
> +	select DW_DMAC_BIG_ENDIAN_IO if ARCH=AVR32
>  	default y if CPU_AT32AP7000
>  	help
>  	  Support the Synopsys DesignWare AHB DMA controller. This
> @@ -25,12 +26,4 @@ config DW_DMAC_PCI
>  	  Intel Medfield has integrated this GPDMA controller.
>  
>  config DW_DMAC_BIG_ENDIAN_IO
> -	bool "Use big endian I/O register access"
> -	default y if AVR32
> -	depends on DW_DMAC_CORE
> -	help
> -	  Say yes here to use big endian I/O access when reading and writing
> -	  to the DMA controller registers. This is needed on some platforms,
> -	  like the Atmel AVR32 architecture.
> -
> -	  If unsure, use the default setting.
> +	bool
> -
> 
> --
> ~Vinod

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
