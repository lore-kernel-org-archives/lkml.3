Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934750AbaDJHU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:20:29 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:38372
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934241AbaDJHU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:20:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzdchz1de098h8275bh1de097hz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26b9h26d3h1155h)
Message-ID: <5346462B.1080902@freescale.com>
Date: Thu, 10 Apr 2014 15:20:11 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>
CC: <scottwood@freescale.com>, <leo.li@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/8] DMA: Freescale: driver cleanups and enhancements
References: <1397113805-24171-1-git-send-email-hongbo.zhang@freescale.com> <1397113805-24171-2-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1397113805-24171-2-git-send-email-hongbo.zhang@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, forgot the cover letter, plus it here.


From: Hongbo Zhang <hongbo.zhang@freescale.com>
Date: Thu, 10 Apr 2014 15:16:31 +0800
Subject: [PATCH v3 0/8] DMA: Freescale: driver cleanups and enhancements

Hi Vinod Koul,
Please have a look at the v3 patch set.

v2 -> v3 change:
Only add "chan->pm_state = RUNNING" for patch[8/8].

v1 -> v2 change:
The only one change is introducing a new patch[1/7] to remove the 
unnecessary
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

  drivers/dma/fsldma.c |  591 
++++++++++++++++++++++++++++++++------------------
  drivers/dma/fsldma.h |   33 ++-
  2 files changed, 409 insertions(+), 215 deletions(-)




