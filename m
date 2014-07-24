Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbaGXMrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:47:46 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:54665 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758527AbaGXMro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:47:44 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH v3 4/4] mfd: pm8921: rename pm8921-core driver
Date: Thu, 24 Jul 2014 15:45:21 +0300
Message-Id: <1406205921-7452-5-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1406205921-7452-1-git-send-email-svarbanov@mm-sol.com>
References: <1406205921-7452-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pm8921-core driver presently supports pm8921 and pm8058
Qualcomm PMICs.  To avoid confusion with new generation PMICs
(like pm8941) rename the pm8921-core driver to more
appropriate name pm8xxx-ssbi, which reflects better that
those chips use SSBI interface.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/Kconfig                          |   14 +++++-----
 drivers/mfd/Makefile                         |    2 +-
 drivers/mfd/{pm8921-core.c => pm8xxx-ssbi.c} |   38 +++++++++++++-------------
 3 files changed, 27 insertions(+), 27 deletions(-)
 rename drivers/mfd/{pm8921-core.c => pm8xxx-ssbi.c} (92%)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 122e2d9..884bc32 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -507,8 +507,8 @@ config UCB1400_CORE
 config MFD_PM8XXX
 	tristate
 
-config MFD_PM8921_CORE
-	tristate "Qualcomm PM8921 PMIC chip"
+config MFD_PM8XXX_SSBI
+	tristate "Qualcomm PM8XXX SSBI PMICs"
 	depends on (ARM || HEXAGON)
 	select IRQ_DOMAIN
 	select MFD_CORE
@@ -516,13 +516,13 @@ config MFD_PM8921_CORE
 	select REGMAP
 	help
 	  If you say yes to this option, support will be included for the
-	  built-in PM8921 PMIC chip.
+	  built-in PM8921 and PM8058 PMIC chips.
 
-	  This is required if your board has a PM8921 and uses its features,
-	  such as: MPPs, GPIOs, regulators, interrupts, and PWM.
+	  This is required if your board has a PM8921 or PM8058 and uses
+	  its features, such as: MPPs, GPIOs, regulators, interrupts, and PWM.
 
-	  Say M here if you want to include support for PM8921 chip as a module.
-	  This will build a module called "pm8921-core".
+	  Say M here if you want to include support for PM8921 or PM8058 chip
+	  as a module. This will build a module called "pm8xxx-ssbi".
 
 config MFD_PM8XXX_SPMI
 	tristate "Qualcomm PM8XXX SPMI PMICs"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 93d82cc..d332085 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -152,7 +152,7 @@ obj-$(CONFIG_MFD_SI476X_CORE)	+= si476x-core.o
 
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o omap-usb-tll.o
-obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
+obj-$(CONFIG_MFD_PM8XXX_SSBI) 	+= pm8xxx-ssbi.o ssbi.o
 obj-$(CONFIG_MFD_PM8XXX_SPMI)	+= pm8xxx-spmi.o
 obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8xxx-ssbi.c
similarity index 92%
rename from drivers/mfd/pm8921-core.c
rename to drivers/mfd/pm8xxx-ssbi.c
index 9595138..102d7fb 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8xxx-ssbi.c
@@ -277,14 +277,14 @@ static const struct regmap_config ssbi_regmap_config = {
 	.reg_write = ssbi_reg_write
 };
 
-static const struct of_device_id pm8921_id_table[] = {
+static const struct of_device_id pm8xxx_id_table[] = {
 	{ .compatible = "qcom,pm8058", },
 	{ .compatible = "qcom,pm8921", },
 	{ }
 };
-MODULE_DEVICE_TABLE(of, pm8921_id_table);
+MODULE_DEVICE_TABLE(of, pm8xxx_id_table);
 
-static int pm8921_probe(struct platform_device *pdev)
+static int pm8xxx_probe(struct platform_device *pdev)
 {
 	struct regmap *regmap;
 	int irq, rc;
@@ -354,18 +354,18 @@ static int pm8921_probe(struct platform_device *pdev)
 	return rc;
 }
 
-static int pm8921_remove_child(struct device *dev, void *unused)
+static int pm8xxx_remove_child(struct device *dev, void *unused)
 {
 	platform_device_unregister(to_platform_device(dev));
 	return 0;
 }
 
-static int pm8921_remove(struct platform_device *pdev)
+static int pm8xxx_remove(struct platform_device *pdev)
 {
 	int irq = platform_get_irq(pdev, 0);
 	struct pm_irq_chip *chip = platform_get_drvdata(pdev);
 
-	device_for_each_child(&pdev->dev, NULL, pm8921_remove_child);
+	device_for_each_child(&pdev->dev, NULL, pm8xxx_remove_child);
 	irq_set_chained_handler(irq, NULL);
 	irq_set_handler_data(irq, NULL);
 	irq_domain_remove(chip->irqdomain);
@@ -373,29 +373,29 @@ static int pm8921_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver pm8921_driver = {
-	.probe		= pm8921_probe,
-	.remove		= pm8921_remove,
+static struct platform_driver pm8xxx_driver = {
+	.probe		= pm8xxx_probe,
+	.remove		= pm8xxx_remove,
 	.driver		= {
-		.name	= "pm8921-core",
+		.name	= "pm8xxx-ssbi",
 		.owner	= THIS_MODULE,
-		.of_match_table = pm8921_id_table,
+		.of_match_table = pm8xxx_id_table,
 	},
 };
 
-static int __init pm8921_init(void)
+static int __init pm8xxx_init(void)
 {
-	return platform_driver_register(&pm8921_driver);
+	return platform_driver_register(&pm8xxx_driver);
 }
-subsys_initcall(pm8921_init);
+subsys_initcall(pm8xxx_init);
 
-static void __exit pm8921_exit(void)
+static void __exit pm8xxx_exit(void)
 {
-	platform_driver_unregister(&pm8921_driver);
+	platform_driver_unregister(&pm8xxx_driver);
 }
-module_exit(pm8921_exit);
+module_exit(pm8xxx_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("PMIC 8921 core driver");
+MODULE_DESCRIPTION("PMIC PM8XXX SSBI driver");
 MODULE_VERSION("1.0");
-MODULE_ALIAS("platform:pm8921-core");
+MODULE_ALIAS("platform:pm8xxx-ssbi");
-- 
1.7.0.4

