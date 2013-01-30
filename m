Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3A3Bub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:50:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3A3Bu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:50:29 -0500
Date: Tue, 29 Jan 2013 17:50:16 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-574d69ea03612f707e7d8116ffe12a24f088bc1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-30-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-30-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, kdump:
  Remove crashkernel range find limit for 64bit
Git-Commit-ID: 574d69ea03612f707e7d8116ffe12a24f088bc1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:50:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  574d69ea03612f707e7d8116ffe12a24f088bc1e
Gitweb:     http://git.kernel.org/tip/574d69ea03612f707e7d8116ffe12a24f088bc1e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:10 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:31:56 -0800

x86, kdump: Remove crashkernel range find limit for 64bit

Now kexeced kernel/ramdisk could be above 4g, so remove 896 limit for
64bit.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-30-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index bbe8cdf..4778dde 100644
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
