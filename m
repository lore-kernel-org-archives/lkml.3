Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab3JaGct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:32:49 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:29774 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003Ab3JaGcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:32:46 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz154dIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <s.hauer@pengutronix.de>, <timur@tabi.org>, <shawn.guo@linaro.org>,
        <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
Subject: [PATCH v2 0/4] Add dual-fifo mode support of i.MX ssi
Date: Thu, 31 Oct 2013 14:32:02 +0800
Message-ID: <cover.1383197521.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog
v2:
 * Instead of adding rogue scripts to current SDMA driver based on firmware
 * V1, we define the new SDMA firmware as version 2 and bisect the PATCH-1
 * to two patches: The first is to add version check code to the SDMA driver;
 * And the second is to add SSI dual FIFO DMATYPE.
 *
 * Nothing changes for the last two patches.
v1:
 * SSI can reduce hardware overrun/underrun possibility when using dual
 * fifo mode. To support this mode, we need to first update sdma sciprt
 * list, and then enable dual fifo BIT in SSI driver, and last update DT
 * bindings of i.MX series.
 *
 * ! This series of patches has a direct dependency between them. When
 * ! applying them, we need to apply in one single branch. Otherwise,
 * ! it would break currect branches.

Nicolin Chen (4):
  dma: imx-sdma: Add sdma firmware version 2 support
  dma: imx-sdma: Add new dma type for ssi dual fifo script
  ASoC: fsl_ssi: Add dual fifo mode support
  ARM: dts: imx: use dual-fifo sdma script for ssi

 .../devicetree/bindings/dma/fsl-imx-sdma.txt       |  1 +
 arch/arm/boot/dts/imx51.dtsi                       |  4 ++--
 arch/arm/boot/dts/imx53.dtsi                       |  4 ++--
 arch/arm/boot/dts/imx6qdl.dtsi                     | 12 +++++------
 arch/arm/boot/dts/imx6sl.dtsi                      | 12 +++++------
 drivers/dma/imx-sdma.c                             | 19 ++++++++++++++++-
 include/linux/platform_data/dma-imx-sdma.h         |  3 +++
 include/linux/platform_data/dma-imx.h              |  1 +
 sound/soc/fsl/fsl_ssi.c                            | 24 +++++++++++++++++++++-
 9 files changed, 62 insertions(+), 18 deletions(-)

-- 
1.8.4


