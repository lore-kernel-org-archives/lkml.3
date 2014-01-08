Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbaAHIp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:45:56 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:19096
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664AbaAHIpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:45:34 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <kernel@pengutronix.de>, <shawn.guo@linaro.org>,
        <fabio.estevam@freescale.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/2] dma: imx-sdma: Assign a default script number for ROM firmware cases
Date: Wed, 8 Jan 2014 16:45:56 +0800
Message-ID: <1389170756-22351-3-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1389170756-22351-1-git-send-email-Guangyu.Chen@freescale.com>
References: <1389170756-22351-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i.MX series have inner firmware in its ROM code: when SDMA isn't provided
any firmware from Kernel or rootfs, the default inner ROM firmware will be
activated. However the current driver doesn't assign any script number to
this situation, and those platform running in this case would be broken.

Thus this patch adds a default script number when no external firmware being
loaded so that people would continue to be able to use basic scripts to run
their platform without any firmware.

Reported-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 drivers/dma/imx-sdma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 1522476..4e79183 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1252,6 +1252,10 @@ static void sdma_add_scripts(struct sdma_engine *sdma,
 	s32 *saddr_arr = (u32 *)sdma->script_addrs;
 	int i;
 
+	/* use the default firmware in ROM if missing external firmware */
+	if (!sdma->script_number)
+		sdma->script_number = SDMA_SCRIPT_ADDRS_ARRAY_SIZE_V1;
+
 	for (i = 0; i < sdma->script_number; i++)
 		if (addr_arr[i] > 0)
 			saddr_arr[i] = addr_arr[i];
-- 
1.8.4


