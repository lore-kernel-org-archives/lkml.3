Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbaFYSOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:14:30 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:19254 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757845AbaFYSO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:14:29 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4HADQRq1NXQ7ge/2dsb2JhbABZgw2rLgsFAZR6hECBDhd1hGAjgRo3iEYBqnWYGBeFY4g1ZB2ELQWPdIpdizaINYNEO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Boaz Harrosh <bharrosh@panasas.com>,
        osd-dev@open-osd.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/exofs/ore_raid.c: replace count*size kzalloc by kcalloc
Date: Wed, 25 Jun 2014 20:14:23 +0200
Message-Id: <1403720063-19061-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: osd-dev@open-osd.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/exofs/ore_raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exofs/ore_raid.c b/fs/exofs/ore_raid.c
index 7f20f25..84529b8 100644
--- a/fs/exofs/ore_raid.c
+++ b/fs/exofs/ore_raid.c
@@ -116,7 +116,7 @@ static int _sp2d_alloc(unsigned pages_in_unit, unsigned group_width,
 			num_a1pa = min_t(unsigned, PAGE_SIZE / sizeof__a1pa,
 							pages_in_unit - i);
 
-			__a1pa = kzalloc(num_a1pa * sizeof__a1pa, GFP_KERNEL);
+			__a1pa = kcalloc(num_a1pa, sizeof__a1pa, GFP_KERNEL);
 			if (unlikely(!__a1pa)) {
 				ORE_DBGMSG("!! Failed to _alloc_1p_arrays=%d\n",
 					   num_a1pa);
-- 
1.9.1

