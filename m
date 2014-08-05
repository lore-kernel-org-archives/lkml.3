Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaHEUzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:55:53 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:54710 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751329AbaHEUzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:55:51 -0400
Date: Tue, 5 Aug 2014 22:55:47 +0200
From: Wim Van Sebroeck <wim.vansebroeck@linux-watchdog.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        George Cherian <george.cherian@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sangjung Woo <sangjung.woo@samsung.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [GIT PULL REQUEST] watchdog - v3.17-rc1 merge window
Message-ID: <20140805205547.GK11710@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

It contains the following changes:
* Remove un-necessary checks after platform_get_resource()
* fix watchdog api documentation typo's
* imx2_wdt: adds big endianness support
* Move restart code to the sunxi watchdog driver

This will update the following files:

 Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt |    5 ++
 Documentation/watchdog/watchdog-api.txt                    |    2 
 drivers/watchdog/dw_wdt.c                                  |    3 -
 drivers/watchdog/imx2_wdt.c                                |    7 +++
 drivers/watchdog/lantiq_wdt.c                              |    5 --
 drivers/watchdog/shwdt.c                                   |    5 --
 drivers/watchdog/sunxi_wdt.c                               |   29 +++++++++++++
 7 files changed, 43 insertions(+), 13 deletions(-)

with these Changes:

commit 440e96bc770eb98b17a763defb9641c77f9a7755
Author: Maxime Ripard <maxime.ripard@free-electrons.com>
Date:   Tue May 6 21:44:19 2014 -0500

    wdt: sunxi: Move restart code to the watchdog driver
    
    Most of the watchdog code is duplicated between the machine restart code and
    the watchdog driver. Add the restart hook to the watchdog driver, to be able to
    remove it from the machine code eventually.
    
    Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 5be876cf7e6feeca6dc2bbdb3f1fa0167e13621d
Author: Sangjung Woo <sangjung.woo@samsung.com>
Date:   Wed Jul 30 09:56:21 2014 +0900

    Documentation: fix two typos in watchdog-api.txt
    
    This patch changes 'go of' to 'go off' and 'pretimout' to
    'pretimeout'.
    
    Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
    Acked-by: Randy Dunlap <rdunlap@infradead.org>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit f728f4bfc495a588abda4661c09595112677be25
Author: Xiubo Li <Li.Xiubo@freescale.com>
Date:   Tue Jun 3 10:45:14 2014 +0800

    watchdog: imx2_wdt: adds big endianness support.
    
    This watchdog driver will be working on IMX2+, Vybrid, LS1, LS2+
    platforms, and will be in different endianness mode in those SoCs:
    
        SoCs       WDT endian mode
    ------------------------------------
        IMX2+           LE
        Vybird          LE
        LS1             BE
        LS2             LE
    
    Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 2cdf25bb574c20efde0340ffa90f08d1609ef97c
Author: George Cherian <george.cherian@ti.com>
Date:   Tue Jun 10 10:10:08 2014 +0530

    watchdog: shwdt: Remove the unnecessary check of resource after platform_get_resource()
    
    devm_ioremap_resource check for a valid resource. Remove the unnecessary check.
    Also group platform_get_resource and devm_ioremap_resource together for better
    readability.
    
    Signed-off-by: George Cherian <george.cherian@ti.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 37f152915fba723de7e5bf43ade3bd971977b724
Author: George Cherian <george.cherian@ti.com>
Date:   Tue Jun 10 10:10:07 2014 +0530

    watchdog: lantiq_wdt: Remove the un-necessary check of resource after platform_get_resource()
    
    devm_ioremap_resource() checks for valid resource.
    Remove the un-necessary check after platform_get_resource().
    
    Signed-off-by: George Cherian <george.cherian@ti.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 4bba08dda402172727c14d8e363a3dda38293548
Author: George Cherian <george.cherian@ti.com>
Date:   Tue Jun 10 10:10:06 2014 +0530

    watchdog: dw_wdt: Remove the un-necessary check after platform_get_resource()
    
    devm_ioremap_resource() checks for valid resource.
    Remove the un-necessary check after platform_get_resource().
    
    Signed-off-by: George Cherian <george.cherian@ti.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
index 2144af1..e52ba2d 100644
--- a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
@@ -5,10 +5,15 @@ Required properties:
 - reg : Should contain WDT registers location and length
 - interrupts : Should contain WDT interrupt
 
+Optional property:
+- big-endian: If present the watchdog device's registers are implemented
+  in big endian mode, otherwise in little mode.
+
 Examples:
 
 wdt@73f98000 {
 	compatible = "fsl,imx51-wdt", "fsl,imx21-wdt";
 	reg = <0x73f98000 0x4000>;
 	interrupts = <58>;
+	big-endian;
 };
diff --git a/Documentation/watchdog/watchdog-api.txt b/Documentation/watchdog/watchdog-api.txt
index eb7132e..b3a701f 100644
--- a/Documentation/watchdog/watchdog-api.txt
+++ b/Documentation/watchdog/watchdog-api.txt
@@ -118,7 +118,7 @@ resets.
 Note that the pretimeout is the number of seconds before the time
 when the timeout will go off.  It is not the number of seconds until
 the pretimeout.  So, for instance, if you set the timeout to 60 seconds
-and the pretimeout to 10 seconds, the pretimout will go of in 50
+and the pretimeout to 10 seconds, the pretimeout will go off in 50
 seconds.  Setting a pretimeout to zero disables it.
 
 There is also a get function for getting the pretimeout:
diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index ee4f86b..9f21029 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -296,9 +296,6 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	int ret;
 	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	if (!mem)
-		return -EINVAL;
-
 	dw_wdt.regs = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(dw_wdt.regs))
 		return PTR_ERR(dw_wdt.regs);
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 9d4874f..68c3d37 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -28,6 +28,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/timer.h>
@@ -190,10 +191,12 @@ static struct regmap_config imx2_wdt_regmap_config = {
 
 static int __init imx2_wdt_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct imx2_wdt_device *wdev;
 	struct watchdog_device *wdog;
 	struct resource *res;
 	void __iomem *base;
+	bool big_endian;
 	int ret;
 	u32 val;
 
@@ -201,6 +204,10 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 	if (!wdev)
 		return -ENOMEM;
 
+	big_endian = of_property_read_bool(np, "big-endian");
+	if (big_endian)
+		imx2_wdt_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
diff --git a/drivers/watchdog/lantiq_wdt.c b/drivers/watchdog/lantiq_wdt.c
index 3b3148c..021e84e 100644
--- a/drivers/watchdog/lantiq_wdt.c
+++ b/drivers/watchdog/lantiq_wdt.c
@@ -192,11 +192,6 @@ ltq_wdt_probe(struct platform_device *pdev)
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct clk *clk;
 
-	if (!res) {
-		dev_err(&pdev->dev, "cannot obtain I/O memory region");
-		return -ENOENT;
-	}
-
 	ltq_wdt_membase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(ltq_wdt_membase))
 		return PTR_ERR(ltq_wdt_membase);
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index 061756e..fa89bb3 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -230,10 +230,6 @@ static int sh_wdt_probe(struct platform_device *pdev)
 	if (pdev->id != -1)
 		return -EINVAL;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (unlikely(!res))
-		return -EINVAL;
-
 	wdt = devm_kzalloc(&pdev->dev, sizeof(struct sh_wdt), GFP_KERNEL);
 	if (unlikely(!wdt))
 		return -ENOMEM;
@@ -249,6 +245,7 @@ static int sh_wdt_probe(struct platform_device *pdev)
 		wdt->clk = NULL;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	wdt->base = devm_ioremap_resource(wdt->dev, res);
 	if (IS_ERR(wdt->base))
 		return PTR_ERR(wdt->base);
diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
index 693b9d2..60deb9d 100644
--- a/drivers/watchdog/sunxi_wdt.c
+++ b/drivers/watchdog/sunxi_wdt.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/io.h>
@@ -22,9 +23,12 @@
 #include <linux/moduleparam.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
 
+#include <asm/system_misc.h>
+
 #define WDT_MAX_TIMEOUT         16
 #define WDT_MIN_TIMEOUT         1
 #define WDT_MODE_TIMEOUT(n)     ((n) << 3)
@@ -70,6 +74,26 @@ static const int wdt_timeout_map[] = {
 	[16] = 0xB, /* 16s */
 };
 
+static void __iomem *reboot_wdt_base;
+
+static void sun4i_wdt_restart(enum reboot_mode mode, const char *cmd)
+{
+	/* Enable timer and set reset bit in the watchdog */
+	writel(WDT_MODE_EN | WDT_MODE_RST_EN, reboot_wdt_base + WDT_MODE);
+
+	/*
+	 * Restart the watchdog. The default (and lowest) interval
+	 * value for the watchdog is 0.5s.
+	 */
+	writel(WDT_CTRL_RELOAD, reboot_wdt_base + WDT_CTRL);
+
+	while (1) {
+		mdelay(5);
+		writel(WDT_MODE_EN | WDT_MODE_RST_EN,
+		       reboot_wdt_base + WDT_MODE);
+	}
+}
+
 static int sunxi_wdt_ping(struct watchdog_device *wdt_dev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
@@ -181,6 +205,9 @@ static int sunxi_wdt_probe(struct platform_device *pdev)
 	if (unlikely(err))
 		return err;
 
+	reboot_wdt_base = sunxi_wdt->wdt_base;
+	arm_pm_restart = sun4i_wdt_restart;
+
 	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)",
 			sunxi_wdt->wdt_dev.timeout, nowayout);
 
@@ -191,6 +218,8 @@ static int sunxi_wdt_remove(struct platform_device *pdev)
 {
 	struct sunxi_wdt_dev *sunxi_wdt = platform_get_drvdata(pdev);
 
+	arm_pm_restart = NULL;
+
 	watchdog_unregister_device(&sunxi_wdt->wdt_dev);
 	watchdog_set_drvdata(&sunxi_wdt->wdt_dev, NULL);
 
