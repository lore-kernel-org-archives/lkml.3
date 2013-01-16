Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab3APA0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:26:12 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53843 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179Ab3APA0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:26:08 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <jmesmon@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 11/17] mm/kmemleak: use node_{start,end}_pfn()
Date: Tue, 15 Jan 2013 16:24:48 -0800
Message-Id: <1358295894-24167-12-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-5806-0000-0000-00001E4CE7A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <jmesmon@gmail.com>

Instead of open coding, use the exsisting node_start_pfn() and
node_end_pfn() helpers.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/kmemleak.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 752a705..83dd5fb 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1300,9 +1300,8 @@ static void kmemleak_scan(void)
 	 */
 	lock_memory_hotplug();
 	for_each_online_node(i) {
-		pg_data_t *pgdat = NODE_DATA(i);
-		unsigned long start_pfn = pgdat->node_start_pfn;
-		unsigned long end_pfn = start_pfn + pgdat->node_spanned_pages;
+		unsigned long start_pfn = node_start_pfn(i);
+		unsigned long end_pfn = node_end_pfn(i);
 		unsigned long pfn;
 
 		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
-- 
1.8.0.3

