Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaEZHQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:16:43 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25204 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaEZHQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:16:28 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-25-5382ea4ae4a6
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Libo Chen <clbchenlibo.chen@huawei.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH 2/2] power: max8925: Use of_get_child_by_name
Date: Mon, 26 May 2014 09:16:11 +0200
Message-id: <1401088571-4407-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401088571-4407-1-git-send-email-k.kozlowski@samsung.com>
References: <1401088571-4407-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t/xy7per5qCDT78FLQ4uFXTYvKtvWwW
	k568Z7aYuHIys8XrF4YWl3fNYXNg85jQ/4nRY+esu+weLUfesnpsXqHl0bdlFaPH501yAWxR
	XDYpqTmZZalF+nYJXBkn+q6yFmxgq+j+d525gXEzaxcjJ4eEgInEuTeToWwxiQv31rN1MXJx
	CAksZZS4eOkFlNPHJHHj0Wd2kCo2AWOJzcuXsIHYIgKVEt9On2ABKWIWaGKUaHr7nxEkISzg
	IjHh015mEJtFQFVi8cI1TCA2r4CbxO+Vr5gg1slJnDwGspqDg1PAXWLSLWeQsBBQye7mt0wT
	GHkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJqK87GJceszrEKMDBqMTD+yKvKViI
	NbGsuDL3EKMEB7OSCO+FXKAQb0piZVVqUX58UWlOavEhRiYOTqkGxo45eteUHFNPTGdjqjKc
	nbW8y+/DgwwtqX6jr898vWXyyzfOOnbq1pO1EnV5/nPrzzuqe//plmZ7bs8YdGWfrAVrxqey
	6XpWZuV9Ok5zeRlbhYP+ZEqralT0VL/7HPlhyloxkxyFph1sPNuaznFNOMWo9KHqUN/2i5ph
	HtEcNyTWRodsnFGpxFKckWioxVxUnAgA7+qFSAYCAAA=
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

