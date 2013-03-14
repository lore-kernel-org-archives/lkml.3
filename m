Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934Ab3CNRxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:53:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:52023 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934594Ab3CNRtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:49:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,845,1355126400"; 
   d="scan'208";a="279559779"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2, RFC 10/30] thp, mm: locking tail page is a bug
Date: Thu, 14 Mar 2013 19:50:15 +0200
Message-Id: <1363283435-7666-11-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/filemap.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 0ff3403..38fdc92 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -669,6 +669,7 @@ void __lock_page(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
+	VM_BUG_ON(PageTail(page));
 	__wait_on_bit_lock(page_waitqueue(page), &wait, sleep_on_page,
 							TASK_UNINTERRUPTIBLE);
 }
@@ -678,6 +679,7 @@ int __lock_page_killable(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
+	VM_BUG_ON(PageTail(page));
 	return __wait_on_bit_lock(page_waitqueue(page), &wait,
 					sleep_on_page_killable, TASK_KILLABLE);
 }
-- 
1.7.10.4

