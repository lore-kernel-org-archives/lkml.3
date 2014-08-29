Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaH2CxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 22:53:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:44897 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaH2CxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 22:53:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,422,1406617200"; 
   d="scan'208";a="591474560"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, lenb@kernel.org, qbanin@gmail.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI/EC: Add msi quirk for Clevo W350etq
Date: Fri, 29 Aug 2014 10:50:08 +0800
Message-Id: <1409280608-19714-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clevo W350etq's EC will not produce GPE interrupt some time after
booting. The ACPI notify event won't trigger when the issue takes
place. After debugging, adding msi quirk for the machine can fix
the issue. This patch is to add msi quirk for the machine.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=77431
Reported-and-tested-by: qbanin@gmail.com
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/ec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index a66ab65..d8535b3 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1015,6 +1015,10 @@ static struct dmi_system_id ec_dmi_table[] __initdata = {
 	DMI_MATCH(DMI_SYS_VENDOR, "Quanta"),
 	DMI_MATCH(DMI_PRODUCT_NAME, "TW9/SW9"),}, NULL},
 	{
+	ec_flag_msi, "Clevo W350etq", {
+	DMI_MATCH(DMI_SYS_VENDOR, "CLEVO CO."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "W35_37ET"),}, NULL},
+	{
 	ec_validate_ecdt, "ASUS hardware", {
 	DMI_MATCH(DMI_BIOS_VENDOR, "ASUS") }, NULL},
 	{
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

