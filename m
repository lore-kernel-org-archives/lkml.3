Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab3FMTUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:20:38 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44099 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460Ab3FMTUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:20:36 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, Bob Liu <bob.liu@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] zswap: init under_reclaim
Date: Thu, 13 Jun 2013 14:19:14 -0500
Message-Id: <1371151154-22360-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061319-7182-0000-0000-00000751D61D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Liu reported a memory leak in zswap.  This was due to the
under_reclaim field in the zbud header not being initialized
to 0, which resulted in zbud_free() not freeing the page
under the false assumption that the page was undergoing
zbud reclaim.

This patch properly initializes the under_reclaim field.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Reported-by: Bob Liu <bob.liu@oracle.com>
---
 mm/zbud.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/zbud.c b/mm/zbud.c
index d63ae6e..9bb4710 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -138,6 +138,7 @@ static struct zbud_header *init_zbud_page(struct page *page)
 	zhdr->last_chunks = 0;
 	INIT_LIST_HEAD(&zhdr->buddy);
 	INIT_LIST_HEAD(&zhdr->lru);
+	zhdr->under_reclaim = 0;
 	return zhdr;
 }
 
-- 
1.7.9.5

