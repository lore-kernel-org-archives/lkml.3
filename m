Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab3K1Jig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:38:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:20766 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab3K1Jia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:38:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,789,1378882800"; 
   d="scan'208";a="435566594"
Date: Thu, 28 Nov 2013 14:11:09 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolin Chen <b42378@freescale.com>
Cc: dan.j.williams@intel.com, s.hauer@pengutronix.de, timur@tabi.org,
        shawn.guo@linaro.org, broonie@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, rob.herring@calxeda.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk
Subject: Re: [PATCH v7 0/4] Add dual-fifo mode support of i.MX ssi
Message-ID: <20131128084108.GZ8834@intel.com>
References: <cover.1384352281.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384352281.git.b42378@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 10:55:23PM +0800, Nicolin Chen wrote:
>  * ! This series of patches has a direct dependency between them. When
>  * ! applying them, we need to apply to one single branch. Otherwise,
>  * ! it would break currect branches.
Applied, thanks

--
~Vinod
> 
> Changelog
> v7:
>  * Appended missing Acked-by to all four patches.
>  * Sorry that I didn't add them at the first place.
> v6:
>  * PATCH-1: Use goto err_firmware instead of return directly.
>  *
>  * Nothing changes for the other three ack-ed patches
> v5:
>  * PATCH-3: Add period size constraint when using dual fifo mode
>  *
>  * Nothing changes for the other three patches
> v4:
>  * PATCH-3: Drop useless register configuration.
>  *
>  * Nothing changes for the other three patches
> v3:
>  * PATCH-1: Add comments to indicate the end of v1 and v2 array.
>  * PATCH-3: Use better way to keep watermark as even number.
>  *
>  * Nothing changes for PATCH-2 and PATCH-4
> v2:
>  * Instead of adding rogue scripts to current SDMA driver based on firmware
>  * V1, we define the new SDMA firmware as version 2 and bisect the PATCH-1
>  * to two patches: The first is to add version check code to the SDMA driver;
>  * And the second is to add SSI dual FIFO DMATYPE.
>  *
>  * Nothing changes for the last two patches.
> v1:
>  * SSI can reduce hardware overrun/underrun possibility when using dual
>  * fifo mode. To support this mode, we need to first update sdma sciprt
>  * list, and then enable dual fifo BIT in SSI driver, and last update DT
>  * bindings of i.MX series.
> 
> Nicolin Chen (4):
>   dma: imx-sdma: Add sdma firmware version 2 support
>   dma: imx-sdma: Add new dma type for ssi dual fifo script
>   ASoC: fsl_ssi: Add dual fifo mode support
>   ARM: dts: imx: use dual-fifo sdma script for ssi
> 
>  .../devicetree/bindings/dma/fsl-imx-sdma.txt       |  1 +
>  arch/arm/boot/dts/imx51.dtsi                       |  4 ++--
>  arch/arm/boot/dts/imx53.dtsi                       |  4 ++--
>  arch/arm/boot/dts/imx6qdl.dtsi                     | 12 +++++-----
>  arch/arm/boot/dts/imx6sl.dtsi                      | 12 +++++-----
>  drivers/dma/imx-sdma.c                             | 19 ++++++++++++++-
>  include/linux/platform_data/dma-imx-sdma.h         |  5 ++++
>  include/linux/platform_data/dma-imx.h              |  1 +
>  sound/soc/fsl/fsl_ssi.c                            | 27 +++++++++++++++++++++-
>  9 files changed, 67 insertions(+), 18 deletions(-)
> 
> -- 
> 1.8.4
> 
> 

-- 
