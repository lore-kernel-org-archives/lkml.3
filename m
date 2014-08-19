Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaHSVgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:36:09 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:64192 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaHSVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:36:07 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] powerpc: Make 256k pages depend on PPC32=n
Date: Tue, 19 Aug 2014 17:36:06 -0400
Message-Id: <1408484166-20711-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

256k pages are not tested on PPC32. On a randconfig I got the following error:

arch/powerpc/kernel/misc_32.S:1171: Error: operand out of range (0x0000000000010000 is not between 0xffffffffffff8000 and 0x0000000000007fff)

Disable 256K pages if PPC32=y

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/powerpc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index da16ffe..6cc518f 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -556,7 +556,7 @@ config PPC_64K_PAGES
 
 config PPC_256K_PAGES
 	bool "256k page size" if 44x
-	depends on !STDBINUTILS
+	depends on !PPC32 && !STDBINUTILS
 	help
 	  Make the page size 256k.
 
-- 
1.9.1

