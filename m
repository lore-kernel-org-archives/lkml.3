Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab3HMPC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:02:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab3HMPC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:02:26 -0400
Date: Tue, 13 Aug 2013 08:01:36 -0700
From: tip-bot for Jianguo Wu <tipbot@zytor.com>
Message-ID: <tip-d4f5228c01c130ff2c1f9240f1de22a5dfc61554@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        wangchen@cn.fujitsu.com, wujianguo@huawei.com, tglx@linutronix.de,
        iamjoonsoo.kim@lge.com, guohanjun@huawei.com, linux-mm@kvack.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        wangchen@cn.fujitsu.com, wujianguo@huawei.com, tglx@linutronix.de,
        iamjoonsoo.kim@lge.com, guohanjun@huawei.com, linux-mm@kvack.org
In-Reply-To: <5209A173.3090600@huawei.com>
References: <5209A173.3090600@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] mm: Remove unused variable idx0 in __early_ioremap()
Git-Commit-ID: d4f5228c01c130ff2c1f9240f1de22a5dfc61554
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 13 Aug 2013 08:01:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4f5228c01c130ff2c1f9240f1de22a5dfc61554
Gitweb:     http://git.kernel.org/tip/d4f5228c01c130ff2c1f9240f1de22a5dfc61554
Author:     Jianguo Wu <wujianguo@huawei.com>
AuthorDate: Tue, 13 Aug 2013 11:01:07 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 13 Aug 2013 11:46:36 +0200

mm: Remove unused variable idx0 in __early_ioremap()

After commit:

   8827247ffcc ("x86: don't define __this_fixmap_does_not_exist()")

variable idx0 is no longer needed, so just remove it.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <linux-mm@kvack.org>
Cc: <wangchen@cn.fujitsu.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Link: http://lkml.kernel.org/r/5209A173.3090600@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/ioremap.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 0215e2c..799580c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -487,7 +487,7 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 	unsigned long offset;
 	resource_size_t last_addr;
 	unsigned int nrpages;
-	enum fixed_addresses idx0, idx;
+	enum fixed_addresses idx;
 	int i, slot;
 
 	WARN_ON(system_state != SYSTEM_BOOTING);
@@ -540,8 +540,7 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 	/*
 	 * Ok, go for it..
 	 */
-	idx0 = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
-	idx = idx0;
+	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	while (nrpages > 0) {
 		early_set_fixmap(idx, phys_addr, prot);
 		phys_addr += PAGE_SIZE;
