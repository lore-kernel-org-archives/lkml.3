Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaJNMA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:00:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39534 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaJNMAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:00:00 -0400
X-AuditID: cbfee68d-f79296d000004278-e7-543d1039861a
From: Heesub Shin <heesub.shin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>, Dan Streetman <ddstreet@ieee.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sunae Seo <sunae.seo@samsung.com>,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [RFC PATCH 9/9] mm/zswap: use highmem pages for compressed pool
Date: Tue, 14 Oct 2014 20:59:28 +0900
Message-id: <1413287968-13940-10-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
References: <1413287968-13940-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t8zPV1LAdsQg12/ZS3mrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwR3HZpKTmZJalFunbJXBlbHp1n63gDFvFon17mBoYN7J2
	MXJySAiYSCxrXMEIYYtJXLi3nq2LkYtDSGAZo8Tppb+YYYquXTjJDJFYxCjRcOUjG0hCSKCd
	SWL7AcsuRg4ONgFtiUPbgkHCIgKREtsffmQBqWcWOMYose3eM7BtwgIeEhcajzGB2CwCqhKP
	jzxkB7F5geLHl61jg1gmJ3Hy2GSwek6g+JLZO1ggdrlLnJ/dzwQyVEJgG7vExLPn2SEGCUh8
	m3yIBeQICQFZiU0HoI6WlDi44gbLBEbhBYwMqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzFC
	YqF3B+PtA9aHGAU4GJV4eAsibUKEWBPLiitzDzGaAm2YyCwlmpwPjLi8knhDYzMjC1MTU2Mj
	c0szJXFeRamfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYt4utcJgqsu/JVd4tLMc6ZT3u
	/y9/f6+sIc/t42cmhq+VxmE8hif4Xhp5bXJaY8zJURPolXN+3SRRu4P1uiGHH84JOJ8Tu7lh
	zWrOtbza3elbZCZUaLE4Cr6Plb3fb5o57WPBdvGEQzqnjAKa3Hyu1uo67PP7qrrfyuLxLsZX
	ZUHrHaRVVb4psRRnJBpqMRcVJwIAX+4H/YACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAV1LAdsQgzOHpSzmrF/DZvHykKbF
	hbbdLBYHZy9hsri8aw6bxb01/1ktNrTMYrf4dPQRm0Xj7ndsDpweTyccZPLY9GkSu8eJGb9Z
	PPq2rGL0uP6tyGPnp82sHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxjzNj06j5bwRm2ikX79jA1MG5k7WLk5JAQMJG4duEkM4QtJnHh3nq2LkYuDiGBRYwSDVc+
	soEkhATamSS2H7DsYuTgYBPQlji0LRgkLCIQKbH94UcWkHpmgWOMEtvuPQMbKizgIXGh8RgT
	iM0ioCrx+MhDdhCbFyh+fNk6NohlchInj00Gq+cEii+ZvYMFYpe7xPnZ/UwTGHkXMDKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAiOtGfSOxhXNVgcYhTgYFTi4S2ItAkRYk0sK67MPcQo
	wcGsJMKrwGEbIsSbklhZlVqUH19UmpNafIjRFOiqicxSosn5wCSQVxJvaGxiZmRpZGZsYm5s
	rCTOe7DVOlBIID2xJDU7NbUgtQimj4mDU6qB0VtcVMppfRLv1ca3JfxGybu3/fiYsqFERO/M
	81o9/2X1TAcmnpkxe53fx5R8XXvHHfkPTXPq/FWTjoellC/av5kn/OWk07cdxR94+YcsLb9V
	WKu7Sk7+1GbhDaG281qn/+r9d8TeqlvOrORbpPHLz+4fDOY8v2K/53jQDiGGc+9ffTDf3Stq
	o8RSnJFoqMVcVJwIAJw9NGrKAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the zbud supports highmem, storing compressed anonymous pages
on highmem looks more reasonble. So, pass __GFP_HIGHMEM flag to zpool
when zswap allocates memory from it.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ea064c1..eaabe95 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -684,8 +684,8 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 
 	/* store */
 	len = dlen + sizeof(struct zswap_header);
-	ret = zpool_malloc(zswap_pool, len, __GFP_NORETRY | __GFP_NOWARN,
-		&handle);
+	ret = zpool_malloc(zswap_pool, len,
+			__GFP_NORETRY | __GFP_NOWARN | __GFP_HIGHMEM, &handle);
 	if (ret == -ENOSPC) {
 		zswap_reject_compress_poor++;
 		goto freepage;
-- 
1.9.1

