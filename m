Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab3GVLeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:34:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30756 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab3GVLd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:33:58 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-24-51ed18a5e201
From: Pintu Kumar <pintu.k@samsung.com>
To: akpm@linux-foundation.org, mgorman@suse.de, jiang.liu@huawei.com,
        minchan@kernel.org, cody@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: cpgs@samsung.com, pintu.k@samsung.com, pintu_agarwal@yahoo.com
Subject: [PATCH 2/2] mm: page_alloc: avoid slowpath for more than MAX_ORDER
 allocation.
Date: Mon, 22 Jul 2013 17:02:42 +0530
Message-id: <1374492762-17735-1-git-send-email-pintu.k@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkWnepxNtAgzlXxC3mrF/DZrH5eg+7
	xctDmhb3v89ls7i8aw6bxb01/1ktJr97xmix7Ot7dou+74fZLb69vc3uwOXRcuQtq8emVZ1s
	Hps+TWL3ODHjN4vHg0ObWTz6tqxi9Nh8utrj8yY5j1mzDjMFcEZx2aSk5mSWpRbp2yVwZfxf
	eYap4B9bxZTHB9gaGO+wdjFyckgImEhMe74CyhaTuHBvPRuILSSwlFHi+G1tmJoVLW3sXYxc
	QPFFjBIfd81igijqYZK4vtESxGYTUJf48eY3I0iRiMByRomF+58xdzFycDALOEmc3ZwCUiMs
	EClxZu8FsAUsAqoS/adesIPYvALOElv3nGEFKZcQUJCYM8kGZIyEwC52iS1bOhkh6gUkvk0+
	xAJRIyux6QAzxG2SEgdX3GCZwCi4gJFhFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZg0J/+
	92zCDsZ7B6wPMSYDjZvILCWanA+MmrySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MEpW6LfM/a0a1KPMk31dU+XSrqcac5c1+GctSf/JIdyUHdvr
	t/zUlT+3/kps7+xwPy3cyGLCIX9o/0zhrqNSiis5jx+VEmDS7bsnnpXME6Cs1bco5EaaZEps
	o9ZSoT+5d1X8i1ddlZy1UE1lu3SGtPK0zSkzXc65udy+bazxK3N9Rrrzt967SizFGYmGWsxF
	xYkAczQ4qJACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAd2lEm8DDaae5bWYs34Nm8Xm6z3s
	Fi8PaVrc/z6XzeLyrjlsFvfW/Ge1mPzuGaPFsq/v2S36vh9mt/j29ja7A5dHy5G3rB6bVnWy
	eWz6NInd48SM3yweDw5tZvHo27KK0WPz6WqPz5vkPGbNOswUwBnVwGiTkZqYklqkkJqXnJ+S
	mZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SokkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwhjHj/8ozTAX/2CqmPD7A1sB4h7WLkZNDQsBEYkVLGzuELSZx
	4d56ti5GLg4hgUWMEh93zWICSQgJ9DBJXN9oCWKzCahL/HjzmxGkSERgOaPEwv3PmLsYOTiY
	BZwkzm5OAakRFoiUOLP3AhuIzSKgKtF/6gXYAl4BZ4mte86wgpRLCChIzJlkM4GRewEjwypG
	0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Kh6Jr2DcVWDxSFGAQ5GJR7ehoA3gUKsiWXFlbmH
	GCU4mJVEeD1XAYV4UxIrq1KL8uOLSnNSiw8xJgMtn8gsJZqcD4z4vJJ4Q2MTc1NjU0sTCxMz
	S9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg5EpX2SQsmG/Zq18SZatua2yzkrvvjaP4
	4w+7rjjZbGT7Vuhelv5zt0OfjvyhtMwAbTXulMLn5TLVy4Ozk9N106wDJmTbn/q80838tey3
	sxdNegsn9sj5P902v0tqurfE7x3dJ/0/a+ov0gkPXL87WMqFV2uy5LPsTROtfh5jDmjzWuHS
	KKrEUpyRaKjFXFScCAAKh3/y7gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was observed that if order is passed as more than MAX_ORDER
allocation in __alloc_pages_nodemask, it will unnecessarily go to
slowpath and then return failure.
Since we know that more than MAX_ORDER will anyways fail, we can
avoid slowpath by returning failure in nodemask itself.

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
---
 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 202ab58..6d38e75 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1564,6 +1564,10 @@ __setup("fail_page_alloc=", setup_fail_page_alloc);
 
 static bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
+	if (order >= MAX_ORDER) {
+		WARN_ON(!(gfp_mask & __GFP_NOWARN));
+		return false;
+	}
 	if (order < fail_page_alloc.min_order)
 		return false;
 	if (gfp_mask & __GFP_NOFAIL)
-- 
1.7.9.5

