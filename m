Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbbAEI6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:58:40 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32065 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbbAEI6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:58:03 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-2b-54aa5219c553
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] hwmon: nct7802: Constify struct regmap_config
Date: Mon, 05 Jan 2015 09:57:55 +0100
Message-id: <1420448275-8154-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMJMWRmVeSWpSXmKPExsVy+t/xy7qSQatCDC5dFLZYevcTm8XrF4YW
	l3fNYbN4svAMk8WdaXvZHFg9Hkzczeax83sDu0ffllWMHptPV3t83iQXwBrFZZOSmpNZllqk
	b5fAlXHs7Tf2gplsFS+/HWJsYJzC2sXIySEhYCJxrvM4I4QtJnHh3nq2LkYuDiGBpYwSmz6/
	YIVw+pgkLh08zgZSxSZgLLF5+RKwKhGBJkaJvZ0LwBLMAoYSP9/9YQexhQXsJCa0LQdbwSKg
	KnH21BWwOK+Am8SvrstsEOvkJE4em8w6gZF7ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95Pzc
	TYyQgPiyg3HxMatDjAIcjEo8vB4nVoYIsSaWFVfmHmKU4GBWEuFddwsoxJuSWFmVWpQfX1Sa
	k1p8iJGJg1OqgdFC9GR5wofaP4VLdnhZrpof/jpM9uWanMYdP47Pu5IXue2IgP/8Ry+lrfSk
	r7zfVB7tE3ZxydEYzzs5q55V1HJKBeSe/idj26u76N3KhYViGt6ljH4fOCdKPFbsmSIjeV9O
	cKXrnv9mDcJVIda5rkFuWYUzfbeGpbH8u3fK9tiSU1kOr3K+iyqxFGckGmoxFxUnAgDkz2Hr
	5gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/hwmon/nct7802.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/nct7802.c b/drivers/hwmon/nct7802.c
index ec5678289e4a..55765790907b 100644
--- a/drivers/hwmon/nct7802.c
+++ b/drivers/hwmon/nct7802.c
@@ -779,7 +779,7 @@ static bool nct7802_regmap_is_volatile(struct device *dev, unsigned int reg)
 	return reg != REG_BANK && reg <= 0x20;
 }
 
-static struct regmap_config nct7802_regmap_config = {
+static const struct regmap_config nct7802_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.cache_type = REGCACHE_RBTREE,
-- 
1.9.1

