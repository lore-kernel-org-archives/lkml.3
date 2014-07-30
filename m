Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaG3MUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:20:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36807 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037AbaG3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 75/94] ARC: Implement ptrace(PTRACE_GET_THREAD_AREA)
Date: Wed, 30 Jul 2014 14:15:04 +0200
Message-Id: <70e52877b68404f462227167ab1c4549e53865fc.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Kolesov <Anton.Kolesov@synopsys.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a4b6cb735b25aa84a462a1985e3e43bebaf5beb4 upstream.

This patch adds implementation of GET_THREAD_AREA ptrace request type. This
is required by GDB to debug NPTL applications.

Signed-off-by: Anton Kolesov <Anton.Kolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arc/include/uapi/asm/ptrace.h | 1 +
 arch/arc/kernel/ptrace.c           | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/arc/include/uapi/asm/ptrace.h b/arch/arc/include/uapi/asm/ptrace.h
index 2618cc13ba75..76a7739aab1c 100644
--- a/arch/arc/include/uapi/asm/ptrace.h
+++ b/arch/arc/include/uapi/asm/ptrace.h
@@ -11,6 +11,7 @@
 #ifndef _UAPI__ASM_ARC_PTRACE_H
 #define _UAPI__ASM_ARC_PTRACE_H
 
+#define PTRACE_GET_THREAD_AREA	25
 
 #ifndef __ASSEMBLY__
 /*
diff --git a/arch/arc/kernel/ptrace.c b/arch/arc/kernel/ptrace.c
index 5d76706139dd..13b3ffb27a38 100644
--- a/arch/arc/kernel/ptrace.c
+++ b/arch/arc/kernel/ptrace.c
@@ -146,6 +146,10 @@ long arch_ptrace(struct task_struct *child, long request,
 	pr_debug("REQ=%ld: ADDR =0x%lx, DATA=0x%lx)\n", request, addr, data);
 
 	switch (request) {
+	case PTRACE_GET_THREAD_AREA:
+		ret = put_user(task_thread_info(child)->thr_ptr,
+			       (unsigned long __user *)data);
+		break;
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
-- 
2.0.1

