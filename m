Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbbAEJIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:08:41 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39513 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbbAEJBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:45 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-5c-54aa52f79420
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: [PATCH 12/14] mfd: tps65218: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:01:31 +0100
Message-id: <1420448493-9355-12-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t/xa7rfg1aFGFxZI2vx+oWhxf2vRxkt
	Lu+aw2Yxe0k/i8XpblaL/Ve8HNg8vn2dxOJx59oeNo95JwM9+rasYvT4vEkugDWKyyYlNSez
	LLVI3y6BK+N3Tx9jwXm2ikuTnzE2MJ5m7WLk5JAQMJG40H2AGcIWk7hwbz1bFyMXh5DAUkaJ
	Q0umM0E4fUwSJ88fZQOpYhMwlti8fAmYLSKQJfFj2mqWLkYODmaBQomWh1EgYWEBZ4kT254x
	gdgsAqoSTy5vYQGxeQXcJc4d38ECsUxO4uSxyawgrZxA8duPI0FMIQE3iX9vEyYw8i5gZFjF
	KJpamlxQnJSea6hXnJhbXJqXrpecn7uJERI+X3YwLj5mdYhRgINRiYfX48TKECHWxLLiytxD
	jBIczEoivOtuAYV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwxn7/PONM0hGX1/8mdP1Yfm6J0lzm
	rStCL360mH0y4nt3v/SKvQUNXtm78qT2zFs049OvDyXXXh1Lu2G3e3XWo4c2yn0FnbXbtRhe
	aoa/64vnZj9lG9nQFnvrltHqRp2PnU2n1hzvfnYzdIUgr2zLy8dzJeyn/PuTICRxMlaj8Lqp
	aGubzBqfFCWW4oxEQy3mouJEAExwnTH9AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
---
 drivers/mfd/tps65218.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65218.c b/drivers/mfd/tps65218.c
index 0d256cb002eb..b019b3198afe 100644
--- a/drivers/mfd/tps65218.c
+++ b/drivers/mfd/tps65218.c
@@ -125,7 +125,7 @@ int tps65218_clear_bits(struct tps65218 *tps, unsigned int reg,
 }
 EXPORT_SYMBOL_GPL(tps65218_clear_bits);
 
-static struct regmap_config tps65218_regmap_config = {
+static const struct regmap_config tps65218_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.cache_type = REGCACHE_RBTREE,
-- 
1.9.1

