Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3CFHsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:48:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20429 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3CFHsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:48:15 -0500
X-AuditID: cbfee68d-b7f636d0000009be-e0-5136f4bd880a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 03/30] rtc: rtc-da9052: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:48:13 +0900
Message-id: <007d01ce1a3e$f4b2b4d0$de181e70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAABoLg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zY929X8wCDe5eM7FYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY9qKt6wFxzkq1q9fxNzA2MXexcjJISFgIrFr7x4mCFtM4sK99WxdjFwcQgLLGCU6
	DjWzwRQtPdfGAmILCUxnlNjSmg9R9ItRYsqNnawgCTYBNYkvXw4DTeXgEBHQl2hr0QCpYRbo
	ZZQ407sbLC4kYCvRM48HpJxTwE5iysTHYEcIC3hKtG95AHYEi4CqxJGpt8FsXqDynVsa2CFs
	QYkfk++B3cAsoCWxfudxJghbXmLzmrfMIOMlBNQlHv3VBQmLCBhJLPjxFapERGLfi3eMIOdI
	CNxilzjw6gwbxC4BiW+TD7FA9MpKbDrADPGupMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZV
	jKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGCFx2ruD8fYB60OMyUDrJzJLiSbnA+M8ryTe0NjY
	xMzE1MTc0tTclDRhJXFeuUsygUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYtafc2vmt/833
	11+NVmd7v723+VLI4QL1GYGG2ln/WLyc7q0o4mnx4eDV+Noq1z5XeZcPT7R8bfzGpe8Ff9/n
	fiS9aJ277bVl+7ZK3LeXPfDtdc4S35/qojbGDvpvtp6/5GMcndzxjiFyg9u33pttTy4s/yNr
	MGtRgF2uxxn5niXJC39M41Z2U2Ipzkg01GIuKk4EACWqioHpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd29X8wCDb5MNrBYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPairesBcc5KtavX8TcwNjF3sXIySEhYCKx
	9FwbC4QtJnHh3no2EFtIYDqjxJbW/C5GLiD7F6PElBs7WUESbAJqEl++HAZq5uAQEdCXaGvR
	AKlhFuhllDjTuxssLiRgK9EzjweknFPATmLKxMdgu4QFPCXatzxgArFZBFQljky9DWbzApXv
	3NLADmELSvyYfA/sHmYBLYn1O48zQdjyEpvXvGUGGS8hoC7x6K8uSFhEwEhiwY+vUCUiEvte
	vGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgpPAM+kd
	jKsaLA4xCnAwKvHwTlAxCxRiTSwrrsw9xCjBwawkwst1BijEm5JYWZValB9fVJqTWnyIMRno
	0YnMUqLJ+cAElVcSb2hsYmZkaWRmYWRibk6asJI4L+OpJwFCAumJJanZqakFqUUwW5g4OKUa
	GBnKwiM6Zaev3mlhvHDzhk7B6dfn8q6Ma/qdd+nSz3sWDgmiH9InsERcale3FbvUsq12TbNZ
	8sr33U2931fvmX71SExK8pY7aff+sC/aEfu5KX7VpoNMCo4+N4qYGE5PEDKMkuuucj8/33fm
	xsas2rd+MbYKlRt0WZ/k9N78vHTj/gcZ6p9dNJRYijMSDbWYi4oTAdOgP5tGAwAA
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
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-da9052.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-da9052.c b/drivers/rtc/rtc-da9052.c
index 0dde688..c4d12d9 100644
--- a/drivers/rtc/rtc-da9052.c
+++ b/drivers/rtc/rtc-da9052.c
@@ -249,7 +249,7 @@ static int da9052_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				       &da9052_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc))
 		return PTR_ERR(rtc->rtc);
@@ -259,9 +259,6 @@ static int da9052_rtc_probe(struct platform_device *pdev)
 
 static int da9052_rtc_remove(struct platform_device *pdev)
 {
-	struct da9052_rtc *rtc = pdev->dev.platform_data;
-
-	rtc_device_unregister(rtc->rtc);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


