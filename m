Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaIPUwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:52:12 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:55365 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbaIPUwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:52:09 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 10/22] ACPI / battery: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:24 +0200
Message-Id: <1410900696-6481-11-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/acpi/battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 5fdfe65..8ec8a89 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -695,7 +695,7 @@ static void acpi_battery_quirks(struct acpi_battery *battery)
 	if (battery->power_unit && dmi_name_in_vendors("LENOVO")) {
 		const char *s;
 		s = dmi_get_system_info(DMI_PRODUCT_VERSION);
-		if (s && !strnicmp(s, "ThinkPad", 8)) {
+		if (s && !strncasecmp(s, "ThinkPad", 8)) {
 			dmi_walk(find_battery, battery);
 			if (test_bit(ACPI_BATTERY_QUIRK_THINKPAD_MAH,
 				     &battery->flags) &&
-- 
2.0.4

