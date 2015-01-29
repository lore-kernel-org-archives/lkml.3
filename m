Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbbA2OfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:35:15 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:61527 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbbA2OfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:35:13 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To: matt.fleming@intel.com, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH] firmware: efi: remove unneeded guid unparse
Date: Thu, 29 Jan 2015 16:35:02 +0200
Message-Id: <1422542102-19348-1-git-send-email-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to translate guid number to string here.
So remove it in order to not do unneeded work.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/firmware/efi/efi.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9035c1b..f6be017 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -272,15 +272,10 @@ static __init int match_config_table(efi_guid_t *guid,
 				     unsigned long table,
 				     efi_config_table_type_t *table_types)
 {
-	u8 str[EFI_VARIABLE_GUID_LEN + 1];
 	int i;
 
 	if (table_types) {
-		efi_guid_unparse(guid, str);
-
 		for (i = 0; efi_guidcmp(table_types[i].guid, NULL_GUID); i++) {
-			efi_guid_unparse(&table_types[i].guid, str);
-
 			if (!efi_guidcmp(*guid, table_types[i].guid)) {
 				*(table_types[i].ptr) = table;
 				pr_cont(" %s=0x%lx ",
-- 
1.9.1

