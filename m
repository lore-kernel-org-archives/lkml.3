Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaK0V5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:57:46 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:49510 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaK0V5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:57:44 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "David S. Miller" <davem@davemloft.net>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: ide: Fix mostly harmless off-by-one hardcoded value
Date: Thu, 27 Nov 2014 22:57:29 +0100
Message-Id: <1417125449-6007-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The string "IOMEGA Clik!" has length 12, not 11. Using strstarts
avoids the error-prone hardcoding of the prefix length. For
consistency, also change the occurence just above.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/ide/ide-floppy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3d42043..8c6363c 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -487,7 +487,7 @@ static void ide_floppy_setup(ide_drive_t *drive)
 	 * it. It should be fixed as of version 1.9, but to be on the safe side
 	 * we'll leave the limitation below for the 2.2.x tree.
 	 */
-	if (!strncmp((char *)&id[ATA_ID_PROD], "IOMEGA ZIP 100 ATAPI", 20)) {
+	if (strstarts((char *)&id[ATA_ID_PROD], "IOMEGA ZIP 100 ATAPI")) {
 		drive->atapi_flags |= IDE_AFLAG_ZIP_DRIVE;
 		/* This value will be visible in the /proc/ide/hdx/settings */
 		drive->pc_delay = IDEFLOPPY_PC_DELAY;
@@ -498,7 +498,7 @@ static void ide_floppy_setup(ide_drive_t *drive)
 	 * Guess what? The IOMEGA Clik! drive also needs the above fix. It makes
 	 * nasty clicking noises without it, so please don't remove this.
 	 */
-	if (strncmp((char *)&id[ATA_ID_PROD], "IOMEGA Clik!", 11) == 0) {
+	if (strstarts((char *)&id[ATA_ID_PROD], "IOMEGA Clik!")) {
 		blk_queue_max_hw_sectors(drive->queue, 64);
 		drive->atapi_flags |= IDE_AFLAG_CLIK_DRIVE;
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-- 
2.0.4

