Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3IJMw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:52:28 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:56260 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3IJMuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:50:20 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 33/38] iio: accel-core: st: Give some indication if device probing was successful
Date: Tue, 10 Sep 2013 13:49:34 +0100
Message-Id: <1378817379-8238-34-git-send-email-lee.jones@linaro.org>
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
 drivers/iio/accel/st_accel_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/accel/st_accel_core.c b/drivers/iio/accel/st_accel_core.c
index 03a2b6b..a003f3b 100644
--- a/drivers/iio/accel/st_accel_core.c
+++ b/drivers/iio/accel/st_accel_core.c
@@ -496,6 +496,9 @@ int st_accel_common_probe(struct iio_dev *indio_dev,
 	if (err && irq > 0)
 		goto st_accel_device_register_error;
 
+	if (!err)
+		dev_info(&indio_dev->dev, "Successfully registered\n");
+
 	return err;
 
 st_accel_device_register_error:
-- 
1.8.1.2

