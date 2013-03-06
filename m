Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3CFHxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:53:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53139 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab3CFHxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:53:41 -0500
X-AuditID: cbfee690-b7f6b6d000004563-7e-5136f604fdcd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 18/30] rtc: rtc-palmas: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:53:40 +0900
Message-id: <008c01ce1a3f$b76c8f50$2645adf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAOBiA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ12Wb2aBBotvyVssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsfHlMbaCVdwVT5v2MTcw7uTsYuTkkBAwkZg3ezUThC0mceHeerYuRi4OIYFljBLT
	d59lgSm69XUtI0RiOqPElClL2SGcX4wSK29sZwWpYhNQk/jy5TBQgoNDREBfoq1FA6SGWaCX
	UeJM726wuJCArUTPPB6Qck4BO4kpEx+zg9jCAp4Sj/a8AruCRUBVYuOTfrA4L1D5/I3TGSFs
	QYkfk++BHcQsoCWxfudxJghbXmLzmrfMIOMlBNQlHv3VhbjASGLzTTeIChGJfS/egZ0vIXCL
	XeLDwdmMEKsEJL5NPsQC0SorsekAM8S7khIHV9xgmcAoMQvJ4llIFs9CsngWkhULGFlWMYqm
	FiQXFCelF5noFSfmFpfmpesl5+duYoTE6YQdjPcOWB9iTAZaP5FZSjQ5HxjneSXxhsbGJmYm
	pibmlqbmpqQJK4nzyl+SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuPgD2/4/X08Ezih8
	ZTSPlesxx9zgg34LT51a+32T7UH7SVue5uVyvTOofbQ9Ud5be0bbxL+txq15ygf9nrblrd73
	Mzey+TJXRMVcjpvLaxh5hFqWnet9sNXyrHpJH8e2lfe2WOSfVrs1ySUz3787W/bWdZ4FtVVy
	+3QV0+YusLnh2nnULX+RqhJLcUaioRZzUXEiAMpGKRnpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV2Wb2aBBltmSVssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLHx5TG2glXcFU+b9jE3MO7k7GLk5JAQMJG4
	9XUtI4QtJnHh3nq2LkYuDiGB6YwSU6YsZYdwfjFKrLyxnRWkik1ATeLLl8NACQ4OEQF9ibYW
	DZAaZoFeRokzvbvB4kICthI983hAyjkF7CSmTHzMDmILC3hKPNrzignEZhFQldj4pB8szgtU
	Pn/jdEYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMoOMlxBQl3j0VxfiAiOJzTfdICpEJPa9
	eMc4gVFoFpJBs5AMmoVk0CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBCeBZ9I7
	GFc1WBxiFOBgVOLhnaBiFijEmlhWXJl7iFGCg1lJhJfrDFCINyWxsiq1KD++qDQntfgQYzLQ
	nxOZpUST84EJKq8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBxcEo1
	MC5aybh3U96cdFuPa+4y4l6x9bbnKhmvfbq+U9X7roONCOesQsZFM2ZzeSq9zX9RnWHz5J5E
	a1dP4K7LJ49U/3G8v/BX/vTgCxd2Xf/z3cxHYuHKeN4injzpcP+4rrMF/z7PPZvU2/aMm+XK
	k9BE1XA9Sdas/gdJ/+6/Ul61+nbHJ18Vk2hLGyWW4oxEQy3mouJEAItyqqdGAwAA
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

 drivers/rtc/rtc-palmas.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c
index df9359c..bbc3b9ef 100644
--- a/drivers/rtc/rtc-palmas.c
+++ b/drivers/rtc/rtc-palmas.c
@@ -264,7 +264,7 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 
 	palmas_rtc->irq = platform_get_irq(pdev, 0);
 
-	palmas_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	palmas_rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				&palmas_rtc_ops, THIS_MODULE);
 	if (IS_ERR(palmas_rtc->rtc)) {
 		ret = PTR_ERR(palmas_rtc->rtc);
@@ -279,7 +279,6 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 			dev_name(&pdev->dev), palmas_rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ request failed, err = %d\n", ret);
-		rtc_device_unregister(palmas_rtc->rtc);
 		return ret;
 	}
 
@@ -289,10 +288,7 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 
 static int palmas_rtc_remove(struct platform_device *pdev)
 {
-	struct palmas_rtc *palmas_rtc = platform_get_drvdata(pdev);
-
 	palmas_rtc_alarm_irq_enable(&pdev->dev, 0);
-	rtc_device_unregister(palmas_rtc->rtc);
 	return 0;
 }
 
-- 
1.7.2.5


