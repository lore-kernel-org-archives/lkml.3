Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3HZIqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:46:49 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:60372 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab3HZIql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:46:41 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 9/10] mm/hwpoison: change permission of corrupt-pfn/unpoison-pfn to 0400 
Date: Mon, 26 Aug 2013 16:46:13 +0800
Message-Id: <1377506774-5377-9-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377506774-5377-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377506774-5377-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082608-9264-0000-0000-00000465A1EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hwpoison inject doesn't implement read method for corrupt-pfn/unpoison-pfn
attributes:

# cat /sys/kernel/debug/hwpoison/corrupt-pfn 
cat: /sys/kernel/debug/hwpoison/corrupt-pfn: Permission denied
# cat /sys/kernel/debug/hwpoison/unpoison-pfn 
cat: /sys/kernel/debug/hwpoison/unpoison-pfn: Permission denied

This patch change the permission of corrupt-pfn/unpoison-pfn to 0400.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/hwpoison-inject.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index 3a61efc..8b77bfd 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -88,12 +88,12 @@ static int pfn_inject_init(void)
 	 * hardware status change, hence do not require hardware support.
 	 * They are mainly for testing hwpoison in software level.
 	 */
-	dentry = debugfs_create_file("corrupt-pfn", 0600, hwpoison_dir,
+	dentry = debugfs_create_file("corrupt-pfn", 0400, hwpoison_dir,
 					  NULL, &hwpoison_fops);
 	if (!dentry)
 		goto fail;
 
-	dentry = debugfs_create_file("unpoison-pfn", 0600, hwpoison_dir,
+	dentry = debugfs_create_file("unpoison-pfn", 0400, hwpoison_dir,
 				     NULL, &unpoison_fops);
 	if (!dentry)
 		goto fail;
-- 
1.8.1.2

