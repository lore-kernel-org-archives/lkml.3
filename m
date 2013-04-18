Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967416Ab3DRM0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 08:26:40 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:54145 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966967Ab3DRM0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 08:26:37 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org
Subject: [PATCH V3 1/5] powerpc, perf: Add new BHRB related instructions for POWER8
Date: Thu, 18 Apr 2013 17:56:12 +0530
Message-Id: <1366287976-3900-2-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366287976-3900-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1366287976-3900-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041812-2000-0000-0000-00000BC8568E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new POWER8 instruction encoding for reading
the BHRB buffer entries and also clearing it. Encoding for
"clrbhrb" instruction is straight forward. But "mfbhrbe"
encoding involves reading a certain index of BHRB buffer
into a particular GPR register.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/ppc-opcode.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index 8752bc8..93ae5a1 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -82,6 +82,7 @@
 #define	__REGA0_R31	31
 
 /* sorted alphabetically */
+#define PPC_INST_BHRBE			0x7c00025c
 #define PPC_INST_DCBA			0x7c0005ec
 #define PPC_INST_DCBA_MASK		0xfc0007fe
 #define PPC_INST_DCBAL			0x7c2005ec
@@ -297,6 +298,12 @@
 #define PPC_NAP			stringify_in_c(.long PPC_INST_NAP)
 #define PPC_SLEEP		stringify_in_c(.long PPC_INST_SLEEP)
 
+/* BHRB instructions */
+#define PPC_CLRBHRB		stringify_in_c(.long 0x7c00035c)
+#define PPC_MFBHRBE(r, n)	stringify_in_c(.long PPC_INST_BHRBE | \
+						__PPC_RS(r) | \
+							(((n) & 0x1f) << 11))
+
 /* Transactional memory instructions */
 #define TRECHKPT		stringify_in_c(.long PPC_INST_TRECHKPT)
 #define TRECLAIM(r)		stringify_in_c(.long PPC_INST_TRECLAIM \
-- 
1.7.11.7

