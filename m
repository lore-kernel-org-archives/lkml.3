Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab3J2QxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:53:02 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62830 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3J2QxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:53:00 -0400
Message-ID: <526FE7E8.80806@linux.com>
Date: Tue, 29 Oct 2013 17:52:56 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: levex@linux.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Hancock <hancockrwd@gmail.com>
CC: Aaron Lu <aaron.lu@intel.com>, ACPI List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] ACPI: Add Toshiba NB100 to Vista _OSI blacklist
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Toshiba NB100 to the Vista _OSI blacklist.

The _OSI(Windows 2006) method is bugged on the netbook resulting in messed up
PCI IRQ Routing information. This was observed on a netbook,
whose SATA controller mode was set to Compatibility mode.
The driver would then register itself to IRQ#16, but the device
was in fact issuing interrupts to IRQ#20.
No side-effects were found during testing, everything is
working as it did before.

See thread:
http://marc.info/?t=137862230200001&r=1&w=2
http://www.spinics.net/lists/linux-ide/msg46173.html


Signed-off-by: Levente Kurusa <levex@linux.com>
Reviewed-by: Robert Hancock <hancockrwd@gmail.com>
---
diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index cb96296..34d4d1a 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -267,6 +267,14 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P305D"),
 		},
 	},
+	{
+	.callback = dmi_disable_osi_vista,
+	.ident = "Toshiba NB100",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "NB100"),
+		},
+	},

 	/*
 	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
