Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbaGaAGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:06:20 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41638 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaGaAGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:06:18 -0400
From: Arjun Sreedharan <arjun024@gmail.com>
To: rjw@rjwysocki.net
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com
Subject: [PATCH] Replace faulty is_hex_digit() by isxdigit()
Date: Thu, 31 Jul 2014 05:35:55 +0530
Message-Id: <1406765155-22755-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1406750412.12100.65.camel@joe-AO725>
References: <1406750412.12100.65.camel@joe-AO725>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0 is ascii for NULL. Hex digit matching should be from '0'.
Unfixed version returns true for #,$,%,& etc.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 drivers/acpi/acpi_pnp.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index 4ddb0dc..6d5922d 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -320,11 +320,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[] = {
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
@@ -335,7 +330,7 @@ static bool matching_id(char *idstr, char *list_id)
 	for (i = 3; i < 7; i++) {
 		char c = toupper(idstr[i]);
 
-		if (!is_hex_digit(c)
+		if (!isxdigit(c)
 		    || (list_id[i] != 'X' && c != toupper(list_id[i])))
 			return false;
 	}
-- 
1.7.11.7

