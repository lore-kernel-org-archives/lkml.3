Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3IJMvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:51:38 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:47002 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3IJMuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:50:22 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 35/38] iio: gyro-core: st: Give some indication if device probing was successful
Date: Tue, 10 Sep 2013 13:49:36 +0100
Message-Id: <1378817379-8238-36-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment the driver is silent in some error cases and if successful.
Prior to this patch there was no clear way to know if the driver succeeded
or not without looking deep into sysfs.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/gyro/st_gyro_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/gyro/st_gyro_core.c b/drivers/iio/gyro/st_gyro_core.c
index 09e24f9..e93b94c 100644
--- a/drivers/iio/gyro/st_gyro_core.c
+++ b/drivers/iio/gyro/st_gyro_core.c
@@ -345,6 +345,9 @@ int st_gyro_common_probe(struct iio_dev *indio_dev,
 	if (err && irq > 0)
 		goto st_gyro_device_register_error;
 
+	if (!err)
+		dev_info(&indio_dev->dev, "Successfully registered\n");
+
 	return err;
 
 st_gyro_device_register_error:
-- 
1.8.1.2

