Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbaISPc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:32:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:60855 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219AbaISPav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:30:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,555,1406617200"; 
   d="scan'208";a="605437166"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: sparse@chrisli.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, Brian Norris <computersforpeace@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 2/7] x86: Silence initializer-overrides warnings
Date: Fri, 19 Sep 2014 08:29:35 -0700
Message-Id: <1411140580-20909-3-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Since the syscall table intentionally uses override initialization,
simply silence those warnings.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: <x86@kernel.org>
CC: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 arch/x86/ia32/syscall_ia32.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/ia32/syscall_ia32.c b/arch/x86/ia32/syscall_ia32.c
index 4754ba0..7bc553b 100644
--- a/arch/x86/ia32/syscall_ia32.c
+++ b/arch/x86/ia32/syscall_ia32.c
@@ -15,6 +15,7 @@ typedef void (*sys_call_ptr_t)(void);
 
 extern void compat_ni_syscall(void);
 
+DIAG_PUSH DIAG_CLANG_IGNORE(initializer-overrides)
 const sys_call_ptr_t ia32_sys_call_table[__NR_ia32_syscall_max+1] = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
@@ -23,3 +24,4 @@ const sys_call_ptr_t ia32_sys_call_table[__NR_ia32_syscall_max+1] = {
 	[0 ... __NR_ia32_syscall_max] = &compat_ni_syscall,
 #include <asm/syscalls_32.h>
 };
+DIAG_POP
-- 
1.9.3

