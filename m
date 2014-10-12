Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbaJLLtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:49:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35525 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbaJLLs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:48:56 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-05-543a6aa146bd
From: Pintu Kumar <pintu.k@samsung.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, hannes@cmpxchg.org, mgorman@suse.de,
        vdavydov@parallels.com, mhocko@suse.cz, suleiman@google.com
Cc: cpgs@samsung.com, pintu.k@samsung.com, pintu_agarwal@yahoo.com,
        vishnu.ps@samsung.com, rohit.kr@samsung.com, iqbal.ams@samsung.com
Subject: [PATCH] [mm]: vmscan: replace printk with pr_err
Date: Sun, 12 Oct 2014 17:10:51 +0530
Message-id: <1413114051-10555-1-git-send-email-pintu.k@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkSndhllWIwcF2DYs569ewWbw8pGmx
	epOvxexfk5gsLu+aw2Zxb81/VovJ754xWrxq/s5q0ff9MLvFt7e32S2eN7eyWGy9sY3V4vLW
	mcwWU/ruMjrweRx+857ZY8GmUo9Nnyaxe5yY8ZvF4+S8n2wefVtWMXqcWXCE3WPz6WqPz5vk
	PGbNOswUwBXFZZOSmpNZllqkb5fAlTGtL7RgCVvFidb7LA2M3axdjJwcEgImEreOTGOEsMUk
	Ltxbz9bFyMUhJLCUUaL142ommKKuxtfsEInpjBLHv75ihHB6mCTeHl4IVsUmoC7x481vsISI
	wFZGiYYzl9lBEswCHYwSMydxdTFycAgLWEp8na8NEmYRUJVYffklC0iYV8BZ4uJmaxBTQkBB
	Ys4kG4i9l9glnuxygqgWkPg2+RALRImsxKYDzBAlkhIHV9xgmcAouICRYRWjaGpBckFxUnqR
	iV5xYm5xaV66XnJ+7iZGYISc/vdswg7GewesDzEKcDAq8fC+kLcKEWJNLCuuzD3EaAq0YSKz
	lGhyPjAO80riDY3NjCxMTUyNjcwtzZTEeV9L/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wDhB3OHyi+pdJsczZT4fFaq2n71x9fkFOmtse+6ZJy1dGMg0YXaI1O4WG60famk7J3SyeD4y
	U3t7ZvOc/7KctdJCqvdmBSZsNzAoY/EpKNf5mn1wdzLjlMjy9mDm6Xnrd1znOPR35+r5M27x
	7ZX6PdOjcb7a91B9cf3oeI/rZRwspvdubVxn06bEUpyRaKjFXFScCAAciLcKiwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t9jQd2FWVYhBr/PylnMWb+GzeLlIU2L
	1Zt8LWb/msRkcXnXHDaLe2v+s1pMfveM0eJV83dWi77vh9ktvr29zW7xvLmVxWLrjW2sFpe3
	zmS2mNJ3l9GBz+Pwm/fMHgs2lXps+jSJ3ePEjN8sHifn/WTz6NuyitHjzIIj7B6bT1d7fN4k
	5zFr1mGmAK6oBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58A
	XbfMHKD7lRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ0/pCC5awVZxo
	vc/SwNjN2sXIySEhYCLR1fiaHcIWk7hwbz1bFyMXh5DAdEaJ419fMUI4PUwSbw8vZAKpYhNQ
	l/jx5jdYQkRgK6NEw5nLYO3MAh2MEjMncXUxcnAIC1hKfJ2vDRJmEVCVWH35JQtImFfAWeLi
	ZmsQU0JAQWLOJJsJjNwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH4DPpHYyrGiwO
	MQpwMCrx8L6QtwoRYk0sK67MPcQowcGsJMJ7KhIoxJuSWFmVWpQfX1Sak1p8iNEUaPdEZinR
	5HxgcsgriTc0NjE3NTa1NLEwMbNUEuc92GodKCSQnliSmp2aWpBaBNPHxMEp1cBYtLdr963P
	szS0Nyrdfno4dunL5Ykr4re/fmuaEutw6n006+1nVR/yXXbx/TvJcdEv4doRVl61PVeSNVXZ
	ZFxXTGuyZ0g3Z9FcXz8jvrjrZs/Oo3e00ip4gg2urf/9kVl3sTvrzel7Dh0/LjGn6bzPU+cv
	f/4ZLbqbXdS5Sva6YorSzYpH7dOClFiKMxINtZiLihMBNubw+NYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces printk(KERN_ERR..) with pr_err found
under shrink_slab.
Thus it also reduces one line extra because of formatting.

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
---
 mm/vmscan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index dcb4707..59605b7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -260,8 +260,7 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
 	do_div(delta, lru_pages + 1);
 	total_scan += delta;
 	if (total_scan < 0) {
-		printk(KERN_ERR
-		"shrink_slab: %pF negative objects to delete nr=%ld\n",
+		pr_err("shrink_slab: %pF negative objects to delete nr=%ld\n",
 		       shrinker->scan_objects, total_scan);
 		total_scan = freeable;
 	}
-- 
1.7.9.5

