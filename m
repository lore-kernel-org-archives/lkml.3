Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbaF1TVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:21:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52806 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaF1RrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Enrico Etxe Arte <goitizena.generoa@gmail.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.4 29/43] ACPI: Fix conflict between customized DSDT and DSDT local copy
Date: Sat, 28 Jun 2014 10:46:20 -0700
Message-Id: <20140628174451.131244730@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
References: <20140628174449.788784511@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -64,6 +70,7 @@ static int set_copy_dsdt(const struct dm
 	acpi_gbl_copy_dsdt_locally = 1;
 	return 0;
 }
+#endif
 
 static struct dmi_system_id dsdt_dmi_table[] __initdata = {
 	/*


