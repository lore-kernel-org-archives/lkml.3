Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3FNFXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:23:38 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:55942 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678Ab3FNFXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:23:34 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <yizhang@marvell.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2 5/9] mfd: 88pm800: remove the power and gpadc page addr from platform data
Date: Fri, 14 Jun 2013 01:21:49 -0400
Message-ID: <1371187313-5776-6-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
References: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

88pm800 has two addtional pages - power and gpadc.
The address of the pages depends on the address of 88pm800.
So do not need pass the address of the power and gpadc in
platform data.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/mfd/88pm800.c       |    5 +++--
 include/linux/mfd/88pm80x.h |    2 --
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index d2951d7..6b607ad 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -525,8 +525,9 @@ static int pm800_probe(struct i2c_client *client,
 		goto err_subchip_alloc;
 	}
 
-	subchip->power_page_addr = pdata->power_page_addr;
-	subchip->gpadc_page_addr = pdata->gpadc_page_addr;
+	/* pm800 has 2 addtional pages to support power and gpadc. */
+	subchip->power_page_addr = client->addr + 1;
+	subchip->gpadc_page_addr = client->addr + 2;
 	chip->subchip = subchip;
 
 	ret = pm800_pages_init(chip);
diff --git a/include/linux/mfd/88pm80x.h b/include/linux/mfd/88pm80x.h
index e94537b..023e639 100644
--- a/include/linux/mfd/88pm80x.h
+++ b/include/linux/mfd/88pm80x.h
@@ -309,8 +309,6 @@ struct pm80x_chip {
 
 struct pm80x_platform_data {
 	struct pm80x_rtc_pdata *rtc;
-	unsigned short power_page_addr;	/* power page I2C address */
-	unsigned short gpadc_page_addr;	/* gpadc page I2C address */
 	int irq_mode;		/* Clear interrupt by read/write(0/1) */
 	int batt_det;		/* enable/disable */
 	int (*plat_config)(struct pm80x_chip *chip,
-- 
1.7.4.1

