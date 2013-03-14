Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3CNV47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:56:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3CNV4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:56:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [PATCH] isdn: hisax: netjet requires VIRT_TO_BUS
Date: Thu, 14 Mar 2013 22:56:41 +0100
Message-Id: <1363298204-8014-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363298204-8014-1-git-send-email-arnd@arndb.de>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:JtUHP2zxyQsTI7mVCFBC1PTbXzdsDDYfsJnQvwxJw3a
 ugC7IpP73fYW0OAR0sMjiw5XMK77tHkCyNJtoV9yAMkTurUJtg
 gfqDB9VjHSJhTw5P05esdr4tOFgxkM9P0MtOw8ZbjlsMKPsyv3
 /vuRpWDiJoC+N0babrB4nGsyrC8Uxwt1Ta9UxoY6G2lCaQrmy/
 lGm1Nql643ulkMwN7nvbgSZ0yWhmX/iCqmVmU3Nfw1who/MCWj
 eHvI+y2X4DSFn4zhKDymx9i11UlNzTTQKty37z+DShdO0HpLWp
 oFucThKf9TgxQpIJAjrnFMBCg1j6+dE1Wvh/P2BilN64vP3puC
 vHOzucrEkyQ3FDTOuJWCI5J2D3RIwngvoDP/9Kdbk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabling CONFIG_VIRT_TO_BUS on ARM showed that the hisax netjet
driver depends on this deprecated functionality but is not
marked so in Kconfig.

Rather than adding ARM to the already long list of architectures
that this driver is broken on, this patch adds 'depends on
VIRT_TO_BUS' and removes the dependency on !SPARC, which is
also implied by that.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
---
Please apply for 3.9 or 3.10, this one is not urgent

 drivers/isdn/hisax/Kconfig | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 5313c9e..d9edcc9 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -237,7 +237,8 @@ config HISAX_MIC
 
 config HISAX_NETJET
 	bool "NETjet card"
-	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
+	depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
+	depends on VIRT_TO_BUS
 	help
 	  This enables HiSax support for the NetJet from Traverse
 	  Technologies.
@@ -248,7 +249,8 @@ config HISAX_NETJET
 
 config HISAX_NETJET_U
 	bool "NETspider U card"
-	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
+	depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
+	depends on VIRT_TO_BUS
 	help
 	  This enables HiSax support for the Netspider U interface ISDN card
 	  from Traverse Technologies.
-- 
1.8.1.2

