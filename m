Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3D2JQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:16:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61147 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab3D2JQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:16:15 -0400
X-AuditID: cbfee68d-b7f016d000007930-56-517e3a5ef91c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 3/5] watchdog: pnx4008_wdt: use devm_clk_get()
Date: Mon, 29 Apr 2013 18:16:14 +0900
Message-id: <000401ce44ba$326e7a70$974b6f50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EujCKEg908+dGS+WtCKJhRX4r3A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t8zI904q7pAg38XRSzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	VrbNZyy4yllxdNkL5gbGr+xdjJwcEgImEl3/PzJD2GISF+6tZ+ti5OIQEljGKHH36DxGmKI7
	PZOYIBLTGSWenLjADuH8YpT4+nAfC0gVm4CaxJcvh4ESHBwiAvoSbS0aIDXMAh2MEgeeLmUF
	qREWcJX4s+sS2DoWAVWJTc9PgvXyClhKLDn8A8oWlPgx+R6YzSygJbF+53EmCFteYvOat1Cn
	KkjsOPsa7DoRAT2J+S8+QtWLSOx78Y4RZLGEwD52ib6JD1ghlglIfJt8iAXkOAkBWYlNB6Dm
	SEocXHGDZQKj2Cwkq2chWT0LyepZSFYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRES
	cb07GG8fsD7EmAy0fiKzlGhyPjBi80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1O
	TS1ILYovKs1JLT7EyMTBKdXA2JZl5iTd+/ua6oqaOs+AXbt+is1rzzjuoaKvOF+yJIO7OGwG
	79TDX413zt796/lkSZtLk/isHhnOeJri9ODTZKtXGbbfxbqOyh/VOJp42+e/T5abRcqasw++
	rlJynd9xwPaw/xWdavEG4QdP51i8qlzOYehYE3vU3q8y6U59pLT4rc2/7bflKLEUZyQaajEX
	FScCACTRpKHOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jQd04q7pAg+XfBCzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYM1a2zWcsuMpZcXTZC+YGxq/sXYycHBICJhJ3eiYxQdhi
	EhfurWfrYuTiEBKYzijx5MQFdgjnF6PE14f7WECq2ATUJL58OQyU4OAQEdCXaGvRAKlhFuhg
	lDjwdCkrSI2wgKvEn12XmEFsFgFViU3PT4L18gpYSiw5/APKFpT4MfkemM0soCWxfudxJghb
	XmLzmrfMEBcpSOw4+5oRxBYR0JOY/+IjVL2IxL4X7xgnMArMQjJqFpJRs5CMmoWkZQEjyypG
	0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Hh+JrWDcWWDxSFGAQ5GJR7egM21gUKsiWXFlbmH
	GCU4mJVEeBWN6gKFeFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+YavJK4g2NTcyMLI3MLIxM
	zM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgdHz8qqDFfNPLr3somG6P8gk/6W254sv
	ii1HrfP0ZNV3f5A48crqn92j4jmGqpFHnbgO64Rt91C+2sNw+eapF9vC6lya/1dZJu08+0b2
	pbuF/7ty07J/7RaHfkpt1FsvsMd3V+qqj/16T44FNSUtvRqwbuNjv/9Zok0tPQ4To6O3b3/m
	MuvgjSVKLMUZiYZazEXFiQDykVscKwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/pnx4008_wdt.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index a3684a3..b30bd43 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -159,13 +159,13 @@ static int pnx4008_wdt_probe(struct platform_device *pdev)
 	if (IS_ERR(wdt_base))
 		return PTR_ERR(wdt_base);
 
-	wdt_clk = clk_get(&pdev->dev, NULL);
+	wdt_clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(wdt_clk))
 		return PTR_ERR(wdt_clk);
 
 	ret = clk_enable(wdt_clk);
 	if (ret)
-		goto out;
+		return ret;
 
 	pnx4008_wdd.bootstatus = (readl(WDTIM_RES(wdt_base)) & WDOG_RESET) ?
 			WDIOF_CARDRESET : 0;
@@ -186,8 +186,6 @@ static int pnx4008_wdt_probe(struct platform_device *pdev)
 
 disable_clk:
 	clk_disable(wdt_clk);
-out:
-	clk_put(wdt_clk);
 	return ret;
 }
 
@@ -196,7 +194,6 @@ static int pnx4008_wdt_remove(struct platform_device *pdev)
 	watchdog_unregister_device(&pnx4008_wdd);
 
 	clk_disable(wdt_clk);
-	clk_put(wdt_clk);
 
 	return 0;
 }
-- 
1.7.2.5


