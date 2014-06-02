Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaFBFZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 01:25:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbaFBFZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 01:25:58 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 1/3] replace PAGECACHE_TAG_* definition with enumeration
Date: Mon,  2 Jun 2014 01:24:57 -0400
Message-Id: <1401686699-9723-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1401686699-9723-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <20140521193336.5df90456.akpm@linux-foundation.org>
 <1401686699-9723-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need number of pagecache tags in later patches, this patch prepares it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/fs.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git v3.15-rc7.orig/include/linux/fs.h v3.15-rc7/include/linux/fs.h
index 878031227c57..5b489df9d964 100644
--- v3.15-rc7.orig/include/linux/fs.h
+++ v3.15-rc7/include/linux/fs.h
@@ -447,9 +447,12 @@ struct block_device {
  * Radix-tree tags, for tagging dirty and writeback pages within the pagecache
  * radix trees
  */
-#define PAGECACHE_TAG_DIRTY	0
-#define PAGECACHE_TAG_WRITEBACK	1
-#define PAGECACHE_TAG_TOWRITE	2
+enum {
+	PAGECACHE_TAG_DIRTY,
+	PAGECACHE_TAG_WRITEBACK,
+	PAGECACHE_TAG_TOWRITE,
+	__NR_PAGECACHE_TAGS,
+};
 
 int mapping_tagged(struct address_space *mapping, int tag);
 
-- 
1.9.3

