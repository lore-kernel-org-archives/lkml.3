Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3ITUVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:21:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41655 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3ITUOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 35/93] ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to skip DSDT scan
Date: Fri, 20 Sep 2013 13:08:30 -0700
Message-Id: <1379707768-1804-36-git-send-email-kamal@canonical.com>
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

commit eff9a4b62b14cf0d9913e3caf1f26f8b7a6105c9 upstream.

HP Folio 13's BIOS defines CMOS RTC Operation Region and the EC's
_REG method will access that region.  To allow the CMOS RTC region
handler to be installed before the EC _REG method is first invoked,
add ec_skip_dsdt_scan() as HP Folio 13's callback to ec_dmi_table.

References: https://bugzilla.kernel.org/show_bug.cgi?id=54621
Reported-and-tested-by: Stefan Nagy <public@stefan-nagy.at>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/ec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index a563e11..bbb6d47 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -983,6 +983,10 @@ static struct dmi_system_id __initdata ec_dmi_table[] = {
 	ec_enlarge_storm_threshold, "CLEVO hardware", {
 	DMI_MATCH(DMI_SYS_VENDOR, "CLEVO Co."),
 	DMI_MATCH(DMI_PRODUCT_NAME, "M720T/M730T"),}, NULL},
+	{
+	ec_skip_dsdt_scan, "HP Folio 13", {
+	DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+	DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13"),}, NULL},
 	{},
 };
 
-- 
1.8.1.2

