Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3CNIXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:23:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33820 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab3CNIXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:23:15 -0400
X-AuditID: cbfee68e-b7f946d000001e37-b6-514188f18976
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 26/30] rtc: rtc-sun4v: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:23:12 +0900
Message-id: <009d01ce208d$2b46f070$81d4d150$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAcP/g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zY92PHY6BBv8usFssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVce7IG7aCUxwVy45vZ2lg7GLvYuTkkBAwkdg1YSkLhC0mceHeejYQW0hgGaPEkp32
	MDW/mxcC1XABxaczSpxcdgHK+cUocfTZf1aQKjYBNYkvXw4DTeXgEBHQl2hr0QCpYRboZZQ4
	07sbLC4kYCtx/b8diMkpYCexYb0YSKewgKvE313TwKawCKhKrDh9BuwGXqDq5nsb2SFsQYkf
	k++B3cksoCWxfudxJghbXmLzmrfMICMlBNQlHv3VhTjASOLHKRGIChGJfS/eMYIcIyFwj12i
	oXMKC8QqAYlvkw+xQLTKSmw6wAzxraTEwRU3WCYwSsxCsngWksWzkCyehWTFAkaWVYyiqQXJ
	BcVJ6UVGesWJucWleel6yfm5mxghMdq3g/HmAetDjMlA6ycyS4km5wNjPK8k3tDYzMjC1MTU
	2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjBMnXOBXqVPi27wsxvFs
	3frfpquazn59K+vRnmV9vfT0zLdfP2Z9+z3nxdGJ8xMfBa5927Z1smmQJlvpxRvTF/59sGDq
	c9agHQeiFz7gP33vR+fGyQ47XZ3NuDw4sxu/ZH7idW6XKNVebihnqyPpwBTHV+SzqIBrk5uq
	wJ6Ll/RYTy7+V31hcqESS3FGoqEWc1FxIgAuN3525wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd2PHY6BBtv3MlssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHHuyBu2glMcFcuOb2dpYOxi72Lk5JAQMJH4
	3byQBcIWk7hwbz1bFyMXh5DAdEaJk8susEA4vxgljj77zwpSxSagJvHly2Ggbg4OEQF9ibYW
	DZAaZoFeRokzvbvB4kICthLX/9uBmJwCdhIb1ouBdAoLuEr83TUNbAqLgKrEitNn2EBsXqDq
	5nsb2SFsQYkfk++B3cMsoCWxfudxJghbXmLzmrfMICMlBNQlHv3VhTjASOLHKRGIChGJfS/e
	MU5gFJqFZNAsJINmIRk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBKeCZ1A7G
	lQ0WhxgFOBiVeHgP9DsECrEmlhVX5h5ilOBgVhLh9fRyDBTiTUmsrEotyo8vKs1JLT7EmAz0
	50RmKdHkfGB6yiuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkG
	xvlZi8/4/Kpaxfb4+pGN1+sff1/YedMrx/fZ5Q6hStGpEkF8aiZMrWxZP/df2vdoY3L9KruG
	8r0795Y/CL61oXj5XnE5hROqu365TXvDvlVaRvFO4vIbkX/jl7rye2rE3n7aOmf5y647CQ81
	OY6fTGhda3kjP3q6vmy2yo2loQpzliRzMAXczldiKc5INNRiLipOBABTPr0sRQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-sun4v.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-sun4v.c b/drivers/rtc/rtc-sun4v.c
index 7c51c49..ce42e5f 100644
--- a/drivers/rtc/rtc-sun4v.c
+++ b/drivers/rtc/rtc-sun4v.c
@@ -81,8 +81,10 @@ static const struct rtc_class_ops sun4v_rtc_ops = {
 
 static int __init sun4v_rtc_probe(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = rtc_device_register("sun4v", &pdev->dev,
-				     &sun4v_rtc_ops, THIS_MODULE);
+	struct rtc_device *rtc;
+
+	rtc = devm_rtc_device_register(&pdev->dev, "sun4v",
+				&sun4v_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -92,9 +94,6 @@ static int __init sun4v_rtc_probe(struct platform_device *pdev)
 
 static int __exit sun4v_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc);
 	return 0;
 }
 
-- 
1.7.2.5


