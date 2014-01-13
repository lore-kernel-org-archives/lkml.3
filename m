Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaAMKXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:23:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:7637 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaAMKXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:23:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,651,1384329600"; 
   d="scan'208";a="437950426"
Date: Mon, 13 Jan 2014 14:52:26 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: dan.j.williams@intel.com, kernel@pengutronix.de, shawn.guo@linaro.org,
        fabio.estevam@freescale.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Fix SSI audio function regression when using ROM
 firmware
Message-ID: <20140113092226.GE25466@intel.com>
References: <1389170756-22351-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389170756-22351-1-git-send-email-Guangyu.Chen@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 04:45:54PM +0800, Nicolin Chen wrote:
> Previously we added dual-fifo script support for SSI and SDMA, meanwhile, we
> switched the default script in DT to this new script. However, there're still
> quite a few people using the old version or even ROM firmware which means they
> don't provide any firmware to SDMA driver. In these cases, the SDMA driver'd
> fail to load essential script then the audio function broken.
> 
> This series of patches mainly fix this issue by assigning a default script
> number for ROM firmware case and reverting the default script in DT so that
> all kinds of users would continue to run it with or without firmware.
> 
> We might later need to figure out a better solution to ensure both SDMA driver
> and SSI driver could adaptively switch the new script to the old one when V2
> firmware isn't provided.

Applied both,

Thanks

--
~Vinod
> 
> This series of patches are based on Vinod's repository.
> 
> Nicolin Chen (2):
>   Revert "ARM: dts: imx: use dual-fifo sdma script for ssi"
>   dma: imx-sdma: Assign a default script number for ROM firmware cases
> 
>  arch/arm/boot/dts/imx51.dtsi   |  4 ++--
>  arch/arm/boot/dts/imx53.dtsi   |  4 ++--
>  arch/arm/boot/dts/imx6qdl.dtsi | 12 ++++++------
>  arch/arm/boot/dts/imx6sl.dtsi  | 12 ++++++------
>  drivers/dma/imx-sdma.c         |  4 ++++
>  5 files changed, 20 insertions(+), 16 deletions(-)
> 
> -- 
> 1.8.4
> 
> 

-- 
