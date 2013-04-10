Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936106Ab3DJUCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:02:30 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50278 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3DJUC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:02:29 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] mm: Rewrite the comment over migrate_pages() more
 comprehensibly
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Date: Thu, 11 Apr 2013 01:29:48 +0530
Message-ID: <20130410195919.17355.23052.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041019-7014-0000-0000-000002D57667
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment over migrate_pages() looks quite weird, and makes it hard
to grasp what it is trying to say. Rewrite it more comprehensibly.

Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 mm/migrate.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 3bbaf5d..3618b04 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -973,19 +973,23 @@ out:
 }
 
 /*
- * migrate_pages
+ * migrate_pages - migrate the pages specified in a list, to the free pages
+ *		   supplied as the target for the page migration
  *
- * The function takes one list of pages to migrate and a function
- * that determines from the page to be migrated and the private data
- * the target of the move and allocates the page.
+ * @from:		The list of pages to be migrated.
+ * @get_new_page:	The function used to allocate free pages to be used
+ *			as the target of the page migration.
+ * @private:		Private data to be passed on to get_new_page()
+ * @mode:		The migration mode that specifies the constraints for
+ *			page migration, if any.
+ * @reason:		The reason for page migration.
  *
- * The function returns after 10 attempts or if no pages
- * are movable anymore because to has become empty
- * or no retryable pages exist anymore.
- * Caller should call putback_lru_pages to return pages to the LRU
+ * The function returns after 10 attempts or if no pages are movable any more
+ * because the list has become empty or no retryable pages exist any more.
+ * The caller should call putback_lru_pages() to return pages to the LRU
  * or free list only if ret != 0.
  *
- * Return: Number of pages not migrated or error code.
+ * Returns the number of pages that were not migrated, or an error code.
  */
 int migrate_pages(struct list_head *from, new_page_t get_new_page,
 		unsigned long private, enum migrate_mode mode, int reason)

