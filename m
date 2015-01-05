Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbbAEJLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:11:54 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32293 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbbAEJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:44 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-50-54aa52f52057
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 06/14] mfd: max77686: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:01:25 +0100
Message-id: <1420448493-9355-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJMWRmVeSWpSXmKPExsVy+t/xa7pfg1aFGMxcrGrx+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bCCVfZCv5y
	VPTsvsDWwLibvYuRk0NCwETiwKkWJghbTOLCvfVsXYxcHEICSxklHnZsZoJw+pgk9jWcZAGp
	YhMwlti8fAkbiC0ikCXxY9pqsDizgKHEz3d/wKYKCzhLvL9+hxHEZhFQlTi25zrYBl4BN4m+
	LfOhNstJnDw2mbWLkYODU8Bd4vbjSBBTCKjk39uECYy8CxgZVjGKppYmFxQnpeca6hUn5haX
	5qXrJefnbmKEBMmXHYyLj1kdYhTgYFTi4fU4sTJEiDWxrLgy9xCjBAezkgjvultAId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYycbfbCd5nmfFb/8mjrHT1N1bWskz8cmH5vs+4qVQ7uyKpnhRfW
	WRX0Sl71z7j+XOh1stxkS2/xY+c3zzt/zvFuWcbUr8GnuJ6YK+yTYzn4aX/JV7267ueXF3q/
	7n1T6BQ27fNxS3Ezv9O7uoKn3n9nU/T3UYx7m0a211Lbwx4XmkO4Lk8JZfygxFKckWioxVxU
	nAgAzzUPC/ABAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max77686.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 929795eae9fc..2b2f2ccda523 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -111,17 +111,17 @@ static bool max77802_is_volatile_reg(struct device *dev, unsigned int reg)
 		max77802_rtc_is_volatile_reg(dev, reg));
 }
 
-static struct regmap_config max77686_regmap_config = {
+static const struct regmap_config max77686_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
 
-static struct regmap_config max77686_rtc_regmap_config = {
+static const struct regmap_config max77686_rtc_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
 
-static struct regmap_config max77802_regmap_config = {
+static const struct regmap_config max77802_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.writeable_reg = max77802_is_accessible_reg,
-- 
1.9.1

