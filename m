Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3LRTT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:19:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab3LRTT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:19:26 -0500
Date: Wed, 18 Dec 2013 20:19:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 3/7] mm: change release_pages() to use put_page()
	rather than put_compound_page()
Message-ID: <20131218191955.GA8322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218191913.GA6464@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change release_pages() to avoid put_compound_page() and simply
call put_page(). This adds the additional PageCompound() check
into the unlikely path but allows us to change the semantics of
put_compound_page().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/swap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index aae24fe..b0e65b6 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -819,7 +819,7 @@ void release_pages(struct page **pages, int nr, int cold)
 				spin_unlock_irqrestore(&zone->lru_lock, flags);
 				zone = NULL;
 			}
-			put_compound_page(page);
+			put_page(page);
 			continue;
 		}
 
-- 
1.5.5.1

