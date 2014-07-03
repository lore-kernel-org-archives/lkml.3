Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbaGCKSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:18:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51518 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136AbaGCJVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Enrico Etxe Arte <goitizena.generoa@gmail.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 026/198] ACPI: Fix conflict between customized DSDT and DSDT local copy
Date: Thu,  3 Jul 2014 10:17:49 +0100
Message-Id: <1404379241-8590-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

commit 73577d1df8e1f31f6b1a5eebcdbc334eb0330e47 upstream.

This patch fixes the following issue:
If DSDT is customized, no local DSDT copy is needed.

References: https://bugzilla.kernel.org/show_bug.cgi?id=69711
Signed-off-by: Enrico Etxe Arte <goitizena.generoa@gmail.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
[rjw: Subject]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/bus.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 80d8a2338ce8..ceeac98f443a 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -57,6 +57,12 @@ EXPORT_SYMBOL(acpi_root_dir);
 
 
 #ifdef CONFIG_X86
+#ifdef CONFIG_ACPI_CUSTOM_DSDT
+static inline int set_copy_dsdt(const struct dmi_system_id *id)
+{
+	return 0;
+}
+#else
 static int set_copy_dsdt(const struct dmi_system_id *id)
 {
 	printk(KERN_NOTICE "%s detected - "
@@ -64,6 +70,7 @@ static int set_copy_dsdt(const struct dmi_system_id *id)
 	acpi_gbl_copy_dsdt_locally = 1;
 	return 0;
 }
+#endif
 
 static struct dmi_system_id dsdt_dmi_table[] __initdata = {
 	/*
-- 
1.9.1

