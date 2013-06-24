Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3FXKTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:19:14 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55604 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3FXKTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:19:11 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18sxNNfmA7ET6vE37NPRRPM
Date: Mon, 24 Jun 2013 03:19:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Joel A Fernandes <joelagnel@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v12 00/11] DMA Engine support for AM33XX
Message-ID: <20130624101903.GV5523@atomide.com>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For merging this series, I suggest the following sets:

* Joel A Fernandes <joelagnel@ti.com> [130620 14:13]:
> 
> Joel A Fernandes (3):
>   edma: config: Enable config options for EDMA
>   da8xx: config: Enable MMC and FS options
>   ARM: davinci: Fix compiler warnings in devices-da8xx
>
> Matt Porter (8):
>   dmaengine: edma: Add TI EDMA device tree binding
>   ARM: edma: Add DT and runtime PM support to the private EDMA API
>   ARM: edma: Add EDMA crossbar event mux support
>   dmaengine: edma: enable build for AM33XX

Sekhar should queue the above patches, I've acked the
mach-omap2/Kconfig change.

>   spi: omap2-mcspi: add generic DMA request support to the DT binding
>   spi: omap2-mcspi: convert to dma_request_slave_channel_compat()


The spi changes should get merged via the driver list.

>   ARM: dts: add AM33XX EDMA support
>   ARM: dts: add AM33XX SPI DMA support

Benoit should queue the .dts changes.
 
>  Documentation/devicetree/bindings/dma/ti-edma.txt  |   34 +++
>  Documentation/devicetree/bindings/spi/omap-spi.txt |   27 ++-
>  arch/arm/Kconfig                                   |    1 +
>  arch/arm/boot/dts/am33xx.dtsi                      |   22 ++
>  arch/arm/common/edma.c                             |  242 ++++++++++++++++++--
>  arch/arm/configs/da8xx_omapl_defconfig             |    3 +
>  arch/arm/mach-davinci/devices-da8xx.c              |    8 +-
>  arch/arm/mach-omap2/Kconfig                        |    2 +
>  drivers/dma/Kconfig                                |    4 +-
>  drivers/spi/spi-omap2-mcspi.c                      |   64 ++++--
>  include/linux/platform_data/edma.h                 |    5 +-
>  11 files changed, 369 insertions(+), 43 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt

Regards,

Tony
