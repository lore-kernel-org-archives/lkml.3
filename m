Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaEGHCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:02:15 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:50661 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaEGHCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:02:14 -0400
From: Christian Gmeiner <christian.gmeiner@gmail.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH] x86/reboot: Add reboot quirk for Certec BPC600
Date: Wed,  7 May 2014 09:01:54 +0200
Message-Id: <1399446114-2147-1-git-send-email-christian.gmeiner@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certec BPC600 needs reboot=pci to actually reboot.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 arch/x86/kernel/reboot.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 3399d3a..52b1157 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -191,6 +191,16 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 		},
 	},
 
+	/* Certec */
+	{       /* Handle problems with rebooting on Certec BPC600 */
+		.callback = set_pci_reboot,
+		.ident = "Certec BPC600",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Certec"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "BPC600"),
+		},
+	},
+
 	/* Dell */
 	{	/* Handle problems with rebooting on Dell DXP061 */
 		.callback = set_bios_reboot,
-- 
1.9.1

