Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3A2Hij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:38:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37879 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297Ab3A2Hii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:38:38 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <anilkumar@ti.com>, <tony@atomide.com>, <hs@denx.de>,
        <broonie@opensource.wolfsonmicro.com>, <sameo@linux.intel.com>,
        <khilman@deeprootsystems.com>, <nsekhar@ti.com>,
        <linus.walleij@linaro.org>, <linux@arm.linux.org.uk>,
        <rob@landley.net>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <manishv.b@ti.com>
Subject: [PATCH V2 1/6] pinctrl: pinctrl-single: use arch_initcall and module_exit
Date: Tue, 29 Jan 2013 13:08:49 +0530
Message-ID: <1359445134-13323-2-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
References: <1359445134-13323-1-git-send-email-manishv.b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, I2C driver gets probed before pinctrl driver.
To achieve I2C pin muxing via pinctrl driver before I2C
probe get called, register pinctrl driver in arch_initcall.
Also, add module_exit to unregister pinctrl driver.

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
---
:100644 100644 f6a360b... 3a96390... M	drivers/pinctrl/pinctrl-single.c
 drivers/pinctrl/pinctrl-single.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index f6a360b..3a96390 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1089,7 +1089,17 @@ static struct platform_driver pcs_driver = {
 	},
 };
 
-module_platform_driver(pcs_driver);
+static int __init pcs_pinctrl_init(void)
+{
+	return platform_driver_register(&pcs_driver);
+}
+arch_initcall(pcs_pinctrl_init);
+
+static void __exit pcs_pinctrl_exit(void)
+{
+	platform_driver_unregister(&pcs_driver);
+}
+module_exit(pcs_pinctrl_exit);
 
 MODULE_AUTHOR("Tony Lindgren <tony@atomide.com>");
 MODULE_DESCRIPTION("One-register-per-pin type device tree based pinctrl driver");
-- 
1.7.4.1

