Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3HQABU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:01:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51774 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969Ab3HPWkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 069/133] ACPI / battery: Fix parsing _BIX return value
Date: Fri, 16 Aug 2013 15:33:31 -0700
Message-Id: <1376692475-28413-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 016d5baad04269e8559332df05f89bd95b52d6ad upstream.

The _BIX method returns extended battery info as a package.
According the ACPI spec (ACPI 5, Section 10.2.2.2), the first member
of that package should be "Revision".  However, the current ACPI
battery driver treats the first member as "Power Unit" which should
be the second member.  This causes the result of _BIX return data
parsing to be incorrect.

Fix this by adding a new member called 'revision' to struct
acpi_battery and adding the offsetof() information on it to
extended_info_offsets[] as the first row.

[rjw: Changelog]
Reported-and-tested-by: Jan Hoffmann <jan.christian.hoffmann@gmail.com>
References: http://bugzilla.kernel.org/show_bug.cgi?id=60519
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/battery.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 7efaeaa..7663df7 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -117,6 +117,7 @@ struct acpi_battery {
 	struct acpi_device *device;
 	struct notifier_block pm_nb;
 	unsigned long update_time;
+	int revision;
 	int rate_now;
 	int capacity_now;
 	int voltage_now;
@@ -359,6 +360,7 @@ static struct acpi_offsets info_offsets[] = {
 };
 
 static struct acpi_offsets extended_info_offsets[] = {
+	{offsetof(struct acpi_battery, revision), 0},
 	{offsetof(struct acpi_battery, power_unit), 0},
 	{offsetof(struct acpi_battery, design_capacity), 0},
 	{offsetof(struct acpi_battery, full_charge_capacity), 0},
-- 
1.8.1.2

