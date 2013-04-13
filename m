Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3DMPkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:40:39 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58988 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab3DMPk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:40:26 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Howells <dhowells@redhat.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 01/19] mm: introduce accessor function set_max_mapnr()
Date: Sat, 13 Apr 2013 23:36:21 +0800
Message-Id: <1365867399-21323-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
References: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce accessor function set_max_mapnr() to set global variable
max_mapnr.

Also unify condition compilation for max_mapnr with
CONFIG_NEED_MULTIPLE_NODES instead of CONFIG_DISCONTIGMEM.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 include/linux/mm.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f9f9f3c..497ebaf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -25,8 +25,15 @@ struct file_ra_state;
 struct user_struct;
 struct writeback_control;
 
-#ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
+#ifndef CONFIG_NEED_MULTIPLE_NODES	/* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
+
+static inline void set_max_mapnr(unsigned long limit)
+{
+	max_mapnr = limit;
+}
+#else
+static inline void set_max_mapnr(unsigned long limit) { }
 #endif
 
 extern unsigned long totalram_pages;
-- 
1.7.9.5

