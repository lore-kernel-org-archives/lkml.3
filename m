Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3I3KMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:12:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43445 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3I3KMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 024/104] ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT
Date: Mon, 30 Sep 2013 11:10:01 +0100
Message-Id: <1380535881-9239-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/ec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 3251d4b..d1a9674 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -978,6 +978,10 @@ static struct dmi_system_id __initdata ec_dmi_table[] = {
 	ec_skip_dsdt_scan, "HP Folio 13", {
 	DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
 	DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13"),}, NULL},
+	{
+	ec_validate_ecdt, "ASUS hardware", {
+	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTek Computer Inc."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "L4R"),}, NULL},
 	{},
 };
 
-- 
1.8.3.2

