Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaANLfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:35:06 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:38965 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaANLfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:35:01 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] spi: Clarify (a)synchronous transfer_one()
Date: Tue, 14 Jan 2014 12:34:56 +0100
Message-Id: <1389699296-28994-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 include/linux/spi/spi.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 21a7251d85ee..5319a8510921 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -282,10 +282,12 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
  * @prepare_message: set up the controller to transfer a single message,
  *                   for example doing DMA mapping.  Called from threaded
  *                   context.
- * @transfer_one: transfer a single spi_transfer. When the
- *	          driver is finished with this transfer it must call
- *	          spi_finalize_current_transfer() so the subsystem can issue
- *                the next transfer
+ * @transfer_one: transfer a single spi_transfer.
+ *                Synchronous transfer methods must return 0 on success.
+ *                Asynchronous transfer methods must return a strict-positive
+ *                value on successful submission, and must call
+ *                spi_finalize_current_transfer() when the driver is finished
+ *                so the subsystem can issue the next transfer
  * @unprepare_message: undo any work done by prepare_message().
  * @cs_gpios: Array of GPIOs to use as chip select lines; one per CS
  *	number. Any individual value may be -ENOENT for CS lines that
-- 
1.7.9.5

