Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbaGZT0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:26:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbaGZTXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 3.15 109/109] ARC: Implement ptrace(PTRACE_GET_THREAD_AREA)
Date: Sat, 26 Jul 2014 12:03:11 -0700
Message-Id: <20140726190227.129159739@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Kolesov <Anton.Kolesov@synopsys.com>

commit a4b6cb735b25aa84a462a1985e3e43bebaf5beb4 upstream.

This patch adds implementation of GET_THREAD_AREA ptrace request type. This
is required by GDB to debug NPTL applications.

Signed-off-by: Anton Kolesov <Anton.Kolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/include/uapi/asm/ptrace.h |    1 +
 arch/arc/kernel/ptrace.c           |    4 ++++
 2 files changed, 5 insertions(+)

--- a/arch/arc/include/uapi/asm/ptrace.h
+++ b/arch/arc/include/uapi/asm/ptrace.h
@@ -11,6 +11,7 @@
 #ifndef _UAPI__ASM_ARC_PTRACE_H
 #define _UAPI__ASM_ARC_PTRACE_H
 
+#define PTRACE_GET_THREAD_AREA	25
 
 #ifndef __ASSEMBLY__
 /*
--- a/arch/arc/kernel/ptrace.c
+++ b/arch/arc/kernel/ptrace.c
@@ -146,6 +146,10 @@ long arch_ptrace(struct task_struct *chi
 	pr_debug("REQ=%ld: ADDR =0x%lx, DATA=0x%lx)\n", request, addr, data);
 
 	switch (request) {
+	case PTRACE_GET_THREAD_AREA:
+		ret = put_user(task_thread_info(child)->thr_ptr,
+			       (unsigned long __user *)data);
+		break;
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;


