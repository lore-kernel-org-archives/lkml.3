Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab3EIWmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:42:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab3EIWev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:34:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Bilski?= <rafalbilski@interia.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 11/26] cpufreq / Longhaul: Disable driver by default
Date: Thu,  9 May 2013 15:34:25 -0700
Message-Id: <20130509223423.608549561@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509223422.368544659@linuxfoundation.org>
References: <20130509223422.368544659@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Bilski <rafalbilski@interia.pl>

commit b5811bc469c0dbebb4f947800b9b234a9c0a68dc upstream.

This is only solution I can think of. User decides if he wants this
driver on his machine. I don't have enough knowledge and time to find
the reason why same code works on some machines and doesn't on others
which use the same, or very similar, chipset and processor.

Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/longhaul.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

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
@@ -1021,6 +1025,10 @@ MODULE_PARM_DESC(scale_voltage, "Scale v
  * such. */
 module_param(revid_errata, int, 0644);
 MODULE_PARM_DESC(revid_errata, "Ignore CPU Revision ID");
+/* By default driver is disabled to prevent incompatible
+ * system freeze. */
+module_param(enable, int, 0644);
+MODULE_PARM_DESC(enable, "Enable driver");
 
 MODULE_AUTHOR("Dave Jones <davej@redhat.com>");
 MODULE_DESCRIPTION("Longhaul driver for VIA Cyrix processors.");


