Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaBTOn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:43:29 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:46141 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaBTOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:43:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 01/10] spi: sh-msiof: Fix SPI bus population from DT
Date: Thu, 20 Feb 2014 15:43:00 +0100
Message-Id: <1392907389-21798-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

DT doesn't instantiate SPI children if spi_master.dev.of_node is not set up
properly.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: devicetree@vger.kernel.org
---
 drivers/spi/spi-sh-msiof.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 33474061b742..e6f79b2f2616 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -710,6 +710,7 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 	master->mode_bits |= SPI_LSB_FIRST | SPI_3WIRE;
 	master->flags = 0;
 	master->bus_num = pdev->id;
+	master->dev.of_node = pdev->dev.of_node;
 	master->num_chipselect = p->info->num_chipselect;
 	master->setup = spi_bitbang_setup;
 	master->cleanup = spi_bitbang_cleanup;
-- 
1.7.9.5

