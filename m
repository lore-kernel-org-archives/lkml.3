Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3JHNaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:30:14 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22713 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3JHNaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:30:08 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-01-525408de7340
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Liu <bob.liu@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 4/6] zbud: memset zbud_header to 0 during init
Date: Tue, 08 Oct 2013 15:29:38 +0200
Message-id: <1381238980-2491-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1381238980-2491-1-git-send-email-k.kozlowski@samsung.com>
References: <1381238980-2491-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t/xa7r3OEKCDLofWljMWb+GzWLjjPWs
	Fl2nprJYfHr5gNHi9QtDi7NNb9gtLu+aw2Zxb81/Vou1R+6yW0x+94zRYtnX9+wWh/atYreY
	1/6S1YHXY/Gel0wem1Z1snls+jSJ3ePEjN8sHg8ObWbx+Pj0FotH35ZVjB6bT1d7fN4kF8AZ
	xWWTkpqTWZZapG+XwJUx4w9/wQS2ivl9P1kaGJtZuxg5OCQETCTOPC7sYuQEMsUkLtxbz9bF
	yMUhJLCUUWL2/xZmCKePSWLB81XsIFVsAsYSm5cvYQOxRQT6GCUmXbYAKWIW+MckMWHHZSaQ
	hLCAo8TC3o1gDSwCqhJbO3aCxXkF3CSWfJzBDLFZQWLOJBsQk1PAXWLBQQmQCiGgit9bnzBN
	YORdwMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkYL/uYFx6zOoQowAHoxIPr8DhoCAh
	1sSy4srcQ4wSHMxKIrx8/4ODhHhTEiurUovy44tKc1KLDzEycXBKNTAKpW8TMbP+W/G+87mT
	UXzovc1cFRzcUpruhl/zJq2dK7dP/ubcZ5wSUVw9tjcsb52T2m0gspJLMC1jJvdGJp8T3mbM
	bQvyzObeEGyWYi9sr9XZcOtzc/CO4/ct//YukPeJXdXFV/+0/2rhPp4jL+9y2kfKb0jedKZY
	eP0609umZtmG1Uvf2CuxFGckGmoxFxUnAgC3Q5JrNgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memset zbud_header to 0 during init instead of manually assigning 0 to
members. Currently only two members needs to be initialized to 0 but
further patches will add more of them.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 mm/zbud.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index 6db0557..0edd880 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -133,8 +133,7 @@ static int size_to_chunks(int size)
 static struct zbud_header *init_zbud_page(struct page *page)
 {
 	struct zbud_header *zhdr = page_address(page);
-	zhdr->first_chunks = 0;
-	zhdr->last_chunks = 0;
+	memset(zhdr, 0, sizeof(*zhdr));
 	INIT_LIST_HEAD(&zhdr->buddy);
 	INIT_LIST_HEAD(&zhdr->lru);
 	return zhdr;
-- 
1.7.9.5

