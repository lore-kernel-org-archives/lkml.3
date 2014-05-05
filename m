Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbaEEM51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:57:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40995 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932255AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 25/50] ACPI / sleep: remove panic in case hardware has changed after S4
Date: Mon,  5 May 2014 14:43:07 +0200
Message-Id: <43c5512d313281d04a91531aa205fac9aa2995a2.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oneukum@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5c551e624abba6782034edd5b9eb58ac6f146b38 upstream.

Some BIOSes change hardware based on the state of
a laptop's lid. If the lid is closed, the touchpad is
disabled and the checksum changes. Windows 8 no longer
aborts resume if the checksum has changed.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
[rjw: Use pr_crit() for the message and don't break the string]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/acpi/sleep.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 99e5158456d8..c09e6f646fe4 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -675,11 +675,8 @@ static void acpi_hibernation_leave(void)
 	/* Reprogram control registers */
 	acpi_leave_sleep_state_prep(ACPI_STATE_S4);
 	/* Check the hardware signature */
-	if (facs && s4_hardware_signature != facs->hardware_signature) {
-		printk(KERN_EMERG "ACPI: Hardware changed while hibernated, "
-			"cannot resume!\n");
-		panic("ACPI S4 hardware signature mismatch");
-	}
+	if (facs && s4_hardware_signature != facs->hardware_signature)
+		pr_crit("ACPI: Hardware changed while hibernated, success doubtful!\n");
 	/* Restore the NVS memory area */
 	suspend_nvs_restore();
 	/* Allow EC transactions to happen. */
-- 
1.9.2

