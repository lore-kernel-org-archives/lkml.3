Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab3IHDT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56126 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756148Ab3IHDSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Lan Tianyu" <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.616770126@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [050/121] ACPI / battery: Fix parsing _BIX return value
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/battery.c | 2 ++
 1 file changed, 2 insertions(+)

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
@@ -350,6 +351,7 @@ static struct acpi_offsets info_offsets[
 };
 
 static struct acpi_offsets extended_info_offsets[] = {
+	{offsetof(struct acpi_battery, revision), 0},
 	{offsetof(struct acpi_battery, power_unit), 0},
 	{offsetof(struct acpi_battery, design_capacity), 0},
 	{offsetof(struct acpi_battery, full_charge_capacity), 0},

