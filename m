Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab3H0Cjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 22:39:49 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39578 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab3H0Cjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 22:39:48 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Tony Luck <tony.luck@intel.com>,
        gong.chen@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 3/3] mm/hwpoison: fix return value of madvise_hwpoison
Date: Tue, 27 Aug 2013 10:39:31 +0800
Message-Id: <1377571171-9958-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377571171-9958-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377571171-9958-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082702-0260-0000-0000-000003864002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value outside for loop is always zero which means madvise_hwpoison 
return success, however, this is not truth for soft_offline_page w/ failure
return value.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index a20764c..19b71e4 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -359,7 +359,7 @@ static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
 				page_to_pfn(p), start);
 			ret = soft_offline_page(p, MF_COUNT_INCREASED);
 			if (ret)
-				break;
+				return ret;
 			continue;
 		}
 		pr_info("Injecting memory failure for page %#lx at %#lx\n",
-- 
1.8.1.2

