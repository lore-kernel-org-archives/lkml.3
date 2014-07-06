Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaGFI6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 04:58:50 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35733 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaGFI6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 04:58:48 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] staging/solo6x10: SOLO6X10 should select BITREVERSE
Date: Sun,  6 Jul 2014 10:58:41 +0200
Message-Id: <1404637121-1253-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_SOLO6X10=y, but CONFIG_BITREVERSE=m:

    drivers/built-in.o: In function `solo_osd_print':
    (.text+0x1c7a1f): undefined reference to `byte_rev_table'
    make: *** [vmlinux] Error 1

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/media/solo6x10/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/solo6x10/Kconfig b/drivers/staging/media/solo6x10/Kconfig
index 6a1906fa1117..1ce2819efcb4 100644
--- a/drivers/staging/media/solo6x10/Kconfig
+++ b/drivers/staging/media/solo6x10/Kconfig
@@ -1,6 +1,7 @@
 config SOLO6X10
 	tristate "Bluecherry / Softlogic 6x10 capture cards (MPEG-4/H.264)"
 	depends on PCI && VIDEO_DEV && SND && I2C
+	select BITREVERSE
 	select FONT_SUPPORT
 	select FONT_8x16
 	select VIDEOBUF2_DMA_SG
-- 
1.9.1

