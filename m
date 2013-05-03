Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab3ECOVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:21:52 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:62205 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762307Ab3ECOVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:21:51 -0400
Date: Fri, 3 May 2013 15:21:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 4/4 v2] staging: =?utf-8?Q?ste=5Frm?=
 =?utf-8?Q?i4=3A_Suppress_'ignoring_return_value_of_=E2=80=98regulator=5Fe?=
 =?utf-8?Q?nable=28=29'?= warning
Message-ID: <20130503142146.GO24153@gmail.com>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
 <1367509690-24022-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367509690-24022-5-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
Acked-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index fe667dd..386362c 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -1087,7 +1087,11 @@ static int synaptics_rmi4_resume(struct device *dev)
 	unsigned char intr_status;
 	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
 
-	regulator_enable(rmi4_data->regulator);
+	retval = regulator_enable(rmi4_data->regulator);
+	if (retval) {
+		dev_err(dev, "Regulator enable failed (%d)\n", retval);
+		return retval;
+	}
 
 	enable_irq(rmi4_data->i2c_client->irq);
 	rmi4_data->touch_stopped = false;
