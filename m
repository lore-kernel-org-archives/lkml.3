Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab3GAH3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:29:15 -0400
Received: from mailsit.unilogicnetworks.net ([62.133.206.125]:52101 "EHLO
	mail.unilogicnetworks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3GAH3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:29:13 -0400
Message-ID: <1372662106.3810.7.camel@optiplex>
Subject: [PATCH 1/3] x86: Expand Dell OptiPlex 760 reboot quirk
From: Pascal de Bruijn <pascal@unilogicnetworks.net>
To: linux-kernel@vger.kernel.org
Date: Mon, 01 Jul 2013 09:01:46 +0200
Organization: Unilogic Networks B.V.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c064fc347ea79c91bbb5bf70d6543ffbcf1111db Mon Sep 17 00:00:00 2001
From: Pascal de Bruijn <pascal@unilogicnetworks.net>
Date: Wed, 27 Mar 2013 14:17:12 +0000
Subject: [PATCH 1/3] x86: Expand Dell OptiPlex 760 reboot quirk

Different DMI_BOARD_NAME's are affected by this reboot issue as well,
so we want to expand the quirk coverage by removing the DMI_BOARD_NAME
match.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=54051
BugLink: https://bugs.launchpad.net/bugs/488319

Signed-off-by: Pascal de Bruijn <pascal@unilogicnetworks.net>
---
 arch/x86/kernel/reboot.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 76fa1e9..6961e77 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -293,13 +293,12 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0T656F"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell OptiPlex 760 with 0G919G */
+	{	/* Handle problems with rebooting on Dell OptiPlex 760 */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 760",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 760"),
-			DMI_MATCH(DMI_BOARD_NAME, "0G919G"),
 		},
 	},
 	{	/* Handle problems with rebooting on Dell 2400's */
-- 
1.7.0.4



