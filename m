Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaDWM3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:29:33 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52969 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaDWM3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:29:30 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-be-5357b2280a55
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND 1/2] rtc: 88pm860x: Use of_get_child_by_name
Date: Wed, 23 Apr 2014 14:29:27 +0200
Message-id: <1398256168-493-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t/xK7oam8KDDXr321gsuXiV3WLO+jVs
	FpfPHWa0uLzwEqvF6xeGFpd3zWGz2N/ZwWhx8k8vowOHx56JJ9k87lzbw+ZxYsZvFo++LasY
	PabP+8nk8XmTXABbFJdNSmpOZllqkb5dAlfGvwsL2At62SoufbnF1MDYw9rFyMkhIWAiMaN7
	NTuELSZx4d56ti5GLg4hgaWMEo+/dUE5fUwSB+7eZAOpYhMwlti8fAmYLSKQLrFo2hUmkCJm
	gRuMEn0vuxhBEsICzhKzX64CW8EioCpx6Mc1ZhCbV8BV4kv7SxaIdXISJ49NZp3AyL2AkWEV
	o2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkjofN3BuPSY1SFGAQ5GJR5eieVhwUKsiWXFlbmH
	GCU4mJVEeJcsCg8W4k1JrKxKLcqPLyrNSS0+xMjEwSnVwMgrx73ovkzxrRdXeXROzi8Xlr6w
	oZ+V6eeOTZk9lQKHLjYZGBfNEtdSe6JiETHnZaDZdIbpm08mhJXmXlunNK31Rvz8SxWTViya
	2djKy7Xx/fyknhnTHNonHb1VsLb02CW3LwznM3Ozrmb/uHa7N+Wcq//8mznrJgg5ZuT/FHNu
	FNzWEp6t1q3EUpyRaKjFXFScCADMATyk+wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of_get_child_by_name to obtain reference to charger node instead of
of_find_node_by_name which can walk outside of the parent node.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/rtc/rtc-88pm860x.c | 2 +-
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
1.9.1

