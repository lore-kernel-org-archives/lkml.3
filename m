Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452AbaFIXKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:10:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933438AbaFIWpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 30/78] Revert "revert "mm: vmscan: do not swap anon pages just because free+file is low""
Date: Mon,  9 Jun 2014 15:48:10 -0700
Message-Id: <20140609224814.312072801@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 623762517e2370be3b3f95f4fe08d6c063a49b06.

Ben rightly points out that commit 0bf1457f0cfc, which is what this
original commit was reverting, never ended up in 3.14-stable, but was
only for 3.15.

So revert this patch as we now have the same check twice in a row, which
is pretty pointless.  Although the comments were "prettier"...

Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1916,24 +1916,6 @@ static void get_scan_count(struct lruvec
 	}
 
 	/*
-	 * Prevent the reclaimer from falling into the cache trap: as
-	 * cache pages start out inactive, every cache fault will tip
-	 * the scan balance towards the file LRU.  And as the file LRU
-	 * shrinks, so does the window for rotation from references.
-	 * This means we have a runaway feedback loop where a tiny
-	 * thrashing file LRU becomes infinitely more attractive than
-	 * anon pages.  Try to detect this based on file LRU size.
-	 */
-	if (global_reclaim(sc)) {
-		unsigned long free = zone_page_state(zone, NR_FREE_PAGES);
-
-		if (unlikely(file + free <= high_wmark_pages(zone))) {
-			scan_balance = SCAN_ANON;
-			goto out;
-		}
-	}
-
-	/*
 	 * There is enough inactive page cache, do not reclaim
 	 * anything from the anonymous working set right now.
 	 */


