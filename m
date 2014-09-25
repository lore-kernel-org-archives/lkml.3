Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaIYTny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:43:54 -0400
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:50865
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751500AbaIYTnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:43:53 -0400
From: Anish Bhatt <anish@chelsio.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        sebastian@fds-team.de, Anish Bhatt <anish@chelsio.com>
Subject: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
Date: Thu, 25 Sep 2014 12:42:51 -0700
Message-Id: <1411674171-24442-1-git-send-email-anish@chelsio.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSR_SYSCALL_MASK, which is responsible for clearing specific EFLAGS on
 syscall entry, should also clear the nested task (NT) flag to be safe from
 userspace injection. Without this fix the application segmentation
 faults on syscall return because of the changed meaning of the IRET
 instruction.

Further details can be seen here https://bugs.winehq.org/show_bug.cgi?id=33275

Signed-off-by: Anish Bhatt <anish@chelsio.com>
Signed-off-by: Sebastian Lackner <sebastian@fds-team.de>
---
 arch/x86/kernel/cpu/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b4..3126558 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1184,7 +1184,7 @@ void syscall_init(void)
 	/* Flags to clear on syscall */
 	wrmsrl(MSR_SYSCALL_MASK,
 	       X86_EFLAGS_TF|X86_EFLAGS_DF|X86_EFLAGS_IF|
-	       X86_EFLAGS_IOPL|X86_EFLAGS_AC);
+	       X86_EFLAGS_IOPL|X86_EFLAGS_AC|X86_EFLAGS_NT);
 }
 
 /*
-- 
2.1.0

