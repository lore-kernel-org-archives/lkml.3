Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaILLU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:20:26 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:53157 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbaILLUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:20:24 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] staging: comedi: addi_apci_3120: redo DMA buffer allocation
Date: Fri, 12 Sep 2014 12:19:53 +0100
Message-Id: <1410520797-17824-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"addi_apci_3120" allocates more pages of DMA buffer than it uses, may
allocate half a double-buffer it does not use because it's the "wrong"
half that it managed to allocate (unlikely), and relies on virt_to_bus()
to treat generic kernel memory from get_free_pages() as coherent DMA
memory.  Correct the issues, using dma_alloc_coherent() to allocate the
DMA buffers.

1) staging: comedi: addi_apci_3120: don't allocate 2nd DMA buffer on
   failure
2) staging: comedi: addi_apci_3120: don't overallocate DMA buffer
3) staging: comedi: addi_apci_3120: use dma_alloc_coherent()
4) staging: comedi: addi_apci_3120: simplify setting of
   devpriv->us_UseDma

 drivers/staging/comedi/Kconfig                     |  2 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |  3 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c    | 44 ++++++++++------------
 3 files changed, 22 insertions(+), 27 deletions(-)
