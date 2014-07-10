Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaGJLq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:46:57 -0400
Received: from sauhun.de ([89.238.76.85]:57093 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbaGJLqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:46:54 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/16] i2c: i2c-mv64xxx: Drop class based scanning to improve bootup time
Date: Thu, 10 Jul 2014 13:46:27 +0200
Message-Id: <1404992799-3705-8-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
References: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has been flagged to drop class based instantiation. The removal
improves boot-up time and is unneeded for embedded controllers. Users have been
warned to switch for some time now, so we can actually do the removal. Keep the
DEPRECATED flag, so the core can inform users that the behaviour finally
changed now. After another transition period, this flag can go, too.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-mv64xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 9f4b775e2e39..6dc5ded86f62 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -863,7 +863,7 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 	drv_data->adapter.dev.parent = &pd->dev;
 	drv_data->adapter.algo = &mv64xxx_i2c_algo;
 	drv_data->adapter.owner = THIS_MODULE;
-	drv_data->adapter.class = I2C_CLASS_HWMON | I2C_CLASS_SPD | I2C_CLASS_DEPRECATED;
+	drv_data->adapter.class = I2C_CLASS_DEPRECATED;
 	drv_data->adapter.nr = pd->id;
 	drv_data->adapter.dev.of_node = pd->dev.of_node;
 	platform_set_drvdata(pd, drv_data);
-- 
2.0.0

