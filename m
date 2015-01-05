Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbbAEJCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:02:43 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31933 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbbAEJCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:02:41 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-22-54aa532f98f6
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] at86rf230: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:02:31 +0100
Message-id: <1420448551-9443-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t/xa7r6watCDGZNY7M41GBu8fqFocXl
	XXPYLO5MXsZicWyBmAOrx85Zd9k9+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PFhFNsBRvY
	Ko5NfMHSwLiJtYuRk0NCwETi/s2bTBC2mMSFe+vZuhi5OIQEljJKzO76xwTh9DFJfJj+GayK
	TcBYYvPyJWwgtohAncSNLTfBbGYBQ4mf7/6wg9jCApYSb76/A7NZBFQl3k57zgxi8wq4SSx6
	/ooNYpucxMljk1knMHIvYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRHi+S87GBcfszrE
	KMDBqMTD63FiZYgQa2JZcWXuIUYJDmYlEd51t4BCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGGPW
	n2SdJr6b8bb8o7wbU1cdPnRxUkXUVOUpHStNrpeqy66VWqq08+NPT+9z564cEpoXrrDxa2HQ
	q7MsPSrRZ1q6b4UfNQvuncxtdN1o6sctXiI39fd3tLAmduldr6jK7d75xHXVzGLlju7CRccr
	py1YJsu4jI8pRfTaTKeTl79ZzH35V249U7MSS3FGoqEWc1FxIgDtCUWF2gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/net/ieee802154/at86rf230.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 80632fc59756..7b051eacb7f1 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -427,7 +427,7 @@ at86rf230_reg_precious(struct device *dev, unsigned int reg)
 	}
 }
 
-static struct regmap_config at86rf230_regmap_spi_config = {
+static const struct regmap_config at86rf230_regmap_spi_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.write_flag_mask = CMD_REG | CMD_WRITE,
-- 
1.9.1

