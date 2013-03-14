Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab3CNIW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:22:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33780 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3CNIWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:22:55 -0400
X-AuditID: cbfee68d-b7f786d000005188-e7-514188de6b3d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 25/30] rtc: rtc-starfire: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:22:53 +0900
Message-id: <009c01ce208d$1ff3ec00$5fdbc400$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAbhCQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY917HY6BBr9fcVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MjfvnMxZ846hY+P4xWwPjVvYuRk4OCQETibnTLjFD2GISF+6t
	ZwOxhQSWMUps/68FUzPt4GSgGi6g+CJGieer9zNBOLOZJOYevcEEUsUmoCbx5cthoKkcHCIC
	+hJtLRogNcwCvYwSZ3p3g8WFBGwlrv+3AzE5BewkNqwXA+kUFvCQ2DPzGNg9LAKqEmu/3QS7
	hxeo+tyWl6wQtqDEj8n3WEBsZgEtifU7jzNB2PISm9e8ZQYZKSGgLvHory5IWETASOLPu5ms
	ECUiEvtevGMEuUZCYBm7xOy1E1ggdglIfJt8iAWiV1Zi0wFoMEhKHFxxg2UCo8QsJJtnIdk8
	C8nmWUhWLGBkWcUomlqQXFCclF5kqFecmFtcmpeul5yfu4kRElW9OxhvH7A+xJgMtH4is5Ro
	cj4wKvNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wHh3lcO6xWkTYn+tYvzz7Lno85MiqRKTXsU3v+XY/X/LZmP/NQe67Jy4NzAF35Tteh8jcODc
	N6Gl56z+5Ly7VvvuUn5EkrNSu8ULj1+CXtbsjuxvXKdJs027t1J9fq/c/x2+Ase2P35zXSb2
	+L+eD3WzJbdcEl+sr3dtzgOBxIpJPWrTdwRO/PdbiaU4I9FQi7moOBEAohJfN8ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO69DsdAg6897BaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY+P++YwF3zgqFr5/zNbA
	uJW9i5GTQ0LARGLawcnMELaYxIV769m6GLk4hAQWMUo8X72fCcKZzSQx9+gNJpAqNgE1iS9f
	DgN1c3CICOhLtLVogNQwC/QySpzp3Q0WFxKwlbj+3w7E5BSwk9iwXgykU1jAQ2LPzGNge1kE
	VCXWfrsJtpcXqPrclpesELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGUGGSkhoC7x6K8uSFhE
	wEjiz7uZrBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz
	0vWS83M3MYKj9pnUDsaVDRaHGAU4GJV4eA/0OwQKsSaWFVfmHmKU4GBWEuH19HIMFOJNSays
	Si3Kjy8qzUktPsSYDPToRGYp0eR8YELJK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJ
	anZqakFqEcwWJg5OqQbGWR/Xh7UnVxp+mJwRvzc1LGlZSBynjv7BDPfDTbX73LiCtP9+v+J5
	jX2q4tbFC8+/dHwQYPvQO/A60/rf7Ilucz6cm791sf3l8vrCf1MnmEQemilhVxrYnXXsz0qJ
	10vnzfmy1Y/rLsdhA6sT9pbXWDSas+0tbz89nBwXGdZ2M83QZd2ShTFTlFiKMxINtZiLihMB
	iMaiBR4DAAA=
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
 drivers/rtc/rtc-starfire.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-starfire.c b/drivers/rtc/rtc-starfire.c
index db7d076..987b5ec 100644
--- a/drivers/rtc/rtc-starfire.c
+++ b/drivers/rtc/rtc-starfire.c
@@ -39,8 +39,10 @@ static const struct rtc_class_ops starfire_rtc_ops = {
 
 static int __init starfire_rtc_probe(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = rtc_device_register("starfire", &pdev->dev,
-				     &starfire_rtc_ops, THIS_MODULE);
+	struct rtc_device *rtc;
+
+	rtc = devm_rtc_device_register(&pdev->dev, "starfire",
+				&starfire_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -51,10 +53,6 @@ static int __init starfire_rtc_probe(struct platform_device *pdev)
 
 static int __exit starfire_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


