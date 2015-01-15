Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbbAONNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:13:34 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:17953 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbbAONNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:13:31 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Chad Reese <kreese@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH v3 12/15] MIPS: OCTEON: Remove setting of processor specific CVMCTL icache bits.
Date: Thu, 15 Jan 2015 16:11:16 +0300
Message-ID: <1421327487-28679-13-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
References: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chad Reese <kreese@caviumnetworks.com>

CN38XX pass 1 required icache prefetching to be turned off. This chip never
reached production and is long dead. Other processor specific icache settings
are done by the bootloader. Remove these bits from the kernel.

Signed-off-by: Chad Reese <kreese@caviumnetworks.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 .../asm/mach-cavium-octeon/kernel-entry-init.h       | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h b/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
index c7ce081..4bef539 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
@@ -37,26 +37,6 @@
 	# Needed for octeon specific memcpy
 	or  v0, v0, 0x5001
 	xor v0, v0, 0x1001
-	# Read the processor ID register
-	mfc0 v1, CP0_PRID_REG
-	# Disable instruction prefetching (Octeon Pass1 errata)
-	or  v0, v0, 0x2000
-	# Skip reenable of prefetching for Octeon Pass1
-	beq v1, CP0_PRID_OCTEON_PASS1, skip
-	nop
-	# Reenable instruction prefetching, not on Pass1
-	xor v0, v0, 0x2000
-	# Strip off pass number off of processor id
-	srl v1, 8
-	sll v1, 8
-	# CN30XX needs some extra stuff turned off for better performance
-	bne v1, CP0_PRID_OCTEON_CN30XX, skip
-	nop
-	# CN30XX Use random Icache replacement
-	or  v0, v0, 0x400
-	# CN30XX Disable instruction prefetching
-	or  v0, v0, 0x2000
-skip:
 	# First clear off CvmCtl[IPPCI] bit and move the performance
 	# counters interrupt to IRQ 6
 	dli	v1, ~(7 << 7)
-- 
2.2.2

