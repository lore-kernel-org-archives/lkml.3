Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbaLBH52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:57:28 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40263 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173AbaLBH5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:57:24 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        mpe@ellerman.id.au, sam.bobroff@au1.ibm.com, kirjanov@gmail.com,
        shuahkh@osg.samsung.com
Subject: [PATCH V6 1/9] elf: Add new powerpc specifc core note sections
Date: Tue,  2 Dec 2014 13:26:45 +0530
Message-Id: <1417507013-11948-2-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417507013-11948-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1417507013-11948-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120207-0029-0000-0000-000000BA4C2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds four new ELF core note sections for powerpc
transactional memory and one new ELF core note section for
powerpc general miscellaneous debug registers. These addition
of new ELF core note sections extends the existing ELF ABI
without affecting it in any manner.

Acked-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 include/uapi/linux/elf.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index ea9bf25..2260fc0 100644
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
1.9.3

