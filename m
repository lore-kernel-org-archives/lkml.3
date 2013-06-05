Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3FEI4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:56:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57912 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab3FEI4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:56:00 -0400
Message-ID: <51AEFCCE.4040608@ti.com>
Date: Wed, 5 Jun 2013 14:24:38 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: Matt Porter <matt@ohporter.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v9 1/9] ARM: davinci: move private EDMA API to arm/common
References: <1362586540-10393-1-git-send-email-mporter@ti.com> <1362586540-10393-2-git-send-email-mporter@ti.com>
In-Reply-To: <1362586540-10393-2-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 3/6/2013 9:45 PM, Matt Porter wrote:
> Move mach-davinci/dma.c to common/edma.c so it can be used
> by OMAP (specifically AM33xx) as well.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> Acked-by: Sekhar Nori <nsekhar@ti.com>

Can you please ack this movement of davinci private EDMA implementation
to arch/arm/common? I would like to take this patch through davinci tree
for v3.11.

Thanks,
Sekhar

> ---
>  arch/arm/Kconfig                                   |    1 +
>  arch/arm/common/Kconfig                            |    3 +
>  arch/arm/common/Makefile                           |    1 +
>  arch/arm/{mach-davinci/dma.c => common/edma.c}     |    2 +-
>  arch/arm/mach-davinci/Makefile                     |    2 +-
>  arch/arm/mach-davinci/board-tnetv107x-evm.c        |    2 +-
>  arch/arm/mach-davinci/davinci.h                    |    2 +-
>  arch/arm/mach-davinci/devices-tnetv107x.c          |    2 +-
>  arch/arm/mach-davinci/devices.c                    |    6 +-
>  arch/arm/mach-davinci/dm355.c                      |    2 +-
>  arch/arm/mach-davinci/dm365.c                      |    2 +-
>  arch/arm/mach-davinci/dm644x.c                     |    2 +-
>  arch/arm/mach-davinci/dm646x.c                     |    2 +-
>  arch/arm/mach-davinci/include/mach/da8xx.h         |    2 +-
>  drivers/dma/edma.c                                 |    2 +-
>  drivers/mmc/host/davinci_mmc.c                     |    1 +
>  include/linux/mfd/davinci_voicecodec.h             |    3 +-
>  .../mach => include/linux/platform_data}/edma.h    |   89 +-------------------
>  include/linux/platform_data/spi-davinci.h          |    2 +-
>  sound/soc/davinci/davinci-evm.c                    |    1 +
>  sound/soc/davinci/davinci-pcm.c                    |    1 +
>  sound/soc/davinci/davinci-pcm.h                    |    2 +-
>  sound/soc/davinci/davinci-sffsdr.c                 |    5 +-
>  23 files changed, 33 insertions(+), 104 deletions(-)
>  rename arch/arm/{mach-davinci/dma.c => common/edma.c} (99%)
>  rename {arch/arm/mach-davinci/include/mach => include/linux/platform_data}/edma.h (59%)
> 
