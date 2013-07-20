Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab3GTXH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 19:07:59 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:59784 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3GTXHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 19:07:40 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] sa1100: collie: fall back to jedec_probe flash detection
Date: Sun, 21 Jul 2013 01:07:36 +0200
Message-Id: <1374361656-3034-1-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zaurus 5500 contains 2 LH28F640BFHE-PTTL90 (64M 4Mx16) and
the LH28F640BFHE-PTTL90.pdf datasheet available on the net shows
the exact erasesize and the OTP support.
At the moment only jedec_probe can discover the chip and
the NOR is mounted read only probably because of wrong vpp.

Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 arch/arm/mach-sa1100/collie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-sa1100/collie.c b/arch/arm/mach-sa1100/collie.c
index 612a456..7fb96eb 100644
--- a/arch/arm/mach-sa1100/collie.c
+++ b/arch/arm/mach-sa1100/collie.c
@@ -289,7 +289,7 @@ static void collie_flash_exit(void)
 }
 
 static struct flash_platform_data collie_flash_data = {
-	.map_name	= "cfi_probe",
+	.map_name	= "jedec_probe",
 	.init		= collie_flash_init,
 	.set_vpp	= collie_set_vpp,
 	.exit		= collie_flash_exit,
-- 
1.8.1.5

