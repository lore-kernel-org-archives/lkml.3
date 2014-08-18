Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaHRVNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 17:13:45 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:43994 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaHRVNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:13:44 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list)
Cc: geert@linux-m68k.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] ppc: Fix build error with CONFIG_PCI=n
Date: Mon, 18 Aug 2014 17:13:41 -0400
Message-Id: <1408396422-32658-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ppc 32 build failure as reported here:

http://kisskb.ellerman.id.au/kisskb/buildresult/11663513/

The error is as follows:

arch/powerpc/include/asm/floppy.h:142:20: error: 'isa_bridge_pcidev' undeclared
(first use in this function)

This is happening since floppy.o is enabled by BLK_DEV_FD which depends on
ARCH_MAY_HAVE_PC_FDC which is in-turn enabled if PPC_PSERIES=n. 

The following commit changes the dependency so that ARCH_MAY_HAVE_PC_FDC is
dependent exclusively on PCI since otherwise it will not compile.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 arch/powerpc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a577609f..9c1aa77 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -182,7 +182,7 @@ config SCHED_OMIT_FRAME_POINTER
 
 config ARCH_MAY_HAVE_PC_FDC
 	bool
-	default !PPC_PSERIES || PCI
+	default PCI
 
 config PPC_OF
 	def_bool y
-- 
1.9.1

