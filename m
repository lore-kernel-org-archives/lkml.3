Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaBTOnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:43:52 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:39897 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaBTOn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:43:26 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 03/10] spi: sh-msiof: Change hz from unsigned long to u32
Date: Thu, 20 Feb 2014 15:43:02 +0100
Message-Id: <1392907389-21798-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Both spi_transfer.speed_hz and spi_master.max_speed_hz are u32

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-sh-msiof.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index cc12e755131d..af9f2db41b16 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -144,8 +144,7 @@ static struct {
 };
 
 static void sh_msiof_spi_set_clk_regs(struct sh_msiof_spi_priv *p,
-				      unsigned long parent_rate,
-				      unsigned long spi_hz)
+				      unsigned long parent_rate, u32 spi_hz)
 {
 	unsigned long div = 1024;
 	size_t k;
@@ -372,10 +371,9 @@ static int sh_msiof_spi_bits(struct spi_device *spi, struct spi_transfer *t)
 	return bits;
 }
 
-static unsigned long sh_msiof_spi_hz(struct spi_device *spi,
-				     struct spi_transfer *t)
+static u32 sh_msiof_spi_hz(struct spi_device *spi, struct spi_transfer *t)
 {
-	unsigned long hz;
+	u32 hz;
 
 	hz = t ? t->speed_hz : 0;
 	if (!hz)
-- 
1.7.9.5

