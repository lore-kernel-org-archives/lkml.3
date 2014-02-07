Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbaBGMCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:02:34 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61768 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaBGMB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:01:57 -0500
Date: Fri, 7 Feb 2014 17:31:52 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        josh@joshtriplett.org
Subject: [PATCH 1/9] mm: Mark function as static in compaction.c
Message-ID: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in compaction.c because it is not used outside
this file.

This eliminates the following warning from mm/compaction.c:
mm/compaction.c:1190:9: warning: no previous prototype for ‘sysfs_compact_node’ [-Wmissing-prototypes

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 805165b..a21f540 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1187,7 +1187,7 @@ int sysctl_extfrag_handler(struct ctl_table *table, int write,
 }
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
-ssize_t sysfs_compact_node(struct device *dev,
+static ssize_t sysfs_compact_node(struct device *dev,
 			struct device_attribute *attr,
 			const char *buf, size_t count)
 {
-- 
1.7.9.5

