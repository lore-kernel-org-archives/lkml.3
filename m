Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab3IKG0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 02:26:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14695 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3IKG0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 02:26:44 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=pwRAa-UwXOgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jP7OCq9BwNYA:10 a=WPyIoOwQAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=1DbiqZag68YA:10 a=jeBq3FmKZ4MA:10 a=BPSfKMXmiYsA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042902.486093911@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Subject: [060/251] MIPS: Oceton: Fix build error.
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0060-MIPS-Oceton-Fix-build-error.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

[ Upstream commit 39205750efa6d335fac4f9bcd32b49c7e71c12b7 ]

If CONFIG_CAVIUM_OCTEON_LOCK_L2_TLB, CONFIG_CAVIUM_OCTEON_LOCK_L2_EXCEPTION,
CONFIG_CAVIUM_OCTEON_LOCK_L2_LOW_LEVEL_INTERRUPT and
CONFIG_CAVIUM_OCTEON_LOCK_L2_INTERRUPT are all undefined:

arch/mips/cavium-octeon/setup.c: In function ‘prom_init’:
arch/mips/cavium-octeon/setup.c:715:12: error: unused variable ‘ebase’ [-Werror=unused-variable]

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/mips/cavium-octeon/setup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 919b0fb..19ce979 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2004-2007 Cavium Networks
  * Copyright (C) 2008 Wind River Systems
  */
+#include <linux/compiler.h>
 #include <linux/init.h>
 #include <linux/console.h>
 #include <linux/delay.h>
@@ -504,7 +505,7 @@ void __init prom_init(void)
 	if (cvmx_read_csr(CVMX_L2D_FUS3) & (3ull << 34)) {
 		pr_info("Skipping L2 locking due to reduced L2 cache size\n");
 	} else {
-		uint32_t ebase = read_c0_ebase() & 0x3ffff000;
+		uint32_t __maybe_unused ebase = read_c0_ebase() & 0x3ffff000;
 #ifdef CONFIG_CAVIUM_OCTEON_LOCK_L2_TLB
 		/* TLB refill */
 		cvmx_l2c_lock_mem_region(ebase, 0x100);
-- 
1.7.10.4


