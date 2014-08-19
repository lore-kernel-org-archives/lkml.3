Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaHSVQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:16:51 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:38353 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaHSVQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:16:50 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org (open list:CELL BROADBAND EN...),
        cbe-oss-dev@lists.ozlabs.org (open list:CELL BROADBAND EN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH] powerpc: Make SPU_FS depend on SPARSEMEM
Date: Tue, 19 Aug 2014 17:16:50 -0400
Message-Id: <1408483010-32689-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPU_FS unconditionally enables MEMORY_HOTPLUG, which will fail to build if
SPARSEMEM=n.

Make SPU_FS depend on SPARSEMEM so that hotplug-memory.c does not fail to
compile.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/powerpc/platforms/cell/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/cell/Kconfig b/arch/powerpc/platforms/cell/Kconfig
index 9978f59..832872e 100644
--- a/arch/powerpc/platforms/cell/Kconfig
+++ b/arch/powerpc/platforms/cell/Kconfig
@@ -60,7 +60,7 @@ menu "Cell Broadband Engine options"
 config SPU_FS
 	tristate "SPU file system"
 	default m
-	depends on PPC_CELL
+	depends on PPC_CELL && SPARSEMEM
 	select SPU_BASE
 	select MEMORY_HOTPLUG
 	help
-- 
1.9.1

