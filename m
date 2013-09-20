Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab3ITUO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:14:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41676 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3ITUOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 36/93] ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT
Date: Fri, 20 Sep 2013 13:08:31 -0700
Message-Id: <1379707768-1804-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/ec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index bbb6d47..0b58c9d 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -987,6 +987,10 @@ static struct dmi_system_id __initdata ec_dmi_table[] = {
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
1.8.1.2

