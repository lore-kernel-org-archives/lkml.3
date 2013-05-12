Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3ELB1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 21:27:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:4397 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab3ELBVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 21:21:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,654,1363158000"; 
   d="scan'208";a="336134848"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv4 15/39] thp, mm: trigger bug in replace_page_cache_page() on THP
Date: Sun, 12 May 2013 04:23:12 +0300
Message-Id: <1368321816-17719-16-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

replace_page_cache_page() is only used by FUSE. It's unlikely that we
will support THP in FUSE page cache any soon.

Let's pospone implemetation of THP handling in replace_page_cache_page()
until any will use it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/filemap.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 657ce82..3a03426 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -428,6 +428,8 @@ int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
 {
 	int error;
 
+	VM_BUG_ON(PageTransHuge(old));
+	VM_BUG_ON(PageTransHuge(new));
 	VM_BUG_ON(!PageLocked(old));
 	VM_BUG_ON(!PageLocked(new));
 	VM_BUG_ON(new->mapping);
-- 
1.7.10.4

