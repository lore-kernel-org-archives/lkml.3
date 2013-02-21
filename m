Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab3BUIcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:32:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44638 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3BUIcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:32:17 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-b4-5125db90dd99
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/12] rtc: rtc-imxdi: use devm_clk_get()
Date: Thu, 21 Feb 2013 17:32:15 +0900
Message-id: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDe9M0/OnFjrjTvSUwIYm7R1WAg==
Content-language: ko
x-cr-hashedpuzzle: Dz9/ Eu7h MPyr NCia UUW+ VF+w VyQg ckJo gPM3 hBkO qBSU vm6K
 wOX2 yGcx ytBb
 0U19;5;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgB0AGMALQBsAGkAbgB1AHgAQABnAG8AbwBnAGwAZQBnAHIAbwB1AHAAcwAuAGMAbwBtAA==;Sosha1_v1;7;{006CFCDE-A64A-4A50-9E6C-0006012496DB};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 21 Feb 2013 08:32:07
 GMT;WwBQAEEAVABDAEgAIAAwADEALwAxADIAXQAgAHIAdABjADoAIAByAHQAYwAtAGkAbQB4AGQAaQA6ACAAdQBzAGUAIABkAGUAdgBtAF8AYwBsAGsAXwBnAGUAdAAoACkA
x-cr-puzzleid: {006CFCDE-A64A-4A50-9E6C-0006012496DB}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zY90Jt1UDDVb85be4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZV45cYytYxFGx/ep2xgbGD2xdjJwcEgImEteWnGGEsMUkLtxb
	DxTn4hASWMYo0fVuISNM0bafl5kgEtMZJW7uvc8I4cxmkuhouMcOUsUmoCbx5cthIJuDQ0RA
	X6KtRQOkhlmgl1HiTO9usBphAUuJfdteg9WwCKhKNEwMBgnzCthKnDm7hBnCFpT4MfkeC4jN
	LKAlsX7ncSYIW15i85q3zCCtEgLqEo/+6oKERQT0JB6tXcgMUSIise/FO7DTJAT2sEo8Pr6N
	CeIBU4nXzV3MEIll7BLLp50Hu4dFQEDi2+RDLBBDZSU2HWCGqJeUOLjiBssERolZSE6aheSk
	WUhOmoVk9wJGllWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYIbHVu4Px9gHrQ4zJQOsnMkuJ
	JucDYzOvJN7Q2NjEzMTUxNzS1NyUNGElcV65SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODil
	Ghi11Vq7nF97dfnffsj2NGXRNtPP/57lS8+Njv8259rC/MCI9bM6JG3NCxMjV3Ku9VTp2Jrx
	VX+mucbzbA0m0wPnmXjOM86L6vt4rsZwn8uPj1q7l6xuztOpe9Xj+WAtX7jEbAPW5POf9ytt
	8NO4m2hwYEmM35H+QzbxFj75eyUP2deZcF9OYFFiKc5INNRiLipOBAAd1yFrwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoO6E26qBBud38lhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjCtHrrEVLOKo2H51O2MD
	4we2LkZODgkBE4ltPy8zQdhiEhfurQeKc3EICUxnlLi59z4jhDObSaKj4R47SBWbgJrEly+H
	gWwODhEBfYm2Fg2QGmaBXkaJM727wWqEBSwl9m17DVbDIqAq0TAxGCTMK2ArcebsEmYIW1Di
	x+R7LCA2s4CWxPqdx5kgbHmJzWveMoO0SgioSzz6qwsSFhHQk3i0diEzRImIxL4X78BOkxDY
	wyrx+Pg2qAdMJV43dzFPYBSahWTFLCQrZiFZMQvJrAWMLKsYRVMLkguKk9JzDfWKE3OLS/PS
	9ZLzczcxgiP3mdQOxpUNFocYBTgYlXh4F7xUCRRiTSwrrsw9xCjBwawkwmt6RDVQiDclsbIq
	tSg/vqg0J7X4EGMyMAAmMkuJJucDk0peSbyhsYmZkaWRmYWRibk5acJK4ryMp54ECAmkJ5ak
	ZqemFqQWwWxh4uCUamDs2Fmh2G32a+OLzElbHhffeMzokZ8h+32TkgnrVI955SsFPXMve+SZ
	XdidY2bIWS5brLzo89Zvnr7Rs54f//Pr10/eh+yScc6i743SwzsMs5jkDnBqnY4zT1O9VnVh
	65aiJNUm/ad5M7NV7roKMgQdCDrddbDxyI1iz/JD3894flXYnDt17mclluKMREMt5qLiRADK
	/pGxIAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-imxdi.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index 75d307a..82aad69 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -406,7 +406,7 @@ static int dryice_rtc_probe(struct platform_device *pdev)
 
 	mutex_init(&imxdi->write_mutex);
 
-	imxdi->clk = clk_get(&pdev->dev, NULL);
+	imxdi->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(imxdi->clk))
 		return PTR_ERR(imxdi->clk);
 	clk_prepare_enable(imxdi->clk);
@@ -475,7 +475,6 @@ static int dryice_rtc_probe(struct platform_device *pdev)
 
 err:
 	clk_disable_unprepare(imxdi->clk);
-	clk_put(imxdi->clk);
 
 	return rc;
 }
@@ -492,7 +491,6 @@ static int dryice_rtc_remove(struct platform_device *pdev)
 	rtc_device_unregister(imxdi->rtc);
 
 	clk_disable_unprepare(imxdi->clk);
-	clk_put(imxdi->clk);
 
 	return 0;
 }
-- 
1.7.2.5


