Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbbAEI5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:57:41 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39255 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbbAEI5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:57:39 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-94-54aa51ff2303
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] extcon: max77693: Constify struct regmap_config
Date: Mon, 05 Jan 2015 09:57:27 +0100
Message-id: <1420448247-8097-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJMWRmVeSWpSXmKPExsVy+t/xy7r/A1eFGFy+bG1x/ctzVovXLwwt
	Lu+aw2Zxu3EFmwOLR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGXM6TrDXjCTrWLtssmMDYzz
	WbsYOTkkBEwkbl/eBmWLSVy4t56ti5GLQ0hgKaPEgvNLWCGcPiaJ5y9BMpwcbALGEpuXLwGz
	RQQKJZ5suApmMwsYSvx894cdxBYWcJBYOu0hM4jNIqAqcfDlbBYQm1fATWJl6zF2iG1yEieP
	TWadwMi9gJFhFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkaIp7/uYFx6zOoQowAHoxIPr8eJ
	lSFCrIllxZW5hxglOJiVRHjX3QIK8aYkVlalFuXHF5XmpBYfYmTi4JRqYLRJnd50qCfWudjJ
	ouqq1zGPM7YhCQVT79Rrfo0penbWSeGrxm3FstrQzfu53tl0zj8V4qr7b+u8g8Fu3f9l9k6v
	SW+99Pcue3KdRL/sjjyez1d115h9vGxwd9aJzOA3P+9WXL3KwGGudMTY0tb1+DV19+xC3wsT
	eQ4+fDFvc9HevINWrfv7lZVYijMSDbWYi4oTAY47cSHSAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 740a14d35072..af165fd0c6f5 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1033,7 +1033,7 @@ static irqreturn_t max77693_muic_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static struct regmap_config max77693_muic_regmap_config = {
+static const struct regmap_config max77693_muic_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
-- 
1.9.1

