Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934933AbaGXKEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:04:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55006 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934589AbaGXJsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 084/128] ARC: Implement ptrace(PTRACE_GET_THREAD_AREA)
Date: Thu, 24 Jul 2014 10:45:33 +0100
Message-Id: <1406195177-8656-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Kolesov <Anton.Kolesov@synopsys.com>

commit a4b6cb735b25aa84a462a1985e3e43bebaf5beb4 upstream.

This patch adds implementation of GET_THREAD_AREA ptrace request type. This
is required by GDB to debug NPTL applications.

Signed-off-by: Anton Kolesov <Anton.Kolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

