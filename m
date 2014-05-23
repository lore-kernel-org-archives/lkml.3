Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaEWPRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:17:40 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:41904 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaEWPRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:17:38 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
Cc: davem@davemloft.net, Paul.Clothier@imgtec.com, james.hogan@imgtec.com,
        avagin@openvz.org, oleg@redhat.com, palves@redhat.com,
        dhowells@redhat.com, davej@redhat.com, mikey@neuling.org,
        benh@kernel.crashing.org
Subject: [PATCH V3 1/3] elf: Add some new PowerPC specifc note sections
Date: Fri, 23 May 2014 20:45:36 +0530
Message-Id: <1400858138-3939-2-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052315-8878-0000-0000-00000C975B7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds four new note sections for transactional memory
and one note section for some miscellaneous registers. This addition
of new elf note sections extends the existing elf ABI without affecting
it in any manner.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 include/uapi/linux/elf.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index ef6103b..4040124 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -379,6 +379,11 @@ typedef struct elf64_shdr {
 #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
 #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
 #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
+#define NT_PPC_TM_SPR	0x103		/* PowerPC TM special registers */
+#define NT_PPC_TM_CGPR	0x104		/* PowerpC TM checkpointed GPR */
+#define NT_PPC_TM_CFPR	0x105		/* PowerPC TM checkpointed FPR */
+#define NT_PPC_TM_CVMX	0x106		/* PowerPC TM checkpointed VMX */
+#define NT_PPC_MISC	0x107		/* PowerPC miscellaneous registers */
 #define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
 #define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
 #define NT_X86_XSTATE	0x202		/* x86 extended state using xsave */
-- 
1.7.11.7

