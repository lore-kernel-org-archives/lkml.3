Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3FNKG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 06:06:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46251 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3FNKG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 06:06:56 -0400
X-AuditID: cbfee691-b7fef6d000002d62-7b-51baeb3e2bee
From: Heesub Shin <heesub.shin@samsung.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, kyungmin.park@samsung.com, d.j.shin@samsung.com,
        sunae.seo@samsung.com, Heesub Shin <heesub.shin@samsung.com>
Subject: [PATCH] mm: vmscan: remove redundant querying to shrinker
Date: Fri, 14 Jun 2013 19:07:51 +0900
Message-id: <1371204471-13518-1-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.8.3.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t8zLV2717sCDR4/V7aYs34Nm8WJi7UW
	B2cvYbI42/SG3eLyrjlsFvfW/Ge1mPzuGaPF3yvrWSwad79jc+D02PRpErvHiRm/WTze77vK
	5tG3ZRWjx+bT1R6fN8kFsEVx2aSk5mSWpRbp2yVwZcxaNoe54DNnxYZ/D1kbGN+zdzFyckgI
	mEh8ObWEGcIWk7hwbz1bFyMXh5DAMkaJ/q5/QA4HWNGpVTIQ8UWMEnebz7JDOG1MEst+LGAC
	KWIT0JY4tC0YZJCIgKzE1L/nWUBqmAVOMkoc7XzMBpIQFnCSeH7kGdhQFgFViRsTYkDCvALu
	Eo1n7jBCHKEgMeXhe2aQXgmBeewSnd+7mEASLAICEt8mH2KBOEhWYtMBqKMlJQ6uuMEygVFw
	ASPDKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQcJ64g/H+AetDjMlA4yYyS4km5wPjIa8k
	3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjEsVORT8
	OHcxXdnkZiis99Ce6+fJS688MiR3Xot/U/np95RfS7mfbO5fYJx4rOXEyvhp4VtuS5T8atNf
	GvSmQFng8Yx/hzS336phVc3PYFv2wHazkWmsbhGj96Wr4Zd6YxLyrqQ/1zl+6E2lLdtUtwDu
	vzHnzi8+EaTzeeqj0092JpzjbKjsN1JiKc5INNRiLipOBAB/1P3MfQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jAV2717sCDTZfk7eYs34Nm8WJi7UW
	B2cvYbI42/SG3eLyrjlsFvfW/Ge1mPzuGaPF3yvrWSwad79jc+D02PRpErvHiRm/WTze77vK
	5tG3ZRWjx+bT1R6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynk
	Jeam2iq5+AToumXmAB2lpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8yY
	tWwOc8FnzooN/x6yNjC+Z+9i5OCQEDCROLVKpouRE8gUk7hwbz1bFyMXh5DAIkaJu81n2SGc
	NiaJZT8WMIE0sAloSxzaFgzSICIgKzH173kWkBpmgZOMEkc7H7OBJIQFnCSeH3nGBlLPIqAq
	cWNCDEiYV8BdovHMHUaIZQoSUx6+Z57AyL2AkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4m
	RnC0PJPawbiyweIQowAHoxIPb8KFnYFCrIllxZW5hxglOJiVRHjD/wKFeFMSK6tSi/Lji0pz
	UosPMSYDLZ/ILCWanA+M5LySeENjEzMjSyMzYxNzY2PShJXEeQ+0WgcKCaQnlqRmp6YWpBbB
	bGHi4JRqYFRVVJuv9UJXjv3B/OOP7WSfiN2Uml8218J+4lPBRXkOGeuOyjDMaQmUM1mg6col
	0MTZ/f1rs4/oqu6QQ/evvg/9xKP+6PhVbVvbCI7XC1cKcrxm+u3h1J7sdL63fc0Mlb+ffly/
	5bt05hXPk+EbL/dtM9uxwqri7PqmLf+fzN78XUVzReHtq4lKLMUZiYZazEXFiQBh6ct42gIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shrink_slab() queries each slab cache to get the number of
elements in it. In most cases such queries are cheap but,
on some caches. For example, Android low-memory-killer,
which is operates as a slab shrinker, does relatively
long calculation once invoked and it is quite expensive.

This patch removes redundant queries to shrinker function
in the loop of shrink batch.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fa6a853..11b6695 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -282,9 +282,8 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 					max_pass, delta, total_scan);
 
 		while (total_scan >= batch_size) {
-			int nr_before;
+			int nr_before = max_pass;
 
-			nr_before = do_shrinker_shrink(shrinker, shrink, 0);
 			shrink_ret = do_shrinker_shrink(shrinker, shrink,
 							batch_size);
 			if (shrink_ret == -1)
@@ -293,6 +292,7 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 				ret += nr_before - shrink_ret;
 			count_vm_events(SLABS_SCANNED, batch_size);
 			total_scan -= batch_size;
+			max_pass = shrink_ret;
 
 			cond_resched();
 		}
-- 
1.8.3.1

