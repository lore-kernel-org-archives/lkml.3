Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaBGH5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 02:57:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61096 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaBGH5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 02:57:44 -0500
X-AuditID: cbfee690-b7f266d00000287c-57-52f491f75571
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Kevin Hilman'" <khilman@linaro.org>
References: <000401cf23d9$d1df6e30$759e4a90$%han@samsung.com>
In-reply-to: <000401cf23d9$d1df6e30$759e4a90$%han@samsung.com>
Subject: [PATCH 2/4] rtc: rtc-davinci: Use devm_ioremap_resource()
Date: Fri, 07 Feb 2014 16:57:42 +0900
Message-id: <000601cf23da$477dc060$d6794120$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2dGo+e7pmAi4QKyN7t2QoeNN8wAAB/Bg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zQ93vE78EGTx/zWax5OJVdos569ew
	WVxeeInV4uvhFYwWl3fNYbPY39nB6MDmsWfiSTaPO9f2sHmcmPGbxaNvyypGj+nzfjJ5fN4k
	F8AWxWWTkpqTWZZapG+XwJXx9cExloI7/BUX5/QwNTD+4Oli5OSQEDCRWHh7MhOELSZx4d56
	ti5GLg4hgWWMEq+OP2CGKTpz6QQjiC0kMJ1RonlBFkTRL0aJOX2TWEASbAJqEl++HGbvYuTg
	EBHQl2hr0QCpYRbYwihx6eMydohmW4mFLzvBhnIK2En07+ljBakXFnCS6OllBQmzCKhKbLx7
	FmwXL1D5m6u3oWxBiR+T74GtYhbQkli/8zgThC0vsXnNW2aQMRIC6hKP/uqChEUEjCQmH/nE
	ClEiIrHvxTtGkHMkBD6yS6zZfxJql4DEt8mHWCB6ZSU2HYB6V1Li4IobLBMYJWYh2TwLyeZZ
	SDbPQrJiASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQ2J2wg/HeAetDjMlA6ycyS4km
	5wNjP68k3tDYzMjC1MTU2Mjc0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUa
	GJX/xrU+/+ckfmpyWG/aBf1Oi7TznW0J1X5mtt9OBzhMk5vE53C+wbX8S8SKOVv1nmvnBvlJ
	5VyamSsWI/s5IE9ldejpBdNfa9258EgxasMKj76JQSFPXsdxfDc+V+8vZ/RXdM2VaXdTQuzS
	9nb/VxbZ9vqi+rOEg+Y8ZSeyH/8WNJn49843FSWW4oxEQy3mouJEAEJqYG/zAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQd3vE78EGex4zGSx5OJVdos569ew
	WVxeeInV4uvhFYwWl3fNYbPY39nB6MDmsWfiSTaPO9f2sHmcmPGbxaNvyypGj+nzfjJ5fN4k
	F8AW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0
	h5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4+uDYywFd/grLs7pYWpg
	/MHTxcjJISFgInHm0glGCFtM4sK99WwgtpDAdEaJ5gVZXYxcQPYvRok5fZNYQBJsAmoSX74c
	Zu9i5OAQEdCXaGvRAKlhFtjCKHHp4zJ2iGZbiYUvO5lBbE4BO4n+PX2sIPXCAk4SPb2sIGEW
	AVWJjXfPgu3lBSp/c/U2lC0o8WPyPbBVzAJaEut3HmeCsOUlNq95ywwyRkJAXeLRX12QsIiA
	kcTkI59YIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al
	6yXn525iBCeGZ1I7GFc2WBxiFOBgVOLhPbH0c5AQa2JZcWXuIUYJDmYlEd6fDV+ChHhTEiur
	Uovy44tKc1KLDzEmAz06kVlKNDkfmLTySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliS
	mp2aWpBaBLOFiYNTqoFR3TR31v9pS80WixVa6SuuzTwlGTjpUvaRymkZv0qffmJY739MN9fx
	9mR/5j3iz/M6clIi/r15UJsteP2up0fPgeXqN9Y/W1e8QNKl6X3E/P2sJVnxG7m9TOyYdY10
	9KxmvxJZFup925nNUbPdWkTIQ0X5mkw++6LAxr3C1S2ds+c5cnsJlyixFGckGmoxFxUnAgDX
	kmOAUAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() in order to make the code simpler,
and remove redundant return value check of platform_get_resource()
because the value is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-davinci.c |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 24677ef8..d3e70f3 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -119,8 +119,6 @@ static DEFINE_SPINLOCK(davinci_rtc_lock);
 struct davinci_rtc {
 	struct rtc_device		*rtc;
 	void __iomem			*base;
-	resource_size_t			pbase;
-	size_t				base_size;
 	int				irq;
 };
 
@@ -482,7 +480,7 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct davinci_rtc *davinci_rtc;
-	struct resource *res, *mem;
+	struct resource *res;
 	int ret = 0;
 
 	davinci_rtc = devm_kzalloc(&pdev->dev, sizeof(struct davinci_rtc), GFP_KERNEL);
@@ -498,28 +496,9 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "no mem resource\n");
-		return -EINVAL;
-	}
-
-	davinci_rtc->pbase = res->start;
-	davinci_rtc->base_size = resource_size(res);
-
-	mem = devm_request_mem_region(dev, davinci_rtc->pbase,
-				davinci_rtc->base_size, pdev->name);
-	if (!mem) {
-		dev_err(dev, "RTC registers at %08x are not free\n",
-			davinci_rtc->pbase);
-		return -EBUSY;
-	}
-
-	davinci_rtc->base = devm_ioremap(dev, davinci_rtc->pbase,
-					davinci_rtc->base_size);
-	if (!davinci_rtc->base) {
-		dev_err(dev, "unable to ioremap MEM resource\n");
-		return -ENOMEM;
-	}
+	davinci_rtc->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(davinci_rtc->base))
+		return PTR_ERR(davinci_rtc->base);
 
 	platform_set_drvdata(pdev, davinci_rtc);
 
-- 
1.7.10.4


