Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3FGJ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:57:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20556 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab3FGJ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:56:59 -0400
X-IronPort-AV: E=Sophos;i="4.87,821,1363104000"; 
   d="scan'208";a="7491541"
Message-ID: <51B1ADC7.7060708@cn.fujitsu.com>
Date: Fri, 07 Jun 2013 17:54:15 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: chanho.min@lge.com, Johannes Weiner <hannes@cmpxchg.org>,
        iamjoonsoo.kim@lge.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/3] mm, vmalloc: Remove unused purge_fragmented_blocks_thiscpu
References: <51B1AD2F.4030702@cn.fujitsu.com>
In-Reply-To: <51B1AD2F.4030702@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/07 17:55:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/07 17:55:13,
	Serialize complete at 2013/06/07 17:55:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is nowhere used now, so remove it.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/vmalloc.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b8abcba..5c037b9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -891,11 +891,6 @@ static void purge_fragmented_blocks(int cpu)
 	}
 }
 
-static void purge_fragmented_blocks_thiscpu(void)
-{
-	purge_fragmented_blocks(smp_processor_id());
-}
-
 static void purge_fragmented_blocks_allcpus(void)
 {
 	int cpu;
-- 
1.7.1

