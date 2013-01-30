Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3A3B1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:27:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43677 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3A3B1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:27:16 -0500
Date: Tue, 29 Jan 2013 17:27:04 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-9735e91e9c29c0d8fe432aef1152e43e50bdb316@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, jarkko.sakkinen@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, jarkko.sakkinen@intel.com,
        hpa@linux.intel.com
In-Reply-To: <1359058816-7615-10-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-10-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, 64bit, realmode:
  Use init_level4_pgt to set trampoline_pgd directly
Git-Commit-ID: 9735e91e9c29c0d8fe432aef1152e43e50bdb316
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:27:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9735e91e9c29c0d8fe432aef1152e43e50bdb316
Gitweb:     http://git.kernel.org/tip/9735e91e9c29c0d8fe432aef1152e43e50bdb316
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:50 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:12:30 -0800

x86, 64bit, realmode: Use init_level4_pgt to set trampoline_pgd directly

with #PF handler way to set early page table, level3_ident will go away with
64bit native path.

So just use entries in init_level4_pgt to set them in trampoline_pgd.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-10-git-send-email-yinghai@kernel.org
Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Acked-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/realmode/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index c44ea7c..ffee06a 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -78,8 +78,8 @@ void __init setup_real_mode(void)
 	*trampoline_cr4_features = read_cr4();
 
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
-	trampoline_pgd[0] = __pa(level3_ident_pgt) + _KERNPG_TABLE;
-	trampoline_pgd[511] = __pa(level3_kernel_pgt) + _KERNPG_TABLE;
+	trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
+	trampoline_pgd[511] = init_level4_pgt[511].pgd;
 #endif
 }
 
