Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaDDHwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:52:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15148 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaDDHvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:51:51 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-83-533e6494ead1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] power: max8925: Use of_get_child_by_name
Date: Fri, 04 Apr 2014 09:51:42 +0200
Message-id: <1396597902-2371-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396597902-2371-1-git-send-email-k.kozlowski@samsung.com>
References: <1396597902-2371-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xq7pTUuyCDSY+VbOY9OQ9s8XElZOZ
	LV6/MLS4vGsOmwOLx85Zd9k9Nq/Q8ujbsorR4/MmuQCWKC6blNSczLLUIn27BK6Mi5uzCray
	VayYdISpgXEraxcjB4eEgInEkj75LkZOIFNM4sK99WxdjFwcQgJLGSWaN/xgh3D6mCT6zvSz
	g1SxCRhLbF6+hA3EFhGolPh2+gQLiM0sYCjx890fdpChwgK2ErOWGoOEWQRUJS7vWMMIYvMK
	uEmsfbEJaq+CxJxJNiBhTgF3iQnzn4KVCAGVbJ30kGkCI+8CRoZVjKKppckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGCEh8nUH49JjVocYBTgYlXh4OdJtg4VYE8uKK3MPMUpwMCuJ8PYF2gUL8aYk
	VlalFuXHF5XmpBYfYmTi4JRqYNzyQPvY/QXy5l+9fnSsaFV98LCeK/9pY6fMZ87CuZ6BIfY3
	Vu1iPT7z5N8pvux+zWtEbpdsPKyXtK7t06ONe5rfZgeZHTp6UWLa6rjeSaZ937OZ0xh/L5gm
	duX0Aa82oxcae0o+iT/nmneLuX+2yF/p7D/tlo+nnj7Jqqohv/Hl6yuR3oqLddcrsRRnJBpq
	MRcVJwIAQMU9n+8BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of_get_child_by_name to obtain reference to charger node instead of
of_find_node_by_name which can walk outside of the parent node.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/max8925_power.c |    2 +-
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
1.7.9.5

