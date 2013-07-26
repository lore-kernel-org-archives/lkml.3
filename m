Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab3GZUtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:49:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982Ab3GZUsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [ 43/79] MIPS: Oceton: Fix build error.
Date: Fri, 26 Jul 2013 13:47:33 -0700
Message-Id: <20130726204726.980439943@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

commit 39205750efa6d335fac4f9bcd32b49c7e71c12b7 upstream.

If CONFIG_CAVIUM_OCTEON_LOCK_L2_TLB, CONFIG_CAVIUM_OCTEON_LOCK_L2_EXCEPTION,
CONFIG_CAVIUM_OCTEON_LOCK_L2_LOW_LEVEL_INTERRUPT and
CONFIG_CAVIUM_OCTEON_LOCK_L2_INTERRUPT are all undefined:

arch/mips/cavium-octeon/setup.c: In function ‘prom_init’:
arch/mips/cavium-octeon/setup.c:715:12: error: unused variable ‘ebase’ [-Werror=unused-variable]

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/cavium-octeon/setup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2008, 2009 Wind River Systems
  *   written by Ralf Baechle <ralf@linux-mips.org>
  */
+#include <linux/compiler.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/console.h>
@@ -712,7 +713,7 @@ void __init prom_init(void)
 	if (cvmx_read_csr(CVMX_L2D_FUS3) & (3ull << 34)) {
 		pr_info("Skipping L2 locking due to reduced L2 cache size\n");
 	} else {
-		uint32_t ebase = read_c0_ebase() & 0x3ffff000;
+		uint32_t __maybe_unused ebase = read_c0_ebase() & 0x3ffff000;
 #ifdef CONFIG_CAVIUM_OCTEON_LOCK_L2_TLB
 		/* TLB refill */
 		cvmx_l2c_lock_mem_region(ebase, 0x100);


