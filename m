Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab3IFDc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 23:32:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20270 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab3IFDc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 23:32:28 -0400
X-IronPort-AV: E=Sophos;i="4.90,850,1371052800"; 
   d="scan'208";a="8431990"
Message-ID: <52294C9D.1080808@cn.fujitsu.com>
Date: Fri, 06 Sep 2013 11:31:41 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/mmap.c: Remove unnecessary pgoff assignment
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/06 11:29:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/06 11:29:51,
	Serialize complete at 2013/09/06 11:29:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never access variable pgoff later, so the assignment is
redundant. Remove it. 

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/mmap.c |    1 - 
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index f9c97d1..db44f6a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1570,7 +1570,6 @@ munmap_back:
                WARN_ON_ONCE(addr != vma->vm_start);
 
                addr = vma->vm_start;
-               pgoff = vma->vm_pgoff;
                vm_flags = vma->vm_flags;
        } else if (vm_flags & VM_SHARED) {
                if (unlikely(vm_flags & (VM_GROWSDOWN|VM_GROWSUP)))
-- 
1.7.1
