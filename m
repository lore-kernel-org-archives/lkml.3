Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3GAH3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:29:14 -0400
Received: from mailsit.unilogicnetworks.net ([62.133.206.125]:40068 "EHLO
	mail.unilogicnetworks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3GAH3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:29:13 -0400
X-Greylist: delayed 1645 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2013 03:29:13 EDT
Message-ID: <1372662132.3810.9.camel@optiplex>
Subject: [PATCH 3/3] x86: add Dell OptiPlex 755 reboot quirk
From: Pascal de Bruijn <pascal@unilogicnetworks.net>
To: linux-kernel@vger.kernel.org
Date: Mon, 01 Jul 2013 09:02:12 +0200
Organization: Unilogic Networks B.V.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 36e78caa1ef9b7299b17e00f0ef34101eb096323 Mon Sep 17 00:00:00 2001
From: Pascal de Bruijn <pascal@unilogicnetworks.net>
Date: Wed, 1 May 2013 12:40:09 +0000
Subject: [PATCH 3/3] x86: add Dell OptiPlex 755 reboot quirk

Dell OptiPlex 755 hangs on reboot unless reboot=bios is used. Add quirk
to reboot through the BIOS.

Signed-off-by: Pascal de Bruijn <pascal@unilogicnetworks.net>
---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 0dfed0f..cb8a4c2 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -293,6 +293,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0T656F"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell OptiPlex 755 */
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 755",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 755"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell OptiPlex 760 */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 760",
-- 
1.7.0.4



