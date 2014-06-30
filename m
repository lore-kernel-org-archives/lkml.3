Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaF3O0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:26:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbaF3O03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:26:29 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH resend v2 2/3] regulator/axp20x: Call mfd_register_supply_aliases
Date: Mon, 30 Jun 2014 16:26:08 +0200
Message-Id: <1404138369-23907-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1404138369-23907-1-git-send-email-hdegoede@redhat.com>
References: <1404138369-23907-1-git-send-email-hdegoede@redhat.com>
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
index 004aadb..0e5ff8a 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/mfd/axp20x.h>
+#include <linux/mfd/core.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/of_regulator.h>
 
@@ -238,6 +239,10 @@ static int axp20x_regulator_probe(struct platform_device *pdev)
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
2.0.0

