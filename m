Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3IJMu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:50:57 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51475 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3IJMuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:50:24 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 37/38] iio: magn-core: st: Give some indication if device probing was successful
Date: Tue, 10 Sep 2013 13:49:38 +0100
Message-Id: <1378817379-8238-38-git-send-email-lee.jones@linaro.org>
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
 drivers/iio/magnetometer/st_magn_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/magnetometer/st_magn_core.c b/drivers/iio/magnetometer/st_magn_core.c
index c252659..12e7e79 100644
--- a/drivers/iio/magnetometer/st_magn_core.c
+++ b/drivers/iio/magnetometer/st_magn_core.c
@@ -386,6 +386,9 @@ int st_magn_common_probe(struct iio_dev *indio_dev,
 	if (err && irq > 0)
 		goto st_magn_device_register_error;
 
+	if (!err)
+		dev_info(&indio_dev->dev, "Successfully registered\n");
+
 	return err;
 
 st_magn_device_register_error:
-- 
1.8.1.2

