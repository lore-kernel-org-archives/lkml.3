Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaJVTN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:13:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63764 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbaJVTNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:13:23 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] eeepc-laptop: define rfkill notifier nodes only once
Date: Wed, 22 Oct 2014 21:12:38 +0200
Message-Id: <1414005163-3461-4-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rfkill notifier node names are used in three different places. As a
matter of style, it is better to store them somewhere and have the
compiler warn us about typos in the function arguments.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 6e3be01..e92ea41 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -819,11 +819,15 @@ static int eeepc_new_rfkill(struct eeepc_laptop *eeepc,
 	return 0;
 }
 
+static char EEEPC_RFKILL_NODE_1[] = "\\_SB.PCI0.P0P5";
+static char EEEPC_RFKILL_NODE_2[] = "\\_SB.PCI0.P0P6";
+static char EEEPC_RFKILL_NODE_3[] = "\\_SB.PCI0.P0P7";
+
 static void eeepc_rfkill_exit(struct eeepc_laptop *eeepc)
 {
-	eeepc_unregister_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P5");
-	eeepc_unregister_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P6");
-	eeepc_unregister_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P7");
+	eeepc_unregister_rfkill_notifier(eeepc, EEEPC_RFKILL_NODE_1);
+	eeepc_unregister_rfkill_notifier(eeepc, EEEPC_RFKILL_NODE_2);
+	eeepc_unregister_rfkill_notifier(eeepc, EEEPC_RFKILL_NODE_3);
 	if (eeepc->wlan_rfkill) {
 		rfkill_unregister(eeepc->wlan_rfkill);
 		rfkill_destroy(eeepc->wlan_rfkill);
@@ -895,9 +899,9 @@ static int eeepc_rfkill_init(struct eeepc_laptop *eeepc)
 	if (result == -EBUSY)
 		result = 0;
 
-	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P5");
-	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P6");
-	eeepc_register_rfkill_notifier(eeepc, "\\_SB.PCI0.P0P7");
+	eeepc_register_rfkill_notifier(eeepc, EEEPC_RFKILL_NODE_1);
+	eeepc_register_rfkill_notifier(eeepc, EEEPC_RFKILL_NODE_2);
+	eeepc_register_rfkill_notifier(eeepc, EEEPC_RFKILL_NODE_3);
 
 exit:
 	if (result && result != -ENODEV)
@@ -933,9 +937,9 @@ static int eeepc_hotk_restore(struct device *device)
 
 	/* Refresh both wlan rfkill state and pci hotplug */
 	if (eeepc->wlan_rfkill) {
-		eeepc_rfkill_hotplug_update(eeepc, "\\_SB.PCI0.P0P5");
-		eeepc_rfkill_hotplug_update(eeepc, "\\_SB.PCI0.P0P6");
-		eeepc_rfkill_hotplug_update(eeepc, "\\_SB.PCI0.P0P7");
+		eeepc_rfkill_hotplug_update(eeepc, EEEPC_RFKILL_NODE_1);
+		eeepc_rfkill_hotplug_update(eeepc, EEEPC_RFKILL_NODE_2);
+		eeepc_rfkill_hotplug_update(eeepc, EEEPC_RFKILL_NODE_3);
 	}
 
 	if (eeepc->bluetooth_rfkill)
-- 
2.1.0

