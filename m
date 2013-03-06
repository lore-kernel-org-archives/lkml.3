Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3CFHue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:50:34 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45900 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3CFHu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:50:28 -0500
X-AuditID: cbfee68d-b7f636d0000009be-29-5136f543eb8f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 09/30] rtc: rtc-ep93xx: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:50:27 +0900
Message-id: <008301ce1a3f$44762ba0$cd6282e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAGwjA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ13nr2aBBte+mFssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsaN/PUvBZ56KYzvWszYwPufqYuTkkBAwkTjU9IQdwhaTuHBvPVsXIxeHkMAyRokj
	n04wwhRN3LKFGSIxnVFi6++fTBDOL0aJ/y92MIFUsQmoSXz5chhoFAeHiIC+RFuLBkgNs0Av
	o8SZ3t1gcSEBW4meeTwg5ZwCdhJTJj4G2yws4CnR+3sT2BgWAVWJ5wcOg8V5gcqfTuqHsgUl
	fky+xwJiMwtoSazfeZwJwpaX2LzmLTPIeAkBdYlHf3VBwiICRhKX5jezQ5SISOx78Y4R5BwJ
	gXvsEq+mdjND7BKQ+Db5EAtEr6zEpgPMEP9KShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnF
	KJpakFxQnJReZKhXnJhbXJqXrpecn7uJERKpvTsYbx+wPsSYDLR+IrOUaHI+MNLzSuINjY1N
	zExMTcwtTc1NSRNWEueVuyQTKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHxgovCBWWvqWu/
	M25xOnnL/izbnFWnf8S8jXq9SnVrb0x4nkvnwXtiyzXLJT8lBt553CtbPllnodmz5cvb3Qp3
	Fh81cfsskMdyOqv+6uddMxf2z9m58FNNu+OCfL6F+zYWGAdn734Zmz3Ree+E20pXXsUL6xtq
	Re4Qu7r3yfdDX816b2+ZHF91SYmlOCPRUIu5qDgRAHJddezqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV3nr2aBBq/WG1ssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLGjfz1LwWeeimM71rM2MD7n6mLk5JAQMJGY
	uGULM4QtJnHh3nq2LkYuDiGB6YwSW3//ZIJwfjFK/H+xgwmkik1ATeLLl8PsXYwcHCIC+hJt
	LRogNcwCvYwSZ3p3g8WFBGwleubxgJRzCthJTJn4mB3EFhbwlOj9vQlsDIuAqsTzA4fB4rxA
	5U8n9UPZghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGWS8hIC6xKO/uiBhEQEjiUvzm9khSkQk
	9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp4Fn
	0jsYVzVYHGIU4GBU4uGdoGIWKMSaWFZcmXuIUYKDWUmEl+sMUIg3JbGyKrUoP76oNCe1+BBj
	MtCjE5mlRJPzgSkqryTe0NjEzMjSyMzCyMTcnDRhJXFexlNPAoQE0hNLUrNTUwtSi2C2MHFw
	SjUwClhx7xc4m71s+sPUx+blm6fYzfDoW7/B3fdDb1v28tXaQRFTAk56H5zivo7VZeny1Dnq
	7CwzxC8snLT0Lu/1ZTumbeArkyzfIfFApHHyt8pFldO7/M9cSijp57erabHz9d+VX1Qe661j
	v3qtVU449/b2pjePOnaLxPSclNmhZvjz2OGU757ZSizFGYmGWsxFxYkAjUXaNUcDAAA=
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

 drivers/rtc/rtc-ep93xx.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 1a4e5e4..5807b77 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -153,8 +153,8 @@ static int ep93xx_rtc_probe(struct platform_device *pdev)
 	pdev->dev.platform_data = ep93xx_rtc;
 	platform_set_drvdata(pdev, ep93xx_rtc);
 
-	ep93xx_rtc->rtc = rtc_device_register(pdev->name,
-				&pdev->dev, &ep93xx_rtc_ops, THIS_MODULE);
+	ep93xx_rtc->rtc = devm_rtc_device_register(&pdev->dev,
+				pdev->name, &ep93xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ep93xx_rtc->rtc)) {
 		err = PTR_ERR(ep93xx_rtc->rtc);
 		goto exit;
@@ -162,12 +162,10 @@ static int ep93xx_rtc_probe(struct platform_device *pdev)
 
 	err = sysfs_create_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
 	if (err)
-		goto fail;
+		goto exit;
 
 	return 0;
 
-fail:
-	rtc_device_unregister(ep93xx_rtc->rtc);
 exit:
 	platform_set_drvdata(pdev, NULL);
 	pdev->dev.platform_data = NULL;
@@ -176,11 +174,8 @@ exit:
 
 static int ep93xx_rtc_remove(struct platform_device *pdev)
 {
-	struct ep93xx_rtc *ep93xx_rtc = platform_get_drvdata(pdev);
-
 	sysfs_remove_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(ep93xx_rtc->rtc);
 	pdev->dev.platform_data = NULL;
 
 	return 0;
-- 
1.7.2.5


