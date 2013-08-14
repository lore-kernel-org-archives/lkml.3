Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab3HNI2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:28:39 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:45911 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756769Ab3HNI2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:28:37 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 1/4] mfd: 88pm800: Fix the bug that pdata may be NULL
Date: Wed, 14 Aug 2013 04:28:47 -0400
Message-ID: <1376468930-9794-2-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
References: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User pass platform data to device, and platform data may be
NULL. Add the check for pdata.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/mfd/88pm800.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 6c95483..d4d272f 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -333,9 +333,11 @@ static int device_rtc_init(struct pm80x_chip *chip,
 {
 	int ret;
 
-	rtc_devs[0].platform_data = pdata->rtc;
-	rtc_devs[0].pdata_size =
-			pdata->rtc ? sizeof(struct pm80x_rtc_pdata) : 0;
+	if (pdata) {
+		rtc_devs[0].platform_data = pdata->rtc;
+		rtc_devs[0].pdata_size =
+				pdata->rtc ? sizeof(struct pm80x_rtc_pdata) : 0;
+	}
 	ret = mfd_add_devices(chip->dev, 0, &rtc_devs[0],
 			      ARRAY_SIZE(rtc_devs), NULL, 0, NULL);
 	if (ret) {
@@ -578,7 +580,7 @@ static int pm800_probe(struct i2c_client *client,
 		goto err_device_init;
 	}
 
-	if (pdata->plat_config)
+	if (pdata && pdata->plat_config)
 		pdata->plat_config(chip, pdata);
 
 	return 0;
-- 
1.7.4.1

