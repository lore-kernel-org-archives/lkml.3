Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab3CKUoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:44:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64200 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3CKUoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:44:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: Regulator API ignored return values
Date: Mon, 11 Mar 2013 20:43:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>, Jingoo Han <jg1.han@samsung.com>,
        Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dtor@mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303112043.53334.arnd@arndb.de>
X-Provags-ID: V02:K0:+VPKhT0yKlUHJtPtwFtTKAHnjzjW4LckqtDdB6WTkF/
 y6DWK6fwBmzKjyj2YMhM4cVK1oGBzepWqH/6LwdQaGYndv8vhE
 8EzG1q53gNFgbSWOWYhoK4htYj3t22gKMtk8Pkrmlt/NCNE3Ps
 0FbxfBfBGdDRNfcVZBdhz7l9Ytib+NCvd6g9S8ueSZokz/UlA+
 /+W+xfCV++xCsap3+uRQ81yT4Eg6TR2T0oxet8VTPOKLvFn3/z
 HDCth7ahFPy3eTv7H2CXSSSjswBmib74tXgWJwojKKPozH8EA+
 YKh7u5LBlXLmTCchM0h6pCWPAfMztdywjJA8OIvm2WM9EZW4Za
 gZagzuboM9KrAMvoOkDk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Mark Brown has added a patch to Linux-next that warns about certain regulator
API functions being called without checking the results, which seems to have
uncovered a number of bugs.

I've added a few people to Cc that might be interested in the reports and
in fixing these bugs. Below you can find a list of all instances I found
building the ARM defconfigs.

	Arnd

==> build/dove_defconfig/faillog <==
/git/arm-soc/drivers/mmc/host/sdhci.c: In function 'sdhci_add_host':
/git/arm-soc/drivers/mmc/host/sdhci.c:2910:19: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]

==> build/imx_v4_v5_defconfig/faillog <==
/git/arm-soc/drivers/input/touchscreen/ads7846.c: In function '__ads7846_enable':
/git/arm-soc/drivers/input/touchscreen/ads7846.c:239:18: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
/git/arm-soc/drivers/mmc/host/sdhci.c: In function 'sdhci_add_host':
/git/arm-soc/drivers/mmc/host/sdhci.c:2910:19: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
/git/arm-soc/drivers/video/backlight/l4f00242t03.c: In function 'l4f00242t03_lcd_init':
/git/arm-soc/drivers/video/backlight/l4f00242t03.c:58:18: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
/git/arm-soc/drivers/video/backlight/l4f00242t03.c:61:18: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]

==> build/imx_v6_v7_defconfig/faillog <==
/git/arm-soc/drivers/mmc/host/sdhci.c: In function 'sdhci_add_host':
/git/arm-soc/drivers/mmc/host/sdhci.c:2910:19: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
/git/arm-soc/drivers/video/backlight/l4f00242t03.c: In function 'l4f00242t03_lcd_init':
/git/arm-soc/drivers/video/backlight/l4f00242t03.c:58:18: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
/git/arm-soc/drivers/video/backlight/l4f00242t03.c:61:18: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]

==> build/magician_defconfig/faillog <==
/git/arm-soc/drivers/usb/otg/gpio_vbus.c: In function 'set_vbus_draw':
/git/arm-soc/drivers/usb/otg/gpio_vbus.c:72:20: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]

==> build/mmp2_defconfig/faillog <==
/git/arm-soc/drivers/mmc/host/sdhci.c: In function 'sdhci_add_host':
/git/arm-soc/drivers/mmc/host/sdhci.c:2910:19: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]

==> build/omap2plus_defconfig/faillog <==
/git/arm-soc/drivers/input/touchscreen/ads7846.c: In function '__ads7846_enable':
/git/arm-soc/drivers/input/touchscreen/ads7846.c:239:18: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]

==> build/tegra_defconfig/faillog <==
/git/arm-soc/arch/arm/mach-tegra/board-harmony-pcie.c: In function 'harmony_pcie_init':
/git/arm-soc/arch/arm/mach-tegra/board-harmony-pcie.c:65:18: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
/git/arm-soc/drivers/mmc/host/sdhci.c: In function 'sdhci_add_host':
/git/arm-soc/drivers/mmc/host/sdhci.c:2910:19: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]

==> build/u8500_defconfig/faillog <==
/git/arm-soc/arch/arm/mach-ux500/board-mop500.c: In function 'mop500_prox_activate':
/git/arm-soc/arch/arm/mach-ux500/board-mop500.c:432:18: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
/git/arm-soc/drivers/mfd/ab8500-gpadc.c: In function 'ab8500_gpadc_runtime_resume':
/git/arm-soc/drivers/mfd/ab8500-gpadc.c:598:18: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
/git/arm-soc/drivers/mfd/ab8500-gpadc.c: In function 'ab8500_gpadc_probe':
/git/arm-soc/drivers/mfd/ab8500-gpadc.c:655:18: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
/git/arm-soc/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c: In function 'synaptics_rmi4_resume':
/git/arm-soc/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c:1085:18: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
