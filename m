Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaALM7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 07:59:17 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:55622 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaALM7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 07:59:15 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] spi: Kill superfluous cast in spi_w8r16()
Date: Sun, 12 Jan 2014 13:59:06 +0100
Message-Id: <1389531546-5867-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

spi_write_then_read() takes a "void *" for rxbuf, so there's no need to
cast the buffer pointer to "u8 *".

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 include/linux/spi/spi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 8c62ba74dd91..02a759ef9bc3 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -847,7 +847,7 @@ static inline ssize_t spi_w8r16(struct spi_device *spi, u8 cmd)
 	ssize_t			status;
 	u16			result;
 
-	status = spi_write_then_read(spi, &cmd, 1, (u8 *) &result, 2);
+	status = spi_write_then_read(spi, &cmd, 1, &result, 2);
 
 	/* return negative errno or unsigned value */
 	return (status < 0) ? status : result;
-- 
1.7.9.5

