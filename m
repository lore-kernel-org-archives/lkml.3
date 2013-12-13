Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3LMGvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:51:54 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43203 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3LMGud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:50:33 -0500
X-AuditID: 9c93017e-b7c17ae000003961-c7-52aaae36ef0b
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 1/6] mm/migrate: add comment about permanent failure path
Date: Fri, 13 Dec 2013 15:53:26 +0900
Message-Id: <1386917611-11319-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386917611-11319-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1386917611-11319-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Let's add a comment about where the failed page goes to, which makes
code more readable.

Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/migrate.c b/mm/migrate.c
index 3747fcd..c6ac87a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1123,7 +1123,12 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 				nr_succeeded++;
 				break;
 			default:
-				/* Permanent failure */
+				/*
+				 * Permanent failure (-EBUSY, -ENOSYS, etc.):
+				 * unlike -EAGAIN case, the failed page is
+				 * removed from migration page list and not
+				 * retried in the next outer loop.
+				 */
 				nr_failed++;
 				break;
 			}
-- 
1.7.9.5

