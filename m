Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbaGPKpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:45:07 -0400
Received: from mail-wg0-f67.google.com ([74.125.82.67]:55226 "EHLO
	mail-wg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaGPKpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:45:03 -0400
From: Samarth Parikh <samarthp@ymail.com>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        torvalds@linux-foundation.org
Subject: [PATCH] Drivers: MTD: Fixed checkpatch seq_printf warnings
Date: Wed, 16 Jul 2014 16:14:37 +0530
Message-Id: <1405507477-46794-1-git-send-email-samarthp@ymail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch warnings: "WARNING: Prefer seq_puts to seq_printf"

This patch is created with reference to the ongoing lkml thread
https://lkml.org/lkml/2014/7/15/646
where Andrew Morton wrote:

"
- puts is presumably faster

- puts doesn't go rogue if you accidentally pass it a "%".

- this patch would actually make compiled object files few bytes smaller.
  Perhaps because seq_printf() is a varargs function, forcing the
  caller to pass args on the stack instead of in registers.
"

Signed-off-by: Samarth Parikh <samarthp@ymail.com>
---
 drivers/mtd/devices/docg3.c | 26 +++++++++++++-------------
 drivers/mtd/mtdswap.c       |  4 ++--
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 91a169c..21cc4b6 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -1697,16 +1697,16 @@ static int dbg_asicmode_show(struct seq_file *s, void *p)

 	switch (mode) {
 	case DOC_ASICMODE_RESET:
-		pos += seq_printf(s, "reset");
+		pos += seq_puts(s, "reset");
 		break;
 	case DOC_ASICMODE_NORMAL:
-		pos += seq_printf(s, "normal");
+		pos += seq_puts(s, "normal");
 		break;
 	case DOC_ASICMODE_POWERDOWN:
-		pos += seq_printf(s, "powerdown");
+		pos += seq_puts(s, "powerdown");
 		break;
 	}
-	pos += seq_printf(s, ")\n");
+	pos += seq_puts(s, ")\n");
 	return pos;
 }
 DEBUGFS_RO_ATTR(asic_mode, dbg_asicmode_show);
@@ -1745,22 +1745,22 @@ static int dbg_protection_show(struct seq_file *s, void *p)
 	pos += seq_printf(s, "Protection = 0x%02x (",
 			 protect);
 	if (protect & DOC_PROTECT_FOUNDRY_OTP_LOCK)
-		pos += seq_printf(s, "FOUNDRY_OTP_LOCK,");
+		pos += seq_puts(s, "FOUNDRY_OTP_LOCK,");
 	if (protect & DOC_PROTECT_CUSTOMER_OTP_LOCK)
-		pos += seq_printf(s, "CUSTOMER_OTP_LOCK,");
+		pos += seq_puts(s, "CUSTOMER_OTP_LOCK,");
 	if (protect & DOC_PROTECT_LOCK_INPUT)
-		pos += seq_printf(s, "LOCK_INPUT,");
+		pos += seq_puts(s, "LOCK_INPUT,");
 	if (protect & DOC_PROTECT_STICKY_LOCK)
-		pos += seq_printf(s, "STICKY_LOCK,");
+		pos += seq_puts(s, "STICKY_LOCK,");
 	if (protect & DOC_PROTECT_PROTECTION_ENABLED)
-		pos += seq_printf(s, "PROTECTION ON,");
+		pos += seq_puts(s, "PROTECTION ON,");
 	if (protect & DOC_PROTECT_IPL_DOWNLOAD_LOCK)
-		pos += seq_printf(s, "IPL_DOWNLOAD_LOCK,");
+		pos += seq_puts(s, "IPL_DOWNLOAD_LOCK,");
 	if (protect & DOC_PROTECT_PROTECTION_ERROR)
-		pos += seq_printf(s, "PROTECT_ERR,");
+		pos += seq_puts(s, "PROTECT_ERR,");
 	else
-		pos += seq_printf(s, "NO_PROTECT_ERR");
-	pos += seq_printf(s, ")\n");
+		pos += seq_puts(s, "NO_PROTECT_ERR");
+	pos += seq_puts(s, ")\n");

 	pos += seq_printf(s, "DPS0 = 0x%02x : "
 			 "Protected area [0x%x - 0x%x] : OTP=%d, READ=%d, "
diff --git a/drivers/mtd/mtdswap.c b/drivers/mtd/mtdswap.c
index 8b33b26..0ec96cd 100644
--- a/drivers/mtd/mtdswap.c
+++ b/drivers/mtd/mtdswap.c
@@ -1287,7 +1287,7 @@ static int mtdswap_show(struct seq_file *s, void *data)

 	seq_printf(s, "total erasures: %lu\n", sum);

-	seq_printf(s, "\n");
+	seq_puts(s, "\n");

 	seq_printf(s, "mtdswap_readsect count: %llu\n", d->sect_read_count);
 	seq_printf(s, "mtdswap_writesect count: %llu\n", d->sect_write_count);
@@ -1296,7 +1296,7 @@ static int mtdswap_show(struct seq_file *s, void *data)
 	seq_printf(s, "mtd write count: %llu\n", d->mtd_write_count);
 	seq_printf(s, "discarded pages count: %llu\n", d->discard_page_count);

-	seq_printf(s, "\n");
+	seq_puts(s, "\n");
 	seq_printf(s, "total pages: %u\n", pages);
 	seq_printf(s, "pages mapped: %u\n", mapped);

--
1.9.1

