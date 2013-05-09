Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3EIMBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:01:15 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:37137 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab3EIMBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:01:14 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrey Smirnov <andrew.smirnov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mfd: si476x: Use get_unaligned_be16() for unaligned be16 loads
Date: Thu,  9 May 2013 14:01:05 +0200
Message-Id: <1368100865-16025-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loading be16 values from byte buffers may cause unaligned accesses, so use
get_unaligned_be16() to avoid problems on architectures that do not support
these.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mfd/si476x-cmd.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/si476x-cmd.c b/drivers/mfd/si476x-cmd.c
index f12f016..6f1ef63 100644
--- a/drivers/mfd/si476x-cmd.c
+++ b/drivers/mfd/si476x-cmd.c
@@ -29,6 +29,8 @@
 
 #include <linux/mfd/si476x-core.h>
 
+#include <asm/unaligned.h>
+
 #define msb(x)                  ((u8)((u16) x >> 8))
 #define lsb(x)                  ((u8)((u16) x &  0x00FF))
 
@@ -483,7 +485,7 @@ int si476x_core_cmd_get_property(struct si476x_core *core, u16 property)
 	if (err < 0)
 		return err;
 	else
-		return be16_to_cpup((__be16 *)(resp + 2));
+		return get_unaligned_be16(resp + 2);
 }
 EXPORT_SYMBOL_GPL(si476x_core_cmd_get_property);
 
@@ -783,7 +785,7 @@ int si476x_core_cmd_am_rsq_status(struct si476x_core *core,
 	report->afcrl		= 0x02 & resp[2];
 	report->valid		= 0x01 & resp[2];
 
-	report->readfreq	= be16_to_cpup((__be16 *)(resp + 3));
+	report->readfreq	= get_unaligned_be16(resp + 3);
 	report->freqoff		= resp[5];
 	report->rssi		= resp[6];
 	report->snr		= resp[7];
@@ -944,7 +946,7 @@ int si476x_core_cmd_fm_rds_status(struct si476x_core *core,
 	report->tp		= 0x20 & resp[3];
 	report->pty		= 0x1f & resp[3];
 
-	report->pi		= be16_to_cpup((__be16 *)(resp + 4));
+	report->pi		= get_unaligned_be16(resp + 4);
 	report->rdsfifoused	= resp[6];
 
 	report->ble[V4L2_RDS_BLOCK_A]	= 0xc0 & resp[7];
@@ -991,9 +993,9 @@ int si476x_core_cmd_fm_rds_blockcount(struct si476x_core *core,
 				       SI476X_DEFAULT_TIMEOUT);
 
 	if (!err) {
-		report->expected	= be16_to_cpup((__be16 *)(resp + 2));
-		report->received	= be16_to_cpup((__be16 *)(resp + 4));
-		report->uncorrectable	= be16_to_cpup((__be16 *)(resp + 6));
+		report->expected	= get_unaligned_be16(resp + 2);
+		report->received	= get_unaligned_be16(resp + 4);
+		report->uncorrectable	= get_unaligned_be16(resp + 6);
 	}
 
 	return err;
@@ -1210,7 +1212,7 @@ static int si476x_core_cmd_fm_rsq_status_a10(struct si476x_core *core,
 	report->afcrl		= 0x02 & resp[2];
 	report->valid		= 0x01 & resp[2];
 
-	report->readfreq	= be16_to_cpup((__be16 *)(resp + 3));
+	report->readfreq	= get_unaligned_be16(resp + 3);
 	report->freqoff		= resp[5];
 	report->rssi		= resp[6];
 	report->snr		= resp[7];
@@ -1218,7 +1220,7 @@ static int si476x_core_cmd_fm_rsq_status_a10(struct si476x_core *core,
 	report->hassi		= resp[10];
 	report->mult		= resp[11];
 	report->dev		= resp[12];
-	report->readantcap	= be16_to_cpup((__be16 *)(resp + 13));
+	report->readantcap	= get_unaligned_be16(resp + 13);
 	report->assi		= resp[15];
 	report->usn		= resp[16];
 
@@ -1264,7 +1266,7 @@ static int si476x_core_cmd_fm_rsq_status_a20(struct si476x_core *core,
 	report->afcrl		= 0x02 & resp[2];
 	report->valid		= 0x01 & resp[2];
 
-	report->readfreq	= be16_to_cpup((__be16 *)(resp + 3));
+	report->readfreq	= get_unaligned_be16(resp + 3);
 	report->freqoff		= resp[5];
 	report->rssi		= resp[6];
 	report->snr		= resp[7];
@@ -1272,7 +1274,7 @@ static int si476x_core_cmd_fm_rsq_status_a20(struct si476x_core *core,
 	report->hassi		= resp[10];
 	report->mult		= resp[11];
 	report->dev		= resp[12];
-	report->readantcap	= be16_to_cpup((__be16 *)(resp + 13));
+	report->readantcap	= get_unaligned_be16(resp + 13);
 	report->assi		= resp[15];
 	report->usn		= resp[16];
 
@@ -1320,7 +1322,7 @@ static int si476x_core_cmd_fm_rsq_status_a30(struct si476x_core *core,
 	report->afcrl		= 0x02 & resp[2];
 	report->valid		= 0x01 & resp[2];
 
-	report->readfreq	= be16_to_cpup((__be16 *)(resp + 3));
+	report->readfreq	= get_unaligned_be16(resp + 3);
 	report->freqoff		= resp[5];
 	report->rssi		= resp[6];
 	report->snr		= resp[7];
@@ -1329,7 +1331,7 @@ static int si476x_core_cmd_fm_rsq_status_a30(struct si476x_core *core,
 	report->hassi		= resp[10];
 	report->mult		= resp[11];
 	report->dev		= resp[12];
-	report->readantcap	= be16_to_cpup((__be16 *)(resp + 13));
+	report->readantcap	= get_unaligned_be16(resp + 13);
 	report->assi		= resp[15];
 	report->usn		= resp[16];
 
@@ -1337,7 +1339,7 @@ static int si476x_core_cmd_fm_rsq_status_a30(struct si476x_core *core,
 	report->rdsdev		= resp[18];
 	report->assidev		= resp[19];
 	report->strongdev	= resp[20];
-	report->rdspi		= be16_to_cpup((__be16 *)(resp + 21));
+	report->rdspi		= get_unaligned_be16(resp + 21);
 
 	return err;
 }
-- 
1.7.0.4

