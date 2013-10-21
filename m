Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3JUIvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39390 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753475Ab3JUIvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Lan Tianyu" <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.838496135@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 038/149] ACPI / EC: Add ASUSTEK L4R to quirk list in
 order to validate ECDT
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 524f42fab787a9510be826ce3d736b56d454ac6d upstream.

The ECDT of ASUSTEK L4R doesn't provide correct command and data
I/O ports.  The DSDT provides the correct information instead.

For this reason, add this machine to quirk list for ECDT validation
and use the EC information from the DSDT.

[rjw: Changelog]
References: https://bugzilla.kernel.org/show_bug.cgi?id=60765
Reported-and-tested-by: Daniele Esposti <expo@expobrain.net>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/ec.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -964,6 +964,10 @@ static struct dmi_system_id __initdata e
 	ec_enlarge_storm_threshold, "CLEVO hardware", {
 	DMI_MATCH(DMI_SYS_VENDOR, "CLEVO Co."),
 	DMI_MATCH(DMI_PRODUCT_NAME, "M720T/M730T"),}, NULL},
+	{
+	ec_validate_ecdt, "ASUS hardware", {
+	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTek Computer Inc."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "L4R"),}, NULL},
 	{},
 };
 

