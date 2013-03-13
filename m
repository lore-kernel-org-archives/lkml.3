Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3CMKHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:07:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7935 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab3CMKHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:07:06 -0400
X-IronPort-AV: E=Sophos;i="4.84,836,1355068800"; 
   d="scan'208";a="6865165"
Message-ID: <51404F67.8040307@cn.fujitsu.com>
Date: Wed, 13 Mar 2013 18:05:27 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmap: find_vma: remove the WARN_ON_ONCE(!mm) check
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/13 18:05:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/13 18:05:47,
	Serialize complete at 2013/03/13 18:05:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the WARN_ON_ONCE(!mm) check as the comment suggested.
Kernel code calls find_vma only when it is absolutely sure that the
mm_struct arg to it is non-NULL.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/mmap.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 2664a47..9da664e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1933,9 +1933,6 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
 	struct vm_area_struct *vma = NULL;
 
-	if (WARN_ON_ONCE(!mm))		/* Remove this in linux-3.6 */
-		return NULL;
-
 	/* Check the cache first. */
 	/* (Cache hit rate is typically around 35%.) */
 	vma = mm->mmap_cache;
-- 
1.7.1
