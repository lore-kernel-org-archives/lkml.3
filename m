Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaLHORH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:17:07 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:52872 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaLHORF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:17:05 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc32/chrp: fix section mismatch warning
Message-Id: <20141208141644.8D8741A5D5C@localhost.localdomain>
Date: Mon,  8 Dec 2014 15:16:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a section mismatch warning

WARNING: vmlinux.o(.text+0x213b6): Section mismatch in reference from the function chrp_init_early() to the variable .init.data:boot_command_line
The function chrp_init_early() references
the variable __initdata boot_command_line.
This is often because chrp_init_early lacks a __initdata 
annotation or the annotation of boot_command_line is wrong.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/platforms/chrp/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index 5b77b19..d5d1ea5 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -253,7 +253,7 @@ static void briq_restart(char *cmd)
  * But unfortunately, the firmware does not connect /chosen/{stdin,stdout}
  * the the built-in serial node. Instead, a /failsafe node is created.
  */
-static void chrp_init_early(void)
+static __init void chrp_init_early(void)
 {
 	struct device_node *node;
 	const char *property;
-- 
2.1.0

