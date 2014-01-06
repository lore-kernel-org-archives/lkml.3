Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbaAFXti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:49:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490AbaAFWji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 115/144] mm/mempolicy: correct putback method for isolate pages if failed
Date: Mon,  6 Jan 2014 14:37:56 -0800
Message-Id: <20140106223748.647616318@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

commit b0e5fd7359f1ce8db4ccb862b3aa80d2f2cbf4d0 upstream.

queue_pages_range() isolates hugetlbfs pages and putback_lru_pages()
can't handle these.  We should change it to putback_movable_pages().

Naoya said that it is worth going into stable, because it can break
in-use hugepage list.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1317,7 +1317,7 @@ static long do_mbind(unsigned long start
 		if (nr_failed && (flags & MPOL_MF_STRICT))
 			err = -EIO;
 	} else
-		putback_lru_pages(&pagelist);
+		putback_movable_pages(&pagelist);
 
 	up_write(&mm->mmap_sem);
  mpol_out:


