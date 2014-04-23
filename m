Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaDWM0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:26:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61585 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaDWM0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:26:08 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-e4-5357b15d127d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Libo Chen <clbchenlibo.chen@huawei.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND 2/2] power: max8925: Use of_get_child_by_name
Date: Wed, 23 Apr 2014 14:26:04 +0200
Message-id: <1398255964-389-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1398255964-389-1-git-send-email-k.kozlowski@samsung.com>
References: <1398255964-389-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t/xq7qxG8ODDc7dF7U4uFXTYvKtvWwW
	k568Z7aYuHIys8W5iZ3MFq9fGFpc3jWHzYHdY0L/J0aPnbPusnu0HHnL6rF5hZbH5IUXmT36
	tqxi9Pi8SS6APYrLJiU1J7MstUjfLoEr40TfVdaCDWwV3f+uMzcwbmbtYuTkkBAwkdh1aTeU
	LSZx4d56ti5GLg4hgaWMEkc/3GOHcPqYJKa9fsgEUsUmYCyxefkSNhBbRKBS4tvpEywgRcwC
	6xklGlfsAxslLOAicWv7Y3YQm0VAVWJH7xSwBl4BV4kVqz5DrZOTOHlsMpjNKeAmsb3xDyOI
	LQRU83X3Y8YJjLwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoSE2dcdjEuPWR1iFOBg
	VOLhlVgeFizEmlhWXJl7iFGCg1lJhHfJovBgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwezkdm
	MU92XPL4Y4FTwJfO/oBrkx6VdiRsFYgrvLVL+No31TSblJ7qPTvTOi8zTpus+KvxHRu/sWbr
	of8LLdf3n7OdwP979T3ee3ttO5/dyBE86a55P2xr+xMm+975GVE7yicffCFvW2V398FKwfuX
	VjZvKd2t8tr1bKhA1PeFqW1+7Sw7r7IrsRRnJBpqMRcVJwIAFEC82hECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of_get_child_by_name to obtain reference to charger node instead of
of_find_node_by_name which can walk outside of the parent node.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/max8925_power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index 0cf237808d47..a6d45eef64dd 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -443,7 +443,7 @@ max8925_power_dt_init(struct platform_device *pdev)
 	if (!nproot)
 		return pdev->dev.platform_data;
 
-	np = of_find_node_by_name(nproot, "charger");
+	np = of_get_child_by_name(nproot, "charger");
 	if (!np) {
 		dev_err(&pdev->dev, "failed to find charger node\n");
 		return NULL;
-- 
1.9.1

