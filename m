Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3CLAV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:21:57 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:53666 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754424Ab3CLAV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:21:56 -0400
Message-ID: <1363047710.3137.132.camel@x61.thuisdomein>
Subject: [PATCH] powerpc: remove outdated default
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 01:21:50 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2013 00:21:51.0075 (UTC) FILETIME=[978CAB30:01CE1EB7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol PCI_PERMEDIA got removed in v2.6.24, through commit
e6b6e3ffb9ee8926f9f2f7dc9147df73e27d5828 ("[POWERPC] Remove APUS support
from arch/ppc"). Remove its last occurrence.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "make ARCH=powerpc menuconfig" using ps3_defconfig, both
before and after this patch. ("!4xx && !CPM2 && !8xx" is true for ps3,
and it uses PPC_PCI_CHOICE.) Nothing seemed to change. Which makes
sense, as defaulting to an undefined symbol should be a nop.

 arch/powerpc/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b89d7eb..3d566c3 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -744,7 +744,6 @@ config PCI
 	bool "PCI support" if PPC_PCI_CHOICE
 	default y if !40x && !CPM2 && !8xx && !PPC_83xx \
 		&& !PPC_85xx && !PPC_86xx && !GAMECUBE_COMMON
-	default PCI_PERMEDIA if !4xx && !CPM2 && !8xx
 	default PCI_QSPAN if !4xx && !CPM2 && 8xx
 	select ARCH_SUPPORTS_MSI
 	select GENERIC_PCI_IOMAP
-- 
1.7.11.7

