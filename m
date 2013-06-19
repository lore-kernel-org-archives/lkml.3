Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3FSG4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:56:06 -0400
Received: from intranet.asianux.com ([58.214.24.6]:23091 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3FSG4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:56:05 -0400
X-Spam-Score: -100.8
Message-ID: <51C155D1.3090304@asianux.com>
Date: Wed, 19 Jun 2013 14:55:13 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, hannes@cmpxchg.org, riel@redhat.com,
        mhocko@suse.cz
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/vmscan.c: 'lru' may be used without initialized after
 the patch "3abf380..." in next-20130607 tree
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'lru' may be used without initialized, so need regressing part of the
related patch.

The related patch:
  "3abf380 mm: remove lru parameter from __lru_cache_add and lru_cache_add_lru"


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 mm/vmscan.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fe73724..e92b1858 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -595,6 +595,7 @@ redo:
 		 * unevictable page on [in]active list.
 		 * We know how to handle that.
 		 */
+		lru = !!TestClearPageActive(page) + page_lru_base_type(page);
 		lru_cache_add(page);
 	} else {
 		/*
-- 
1.7.7.6
