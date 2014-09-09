Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbaIIJrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:47:33 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61285 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbaIIJra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:47:30 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-1f-540eccafc7d0
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH 2/2] power: max8925: Use of_get_child_by_name
Date: Tue, 09 Sep 2014 11:47:15 +0200
Message-id: <1410256035-24051-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410256035-24051-1-git-send-email-k.kozlowski@samsung.com>
References: <1410256035-24051-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLJMWRmVeSWpSXmKPExsVy+t/xa7rrz/CFGLy7omEx6cl7ZouJKycz
	W7x+YWhxedccNovPvUcYLU7vLnFg89g56y67x+YVWh6bVnWyefRtWcXo8XmTXABrFJdNSmpO
	Zllqkb5dAlfGib6rrAUb2Cq6/11nbmDczNrFyMkhIWAice/hDDYIW0ziwr31YLaQwFJGiV0f
	qrsYuYDsPiaJE88+gzWwCRhLbF6+hA0kISKwm1FiwtTlLCAJZgFDiZ/v/rCD2MICLhITPu1l
	BrFZBFQlnn1dCVTDwcEr4C7xpoMJYpmcxMljk8Fmcgp4SNw7NYMRYrG7xM9rX9kmMPIuYGRY
	xSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESRF93MC49ZnWIUYCDUYmHd2IZX4gQa2JZcWXu
	IUYJDmYlEd7dB4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGEPXfZufzJp4IXVruYvDsfyLu+Zw
	NPNHHfzRYNw6++fu/bk1ATM5F/2UXTZNd9PkQn33I3MefkuOfbrlwhNvxdPn+3epKbvvZH+8
	Sbu72fipyPLmVTK32mLnP3jLsj69kfPZmcd9ak4OFw+67twdINd3x+r9b1Xl9Z8/z6k6ueew
	osbLR+tEznUqsRRnJBpqMRcVJwIAZPSTmgACAAA=
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

