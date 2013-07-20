Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3GTXHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 19:07:39 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53081 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3GTXHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 19:07:37 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: jedec_probe: fix LH28F640BF definition
Date: Sun, 21 Jul 2013 01:07:33 +0200
Message-Id: <1374361653-3004-1-git-send-email-andrea.adami@gmail.com>
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
 drivers/mtd/chips/jedec_probe.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index c443f52..7c0b27d 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -120,7 +120,7 @@
 #define PM49FL008	0x006A
 
 /* Sharp */
-#define LH28F640BF	0x00b0
+#define LH28F640BF	0x00B0
 
 /* ST - www.st.com */
 #define M29F800AB	0x0058
@@ -1299,13 +1299,14 @@ static const struct amd_flash_info jedec_table[] = {
 		.mfr_id		= CFI_MFR_SHARP,
 		.dev_id		= LH28F640BF,
 		.name		= "LH28F640BF",
-		.devtypes	= CFI_DEVICETYPE_X8,
+		.devtypes	= CFI_DEVICETYPE_X16,
 		.uaddr		= MTD_UADDR_UNNECESSARY,
-		.dev_size	= SIZE_4MiB,
-		.cmd_set	= P_ID_INTEL_STD,
-		.nr_regions	= 1,
+		.dev_size	= SIZE_8MiB,
+		.cmd_set	= P_ID_INTEL_EXT,
+		.nr_regions	= 2,
 		.regions	= {
-			ERASEINFO(0x40000,16),
+			ERASEINFO(0x10000, 127),
+			ERASEINFO(0x02000, 8),
 		}
 	}, {
 		.mfr_id		= CFI_MFR_SST,
-- 
1.8.1.5

