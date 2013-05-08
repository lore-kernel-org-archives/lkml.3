Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3EHXLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:11:43 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52877 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3EHXLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:11:41 -0400
From: GBGamer <npmazzuca@gmail.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        GBGamer <nicholas@mazzucastuff.com>
Subject: ACPI: battery: Made sure all spaces were in correct places
Date: Wed,  8 May 2013 16:11:15 -0700
Message-Id: <1368054675-5168-1-git-send-email-nicholas@mazzucastuff.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added or removed any spaces that gave errors or warnings in checkpatch.pl

Signed-off-by: Nicholas Mazzuca <nicholas@mazzucastuff.com>
---
 drivers/acpi/battery.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 3c1784b..082b4dd 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -425,7 +425,7 @@ static int acpi_battery_get_info(struct acpi_battery *battery)
 {
 	int result = -EFAULT;
 	acpi_status status = 0;
-	char *name = test_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags)?
+	char *name = test_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags) ?
 			"_BIX" : "_BIF";
 
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -661,11 +661,11 @@ static void find_battery(const struct dmi_header *dm, void *private)
 static void acpi_battery_quirks(struct acpi_battery *battery)
 {
 	if (test_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags))
-		return ;
+		return;
 
 	if (battery->full_charge_capacity == 100 &&
 		battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN &&
-		battery->capacity_now >=0 && battery->capacity_now <= 100) {
+		battery->capacity_now >= 0 && battery->capacity_now <= 100) {
 		set_bit(ACPI_BATTERY_QUIRK_PERCENTAGE_CAPACITY, &battery->flags);
 		battery->full_charge_capacity = battery->design_capacity;
 		battery->capacity_now = (battery->capacity_now *
@@ -673,7 +673,7 @@ static void acpi_battery_quirks(struct acpi_battery *battery)
 	}
 
 	if (test_bit(ACPI_BATTERY_QUIRK_THINKPAD_MAH, &battery->flags))
-		return ;
+		return;
 
 	if (battery->power_unit && dmi_name_in_vendors("LENOVO")) {
 		const char *s;
@@ -761,7 +761,7 @@ static int acpi_battery_print_info(struct seq_file *seq, int result)
 		goto end;
 
 	seq_printf(seq, "present:                 %s\n",
-		   acpi_battery_present(battery)?"yes":"no");
+		   acpi_battery_present(battery) ? "yes" : "no");
 	if (!acpi_battery_present(battery))
 		goto end;
 	if (battery->design_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
@@ -817,12 +817,12 @@ static int acpi_battery_print_state(struct seq_file *seq, int result)
 		goto end;
 
 	seq_printf(seq, "present:                 %s\n",
-		   acpi_battery_present(battery)?"yes":"no");
+		   acpi_battery_present(battery) ? "yes" : "no");
 	if (!acpi_battery_present(battery))
 		goto end;
 
 	seq_printf(seq, "capacity state:          %s\n",
-			(battery->state & 0x04)?"critical":"ok");
+			(battery->state & 0x04) ? "critical" : "ok");
 	if ((battery->state & 0x01) && (battery->state & 0x02))
 		seq_printf(seq,
 			   "charging state:          charging/discharging\n");
-- 
1.7.9.5

