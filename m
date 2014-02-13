Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaBMJy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:54:56 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59746 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaBMJyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:54:53 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: matt.fleming@intel.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] firmware/efi : use NULL instead of 0 for pointer
Date: Thu, 13 Feb 2014 18:54:48 +0900
Message-ID: <2817765.zrQqrE3135@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1c70573009a3b50cef2acaae1e5a8cd350edfe6d Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Thu, 13 Feb 2014 17:16:36 +0900
Subject: [PATCH] firmware/efi : use NULL instead of 0 for pointer

following sparse warnings:

drivers/firmware/efi/efivars.c:230:66: warning:
 Using plain integer as NULL pointer
drivers/firmware/efi/efi.c:236:27: warning:
 Using plain integer as NULL pointer

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/firmware/efi/efi.c     |    2 +-
 drivers/firmware/efi/efivars.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 4753bac..d85187f 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -233,7 +233,7 @@ static __initdata efi_config_table_type_t common_tables[] = 
{
 	{SAL_SYSTEM_TABLE_GUID, "SALsystab", &efi.sal_systab},
 	{SMBIOS_TABLE_GUID, "SMBIOS", &efi.smbios},
 	{UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
-	{NULL_GUID, NULL, 0},
+	{NULL_GUID, NULL, NULL},
 };
 
 static __init int match_config_table(efi_guid_t *guid,
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 3dc2482..50ea412 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -227,7 +227,7 @@ efivar_store_raw(struct efivar_entry *entry, const char 
*buf, size_t count)
 	memcpy(&entry->var, new_var, count);
 
 	err = efivar_entry_set(entry, new_var->Attributes,
-			       new_var->DataSize, new_var->Data, false);
+			       new_var->DataSize, new_var->Data, NULL);
 	if (err) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%d\n", 
err);
 		return -EIO;
-- 
1.7.9.5


