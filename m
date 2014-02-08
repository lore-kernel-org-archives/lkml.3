Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaBHHvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:51:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:13482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbaBHHv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:51:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="451781100"
From: Andi Kleen <ak@linux.intel.com>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/6] kbuild: Put kallsyms into own section
Date: Sat,  8 Feb 2014 08:50:36 +0100
Message-Id: <1391845840-28514-2-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845840-28514-1-git-send-email-ak@linux.intel.com>
References: <1391845840-28514-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put the kallsyms information into an own .kallsyms section.
This makes it easier to patch the kallsyms inside the executable.
Otherwise it shouldn't change anything.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/asm-generic/vmlinux.lds.h | 4 ++++
 scripts/kallsyms.c                | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bc2121f..6214f18 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -280,6 +280,10 @@
 									\
 	TRACEDATA							\
 									\
+	.kallsyms          : AT(ADDR(.kallsyms) - LOAD_OFFSET) {	\
+		*(.kallsyms)						\
+	}								\
+									\
 	/* Kernel symbol table: Normal symbols */			\
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 56f5986..ceef756 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -314,7 +314,7 @@ static void write_src(void)
 	printf("#define ALGN .align 4\n");
 	printf("#endif\n");
 
-	printf("\t.section .rodata, \"a\"\n");
+	printf("\t.section .kallsyms, \"a\"\n");
 
 	/* Provide proper symbols relocatability by their '_text'
 	 * relativeness.  The symbol names cannot be used to construct
-- 
1.8.5.2

