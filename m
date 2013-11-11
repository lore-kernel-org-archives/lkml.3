Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3KKSrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:47:17 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:37699 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3KKSrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:47:06 -0500
Date: Mon, 11 Nov 2013 19:47:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/reboot changes for v3.13
Message-ID: <20131111184702.GA16472@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-reboot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-reboot-for-linus

   # HEAD: 6d9153bbce50d41802ad2e20ce52daf699a3e8ad x86/reboot: Correct pr_info() log message in the set_bios/pci/kbd_reboot()

Misc changes - the only one with functional impact should be:

   16c21ae5ca63 reboot: Allow specifying warm/cold reset for CF9 boot type

which extends cold/warm reboot handling to the 0xCF9 reboot method.

 Thanks,

	Ingo

------------------>
Dave Jones (1):
      x86/reboot: Sort reboot DMI quirks by vendor

Lan Tianyu (1):
      x86/reboot: Correct pr_info() log message in the set_bios/pci/kbd_reboot()

Li Fei (1):
      reboot: Allow specifying warm/cold reset for CF9 boot type

Masoud Sharbiani (1):
      x86/reboot: Remove the duplicate C6100 entry in the reboot quirks list


 arch/x86/kernel/reboot.c | 279 ++++++++++++++++++++++++-----------------------
 1 file changed, 143 insertions(+), 136 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e643e74..da1fe1c 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -61,7 +61,7 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
 	if (reboot_type != BOOT_BIOS) {
 		reboot_type = BOOT_BIOS;
 		pr_info("%s series board detected. Selecting %s-method for reboots.\n",
-			"BIOS", d->ident);
+			d->ident, "BIOS");
 	}
 	return 0;
 }
@@ -117,7 +117,7 @@ static int __init set_pci_reboot(const struct dmi_system_id *d)
 	if (reboot_type != BOOT_CF9) {
 		reboot_type = BOOT_CF9;
 		pr_info("%s series board detected. Selecting %s-method for reboots.\n",
-			"PCI", d->ident);
+			d->ident, "PCI");
 	}
 	return 0;
 }
@@ -127,7 +127,7 @@ static int __init set_kbd_reboot(const struct dmi_system_id *d)
 	if (reboot_type != BOOT_KBD) {
 		reboot_type = BOOT_KBD;
 		pr_info("%s series board detected. Selecting %s-method for reboot.\n",
-			"KBD", d->ident);
+			d->ident, "KBD");
 	}
 	return 0;
 }
@@ -136,244 +136,248 @@ static int __init set_kbd_reboot(const struct dmi_system_id *d)
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
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
-		},
-	},
-
-	{	/* Handle reboot issue on Acer Aspire one */
-		.callback = set_kbd_reboot,
-		.ident = "Acer Aspire One A110",
+		.ident = "Dell OptiPlex 760",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 760"),
+			DMI_MATCH(DMI_BOARD_NAME, "0G919G"),
 		},
 	},
-	{	/* Handle problems with rebooting on Apple MacBook5 */
+	{	/* Handle problems with rebooting on the OptiPlex 990. */
 		.callback = set_pci_reboot,
-		.ident = "Apple MacBook5",
+		.ident = "Dell OptiPlex 990",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
 		},
 	},
-	{	/* Handle problems with rebooting on Apple MacBookPro5 */
-		.callback = set_pci_reboot,
-		.ident = "Apple MacBookPro5",
+	{	/* Handle problems with rebooting on Dell 300's */
+		.callback = set_bios_reboot,
+		.ident = "Dell PowerEdge 300",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 300/"),
 		},
 	},
-	{	/* Handle problems with rebooting on Apple Macmini3,1 */
-		.callback = set_pci_reboot,
-		.ident = "Apple Macmini3,1",
+	{	/* Handle problems with rebooting on Dell 1300's */
+		.callback = set_bios_reboot,
+		.ident = "Dell PowerEdge 1300",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 1300/"),
 		},
 	},
-	{	/* Handle problems with rebooting on the iMac9,1. */
-		.callback = set_pci_reboot,
-		.ident = "Apple iMac9,1",
+	{	/* Handle problems with rebooting on Dell 2400's */
+		.callback = set_bios_reboot,
+		.ident = "Dell PowerEdge 2400",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 2400"),
 		},
 	},
-	{	/* Handle problems with rebooting on the Latitude E6320. */
+	{	/* Handle problems with rebooting on the Dell PowerEdge C6100. */
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
 
@@ -527,10 +531,13 @@ static void native_machine_emergency_restart(void)
 
 		case BOOT_CF9_COND:
 			if (port_cf9_safe) {
-				u8 cf9 = inb(0xcf9) & ~6;
+				u8 reboot_code = reboot_mode == REBOOT_WARM ?
+					0x06 : 0x0E;
+				u8 cf9 = inb(0xcf9) & ~reboot_code;
 				outb(cf9|2, 0xcf9); /* Request hard reset */
 				udelay(50);
-				outb(cf9|6, 0xcf9); /* Actually do the reset */
+				/* Actually do the reset */
+				outb(cf9|reboot_code, 0xcf9);
 				udelay(50);
 			}
 			reboot_type = BOOT_KBD;

