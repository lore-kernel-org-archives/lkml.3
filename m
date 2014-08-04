Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaHDSYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:24:16 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55577 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaHDSYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:24:14 -0400
Message-ID: <53DFCFC9.6060307@gmail.com>
Date: Tue, 05 Aug 2014 02:24:09 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: isdn@linux-pingi.de
CC: davem@davemloft.net, Jean Delvare <jdelvare@suse.de>,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        monstr@monstr.eu
Subject: [PATCH] drivers/isdn/hisax/Kconfig: Let HISAX_NETJET skip microblaze
 architecture
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For HISAX_NETJET, HISAX_NETJET_U or related config needs !__BIG_ENDIAN,
so skip microblaze, just like skip all other architectures which have
no CONFIG_*_ENDIAN.

The related error (with allmodconfig under microblaze):

    CC [M]  drivers/isdn/hisax/nj_s.o
  drivers/isdn/hisax/nj_s.c: In function 'setup_netjet_s':
  drivers/isdn/hisax/nj_s.c:265:2: error: #error "not running on big endian machines now"
   #error "not running on big endian machines now"
    ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/isdn/hisax/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index 97465ac..eb83d94 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -237,7 +237,7 @@ config HISAX_MIC
 
 config HISAX_NETJET
 	bool "NETjet card"
-	depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
+	depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN) || MICROBLAZE))
 	depends on VIRT_TO_BUS
 	help
 	  This enables HiSax support for the NetJet from Traverse
@@ -249,7 +249,7 @@ config HISAX_NETJET
 
 config HISAX_NETJET_U
 	bool "NETspider U card"
-	depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN)))
+	depends on PCI && (BROKEN || !(PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV || (XTENSA && !CPU_LITTLE_ENDIAN) || MICROBLAZE))
 	depends on VIRT_TO_BUS
 	help
 	  This enables HiSax support for the Netspider U interface ISDN card
-- 
1.7.11.7
