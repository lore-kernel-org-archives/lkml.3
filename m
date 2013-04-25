Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab3DYLCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:02:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53932 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3DYLCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:02:42 -0400
X-AuditID: cbfee68f-b7f066d000003683-a2-51790d511f1c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/3] f2fs: check nid == 0 in add_free_nid
Date: Thu, 25 Apr 2013 20:01:35 +0900
Message-id: <1366887697-24627-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zY91A3spAg4f/2S2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyjh3qZu9YBV7Reu/
	HvYGxgesXYycHBICJhJL17xkh7DFJC7cW8/WxcjFISSwjFFi0/NHTDBFB7Y2QCUWMUos6prJ
	CuG0MUl8XrsDyOHgYBPQlti83wCkQUSAWWLB1POMIDXMAhMYJf4ves8CkhAWsJSYf7oVbDWL
	gKrEkfYeZhCbV8Bd4vuhhYwQ23QlVv9/zg7SLCFwn03ibMtGRogGAYlvkw+xgCyTEJCV2HSA
	GaJeUuLgihssExgFFzAyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQICcL+HYx3D1gfYkwG
	GjeRWUo0OR8YxHkl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYf
	YmTi4JRqYGxL+meY+GuXm7ez5ba687xr59XfzHp+kMVMPGq3yMXQvV+dczvdj3cprYt517sq
	+qzul+234zZ4vq/1b+GOFr3YtbUuu53TY/+3PTU+pyrDlO1fpyy/9EJr13NNzzmZy67eYLy4
	h5PVsV712tKGC5NSZZt15kv8urV/2tdEHbZ16oGtFtM3zFFiKc5INNRiLipOBABliVGTWAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAd1A3spAg2W9LBbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWacu9TNXrCKvaL1Xw97A+MD1i5GTg4JAROJA1sb2CBsMYkL99YD2VwcQgKL
	GCUWdc1khXDamCQ+r90B5HBwsAloS2zebwDSICLALLFg6nlGkBpmgQmMEv8XvWcBSQgLWErM
	P90KtoFFQFXiSHsPM4jNK+Au8f3QQkaIbboSq/8/Z5/AyL2AkWEVo2hqQXJBcVJ6rpFecWJu
	cWleul5yfu4mRnCIP5PewbiqweIQowAHoxIPr8Cr8kAh1sSy4srcQ4wSHMxKIrzMPyoChXhT
	EiurUovy44tKc1KLDzEmA22fyCwlmpwPjL+8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmk
	J5akZqemFqQWwWxh4uCUamA0mXW26cLzXUbeO4sutf377znFxlD+QMEeX65V1ealpW13NOdp
	yht8ePlk7+TD1i0PQ2xmS72srpI9omUpNWm2Qvn05HKuhgb/2QE7jbsf7msPFn908tCZ5t3F
	Zzu3b5v3r5jlsXTEi0S114/KGy9rVrpJWrqsuWzCsEZ4Rrne7Yl/70Xt3pShxFKckWioxVxU
	nAgAPhAVYbUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is more obvious that add_free_nid checks whether the free nid is zero or not.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index a0aa044..c8f48d4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1245,6 +1245,10 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid)
 
 	if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
 		return 0;
+
+	/* 0 nid should not be used */
+	if (nid == 0)
+		return 0;
 retry:
 	i = kmem_cache_alloc(free_nid_slab, GFP_NOFS);
 	if (!i) {
@@ -1286,10 +1290,6 @@ static int scan_nat_page(struct f2fs_nm_info *nm_i,
 	int fcnt = 0;
 	int i;
 
-	/* 0 nid should not be used */
-	if (start_nid == 0)
-		++start_nid;
-
 	i = start_nid % NAT_ENTRY_PER_BLOCK;
 
 	for (; i < NAT_ENTRY_PER_BLOCK; i++, start_nid++) {
-- 
1.8.1.3.566.gaa39828

