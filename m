Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab3CNIKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:10:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13917 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3CNIKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:10:18 -0400
X-AuditID: cbfee68d-b7f786d000005188-24-514185e843c5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/30] rtc: rtc-ab3100: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:10:16 +0900
Message-id: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zQ90XrY6BBt+nG1ssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVMaNNteACR8XUff+YGxgnsHcxcnJICJhI3N41iwXCFpO4cG89WxcjF4eQwDJGiTmP
	l7HAFC17fYEZIjGdUeLv/ousIAkhgV+MEr+Xs4HYbAJqEl++HAaaysEhIqAv0daiAVLPLNDL
	KHGmdzfYNmEBN4mTW6YwgdgsAqoSu5d0M4LYvAK2EnuWHmaBsAUlfky+B2YzC2hJrN95nAnC
	lpfYvOYtM8h8CQF1iUd/dUHCIgJ6Ei1fXkKViEjse/GOEWSvhMAxdokZPXdZIXYJSHybfIgF
	oldWYtMBZoi/JCUOrrjBMoFRbBaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLUK07MLS7N
	S9dLzs/dxAiJu94djLcPWB9iTAZaP5FZSjQ5Hxi3eSXxhsZmRhamJqbGRuaWZqQJK4nzqrVY
	BwoJpCeWpGanphakFsUXleakFh9iZOLglGpgnP9kmUIam9kWZ8WqSxel9opNTqjacLxR1K2a
	9SBL1svy4LN3zbf9+34uyvfQxiCL2OMMDpe/5M9/PGfmOgnTT2snJq865F/8xElT5O2bb2VT
	3+wUbNyauMK3t/KeWusMlR8Ns3hsGlTWi1Q43Vv2y3fZlog7b99kzFL8HMy+Jkrz+4miDLa/
	E5RYijMSDbWYi4oTAYmDMMLRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd0XrY6BBoce6VksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDGjTbXgAkfF1H3/mBsYJ7B3MXJySAiYSCx7
	fYEZwhaTuHBvPVsXIxeHkMB0Rom/+y+ygiSEBH4xSvxezgZiswmoSXz5chiomYNDREBfoq1F
	A6SeWaCXUeJM726wocICbhInt0xhArFZBFQldi/pZgSxeQVsJfYsPcwCYQtK/Jh8D8xmFtCS
	WL/zOBOELS+xec1bZpD5EgLqEo/+6oKERQT0JFq+vIQqEZHY9+Id4wRGgVlIJs1CMmkWkkmz
	kLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc1c+kdzCuarA4xCjAwajEwxsh6hgo
	xJpYVlyZe4hRgoNZSYTX0wsoxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAhJNXEm9obGJm
	ZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyuRtof7v5P95ghqaGmevRV
	9+42+WN2rnWT3VfN+njT50x2jv1rX72TmZ4cc4R+J/Z8TbbfOtFCd5rM5+WtL2KeTStmm7Fz
	UbPG5u37ing79qm4Z69yPCg303F9oWVVjyHbn6iqOT9uf2W/ZnZZ/7plVEbN7ehp63hNQm49
	jvx9JNGlXPvsw1wlluKMREMt5qLiRABiAgVYLgMAAA==
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
 drivers/rtc/rtc-ab3100.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
index c2f12d3..47a4f2c 100644
--- a/drivers/rtc/rtc-ab3100.c
+++ b/drivers/rtc/rtc-ab3100.c
@@ -229,8 +229,8 @@ static int __init ab3100_rtc_probe(struct platform_device *pdev)
 		/* Ignore any error on this write */
 	}
 
-	rtc = rtc_device_register("ab3100-rtc", &pdev->dev, &ab3100_rtc_ops,
-				  THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, "ab3100-rtc",
+					&ab3100_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		err = PTR_ERR(rtc);
 		return err;
@@ -242,9 +242,6 @@ static int __init ab3100_rtc_probe(struct platform_device *pdev)
 
 static int __exit ab3100_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc);
 	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
-- 
1.7.2.5


