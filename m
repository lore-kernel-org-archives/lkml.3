Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab3LIXqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:46:12 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60243 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3LIXqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:46:11 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vladimir Murzin <murzin.v@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2] mm/hwpoison: add '#' to hwpoison_inject
Date: Tue, 10 Dec 2013 07:45:57 +0800
Message-Id: <1386632757-11783-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120923-8256-0000-0000-00000A7E6722
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 v1 -> v2:
  * remove KERN_INFO in pr_info().

Add '#' to hwpoison_inject just as done in madvise_hwpoison.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/hwpoison-inject.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index 4c84678..95487c7 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -55,7 +55,7 @@ static int hwpoison_inject(void *data, u64 val)
 		return 0;
 
 inject:
-	printk(KERN_INFO "Injecting memory failure at pfn %lx\n", pfn);
+	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
 	return memory_failure(pfn, 18, MF_COUNT_INCREASED);
 }
 
-- 
1.7.5.4

