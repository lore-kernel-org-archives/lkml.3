Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3EaAhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:37:47 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:36069 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab3EaAgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:36:49 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v8 05/11] KVM: MMU: show mmu_valid_gen in shadow page related tracepoints
Date: Fri, 31 May 2013 08:36:24 +0800
Message-Id: <1369960590-14138-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053100-5490-0000-0000-0000038EDBAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show sp->mmu_valid_gen

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmutrace.h |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index b8f6172..697f466 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -7,16 +7,18 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvmmmu
 
-#define KVM_MMU_PAGE_FIELDS \
-	__field(__u64, gfn) \
-	__field(__u32, role) \
-	__field(__u32, root_count) \
+#define KVM_MMU_PAGE_FIELDS			\
+	__field(unsigned long, mmu_valid_gen)	\
+	__field(__u64, gfn)			\
+	__field(__u32, role)			\
+	__field(__u32, root_count)		\
 	__field(bool, unsync)
 
-#define KVM_MMU_PAGE_ASSIGN(sp)			     \
-	__entry->gfn = sp->gfn;			     \
-	__entry->role = sp->role.word;		     \
-	__entry->root_count = sp->root_count;        \
+#define KVM_MMU_PAGE_ASSIGN(sp)				\
+	__entry->mmu_valid_gen = sp->mmu_valid_gen;	\
+	__entry->gfn = sp->gfn;				\
+	__entry->role = sp->role.word;			\
+	__entry->root_count = sp->root_count;		\
 	__entry->unsync = sp->unsync;
 
 #define KVM_MMU_PAGE_PRINTK() ({				        \
@@ -28,8 +30,8 @@
 								        \
 	role.word = __entry->role;					\
 									\
-	trace_seq_printf(p, "sp gfn %llx %u%s q%u%s %s%s"		\
-			 " %snxe root %u %s%c",				\
+	trace_seq_printf(p, "sp gen %lx gfn %llx %u%s q%u%s %s%s"	\
+			 " %snxe root %u %s%c",	__entry->mmu_valid_gen,	\
 			 __entry->gfn, role.level,			\
 			 role.cr4_pae ? " pae" : "",			\
 			 role.quadrant,					\
-- 
1.7.7.6

