Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3GAH3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:29:17 -0400
Received: from mailsit.unilogicnetworks.net ([62.133.206.125]:45071 "EHLO
	mail.unilogicnetworks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GAH3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:29:13 -0400
Message-ID: <1372662125.3810.8.camel@optiplex>
Subject: [PATCH 2/3] x86: add Dell OptiPlex 780 reboot quirk
From: Pascal de Bruijn <pascal@unilogicnetworks.net>
To: linux-kernel@vger.kernel.org
Date: Mon, 01 Jul 2013 09:02:05 +0200
Organization: Unilogic Networks B.V.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 34ee5e25f01c4791b26e400c509761264a70dd99 Mon Sep 17 00:00:00 2001
From: Pascal de Bruijn <pascal@unilogicnetworks.net>
Date: Wed, 27 Mar 2013 14:19:53 +0000
Subject: [PATCH 2/3] x86: add Dell OptiPlex 780 reboot quirk

Dell OptiPlex 780 hangs on reboot unless reboot=bios is used. Add quirk
to reboot through the BIOS.

Signed-off-by: Pascal de Bruijn <pascal@unilogicnetworks.net>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 6961e77..0dfed0f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -301,6 +301,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 760"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell OptiPlex 780 */
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 780",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 780"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",
-- 
1.7.0.4



