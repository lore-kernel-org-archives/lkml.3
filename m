Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaKJBs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:48:59 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39160 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaKJBor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:44:47 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: [PATCH v6 35/48] arm: Register with kernel power-off handler
Date: Sun,  9 Nov 2014 17:42:52 -0800
Message-Id: <1415583785-6980-36-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=1.5
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.5460188E.019C,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 206
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel power-off handler instead of setting pm_power_off
directly. Always use register_power_off_handler_simple as there is no
indication that more than one power-off handler is registered.

If the power-off handler only resets the system or puts the CPU in sleep mode,
select the fallback priority to indicate that the power-off handler is one
of last resort. If the power-off handler powers off the system, select the
default priority.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v6:
- This patch: No change.
  Global: Replaced priority defines with enum.
v5:
- Rebase to v3.18-rc3
v4:
- No change
v3:
- Replace poweroff in all newly introduced variables and in text
  with power_off or power-off as appropriate
- Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
v2:
- Use defines to specify poweroff handler priorities
- Drop changes in arch/arm/mach-at91/setup.c (file removed upstream)

 arch/arm/kernel/psci.c                         | 3 ++-
 arch/arm/mach-at91/board-gsia18s.c             | 3 ++-
 arch/arm/mach-bcm/board_bcm2835.c              | 3 ++-
 arch/arm/mach-cns3xxx/cns3420vb.c              | 3 ++-
 arch/arm/mach-cns3xxx/core.c                   | 3 ++-
 arch/arm/mach-highbank/highbank.c              | 3 ++-
 arch/arm/mach-imx/mach-mx31moboard.c           | 3 ++-
 arch/arm/mach-iop32x/em7210.c                  | 3 ++-
 arch/arm/mach-iop32x/glantank.c                | 3 ++-
 arch/arm/mach-iop32x/iq31244.c                 | 3 ++-
 arch/arm/mach-iop32x/n2100.c                   | 3 ++-
 arch/arm/mach-ixp4xx/dsmg600-setup.c           | 3 ++-
 arch/arm/mach-ixp4xx/nas100d-setup.c           | 3 ++-
 arch/arm/mach-ixp4xx/nslu2-setup.c             | 3 ++-
 arch/arm/mach-omap2/board-omap3touchbook.c     | 3 ++-
 arch/arm/mach-orion5x/board-mss2.c             | 3 ++-
 arch/arm/mach-orion5x/dns323-setup.c           | 9 ++++++---
 arch/arm/mach-orion5x/kurobox_pro-setup.c      | 3 ++-
 arch/arm/mach-orion5x/ls-chl-setup.c           | 3 ++-
 arch/arm/mach-orion5x/ls_hgl-setup.c           | 3 ++-
 arch/arm/mach-orion5x/lsmini-setup.c           | 3 ++-
 arch/arm/mach-orion5x/mv2120-setup.c           | 3 ++-
 arch/arm/mach-orion5x/net2big-setup.c          | 3 ++-
 arch/arm/mach-orion5x/terastation_pro2-setup.c | 3 ++-
 arch/arm/mach-orion5x/ts209-setup.c            | 3 ++-
 arch/arm/mach-orion5x/ts409-setup.c            | 3 ++-
 arch/arm/mach-pxa/corgi.c                      | 3 ++-
 arch/arm/mach-pxa/mioa701.c                    | 3 ++-
 arch/arm/mach-pxa/poodle.c                     | 3 ++-
 arch/arm/mach-pxa/spitz.c                      | 3 ++-
 arch/arm/mach-pxa/tosa.c                       | 3 ++-
 arch/arm/mach-pxa/viper.c                      | 3 ++-
 arch/arm/mach-pxa/z2.c                         | 7 ++++---
 arch/arm/mach-pxa/zeus.c                       | 7 ++++---
 arch/arm/mach-s3c24xx/mach-gta02.c             | 3 ++-
 arch/arm/mach-s3c24xx/mach-jive.c              | 3 ++-
 arch/arm/mach-s3c24xx/mach-vr1000.c            | 3 ++-
 arch/arm/mach-s3c64xx/mach-smartq.c            | 3 ++-
 arch/arm/mach-sa1100/generic.c                 | 3 ++-
 arch/arm/mach-sa1100/simpad.c                  | 3 ++-
 arch/arm/mach-u300/regulator.c                 | 3 ++-
 arch/arm/mach-vt8500/vt8500.c                  | 3 ++-
 arch/arm/xen/enlighten.c                       | 3 ++-
 43 files changed, 94 insertions(+), 49 deletions(-)

diff --git a/arch/arm/kernel/psci.c b/arch/arm/kernel/psci.c
index f73891b..a7a2b4a 100644
--- a/arch/arm/kernel/psci.c
+++ b/arch/arm/kernel/psci.c
@@ -264,7 +264,8 @@ static int psci_0_2_init(struct device_node *np)
 
 	arm_pm_restart = psci_sys_reset;
 
-	pm_power_off = psci_sys_poweroff;
+	register_power_off_handler_simple(psci_sys_poweroff,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 out_put_node:
 	of_node_put(np);
diff --git a/arch/arm/mach-at91/board-gsia18s.c b/arch/arm/mach-at91/board-gsia18s.c
index bf5cc55..e628c4a 100644
--- a/arch/arm/mach-at91/board-gsia18s.c
+++ b/arch/arm/mach-at91/board-gsia18s.c
@@ -521,7 +521,8 @@ static void gsia18s_power_off(void)
 
 static int __init gsia18s_power_off_init(void)
 {
-	pm_power_off = gsia18s_power_off;
+	register_power_off_handler_simple(gsia18s_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 	return 0;
 }
 
diff --git a/arch/arm/mach-bcm/board_bcm2835.c b/arch/arm/mach-bcm/board_bcm2835.c
index 70f2f39..1d75c76 100644
--- a/arch/arm/mach-bcm/board_bcm2835.c
+++ b/arch/arm/mach-bcm/board_bcm2835.c
@@ -111,7 +111,8 @@ static void __init bcm2835_init(void)
 
 	bcm2835_setup_restart();
 	if (wdt_regs)
-		pm_power_off = bcm2835_power_off;
+		register_power_off_handler_simple(bcm2835_power_off,
+						  POWER_OFF_PRIORITY_FALLBACK);
 
 	bcm2835_init_clocks();
 
diff --git a/arch/arm/mach-cns3xxx/cns3420vb.c b/arch/arm/mach-cns3xxx/cns3420vb.c
index 6428bcc7..5c50461 100644
--- a/arch/arm/mach-cns3xxx/cns3420vb.c
+++ b/arch/arm/mach-cns3xxx/cns3420vb.c
@@ -224,7 +224,8 @@ static void __init cns3420_init(void)
 	cns3xxx_ahci_init();
 	cns3xxx_sdhci_init();
 
-	pm_power_off = cns3xxx_power_off;
+	register_power_off_handler_simple(cns3xxx_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 }
 
 static struct map_desc cns3420_io_desc[] __initdata = {
diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index 4e9837d..9c214cf 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -386,7 +386,8 @@ static void __init cns3xxx_init(void)
 		cns3xxx_pwr_soft_rst(CNS3XXX_PWR_SOFTWARE_RST(SDIO));
 	}
 
-	pm_power_off = cns3xxx_power_off;
+	register_power_off_handler_simple(cns3xxx_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	of_platform_populate(NULL, of_default_bus_match_table,
                         cns3xxx_auxdata, NULL);
diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index 07a0957..6fbdc01 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -155,7 +155,8 @@ static void __init highbank_init(void)
 	sregs_base = of_iomap(np, 0);
 	WARN_ON(!sregs_base);
 
-	pm_power_off = highbank_power_off;
+	register_power_off_handler_simple(highbank_power_off,
+					  POWER_OFF_PRIORITY_FALLBACK);
 	highbank_pm_init();
 
 	bus_register_notifier(&platform_bus_type, &highbank_platform_nb);
diff --git a/arch/arm/mach-imx/mach-mx31moboard.c b/arch/arm/mach-imx/mach-mx31moboard.c
index bb6f8a5..3001b14 100644
--- a/arch/arm/mach-imx/mach-mx31moboard.c
+++ b/arch/arm/mach-imx/mach-mx31moboard.c
@@ -559,7 +559,8 @@ static void __init mx31moboard_init(void)
 
 	imx_add_platform_device("imx_mc13783", 0, NULL, 0, NULL, 0);
 
-	pm_power_off = mx31moboard_poweroff;
+	register_power_off_handler_simple(mx31moboard_poweroff,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	switch (mx31moboard_baseboard) {
 	case MX31NOBOARD:
diff --git a/arch/arm/mach-iop32x/em7210.c b/arch/arm/mach-iop32x/em7210.c
index 77e1ff0..fd3ad09 100644
--- a/arch/arm/mach-iop32x/em7210.c
+++ b/arch/arm/mach-iop32x/em7210.c
@@ -201,7 +201,8 @@ static int __init em7210_request_gpios(void)
 		return 0;
 	}
 
-	pm_power_off = em7210_power_off;
+	register_power_off_handler_simple(em7210_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 0;
 }
diff --git a/arch/arm/mach-iop32x/glantank.c b/arch/arm/mach-iop32x/glantank.c
index 547b234..9298ea0 100644
--- a/arch/arm/mach-iop32x/glantank.c
+++ b/arch/arm/mach-iop32x/glantank.c
@@ -199,7 +199,8 @@ static void __init glantank_init_machine(void)
 	i2c_register_board_info(0, glantank_i2c_devices,
 		ARRAY_SIZE(glantank_i2c_devices));
 
-	pm_power_off = glantank_power_off;
+	register_power_off_handler_simple(glantank_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 }
 
 MACHINE_START(GLANTANK, "GLAN Tank")
diff --git a/arch/arm/mach-iop32x/iq31244.c b/arch/arm/mach-iop32x/iq31244.c
index 0e1392b..50ba54b 100644
--- a/arch/arm/mach-iop32x/iq31244.c
+++ b/arch/arm/mach-iop32x/iq31244.c
@@ -293,7 +293,8 @@ static void __init iq31244_init_machine(void)
 	platform_device_register(&iop3xx_dma_1_channel);
 
 	if (is_ep80219())
-		pm_power_off = ep80219_power_off;
+		register_power_off_handler_simple(ep80219_power_off,
+						  POWER_OFF_PRIORITY_DEFAULT);
 
 	if (!is_80219())
 		platform_device_register(&iop3xx_aau_channel);
diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
index c1cd80e..734a092 100644
--- a/arch/arm/mach-iop32x/n2100.c
+++ b/arch/arm/mach-iop32x/n2100.c
@@ -356,7 +356,8 @@ static void __init n2100_init_machine(void)
 	i2c_register_board_info(0, n2100_i2c_devices,
 		ARRAY_SIZE(n2100_i2c_devices));
 
-	pm_power_off = n2100_power_off;
+	register_power_off_handler_simple(n2100_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 }
 
 MACHINE_START(N2100, "Thecus N2100")
diff --git a/arch/arm/mach-ixp4xx/dsmg600-setup.c b/arch/arm/mach-ixp4xx/dsmg600-setup.c
index 43ee06d..f34564d 100644
--- a/arch/arm/mach-ixp4xx/dsmg600-setup.c
+++ b/arch/arm/mach-ixp4xx/dsmg600-setup.c
@@ -281,7 +281,8 @@ static void __init dsmg600_init(void)
 
 	platform_add_devices(dsmg600_devices, ARRAY_SIZE(dsmg600_devices));
 
-	pm_power_off = dsmg600_power_off;
+	register_power_off_handler_simple(dsmg600_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 }
 
 MACHINE_START(DSMG600, "D-Link DSM-G600 RevA")
diff --git a/arch/arm/mach-ixp4xx/nas100d-setup.c b/arch/arm/mach-ixp4xx/nas100d-setup.c
index 4e0f762..43a9333 100644
--- a/arch/arm/mach-ixp4xx/nas100d-setup.c
+++ b/arch/arm/mach-ixp4xx/nas100d-setup.c
@@ -292,7 +292,8 @@ static void __init nas100d_init(void)
 
 	platform_add_devices(nas100d_devices, ARRAY_SIZE(nas100d_devices));
 
-	pm_power_off = nas100d_power_off;
+	register_power_off_handler_simple(nas100d_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	if (request_irq(gpio_to_irq(NAS100D_RB_GPIO), &nas100d_reset_handler,
 		IRQF_TRIGGER_LOW, "NAS100D reset button", NULL) < 0) {
diff --git a/arch/arm/mach-ixp4xx/nslu2-setup.c b/arch/arm/mach-ixp4xx/nslu2-setup.c
index 88c025f..e094d5f 100644
--- a/arch/arm/mach-ixp4xx/nslu2-setup.c
+++ b/arch/arm/mach-ixp4xx/nslu2-setup.c
@@ -262,7 +262,8 @@ static void __init nslu2_init(void)
 
 	platform_add_devices(nslu2_devices, ARRAY_SIZE(nslu2_devices));
 
-	pm_power_off = nslu2_power_off;
+	register_power_off_handler_simple(nslu2_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	if (request_irq(gpio_to_irq(NSLU2_RB_GPIO), &nslu2_reset_handler,
 		IRQF_TRIGGER_LOW, "NSLU2 reset button", NULL) < 0) {
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index a01993e..8abce2c 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -344,7 +344,8 @@ static void __init omap3_touchbook_init(void)
 {
 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
 
-	pm_power_off = omap3_touchbook_poweroff;
+	register_power_off_handler_simple(omap3_touchbook_poweroff,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	if (system_rev >= 0x20 && system_rev <= 0x34301000) {
 		omap_mux_init_gpio(23, OMAP_PIN_INPUT);
diff --git a/arch/arm/mach-orion5x/board-mss2.c b/arch/arm/mach-orion5x/board-mss2.c
index 66f9c3b..cac2793 100644
--- a/arch/arm/mach-orion5x/board-mss2.c
+++ b/arch/arm/mach-orion5x/board-mss2.c
@@ -86,5 +86,6 @@ static void mss2_power_off(void)
 void __init mss2_init(void)
 {
 	/* register mss2 specific power-off method */
-	pm_power_off = mss2_power_off;
+	register_power_off_handler_simple(mss2_power_off,
+					  POWER_OFF_PRIORITY_FALLBACK);
 }
diff --git a/arch/arm/mach-orion5x/dns323-setup.c b/arch/arm/mach-orion5x/dns323-setup.c
index 09d2a26..9876509 100644
--- a/arch/arm/mach-orion5x/dns323-setup.c
+++ b/arch/arm/mach-orion5x/dns323-setup.c
@@ -669,7 +669,8 @@ static void __init dns323_init(void)
 		if (gpio_request(DNS323_GPIO_POWER_OFF, "POWEROFF") != 0 ||
 		    gpio_direction_output(DNS323_GPIO_POWER_OFF, 0) != 0)
 			pr_err("DNS-323: failed to setup power-off GPIO\n");
-		pm_power_off = dns323a_power_off;
+		register_power_off_handler_simple(dns323a_power_off,
+						  POWER_OFF_PRIORITY_DEFAULT);
 		break;
 	case DNS323_REV_B1:
 		/* 5182 built-in SATA init */
@@ -686,7 +687,8 @@ static void __init dns323_init(void)
 		if (gpio_request(DNS323_GPIO_POWER_OFF, "POWEROFF") != 0 ||
 		    gpio_direction_output(DNS323_GPIO_POWER_OFF, 0) != 0)
 			pr_err("DNS-323: failed to setup power-off GPIO\n");
-		pm_power_off = dns323b_power_off;
+		register_power_off_handler_simple(dns323b_power_off,
+						  POWER_OFF_PRIORITY_DEFAULT);
 		break;
 	case DNS323_REV_C1:
 		/* 5182 built-in SATA init */
@@ -696,7 +698,8 @@ static void __init dns323_init(void)
 		if (gpio_request(DNS323C_GPIO_POWER_OFF, "POWEROFF") != 0 ||
 		    gpio_direction_output(DNS323C_GPIO_POWER_OFF, 0) != 0)
 			pr_err("DNS-323: failed to setup power-off GPIO\n");
-		pm_power_off = dns323c_power_off;
+		register_power_off_handler_simple(dns323c_power_off,
+						  POWER_OFF_PRIORITY_DEFAULT);
 
 		/* Now, -this- should theorically be done by the sata_mv driver
 		 * once I figure out what's going on there. Maybe the behaviour
diff --git a/arch/arm/mach-orion5x/kurobox_pro-setup.c b/arch/arm/mach-orion5x/kurobox_pro-setup.c
index fe6a48a..872d4fe 100644
--- a/arch/arm/mach-orion5x/kurobox_pro-setup.c
+++ b/arch/arm/mach-orion5x/kurobox_pro-setup.c
@@ -376,7 +376,8 @@ static void __init kurobox_pro_init(void)
 	i2c_register_board_info(0, &kurobox_pro_i2c_rtc, 1);
 
 	/* register Kurobox Pro specific power-off method */
-	pm_power_off = kurobox_pro_power_off;
+	register_power_off_handler_simple(kurobox_pro_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 }
 
 #ifdef CONFIG_MACH_KUROBOX_PRO
diff --git a/arch/arm/mach-orion5x/ls-chl-setup.c b/arch/arm/mach-orion5x/ls-chl-setup.c
index 028ea03..3f540d1 100644
--- a/arch/arm/mach-orion5x/ls-chl-setup.c
+++ b/arch/arm/mach-orion5x/ls-chl-setup.c
@@ -312,7 +312,8 @@ static void __init lschl_init(void)
 	gpio_set_value(LSCHL_GPIO_USB_POWER, 1);
 
 	/* register power-off method */
-	pm_power_off = lschl_power_off;
+	register_power_off_handler_simple(lschl_power_off,
+					  POWER_OFF_PRIORITY_FALLBACK);
 
 	pr_info("%s: finished\n", __func__);
 }
diff --git a/arch/arm/mach-orion5x/ls_hgl-setup.c b/arch/arm/mach-orion5x/ls_hgl-setup.c
index 32b7129..699a5a1 100644
--- a/arch/arm/mach-orion5x/ls_hgl-setup.c
+++ b/arch/arm/mach-orion5x/ls_hgl-setup.c
@@ -259,7 +259,8 @@ static void __init ls_hgl_init(void)
 	gpio_set_value(LS_HGL_GPIO_USB_POWER, 1);
 
 	/* register power-off method */
-	pm_power_off = ls_hgl_power_off;
+	register_power_off_handler_simple(ls_hgl_power_off,
+					  POWER_OFF_PRIORITY_FALLBACK);
 
 	pr_info("%s: finished\n", __func__);
 }
diff --git a/arch/arm/mach-orion5x/lsmini-setup.c b/arch/arm/mach-orion5x/lsmini-setup.c
index a6493e7..c5712ff 100644
--- a/arch/arm/mach-orion5x/lsmini-setup.c
+++ b/arch/arm/mach-orion5x/lsmini-setup.c
@@ -260,7 +260,8 @@ static void __init lsmini_init(void)
 	gpio_set_value(LSMINI_GPIO_USB_POWER, 1);
 
 	/* register power-off method */
-	pm_power_off = lsmini_power_off;
+	register_power_off_handler_simple(lsmini_power_off,
+					  POWER_OFF_PRIORITY_FALLBACK);
 
 	pr_info("%s: finished\n", __func__);
 }
diff --git a/arch/arm/mach-orion5x/mv2120-setup.c b/arch/arm/mach-orion5x/mv2120-setup.c
index e032f01..13efbec 100644
--- a/arch/arm/mach-orion5x/mv2120-setup.c
+++ b/arch/arm/mach-orion5x/mv2120-setup.c
@@ -225,7 +225,8 @@ static void __init mv2120_init(void)
 	if (gpio_request(MV2120_GPIO_POWER_OFF, "POWEROFF") != 0 ||
 	    gpio_direction_output(MV2120_GPIO_POWER_OFF, 1) != 0)
 		pr_err("mv2120: failed to setup power-off GPIO\n");
-	pm_power_off = mv2120_power_off;
+	register_power_off_handler_simple(mv2120_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 }
 
 /* Warning: HP uses a wrong mach-type (=526) in their bootloader */
diff --git a/arch/arm/mach-orion5x/net2big-setup.c b/arch/arm/mach-orion5x/net2big-setup.c
index ba73dc7..c7648f0 100644
--- a/arch/arm/mach-orion5x/net2big-setup.c
+++ b/arch/arm/mach-orion5x/net2big-setup.c
@@ -413,7 +413,8 @@ static void __init net2big_init(void)
 
 	if (gpio_request(NET2BIG_GPIO_POWER_OFF, "power-off") == 0 &&
 	    gpio_direction_output(NET2BIG_GPIO_POWER_OFF, 0) == 0)
-		pm_power_off = net2big_power_off;
+		register_power_off_handler_simple(net2big_power_off,
+						  POWER_OFF_PRIORITY_DEFAULT);
 	else
 		pr_err("net2big: failed to configure power-off GPIO\n");
 
diff --git a/arch/arm/mach-orion5x/terastation_pro2-setup.c b/arch/arm/mach-orion5x/terastation_pro2-setup.c
index 1208674..227ae91 100644
--- a/arch/arm/mach-orion5x/terastation_pro2-setup.c
+++ b/arch/arm/mach-orion5x/terastation_pro2-setup.c
@@ -353,7 +353,8 @@ static void __init tsp2_init(void)
 	i2c_register_board_info(0, &tsp2_i2c_rtc, 1);
 
 	/* register Terastation Pro II specific power-off method */
-	pm_power_off = tsp2_power_off;
+	register_power_off_handler_simple(tsp2_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 }
 
 MACHINE_START(TERASTATION_PRO2, "Buffalo Terastation Pro II/Live")
diff --git a/arch/arm/mach-orion5x/ts209-setup.c b/arch/arm/mach-orion5x/ts209-setup.c
index c725b7c..540e3f3 100644
--- a/arch/arm/mach-orion5x/ts209-setup.c
+++ b/arch/arm/mach-orion5x/ts209-setup.c
@@ -318,7 +318,8 @@ static void __init qnap_ts209_init(void)
 	i2c_register_board_info(0, &qnap_ts209_i2c_rtc, 1);
 
 	/* register tsx09 specific power-off method */
-	pm_power_off = qnap_tsx09_power_off;
+	register_power_off_handler_simple(qnap_tsx09_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 }
 
 MACHINE_START(TS209, "QNAP TS-109/TS-209")
diff --git a/arch/arm/mach-orion5x/ts409-setup.c b/arch/arm/mach-orion5x/ts409-setup.c
index cf2ab53..40cbdd7 100644
--- a/arch/arm/mach-orion5x/ts409-setup.c
+++ b/arch/arm/mach-orion5x/ts409-setup.c
@@ -307,7 +307,8 @@ static void __init qnap_ts409_init(void)
 	platform_device_register(&ts409_leds);
 
 	/* register tsx09 specific power-off method */
-	pm_power_off = qnap_tsx09_power_off;
+	register_power_off_handler_simple(qnap_tsx09_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 }
 
 MACHINE_START(TS409, "QNAP TS-409")
diff --git a/arch/arm/mach-pxa/corgi.c b/arch/arm/mach-pxa/corgi.c
index 06022b2..93b73a1 100644
--- a/arch/arm/mach-pxa/corgi.c
+++ b/arch/arm/mach-pxa/corgi.c
@@ -718,7 +718,8 @@ static void corgi_restart(enum reboot_mode mode, const char *cmd)
 
 static void __init corgi_init(void)
 {
-	pm_power_off = corgi_poweroff;
+	register_power_off_handler_simple(corgi_poweroff,
+					  POWER_OFF_PRIORITY_FALLBACK);
 
 	/* Stop 3.6MHz and drive HIGH to PCMCIA and CS */
 	PCFR |= PCFR_OPDE;
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index 29997bd..5d318d4 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -750,7 +750,8 @@ static void __init mioa701_machine_init(void)
 	pxa_set_keypad_info(&mioa701_keypad_info);
 	pxa_set_udc_info(&mioa701_udc_info);
 	pxa_set_ac97_info(&mioa701_ac97_info);
-	pm_power_off = mioa701_poweroff;
+	register_power_off_handler_simple(mioa701_poweroff,
+					  POWER_OFF_PRIORITY_FALLBACK);
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 	gsm_init();
 
diff --git a/arch/arm/mach-pxa/poodle.c b/arch/arm/mach-pxa/poodle.c
index 1319916..749d2af 100644
--- a/arch/arm/mach-pxa/poodle.c
+++ b/arch/arm/mach-pxa/poodle.c
@@ -432,7 +432,8 @@ static void __init poodle_init(void)
 {
 	int ret = 0;
 
-	pm_power_off = poodle_poweroff;
+	register_power_off_handler_simple(poodle_poweroff,
+					  POWER_OFF_PRIORITY_FALLBACK);
 
 	PCFR |= PCFR_OPDE;
 
diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
index 840c3a4..ab25b6c 100644
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -944,7 +944,8 @@ static void spitz_restart(enum reboot_mode mode, const char *cmd)
 static void __init spitz_init(void)
 {
 	init_gpio_reset(SPITZ_GPIO_ON_RESET, 1, 0);
-	pm_power_off = spitz_poweroff;
+	register_power_off_handler_simple(spitz_poweroff,
+					  POWER_OFF_PRIORITY_FALLBACK);
 
 	PMCR = 0x00;
 
diff --git a/arch/arm/mach-pxa/tosa.c b/arch/arm/mach-pxa/tosa.c
index c158a6e..8823448 100644
--- a/arch/arm/mach-pxa/tosa.c
+++ b/arch/arm/mach-pxa/tosa.c
@@ -940,7 +940,8 @@ static void __init tosa_init(void)
 
 	init_gpio_reset(TOSA_GPIO_ON_RESET, 0, 0);
 
-	pm_power_off = tosa_poweroff;
+	register_power_off_handler_simple(tosa_poweroff,
+					  POWER_OFF_PRIORITY_FALLBACK);
 
 	PCFR |= PCFR_OPDE;
 
diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
index de3b080..6bb4de3 100644
--- a/arch/arm/mach-pxa/viper.c
+++ b/arch/arm/mach-pxa/viper.c
@@ -919,7 +919,8 @@ static void __init viper_init(void)
 {
 	u8 version;
 
-	pm_power_off = viper_power_off;
+	register_power_off_handler_simple(viper_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	pxa2xx_mfp_config(ARRAY_AND_SIZE(viper_pin_config));
 
diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
index e1a121b..0d0a6ae 100644
--- a/arch/arm/mach-pxa/z2.c
+++ b/arch/arm/mach-pxa/z2.c
@@ -693,8 +693,6 @@ static void z2_power_off(void)
 	pxa27x_set_pwrmode(PWRMODE_DEEPSLEEP);
 	pxa27x_cpu_pm_enter(PM_SUSPEND_MEM);
 }
-#else
-#define z2_power_off   NULL
 #endif
 
 /******************************************************************************
@@ -719,7 +717,10 @@ static void __init z2_init(void)
 	z2_keys_init();
 	z2_pmic_init();
 
-	pm_power_off = z2_power_off;
+#ifdef CONFIG_PM
+	register_power_off_handler_simple(z2_power_off,
+					  POWER_OFF_PRIORITY_FALLBACK);
+#endif
 }
 
 MACHINE_START(ZIPIT2, "Zipit Z2")
diff --git a/arch/arm/mach-pxa/zeus.c b/arch/arm/mach-pxa/zeus.c
index 205f9bf..457eed1 100644
--- a/arch/arm/mach-pxa/zeus.c
+++ b/arch/arm/mach-pxa/zeus.c
@@ -690,8 +690,6 @@ static void zeus_power_off(void)
 	local_irq_disable();
 	cpu_suspend(PWRMODE_DEEPSLEEP, pxa27x_finish_suspend);
 }
-#else
-#define zeus_power_off   NULL
 #endif
 
 #ifdef CONFIG_APM_EMULATION
@@ -847,7 +845,10 @@ static void __init zeus_init(void)
 	__raw_writel(msc0, MSC0);
 	__raw_writel(msc1, MSC1);
 
-	pm_power_off = zeus_power_off;
+#ifdef CONFIG_PM
+	register_power_off_handler_simple(zeus_power_off,
+					  POWER_OFF_PRIORITY_FALLBACK);
+#endif
 	zeus_setup_apm();
 
 	pxa2xx_mfp_config(ARRAY_AND_SIZE(zeus_pin_config));
diff --git a/arch/arm/mach-s3c24xx/mach-gta02.c b/arch/arm/mach-s3c24xx/mach-gta02.c
index 6d1e0b9..8366b3e 100644
--- a/arch/arm/mach-s3c24xx/mach-gta02.c
+++ b/arch/arm/mach-s3c24xx/mach-gta02.c
@@ -579,7 +579,8 @@ static void __init gta02_machine_init(void)
 	i2c_register_board_info(0, gta02_i2c_devs, ARRAY_SIZE(gta02_i2c_devs));
 
 	platform_add_devices(gta02_devices, ARRAY_SIZE(gta02_devices));
-	pm_power_off = gta02_poweroff;
+	register_power_off_handler_simple(gta02_poweroff,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	regulator_has_full_constraints();
 }
diff --git a/arch/arm/mach-s3c24xx/mach-jive.c b/arch/arm/mach-s3c24xx/mach-jive.c
index 7d99fe8..20beb39 100644
--- a/arch/arm/mach-s3c24xx/mach-jive.c
+++ b/arch/arm/mach-s3c24xx/mach-jive.c
@@ -657,7 +657,8 @@ static void __init jive_machine_init(void)
 	s3c_i2c0_set_platdata(&jive_i2c_cfg);
 	i2c_register_board_info(0, jive_i2c_devs, ARRAY_SIZE(jive_i2c_devs));
 
-	pm_power_off = jive_power_off;
+	register_power_off_handler_simple(jive_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	platform_add_devices(jive_devices, ARRAY_SIZE(jive_devices));
 }
diff --git a/arch/arm/mach-s3c24xx/mach-vr1000.c b/arch/arm/mach-s3c24xx/mach-vr1000.c
index 89f32bd..1f32ba7 100644
--- a/arch/arm/mach-s3c24xx/mach-vr1000.c
+++ b/arch/arm/mach-s3c24xx/mach-vr1000.c
@@ -306,7 +306,8 @@ static void vr1000_power_off(void)
 
 static void __init vr1000_map_io(void)
 {
-	pm_power_off = vr1000_power_off;
+	register_power_off_handler_simple(vr1000_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	s3c24xx_init_io(vr1000_iodesc, ARRAY_SIZE(vr1000_iodesc));
 	s3c24xx_init_uarts(vr1000_uartcfgs, ARRAY_SIZE(vr1000_uartcfgs));
diff --git a/arch/arm/mach-s3c64xx/mach-smartq.c b/arch/arm/mach-s3c64xx/mach-smartq.c
index b3d1353..b30906f 100644
--- a/arch/arm/mach-s3c64xx/mach-smartq.c
+++ b/arch/arm/mach-s3c64xx/mach-smartq.c
@@ -291,7 +291,8 @@ static int __init smartq_power_off_init(void)
 	/* leave power on */
 	gpio_direction_output(S3C64XX_GPK(15), 0);
 
-	pm_power_off = smartq_power_off;
+	register_power_off_handler_simple(smartq_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return ret;
 }
diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index d4ea142..371bffe 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -311,7 +311,8 @@ static struct platform_device *sa11x0_devices[] __initdata = {
 
 static int __init sa1100_init(void)
 {
-	pm_power_off = sa1100_power_off;
+	register_power_off_handler_simple(sa1100_power_off,
+					  POWER_OFF_PRIORITY_FALLBACK);
 	return platform_add_devices(sa11x0_devices, ARRAY_SIZE(sa11x0_devices));
 }
 
diff --git a/arch/arm/mach-sa1100/simpad.c b/arch/arm/mach-sa1100/simpad.c
index 41e476e..fb85730 100644
--- a/arch/arm/mach-sa1100/simpad.c
+++ b/arch/arm/mach-sa1100/simpad.c
@@ -373,7 +373,8 @@ static int __init simpad_init(void)
 	if (ret)
 		printk(KERN_WARNING "simpad: Unable to register cs3 GPIO device");
 
-	pm_power_off = simpad_power_off;
+	register_power_off_handler_simple(simpad_power_off,
+					  POWER_OFF_PRIORITY_FALLBACK);
 
 	sa11x0_ppc_configure_mcp();
 	sa11x0_register_mtd(&simpad_flash_data, simpad_flash_resources,
diff --git a/arch/arm/mach-u300/regulator.c b/arch/arm/mach-u300/regulator.c
index 0493a84..4ff09b0 100644
--- a/arch/arm/mach-u300/regulator.c
+++ b/arch/arm/mach-u300/regulator.c
@@ -98,7 +98,8 @@ static int __init __u300_init_boardpower(struct platform_device *pdev)
 			   U300_SYSCON_PMCR_DCON_ENABLE, 0);
 
 	/* Register globally exported PM poweroff hook */
-	pm_power_off = u300_pm_poweroff;
+	register_power_off_handler_simple(u300_pm_poweroff,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	return 0;
 }
diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
index 3bc0dc9..48e4fbf 100644
--- a/arch/arm/mach-vt8500/vt8500.c
+++ b/arch/arm/mach-vt8500/vt8500.c
@@ -155,7 +155,8 @@ static void __init vt8500_init(void)
 			pr_err("%s:ioremap(power_off) failed\n", __func__);
 	}
 	if (pmc_base)
-		pm_power_off = &vt8500_power_off;
+		register_power_off_handler_simple(vt8500_power_off,
+						  POWER_OFF_PRIORITY_FALLBACK);
 	else
 		pr_err("%s: PMC Hibernation register could not be remapped, not enabling power off!\n", __func__);
 
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 0e15f01..1c8bce0 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -336,7 +336,8 @@ static int __init xen_pm_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
-	pm_power_off = xen_power_off;
+	register_power_off_handler_simple(xen_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 	arm_pm_restart = xen_restart;
 
 	return 0;
-- 
1.9.1

