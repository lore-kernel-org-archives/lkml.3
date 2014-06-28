Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbaF1Sm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:42:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbaF1RuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Enrico Etxe Arte <goitizena.generoa@gmail.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 059/110] ACPI: Fix conflict between customized DSDT and DSDT local copy
Date: Sat, 28 Jun 2014 10:46:56 -0700
Message-Id: <20140628174549.118046518@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/bus.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -52,6 +52,12 @@ struct proc_dir_entry *acpi_root_dir;
 EXPORT_SYMBOL(acpi_root_dir);
 
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
@@ -59,6 +65,7 @@ static int set_copy_dsdt(const struct dm
 	acpi_gbl_copy_dsdt_locally = 1;
 	return 0;
 }
+#endif
 
 static struct dmi_system_id dsdt_dmi_table[] __initdata = {
 	/*


