Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaAFXsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:48:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbaAFWjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Rafael Aquini <aquini@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 116/144] mm/compaction: respect ignore_skip_hint in update_pageblock_skip
Date: Mon,  6 Jan 2014 14:37:57 -0800
Message-Id: <20140106223748.673725492@linuxfoundation.org>
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

commit 6815bf3f233e0b10c99a758497d5d236063b010b upstream.

update_pageblock_skip() only fits to compaction which tries to isolate
by pageblock unit.  If isolate_migratepages_range() is called by CMA, it
try to isolate regardless of pageblock unit and it don't reference
get_pageblock_skip() by ignore_skip_hint.  We should also respect it on
update_pageblock_skip() to prevent from setting the wrong information.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -134,6 +134,10 @@ static void update_pageblock_skip(struct
 			bool migrate_scanner)
 {
 	struct zone *zone = cc->zone;
+
+	if (cc->ignore_skip_hint)
+		return;
+
 	if (!page)
 		return;
 


