Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3H0Bbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:31:47 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:45335 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab3H0BbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:31:22 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Tony Luck <tony.luck@intel.com>,
        gong.chen@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 2/3] mm/hwpoison: change permission of corrupt-pfn/unpoison-pfn to 0200
Date: Tue, 27 Aug 2013 09:30:53 +0800
Message-Id: <1377567054-32442-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377567054-32442-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377567054-32442-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082701-2674-0000-0000-00000A64C491
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hwpoison inject doesn't implement read method for corrupt-pfn/unpoison-pfn
attributes:

# cat /sys/kernel/debug/hwpoison/corrupt-pfn
cat: /sys/kernel/debug/hwpoison/corrupt-pfn: Permission denied
# cat /sys/kernel/debug/hwpoison/unpoison-pfn
cat: /sys/kernel/debug/hwpoison/unpoison-pfn: Permission denied

This patch change the permission of corrupt-pfn/unpoison-pfn to 0200.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/hwpoison-inject.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index 3a61efc..afc2daa 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -88,12 +88,12 @@ static int pfn_inject_init(void)
 	 * hardware status change, hence do not require hardware support.
 	 * They are mainly for testing hwpoison in software level.
 	 */
-	dentry = debugfs_create_file("corrupt-pfn", 0600, hwpoison_dir,
+	dentry = debugfs_create_file("corrupt-pfn", 0200, hwpoison_dir,
 					  NULL, &hwpoison_fops);
 	if (!dentry)
 		goto fail;
 
-	dentry = debugfs_create_file("unpoison-pfn", 0600, hwpoison_dir,
+	dentry = debugfs_create_file("unpoison-pfn", 0200, hwpoison_dir,
 				     NULL, &unpoison_fops);
 	if (!dentry)
 		goto fail;
-- 
1.8.1.2

