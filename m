Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaFJS25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:28:57 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:21290 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbaFJS24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:28:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQNAAVOl1NbskA7/2dsb2JhbABZgw2sFAEBBpkSgQgXdYRgI4EaN4hGAcx9F4VWiHMdhCsEj12KR4soiB2DPjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 1/1] mm/readahead.c: remove unused file_ra_state from count_history_pages
Date: Tue, 10 Jun 2014 20:27:26 +0200
Message-Id: <1402424846-9652-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

count_history_pages does only call page_cache_prev_hole in rcu_lock
context using address_space mapping. There's no need to have file_ra_state
here.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/readahead.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 0ca36a7..17b9172 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -326,7 +326,6 @@ static unsigned long get_next_ra_size(struct file_ra_state *ra,
  * 	- thrashing threshold in memory tight systems
  */
 static pgoff_t count_history_pages(struct address_space *mapping,
-				   struct file_ra_state *ra,
 				   pgoff_t offset, unsigned long max)
 {
 	pgoff_t head;
@@ -349,7 +348,7 @@ static int try_context_readahead(struct address_space *mapping,
 {
 	pgoff_t size;
 
-	size = count_history_pages(mapping, ra, offset, max);
+	size = count_history_pages(mapping, offset, max);
 
 	/*
 	 * not enough history pages:
-- 
1.8.4.5

