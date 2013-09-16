Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3IPClm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 22:41:42 -0400
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:44979 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755795Ab3IPClk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 22:41:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:69:355:371:372:379:541:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1801:1981:2194:2199:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3865:3866:3867:3868:4250:4321:4605:5007:7652:7903:7974:9010:10004:10848:11026:11657:11914:12043:12217:12295:12296:12438:12517:12519:12555:12679:13161:13229:13255:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: skin40_2b07537c76a09
X-Filterd-Recvd-Size: 53230
Message-ID: <1379299293.3641.14.camel@joe-AO722>
Subject: [untested checkpatch patch] treewide: Convert __initdata and
 __initconst misuses
From: Joe Perches <joe@perches.com>
To: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 15 Sep 2013 19:41:33 -0700
In-Reply-To: <1379298894.3641.8.camel@joe-AO722>
References: <1375740651-7716-1-git-send-email-andi@firstfloor.org>
	 <1379276783.3641.3.camel@joe-AO722>
	 <20130915210433.GV18242@two.firstfloor.org>
	 <1379298894.3641.8.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andi.

I ran the updated checkpatch tests against the -next tree
and get this patch below:

There are slightly suspicious conversions of

from:
	static const char *foo __initdata = { "bar", "baz" };
to:
	static const char *foo __initconst = { "bar", "baz" };

Maybe these should be:
	static const char * const foo...

Anyway, here are the conversions:

---

 arch/arc/plat-arcfpga/platform.c                   |  6 +++---
 arch/arc/plat-tb10x/tb10x.c                        |  2 +-
 arch/arm/kernel/setup.c                            |  2 +-
 arch/arm/mach-at91/board-dt-sam9.c                 |  2 +-
 arch/arm/mach-at91/board-dt-sama5.c                |  2 +-
 arch/arm/mach-clps711x/board-edb7211.c             |  2 +-
 arch/arm/mach-clps711x/board-p720t.c               |  2 +-
 arch/arm/mach-cns3xxx/core.c                       |  4 ++--
 arch/arm/mach-davinci/board-dm355-evm.c            |  2 +-
 arch/arm/mach-davinci/board-dm355-leopard.c        |  2 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |  2 +-
 arch/arm/mach-davinci/board-tnetv107x-evm.c        |  6 +++---
 arch/arm/mach-davinci/da850.c                      |  4 ++--
 arch/arm/mach-davinci/da8xx-dt.c                   |  2 +-
 arch/arm/mach-exynos/mach-exynos4-dt.c             |  2 +-
 arch/arm/mach-exynos/mach-exynos5-dt.c             |  2 +-
 arch/arm/mach-imx/imx31-dt.c                       |  2 +-
 arch/arm/mach-imx/imx51-dt.c                       |  2 +-
 arch/arm/mach-imx/mach-imx53.c                     |  2 +-
 arch/arm/mach-imx/mach-imx6q.c                     |  2 +-
 arch/arm/mach-imx/mach-imx6sl.c                    |  2 +-
 arch/arm/mach-imx/mach-vf610.c                     |  2 +-
 arch/arm/mach-lpc32xx/phy3250.c                    |  2 +-
 arch/arm/mach-mmp/mmp-dt.c                         |  2 +-
 arch/arm/mach-mmp/mmp2-dt.c                        |  2 +-
 arch/arm/mach-msm/board-dt-8660.c                  |  2 +-
 arch/arm/mach-mxs/mach-mxs.c                       |  2 +-
 arch/arm/mach-omap2/board-generic.c                | 18 ++++++++--------
 arch/arm/mach-omap2/vc.c                           |  2 +-
 arch/arm/mach-omap2/voltagedomains3xxx_data.c      |  2 +-
 arch/arm/mach-omap2/voltagedomains44xx_data.c      |  2 +-
 arch/arm/mach-omap2/voltagedomains54xx_data.c      |  2 +-
 arch/arm/mach-prima2/common.c                      |  6 +++---
 arch/arm/mach-prima2/l2x0.c                        |  6 +++---
 arch/arm/mach-pxa/pxa-dt.c                         |  2 +-
 arch/arm/mach-s3c24xx/mach-s3c2416-dt.c            |  2 +-
 arch/arm/mach-shmobile/board-ape6evm-reference.c   |  2 +-
 arch/arm/mach-shmobile/board-ape6evm.c             |  2 +-
 .../board-armadillo800eva-reference.c              |  2 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c     |  2 +-
 arch/arm/mach-shmobile/board-bockw-reference.c     |  2 +-
 arch/arm/mach-shmobile/board-bockw.c               |  2 +-
 arch/arm/mach-shmobile/board-kzm9d-reference.c     |  2 +-
 arch/arm/mach-shmobile/board-kzm9d.c               |  2 +-
 arch/arm/mach-shmobile/board-kzm9g-reference.c     |  2 +-
 arch/arm/mach-shmobile/board-kzm9g.c               |  2 +-
 arch/arm/mach-shmobile/board-lager-reference.c     |  2 +-
 arch/arm/mach-shmobile/board-lager.c               |  2 +-
 arch/arm/mach-shmobile/board-mackerel.c            |  2 +-
 arch/arm/mach-shmobile/board-marzen-reference.c    |  2 +-
 arch/arm/mach-shmobile/board-marzen.c              |  2 +-
 arch/arm/mach-shmobile/setup-emev2.c               |  2 +-
 arch/arm/mach-shmobile/setup-r8a73a4.c             |  2 +-
 arch/arm/mach-shmobile/setup-r8a7740.c             |  2 +-
 arch/arm/mach-shmobile/setup-r8a7778.c             |  2 +-
 arch/arm/mach-shmobile/setup-r8a7779.c             |  2 +-
 arch/arm/mach-shmobile/setup-r8a7790.c             |  2 +-
 arch/arm/mach-shmobile/setup-sh7372.c              |  2 +-
 arch/arm/mach-shmobile/setup-sh73a0.c              |  2 +-
 arch/arm/mach-sti/board-dt.c                       |  2 +-
 arch/metag/kernel/machines.c                       |  2 +-
 arch/mips/ath79/pci.c                              |  2 +-
 arch/powerpc/platforms/52xx/mpc5200_simple.c       |  2 +-
 arch/powerpc/platforms/83xx/mpc830x_rdb.c          |  2 +-
 arch/powerpc/platforms/83xx/mpc831x_rdb.c          |  2 +-
 arch/powerpc/sysdev/xilinx_intc.c                  |  2 +-
 drivers/clk/samsung/clk.h                          |  2 +-
 drivers/clk/versatile/clk-integrator.c             |  2 +-
 drivers/clk/versatile/clk-realview.c               |  4 ++--
 drivers/clk/zynq/clkc.c                            | 24 +++++++++++-----------
 drivers/cpufreq/ppc-corenet-cpufreq.c              |  2 +-
 drivers/irqchip/irq-bcm2835.c                      | 10 ++++-----
 drivers/mmc/host/sdhci-bcm-kona.c                  |  2 +-
 drivers/mtd/nand/davinci_nand.c                    |  4 ++--
 drivers/usb/host/ehci-msm.c                        |  2 +-
 drivers/usb/host/ehci-omap.c                       |  2 +-
 drivers/usb/host/ehci-s5p.c                        |  2 +-
 drivers/usb/host/ehci-spear.c                      |  2 +-
 78 files changed, 113 insertions(+), 113 deletions(-)

diff --git a/arch/arc/plat-arcfpga/platform.c b/arch/arc/plat-arcfpga/platform.c
index d71f3c3..19b76b6 100644
--- a/arch/arc/plat-arcfpga/platform.c
+++ b/arch/arc/plat-arcfpga/platform.c
@@ -201,7 +201,7 @@ static void __init plat_fpga_populate_dev(void)
  * callback set, by matching the DT compatible name.
  */
 
-static const char *aa4_compat[] __initdata = {
+static const char *aa4_compat[] __initconst = {
 	"snps,arc-angel4",
 	NULL,
 };
@@ -216,7 +216,7 @@ MACHINE_START(ANGEL4, "angel4")
 #endif
 MACHINE_END
 
-static const char *ml509_compat[] __initdata = {
+static const char *ml509_compat[] __initconst = {
 	"snps,arc-ml509",
 	NULL,
 };
@@ -231,7 +231,7 @@ MACHINE_START(ML509, "ml509")
 #endif
 MACHINE_END
 
-static const char *nsimosci_compat[] __initdata = {
+static const char *nsimosci_compat[] __initconst = {
 	"snps,nsimosci",
 	NULL,
 };
diff --git a/arch/arc/plat-tb10x/tb10x.c b/arch/arc/plat-tb10x/tb10x.c
index 06cb309..e487556 100644
--- a/arch/arc/plat-tb10x/tb10x.c
+++ b/arch/arc/plat-tb10x/tb10x.c
@@ -34,7 +34,7 @@ static void __init tb10x_platform_init(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static const char *tb10x_compat[] __initdata = {
+static const char *tb10x_compat[] __initconst = {
 	"abilis,arc-tb10x",
 	NULL,
 };
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 0e1e2b3..c56dcd4 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -139,7 +139,7 @@ EXPORT_SYMBOL(elf_platform);
 static const char *cpu_name;
 static const char *machine_name;
 static char __initdata cmd_line[COMMAND_LINE_SIZE];
-const struct machine_desc *machine_desc __initdata;
+const struct machine_desc *machine_desc __initconst;
 
 static union { char c[4]; unsigned long l; } endian_test __initdata = { { 'l', '?', '?', 'b' } };
 #define ENDIANNESS ((char)endian_test.l)
diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index 8db3013..8c74ded 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -42,7 +42,7 @@ static void __init at91_dt_device_init(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static const char *at91_dt_board_compat[] __initdata = {
+static const char *at91_dt_board_compat[] __initconst = {
 	"atmel,at91sam9",
 	NULL
 };
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index bf00d15..fab5b3f 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -65,7 +65,7 @@ static void __init sama5_dt_device_init(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static const char *sama5_dt_board_compat[] __initdata = {
+static const char *sama5_dt_board_compat[] __initconst = {
 	"atmel,sama5",
 	NULL
 };
diff --git a/arch/arm/mach-clps711x/board-edb7211.c b/arch/arm/mach-clps711x/board-edb7211.c
index fe6184e..e5a7568 100644
--- a/arch/arm/mach-clps711x/board-edb7211.c
+++ b/arch/arm/mach-clps711x/board-edb7211.c
@@ -120,7 +120,7 @@ static struct generic_bl_info edb7211_lcd_backlight_pdata = {
 	.set_bl_intensity	= edb7211_lcd_backlight_set_intensity,
 };
 
-static struct gpio edb7211_gpios[] __initconst = {
+static const struct gpio edb7211_gpios[] __initconst = {
 	{ EDB7211_LCD_DC_DC_EN,	GPIOF_OUT_INIT_LOW,	"LCD DC-DC" },
 	{ EDB7211_LCDEN,	GPIOF_OUT_INIT_LOW,	"LCD POWER" },
 	{ EDB7211_LCDBL,	GPIOF_OUT_INIT_LOW,	"LCD BACKLIGHT" },
diff --git a/arch/arm/mach-clps711x/board-p720t.c b/arch/arm/mach-clps711x/board-p720t.c
index dd81b06..55ef42d 100644
--- a/arch/arm/mach-clps711x/board-p720t.c
+++ b/arch/arm/mach-clps711x/board-p720t.c
@@ -155,7 +155,7 @@
 #define PLD_GPIO1		(PLD_GPIO_MMGPIO_BASE + 1)
 #define PLD_GPIO0		(PLD_GPIO_MMGPIO_BASE + 0)
 
-static struct gpio p720t_gpios[] __initconst = {
+static const struct gpio p720t_gpios[] __initconst = {
 	{ PLD_S1_ON,	GPIOF_OUT_INIT_LOW,	"PLD_S1_ON" },
 	{ PLD_S2_ON,	GPIOF_OUT_INIT_LOW,	"PLD_S2_ON" },
 	{ PLD_S3_ON,	GPIOF_OUT_INIT_LOW,	"PLD_S3_ON" },
diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index e38b279..0be9bbd 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -307,7 +307,7 @@ static struct usb_ohci_pdata cns3xxx_usb_ohci_pdata = {
 	.power_off	= csn3xxx_usb_power_off,
 };
 
-static struct of_dev_auxdata cns3xxx_auxdata[] __initconst = {
+static const struct of_dev_auxdata cns3xxx_auxdata[] __initconst = {
 	{ "intel,usb-ehci", CNS3XXX_USB_BASE, "ehci-platform", &cns3xxx_usb_ehci_pdata },
 	{ "intel,usb-ohci", CNS3XXX_USB_OHCI_BASE, "ohci-platform", &cns3xxx_usb_ohci_pdata },
 	{ "cavium,cns3420-ahci", CNS3XXX_SATA2_BASE, "ahci", NULL },
@@ -360,7 +360,7 @@ static void __init cns3xxx_init(void)
                         cns3xxx_auxdata, NULL);
 }
 
-static const char *cns3xxx_dt_compat[] __initdata = {
+static const char *cns3xxx_dt_compat[] __initconst = {
 	"cavium,cns3410",
 	"cavium,cns3420",
 	NULL,
diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 42b23a3..526dc2a 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -361,7 +361,7 @@ static struct spi_eeprom at25640a = {
 	.flags		= EE_ADDR2,
 };
 
-static struct spi_board_info dm355_evm_spi_info[] __initconst = {
+static const struct spi_board_info dm355_evm_spi_info[] __initconst = {
 	{
 		.modalias	= "at25",
 		.platform_data	= &at25640a,
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index 65a984c..440df2a 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -220,7 +220,7 @@ static struct spi_eeprom at25640a = {
 	.flags		= EE_ADDR2,
 };
 
-static struct spi_board_info dm355_leopard_spi_info[] __initconst = {
+static const struct spi_board_info dm355_leopard_spi_info[] __initconst = {
 	{
 		.modalias	= "at25",
 		.platform_data	= &at25640a,
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 92b7f77..73516bd 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -730,7 +730,7 @@ static struct spi_eeprom at25640 = {
 	.flags		= EE_ADDR2,
 };
 
-static struct spi_board_info dm365_evm_spi_info[] __initconst = {
+static const struct spi_board_info dm365_evm_spi_info[] __initconst = {
 	{
 		.modalias	= "at25",
 		.platform_data	= &at25640,
diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index 78ea395..14db8d0 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -147,7 +147,7 @@ static struct davinci_nand_pdata nand_config = {
 	.ecc_bits	= 1,
 };
 
-static struct davinci_uart_config serial_config __initconst = {
+static const struct davinci_uart_config serial_config __initconst = {
 	.enabled_uarts	= BIT(1),
 };
 
@@ -245,7 +245,7 @@ static struct ti_ssp_data ssp_config = {
 	},
 };
 
-static struct tnetv107x_device_info evm_device_info __initconst = {
+static const struct tnetv107x_device_info evm_device_info __initconst = {
 	.serial_config		= &serial_config,
 	.mmc_config[1]		= &mmc_config,	/* controller 1 */
 	.nand_config[0]		= &nand_config,	/* chip select 0 */
@@ -253,7 +253,7 @@ static struct tnetv107x_device_info evm_device_info __initconst = {
 	.ssp_config		= &ssp_config,
 };
 
-static struct spi_board_info spi_info[] __initconst = {
+static const struct spi_board_info spi_info[] __initconst = {
 };
 
 static __init void tnetv107x_evm_board_init(void)
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index f56e5fb..4bcbaa5 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -714,7 +714,7 @@ const short da850_lcdcntl_pins[] __initconst = {
 	-1
 };
 
-const short da850_vpif_capture_pins[] __initdata = {
+const short da850_vpif_capture_pins[] __initconst = {
 	DA850_VPIF_DIN0, DA850_VPIF_DIN1, DA850_VPIF_DIN2, DA850_VPIF_DIN3,
 	DA850_VPIF_DIN4, DA850_VPIF_DIN5, DA850_VPIF_DIN6, DA850_VPIF_DIN7,
 	DA850_VPIF_DIN8, DA850_VPIF_DIN9, DA850_VPIF_DIN10, DA850_VPIF_DIN11,
@@ -724,7 +724,7 @@ const short da850_vpif_capture_pins[] __initdata = {
 	-1
 };
 
-const short da850_vpif_display_pins[] __initdata = {
+const short da850_vpif_display_pins[] __initconst = {
 	DA850_VPIF_DOUT0, DA850_VPIF_DOUT1, DA850_VPIF_DOUT2, DA850_VPIF_DOUT3,
 	DA850_VPIF_DOUT4, DA850_VPIF_DOUT5, DA850_VPIF_DOUT6, DA850_VPIF_DOUT7,
 	DA850_VPIF_DOUT8, DA850_VPIF_DOUT9, DA850_VPIF_DOUT10,
diff --git a/arch/arm/mach-davinci/da8xx-dt.c b/arch/arm/mach-davinci/da8xx-dt.c
index d2bc574..da6e634 100644
--- a/arch/arm/mach-davinci/da8xx-dt.c
+++ b/arch/arm/mach-davinci/da8xx-dt.c
@@ -58,7 +58,7 @@ static void __init da850_init_machine(void)
 
 }
 
-static const char *da850_boards_compat[] __initdata = {
+static const char *da850_boards_compat[] __initconst = {
 	"enbw,cmc",
 	"ti,da850-evm",
 	"ti,da850",
diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
index 0099c6c..255b7d0 100644
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@ -28,7 +28,7 @@ static void __init exynos4_dt_machine_init(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static char const *exynos4_dt_compat[] __initdata = {
+static char const *exynos4_dt_compat[] __initconst = {
 	"samsung,exynos4210",
 	"samsung,exynos4212",
 	"samsung,exynos4412",
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index f874b77..aa11b03 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -50,7 +50,7 @@ static void __init exynos5_dt_machine_init(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static char const *exynos5_dt_compat[] __initdata = {
+static char const *exynos5_dt_compat[] __initconst = {
 	"samsung,exynos5250",
 	"samsung,exynos5420",
 	"samsung,exynos5440",
diff --git a/arch/arm/mach-imx/imx31-dt.c b/arch/arm/mach-imx/imx31-dt.c
index 818a1cc..e1e70ef 100644
--- a/arch/arm/mach-imx/imx31-dt.c
+++ b/arch/arm/mach-imx/imx31-dt.c
@@ -25,7 +25,7 @@ static void __init imx31_dt_init(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static const char *imx31_dt_board_compat[] __initdata = {
+static const char *imx31_dt_board_compat[] __initconst = {
 	"fsl,imx31",
 	NULL
 };
diff --git a/arch/arm/mach-imx/imx51-dt.c b/arch/arm/mach-imx/imx51-dt.c
index 53e43e5..941c174 100644
--- a/arch/arm/mach-imx/imx51-dt.c
+++ b/arch/arm/mach-imx/imx51-dt.c
@@ -29,7 +29,7 @@ static void __init imx51_dt_init(void)
 	platform_device_register_full(&devinfo);
 }
 
-static const char *imx51_dt_board_compat[] __initdata = {
+static const char *imx51_dt_board_compat[] __initconst = {
 	"fsl,imx51",
 	NULL
 };
diff --git a/arch/arm/mach-imx/mach-imx53.c b/arch/arm/mach-imx/mach-imx53.c
index 98c5894..3930264 100644
--- a/arch/arm/mach-imx/mach-imx53.c
+++ b/arch/arm/mach-imx/mach-imx53.c
@@ -31,7 +31,7 @@ static void __init imx53_dt_init(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static const char *imx53_dt_board_compat[] __initdata = {
+static const char *imx53_dt_board_compat[] __initconst = {
 	"fsl,imx53",
 	NULL
 };
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 85a1b51..ac5b540 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -296,7 +296,7 @@ static void __init imx6q_timer_init(void)
 			      imx6q_revision());
 }
 
-static const char *imx6q_dt_compat[] __initdata = {
+static const char *imx6q_dt_compat[] __initconst = {
 	"fsl,imx6dl",
 	"fsl,imx6q",
 	NULL,
diff --git a/arch/arm/mach-imx/mach-imx6sl.c b/arch/arm/mach-imx/mach-imx6sl.c
index 892b629..0469de4f 100644
--- a/arch/arm/mach-imx/mach-imx6sl.c
+++ b/arch/arm/mach-imx/mach-imx6sl.c
@@ -57,7 +57,7 @@ static void __init imx6sl_timer_init(void)
 	of_clk_init(NULL);
 }
 
-static const char *imx6sl_dt_compat[] __initdata = {
+static const char *imx6sl_dt_compat[] __initconst = {
 	"fsl,imx6sl",
 	NULL,
 };
diff --git a/arch/arm/mach-imx/mach-vf610.c b/arch/arm/mach-imx/mach-vf610.c
index 816991d..42fa42d 100644
--- a/arch/arm/mach-imx/mach-vf610.c
+++ b/arch/arm/mach-imx/mach-vf610.c
@@ -34,7 +34,7 @@ static void __init vf610_init_time(void)
 	clocksource_of_init();
 }
 
-static const char *vf610_dt_compat[] __initdata = {
+static const char *vf610_dt_compat[] __initconst = {
 	"fsl,vf610",
 	NULL,
 };
diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index e54f87e..77a3e59 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -251,7 +251,7 @@ static void __init lpc3250_machine_init(void)
 			     lpc32xx_auxdata_lookup, NULL);
 }
 
-static char const *lpc32xx_dt_compat[] __initdata = {
+static char const *lpc32xx_dt_compat[] __initconst = {
 	"nxp,lpc3220",
 	"nxp,lpc3230",
 	"nxp,lpc3240",
diff --git a/arch/arm/mach-mmp/mmp-dt.c b/arch/arm/mach-mmp/mmp-dt.c
index cca529c..46e70e2 100644
--- a/arch/arm/mach-mmp/mmp-dt.c
+++ b/arch/arm/mach-mmp/mmp-dt.c
@@ -52,7 +52,7 @@ static void __init pxa910_dt_init(void)
 			     pxa910_auxdata_lookup, NULL);
 }
 
-static const char *mmp_dt_board_compat[] __initdata = {
+static const char *mmp_dt_board_compat[] __initconst = {
 	"mrvl,pxa168-aspenite",
 	"mrvl,pxa910-dkb",
 	NULL,
diff --git a/arch/arm/mach-mmp/mmp2-dt.c b/arch/arm/mach-mmp/mmp2-dt.c
index 023cb45..5106a7d 100644
--- a/arch/arm/mach-mmp/mmp2-dt.c
+++ b/arch/arm/mach-mmp/mmp2-dt.c
@@ -37,7 +37,7 @@ static void __init mmp2_dt_init(void)
 			     mmp2_auxdata_lookup, NULL);
 }
 
-static const char *mmp2_dt_board_compat[] __initdata = {
+static const char *mmp2_dt_board_compat[] __initconst = {
 	"mrvl,mmp2-brownstone",
 	NULL,
 };
diff --git a/arch/arm/mach-msm/board-dt-8660.c b/arch/arm/mach-msm/board-dt-8660.c
index c294689..6758562 100644
--- a/arch/arm/mach-msm/board-dt-8660.c
+++ b/arch/arm/mach-msm/board-dt-8660.c
@@ -34,7 +34,7 @@ static void __init msm8x60_dt_init(void)
 			msm_auxdata_lookup, NULL);
 }
 
-static const char *msm8x60_fluid_match[] __initdata = {
+static const char *msm8x60_fluid_match[] __initconst = {
 	"qcom,msm8660-fluid",
 	"qcom,msm8660-surf",
 	NULL
diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 98f6e2a..96f9264 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -500,7 +500,7 @@ static void __init mxs_timer_init(void)
 	clocksource_of_init();
 }
 
-static const char *mxs_dt_compat[] __initdata = {
+static const char *mxs_dt_compat[] __initconst = {
 	"fsl,imx28",
 	"fsl,imx23",
 	NULL,
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 39c7838..96cdec7 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -73,7 +73,7 @@ static void __init omap_generic_init(void)
 }
 
 #ifdef CONFIG_SOC_OMAP2420
-static const char *omap242x_boards_compat[] __initdata = {
+static const char *omap242x_boards_compat[] __initconst = {
 	"ti,omap2420",
 	NULL,
 };
@@ -92,7 +92,7 @@ MACHINE_END
 #endif
 
 #ifdef CONFIG_SOC_OMAP2430
-static const char *omap243x_boards_compat[] __initdata = {
+static const char *omap243x_boards_compat[] __initconst = {
 	"ti,omap2430",
 	NULL,
 };
@@ -111,7 +111,7 @@ MACHINE_END
 #endif
 
 #ifdef CONFIG_ARCH_OMAP3
-static const char *omap3_boards_compat[] __initdata = {
+static const char *omap3_boards_compat[] __initconst = {
 	"ti,omap3",
 	NULL,
 };
@@ -129,7 +129,7 @@ DT_MACHINE_START(OMAP3_DT, "Generic OMAP3 (Flattened Device Tree)")
 	.restart	= omap3xxx_restart,
 MACHINE_END
 
-static const char *omap3_gp_boards_compat[] __initdata = {
+static const char *omap3_gp_boards_compat[] __initconst = {
 	"ti,omap3-beagle",
 	"timll,omap3-devkit8000",
 	NULL,
@@ -150,7 +150,7 @@ MACHINE_END
 #endif
 
 #ifdef CONFIG_SOC_AM33XX
-static const char *am33xx_boards_compat[] __initdata = {
+static const char *am33xx_boards_compat[] __initconst = {
 	"ti,am33xx",
 	NULL,
 };
@@ -169,7 +169,7 @@ MACHINE_END
 #endif
 
 #ifdef CONFIG_ARCH_OMAP4
-static const char *omap4_boards_compat[] __initdata = {
+static const char *omap4_boards_compat[] __initconst = {
 	"ti,omap4",
 	NULL,
 };
@@ -189,7 +189,7 @@ MACHINE_END
 #endif
 
 #ifdef CONFIG_SOC_OMAP5
-static const char *omap5_boards_compat[] __initdata = {
+static const char *omap5_boards_compat[] __initconst = {
 	"ti,omap5",
 	NULL,
 };
@@ -208,7 +208,7 @@ MACHINE_END
 #endif
 
 #ifdef CONFIG_SOC_AM43XX
-static const char *am43_boards_compat[] __initdata = {
+static const char *am43_boards_compat[] __initconst = {
 	"ti,am43",
 	NULL,
 };
@@ -224,7 +224,7 @@ MACHINE_END
 #endif
 
 #ifdef CONFIG_SOC_DRA7XX
-static const char *dra7xx_boards_compat[] __initdata = {
+static const char *dra7xx_boards_compat[] __initconst = {
 	"ti,dra7",
 	NULL,
 };
diff --git a/arch/arm/mach-omap2/vc.c b/arch/arm/mach-omap2/vc.c
index 49ac797..f8198f9 100644
--- a/arch/arm/mach-omap2/vc.c
+++ b/arch/arm/mach-omap2/vc.c
@@ -482,7 +482,7 @@ struct i2c_init_data {
 	u8 hsscll_12;
 };
 
-static const __initdata struct i2c_init_data omap4_i2c_timing_data[] = {
+static const struct i2c_init_data omap4_i2c_timing_data[] __initconst = {
 	{
 		.load = 50,
 		.loadbits = 0x3,
diff --git a/arch/arm/mach-omap2/voltagedomains3xxx_data.c b/arch/arm/mach-omap2/voltagedomains3xxx_data.c
index 261bb7c..99c222e 100644
--- a/arch/arm/mach-omap2/voltagedomains3xxx_data.c
+++ b/arch/arm/mach-omap2/voltagedomains3xxx_data.c
@@ -95,7 +95,7 @@ static struct voltagedomain *voltagedomains_am35xx[] __initdata = {
 };
 
 
-static const char *sys_clk_name __initdata = "sys_ck";
+static const char *sys_clk_name __initconst = "sys_ck";
 
 void __init omap3xxx_voltagedomains_init(void)
 {
diff --git a/arch/arm/mach-omap2/voltagedomains44xx_data.c b/arch/arm/mach-omap2/voltagedomains44xx_data.c
index 48b22a0..c98c36f 100644
--- a/arch/arm/mach-omap2/voltagedomains44xx_data.c
+++ b/arch/arm/mach-omap2/voltagedomains44xx_data.c
@@ -92,7 +92,7 @@ static struct voltagedomain *voltagedomains_omap4[] __initdata = {
 	NULL,
 };
 
-static const char *sys_clk_name __initdata = "sys_clkin_ck";
+static const char *sys_clk_name __initconst = "sys_clkin_ck";
 
 void __init omap44xx_voltagedomains_init(void)
 {
diff --git a/arch/arm/mach-omap2/voltagedomains54xx_data.c b/arch/arm/mach-omap2/voltagedomains54xx_data.c
index 33d22b8..953d7c1 100644
--- a/arch/arm/mach-omap2/voltagedomains54xx_data.c
+++ b/arch/arm/mach-omap2/voltagedomains54xx_data.c
@@ -78,7 +78,7 @@ static struct voltagedomain *voltagedomains_omap5[] __initdata = {
 	NULL,
 };
 
-static const char *sys_clk_name __initdata = "sys_clkin";
+static const char *sys_clk_name __initconst = "sys_clkin";
 
 void __init omap54xx_voltagedomains_init(void)
 {
diff --git a/arch/arm/mach-prima2/common.c b/arch/arm/mach-prima2/common.c
index e110b6d..e1fffdf 100644
--- a/arch/arm/mach-prima2/common.c
+++ b/arch/arm/mach-prima2/common.c
@@ -35,7 +35,7 @@ static __init void sirfsoc_map_io(void)
 }
 
 #ifdef CONFIG_ARCH_ATLAS6
-static const char *atlas6_dt_match[] __initdata = {
+static const char *atlas6_dt_match[] __initconst = {
 	"sirf,atlas6",
 	NULL
 };
@@ -51,7 +51,7 @@ MACHINE_END
 #endif
 
 #ifdef CONFIG_ARCH_PRIMA2
-static const char *prima2_dt_match[] __initdata = {
+static const char *prima2_dt_match[] __initconst = {
 	"sirf,prima2",
 	NULL
 };
@@ -68,7 +68,7 @@ MACHINE_END
 #endif
 
 #ifdef CONFIG_ARCH_MARCO
-static const char *marco_dt_match[] __initdata = {
+static const char *marco_dt_match[] __initconst = {
 	"sirf,marco",
 	NULL
 };
diff --git a/arch/arm/mach-prima2/l2x0.c b/arch/arm/mach-prima2/l2x0.c
index cbcbe9c..6b13096 100644
--- a/arch/arm/mach-prima2/l2x0.c
+++ b/arch/arm/mach-prima2/l2x0.c
@@ -17,18 +17,18 @@ struct l2x0_aux
 	u32 mask;
 };
 
-static struct l2x0_aux prima2_l2x0_aux __initconst = {
+static const struct l2x0_aux prima2_l2x0_aux __initconst = {
 	.val = 2 << L2X0_AUX_CTRL_WAY_SIZE_SHIFT,
 	.mask =	0,
 };
 
-static struct l2x0_aux marco_l2x0_aux __initconst = {
+static const struct l2x0_aux marco_l2x0_aux __initconst = {
 	.val = (2 << L2X0_AUX_CTRL_WAY_SIZE_SHIFT) |
 		(1 << L2X0_AUX_CTRL_ASSOCIATIVITY_SHIFT),
 	.mask = L2X0_AUX_CTRL_MASK,
 };
 
-static struct of_device_id sirf_l2x0_ids[] __initconst = {
+static const struct of_device_id sirf_l2x0_ids[] __initconst = {
 	{ .compatible = "sirf,prima2-pl310-cache", .data = &prima2_l2x0_aux, },
 	{ .compatible = "sirf,marco-pl310-cache", .data = &marco_l2x0_aux, },
 	{},
diff --git a/arch/arm/mach-pxa/pxa-dt.c b/arch/arm/mach-pxa/pxa-dt.c
index f6a2c4b..67124a9 100644
--- a/arch/arm/mach-pxa/pxa-dt.c
+++ b/arch/arm/mach-pxa/pxa-dt.c
@@ -42,7 +42,7 @@ static void __init pxa3xx_dt_init(void)
 			     pxa3xx_auxdata_lookup, NULL);
 }
 
-static const char *pxa3xx_dt_board_compat[] __initdata = {
+static const char *pxa3xx_dt_board_compat[] __initconst = {
 	"marvell,pxa300",
 	"marvell,pxa310",
 	"marvell,pxa320",
diff --git a/arch/arm/mach-s3c24xx/mach-s3c2416-dt.c b/arch/arm/mach-s3c24xx/mach-s3c2416-dt.c
index f50454a..d0ee002 100644
--- a/arch/arm/mach-s3c24xx/mach-s3c2416-dt.c
+++ b/arch/arm/mach-s3c24xx/mach-s3c2416-dt.c
@@ -74,7 +74,7 @@ static void __init s3c2416_dt_machine_init(void)
 	s3c_pm_init();
 }
 
-static char const *s3c2416_dt_compat[] __initdata = {
+static char const *s3c2416_dt_compat[] __initconst = {
 	"samsung,s3c2416",
 	"samsung,s3c2450",
 	NULL
diff --git a/arch/arm/mach-shmobile/board-ape6evm-reference.c b/arch/arm/mach-shmobile/board-ape6evm-reference.c
index a23fa71..fe7b786 100644
--- a/arch/arm/mach-shmobile/board-ape6evm-reference.c
+++ b/arch/arm/mach-shmobile/board-ape6evm-reference.c
@@ -51,7 +51,7 @@ static void __init ape6evm_add_standard_devices(void)
 	platform_device_register_simple("cpufreq-cpu0", -1, NULL, 0);
 }
 
-static const char *ape6evm_boards_compat_dt[] __initdata = {
+static const char *ape6evm_boards_compat_dt[] __initconst = {
 	"renesas,ape6evm-reference",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-ape6evm.c b/arch/arm/mach-shmobile/board-ape6evm.c
index 24b87eea..9af59b5 100644
--- a/arch/arm/mach-shmobile/board-ape6evm.c
+++ b/arch/arm/mach-shmobile/board-ape6evm.c
@@ -234,7 +234,7 @@ static void __init ape6evm_add_standard_devices(void)
 				      sizeof(ape6evm_leds_pdata));
 }
 
-static const char *ape6evm_boards_compat_dt[] __initdata = {
+static const char *ape6evm_boards_compat_dt[] __initconst = {
 	"renesas,ape6evm",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-armadillo800eva-reference.c b/arch/arm/mach-shmobile/board-armadillo800eva-reference.c
index 57d1a78..9c04f77 100644
--- a/arch/arm/mach-shmobile/board-armadillo800eva-reference.c
+++ b/arch/arm/mach-shmobile/board-armadillo800eva-reference.c
@@ -180,7 +180,7 @@ static void eva_restart(enum reboot_mode mode, const char *cmd)
 	writel(1 << 31, RESCNT2);
 }
 
-static const char *eva_boards_compat_dt[] __initdata = {
+static const char *eva_boards_compat_dt[] __initconst = {
 	"renesas,armadillo800eva-reference",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-armadillo800eva.c b/arch/arm/mach-shmobile/board-armadillo800eva.c
index 5bd1479..d0d0303 100644
--- a/arch/arm/mach-shmobile/board-armadillo800eva.c
+++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
@@ -1305,7 +1305,7 @@ static void eva_restart(enum reboot_mode mode, const char *cmd)
 	writel((1 << 31), RESCNT2);
 }
 
-static const char *eva_boards_compat_dt[] __initdata = {
+static const char *eva_boards_compat_dt[] __initconst = {
 	"renesas,armadillo800eva",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-bockw-reference.c b/arch/arm/mach-shmobile/board-bockw-reference.c
index 1a7c893..5646942 100644
--- a/arch/arm/mach-shmobile/board-bockw-reference.c
+++ b/arch/arm/mach-shmobile/board-bockw-reference.c
@@ -48,7 +48,7 @@ static void __init bockw_init(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static const char *bockw_boards_compat_dt[] __initdata = {
+static const char *bockw_boards_compat_dt[] __initconst = {
 	"renesas,bockw-reference",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-bockw.c b/arch/arm/mach-shmobile/board-bockw.c
index 6b9faf3..28fae43 100644
--- a/arch/arm/mach-shmobile/board-bockw.c
+++ b/arch/arm/mach-shmobile/board-bockw.c
@@ -310,7 +310,7 @@ static void __init bockw_init(void)
 	}
 }
 
-static const char *bockw_boards_compat_dt[] __initdata = {
+static const char *bockw_boards_compat_dt[] __initconst = {
 	"renesas,bockw",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-kzm9d-reference.c b/arch/arm/mach-shmobile/board-kzm9d-reference.c
index 8f8bb2f..9a9fc47 100644
--- a/arch/arm/mach-shmobile/board-kzm9d-reference.c
+++ b/arch/arm/mach-shmobile/board-kzm9d-reference.c
@@ -32,7 +32,7 @@ static void __init kzm9d_add_standard_devices(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static const char *kzm9d_boards_compat_dt[] __initdata = {
+static const char *kzm9d_boards_compat_dt[] __initconst = {
 	"renesas,kzm9d-reference",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-kzm9d.c b/arch/arm/mach-shmobile/board-kzm9d.c
index 30c2cc6..076287b 100644
--- a/arch/arm/mach-shmobile/board-kzm9d.c
+++ b/arch/arm/mach-shmobile/board-kzm9d.c
@@ -77,7 +77,7 @@ void __init kzm9d_add_standard_devices(void)
 	platform_add_devices(kzm9d_devices, ARRAY_SIZE(kzm9d_devices));
 }
 
-static const char *kzm9d_boards_compat_dt[] __initdata = {
+static const char *kzm9d_boards_compat_dt[] __initconst = {
 	"renesas,kzm9d",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-kzm9g-reference.c b/arch/arm/mach-shmobile/board-kzm9g-reference.c
index 598e324..6a7d134 100644
--- a/arch/arm/mach-shmobile/board-kzm9g-reference.c
+++ b/arch/arm/mach-shmobile/board-kzm9g-reference.c
@@ -41,7 +41,7 @@ static void __init kzm_init(void)
 #endif
 }
 
-static const char *kzm9g_boards_compat_dt[] __initdata = {
+static const char *kzm9g_boards_compat_dt[] __initconst = {
 	"renesas,kzm9g-reference",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-kzm9g.c b/arch/arm/mach-shmobile/board-kzm9g.c
index f199496..a1c1a94 100644
--- a/arch/arm/mach-shmobile/board-kzm9g.c
+++ b/arch/arm/mach-shmobile/board-kzm9g.c
@@ -898,7 +898,7 @@ static void kzm9g_restart(enum reboot_mode mode, const char *cmd)
 	writel((1 << 31), RESCNT2);
 }
 
-static const char *kzm9g_boards_compat_dt[] __initdata = {
+static const char *kzm9g_boards_compat_dt[] __initconst = {
 	"renesas,kzm9g",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-lager-reference.c b/arch/arm/mach-shmobile/board-lager-reference.c
index 9c316a1..ea2ce09 100644
--- a/arch/arm/mach-shmobile/board-lager-reference.c
+++ b/arch/arm/mach-shmobile/board-lager-reference.c
@@ -32,7 +32,7 @@ static void __init lager_add_standard_devices(void)
         of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static const char *lager_boards_compat_dt[] __initdata = {
+static const char *lager_boards_compat_dt[] __initconst = {
 	"renesas,lager-reference",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-lager.c b/arch/arm/mach-shmobile/board-lager.c
index ffb6f0a..528f8eb 100644
--- a/arch/arm/mach-shmobile/board-lager.c
+++ b/arch/arm/mach-shmobile/board-lager.c
@@ -155,7 +155,7 @@ static void __init lager_add_standard_devices(void)
 					  &ether_pdata, sizeof(ether_pdata));
 }
 
-static const char *lager_boards_compat_dt[] __initdata = {
+static const char *lager_boards_compat_dt[] __initconst = {
 	"renesas,lager",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index af06753..add32da 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -1505,7 +1505,7 @@ static void __init mackerel_init(void)
 	pm_clk_add(&hdmi_lcdc_device.dev, "hdmi");
 }
 
-static const char *mackerel_boards_compat_dt[] __initdata = {
+static const char *mackerel_boards_compat_dt[] __initconst = {
 	"renesas,mackerel",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-marzen-reference.c b/arch/arm/mach-shmobile/board-marzen-reference.c
index 3f4250a..a1eef1e 100644
--- a/arch/arm/mach-shmobile/board-marzen-reference.c
+++ b/arch/arm/mach-shmobile/board-marzen-reference.c
@@ -30,7 +30,7 @@ static void __init marzen_init(void)
 	r8a7779_add_standard_devices_dt();
 }
 
-static const char *marzen_boards_compat_dt[] __initdata = {
+static const char *marzen_boards_compat_dt[] __initconst = {
 	"renesas,marzen-reference",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/board-marzen.c b/arch/arm/mach-shmobile/board-marzen.c
index 3f5044f..9e79529 100644
--- a/arch/arm/mach-shmobile/board-marzen.c
+++ b/arch/arm/mach-shmobile/board-marzen.c
@@ -299,7 +299,7 @@ static void __init marzen_init(void)
 	platform_add_devices(marzen_devices, ARRAY_SIZE(marzen_devices));
 }
 
-static const char *marzen_boards_compat_dt[] __initdata = {
+static const char *marzen_boards_compat_dt[] __initconst = {
         "renesas,marzen",
         NULL,
 };
diff --git a/arch/arm/mach-shmobile/setup-emev2.c b/arch/arm/mach-shmobile/setup-emev2.c
index 3ad531c..b9370352d 100644
--- a/arch/arm/mach-shmobile/setup-emev2.c
+++ b/arch/arm/mach-shmobile/setup-emev2.c
@@ -197,7 +197,7 @@ void __init emev2_init_delay(void)
 
 #ifdef CONFIG_USE_OF
 
-static const char *emev2_boards_compat_dt[] __initdata = {
+static const char *emev2_boards_compat_dt[] __initconst = {
 	"renesas,emev2",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/setup-r8a73a4.c b/arch/arm/mach-shmobile/setup-r8a73a4.c
index 8949170..aa2cd5c 100644
--- a/arch/arm/mach-shmobile/setup-r8a73a4.c
+++ b/arch/arm/mach-shmobile/setup-r8a73a4.c
@@ -216,7 +216,7 @@ void __init r8a73a4_init_delay(void)
 
 #ifdef CONFIG_USE_OF
 
-static const char *r8a73a4_boards_compat_dt[] __initdata = {
+static const char *r8a73a4_boards_compat_dt[] __initconst = {
 	"renesas,r8a73a4",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/setup-r8a7740.c b/arch/arm/mach-shmobile/setup-r8a7740.c
index b7d4b2c..d450b32 100644
--- a/arch/arm/mach-shmobile/setup-r8a7740.c
+++ b/arch/arm/mach-shmobile/setup-r8a7740.c
@@ -1057,7 +1057,7 @@ static void __init r8a7740_generic_init(void)
 	r8a7740_add_standard_devices_dt();
 }
 
-static const char *r8a7740_boards_compat_dt[] __initdata = {
+static const char *r8a7740_boards_compat_dt[] __initconst = {
 	"renesas,r8a7740",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/setup-r8a7778.c b/arch/arm/mach-shmobile/setup-r8a7778.c
index 6a2657e..93be360 100644
--- a/arch/arm/mach-shmobile/setup-r8a7778.c
+++ b/arch/arm/mach-shmobile/setup-r8a7778.c
@@ -432,7 +432,7 @@ void __init r8a7778_init_irq_dt(void)
 	iounmap(base);
 }
 
-static const char *r8a7778_compat_dt[] __initdata = {
+static const char *r8a7778_compat_dt[] __initconst = {
 	"renesas,r8a7778",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/setup-r8a7779.c b/arch/arm/mach-shmobile/setup-r8a7779.c
index ecd0148..ec5925a 100644
--- a/arch/arm/mach-shmobile/setup-r8a7779.c
+++ b/arch/arm/mach-shmobile/setup-r8a7779.c
@@ -773,7 +773,7 @@ void __init r8a7779_add_standard_devices_dt(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static const char *r8a7779_compat_dt[] __initdata = {
+static const char *r8a7779_compat_dt[] __initconst = {
 	"renesas,r8a7779",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/setup-r8a7790.c b/arch/arm/mach-shmobile/setup-r8a7790.c
index d0f5c9f..a50c807e6 100644
--- a/arch/arm/mach-shmobile/setup-r8a7790.c
+++ b/arch/arm/mach-shmobile/setup-r8a7790.c
@@ -276,7 +276,7 @@ void __init r8a7790_init_delay(void)
 
 #ifdef CONFIG_USE_OF
 
-static const char *r8a7790_boards_compat_dt[] __initdata = {
+static const char *r8a7790_boards_compat_dt[] __initconst = {
 	"renesas,r8a7790",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index 3118783..9cea7fa 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -1157,7 +1157,7 @@ void __init sh7372_add_standard_devices_dt(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static const char *sh7372_boards_compat_dt[] __initdata = {
+static const char *sh7372_boards_compat_dt[] __initconst = {
 	"renesas,sh7372",
 	NULL,
 };
diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index 22de174..989fcd9 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -958,7 +958,7 @@ void __init sh73a0_add_standard_devices_dt(void)
 	platform_device_register_full(&devinfo);
 }
 
-static const char *sh73a0_boards_compat_dt[] __initdata = {
+static const char *sh73a0_boards_compat_dt[] __initconst = {
 	"renesas,sh73a0",
 	NULL,
 };
diff --git a/arch/arm/mach-sti/board-dt.c b/arch/arm/mach-sti/board-dt.c
index 8fe6f0c..be05514 100644
--- a/arch/arm/mach-sti/board-dt.c
+++ b/arch/arm/mach-sti/board-dt.c
@@ -35,7 +35,7 @@ static void __init stih41x_timer_init(void)
 	stih41x_l2x0_init();
 }
 
-static const char *stih41x_dt_match[] __initdata = {
+static const char *stih41x_dt_match[] __initconst = {
 	"st,stih415",
 	"st,stih416",
 	NULL
diff --git a/arch/metag/kernel/machines.c b/arch/metag/kernel/machines.c
index 1edf6ba..c6e6006 100644
--- a/arch/metag/kernel/machines.c
+++ b/arch/metag/kernel/machines.c
@@ -10,7 +10,7 @@
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 
-static const char *meta_boards_compat[] __initdata = {
+static const char *meta_boards_compat[] __initconst = {
 	"img,meta",
 	NULL,
 };
diff --git a/arch/mips/ath79/pci.c b/arch/mips/ath79/pci.c
index 730c0b0..67f2b81 100644
--- a/arch/mips/ath79/pci.c
+++ b/arch/mips/ath79/pci.c
@@ -22,7 +22,7 @@
 #include "pci.h"
 
 static int (*ath79_pci_plat_dev_init)(struct pci_dev *dev);
-static const struct ath79_pci_irq *ath79_pci_irq_map __initdata;
+static const struct ath79_pci_irq *ath79_pci_irq_map __initconst;
 static unsigned ath79_pci_nr_irqs __initdata;
 
 static const struct ath79_pci_irq ar71xx_pci_irq_map[] __initconst = {
diff --git a/arch/powerpc/platforms/52xx/mpc5200_simple.c b/arch/powerpc/platforms/52xx/mpc5200_simple.c
index 792a301..849ba67 100644
--- a/arch/powerpc/platforms/52xx/mpc5200_simple.c
+++ b/arch/powerpc/platforms/52xx/mpc5200_simple.c
@@ -49,7 +49,7 @@ static void __init mpc5200_simple_setup_arch(void)
 }
 
 /* list of the supported boards */
-static const char *board[] __initdata = {
+static const char *board[] __initconst = {
 	"anonymous,a3m071",
 	"anonymous,a4m072",
 	"anon,charon",
diff --git a/arch/powerpc/platforms/83xx/mpc830x_rdb.c b/arch/powerpc/platforms/83xx/mpc830x_rdb.c
index 4f2d9fe..3327ab9 100644
--- a/arch/powerpc/platforms/83xx/mpc830x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc830x_rdb.c
@@ -34,7 +34,7 @@ static void __init mpc830x_rdb_setup_arch(void)
 	mpc831x_usb_cfg();
 }
 
-static const char *board[] __initdata = {
+static const char *board[] __initconst = {
 	"MPC8308RDB",
 	"fsl,mpc8308rdb",
 	"denx,mpc8308_p1m",
diff --git a/arch/powerpc/platforms/83xx/mpc831x_rdb.c b/arch/powerpc/platforms/83xx/mpc831x_rdb.c
index fa25977..067d3f0 100644
--- a/arch/powerpc/platforms/83xx/mpc831x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc831x_rdb.c
@@ -35,7 +35,7 @@ static void __init mpc831x_rdb_setup_arch(void)
 	mpc831x_usb_cfg();
 }
 
-static const char *board[] __initdata = {
+static const char *board[] __initconst = {
 	"MPC8313ERDB",
 	"fsl,mpc8315erdb",
 	NULL
diff --git a/arch/powerpc/sysdev/xilinx_intc.c b/arch/powerpc/sysdev/xilinx_intc.c
index 8d73c3c..7ae7e80 100644
--- a/arch/powerpc/sysdev/xilinx_intc.c
+++ b/arch/powerpc/sysdev/xilinx_intc.c
@@ -263,7 +263,7 @@ static void __init xilinx_i8259_setup_cascade(void)
 static inline void xilinx_i8259_setup_cascade(void) { return; }
 #endif /* defined(CONFIG_PPC_I8259) */
 
-static struct of_device_id xilinx_intc_match[] __initconst = {
+static const struct of_device_id xilinx_intc_match[] __initconst = {
 	{ .compatible = "xlnx,opb-intc-1.00.c", },
 	{ .compatible = "xlnx,xps-intc-1.00.a", },
 	{}
diff --git a/drivers/clk/samsung/clk.h b/drivers/clk/samsung/clk.h
index 31b4174..ed8cef9 100644
--- a/drivers/clk/samsung/clk.h
+++ b/drivers/clk/samsung/clk.h
@@ -252,7 +252,7 @@ struct samsung_gate_clock {
 #define GATE_DA(_id, dname, cname, pname, o, b, f, gf, a)	\
 	__GATE(_id, dname, cname, pname, o, b, f, gf, a)
 
-#define PNAME(x) static const char *x[] __initdata
+#define PNAME(x) static const char *x[] __initconst
 
 /**
  * struct samsung_clk_reg_dump: register dump of clock controller registers.
diff --git a/drivers/clk/versatile/clk-integrator.c b/drivers/clk/versatile/clk-integrator.c
index 08593b4..8d57f07 100644
--- a/drivers/clk/versatile/clk-integrator.c
+++ b/drivers/clk/versatile/clk-integrator.c
@@ -35,7 +35,7 @@ static const struct icst_params cp_auxvco_params = {
 	.idx2s		= icst525_idx2s,
 };
 
-static const struct clk_icst_desc __initdata cp_icst_desc = {
+static const struct clk_icst_desc cp_icst_desc __initconst = {
 	.params = &cp_auxvco_params,
 	.vco_offset = 0x1c,
 	.lock_offset = INTEGRATOR_HDR_LOCK_OFFSET,
diff --git a/drivers/clk/versatile/clk-realview.c b/drivers/clk/versatile/clk-realview.c
index cda07e7..ac9482a 100644
--- a/drivers/clk/versatile/clk-realview.c
+++ b/drivers/clk/versatile/clk-realview.c
@@ -33,13 +33,13 @@ static const struct icst_params realview_oscvco_params = {
 	.idx2s		= icst307_idx2s,
 };
 
-static const struct clk_icst_desc __initdata realview_osc0_desc = {
+static const struct clk_icst_desc realview_osc0_desc __initconst = {
 	.params = &realview_oscvco_params,
 	.vco_offset = REALVIEW_SYS_OSC0_OFFSET,
 	.lock_offset = REALVIEW_SYS_LOCK_OFFSET,
 };
 
-static const struct clk_icst_desc __initdata realview_osc4_desc = {
+static const struct clk_icst_desc realview_osc4_desc __initconst = {
 	.params = &realview_oscvco_params,
 	.vco_offset = REALVIEW_SYS_OSC4_OFFSET,
 	.lock_offset = REALVIEW_SYS_LOCK_OFFSET,
diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index cc40fe6..867c726 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -83,22 +83,22 @@ static DEFINE_SPINLOCK(aperclk_lock);
 
 static const char dummy_nm[] __initconst = "dummy_name";
 
-static const char *armpll_parents[] __initdata = {"armpll_int", "ps_clk"};
-static const char *ddrpll_parents[] __initdata = {"ddrpll_int", "ps_clk"};
-static const char *iopll_parents[] __initdata = {"iopll_int", "ps_clk"};
-static const char *gem0_mux_parents[] __initdata = {"gem0_div1", dummy_nm};
-static const char *gem1_mux_parents[] __initdata = {"gem1_div1", dummy_nm};
-static const char *can0_mio_mux2_parents[] __initdata = {"can0_gate",
+static const char *armpll_parents[] __initconst = {"armpll_int", "ps_clk"};
+static const char *ddrpll_parents[] __initconst = {"ddrpll_int", "ps_clk"};
+static const char *iopll_parents[] __initconst = {"iopll_int", "ps_clk"};
+static const char *gem0_mux_parents[] __initconst = {"gem0_div1", dummy_nm};
+static const char *gem1_mux_parents[] __initconst = {"gem1_div1", dummy_nm};
+static const char *can0_mio_mux2_parents[] __initconst = {"can0_gate",
 	"can0_mio_mux"};
-static const char *can1_mio_mux2_parents[] __initdata = {"can1_gate",
+static const char *can1_mio_mux2_parents[] __initconst = {"can1_gate",
 	"can1_mio_mux"};
-static const char *dbg_emio_mux_parents[] __initdata = {"dbg_div",
+static const char *dbg_emio_mux_parents[] __initconst = {"dbg_div",
 	dummy_nm};
 
-static const char *dbgtrc_emio_input_names[] __initdata = {"trace_emio_clk"};
-static const char *gem0_emio_input_names[] __initdata = {"gem0_emio_clk"};
-static const char *gem1_emio_input_names[] __initdata = {"gem1_emio_clk"};
-static const char *swdt_ext_clk_input_names[] __initdata = {"swdt_ext_clk"};
+static const char *dbgtrc_emio_input_names[] __initconst = {"trace_emio_clk"};
+static const char *gem0_emio_input_names[] __initconst = {"gem0_emio_clk"};
+static const char *gem1_emio_input_names[] __initconst = {"gem1_emio_clk"};
+static const char *swdt_ext_clk_input_names[] __initconst = {"swdt_ext_clk"};
 
 static void __init zynq_clk_register_fclk(enum zynq_clk fclk,
 		const char *clk_name, void __iomem *fclk_ctrl_reg,
diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index 60e81d5..ae2bc84 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -309,7 +309,7 @@ static struct cpufreq_driver ppc_corenet_cpufreq_driver = {
 	.attr		= corenet_cpufreq_attr,
 };
 
-static const struct of_device_id node_matches[] __initdata = {
+static const struct of_device_id node_matches[] __initconst = {
 	{ .compatible = "fsl,p2041-clockgen", .data = &sdata[0], },
 	{ .compatible = "fsl,p3041-clockgen", .data = &sdata[0], },
 	{ .compatible = "fsl,p5020-clockgen", .data = &sdata[1], },
diff --git a/drivers/irqchip/irq-bcm2835.c b/drivers/irqchip/irq-bcm2835.c
index 16c78f1..61bc5e4 100644
--- a/drivers/irqchip/irq-bcm2835.c
+++ b/drivers/irqchip/irq-bcm2835.c
@@ -74,10 +74,10 @@
 #define NR_BANKS		3
 #define IRQS_PER_BANK		32
 
-static int reg_pending[] __initconst = { 0x00, 0x04, 0x08 };
-static int reg_enable[] __initconst = { 0x18, 0x10, 0x14 };
-static int reg_disable[] __initconst = { 0x24, 0x1c, 0x20 };
-static int bank_irqs[] __initconst = { 8, 32, 32 };
+static const int reg_pending[] __initconst = { 0x00, 0x04, 0x08 };
+static const int reg_enable[] __initconst = { 0x18, 0x10, 0x14 };
+static const int reg_disable[] __initconst = { 0x24, 0x1c, 0x20 };
+static const int bank_irqs[] __initconst = { 8, 32, 32 };
 
 static const int shortcuts[] = {
 	7, 9, 10, 18, 19,		/* Bank 1 */
@@ -167,7 +167,7 @@ static int __init armctrl_of_init(struct device_node *node,
 	return 0;
 }
 
-static struct of_device_id irq_of_match[] __initconst = {
+static const struct of_device_id irq_of_match[] __initconst = {
 	{ .compatible = "brcm,bcm2835-armctrl-ic", .data = armctrl_of_init },
 	{ }
 };
diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
index 85472d3..8be7429 100644
--- a/drivers/mmc/host/sdhci-bcm-kona.c
+++ b/drivers/mmc/host/sdhci-bcm-kona.c
@@ -220,7 +220,7 @@ static struct sdhci_pltfm_data sdhci_pltfm_data_kona = {
 		SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
 };
 
-static struct __initconst of_device_id sdhci_bcm_kona_of_match[] = {
+static const struct __initconst of_device_id sdhci_bcm_kona_of_match[] = {
 	{ .compatible = "brcm,kona-sdhci"},
 	{ .compatible = "bcm,kona-sdhci"}, /* deprecated name */
 	{}
diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index b77a01e..e6505e9 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -487,7 +487,7 @@ static int nand_davinci_dev_ready(struct mtd_info *mtd)
  * ten ECC bytes plus the manufacturer's bad block marker byte, and
  * and not overlapping the default BBT markers.
  */
-static struct nand_ecclayout hwecc4_small __initconst = {
+static const struct nand_ecclayout hwecc4_small __initconst = {
 	.eccbytes = 10,
 	.eccpos = { 0, 1, 2, 3, 4,
 		/* offset 5 holds the badblock marker */
@@ -503,7 +503,7 @@ static struct nand_ecclayout hwecc4_small __initconst = {
  * storing ten ECC bytes plus the manufacturer's bad block marker byte,
  * and not overlapping the default BBT markers.
  */
-static struct nand_ecclayout hwecc4_2048 __initconst = {
+static const struct nand_ecclayout hwecc4_2048 __initconst = {
 	.eccbytes = 40,
 	.eccpos = {
 		/* at the end of spare sector */
diff --git a/drivers/usb/host/ehci-msm.c b/drivers/usb/host/ehci-msm.c
index 0f717dc..655c24a 100644
--- a/drivers/usb/host/ehci-msm.c
+++ b/drivers/usb/host/ehci-msm.c
@@ -195,7 +195,7 @@ static struct platform_driver ehci_msm_driver = {
 	},
 };
 
-static const struct ehci_driver_overrides msm_overrides __initdata = {
+static const struct ehci_driver_overrides msm_overrides __initconst = {
 	.reset = ehci_msm_reset,
 };
 
diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 78b01fa..fb7a492 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -86,7 +86,7 @@ static inline u32 ehci_read(void __iomem *base, u32 reg)
 
 static struct hc_driver __read_mostly ehci_omap_hc_driver;
 
-static const struct ehci_driver_overrides ehci_omap_overrides __initdata = {
+static const struct ehci_driver_overrides ehci_omap_overrides __initconst = {
 	.extra_priv_size = sizeof(struct omap_hcd),
 };
 
diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 7c3de95..e604331 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -297,7 +297,7 @@ static struct platform_driver s5p_ehci_driver = {
 		.of_match_table = of_match_ptr(exynos_ehci_match),
 	}
 };
-static const struct ehci_driver_overrides s5p_overrides __initdata = {
+static const struct ehci_driver_overrides s5p_overrides __initconst = {
 	.extra_priv_size = sizeof(struct s5p_ehci_hcd),
 };
 
diff --git a/drivers/usb/host/ehci-spear.c b/drivers/usb/host/ehci-spear.c
index 1cf0adb..111e65f 100644
--- a/drivers/usb/host/ehci-spear.c
+++ b/drivers/usb/host/ehci-spear.c
@@ -174,7 +174,7 @@ static struct platform_driver spear_ehci_hcd_driver = {
 	}
 };
 
-static const struct ehci_driver_overrides spear_overrides __initdata = {
+static const struct ehci_driver_overrides spear_overrides __initconst = {
 	.extra_priv_size = sizeof(struct spear_ehci),
 };
 


