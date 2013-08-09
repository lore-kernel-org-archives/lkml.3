Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030385Ab3HICJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:09:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967685Ab3HIB7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 066/102] ACPI / battery: Fix parsing _BIX return value
Date: Thu,  8 Aug 2013 18:57:42 -0700
Message-Id: <20130809015025.729003734@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/battery.c |    2 ++
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
@@ -359,6 +360,7 @@ static struct acpi_offsets info_offsets[
 };
 
 static struct acpi_offsets extended_info_offsets[] = {
+	{offsetof(struct acpi_battery, revision), 0},
 	{offsetof(struct acpi_battery, power_unit), 0},
 	{offsetof(struct acpi_battery, design_capacity), 0},
 	{offsetof(struct acpi_battery, full_charge_capacity), 0},


