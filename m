Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbaEPMtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:49:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49646 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856AbaEPMsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Aneesh Kumar" <aneesh.kumar@linux.vnet.ibm.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Joonsoo Kim" <iamjoonsoo.kim@lge.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "Mizuma, Masayoshi" <m.mizuma@jp.fujitsu.com>,
        "Naoya Horiguchi" <n-horiguchi@ah.jp.nec.com>,
        "Michal Hocko" <mhocko@suse.cz>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.232726135@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 16/34] mm/hugetlb.c: add cond_resched_lock() in
 return_unused_surplus_pages()
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Mizuma, Masayoshi" <m.mizuma@jp.fujitsu.com>

commit 7848a4bf51b34f41fcc9bd77e837126d99ae84e3 upstream.

soft lockup in freeing gigantic hugepage fixed in commit 55f67141a892 "mm:
hugetlb: fix softlockup when a large number of hugepages are freed." can
happen in return_unused_surplus_pages(), so let's fix it.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/hugetlb.c | 1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1078,6 +1078,7 @@ static void return_unused_surplus_pages(
 	while (nr_pages--) {
 		if (!free_pool_huge_page(h, &node_states[N_HIGH_MEMORY], 1))
 			break;
+		cond_resched_lock(&hugetlb_lock);
 	}
 }
 

