Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3JCOA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:00:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45521 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab3JCOAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:00:23 -0400
Date: Thu, 3 Oct 2013 06:59:44 -0700
From: tip-bot for Dave Jones <tipbot@zytor.com>
Message-ID: <tip-e56e57f6613d5ed5c3127419341d1aa989a11971@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davej@fedoraproject.org, davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davej@fedoraproject.org, tglx@linutronix.de, davej@redhat.com
In-Reply-To: <20131001203655.GA10719@redhat.com>
References: <20131001203655.GA10719@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] x86/reboot: Sort reboot DMI quirks by vendor
Git-Commit-ID: e56e57f6613d5ed5c3127419341d1aa989a11971
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 03 Oct 2013 06:59:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e56e57f6613d5ed5c3127419341d1aa989a11971
Gitweb:     http://git.kernel.org/tip/e56e57f6613d5ed5c3127419341d1aa989a11971
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Tue, 1 Oct 2013 16:36:55 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 2 Oct 2013 08:02:24 +0200

x86/reboot: Sort reboot DMI quirks by vendor

Grouping them by vendor should make it easier to spot duplicates.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Link: http://lkml.kernel.org/r/20131001203655.GA10719@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/reboot.c | 260 +++++++++++++++++++++++++----------------------
 1 file changed, 136 insertions(+), 124 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d9333a4..7692520 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -136,236 +136,248 @@ static int __init set_kbd_reboot(const struct dmi_system_id *d)
  * This is a single dmi_table handling all reboot quirks.
  */
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
-	{	/* Handle problems with rebooting on Dell E520's */
-		.callback = set_bios_reboot,
-		.ident = "Dell E520",
+
+	/* Acer */
+	{	/* Handle reboot issue on Acer Aspire one */
+		.callback = set_kbd_reboot,
+		.ident = "Acer Aspire One A110",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DM061"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell 1300's */
-		.callback = set_bios_reboot,
-		.ident = "Dell PowerEdge 1300",
+
+	/* Apple */
+	{	/* Handle problems with rebooting on Apple MacBook5 */
+		.callback = set_pci_reboot,
+		.ident = "Apple MacBook5",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 1300/"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell 300's */
-		.callback = set_bios_reboot,
-		.ident = "Dell PowerEdge 300",
+	{	/* Handle problems with rebooting on Apple MacBookPro5 */
+		.callback = set_pci_reboot,
+		.ident = "Apple MacBookPro5",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 300/"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell Optiplex 745's SFF */
-		.callback = set_bios_reboot,
-		.ident = "Dell OptiPlex 745",
+	{	/* Handle problems with rebooting on Apple Macmini3,1 */
+		.callback = set_pci_reboot,
+		.ident = "Apple Macmini3,1",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell Optiplex 745's DFF */
-		.callback = set_bios_reboot,
-		.ident = "Dell OptiPlex 745",
+	{	/* Handle problems with rebooting on the iMac9,1. */
+		.callback = set_pci_reboot,
+		.ident = "Apple iMac9,1",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
-			DMI_MATCH(DMI_BOARD_NAME, "0MM599"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell Optiplex 745 with 0KW626 */
+
+	/* ASUS */
+	{	/* Handle problems with rebooting on ASUS P4S800 */
 		.callback = set_bios_reboot,
-		.ident = "Dell OptiPlex 745",
+		.ident = "ASUS P4S800",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
-			DMI_MATCH(DMI_BOARD_NAME, "0KW626"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell Optiplex 330 with 0KP561 */
+
+	/* Dell */
+	{	/* Handle problems with rebooting on Dell DXP061 */
 		.callback = set_bios_reboot,
-		.ident = "Dell OptiPlex 330",
+		.ident = "Dell DXP061",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 330"),
-			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DXP061"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell Optiplex 360 with 0T656F */
+	{	/* Handle problems with rebooting on Dell E520's */
 		.callback = set_bios_reboot,
-		.ident = "Dell OptiPlex 360",
+		.ident = "Dell E520",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 360"),
-			DMI_MATCH(DMI_BOARD_NAME, "0T656F"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DM061"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell OptiPlex 760 with 0G919G */
-		.callback = set_bios_reboot,
-		.ident = "Dell OptiPlex 760",
+	{	/* Handle problems with rebooting on the Latitude E5420. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E5420",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 760"),
-			DMI_MATCH(DMI_BOARD_NAME, "0G919G"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5420"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell 2400's */
-		.callback = set_bios_reboot,
-		.ident = "Dell PowerEdge 2400",
+	{	/* Handle problems with rebooting on the Latitude E6320. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E6320",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 2400"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6320"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell T5400's */
-		.callback = set_bios_reboot,
-		.ident = "Dell Precision T5400",
+	{	/* Handle problems with rebooting on the Latitude E6420. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E6420",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T5400"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell T7400's */
+	{	/* Handle problems with rebooting on Dell Optiplex 330 with 0KP561 */
 		.callback = set_bios_reboot,
-		.ident = "Dell Precision T7400",
+		.ident = "Dell OptiPlex 330",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T7400"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 330"),
+			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),
 		},
 	},
-	{	/* Handle problems with rebooting on HP laptops */
+	{	/* Handle problems with rebooting on Dell Optiplex 360 with 0T656F */
 		.callback = set_bios_reboot,
-		.ident = "HP Compaq Laptop",
+		.ident = "Dell OptiPlex 360",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 360"),
+			DMI_MATCH(DMI_BOARD_NAME, "0T656F"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell XPS710 */
+	{	/* Handle problems with rebooting on Dell Optiplex 745's SFF */
 		.callback = set_bios_reboot,
-		.ident = "Dell XPS710",
+		.ident = "Dell OptiPlex 745",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Dell XPS710"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell DXP061 */
+	{	/* Handle problems with rebooting on Dell Optiplex 745's DFF */
 		.callback = set_bios_reboot,
-		.ident = "Dell DXP061",
+		.ident = "Dell OptiPlex 745",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DXP061"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+			DMI_MATCH(DMI_BOARD_NAME, "0MM599"),
 		},
 	},
-	{	/* Handle problems with rebooting on Sony VGN-Z540N */
+	{	/* Handle problems with rebooting on Dell Optiplex 745 with 0KW626 */
 		.callback = set_bios_reboot,
-		.ident = "Sony VGN-Z540N",
+		.ident = "Dell OptiPlex 745",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+			DMI_MATCH(DMI_BOARD_NAME, "0KW626"),
 		},
 	},
-	{	/* Handle problems with rebooting on ASUS P4S800 */
+	{	/* Handle problems with rebooting on Dell OptiPlex 760 with 0G919G */
 		.callback = set_bios_reboot,
-		.ident = "ASUS P4S800",
+		.ident = "Dell OptiPlex 760",
 		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 760"),
+			DMI_MATCH(DMI_BOARD_NAME, "0G919G"),
 		},
 	},
-
-	{	/* Handle reboot issue on Acer Aspire one */
-		.callback = set_kbd_reboot,
-		.ident = "Acer Aspire One A110",
+	{	/* Handle problems with rebooting on the OptiPlex 990. */
+		.callback = set_pci_reboot,
+		.ident = "Dell OptiPlex 990",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
 		},
 	},
-	{	/* Handle problems with rebooting on Apple MacBook5 */
-		.callback = set_pci_reboot,
-		.ident = "Apple MacBook5",
+	{	/* Handle problems with rebooting on Dell 300's */
+		.callback = set_bios_reboot,
+		.ident = "Dell PowerEdge 300",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 300/"),
 		},
 	},
-	{	/* Handle problems with rebooting on Apple MacBookPro5 */
-		.callback = set_pci_reboot,
-		.ident = "Apple MacBookPro5",
+	{	/* Handle problems with rebooting on Dell 1300's */
+		.callback = set_bios_reboot,
+		.ident = "Dell PowerEdge 1300",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 1300/"),
 		},
 	},
-	{	/* Handle problems with rebooting on Apple Macmini3,1 */
-		.callback = set_pci_reboot,
-		.ident = "Apple Macmini3,1",
+	{	/* Handle problems with rebooting on Dell 2400's */
+		.callback = set_bios_reboot,
+		.ident = "Dell PowerEdge 2400",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 2400"),
 		},
 	},
-	{	/* Handle problems with rebooting on the iMac9,1. */
+	{	/* Handle problems with rebooting on the Dell PowerEdge C6100. */
 		.callback = set_pci_reboot,
-		.ident = "Apple iMac9,1",
+		.ident = "Dell PowerEdge C6100",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Latitude E6320. */
+	{	/* Handle problems with rebooting on the Precision M6600. */
 		.callback = set_pci_reboot,
-		.ident = "Dell Latitude E6320",
+		.ident = "Dell Precision M6600",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6320"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Latitude E5420. */
-		.callback = set_pci_reboot,
-		.ident = "Dell Latitude E5420",
+	{	/* Handle problems with rebooting on Dell T5400's */
+		.callback = set_bios_reboot,
+		.ident = "Dell Precision T5400",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5420"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T5400"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Latitude E6420. */
-		.callback = set_pci_reboot,
-		.ident = "Dell Latitude E6420",
+	{	/* Handle problems with rebooting on Dell T7400's */
+		.callback = set_bios_reboot,
+		.ident = "Dell Precision T7400",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T7400"),
 		},
 	},
-	{	/* Handle problems with rebooting on the OptiPlex 990. */
-		.callback = set_pci_reboot,
-		.ident = "Dell OptiPlex 990",
+	{	/* Handle problems with rebooting on Dell XPS710 */
+		.callback = set_bios_reboot,
+		.ident = "Dell XPS710",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell XPS710"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Precision M6600. */
-		.callback = set_pci_reboot,
-		.ident = "Dell Precision M6600",
+
+	/* Hewlett-Packard */
+	{	/* Handle problems with rebooting on HP laptops */
+		.callback = set_bios_reboot,
+		.ident = "HP Compaq Laptop",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Dell PowerEdge C6100. */
-		.callback = set_pci_reboot,
-		.ident = "Dell PowerEdge C6100",
+
+	/* Sony */
+	{	/* Handle problems with rebooting on Sony VGN-Z540N */
+		.callback = set_bios_reboot,
+		.ident = "Sony VGN-Z540N",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
 		},
 	},
+
 	{ }
 };
 
