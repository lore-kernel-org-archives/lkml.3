Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3AXU3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:29:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26132 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030184Ab3AXUVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:21:09 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 29/35] x86, kdump: Remove crashkernel range find limit for 64bit
Date: Thu, 24 Jan 2013 12:20:10 -0800
Message-Id: <1359058816-7615-30-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now kexeced kernel/ramdisk could be above 4g, so remove 896 limit for
64bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/setup.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1f1c68f..563c99d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -501,13 +501,11 @@ static void __init memblock_x86_reserve_range_setup_data(void)
 /*
  * Keep the crash kernel below this limit.  On 32 bits earlier kernels
  * would limit the kernel to the low 512 MiB due to mapping restrictions.
- * On 64 bits, kexec-tools currently limits us to 896 MiB; increase this
- * limit once kexec-tools are fixed.
  */
 #ifdef CONFIG_X86_32
 # define CRASH_KERNEL_ADDR_MAX	(512 << 20)
 #else
-# define CRASH_KERNEL_ADDR_MAX	(896 << 20)
+# define CRASH_KERNEL_ADDR_MAX	MAXMEM
 #endif
 
 static void __init reserve_crashkernel(void)
-- 
1.7.10.4

