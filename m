Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3BFFZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:25:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:13190 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab3BFFZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:25:54 -0500
X-IronPort-AV: E=Sophos;i="4.84,613,1355068800"; 
   d="scan'208";a="6694991"
Message-ID: <5111E761.5070203@cn.fujitsu.com>
Date: Wed, 06 Feb 2013 13:17:21 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] fs/buffer.c: change type of max_buffer_heads to unsigned
 long
References: <5111E612.4010907@cn.fujitsu.com>
In-Reply-To: <5111E612.4010907@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 13:17:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 13:17:39,
	Serialize complete at 2013/02/06 13:17:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_buffer_heads is calculated from nr_free_buffer_pages(), so
change its type to unsigned long in case of overflow.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 fs/buffer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 7a75c3e..3eb675b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3227,7 +3227,7 @@ static struct kmem_cache *bh_cachep __read_mostly;
  * Once the number of bh's in the machine exceeds this level, we start
  * stripping them in writeback.
  */
-static int max_buffer_heads;
+static unsigned long max_buffer_heads;
 
 int buffer_heads_over_limit;
 
@@ -3343,7 +3343,7 @@ EXPORT_SYMBOL(bh_submit_read);
 
 void __init buffer_init(void)
 {
-	int nrpages;
+	unsigned long nrpages;
 
 	bh_cachep = kmem_cache_create("buffer_head",
 			sizeof(struct buffer_head), 0,
-- 
1.7.1

