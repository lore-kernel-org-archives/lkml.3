Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3BUIed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:34:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45184 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab3BUIeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:34:31 -0500
X-AuditID: cbfee690-b7f066d00000169f-db-5125dc160943
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
In-reply-to: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
Subject: [PATCH 04/12] rtc: rtc-coh901331: use devm_clk_get()
Date: Thu, 21 Feb 2013 17:34:29 +0900
Message-id: <00cf01ce100e$44100450$cc300cf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDe9M0/OnFjrjTvSUwIYm7R1WAgAAEA5g
Content-language: ko
x-cr-hashedpuzzle: bYc= B+36 Fc8T G8n1 KRYS cgnU jQGb nXh+ tfIV vwSg xGJe yo+/
 zN0H 3viq 5q7m
 7C08;5;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgB0AGMALQBsAGkAbgB1AHgAQABnAG8AbwBnAGwAZQBnAHIAbwB1AHAAcwAuAGMAbwBtAA==;Sosha1_v1;7;{D0EF2DB6-72AC-4F53-88E7-DFAE821379EF};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 21 Feb 2013 08:34:20
 GMT;WwBQAEEAVABDAEgAIAAwADQALwAxADIAXQAgAHIAdABjADoAIAByAHQAYwAtAGMAbwBoADkAMAAxADMAMwAxADoAIAB1AHMAZQAgAGQAZQB2AG0AXwBjAGwAawBfAGcAZQB0ACgAKQA=
x-cr-puzzleid: {D0EF2DB6-72AC-4F53-88E7-DFAE821379EF}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zA12xO6qBBi+Xi1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MrfteshXc4K4417GRqYHxFGcXIyeHhICJxM62a+wQtpjEhXvr
	2boYuTiEBJYxStw/9IoRpmj1rMeMEIlFjBLHjz1lgnBmM0k83X2KFaSKTUBN4suXw0CjODhE
	BPQl2lo0QGqYBXoZJc707gZbISRgKzHnwzVmEJtTwE7i8rYvrCD1wkDx6/PNQEwWAVWJf726
	IBW8QNHG60fYIGxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsM0iohoC7x6C9Yq4iAkcT3JfvZ
	IUpEJPa9eAd2voTACVaJKR0bWCDqTSVer1CCiB9il/izewHYJywCAhLfJh+CqpGV2HSAGRIM
	khIHV9xgmcAoNQvJRbOQXDQLyUWzkKxewMiyilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMk
	DifsYLx3wPoQYzLQ+onMUqLJ+cA4ziuJNzQ2NjEzMTUxtzQ1NyVNWEmcV/6STKCQQHpiSWp2
	ampBalF8UWlOavEhRiYOTqkGRpaiU8Z7EraLWt5/976jNdD0p0na+ky5yN9Zj/Z7zJ96SbqV
	oeBd68uF9qfOtmrFf2Tfz3PixTaRpKyVXVe2b3Vbu0F78rxYdu7TJgJ3LiS4n2zqlLJcplTD
	1H087USY7QVd9VO7pqaJMR3kWPzOf576vlvrbBVKzq+uOlCx96XdhSlXem/euaTEUpyRaKjF
	XFScCABmIoPB2QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAV2xO6qBBrdW81hc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjK37XrIV3OCuONexkamB
	8RRnFyMnh4SAicTqWY8ZIWwxiQv31rN1MXJxCAksYpQ4fuwpE4Qzm0ni6e5TrCBVbAJqEl++
	HGbvYuTgEBHQl2hr0QCpYRboZZQ407ubHaRGSMBWYs6Ha8wgNqeAncTlbV9YQeqFgeLX55uB
	mCwCqhL/enVBKniBoo3Xj7BB2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhmkVUJAXeLRX7BW
	EQEjie9L9rNDlIhI7HvxjhHkGgmBE6wSUzo2sEDUm0q8XqE0gVFkFpINs5BsmIVkwywkoxYw
	sqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7yZ1I7GFc2WBxiFOBgVOLhXfBSJVCINbGs
	uDL3EKMEB7OSCK/pEdVAId6UxMqq1KL8+KLSnNTiQ4zJQP9PZJYSTc4HJqC8knhDYxMzI0sj
	MwsjE3Nz0oSVxHkZTz0JEBJITyxJzU5NLUgtgtnCxMEp1cBYdj1fPWF+4zkDO4UQN8XIHWa+
	3zjzdfaITbN6vvC07LqW/XY+ezwcP7Xc+O+4tYZDytjiyLN/Jy4LrpwY4sjlbH+w2DDVhdMg
	carGybWeXv5+G3pVLmhumKe+hm3u4uCpd6fUTFTxX85s1vp6mr9cyp+9Tm/eqXTb99++9DP9
	2aryjuSZWW5KLMUZiYZazEXFiQAtVexmNgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-coh901331.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index c8115b8..2d28ec1a 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -157,7 +157,6 @@ static int __exit coh901331_remove(struct platform_device *pdev)
 	if (rtap) {
 		rtc_device_unregister(rtap->rtc);
 		clk_unprepare(rtap->clk);
-		clk_put(rtap->clk);
 		platform_set_drvdata(pdev, NULL);
 	}
 
@@ -196,7 +195,7 @@ static int __init coh901331_probe(struct platform_device *pdev)
 			     "RTC COH 901 331 Alarm", rtap))
 		return -EIO;
 
-	rtap->clk = clk_get(&pdev->dev, NULL);
+	rtap->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(rtap->clk)) {
 		ret = PTR_ERR(rtap->clk);
 		dev_err(&pdev->dev, "could not get clock\n");
@@ -207,7 +206,7 @@ static int __init coh901331_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(rtap->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "could not enable clock\n");
-		goto out_no_clk_prepenable;
+		return ret;
 	}
 	clk_disable(rtap->clk);
 
@@ -224,8 +223,6 @@ static int __init coh901331_probe(struct platform_device *pdev)
  out_no_rtc:
 	platform_set_drvdata(pdev, NULL);
 	clk_unprepare(rtap->clk);
- out_no_clk_prepenable:
-	clk_put(rtap->clk);
 	return ret;
 }
 
-- 
1.7.2.5


