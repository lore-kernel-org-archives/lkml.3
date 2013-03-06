Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3CFHux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:50:53 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45950 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab3CFHur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:50:47 -0500
X-AuditID: cbfee690-b7f6b6d000004563-ac-5136f5568294
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 10/30] rtc: rtc-imxdi: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:50:45 +0900
Message-id: <008401ce1a3f$4f7e1d50$ee7a57f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAHexA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zQ92wr2aBBivPC1ksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVMXXZFJaCvRwV/5Y2MjcwtrJ3MXJwSAiYSMye7NbFyAlkiklcuLeeDcQWEljGKLFq
	jgBE3ETi377njF2MXEDx6YwST56cZodwfjFKTHp1FKyDTUBN4suXw2BDRQT0JdpaNEBqmAV6
	GSXO9O4GiwsJ2Er0zOMBKecUsJOYMvExO4gtLOAhsXVrNwuIzSKgKvFj9RMmkHJeoPLX7SEg
	YV4BQYkfk++BlTALaEms33mcCcKWl9i85i0zxCvqEo/+6oKERQSMJC5NecYGUSIise/FO7Dz
	JQTusUucalzFBLFKQOLb5EMsEL2yEpsOMEO8KylxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFl
	FaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZIjE7YwXjvgPUhxmSg9ROZpUST84ExnlcSb2hs
	bGJmYmpibmlqbkqasJI4r/wlmUAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjFEcH2ZOE3vu
	4uF77JSQdkyNa/jmN5Kn2t5NNfRJsZ1b9ZvBkKGjPvf+tAedMtnpYcLlIdsPrXi9+ZTopLKG
	god2ayuP6u5gtHrf9eDRo2+ZUg0zvkgs+rZ9/nuhe44m3UcMYuSmBjlZLXrTF54duSxp9obc
	U/d7825vcb/M5tx+ULOmZt4DfiWW4oxEQy3mouJEAElyHm/nAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd2wr2aBBmem8lksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDF12RSWgr0cFf+WNjI3MLaydzFyckgImEj8
	2/ecEcIWk7hwbz1bFyMXh5DAdEaJJ09Os0M4vxglJr06ygZSxSagJvHly2GgBAeHiIC+RFuL
	BkgNs0Avo8SZ3t1gcSEBW4meeTwg5ZwCdhJTJj4GWyYs4CGxdWs3C4jNIqAq8WP1EyaQcl6g
	8tftISBhXgFBiR+T74GVMAtoSazfeZwJwpaX2LzmLTNIuYSAusSjv7ogYREBI4lLU56xQZSI
	SOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4C
	z6R3MK5qsDjEKMDBqMTDO0HFLFCINbGsuDL3EKMEB7OSCC/XGaAQb0piZVVqUX58UWlOavEh
	xmSgPycyS4km5wMTVF5JvKGxiZmRpZGZhZGJuTlpwkrivIynngQICaQnlqRmp6YWpBbBbGHi
	4JRqYKy+8fuH3+MH4g5yK7trnwbb5r8PtVN6pX3UOlHa5PRL/zNxsVXSUqXPlPfwVZ/rWbfy
	dcL7RbMfqalr+1+0eXxPST88r4yZJXVt7J9vgqy7RS4kZ6lutlqVFWdcVb9a72rgnVqx5VV1
	NSLBB0zWvuy2OJ318v3KntfuTecNzDguybC81PNQUmIpzkg01GIuKk4EALjnDXhGAwAA
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

 drivers/rtc/rtc-imxdi.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index 73cf81c..33914e2 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -464,7 +464,7 @@ static int __init dryice_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, imxdi);
-	imxdi->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	imxdi->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
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


