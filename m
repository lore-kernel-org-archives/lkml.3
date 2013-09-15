Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab3IOWEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 18:04:47 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:35409 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3IOWEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 18:04:45 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: sa1100: collie.c: fall back to jedec_probe flash detection
Date: Mon, 16 Sep 2013 00:04:42 +0200
Message-Id: <1379282682-26985-1-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zaurus collie contains 2 LH28F640BFHE-PTTL90 (64M 4Mx16) and
at the moment cfi will not detect the collie NOR.
In the meanwhile we can revert to the jedec-probe map which has been
fixed with following commit:

mtd: jedec_probe: fix LH28F640BF definition
fe2f4c8e0bf2756b670ee78fa9772613a2ea8495

Somehow this is unsatisfactory because the flash is mounted READ ONLY
(as from factory, with a RO cramfs)

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

