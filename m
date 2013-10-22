Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3JVOxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:53:40 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:59645 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3JVOxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:53:39 -0400
Message-ID: <5266916F.5020507@linux.com>
Date: Tue, 22 Oct 2013 16:53:35 +0200
From: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Hancock <hancockrwd@gmail.com>
CC: Aaron Lu <aaron.lu@intel.com>, "ACPI List" <linux-acpi@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi: Add Toshiba NB100 to Vista _OSI blacklist
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Toshiba NB100 to the Vista _OSI blacklist.

The _OSI(Windows 2006) method is bugged on the netbook resulting in messed up
PCI IRQ Routing information. This was observed on a netbook,
whose SATA controller mode was set to Compatibility mode.
The controller would then issue IRQs to IRQ#16 instead of
IRQ#20, where it should have been.
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
