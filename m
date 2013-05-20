Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab3ETLKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:10:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56191 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab3ETKxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Rafa=C5=82=20Bilski?= <rafalbilski@interia.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 058/115] cpufreq / Longhaul: Disable driver by default
Date: Mon, 20 May 2013 11:50:58 +0100
Message-Id: <1369047116-9378-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Rafa=C5=82=20Bilski?= <rafalbilski@interia.pl>

commit b5811bc469c0dbebb4f947800b9b234a9c0a68dc upstream.

This is only solution I can think of. User decides if he wants this
driver on his machine. I don't have enough knowledge and time to find
the reason why same code works on some machines and doesn't on others
which use the same, or very similar, chipset and processor.

Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/longhaul.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 53ddbc7..0bf5bd1 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -77,7 +77,7 @@ static unsigned int longhaul_index;
 static int scale_voltage;
 static int disable_acpi_c3;
 static int revid_errata;
-
+static int enable;
 
 /* Clock ratios multiplied by 10 */
 static int mults[32];
@@ -965,6 +965,10 @@ static int __init longhaul_init(void)
 	if (!x86_match_cpu(longhaul_id))
 		return -ENODEV;
 
+	if (!enable) {
+		printk(KERN_ERR PFX "Option \"enable\" not set. Aborting.\n");
+		return -ENODEV;
+	}
 #ifdef CONFIG_SMP
 	if (num_online_cpus() > 1) {
 		printk(KERN_ERR PFX "More than 1 CPU detected, "
@@ -1021,6 +1025,10 @@ MODULE_PARM_DESC(scale_voltage, "Scale voltage of processor");
  * such. */
 module_param(revid_errata, int, 0644);
 MODULE_PARM_DESC(revid_errata, "Ignore CPU Revision ID");
+/* By default driver is disabled to prevent incompatible
+ * system freeze. */
+module_param(enable, int, 0644);
+MODULE_PARM_DESC(enable, "Enable driver");
 
 MODULE_AUTHOR("Dave Jones <davej@redhat.com>");
 MODULE_DESCRIPTION("Longhaul driver for VIA Cyrix processors.");
-- 
1.8.1.2

