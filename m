Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3EIVFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 17:05:15 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:44246 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3EIVFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 17:05:08 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 09/12] uio: UIO_DMEM_GENIRQ should depend on HAS_DMA
Date: Thu,  9 May 2013 23:04:51 +0200
Message-Id: <1368133494-22198-9-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
References: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `uio_dmem_genirq_release':
drivers/uio/uio_dmem_genirq.c:95: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `uio_dmem_genirq_open':
drivers/uio/uio_dmem_genirq.c:61: undefined reference to `dma_alloc_coherent'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hans J. Koch <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index e92eeaf..5295be0 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -45,6 +45,7 @@ config UIO_PDRV_GENIRQ
 
 config UIO_DMEM_GENIRQ
 	tristate "Userspace platform driver with generic irq and dynamic memory"
+	depends on HAS_DMA
 	help
 	  Platform driver for Userspace I/O devices, including generic
 	  interrupt handling code. Shared interrupts are not supported.
-- 
1.7.0.4

