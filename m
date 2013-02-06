Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab3BFFZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:25:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:13190 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab3BFFZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:25:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,613,1355068800"; 
   d="scan'208";a="6694992"
Message-ID: <5111E72C.5000709@cn.fujitsu.com>
Date: Wed, 06 Feb 2013 13:16:28 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] ia64: use %ld to print pages calculated in nr_free_buffer_pages
References: <5111E612.4010907@cn.fujitsu.com>
In-Reply-To: <5111E612.4010907@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 13:16:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 13:16:46,
	Serialize complete at 2013/02/06 13:16:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the function nr_free_buffer_pages returns unsigned long, so
use %ld to print its return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/ia64/mm/contig.c    |    2 +-
 arch/ia64/mm/discontig.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/mm/contig.c b/arch/ia64/mm/contig.c
index 1516d1d..80dab50 100644
--- a/arch/ia64/mm/contig.c
+++ b/arch/ia64/mm/contig.c
@@ -93,7 +93,7 @@ void show_mem(unsigned int filter)
 	printk(KERN_INFO "%d pages swap cached\n", total_cached);
 	printk(KERN_INFO "Total of %ld pages in page table cache\n",
 	       quicklist_total_size());
-	printk(KERN_INFO "%d free buffer pages\n", nr_free_buffer_pages());
+	printk(KERN_INFO "%ld free buffer pages\n", nr_free_buffer_pages());
 }
 
 
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index c641333..b8a8fa3 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -666,7 +666,7 @@ void show_mem(unsigned int filter)
 	printk(KERN_INFO "%d pages swap cached\n", total_cached);
 	printk(KERN_INFO "Total of %ld pages in page table cache\n",
 	       quicklist_total_size());
-	printk(KERN_INFO "%d free buffer pages\n", nr_free_buffer_pages());
+	printk(KERN_INFO "%ld free buffer pages\n", nr_free_buffer_pages());
 }
 
 /**
-- 
1.7.1

