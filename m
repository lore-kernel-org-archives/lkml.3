Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab3EZF7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 01:59:38 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43742 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3EZF67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 01:58:59 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 5/6] mm/pageblock: remove get/set_pageblock_flags 
Date: Sun, 26 May 2013 13:58:40 +0800
Message-Id: <1369547921-24264-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1369547921-24264-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052605-9264-0000-0000-000003D15849
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog: 
 v1 -> v2: 
	* add Michal reviewed-by 

get_pageblock_flags and set_pageblock_flags are not used any 
more, this patch remove them.

Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 include/linux/pageblock-flags.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index be655e4..2ee8cd2 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -80,10 +80,4 @@ void set_pageblock_flags_group(struct page *page, unsigned long flags,
 							PB_migrate_skip)
 #endif /* CONFIG_COMPACTION */
 
-#define get_pageblock_flags(page) \
-			get_pageblock_flags_group(page, 0, PB_migrate_end)
-#define set_pageblock_flags(page, flags) \
-			set_pageblock_flags_group(page, flags,	\
-						  0, PB_migrate_end)
-
 #endif	/* PAGEBLOCK_FLAGS_H */
-- 
1.8.1.2

