Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaKLWdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:33:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbaKLWds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:33:48 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        andi@firstfloor.org, rientjes@google.com, riel@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org, davidlohr@hp.com
Subject: [PATCH 2/3] hugetlb: alloc_bootmem_huge_page(): use IS_ALIGNED()
Date: Wed, 12 Nov 2014 17:33:12 -0500
Message-Id: <1415831593-9020-3-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com>
References: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No reason to duplicate the code of an existing macro.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9fd7227..a10fd57 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1457,7 +1457,7 @@ int __weak alloc_bootmem_huge_page(struct hstate *h)
 	return 0;
 
 found:
-	BUG_ON((unsigned long)virt_to_phys(m) & (huge_page_size(h) - 1));
+	BUG_ON(!IS_ALIGNED(virt_to_phys(m), huge_page_size(h)));
 	/* Put them into a private list first because mem_map is not up yet */
 	list_add(&m->list, &huge_boot_pages);
 	m->hstate = h;
-- 
1.9.3

