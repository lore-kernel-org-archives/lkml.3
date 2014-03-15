Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaCOBY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 21:24:57 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62889 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaCOBY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 21:24:56 -0400
Message-ID: <1394846690.8939.1.camel@phoenix>
Subject: [PATCH] mfd: bcm590xx: Fix type argument for module device table
From: Axel Lin <axel.lin@ingics.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Matt Porter <mporter@linaro.org>, Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>, linux-kernel@vger.kernel.org
Date: Sat, 15 Mar 2014 09:24:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build error.

FATAL: drivers/mfd/bcm590xx: sizeof(struct i2c_device_id)=24 is not a modulo of the size of section __mod_i2c_device_table=392.
Fix definition of struct i2c_device_id in mod_devicetable.h
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/bcm590xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/bcm590xx.c b/drivers/mfd/bcm590xx.c
index 926a57e..e9a33c7 100644
--- a/drivers/mfd/bcm590xx.c
+++ b/drivers/mfd/bcm590xx.c
@@ -68,7 +68,7 @@ static const struct of_device_id bcm590xx_of_match[] = {
 	{ .compatible = "brcm,bcm59056" },
 	{ }
 };
-MODULE_DEVICE_TABLE(i2c, bcm590xx_of_match);
+MODULE_DEVICE_TABLE(of, bcm590xx_of_match);
 
 static const struct i2c_device_id bcm590xx_i2c_id[] = {
 	{ "bcm59056" },
-- 
1.8.1.2



