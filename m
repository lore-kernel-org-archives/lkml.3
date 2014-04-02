Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbaDBHE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:04:27 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40669 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbaDBHE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:04:26 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: avagin@openvz.org, oleg@redhat.com, roland@redhat.com, mikey@neuling.org,
        benh@kernel.crashing.org,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 1/3] elf: Add some new PowerPC specifc note sections
Date: Wed,  2 Apr 2014 12:32:22 +0530
Message-Id: <1396422144-11032-2-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040207-5490-0000-0000-0000054AFA45
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
index ef6103b..bd59452 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -379,6 +379,11 @@ typedef struct elf64_shdr {
 #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
 #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
 #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
+#define NT_PPC_TM_SPR	0x103		/* PowerPC transactional memory special registers */
+#define NT_PPC_TM_CGPR	0x104		/* PowerpC transactional memory checkpointed GPR */
+#define NT_PPC_TM_CFPR	0x105		/* PowerPC transactional memory checkpointed FPR */
+#define NT_PPC_TM_CVMX	0x106		/* PowerPC transactional memory checkpointed VMX */
+#define NT_PPC_MISC	0x107		/* PowerPC miscellaneous registers */
 #define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
 #define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
 #define NT_X86_XSTATE	0x202		/* x86 extended state using xsave */
-- 
1.7.11.7

