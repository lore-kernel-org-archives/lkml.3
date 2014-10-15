Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaJOKAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:00:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56641 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaJOKAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:00:48 -0400
X-AuditID: cbfee68d-f79296d000004278-0d-543e45ce257d
From: Heesub Shin <heesub.shin@samsung.com>
To: Dan Streetman <ddstreet@ieee.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sunae Seo <sunae.seo@samsung.com>,
        Heesub Shin <heesub.shin@samsung.com>
Subject: [PATCH] mm/zbud: init user ops only when it is needed
Date: Wed, 15 Oct 2014 19:00:43 +0900
Message-id: <1413367243-23524-1-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t8zTd1zrnYhBh9/SVjMWb+GzeLlIU2L
	C227WSwOzl7CZHF51xw2i3tr/rNafDr6iM2icfc7NgcOj6cTDjJ5bPo0id3jxIzfLB59W1Yx
	elz/VuTxeZNcAFsUl01Kak5mWWqRvl0CV0bzz1dMBf/ZK+78/MjawHiGrYuRk0NCwETiVNMa
	RghbTOLCvfVAcS4OIYFljBLzNv9nhina+eUbI0RiOqPE1JufoJx2JomrK38zdTFycLAJaEsc
	2hYMYooI1ElM/hwHUsIs0ABUv/MG2CBhATuJfY+usYPUsAioSszaaAUS5hVwl1i16RgTxC45
	iZPHJrOC9EoI9LNLXN3cyQ6SYBEQkPg2+RALSK+EgKzEpgNQt0lKHFxxg2UCo+ACRoZVjKKp
	BckFxUnpRYZ6xYm5xaV56XrJ+bmbGCFB3LuD8fYB60OMAhyMSjy8Fq9sQ4RYE8uKK3MPMZoC
	bZjILCWanA+MlbySeENjMyMLUxNTYyNzSzMlcV5FqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZ
	ODilGhjZL0eV7tPw/KTecOONQ/G2PT+2TdvexTMtZ+nb5+G72F/fnnjBrvzigdSFhmdjy09O
	uy4i/lVV9oVh1q1FU90b01NqgpQmeOy3U58ksH52yJ3lDUK3+VTq/f3T/5hfSXv5/vaLU2UR
	pl97UlUeumlNm8falW19kSG+v9nUSTHikLibbZtP+WIlluKMREMt5qLiRAByWTm5XQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jQd1zrnYhBr9+i1jMWb+GzeLlIU2L
	C227WSwOzl7CZHF51xw2i3tr/rNafDr6iM2icfc7NgcOj6cTDjJ5bPo0id3jxIzfLB59W1Yx
	elz/VuTxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2S
	i0+ArltmDtA9SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaM5p+vmAr+
	s1fc+fmRtYHxDFsXIyeHhICJxM4v3xghbDGJC/fWA8W5OIQEpjNKTL35iRHCaWeSuLryN1MX
	IwcHm4C2xKFtwSCmiECdxOTPcSAlzAINQPU7bzCDDBIWsJPY9+gaO0gNi4CqxKyNViBhXgF3
	iVWbjjFB7JKTOHlsMusERu4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj5Jn0DsZV
	DRaHGAU4GJV4eDkO2IYIsSaWFVfmHmKU4GBWEuEtdrELEeJNSaysSi3Kjy8qzUktPsRoCrR8
	IrOUaHI+MH7zSuINjU3MjCyNzIxNzI2NlcR5D7ZaBwoJpCeWpGanphakFsH0MXFwSjUwTpXc
	vs3hvZTG2y2LJKduvibX/ts6rO89+8ankn/aJFeWKG6v/V/belP2wcRVvTdfvv6+vtTBLHPz
	v8UWv6Y8vnTkWu+37efjK3kDj3avl9eR7zo7bZ7SgmnTIj8vmpmXev/V3PlrVbp8toj4s77Z
	LthrpXs/KP+KjmF6XcLe3ZtKfy3actK/rFSJpTgj0VCLuag4EQBl3/m5pwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When zbud is initialized through the zpool wrapper, pool->ops which
points to user-defined operations is always set regardless of whether it
is specified from the upper layer. This causes zbud_reclaim_page() to
iterate its loop for evicting pool pages out without any gain.

This patch sets the user-defined ops only when it is needed, so that
zbud_reclaim_page() can bail out the reclamation loop earlier if there
is no user-defined operations specified.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 mm/zbud.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index ecf1dbe..db8de74 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -132,7 +132,7 @@ static struct zbud_ops zbud_zpool_ops = {
 
 static void *zbud_zpool_create(gfp_t gfp, struct zpool_ops *zpool_ops)
 {
-	return zbud_create_pool(gfp, &zbud_zpool_ops);
+	return zbud_create_pool(gfp, zpool_ops ? &zbud_zpool_ops : NULL);
 }
 
 static void zbud_zpool_destroy(void *pool)
-- 
1.9.1

