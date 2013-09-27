Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3I0UdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:33:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab3I0UdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:33:18 -0400
Date: Fri, 27 Sep 2013 16:33:08 -0400
From: Dave Jones <davej@redhat.com>
To: x86@kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: x86: sort reboot DMI quirks by vendor.
Message-ID: <20130927203308.GB22836@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grouping them by vendor should make it easier to spot duplicates.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e643e74..12521b2 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -136,244 +136,255 @@ static int __init set_kbd_reboot(const struct dmi_system_id *d)
  * This is a single dmi_table handling all reboot quirks.
  */
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
-	{	/* Handle problems with rebooting on Dell E520's */
-		.callback = set_bios_reboot,
-		.ident = "Dell E520",
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
+
+	/* ASUS */
+	{	/* Handle problems with rebooting on ASUS P4S800 */
 		.callback = set_bios_reboot,
-		.ident = "Dell PowerEdge 1300",
+		.ident = "ASUS P4S800",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 1300/"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell 300's */
-		.callback = set_bios_reboot,
-		.ident = "Dell PowerEdge 300",
+
+	/* Apple */
+	{	/* Handle problems with rebooting on Apple MacBook5 */
+		.callback = set_pci_reboot,
+		.ident = "Apple MacBook5",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 300/"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell Optiplex 745's SFF */
-		.callback = set_bios_reboot,
-		.ident = "Dell OptiPlex 745",
+	{	/* Handle problems with rebooting on Apple MacBookPro5 */
+		.callback = set_pci_reboot,
+		.ident = "Apple MacBookPro5",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell Optiplex 745's DFF */
-		.callback = set_bios_reboot,
-		.ident = "Dell OptiPlex 745",
+	{	/* Handle problems with rebooting on Apple Macmini3,1 */
+		.callback = set_pci_reboot,
+		.ident = "Apple Macmini3,1",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
-			DMI_MATCH(DMI_BOARD_NAME, "0MM599"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell Optiplex 745 with 0KW626 */
-		.callback = set_bios_reboot,
-		.ident = "Dell OptiPlex 745",
+	{	/* Handle problems with rebooting on the iMac9,1. */
+		.callback = set_pci_reboot,
+		.ident = "Apple iMac9,1",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
-			DMI_MATCH(DMI_BOARD_NAME, "0KW626"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
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
+	{	/* Handle problems with rebooting on Dell Optiplex 745 with 0KW626 */
 		.callback = set_bios_reboot,
-		.ident = "Dell DXP061",
+		.ident = "Dell OptiPlex 745",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DXP061"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+			DMI_MATCH(DMI_BOARD_NAME, "0KW626"),
 		},
 	},
-	{	/* Handle problems with rebooting on Sony VGN-Z540N */
+	{	/* Handle problems with rebooting on Dell Optiplex 745's DFF */
 		.callback = set_bios_reboot,
-		.ident = "Sony VGN-Z540N",
+		.ident = "Dell OptiPlex 745",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+			DMI_MATCH(DMI_BOARD_NAME, "0MM599"),
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
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Latitude E6320. */
+	{	/* Some C6100 machines were shipped with vendor being 'Dell'. */
 		.callback = set_pci_reboot,
-		.ident = "Dell Latitude E6320",
+		.ident = "Dell PowerEdge C6100",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6320"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Latitude E5420. */
+	{	/* Handle problems with rebooting on the Precision M6600. */
 		.callback = set_pci_reboot,
-		.ident = "Dell Latitude E5420",
+		.ident = "Dell Precision M6600",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5420"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Latitude E6420. */
-		.callback = set_pci_reboot,
-		.ident = "Dell Latitude E6420",
+	{	/* Handle problems with rebooting on Dell T5400's */
+		.callback = set_bios_reboot,
+		.ident = "Dell Precision T5400",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T5400"),
 		},
 	},
-	{	/* Handle problems with rebooting on the OptiPlex 990. */
-		.callback = set_pci_reboot,
-		.ident = "Dell OptiPlex 990",
+	{	/* Handle problems with rebooting on Dell T7400's */
+		.callback = set_bios_reboot,
+		.ident = "Dell Precision T7400",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision WorkStation T7400"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Precision M6600. */
-		.callback = set_pci_reboot,
-		.ident = "Dell Precision M6600",
+	{	/* Handle problems with rebooting on Dell XPS710 */
+		.callback = set_bios_reboot,
+		.ident = "Dell XPS710",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell XPS710"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Dell PowerEdge C6100. */
-		.callback = set_pci_reboot,
-		.ident = "Dell PowerEdge C6100",
+
+	/* Hewlett-Packard */
+	{	/* Handle problems with rebooting on HP laptops */
+		.callback = set_bios_reboot,
+		.ident = "HP Compaq Laptop",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq"),
 		},
 	},
-	{	/* Some C6100 machines were shipped with vendor being 'Dell'. */
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
 
