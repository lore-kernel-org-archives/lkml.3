Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbbAEJJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:09:14 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31848 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbbAEJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:44 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-49-54aa52f4e9bd
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 01/14] mfd: 88pm860x-core: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:01:20 +0100
Message-id: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJMWRmVeSWpSXmKPExsVy+t/xa7pfglaFGMw7zmvx+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bX7+eZC66y
	Vqw/9oilgfEOSxcjJ4eEgInE6gunmCBsMYkL99azdTFycQgJLGWUOLJiLzNIQkigj0ni0FNT
	EJtNwFhi8/IlbCC2iECWxI9pq8EGMQsYSvx894cdxBYW8JD42zKPEcRmEVCV2PjzEdgCXgE3
	ic3TOpghlslJnDw2mXUCI/cCRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCF+/7KDcfEx
	q0OMAhyMSjy8HidWhgixJpYVV+YeYpTgYFYS4V13CyjEm5JYWZValB9fVJqTWnyIkYmDU6qB
	UWf67+6VK06LvTng6uJca1hyrHGma5yR96rLl+PnGAXdnM8o+dn72rzOoB3BelVbIpyFNO+L
	TdwTsmhLA8Pnc2fsy12/cCxKvVn6OzD4ffHZVfdCmqdKbYpdzp7zdd3pBSfLZ867puq9WfP0
	X3PuLR98o9kS8n7MF/ludP5W07rm9V9mnr7iZKnEUpyRaKjFXFScCAAb2mgj2QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/88pm860x-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 3a2604580164..d2a85cde68da 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -1111,7 +1111,7 @@ static int verify_addr(struct i2c_client *i2c)
 	return 0;
 }
 
-static struct regmap_config pm860x_regmap_config = {
+static const struct regmap_config pm860x_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
-- 
1.9.1

