Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaAETtm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 14:49:42 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61838 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaAETtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 14:49:40 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2] isdn: Mark build for telespci and hfc_pci as broken for big endian ARM
Date: Sun,  5 Jan 2014 11:49:27 -0800
Message-Id: <1388951367-7411-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With arm:allmodconfig, building the Teles PCI driver fails with

telespci.c:294:2: error: #error "not running on big endian machines now"

Similar, building the driver for HFC PCI-Bus cards fails with

hfc_pci.c:1647:2: error: #error "not running on big endian machines now"

Mark build as broken for big endian ARM machines.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Turns out CPU_LITTLE_ENDIAN is not defined for little-endian-only
    architectures. Instead of messing with the overall Kconfig architecture,
    mark build as broken for big endian ARM machines.
    Also updated headline accordingly.

 drivers/isdn/hisax/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index d9edcc9..53dbb75 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -109,7 +109,7 @@ config HISAX_16_3
 
 config HISAX_TELESPCI
 	bool "Teles PCI"
-	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
+	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN) || (ARM && !CPU_LITTLE_ENDIAN)))
 	help
 	  This enables HiSax support for the Teles PCI.
 	  See <file:Documentation/isdn/README.HiSax> on how to configure it.
@@ -318,7 +318,7 @@ config HISAX_GAZEL
 
 config HISAX_HFC_PCI
 	bool "HFC PCI-Bus cards"
-	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
+	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN) || (ARM && !CPU_LITTLE_ENDIAN)))
 	help
 	  This enables HiSax support for the HFC-S PCI 2BDS0 based cards.
 
-- 
1.7.9.7

