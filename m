Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab3CFFal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:30:41 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48686 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3CFFak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:30:40 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-eb-5136d4789ee9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 10/30] rtc: rtc-imxdi: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:30:31 +0900
Message-id: <004c01ce1a2b$b866e4f0$2934aed0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAHL/Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zfd2KK2aBBl83S1gsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVser4daaCr+wVOxbVNzCeZeti5OSQEDCROHXwBhOELSZx4d56oDgXh5DAMkaJGVsO
	McEUXf3wnhnEFhKYzihx5kUYRNEvRok1P1eBTWITUJP48uUwexcjB4eIgL5EW4sGSA2zQC9Q
	fe9udohmW4mr3avABnEK2EksfzyLBcQWFnCVeLXvJdgyFgFViX2X9rGC2LxA9e1XHkDZghI/
	Jt8Dq2cW0JJYv/M4E4QtL7F5zVtmkL0SAuoSj/7qgoRFBIwkmjd1sUOUiEjse/GOEeKXW+wS
	7xZpQawSkPg2+RALRKusxKYDzBAlkhIHV9xgmcAoMQvJ4llIFs9CsngWkg0LGFlWMYqmFiQX
	FCelF5nqFSfmFpfmpesl5+duYoRE6cQdjPcPWB9iTAZaP5FZSjQ5HxjleSXxhsbGJmYmpibm
	lqbmpqQJK4nzyl+SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAqC/q/Wf/kcmr36aJF1of
	v6gaKrfiw7q+Pw7L7ptNvrbErlXzskDC5j5Hzd0qHIGry08vsKg+s7h4f8aKslOOWqXGHObp
	u1QSn+ZMZbntIlG1ZMWU/el7dtguex+8WrclL9Znl/PEN+bKUlcrjM8dXryqWkL2+uZ3Wb2a
	hXN3qna3MeY/U9tVqcRSnJFoqMVcVJwIABxvKRToAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd2KK2aBBud+CFssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLHq+HWmgq/sFTsW1TcwnmXrYuTkkBAwkbj6
	4T0zhC0mceHeerC4kMB0RokzL8K6GLmA7F+MEmt+rgJLsAmoSXz5cpi9i5GDQ0RAX6KtRQOk
	hlmgF6i+dzc7RLOtxNXuVWBDOQXsJJY/nsUCYgsLuEq82veSCcRmEVCV2HdpHyuIzQtU337l
	AZQtKPFj8j2wemYBLYn1O48zQdjyEpvXvGUG2SshoC7x6K8uSFhEwEiieVMXO0SJiMS+F+8Y
	JzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAk8Ex6B+Oq
	BotDjAIcjEo8vBNUzAKFWBPLiitzDzFKcDArifBynQEK8aYkVlalFuXHF5XmpBYfYkwGenQi
	s5Rocj4wQeWVxBsam5gZWRqZWRiZmJuTJqwkzst46kmAkEB6YklqdmpqQWoRzBYmDk6pBsak
	pj96/9rESldvUrt4NV4idp3igyOx532O8Lp1XXU6dHnvMUuHNLtzjY7njHctOip/bPY/XyvL
	9MOpna9n2dyROpR+U23C0Wh5+elsJnwNbqnSRZW9bB8eMFf+l9zq2aO7NSNxw+fCPDWP1nCX
	W8ti5nBt9AhQZRDOYv6/6wR/zGzGT74b9iixFGckGmoxFxUnAgDgKrYiRgMAAA==
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
 drivers/rtc/rtc-imxdi.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index 73cf81c..25d20cf 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -464,7 +464,7 @@ static int __init dryice_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, imxdi);
-	imxdi->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	imxdi->rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 				  &dryice_rtc_ops, THIS_MODULE);
 	if (IS_ERR(imxdi->rtc)) {
 		rc = PTR_ERR(imxdi->rtc);
@@ -488,8 +488,6 @@ static int __exit dryice_rtc_remove(struct platform_device *pdev)
 	/* mask all interrupts */
 	__raw_writel(0, imxdi->ioaddr + DIER);
 
-	rtc_device_unregister(imxdi->rtc);
-
 	clk_disable_unprepare(imxdi->clk);
 
 	return 0;
-- 
1.7.2.5


