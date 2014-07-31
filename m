Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaGaJFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:05:08 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36193 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbaGaJFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:05:06 -0400
From: Arjun Sreedharan <arjun024@gmail.com>
To: rjw@rjwysocki.net
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, rdunlap@infradead.org
Subject: [PATCH] Replace faulty is_hex_digit() by isxdigit()
Date: Thu, 31 Jul 2014 14:34:49 +0530
Message-Id: <1406797489-4296-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <53D9895A.1030902@infradead.org>
References: <53D9895A.1030902@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0 is ascii for NULL. Hex digit matching should be from '0'.
Faulty version returns true for #,$,%,& etc.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 drivers/acpi/acpi_pnp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index 4ddb0dc..996fa19 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -12,6 +12,7 @@
 
 #include <linux/acpi.h>
 #include <linux/module.h>
+#include <linux/ctype.h>
 
 static const struct acpi_device_id acpi_pnp_device_ids[] = {
 	/* soc_button_array */
@@ -320,11 +321,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[] = {
 	{""},
 };
 
-static bool is_hex_digit(char c)
-{
-	return (c >= 0 && c <= '9') || (c >= 'A' && c <= 'F');
-}
-
 static bool matching_id(char *idstr, char *list_id)
 {
 	int i;
@@ -335,7 +331,7 @@ static bool matching_id(char *idstr, char *list_id)
 	for (i = 3; i < 7; i++) {
 		char c = toupper(idstr[i]);
 
-		if (!is_hex_digit(c)
+		if (!isxdigit(c)
 		    || (list_id[i] != 'X' && c != toupper(list_id[i])))
 			return false;
 	}
-- 
1.7.11.7

