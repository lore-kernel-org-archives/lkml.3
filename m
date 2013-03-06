Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3CFHrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:47:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45114 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3CFHrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:47:10 -0500
X-AuditID: cbfee68d-b7f636d0000009be-1e-5136f47c6685
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2 01/30] rtc: rtc-88pm80x: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:47:07 +0900
Message-id: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t8zfd2aL2aBBrsaZC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuP53C1vBG46KC/NPszcwbmXvYuTkkBAwkfgy7TsrhC0mceHeejYQW0hgGaPE7hfh
	XYwcYDW/T6ZAhKczSsz7A1TCBWT/YpSYfXUiC0iCTUBN4suXw+wg9SIC+hJtLRogNcwCvYwS
	Z3p3g+0SFvCSWLu/kxnEZhFQldi4cy9YnFfAVuLsm++MELagxI/J98BmMgtoSazfeZwJwpaX
	2LzmLTPEPeoSj/7qgoRFBPQk1i1azAxRIiKx78U7RohXDrFLTPmSAbFKQOLb5EMsEK2yEpsO
	MEOUSEocXHGDZQKj2Cwki2chWTwLyeJZSDYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7
	iRESc707GG8fsD7EmAy0fiKzlGhyPjBm80riDY2NTcxMTE3MLU3NTUkTVhLnlbskEygkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBUU9kqaf90lcJ2ct36H3mst7R/vzaam+NS80398+aWtre
	eud1Qn59+H+5S7MCFcNWzjQRDdULF7vLkrHzS6zXDMspjCsWuRS7XNBqUViUEz5tQtkHxZYr
	3R8/mpYGn55qUBJmf23H3rj6d51yTZ9VpLa41mnm/ymZ/mmzhbr5ZcUrryweVyefU2Ipzkg0
	1GIuKk4EAM1IJKXPAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd2aL2aBBueXSlgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHH97xa2gjccFRfmn2ZvYNzK3sXIwSEhYCLx
	+2RKFyMnkCkmceHeejYQW0hgOqPEvD9ANheQ/YtRYvbViSwgCTYBNYkvXw6D9YoI6Eu0tWiA
	1DAL9DJKnOndzQ5SIyzgJbF2fycziM0ioCqxcedesDivgK3E2TffGSFsQYkfk++BzWQW0JJY
	v/M4E4QtL7F5zVtmiNvUJR791QUJiwjoSaxbtJgZokREYt+Ld4wTGAVmIZk0C8mkWUgmzULS
	soCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcFQ/k97BuKrB4hCjAAejEg/vBBWzQCHW
	xLLiytxDjBIczEoivFxngEK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0w4eSXxhsYmZkaW
	RmYWRibm5qQJK4nzMp56EiAkkJ5YkpqdmlqQWgSzhYmDU6qBkTljguHWlCzm6uki2pPnFxn1
	iBgUJT7R5jeZ+YZ59eSSC5+yDCPEdU992XPD8lWXZFzkHDPLp+m5eemROW1ze7IzGNas4S2P
	X1kn0bh7UgTzpZucwnqXXKJtXqmv/D351WT/16Lb5fiiY14sXPx6ifz+tgeqexOOcBsEJpmn
	rvicfF7589JIJZbijERDLeai4kQAdP5ftS4DAAA=
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

 drivers/rtc/rtc-88pm80x.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index 63b17eb..76f9505 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -312,7 +312,7 @@ static int pm80x_rtc_probe(struct platform_device *pdev)
 	}
 	rtc_tm_to_time(&tm, &ticks);
 
-	info->rtc_dev = rtc_device_register("88pm80x-rtc", &pdev->dev,
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev, "88pm80x-rtc",
 					    &pm80x_rtc_ops, THIS_MODULE);
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
@@ -346,7 +346,6 @@ static int pm80x_rtc_remove(struct platform_device *pdev)
 {
 	struct pm80x_rtc_info *info = platform_get_drvdata(pdev);
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(info->rtc_dev);
 	pm80x_free_irq(info->chip, info->irq, info);
 	return 0;
 }
-- 
1.7.2.5


