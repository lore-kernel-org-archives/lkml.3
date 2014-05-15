Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaEORJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:09:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:61599 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbaEORJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:09:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1060,1389772800"; 
   d="scan'208";a="532567033"
To: Miklos Szeredi <miklos@szeredi.hu>
From: Tony Luck <tony.luck@intel.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/15] ia64: add renameat2 syscall
In-Reply-To: <CAJfpegue5pcHrhVKW533iaWzaW4mcgThRjrxwK8a5KE_8v=mAQ@mail.gmail.com>
Date: Thu, 15 May 2014 09:55:11 -0700
Message-Id: <5374f16f64083d3e1@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos,

You missed a bit (adding sys_renameat2 to the system call
entry table in arch/ia64/kernel/entry.S)

Please use this version when you send to Linus

Acked-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
index ae763d8bf55a..fb13dc5e8f8c 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -11,7 +11,7 @@
 
 
 
-#define NR_syscalls			314 /* length of syscall table */
+#define NR_syscalls			315 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
diff --git a/arch/ia64/include/uapi/asm/unistd.h b/arch/ia64/include/uapi/asm/unistd.h
index 715e85f858de..7de0a2d65da4 100644
--- a/arch/ia64/include/uapi/asm/unistd.h
+++ b/arch/ia64/include/uapi/asm/unistd.h
@@ -327,5 +327,6 @@
 #define __NR_finit_module		1335
 #define __NR_sched_setattr		1336
 #define __NR_sched_getattr		1337
+#define __NR_renameat2			1338
 
 #endif /* _UAPI_ASM_IA64_UNISTD_H */
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index fa8d61a312a7..ba3d03503e84 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1775,6 +1775,7 @@ sys_call_table:
 	data8 sys_finit_module			// 1335
 	data8 sys_sched_setattr
 	data8 sys_sched_getattr
+	data8 sys_renameat2
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
 #endif /* __IA64_ASM_PARAVIRTUALIZED_NATIVE */
