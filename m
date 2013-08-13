Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246Ab3HMUVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:21:05 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:13017 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221Ab3HMUUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:20:33 -0400
Message-ID: <201308132020.r7DKKWKF022762@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 13 Aug 2013 15:33:53 -0400
Subject: [PATCH] tile: use standard tile_bundle_bits type in traps.c
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were rolling our own bundle_bits, which is unnecessary.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/traps.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index ef95de2..8f41de2 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -101,13 +101,7 @@ static int retry_gpv(unsigned int gpv_reason)
 
 #endif /* CHIP_HAS_TILE_DMA() */
 
-#ifdef __tilegx__
-#define bundle_bits tilegx_bundle_bits
-#else
-#define bundle_bits tile_bundle_bits
-#endif
-
-extern bundle_bits bpt_code;
+extern tile_bundle_bits bpt_code;
 
 asm(".pushsection .rodata.bpt_code,\"a\";"
     ".align 8;"
@@ -115,7 +109,7 @@ asm(".pushsection .rodata.bpt_code,\"a\";"
     ".size bpt_code,.-bpt_code;"
     ".popsection");
 
-static int special_ill(bundle_bits bundle, int *sigp, int *codep)
+static int special_ill(tile_bundle_bits bundle, int *sigp, int *codep)
 {
 	int sig, code, maxcode;
 
@@ -263,7 +257,7 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 	siginfo_t info = { 0 };
 	int signo, code;
 	unsigned long address = 0;
-	bundle_bits instr;
+	tile_bundle_bits instr;
 
 	/* Re-enable interrupts, if they were previously enabled. */
 	if (!(regs->flags & PT_FLAGS_DISABLE_IRQ))
-- 
1.8.3.1

