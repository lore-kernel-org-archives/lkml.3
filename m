Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbbAEJJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:09:11 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39513 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbbAEJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:44 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-4f-54aa52f7819b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 07/14] mfd: mc13xxx: i2c/spi: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:01:26 +0100
Message-id: <1420448493-9355-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xa7rfg1aFGFxdwG/x+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aWozNZC/5w
	Vtydeoe5gXEbRxcjJ4eEgIlEw4NfTBC2mMSFe+vZQGwhgaWMEvsv63cxcgHZfUwS+xpOsoAk
	2ASMJTYvXwJWJCKQJfFj2mqwOLOAocTPd3/YQWxhAW+Jhp03mEFsFgFVicWr14LZvAJuEsv/
	zGeBWCYncfLYZNYuRg4OTgF3iduPI0FMIaCSf28TJjDyLmBkWMUomlqaXFCclJ5rpFecmFtc
	mpeul5yfu4kREiJfdzAuPWZ1iFGAg1GJh9fjxMoQIdbEsuLK3EOMEhzMSiK8624BhXhTEiur
	Uovy44tKc1KLDzEycXBKNTBm/2VZ2vOw4/ykBv+wLcubHTc5STZOm/Q19M+npGfrLthNUzfP
	7TIUSnbhn5fgoHr345toH4XDccLPp7j7sst+Yz1/dHrbQrU5U2OEcjf8ucnxyOliqu+lgJz1
	Il3KndfCCy93xRycptf4v2B95EFeA50DjA3JTj6i22ed6Vup8t7H93nnLXUlluKMREMt5qLi
	RAAeRkhp7wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/mc13xxx-i2c.c | 2 +-
 drivers/mfd/mc13xxx-spi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/mc13xxx-i2c.c b/drivers/mfd/mc13xxx-i2c.c
index ae3addb153a2..68b844811566 100644
--- a/drivers/mfd/mc13xxx-i2c.c
+++ b/drivers/mfd/mc13xxx-i2c.c
@@ -46,7 +46,7 @@ static const struct of_device_id mc13xxx_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
 
-static struct regmap_config mc13xxx_regmap_i2c_config = {
+static const struct regmap_config mc13xxx_regmap_i2c_config = {
 	.reg_bits = 8,
 	.val_bits = 24,
 
diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 702925e242c9..58a170e45d88 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -48,7 +48,7 @@ static const struct of_device_id mc13xxx_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, mc13xxx_dt_ids);
 
-static struct regmap_config mc13xxx_regmap_spi_config = {
+static const struct regmap_config mc13xxx_regmap_spi_config = {
 	.reg_bits = 7,
 	.pad_bits = 1,
 	.val_bits = 24,
-- 
1.9.1

