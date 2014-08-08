Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbaHHLCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:02:43 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50659 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbaHHLCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:02:41 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: Add missing kerneldoc bits
Date: Fri,  8 Aug 2014 13:02:36 +0200
Message-Id: <1407495756-19331-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

These are all arguments or fields that got added without updating the
kerneldoc comments.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/spi/spi.c       | 1 +
 include/linux/spi/spi.h | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index e0531baf2782..ca935df80c88 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -848,6 +848,7 @@ out:
 
 /**
  * spi_finalize_current_transfer - report completion of a transfer
+ * @master: the master reporting completion
  *
  * Called by SPI drivers using the core transfer_one_message()
  * implementation to notify it that the current interrupt driven
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index e713543336f1..46d188a9947c 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -253,6 +253,7 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
  *	the device whose settings are being modified.
  * @transfer: adds a message to the controller's transfer queue.
  * @cleanup: frees controller-specific state
+ * @can_dma: determine whether this master supports DMA
  * @queued: whether this master is providing an internal message queue
  * @kworker: thread struct for message pump
  * @kworker_task: pointer to task for message pump kworker thread
@@ -262,6 +263,7 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
  * @cur_msg: the currently in-flight message
  * @cur_msg_prepared: spi_prepare_message was called for the currently
  *                    in-flight message
+ * @cur_msg_mapped: message has been mapped for DMA
  * @xfer_completion: used by core transfer_one_message()
  * @busy: message pump is busy
  * @running: message pump is running
@@ -299,6 +301,10 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
  * @cs_gpios: Array of GPIOs to use as chip select lines; one per CS
  *	number. Any individual value may be -ENOENT for CS lines that
  *	are not GPIOs (driven by the SPI controller itself).
+ * @dma_tx: DMA transmit channel
+ * @dma_rx: DMA receive channel
+ * @dummy_rx: dummy receive buffer for full-duplex devices
+ * @dummy_tx: dummy transmit buffer for full-duplex devices
  *
  * Each SPI master controller can communicate with one or more @spi_device
  * children.  These make a small bus, sharing MOSI, MISO and SCK signals
@@ -632,6 +638,7 @@ struct spi_transfer {
  *	addresses for each transfer buffer
  * @complete: called to report transaction completions
  * @context: the argument to complete() when it's called
+ * @frame_length: the total number of bytes in the message
  * @actual_length: the total number of bytes that were transferred in all
  *	successful segments
  * @status: zero for success, else negative errno
-- 
2.0.4

