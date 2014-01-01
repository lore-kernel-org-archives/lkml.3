Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbaAAA3o (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 19:29:44 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:35642 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702AbaAAA3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 19:29:43 -0500
Date: Wed, 1 Jan 2014 08:29:35 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [RFC] mm: show message when updating min_free_kbytes in thp
Message-ID: <20140101002935.GA15683@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010100-9332-0000-0000-000002A23FF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

min_free_kbytes may be updated during thp's initialization. Sometimes,
this will change the value being set by user. Showing message will
clarify this confusion.

Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>
---
 mm/huge_memory.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7de1bf8..46011c6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -130,8 +130,11 @@ static int set_recommended_min_free_kbytes(void)
 			      (unsigned long) nr_free_buffer_pages() / 20);
 	recommended_min <<= (PAGE_SHIFT-10);
 
-	if (recommended_min > min_free_kbytes)
+	if (recommended_min > min_free_kbytes) {
 		min_free_kbytes = recommended_min;
+		pr_info("min_free_kbytes is updated to %d by enabling transparent hugepage.\n",
+			min_free_kbytes);
+	}
 	setup_per_zone_wmarks();
 	return 0;
 }
-- 
1.7.7.6

