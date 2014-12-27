Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaL0RRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 12:17:31 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:38195 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaL0RRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 12:17:14 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Neuling <mikey@neuling.org>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] powerpc/powernv: Select CONFIG_PRINTK to fix build failure
Date: Sat, 27 Dec 2014 12:17:44 -0500
Message-Id: <1419700667-24888-2-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419700667-24888-1-git-send-email-bobby.prani@gmail.com>
References: <1419700667-24888-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In an allnoconfig we get the following build failure:

arch/powerpc/platforms/built-in.o: In function `.__machine_initcall_powernv_opal_init':
opal.c:(.init.text+0x468): undefined reference to `.log_buf_addr_get'
opal.c:(.init.text+0x474): undefined reference to `.log_buf_len_get'
make: *** [vmlinux] Error 1

This happens because powernv requires printk() support. Enable it in the config
file.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/powerpc/platforms/powernv/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platforms/powernv/Kconfig
index 45a8ed0..be4f340 100644
--- a/arch/powerpc/platforms/powernv/Kconfig
+++ b/arch/powerpc/platforms/powernv/Kconfig
@@ -18,6 +18,7 @@ config PPC_POWERNV
 	select CPU_FREQ_GOV_ONDEMAND
 	select CPU_FREQ_GOV_CONSERVATIVE
 	select PPC_DOORBELL
+	select PRINTK
 	default y
 
 config PPC_POWERNV_RTAS
-- 
1.9.1

