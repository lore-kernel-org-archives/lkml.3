Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab3IJBiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:38:12 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:45641 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3IJBiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:38:11 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Guenter Roeck <linux@roeck-us.net>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Shivaprasad G Bhat <sbhat@linux.vnet.ibm.com>
Subject: [PATCH] powerpc: Export cpu_to_chip_id() to fix build error
Date: Mon,  9 Sep 2013 18:37:56 -0700
Message-Id: <1378777076-4699-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc allmodconfig build fails with:

ERROR: ".cpu_to_chip_id" [drivers/block/mtip32xx/mtip32xx.ko] undefined!

The problem was introduced with commit 15863ff3b (powerpc: Make chip-id
information available to userspace).

Export the missing symbol.

Cc: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc: Shivaprasad G Bhat <sbhat@linux.vnet.ibm.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/powerpc/kernel/smp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 442d8e2..8e59abc 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -611,6 +611,7 @@ int cpu_to_chip_id(int cpu)
 	of_node_put(np);
 	return of_get_ibm_chip_id(np);
 }
+EXPORT_SYMBOL(cpu_to_chip_id);
 
 /* Helper routines for cpu to core mapping */
 int cpu_core_index_of_thread(int cpu)
-- 
1.7.9.7

