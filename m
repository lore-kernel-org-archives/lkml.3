Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaAFEcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 23:32:50 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:59078 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaAFEck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 23:32:40 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3] isdn: Drop big endian cpp checks from telespci and hfc_pci drivers
Date: Sun,  5 Jan 2014 20:31:39 -0800
Message-Id: <1388982699-11514-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With arm:allmodconfig, building the Teles PCI driver fails with

telespci.c:294:2: error: #error "not running on big endian machines now"

Similar, building the driver for HFC PCI-Bus cards fails with

hfc_pci.c:1647:2: error: #error "not running on big endian machines now"

Remove the big endian cpp check from both drivers to fix the build errors.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v3: Instead of marking build as broken, remove cpp endianness checks.
    Updated headline to match the changes.

v2: Turns out CPU_LITTLE_ENDIAN is not defined for little-endian-only
    architectures. Instead of messing with the overall Kconfig architecture,
    mark build as broken for big endian ARM machines.
    Also updated headline accordingly.

 drivers/isdn/hisax/hfc_pci.c  |    4 ----
 drivers/isdn/hisax/telespci.c |    4 ----
 2 files changed, 8 deletions(-)

diff --git a/drivers/isdn/hisax/hfc_pci.c b/drivers/isdn/hisax/hfc_pci.c
index 497bd02..4a48255 100644
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -1643,10 +1643,6 @@ setup_hfcpci(struct IsdnCard *card)
 	int i;
 	struct pci_dev *tmp_hfcpci = NULL;
 
-#ifdef __BIG_ENDIAN
-#error "not running on big endian machines now"
-#endif
-
 	strcpy(tmp, hfcpci_revision);
 	printk(KERN_INFO "HiSax: HFC-PCI driver Rev. %s\n", HiSax_getrev(tmp));
 
diff --git a/drivers/isdn/hisax/telespci.c b/drivers/isdn/hisax/telespci.c
index f6ab63a..33eeb46 100644
--- a/drivers/isdn/hisax/telespci.c
+++ b/drivers/isdn/hisax/telespci.c
@@ -290,10 +290,6 @@ int setup_telespci(struct IsdnCard *card)
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
 
-#ifdef __BIG_ENDIAN
-#error "not running on big endian machines now"
-#endif
-
 	strcpy(tmp, telespci_revision);
 	printk(KERN_INFO "HiSax: Teles/PCI driver Rev. %s\n", HiSax_getrev(tmp));
 	if (cs->typ != ISDN_CTYPE_TELESPCI)
-- 
1.7.9.7

