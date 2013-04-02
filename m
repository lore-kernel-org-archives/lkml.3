Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450Ab3DBLKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:10:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:64561 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3DBLKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:10:20 -0400
Message-ID: <515ABC79.5060900@huawei.com>
Date: Tue, 2 Apr 2013 19:09:45 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        <hughd@google.com>, <riel@redhat.com>, <khlebnikov@openvz.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Zhangdianfang <zhangdianfang@huawei.com>
Subject: [PATCH] mm/vmscan: fix error return in kswapd_run()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the error return value in kswapd_run(). The bug was
introduced by commit d5dc0ad928fb9e972001e552597fd0b794863f34
"mm/vmscan: fix error number for failed kthread".

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/vmscan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 88c5fed..950636e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3188,9 +3188,9 @@ int kswapd_run(int nid)
 	if (IS_ERR(pgdat->kswapd)) {
 		/* failure at boot is fatal */
 		BUG_ON(system_state == SYSTEM_BOOTING);
-		pgdat->kswapd = NULL;
 		pr_err("Failed to start kswapd on node %d\n", nid);
 		ret = PTR_ERR(pgdat->kswapd);
+		pgdat->kswapd = NULL;
 	}
 	return ret;
 }
-- 
1.7.6.1

