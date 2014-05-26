Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaEZKG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:06:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48266 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaEZKG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:06:56 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-d4-5383123f8710
From: Heesub Shin <heesub.shin@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>
Subject: [PATCH 2/9] staging: ion: simplify ion_page_pool_total()
Date: Mon, 26 May 2014 19:04:54 +0900
Message-id: <1401098701-24049-2-git-send-email-heesub.shin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t8zbV17oeZgg86VIhbv/95ns9i+8Rur
	xctDmhYHP9xnsdhz5he7RfPi9WwWB2cvYbI481vX4vKuOWwWa+dvY7O4MbnQ4nTHIlYHHo9t
	u7exelzu62XyuLfvMIvHzll32T3uXNvD5rF/7hp2j74tqxg9Pm+SC+CI4rJJSc3JLEst0rdL
	4MrY09fKUtDLWfH1/SPmBsaL7F2MHBwSAiYSkyaFdzFyApliEhfurWcDsYUEljFKfO/zhoib
	SJycexuonAsoPp1R4uXdrywQTjuTxKrbDWwgg9gEtCUObQsGaRARMJboPzsLrIFZYA6zxJSt
	F5hAEsICjhIvtrwDs1kEVCWObvkMto1XwF3i2tINzBDb5CROHpvMCmJzCnhITHwyhwXiIneJ
	2xsfsoEMlRC4xi5xafVTqEECEt8mH2KB+EZWYtMBqDmSEgdX3GCZwCi8gJFhFaNoakFyQXFS
	epGhXnFibnFpXrpecn7uJkZIvPTuYLx9wPoQYzLQuInMUqLJ+cB4yyuJNzQ2M7IwNTE1NjK3
	NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxvL5L9+8U+I47Jf16Frjr1ss
	N1h+PbnuKFfJapp1ckPnBU/Di9Mtr2+28+li7WncpPg2Mi1i6spM0VMbz14QW3b500oJQ1eJ
	uAkGjBue/y6MuasnYcbquOGn6epltSot99fufj6jTq4k70z+xXmSbxrbN528ob88uX7+VY7H
	vo/FwqwfNKRbf1diKc5INNRiLipOBAAZ9v5trQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQV17oeZgg9frBSze/73PZrF94zdW
	i5eHNC0OfrjPYrHnzC92i+bF69ksDs5ewmRx5reuxeVdc9gs1s7fxmZxY3KhxemORawOPB7b
	dm9j9bjc18vkcW/fYRaPnbPusnvcubaHzWP/3DXsHn1bVjF6fN4kF8AR1cBok5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rJJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsI4xY09fK0tBL2fF1/ePmBsYL7J3MXJySAiYSJycexvK
	FpO4cG89WxcjF4eQwHRGiZd3v7JAOO1MEqtuNwBlODjYBLQlDm0LBmkQETCW6D87ix2khllg
	DrPElK0XmEASwgKOEi+2vAOzWQRUJY5u+cwGYvMKuEtcW7qBGWKbnMTJY5NZQWxOAQ+JiU/m
	sIDYQkA1tzc+ZJvAyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBEPpPawbiyweIQ
	owAHoxIP7wHvpmAh1sSy4srcQ4wSHMxKIrxanM3BQrwpiZVVqUX58UWlOanFhxiTga6ayCwl
	mpwPTBZ5JfGGxiZmRpZGZsYm5sbGpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cC4dvvR
	f78Z7ew29WaxbCpz13xvZLf1+IzCy0w3uGq9+y86VV1eG6YvzbFV3HrpXL4PV9UaMsrOXQ0P
	zPptHTJp7s8Eq2daSb6Tz1SJlb4y0rplLXtbaPqb2ITT/86nqwnNk7jfw+bItu1acH1l7pfQ
	NQxshn/v5+/q6HR69/HwDb9ffpP8p0YosRRnJBpqMRcVJwIAtajKegwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ion_page_pool_total() returns the total number of pages in the pool.
Depending on the argument passed, it counts pages from highmem zone in
or not. This commit simplifies the code lines for better readability.

Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
---
 drivers/staging/android/ion/ion_page_pool.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index ead4054..1684780 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -119,12 +119,12 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page *page)
 
 static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
 {
-	int total = 0;
+	int count = pool->low_count;
 
-	total += high ? (pool->high_count + pool->low_count) *
-		(1 << pool->order) :
-			pool->low_count * (1 << pool->order);
-	return total;
+	if (high)
+		count += pool->high_count;
+
+	return count << pool->order;
 }
 
 int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
-- 
1.9.1

