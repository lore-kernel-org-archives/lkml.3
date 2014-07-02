Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaGBJSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:18:25 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22523 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaGBJSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:18:13 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-f4-53b3ce523a08
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton@enomsg.org>
Cc: Philip Rakity <prakity@marvell.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND 2/2] power: max8925: Use of_get_child_by_name
Date: Wed, 02 Jul 2014 11:17:54 +0200
Message-id: <1404292674-5260-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404292674-5260-1-git-send-email-k.kozlowski@samsung.com>
References: <1404292674-5260-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEJMWRmVeSWpSXmKPExsVy+t/xy7pB5zYHG7z9rmhxcKumxaQn75kt
	Jq6czGzx+oWhxeVdc9gs5q9+wujA5jGh/xOjx85Zd9k9Nq/Q8pi88CKzR9+WVYwenzfJBbBF
	cdmkpOZklqUW6dslcGWc6LvKWrCBraL733XmBsbNrF2MnBwSAiYSm1evZ4OwxSQu3IOwhQSW
	Mkps2m7TxcgFZPcxSUy4/pQJJMEmYCyxefkSNpCEiMB8RonpB6eDdTALREi8P/YXzBYWcJG4
	tf0xO4jNIqAq8eHqQaA4BwevgJtE3ycRiGVyEiePTQY7glPAXeLPildMEIvdJLY2PmabwMi7
	gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIOH3Zwbj4mNUhRgEORiUe3sYVG4KFWBPL
	iitzDzFKcDArifA+OrM5WIg3JbGyKrUoP76oNCe1+BAjEwenVAPjJB25bXt+dd1bF+23f0HJ
	mTWidpwPd3lseHV+Qb1KrdSUojz/gva+809Tf1psdDoc/8NG+vP6Y/uf3ORsO/TqmswZ+an3
	NnOum7I2xMx/r4H/W47KySc2MF7+vzPswVZt6T2ufYJbJT9VTdNclcL1fYLNpo1zrn0vmiB0
	+3Xivx3i5nv+bmsya1NiKc5INNRiLipOBAADUBz8BQIAAA==
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

