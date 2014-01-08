Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbaAHIpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:45:34 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:20293
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477AbaAHIpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:45:23 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzdchz1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <kernel@pengutronix.de>, <shawn.guo@linaro.org>,
        <fabio.estevam@freescale.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 0/2] Fix SSI audio function regression when using ROM firmware
Date: Wed, 8 Jan 2014 16:45:54 +0800
Message-ID: <1389170756-22351-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we added dual-fifo script support for SSI and SDMA, meanwhile, we
switched the default script in DT to this new script. However, there're still
quite a few people using the old version or even ROM firmware which means they
don't provide any firmware to SDMA driver. In these cases, the SDMA driver'd
fail to load essential script then the audio function broken.

This series of patches mainly fix this issue by assigning a default script
number for ROM firmware case and reverting the default script in DT so that
all kinds of users would continue to run it with or without firmware.

We might later need to figure out a better solution to ensure both SDMA driver
and SSI driver could adaptively switch the new script to the old one when V2
firmware isn't provided.

This series of patches are based on Vinod's repository.

Nicolin Chen (2):
  Revert "ARM: dts: imx: use dual-fifo sdma script for ssi"
  dma: imx-sdma: Assign a default script number for ROM firmware cases

 arch/arm/boot/dts/imx51.dtsi   |  4 ++--
 arch/arm/boot/dts/imx53.dtsi   |  4 ++--
 arch/arm/boot/dts/imx6qdl.dtsi | 12 ++++++------
 arch/arm/boot/dts/imx6sl.dtsi  | 12 ++++++------
 drivers/dma/imx-sdma.c         |  4 ++++
 5 files changed, 20 insertions(+), 16 deletions(-)

-- 
1.8.4


