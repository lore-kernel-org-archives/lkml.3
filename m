Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783Ab3CLW4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:56:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933760Ab3CLWoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 19/40] hwmon: (sht15) Check return value of regulator_enable()
Date: Tue, 12 Mar 2013 15:43:40 -0700
Message-Id: <20130312223213.582017820@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223211.492954675@linuxfoundation.org>
References: <20130312223211.492954675@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 3e78080f81481aa8340374d5a37ae033c1cf4272 upstream.

Not having power is a pretty serious error so check that we are able to
enable the supply and error out if we can't.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>

---
 drivers/hwmon/sht15.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -926,7 +926,13 @@ static int __devinit sht15_probe(struct
 		if (voltage)
 			data->supply_uV = voltage;
 
-		regulator_enable(data->reg);
+		ret = regulator_enable(data->reg);
+		if (ret != 0) {
+			dev_err(&pdev->dev,
+				"failed to enable regulator: %d\n", ret);
+			return ret;
+		}
+
 		/*
 		 * Setup a notifier block to update this if another device
 		 * causes the voltage to change


