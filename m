Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaAPGLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:11:12 -0500
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:59046
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbaAPGLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:11:10 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21a7h1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: <hongbo.zhang@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <scottwood@freescale.com>, <LeoLi@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH] DMA: Freescale: change BWC from 256 bytes to 1024 bytes
Date: Thu, 16 Jan 2014 14:10:53 +0800
Message-ID: <1389852653-8806-1-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

Freescale DMA has a feature of BandWidth Control (ab. BWC), which is currently
256 bytes and should be changed to 1024 bytes for best DMA throughput.
Changing BWC from 256 to 1024 will improve DMA performance much, in cases
whatever one channel is running or multi channels are running simultanously,
large or small buffers are copied.  And this change doesn't impact memory
access performance remarkably, lmbench tests show that for some cases the
memory performance are decreased very slightly, while the others are even
better.
Tested on T4240.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
---
 drivers/dma/fsldma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index 1ffc244..d56e835 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -41,7 +41,7 @@
  * channel is allowed to transfer before the DMA engine pauses
  * the current channel and switches to the next channel
  */
-#define FSL_DMA_MR_BWC         0x08000000
+#define FSL_DMA_MR_BWC         0x0A000000
 
 /* Special MR definition for MPC8349 */
 #define FSL_DMA_MR_EOTIE	0x00000080
-- 
1.7.9.5



