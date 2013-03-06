Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab3CFHyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:54:39 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21681 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3CFHyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:54:36 -0500
X-AuditID: cbfee690-b7f6b6d000004563-a8-5136f63aca6e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 21/30] rtc: rtc-snvs: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:54:34 +0900
Message-id: <008f01ce1a3f$d797ba70$86c72f50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAP+vA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zQ12rb2aBBvduyVgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8W96ZsECjoqpzWfZGhifs3UxcnJICJhI/N25jBnCFpO4cG89UJyLQ0hgGaPEie4u
	Fpii4z/3sEMkpjNK3P4zixUkISTwi1Fiwrk8EJtNQE3iy5fDQEUcHCIC+hJtLRog9cwCvYwS
	Z3p3g8WFBGwleubxgJRzCthJTJn4mB3EFhZwl5j48zeYzSKgKnFw4VkmEJsXqPzy4p9QtqDE
	j8n3wO5hFtCSWL/zOBOELS+xec1bZpDxEgLqEo/+6oKERQSMJLovPmKDKBGR2PfiHSPIORIC
	t9glHtyYywKxS0Di2+RDLBC9shKbDkDDQVLi4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR
	1ILkguKk9CITveLE3OLSvHS95PzcTYyQKJ2wg/HeAetDjMlA6ycyS4km5wOjPK8k3tDY2MTM
	xNTE3NLU3JQ0YSVxXvlLMoFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGAMdV3PfTNCS3X1o
	f836Cr4pkqdYDxvP2P7b2uXCbanj+oUOncpH5tqoFvP9XBEpIVK91ChtDSP79uTqLwzPthpt
	6Lpwr+fjU+fMIuV3l/MStx0++fo/j7NIzYmHOnuL2hKtw0Or4hRWpAbP8yyNlFFy1yhdvjFf
	7eBju6OfTq/YKRj0YkM6pxJLcUaioRZzUXEiAO7QsnXoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV2rb2aBBsdmSVgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPFvembBAo6Kqc1n2RoYn7N1MXJySAiYSBz/
	uYcdwhaTuHBvPVCci0NIYDqjxO0/s1hBEkICvxglJpzLA7HZBNQkvnw5DNTAwSEioC/R1qIB
	Us8s0MsocaZ3N1hcSMBWomceD0g5p4CdxJSJj8HmCwu4S0z8+RvMZhFQlTi48CwTiM0LVH55
	8U8oW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMoOMlxBQl3j0VxckLCJgJNF98REbRImIxL4X
	7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4BTwTHoH
	46oGi0OMAhyMSjy8E1TMAoVYE8uKK3MPMUpwMCuJ8HKdAQrxpiRWVqUW5ccXleakFh9iTAZ6
	dCKzlGhyPjA95ZXEGxqbmBlZGplZGJmYm5MmrCTOy3jqSYCQQHpiSWp2ampBahHMFiYOTqkG
	Ru3He7Yst/1ckbLfoOWH6oKsh7xGx3l63llMa32w3VAvtKjMJfK0lZwYj+Eltcf+Ff5SnfcU
	LqQ2Sv7KmnNZivnayzs7nl5hCV3161OwineKraKXfc7aaRv9DlvM+2iQoWNhs8leaS3vBWa1
	Kvvz6VUd6jM/3FrsW6Ce9n/XuwnOl3xlpG3+KbEUZyQaajEXFScCAHnM1lFFAwAA
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

 drivers/rtc/rtc-snvs.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index f7d9070..b04f09a 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -283,7 +283,7 @@ static int snvs_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	data->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	data->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 					&snvs_rtc_ops, THIS_MODULE);
 	if (IS_ERR(data->rtc)) {
 		ret = PTR_ERR(data->rtc);
@@ -296,10 +296,6 @@ static int snvs_rtc_probe(struct platform_device *pdev)
 
 static int snvs_rtc_remove(struct platform_device *pdev)
 {
-	struct snvs_rtc_data *data = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(data->rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


