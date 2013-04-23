Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3DWFnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 01:43:32 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52293 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3DWFnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 01:43:11 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org
Subject: [PATCH V4 1/5] powerpc, perf: Add new BHRB related instructions for POWER8
Date: Tue, 23 Apr 2013 11:12:40 +0530
Message-Id: <1366695764-3073-2-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366695764-3073-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1366695764-3073-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042305-4790-0000-0000-000007F92544
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new POWER8 instruction encoding for reading
and clearing Branch History Rolling Buffer entries. The new
instruction 'mfbhrbe' (move from branch history rolling buffer
entry) is used to read BHRB buffer entries and instruction
'clrbhrb' (clear branch history rolling buffer) is used to
clear the entire buffer. The instruction 'clrbhrb' has straight
forward encoding. But the instruction encoding format for
reading the BHRB entries is like 'mfbhrbe RT, BHRBE' where it
takes two arguments, i.e the index for the BHRB buffer entry to
read and a general purpose register to put the value which was
read from the buffer entry.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/ppc-opcode.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index 8752bc8..0c34e48 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -82,6 +82,8 @@
 #define	__REGA0_R31	31
 
 /* sorted alphabetically */
+#define PPC_INST_BHRBE			0x7c00025c
+#define PPC_INST_CLRBHRB		0x7c00035c
 #define PPC_INST_DCBA			0x7c0005ec
 #define PPC_INST_DCBA_MASK		0xfc0007fe
 #define PPC_INST_DCBAL			0x7c2005ec
@@ -297,6 +299,12 @@
 #define PPC_NAP			stringify_in_c(.long PPC_INST_NAP)
 #define PPC_SLEEP		stringify_in_c(.long PPC_INST_SLEEP)
 
+/* BHRB instructions */
+#define PPC_CLRBHRB		stringify_in_c(.long PPC_INST_CLRBHRB)
+#define PPC_MFBHRBE(r, n)	stringify_in_c(.long PPC_INST_BHRBE | \
+						__PPC_RT(r) | \
+							(((n) & 0x3ff) << 11))
+
 /* Transactional memory instructions */
 #define TRECHKPT		stringify_in_c(.long PPC_INST_TRECHKPT)
 #define TRECLAIM(r)		stringify_in_c(.long PPC_INST_TRECLAIM \
-- 
1.7.11.7

