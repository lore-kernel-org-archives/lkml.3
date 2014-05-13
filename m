Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbaEMK65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:58:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64293 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaEMK6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:58:55 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-52-5371faecc5dd
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 01/16] mfd: max14577: Make mfd_cell array const
Date: Tue, 13 May 2014 12:58:38 +0200
Message-id: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t/xy7pvfhUGG9xfZGrx+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8b6JY+YCh5y
	Viz48Jq1gbGZo4uRk0NCwERiy4clzBC2mMSFe+vZuhi5OIQEljJKfPm0nxHC6WOS2LnxFCNI
	FZuAscTm5UvYQGwRgSyJH9NWs4DYzAKGEj/f/WEHsYUF7CVudM9nBbFZBFQljm24AmbzCrhL
	7Nn6jQVim5zEyWOTWScwci9gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJEeL5rzsYlx6z
	OsQowMGoxMPrwVwQLMSaWFZcmXuIUYKDWUmE1/1TYbAQb0piZVVqUX58UWlOavEhRiYOTqkG
	xssf4gxTFYMfFMnWnjl2YllA+Nv1to9PH/zw+8KUpe4WLtfPLBPQtH+lyxv/+PdsWZ4XM7bv
	sdq4V+TwK8XZgR9+f/bjzmHoqvedv/U1+74VaiesfqZL/0iYtVZF5f9ho8xlfeEbxLdMnfJ4
	gqO7xLbP5yvqjyqsEjdf4jX/W0fBrF9+m2Umf1dVYinOSDTUYi4qTgQAS8Dt49oBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mfd_add_devices() expects array of struct mfd_cell to be const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max14577.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 484d372a4892..39b658d6497b 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -26,7 +26,7 @@
 #include <linux/mfd/max14577.h>
 #include <linux/mfd/max14577-private.h>
 
-static struct mfd_cell max14577_devs[] = {
+static const struct mfd_cell max14577_devs[] = {
 	{
 		.name = "max14577-muic",
 		.of_compatible = "maxim,max14577-muic",
@@ -38,7 +38,7 @@ static struct mfd_cell max14577_devs[] = {
 	{ .name = "max14577-charger", },
 };
 
-static struct mfd_cell max77836_devs[] = {
+static const struct mfd_cell max77836_devs[] = {
 	{
 		.name = "max77836-muic",
 		.of_compatible = "maxim,max77836-muic",
@@ -292,7 +292,7 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	struct device_node *np = i2c->dev.of_node;
 	int ret = 0;
 	const struct regmap_irq_chip *irq_chip;
-	struct mfd_cell *mfd_devs;
+	const struct mfd_cell *mfd_devs;
 	unsigned int mfd_devs_size;
 	int irq_flags;
 
-- 
1.9.1

