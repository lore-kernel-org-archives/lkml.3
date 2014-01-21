Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaAUPK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:10:29 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:60128 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbaAUPKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:10:21 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 3/5] spi: Correct set_cs() documentation
Date: Tue, 21 Jan 2014 16:10:07 +0100
Message-Id: <1390317009-8292-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
References: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

The documentation for spi_master.set_cs() says:

    assert or deassert chip select, true to assert

i.e. its "enable" parameter uses assertion-level logic.

This does not match the implementation of spi_set_cs(), which calls
spi_master.set_cs() with the wanted logic level of the chip select line,
which depends on the polarity of the chip select signal.

Correct the documentation to match the implementation.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2: Changed documentation instead of implementation

 include/linux/spi/spi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index ba69940a6515..a1d4ca290862 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -277,7 +277,7 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
  * @unprepare_transfer_hardware: there are currently no more messages on the
  *	queue so the subsystem notifies the driver that it may relax the
  *	hardware by issuing this call
- * @set_cs: assert or deassert chip select, true to assert.  May be called
+ * @set_cs: set the logic level of the chip select line.  May be called
  *          from interrupt context.
  * @prepare_message: set up the controller to transfer a single message,
  *                   for example doing DMA mapping.  Called from threaded
-- 
1.7.9.5

