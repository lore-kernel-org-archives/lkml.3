Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaALKbC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 05:31:02 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:60591 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaALKa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 05:30:58 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] sh: sh7757: switch RSPI clock to dev ID match
Date: Sun, 12 Jan 2014 11:30:49 +0100
Message-Id: <1389522649-1753-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Switch the RSPI MSTP clock on SH7757 from a con ID match to a dev ID
match, so we can start looking it up using clk_get() with a NULL ID.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
Untested, as I don't have the hardware, but this is a prerequisite for
"spi: rspi: Use NULL as the clock ID".

 arch/sh/kernel/cpu/sh4a/clock-sh7757.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/kernel/cpu/sh4a/clock-sh7757.c b/arch/sh/kernel/cpu/sh4a/clock-sh7757.c
index e84a43229b9c..5c0e3c335161 100644
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7757.c
+++ b/arch/sh/kernel/cpu/sh4a/clock-sh7757.c
@@ -132,7 +132,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("usb_fck", &mstp_clks[MSTP103]),
 	CLKDEV_DEV_ID("renesas_usbhs.0", &mstp_clks[MSTP102]),
 	CLKDEV_CON_ID("mmc0", &mstp_clks[MSTP220]),
-	CLKDEV_CON_ID("rspi2", &mstp_clks[MSTP127]),
+	CLKDEV_DEV_ID("rspi.2", &mstp_clks[MSTP127]),
 };
 
 int __init arch_clk_init(void)
-- 
1.7.9.5

