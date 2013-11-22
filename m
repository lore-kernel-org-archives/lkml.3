Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab3KVQiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:38:46 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:51069
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755654Ab3KVQim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:38:42 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI154dI1432I14ffIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h17326ah8275dh1de097h186068hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h1155h)
Date: Sat, 23 Nov 2013 00:31:32 +0800
From: Nicolin Chen <b42378@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <s.hauer@pengutronix.de>, <timur@tabi.org>, <shawn.guo@linaro.org>,
        <broonie@kernel.org>
CC: <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <pawel.moll@arm.com>,
        <linux-doc@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <dmaengine@vger.kernel.org>, <ijc+devicetree@hellion.org.uk>,
        <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 0/4] Add dual-fifo mode support of i.MX ssi
Message-ID: <20131122163132.GB17344@MrMyself>
References: <cover.1384352281.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1384352281.git.b42378@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

   I'm sorry to push this. But this series has been an orphan for a while.
   Could any one please receive and foster it?

Thank you.
Nicolin Chen

On Wed, Nov 13, 2013 at 10:55:23PM +0800, Nicolin Chen wrote:
>  * ! This series of patches has a direct dependency between them. When
>  * ! applying them, we need to apply to one single branch. Otherwise,
>  * ! it would break currect branches.
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
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

