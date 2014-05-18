Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaERNt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 09:49:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbaERNtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 09:49:32 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/3] regulator/axp20x: Call mfd_register_supply_aliases
Date: Sun, 18 May 2014 15:49:12 +0200
Message-Id: <1400420953-20705-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1400420953-20705-1-git-send-email-hdegoede@redhat.com>
References: <1400420953-20705-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mfd-core no longer registers the supply aliases, instead the platform
driver probe method must now call mfd_register_supply_aliases().

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/regulator/axp20x-regulator.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index 78a29e6..ff35758 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/mfd/axp20x.h>
+#include <linux/mfd/core.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/of_regulator.h>
 
@@ -237,6 +238,10 @@ static int axp20x_regulator_probe(struct platform_device *pdev)
 	int ret, i;
 	u32 workmode;
 
+	ret = mfd_register_supply_aliases(pdev);
+	if (ret)
+		return ret;
+
 	ret = axp20x_regulator_parse_dt(pdev);
 	if (ret)
 		return ret;
-- 
1.9.0

