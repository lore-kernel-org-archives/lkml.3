Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590Ab3EBPst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:48:49 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:62809 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760494Ab3EBPsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:48:47 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 4/4] =?UTF-8?q?staging:=20ste=5Frmi4:=20Suppress=20'ignoring?= =?UTF-8?q?=20return=20value=20of=20=E2=80=98regulator=5Fenable()'=20warning?=
Date: Thu,  2 May 2013 16:48:10 +0100
Message-Id: <1367509690-24022-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c:
        In function ‘synaptics_rmi4_resume’:
drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c:1090:18:
        warning: ignoring return value of ‘regulator_enable’, declared
        with attribute warn_unused_result [-Wunused-result

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index fe667dd..c4d013d 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -1087,7 +1087,9 @@ static int synaptics_rmi4_resume(struct device *dev)
 	unsigned char intr_status;
 	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
 
-	regulator_enable(rmi4_data->regulator);
+	retval = regulator_enable(rmi4_data->regulator);
+	if (retval < 0)
+		return retval;
 
 	enable_irq(rmi4_data->i2c_client->irq);
 	rmi4_data->touch_stopped = false;
-- 
1.7.10.4

