Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab3HZBTU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 21:19:20 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60422 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3HZBTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 21:19:14 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 7/8] mm/hwpoison: add '#' to madvise_hwpoison
Date: Mon, 26 Aug 2013 09:18:50 +0800
Message-Id: <1377479931-7430-7-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377479931-7430-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377479931-7430-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082601-1618-0000-0000-000004831678
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add '#' to madvise_hwpoison.

Before patch:

[   95.892866] Injecting memory failure for page 19d0 at b7786000
[   95.893151] MCE 0x19d0: non LRU page recovery: Ignored

After patch:

[   95.892866] Injecting memory failure for page 0x19d0 at 0xb7786000
[   95.893151] MCE 0x19d0: non LRU page recovery: Ignored

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/madvise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 95795df..588bb19 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -353,14 +353,14 @@ static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
 		if (ret != 1)
 			return ret;
 		if (bhv == MADV_SOFT_OFFLINE) {
-			printk(KERN_INFO "Soft offlining page %lx at %lx\n",
+			pr_info("Soft offlining page %#lx at %#lx\n",
 				page_to_pfn(p), start);
 			ret = soft_offline_page(p, MF_COUNT_INCREASED);
 			if (ret)
 				break;
 			continue;
 		}
-		printk(KERN_INFO "Injecting memory failure for page %lx at %lx\n",
+		pr_info("Injecting memory failure for page %#lx at %#lx\n",
 		       page_to_pfn(p), start);
 		/* Ignore return value for now */
 		memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
-- 
1.8.1.2

