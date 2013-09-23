Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3IWJqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:46:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29298 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3IWJqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:46:35 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-c9-52400dfac382
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 08/15] rtc: rtc-ep93xx: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:46:34 +0900
Message-id: <002401ceb841$ca341900$5e9c4b00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAARhyw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zI91fvA5BBmuPaVgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8W3NNqaCezwVDy+0szcwXuHqYuTkkBAwkXjQf4UZwhaTuHBvPVsXIxeHkMAyRon1
	y/8zwhSda/jOApFYxCjxqWcZO4Tzi1Fi3rypYO1sAmoSX74cBkpwcIgI6Eu0tWiA1DAL9DJK
	nOndzQ5SIyRgKzFx2lcmEJtTwE5izedlYLYwkH3i7gcwm0VAVWLG9g1gM3mB6n/92sgGYQtK
	/Jh8jwXEZhbQkti8rYkVwpaX2LzmLTPIXgkBdYlHf3VBwiICRhJLrl9jhCgRkdj34h0jyD0S
	AvfYJXr/LmaF2CUg8W3yIRaIXlmJTQegISEpcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWj
	aGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSKxO2MF474D1IcZkoPUTmaVEk/OBsZ5XEm9obGZk
	YWpiamxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsb21afk/YzW8HbE
	iLx1urb92Yv3ljvmpWU/v7h5U8bU7BLxGMNFV19+eL/h6M8Y5TROJn2J9ydzbokrGQW375xi
	nJj4/+Jby14ug50Ov8+nhOy8zeLnHs+WXivjFvtmx4vPBsEMj27/cPa7sW1G0KuNE+Ksk9as
	E57bKL0lud/r3QSlH/02VilKLMUZiYZazEXFiQA3Dqcf6wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd1fvA5BBsuuqFgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPFtzTamgns8FQ8vtLM3MF7h6mLk5JAQMJE4
	1/CdBcIWk7hwbz1bFyMXh5DAIkaJTz3L2CGcX4wS8+ZNZQapYhNQk/jy5TBQgoNDREBfoq1F
	A6SGWaCXUeJM7252kBohAVuJidO+MoHYnAJ2Ems+LwOzhYHsE3c/gNksAqoSM7ZvAJvJC1T/
	69dGNghbUOLH5HtgFzELaEls3tbECmHLS2xe85YZZK+EgLrEo7+6IGERASOJJdevMUKUiEjs
	e/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOBM+k
	djCubLA4xCjAwajEwxuRaB8kxJpYVlyZe4hRgoNZSYTXj9UhSIg3JbGyKrUoP76oNCe1+BBj
	MtCjE5mlRJPzgUkqryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4
	pRoYd705HXC2NMnyDK/m/E0pxrN9S0VOffyYp/5uisn8uTyGzh/2S8775Lq591FPYN0VHTld
	/ag/+se+znwk/0FNuvr4yvSnp3vnvl6X4xrLta7nebWT9OeZyW/EdeWYNgs/XsIstSr4i5Fm
	o0JX+W6l7cYM3h8fuBdcPtLf2hL5Q32GOFfLW4vZSizFGYmGWsxFxYkAfaQN/UgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ep93xx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 580e7b5..5e4f5dc 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -42,7 +42,7 @@ struct ep93xx_rtc {
 static int ep93xx_rtc_get_swcomp(struct device *dev, unsigned short *preload,
 				unsigned short *delete)
 {
-	struct ep93xx_rtc *ep93xx_rtc = dev->platform_data;
+	struct ep93xx_rtc *ep93xx_rtc = dev_get_platdata(dev);
 	unsigned long comp;
 
 	comp = __raw_readl(ep93xx_rtc->mmio_base + EP93XX_RTC_SWCOMP);
@@ -60,7 +60,7 @@ static int ep93xx_rtc_get_swcomp(struct device *dev, unsigned short *preload,
 
 static int ep93xx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	struct ep93xx_rtc *ep93xx_rtc = dev->platform_data;
+	struct ep93xx_rtc *ep93xx_rtc = dev_get_platdata(dev);
 	unsigned long time;
 
 	 time = __raw_readl(ep93xx_rtc->mmio_base + EP93XX_RTC_DATA);
@@ -71,7 +71,7 @@ static int ep93xx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 static int ep93xx_rtc_set_mmss(struct device *dev, unsigned long secs)
 {
-	struct ep93xx_rtc *ep93xx_rtc = dev->platform_data;
+	struct ep93xx_rtc *ep93xx_rtc = dev_get_platdata(dev);
 
 	__raw_writel(secs + 1, ep93xx_rtc->mmio_base + EP93XX_RTC_LOAD);
 	return 0;
-- 
1.7.10.4


