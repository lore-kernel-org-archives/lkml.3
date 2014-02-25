Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaBYLLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:11:52 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:44892 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaBYLLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:11:51 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] mtd: m25p80: Enable Dual and Quad SPI read transfers for s25sl032p
Date: Tue, 25 Feb 2014 12:11:46 +0100
Message-Id: <1393326706-17979-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Spansion s25sl032p supports Dual and Quad SPI transfers, hence set the
M25P80_DUAL_READ and M25P80_QUAD_READ flags.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/mtd/devices/m25p80.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 0b9a3ca310f7..1b2ec49cceea 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -957,7 +957,7 @@ static const struct spi_device_id m25p_ids[] = {
 	/* Spansion -- single (large) sector size only, at least
 	 * for the chips listed here (without boot sectors).
 	 */
-	{ "s25sl032p",  INFO(0x010215, 0x4d00,  64 * 1024,  64, 0) },
+	{ "s25sl032p",  INFO(0x010215, 0x4d00,  64 * 1024,  64, M25P80_DUAL_READ | M25P80_QUAD_READ) },
 	{ "s25sl064p",  INFO(0x010216, 0x4d00,  64 * 1024, 128, 0) },
 	{ "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, 0) },
 	{ "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512, M25P80_DUAL_READ | M25P80_QUAD_READ) },
-- 
1.7.9.5

