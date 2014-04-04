Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaDDDaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:30:17 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:30984 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbaDDD2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:28:01 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch21a7h1fc6h208chzdchz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: <hongbo.zhang@freescale.com>
To: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v2 0/8] DMA: Freescale: driver cleanups and enhancements
Date: Fri, 4 Apr 2014 11:27:09 +0800
Message-ID: <1396582037-23065-1-git-send-email-hongbo.zhang@freescale.com>
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

Hi Vinod Koul,
Please have a look at the v2 patch set.

v1 -> v2 change:
The only one change is introducing a new patch[1/7] to remove the unnecessary
macro FSL_DMA_LD_DEBUG, thus the total patches number is 8 now (was 7)

Hongbo Zhang (8):
  DMA: Freescale: remove the unnecessary FSL_DMA_LD_DEBUG
  DMA: Freescale: unify register access methods
  DMA: Freescale: remove attribute DMA_INTERRUPT of dmaengine
  DMA: Freescale: add fsl_dma_free_descriptor() to reduce code
    duplication
  DMA: Freescale: move functions to avoid forward declarations
  DMA: Freescale: change descriptor release process for supporting
    async_tx
  DMA: Freescale: use spin_lock_bh instead of spin_lock_irqsave
  DMA: Freescale: add suspend resume functions for DMA driver

 drivers/dma/fsldma.c |  590 ++++++++++++++++++++++++++++++++------------------
 drivers/dma/fsldma.h |   33 ++-
 2 files changed, 408 insertions(+), 215 deletions(-)

-- 
1.7.9.5



