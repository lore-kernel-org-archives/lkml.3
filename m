Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab3CPNJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 09:09:14 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:50978 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764Ab3CPNJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 09:09:12 -0400
Message-ID: <1363439347.1335.129.camel@x61.thuisdomein>
Subject: [PATCH] firewire: Remove two unneeded checks for macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Sat, 16 Mar 2013 14:09:07 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2013 13:09:08.0154 (UTC) FILETIME=[717071A0:01CE2247]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old IEEE 1394 driver stack was removed in v2.6.37. That made the
checks for two Kconfig (module) macros unneeded, since they will now
always evaluate to true. Remove these two checks.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Perhaps these alias can be dropped entirely. Bat that's not my call.

 drivers/firewire/ohci.c | 2 --
 drivers/firewire/sbp2.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 45912e6..4a55b51 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -3837,6 +3837,4 @@ MODULE_DESCRIPTION("Driver for PCI OHCI IEEE1394 controllers");
 MODULE_LICENSE("GPL");
 
 /* Provide a module alias so root-on-sbp2 initrds don't break. */
-#ifndef CONFIG_IEEE1394_OHCI1394_MODULE
 MODULE_ALIAS("ohci1394");
-#endif
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 1162d6b..12ec0e6 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1636,9 +1636,7 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(ieee1394, sbp2_id_table);
 
 /* Provide a module alias so root-on-sbp2 initrds don't break. */
-#ifndef CONFIG_IEEE1394_SBP2_MODULE
 MODULE_ALIAS("sbp2");
-#endif
 
 static int __init sbp2_init(void)
 {
-- 
1.7.11.7

