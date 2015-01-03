Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbbACWAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 17:00:24 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:46347 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbbACWAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 17:00:21 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] g_NCR5380: Kill compiler warning if builtin
Date: Sat,  3 Jan 2015 23:00:16 +0100
Message-Id: <1420322416-13960-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_SCSI_GENERIC_NCR5380=y:

drivers/scsi/g_NCR5380.c:727: warning: ‘id_table’ defined but not used

In the non-modular case, MODULE_DEVICE_TABLE() expands to nothing, and
id_table is not referenced.

Correct the existing #ifdef to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/g_NCR5380.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index f35792f7051c0884..74ec2f5669aba5f5 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -723,7 +723,7 @@ module_param(ncr_53c400a, int, 0);
 module_param(dtc_3181e, int, 0);
 MODULE_LICENSE("GPL");
 
-#ifndef SCSI_G_NCR5380_MEM
+#if !defined(SCSI_G_NCR5380_MEM) && defined(MODULE)
 static struct isapnp_device_id id_table[] = {
 	{
 	 ISAPNP_ANY_ID, ISAPNP_ANY_ID,
-- 
1.9.1

