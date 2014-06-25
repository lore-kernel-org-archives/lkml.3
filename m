Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbaFYOVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:21:23 -0400
Received: from w-smtp-out-7.wedos.net ([46.28.106.5]:55749 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756886AbaFYOVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:21:22 -0400
Date: Wed, 25 Jun 2014 16:21:21 +0200
From: Josef Gajdusek <atx@atx.name>
To: lm-sensors@lm-sensors.org
Cc: jdelvare@suse.de, linux@roeck-us.net, linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: (emc1403) Fix missing 'select REGMAP_I2C' in Kconfig
Message-ID: <20140625142121.GA14873@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 4cab259f, the emc1403 driver was converted to use regmap but the 
necessary Kconfig option was not added.

Signed-off-by: Josef Gajdusek <atx@atx.name>
---
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 08531a1..bdb90a0 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1176,6 +1176,7 @@ config SENSORS_DME1737
 config SENSORS_EMC1403
 	tristate "SMSC EMC1403/23 thermal sensor"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the SMSC EMC1403/23
 	  temperature monitoring chip.

