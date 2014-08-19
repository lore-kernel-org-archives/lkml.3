Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaHSVBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:01:07 -0400
Received: from mail-yk0-f181.google.com ([209.85.160.181]:52124 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaHSVBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:01:06 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list)
Cc: Andew Morton <akpm@linux-foundation.org>
Subject: [PATCH] powerpc: Fix build failure when MEMORY_HOTPLUG=y
Date: Tue, 19 Aug 2014 17:01:05 -0400
Message-Id: <1408482065-18457-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_ENABLE_MEMORY_HOTPLUG is enabled by default for powerpc. This causes build
failures when SPARSEMEM=n as memory hotplug needs definition which are defined
only when SPARSEMEM=y. The error is as follows:

arch/powerpc/platforms/pseries/hotplug-memory.c:27:31: error: 'SECTION_SIZE_BITS' undeclared (first use in this function)
arch/powerpc/platforms/pseries/hotplug-memory.c:27:31: note: each undeclared identifier is reported only once for each function it appears in
arch/powerpc/platforms/pseries/hotplug-memory.c: In function 'pseries_remove_memblock':
arch/powerpc/platforms/pseries/hotplug-memory.c:98:34: error: 'SECTION_SIZE_BITS' undeclared (first use in this function)
make[2]: *** [arch/powerpc/platforms/pseries/hotplug-memory.o] Error 1

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Andew Morton <akpm@linux-foundation.org>
---
 arch/powerpc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9c1aa77..da16ffe 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -383,6 +383,7 @@ config ARCH_CPU_PROBE_RELEASE
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
+	depends on SPARSEMEM
 
 config ARCH_HAS_WALK_MEMORY
 	def_bool y
-- 
1.9.1

