Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaDDHuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:50:54 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15100 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaDDHuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:50:51 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-a4-533e645958f9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] rtc: 88pm860x: Use of_get_child_by_name
Date: Fri, 04 Apr 2014 09:50:40 +0200
Message-id: <1396597841-2273-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJMWRmVeSWpSXmKPExsVy+t/xy7qRKXbBBqvPyVosuXiV3eL1C0OL
	y7vmsFns7+xgdGDx2DPxJJtH35ZVjB7T5/1k8vi8SS6AJYrLJiU1J7MstUjfLoEr4+ifkoJJ
	bBUrZ91nbWDsY+1i5OSQEDCR+PHxDiOELSZx4d56ti5GLg4hgaWMEm8arjFBOH1MEm8X32EG
	qWITMJbYvHwJG4gtIpAusWjaFSYQm1nAUOLnuz/sILawgI3EystrWLoYOThYBFQl5r1JAAnz
	CrhJnFjfzAwSlhBQkJgzyWYCI/cCRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCF+/7qD
	cekxq0OMAhyMSjy8HOm2wUKsiWXFlbmHGCU4mJVEePsC7YKFeFMSK6tSi/Lji0pzUosPMTJx
	cEo1MEr+FJtzln+W10bdP5ml3Kfiu/Y3HEgOdOcy4L3caXxYxKTES2YWy+lN6dO/nSyyLTX1
	kQn8dJ1NZd2Kho/OqfYsEzreNwkbRx/JlmO7ViblouAm0lv52q1cjVOchdV/2U2xJ22SzIWP
	2LOnxTdYXWWTiJJK95m/nvmXiErXEr9LfLm6UtJKLMUZiYZazEXFiQA82fDq2QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of_get_child_by_name to obtain reference to charger node instead of
of_find_node_by_name which can walk outside of the parent node.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/rtc/rtc-88pm860x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index 816504846cdd..fb9e3c63b4ac 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -293,7 +293,7 @@ static int pm860x_rtc_dt_init(struct platform_device *pdev,
 	int ret;
 	if (!np)
 		return -ENODEV;
-	np = of_find_node_by_name(np, "rtc");
+	np = of_get_child_by_name(np, "rtc");
 	if (!np) {
 		dev_err(&pdev->dev, "failed to find rtc node\n");
 		return -ENODEV;
-- 
1.7.9.5

