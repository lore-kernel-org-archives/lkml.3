Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaILJGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:06:38 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52231 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbaILJE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:04:59 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] staging: comedi: adl_pci9118: redo DMA buffer allocation
Date: Fri, 12 Sep 2014 10:04:41 +0100
Message-Id: <1410512684-17403-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"adl_pci9118" allocates more pages of DMA buffer than it uses, may
allocate half a double-buffer it does not use because it's the "wrong"
half that it managed to allocate (unlikely), and relies on virt_to_bus()
to treat generic kernel memory from get_free_pages() as coherent DMA
memory.  Correct the issues, using dma_alloc_coherent() to allocate the
DMA buffers.

1) staging: comedi: adl_pci9118: don't allocate 2nd DMA buffer on
   failure
2) staging: comedi: adl_pci9118: don't overallocate DMA buffer
3) staging: comedi: adl_pci9118: use dma_alloc_coherent()

 drivers/staging/comedi/Kconfig               |  2 +-
 drivers/staging/comedi/drivers/adl_pci9118.c | 40 ++++++++++++++--------------
 2 files changed, 21 insertions(+), 21 deletions(-)
