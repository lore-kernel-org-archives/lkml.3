Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbaGCOj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:39:59 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:51778 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417AbaGCOjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:39:22 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, rabin@rab.in,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [RFC v2 2/5] clk: Move all drivers to use internal API
Date: Thu,  3 Jul 2014 16:38:40 +0200
Message-Id: <1404398323-18934-3-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to change the public API to return a per-user clk structure,
remove any usage of this public API from the clock implementations.

The reason for having this in a separate commit from the one that introduces
the implementation of the new functions is to separate the changes generated
with Coccinelle from the rest, and keep the patches' size reasonable.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/at91/clk-main.c               | 24 +++++++++----------
 drivers/clk/at91/clk-master.c             |  6 ++---
 drivers/clk/at91/clk-peripheral.c         | 12 +++++-----
 drivers/clk/at91/clk-pll.c                |  6 ++---
 drivers/clk/at91/clk-plldiv.c             |  6 ++---
 drivers/clk/at91/clk-programmable.c       | 10 ++++----
 drivers/clk/at91/clk-slow.c               | 24 +++++++++----------
 drivers/clk/at91/clk-smd.c                |  6 ++---
 drivers/clk/at91/clk-system.c             |  6 ++---
 drivers/clk/at91/clk-usb.c                | 18 +++++++-------
 drivers/clk/at91/clk-utmi.c               |  6 ++---
 drivers/clk/bcm/clk-kona-setup.c          |  6 ++---
 drivers/clk/bcm/clk-kona.c                | 12 +++++-----
 drivers/clk/bcm/clk-kona.h                |  2 +-
 drivers/clk/berlin/berlin2-avpll.c        |  4 ++--
 drivers/clk/berlin/berlin2-avpll.h        |  4 ++--
 drivers/clk/berlin/berlin2-div.c          |  2 +-
 drivers/clk/berlin/berlin2-div.h          |  2 +-
 drivers/clk/berlin/berlin2-pll.c          |  2 +-
 drivers/clk/berlin/berlin2-pll.h          |  2 +-
 drivers/clk/berlin/bg2.c                  | 12 +++++-----
 drivers/clk/berlin/bg2q.c                 |  8 +++----
 drivers/clk/clk-axi-clkgen.c              |  2 +-
 drivers/clk/clk-axm5516.c                 |  4 ++--
 drivers/clk/clk-bcm2835.c                 |  2 +-
 drivers/clk/clk-composite.c               |  6 ++---
 drivers/clk/clk-divider.c                 |  8 +++----
 drivers/clk/clk-efm32gg.c                 |  2 +-
 drivers/clk/clk-fixed-factor.c            |  6 ++---
 drivers/clk/clk-fixed-rate.c              |  8 +++----
 drivers/clk/clk-fractional-divider.c      |  4 ++--
 drivers/clk/clk-gate.c                    |  4 ++--
 drivers/clk/clk-highbank.c                |  8 +++----
 drivers/clk/clk-ls1x.c                    | 16 ++++++-------
 drivers/clk/clk-max77686.c                | 10 ++++----
 drivers/clk/clk-moxart.c                  |  8 +++----
 drivers/clk/clk-mux.c                     |  6 ++---
 drivers/clk/clk-nomadik.c                 | 14 +++++------
 drivers/clk/clk-nspire.c                  |  4 ++--
 drivers/clk/clk-ppc-corenet.c             |  8 +++----
 drivers/clk/clk-s2mps11.c                 |  6 ++---
 drivers/clk/clk-si5351.c                  | 17 ++++++-------
 drivers/clk/clk-si570.c                   |  4 ++--
 drivers/clk/clk-twl6040.c                 |  2 +-
 drivers/clk/clk-u300.c                    | 12 +++++-----
 drivers/clk/clk-vt8500.c                  |  4 ++--
 drivers/clk/clk-wm831x.c                  |  6 ++---
 drivers/clk/clk-xgene.c                   | 12 +++++-----
 drivers/clk/clk.h                         |  4 ++--
 drivers/clk/hisilicon/clk-hi3620.c        |  8 +++----
 drivers/clk/hisilicon/clk.c               | 16 ++++++-------
 drivers/clk/hisilicon/clk.h               |  2 +-
 drivers/clk/hisilicon/clkgate-separated.c |  4 ++--
 drivers/clk/keystone/gate.c               |  6 ++---
 drivers/clk/keystone/pll.c                | 10 ++++----
 drivers/clk/mmp/clk-apbc.c                |  4 ++--
 drivers/clk/mmp/clk-apmu.c                |  4 ++--
 drivers/clk/mmp/clk-frac.c                |  4 ++--
 drivers/clk/mmp/clk-mmp2.c                | 14 +++++------
 drivers/clk/mmp/clk-pxa168.c              | 12 +++++-----
 drivers/clk/mmp/clk-pxa910.c              | 12 +++++-----
 drivers/clk/mmp/clk.h                     |  8 +++----
 drivers/clk/mvebu/clk-corediv.c           |  4 ++--
 drivers/clk/mvebu/clk-cpu.c               |  8 +++----
 drivers/clk/mvebu/common.c                | 14 +++++------
 drivers/clk/mxs/clk-div.c                 |  4 ++--
 drivers/clk/mxs/clk-frac.c                |  4 ++--
 drivers/clk/mxs/clk-imx23.c               |  4 ++--
 drivers/clk/mxs/clk-imx28.c               |  4 ++--
 drivers/clk/mxs/clk-pll.c                 |  4 ++--
 drivers/clk/mxs/clk-ref.c                 |  4 ++--
 drivers/clk/mxs/clk-ssp.c                 |  2 +-
 drivers/clk/mxs/clk.h                     | 16 ++++++-------
 drivers/clk/qcom/clk-rcg.c                |  6 ++---
 drivers/clk/qcom/clk-rcg2.c               | 14 +++++------
 drivers/clk/qcom/clk-regmap.c             |  2 +-
 drivers/clk/qcom/clk-regmap.h             |  2 +-
 drivers/clk/qcom/common.c                 |  6 ++---
 drivers/clk/qcom/gcc-msm8660.c            |  2 +-
 drivers/clk/qcom/gcc-msm8960.c            |  2 +-
 drivers/clk/qcom/gcc-msm8974.c            |  2 +-
 drivers/clk/qcom/mmcc-msm8960.c           |  6 ++---
 drivers/clk/rockchip/clk-rockchip.c       |  2 +-
 drivers/clk/samsung/clk-exynos-audss.c    | 16 ++++++-------
 drivers/clk/samsung/clk-exynos4.c         |  6 ++---
 drivers/clk/samsung/clk-pll.c             |  6 ++---
 drivers/clk/samsung/clk-pll.h             |  2 +-
 drivers/clk/samsung/clk-s3c2410-dclk.c    | 10 ++++----
 drivers/clk/samsung/clk.c                 | 22 ++++++++---------
 drivers/clk/samsung/clk.h                 |  2 +-
 drivers/clk/shmobile/clk-div6.c           |  2 +-
 drivers/clk/shmobile/clk-emev2.c          |  4 ++--
 drivers/clk/shmobile/clk-mstp.c           |  6 ++---
 drivers/clk/shmobile/clk-r8a7740.c        |  6 ++---
 drivers/clk/shmobile/clk-r8a7779.c        |  6 ++---
 drivers/clk/shmobile/clk-rcar-gen2.c      | 10 ++++----
 drivers/clk/shmobile/clk-rz.c             |  6 ++---
 drivers/clk/sirf/clk-atlas6.c             |  2 +-
 drivers/clk/sirf/clk-common.c             | 30 +++++++++++------------
 drivers/clk/sirf/clk-prima2.c             |  2 +-
 drivers/clk/socfpga/clk-gate.c            |  2 +-
 drivers/clk/socfpga/clk-periph.c          |  2 +-
 drivers/clk/socfpga/clk-pll.c             |  4 ++--
 drivers/clk/spear/clk-aux-synth.c         |  8 +++----
 drivers/clk/spear/clk-frac-synth.c        |  4 ++--
 drivers/clk/spear/clk-gpt-synth.c         |  4 ++--
 drivers/clk/spear/clk-vco-pll.c           |  8 +++----
 drivers/clk/spear/clk.h                   | 14 +++++------
 drivers/clk/spear/spear1310_clock.c       |  2 +-
 drivers/clk/spear/spear1340_clock.c       |  2 +-
 drivers/clk/spear/spear3xx_clock.c        |  8 +++----
 drivers/clk/spear/spear6xx_clock.c        |  2 +-
 drivers/clk/st/clkgen-fsyn.c              | 22 ++++++++---------
 drivers/clk/st/clkgen-mux.c               | 32 ++++++++++++-------------
 drivers/clk/st/clkgen-pll.c               | 34 +++++++++++++-------------
 drivers/clk/sunxi/clk-a10-hosc.c          |  2 +-
 drivers/clk/sunxi/clk-a20-gmac.c          |  2 +-
 drivers/clk/sunxi/clk-factors.c           |  4 ++--
 drivers/clk/sunxi/clk-sun6i-apb0-gates.c  |  2 +-
 drivers/clk/sunxi/clk-sun6i-apb0.c        |  2 +-
 drivers/clk/sunxi/clk-sun6i-ar100.c       |  6 ++---
 drivers/clk/sunxi/clk-sunxi.c             | 18 +++++++-------
 drivers/clk/tegra/clk-audio-sync.c        |  4 ++--
 drivers/clk/tegra/clk-divider.c           |  4 ++--
 drivers/clk/tegra/clk-periph-gate.c       |  4 ++--
 drivers/clk/tegra/clk-periph.c            |  8 +++----
 drivers/clk/tegra/clk-pll-out.c           |  4 ++--
 drivers/clk/tegra/clk-pll.c               | 40 +++++++++++++++----------------
 drivers/clk/tegra/clk-super.c             |  4 ++--
 drivers/clk/tegra/clk-tegra-audio.c       |  4 ++--
 drivers/clk/tegra/clk-tegra-fixed.c       |  8 +++----
 drivers/clk/tegra/clk-tegra-periph.c      | 12 +++++-----
 drivers/clk/tegra/clk-tegra-pmc.c         |  4 ++--
 drivers/clk/tegra/clk-tegra-super-gen4.c  |  8 +++----
 drivers/clk/tegra/clk-tegra114.c          | 10 ++++----
 drivers/clk/tegra/clk-tegra124.c          |  6 ++---
 drivers/clk/tegra/clk-tegra20.c           | 12 +++++-----
 drivers/clk/tegra/clk-tegra30.c           |  8 +++----
 drivers/clk/tegra/clk.c                   | 24 +++++++++----------
 drivers/clk/tegra/clk.h                   | 38 ++++++++++++++---------------
 drivers/clk/ti/apll.c                     |  8 +++----
 drivers/clk/ti/clk-2xxx.c                 |  8 +++----
 drivers/clk/ti/clk-33xx.c                 | 18 +++++++-------
 drivers/clk/ti/clk-3xxx.c                 |  8 +++----
 drivers/clk/ti/clk-43xx.c                 |  8 +++----
 drivers/clk/ti/clk-44xx.c                 | 16 ++++++-------
 drivers/clk/ti/clk-54xx.c                 | 25 +++++++++----------
 drivers/clk/ti/clk-7xx.c                  | 16 ++++++-------
 drivers/clk/ti/clk-dra7-atl.c             |  6 ++---
 drivers/clk/ti/clk.c                      |  2 +-
 drivers/clk/ti/clockdomain.c              |  4 ++--
 drivers/clk/ti/composite.c                |  2 +-
 drivers/clk/ti/divider.c                  |  6 ++---
 drivers/clk/ti/dpll.c                     |  8 +++----
 drivers/clk/ti/fixed-factor.c             |  2 +-
 drivers/clk/ti/gate.c                     |  2 +-
 drivers/clk/ti/interface.c                |  2 +-
 drivers/clk/ti/mux.c                      |  6 ++---
 drivers/clk/ux500/abx500-clk.c            |  2 +-
 drivers/clk/ux500/clk-prcc.c              |  8 +++----
 drivers/clk/ux500/clk-prcmu.c             | 16 ++++++-------
 drivers/clk/ux500/clk-sysctrl.c           | 10 ++++----
 drivers/clk/ux500/clk.h                   | 22 ++++++++---------
 drivers/clk/ux500/u8500_clk.c             |  2 +-
 drivers/clk/ux500/u8500_of_clk.c          | 12 +++++-----
 drivers/clk/ux500/u8540_clk.c             |  2 +-
 drivers/clk/versatile/clk-icst.c          |  4 ++--
 drivers/clk/versatile/clk-icst.h          |  2 +-
 drivers/clk/versatile/clk-impd1.c         | 18 +++++++-------
 drivers/clk/versatile/clk-integrator.c    |  2 +-
 drivers/clk/versatile/clk-realview.c      |  2 +-
 drivers/clk/versatile/clk-sp810.c         | 30 ++++++++++++-----------
 drivers/clk/versatile/clk-vexpress-osc.c  |  2 +-
 drivers/clk/versatile/clk-vexpress.c      |  6 ++---
 drivers/clk/x86/clk-lpt.c                 |  2 +-
 drivers/clk/zynq/clkc.c                   | 22 ++++++++---------
 drivers/clk/zynq/pll.c                    |  4 ++--
 include/linux/clk/ti.h                    | 10 ++++----
 include/linux/clk/zynq.h                  |  2 +-
 include/linux/platform_data/si5351.h      |  4 ++--
 180 files changed, 721 insertions(+), 717 deletions(-)

diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
index 7333061..939c4b7 100644
--- a/drivers/clk/at91/clk-main.c
+++ b/drivers/clk/at91/clk-main.c
@@ -138,7 +138,7 @@ static const struct clk_ops main_osc_ops = {
 	.is_prepared = clk_main_osc_is_prepared,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_main_osc(struct at91_pmc *pmc,
 			   unsigned int irq,
 			   const char *name,
@@ -147,7 +147,7 @@ at91_clk_register_main_osc(struct at91_pmc *pmc,
 {
 	int ret;
 	struct clk_main_osc *osc;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	if (!pmc || !irq || !name || !parent_name)
@@ -192,7 +192,7 @@ at91_clk_register_main_osc(struct at91_pmc *pmc,
 void __init of_at91rm9200_clk_main_osc_setup(struct device_node *np,
 					     struct at91_pmc *pmc)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	unsigned int irq;
 	const char *name = np->name;
 	const char *parent_name;
@@ -291,7 +291,7 @@ static const struct clk_ops main_rc_osc_ops = {
 	.recalc_accuracy = clk_main_rc_osc_recalc_accuracy,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_main_rc_osc(struct at91_pmc *pmc,
 			      unsigned int irq,
 			      const char *name,
@@ -299,7 +299,7 @@ at91_clk_register_main_rc_osc(struct at91_pmc *pmc,
 {
 	int ret;
 	struct clk_main_rc_osc *osc;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	if (!pmc || !irq || !name || !frequency)
@@ -340,7 +340,7 @@ at91_clk_register_main_rc_osc(struct at91_pmc *pmc,
 void __init of_at91sam9x5_clk_main_rc_osc_setup(struct device_node *np,
 						struct at91_pmc *pmc)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	unsigned int irq;
 	u32 frequency = 0;
 	u32 accuracy = 0;
@@ -423,13 +423,13 @@ static const struct clk_ops rm9200_main_ops = {
 	.recalc_rate = clk_rm9200_main_recalc_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_rm9200_main(struct at91_pmc *pmc,
 			      const char *name,
 			      const char *parent_name)
 {
 	struct clk_rm9200_main *clkmain;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	if (!pmc || !name)
@@ -461,7 +461,7 @@ at91_clk_register_rm9200_main(struct at91_pmc *pmc,
 void __init of_at91rm9200_clk_main_setup(struct device_node *np,
 					 struct at91_pmc *pmc)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name;
 	const char *name = np->name;
 
@@ -554,7 +554,7 @@ static const struct clk_ops sam9x5_main_ops = {
 	.get_parent = clk_sam9x5_main_get_parent,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_sam9x5_main(struct at91_pmc *pmc,
 			      unsigned int irq,
 			      const char *name,
@@ -563,7 +563,7 @@ at91_clk_register_sam9x5_main(struct at91_pmc *pmc,
 {
 	int ret;
 	struct clk_sam9x5_main *clkmain;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	if (!pmc || !irq || !name)
@@ -606,7 +606,7 @@ at91_clk_register_sam9x5_main(struct at91_pmc *pmc,
 void __init of_at91sam9x5_clk_main_setup(struct device_node *np,
 					 struct at91_pmc *pmc)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_names[2];
 	int num_parents;
 	unsigned int irq;
diff --git a/drivers/clk/at91/clk-master.c b/drivers/clk/at91/clk-master.c
index c1af80b..95ae1b6 100644
--- a/drivers/clk/at91/clk-master.c
+++ b/drivers/clk/at91/clk-master.c
@@ -131,7 +131,7 @@ static const struct clk_ops master_ops = {
 	.get_parent = clk_master_get_parent,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_master(struct at91_pmc *pmc, unsigned int irq,
 		const char *name, int num_parents,
 		const char **parent_names,
@@ -140,7 +140,7 @@ at91_clk_register_master(struct at91_pmc *pmc, unsigned int irq,
 {
 	int ret;
 	struct clk_master *master;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	if (!pmc || !irq || !name || !num_parents || !parent_names)
@@ -216,7 +216,7 @@ static void __init
 of_at91_clk_master_setup(struct device_node *np, struct at91_pmc *pmc,
 			 const struct clk_master_layout *layout)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	int num_parents;
 	int i;
 	unsigned int irq;
diff --git a/drivers/clk/at91/clk-peripheral.c b/drivers/clk/at91/clk-peripheral.c
index 597fed4..cdf8e8a 100644
--- a/drivers/clk/at91/clk-peripheral.c
+++ b/drivers/clk/at91/clk-peripheral.c
@@ -100,12 +100,12 @@ static const struct clk_ops peripheral_ops = {
 	.is_enabled = clk_peripheral_is_enabled,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_peripheral(struct at91_pmc *pmc, const char *name,
 			     const char *parent_name, u32 id)
 {
 	struct clk_peripheral *periph;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	if (!pmc || !name || !parent_name || id > PERIPHERAL_ID_MAX)
@@ -134,7 +134,7 @@ at91_clk_register_peripheral(struct at91_pmc *pmc, const char *name,
 
 static void clk_sam9x5_peripheral_autodiv(struct clk_sam9x5_peripheral *periph)
 {
-	struct clk *parent;
+	struct clk_core *parent;
 	unsigned long parent_rate;
 	int shift = 0;
 
@@ -309,13 +309,13 @@ static const struct clk_ops sam9x5_peripheral_ops = {
 	.set_rate = clk_sam9x5_peripheral_set_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_sam9x5_peripheral(struct at91_pmc *pmc, const char *name,
 				    const char *parent_name, u32 id,
 				    const struct clk_range *range)
 {
 	struct clk_sam9x5_peripheral *periph;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	if (!pmc || !name || !parent_name)
@@ -352,7 +352,7 @@ of_at91_clk_periph_setup(struct device_node *np, struct at91_pmc *pmc, u8 type)
 {
 	int num;
 	u32 id;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name;
 	const char *name;
 	struct device_node *periphclknp;
diff --git a/drivers/clk/at91/clk-pll.c b/drivers/clk/at91/clk-pll.c
index cf6ed02..0d22f65f 100644
--- a/drivers/clk/at91/clk-pll.c
+++ b/drivers/clk/at91/clk-pll.c
@@ -297,14 +297,14 @@ static const struct clk_ops pll_ops = {
 	.set_rate = clk_pll_set_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_pll(struct at91_pmc *pmc, unsigned int irq, const char *name,
 		      const char *parent_name, u8 id,
 		      const struct clk_pll_layout *layout,
 		      const struct clk_pll_characteristics *characteristics)
 {
 	struct clk_pll *pll;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 	int ret;
 	int offset = PLL_REG(id);
@@ -474,7 +474,7 @@ of_at91_clk_pll_setup(struct device_node *np, struct at91_pmc *pmc,
 {
 	u32 id;
 	unsigned int irq;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name;
 	const char *name = np->name;
 	struct clk_pll_characteristics *characteristics;
diff --git a/drivers/clk/at91/clk-plldiv.c b/drivers/clk/at91/clk-plldiv.c
index ea22656..f8204d8 100644
--- a/drivers/clk/at91/clk-plldiv.c
+++ b/drivers/clk/at91/clk-plldiv.c
@@ -79,12 +79,12 @@ static const struct clk_ops plldiv_ops = {
 	.set_rate = clk_plldiv_set_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_plldiv(struct at91_pmc *pmc, const char *name,
 			 const char *parent_name)
 {
 	struct clk_plldiv *plldiv;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	plldiv = kzalloc(sizeof(*plldiv), GFP_KERNEL);
@@ -111,7 +111,7 @@ at91_clk_register_plldiv(struct at91_pmc *pmc, const char *name,
 static void __init
 of_at91_clk_plldiv_setup(struct device_node *np, struct at91_pmc *pmc)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name;
 	const char *name = np->name;
 
diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
index 62e2509..b72e98c 100644
--- a/drivers/clk/at91/clk-programmable.c
+++ b/drivers/clk/at91/clk-programmable.c
@@ -57,9 +57,9 @@ static unsigned long clk_programmable_recalc_rate(struct clk_hw *hw,
 static long clk_programmable_determine_rate(struct clk_hw *hw,
 					    unsigned long rate,
 					    unsigned long *best_parent_rate,
-					    struct clk **best_parent_clk)
+					    struct clk_core **best_parent_clk)
 {
-	struct clk *parent = NULL;
+	struct clk_core *parent = NULL;
 	long best_rate = -EINVAL;
 	unsigned long parent_rate;
 	unsigned long tmp_rate;
@@ -169,14 +169,14 @@ static const struct clk_ops programmable_ops = {
 	.set_rate = clk_programmable_set_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_programmable(struct at91_pmc *pmc,
 			       const char *name, const char **parent_names,
 			       u8 num_parents, u8 id,
 			       const struct clk_programmable_layout *layout)
 {
 	struct clk_programmable *prog;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	if (id > PROG_ID_MAX)
@@ -229,7 +229,7 @@ of_at91_clk_prog_setup(struct device_node *np, struct at91_pmc *pmc,
 	int num;
 	u32 id;
 	int i;
-	struct clk *clk;
+	struct clk_core *clk;
 	int num_parents;
 	const char *parent_names[PROG_SOURCE_MAX];
 	const char *name;
diff --git a/drivers/clk/at91/clk-slow.c b/drivers/clk/at91/clk-slow.c
index 0300c46..d50fe02 100644
--- a/drivers/clk/at91/clk-slow.c
+++ b/drivers/clk/at91/clk-slow.c
@@ -117,7 +117,7 @@ static const struct clk_ops slow_osc_ops = {
 	.is_prepared = clk_slow_osc_is_prepared,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_slow_osc(void __iomem *sckcr,
 			   const char *name,
 			   const char *parent_name,
@@ -125,7 +125,7 @@ at91_clk_register_slow_osc(void __iomem *sckcr,
 			   bool bypass)
 {
 	struct clk_slow_osc *osc;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	if (!sckcr || !name || !parent_name)
@@ -159,7 +159,7 @@ at91_clk_register_slow_osc(void __iomem *sckcr,
 void __init of_at91sam9x5_clk_slow_osc_setup(struct device_node *np,
 					     void __iomem *sckcr)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name;
 	const char *name = np->name;
 	u32 startup;
@@ -229,7 +229,7 @@ static const struct clk_ops slow_rc_osc_ops = {
 	.recalc_accuracy = clk_slow_rc_osc_recalc_accuracy,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_slow_rc_osc(void __iomem *sckcr,
 			      const char *name,
 			      unsigned long frequency,
@@ -237,7 +237,7 @@ at91_clk_register_slow_rc_osc(void __iomem *sckcr,
 			      unsigned long startup)
 {
 	struct clk_slow_rc_osc *osc;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	if (!sckcr || !name)
@@ -269,7 +269,7 @@ at91_clk_register_slow_rc_osc(void __iomem *sckcr,
 void __init of_at91sam9x5_clk_slow_rc_osc_setup(struct device_node *np,
 						void __iomem *sckcr)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	u32 frequency = 0;
 	u32 accuracy = 0;
 	u32 startup = 0;
@@ -327,14 +327,14 @@ static const struct clk_ops sam9x5_slow_ops = {
 	.get_parent = clk_sam9x5_slow_get_parent,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_sam9x5_slow(void __iomem *sckcr,
 			      const char *name,
 			      const char **parent_names,
 			      int num_parents)
 {
 	struct clk_sam9x5_slow *slowck;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	if (!sckcr || !name || !parent_names || !num_parents)
@@ -364,7 +364,7 @@ at91_clk_register_sam9x5_slow(void __iomem *sckcr,
 void __init of_at91sam9x5_clk_slow_setup(struct device_node *np,
 					 void __iomem *sckcr)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_names[2];
 	int num_parents;
 	const char *name = np->name;
@@ -401,14 +401,14 @@ static const struct clk_ops sam9260_slow_ops = {
 	.get_parent = clk_sam9260_slow_get_parent,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_sam9260_slow(struct at91_pmc *pmc,
 			       const char *name,
 			       const char **parent_names,
 			       int num_parents)
 {
 	struct clk_sam9260_slow *slowck;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	if (!pmc || !name)
@@ -440,7 +440,7 @@ at91_clk_register_sam9260_slow(struct at91_pmc *pmc,
 void __init of_at91sam9260_clk_slow_setup(struct device_node *np,
 					  struct at91_pmc *pmc)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_names[2];
 	int num_parents;
 	const char *name = np->name;
diff --git a/drivers/clk/at91/clk-smd.c b/drivers/clk/at91/clk-smd.c
index 144d47e..8820b84 100644
--- a/drivers/clk/at91/clk-smd.c
+++ b/drivers/clk/at91/clk-smd.c
@@ -113,12 +113,12 @@ static const struct clk_ops at91sam9x5_smd_ops = {
 	.set_rate = at91sam9x5_clk_smd_set_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91sam9x5_clk_register_smd(struct at91_pmc *pmc, const char *name,
 			    const char **parent_names, u8 num_parents)
 {
 	struct at91sam9x5_clk_smd *smd;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	smd = kzalloc(sizeof(*smd), GFP_KERNEL);
@@ -144,7 +144,7 @@ at91sam9x5_clk_register_smd(struct at91_pmc *pmc, const char *name,
 void __init of_at91sam9x5_clk_smd_setup(struct device_node *np,
 					struct at91_pmc *pmc)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	int i;
 	int num_parents;
 	const char *parent_names[SMD_SOURCE_MAX];
diff --git a/drivers/clk/at91/clk-system.c b/drivers/clk/at91/clk-system.c
index 8c96307..770d9bf 100644
--- a/drivers/clk/at91/clk-system.c
+++ b/drivers/clk/at91/clk-system.c
@@ -99,12 +99,12 @@ static const struct clk_ops system_ops = {
 	.is_prepared = clk_system_is_prepared,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_system(struct at91_pmc *pmc, const char *name,
 			 const char *parent_name, u8 id, int irq)
 {
 	struct clk_system *sys;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 	int ret;
 
@@ -153,7 +153,7 @@ of_at91_clk_sys_setup(struct device_node *np, struct at91_pmc *pmc)
 	int num;
 	int irq = 0;
 	u32 id;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *name;
 	struct device_node *sysclknp;
 	const char *parent_name;
diff --git a/drivers/clk/at91/clk-usb.c b/drivers/clk/at91/clk-usb.c
index 7d1d26a..246989c 100644
--- a/drivers/clk/at91/clk-usb.c
+++ b/drivers/clk/at91/clk-usb.c
@@ -162,12 +162,12 @@ static const struct clk_ops at91sam9n12_usb_ops = {
 	.set_rate = at91sam9x5_clk_usb_set_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91sam9x5_clk_register_usb(struct at91_pmc *pmc, const char *name,
 			    const char **parent_names, u8 num_parents)
 {
 	struct at91sam9x5_clk_usb *usb;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	usb = kzalloc(sizeof(*usb), GFP_KERNEL);
@@ -190,12 +190,12 @@ at91sam9x5_clk_register_usb(struct at91_pmc *pmc, const char *name,
 	return clk;
 }
 
-static struct clk * __init
+static struct clk_core * __init
 at91sam9n12_clk_register_usb(struct at91_pmc *pmc, const char *name,
 			     const char *parent_name)
 {
 	struct at91sam9x5_clk_usb *usb;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	usb = kzalloc(sizeof(*usb), GFP_KERNEL);
@@ -295,12 +295,12 @@ static const struct clk_ops at91rm9200_usb_ops = {
 	.set_rate = at91rm9200_clk_usb_set_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91rm9200_clk_register_usb(struct at91_pmc *pmc, const char *name,
 			    const char *parent_name, const u32 *divisors)
 {
 	struct at91rm9200_clk_usb *usb;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	usb = kzalloc(sizeof(*usb), GFP_KERNEL);
@@ -327,7 +327,7 @@ at91rm9200_clk_register_usb(struct at91_pmc *pmc, const char *name,
 void __init of_at91sam9x5_clk_usb_setup(struct device_node *np,
 					struct at91_pmc *pmc)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	int i;
 	int num_parents;
 	const char *parent_names[USB_SOURCE_MAX];
@@ -355,7 +355,7 @@ void __init of_at91sam9x5_clk_usb_setup(struct device_node *np,
 void __init of_at91sam9n12_clk_usb_setup(struct device_node *np,
 					 struct at91_pmc *pmc)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name;
 	const char *name = np->name;
 
@@ -375,7 +375,7 @@ void __init of_at91sam9n12_clk_usb_setup(struct device_node *np,
 void __init of_at91rm9200_clk_usb_setup(struct device_node *np,
 					struct at91_pmc *pmc)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name;
 	const char *name = np->name;
 	u32 divisors[4] = {0, 0, 0, 0};
diff --git a/drivers/clk/at91/clk-utmi.c b/drivers/clk/at91/clk-utmi.c
index ae3263b..0502050 100644
--- a/drivers/clk/at91/clk-utmi.c
+++ b/drivers/clk/at91/clk-utmi.c
@@ -92,13 +92,13 @@ static const struct clk_ops utmi_ops = {
 	.recalc_rate = clk_utmi_recalc_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 at91_clk_register_utmi(struct at91_pmc *pmc, unsigned int irq,
 		       const char *name, const char *parent_name)
 {
 	int ret;
 	struct clk_utmi *utmi;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 	struct clk_init_data init;
 
 	utmi = kzalloc(sizeof(*utmi), GFP_KERNEL);
@@ -132,7 +132,7 @@ static void __init
 of_at91_clk_utmi_setup(struct device_node *np, struct at91_pmc *pmc)
 {
 	unsigned int irq;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name;
 	const char *name = np->name;
 
diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index e5aeded..122e7b0 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -697,7 +697,7 @@ static void bcm_clk_teardown(struct kona_clk *bcm_clk)
 	bcm_clk->type = bcm_clk_none;
 }
 
-static void kona_clk_teardown(struct clk *clk)
+static void kona_clk_teardown(struct clk_core *clk)
 {
 	struct clk_hw *hw;
 	struct kona_clk *bcm_clk;
@@ -716,10 +716,10 @@ static void kona_clk_teardown(struct clk *clk)
 	bcm_clk_teardown(bcm_clk);
 }
 
-struct clk *kona_clk_setup(struct kona_clk *bcm_clk)
+struct clk_core *kona_clk_setup(struct kona_clk *bcm_clk)
 {
 	struct clk_init_data *init_data = &bcm_clk->init_data;
-	struct clk *clk = NULL;
+	struct clk_core *clk = NULL;
 
 	switch (bcm_clk->type) {
 	case bcm_clk_peri:
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index 95af2e6..a301aa9 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -1032,11 +1032,11 @@ static long kona_peri_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 }
 
 static long kona_peri_clk_determine_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *best_parent_rate, struct clk **best_parent)
+		unsigned long *best_parent_rate, struct clk_core **best_parent)
 {
 	struct kona_clk *bcm_clk = to_kona_clk(hw);
-	struct clk *clk = hw->clk;
-	struct clk *current_parent;
+	struct clk_core *clk = hw->clk;
+	struct clk_core *current_parent;
 	unsigned long parent_rate;
 	unsigned long best_delta;
 	unsigned long best_rate;
@@ -1053,14 +1053,14 @@ static long kona_peri_clk_determine_rate(struct clk_hw *hw, unsigned long rate,
 		return kona_peri_clk_round_rate(hw, rate, best_parent_rate);
 
 	/* Unless we can do better, stick with current parent */
-	current_parent = clk_get_parent(clk);
+	current_parent = clk_provider_get_parent(clk);
 	parent_rate = __clk_get_rate(current_parent);
 	best_rate = kona_peri_clk_round_rate(hw, rate, &parent_rate);
 	best_delta = abs(best_rate - rate);
 
 	/* Check whether any other parent clock can produce a better result */
 	for (which = 0; which < parent_count; which++) {
-		struct clk *parent = clk_get_parent_by_index(clk, which);
+		struct clk_core *parent = clk_get_parent_by_index(clk, which);
 		unsigned long delta;
 		unsigned long other_rate;
 
@@ -1260,7 +1260,7 @@ bool __init kona_ccu_init(struct ccu_data *ccu)
 {
 	unsigned long flags;
 	unsigned int which;
-	struct clk **clks = ccu->clk_data.clks;
+	struct clk_core **clks = ccu->clk_data.clks;
 	bool success = true;
 
 	flags = ccu_lock(ccu);
diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
index 2537b30..c2d0152 100644
--- a/drivers/clk/bcm/clk-kona.h
+++ b/drivers/clk/bcm/clk-kona.h
@@ -508,7 +508,7 @@ extern u64 scaled_div_max(struct bcm_clk_div *div);
 extern u64 scaled_div_build(struct bcm_clk_div *div, u32 div_value,
 				u32 billionths);
 
-extern struct clk *kona_clk_setup(struct kona_clk *bcm_clk);
+extern struct clk_core *kona_clk_setup(struct kona_clk *bcm_clk);
 extern void __init kona_dt_ccu_setup(struct ccu_data *ccu,
 				struct device_node *node);
 extern bool __init kona_ccu_init(struct ccu_data *ccu);
diff --git a/drivers/clk/berlin/berlin2-avpll.c b/drivers/clk/berlin/berlin2-avpll.c
index fd0f26c..488d986 100644
--- a/drivers/clk/berlin/berlin2-avpll.c
+++ b/drivers/clk/berlin/berlin2-avpll.c
@@ -188,7 +188,7 @@ static const struct clk_ops berlin2_avpll_vco_ops = {
 	.recalc_rate	= berlin2_avpll_vco_recalc_rate,
 };
 
-struct clk * __init berlin2_avpll_vco_register(void __iomem *base,
+struct clk_core * __init berlin2_avpll_vco_register(void __iomem *base,
 			       const char *name, const char *parent_name,
 			       u8 vco_flags, unsigned long flags)
 {
@@ -364,7 +364,7 @@ static const struct clk_ops berlin2_avpll_channel_ops = {
  */
 static const u8 quirk_index[] __initconst = { 0, 6, 5, 4, 3, 2, 1, 7 };
 
-struct clk * __init berlin2_avpll_channel_register(void __iomem *base,
+struct clk_core * __init berlin2_avpll_channel_register(void __iomem *base,
 			   const char *name, u8 index, const char *parent_name,
 			   u8 ch_flags, unsigned long flags)
 {
diff --git a/drivers/clk/berlin/berlin2-avpll.h b/drivers/clk/berlin/berlin2-avpll.h
index a37f506..216eee7 100644
--- a/drivers/clk/berlin/berlin2-avpll.h
+++ b/drivers/clk/berlin/berlin2-avpll.h
@@ -24,11 +24,11 @@ struct clk;
 #define BERLIN2_AVPLL_BIT_QUIRK		BIT(0)
 #define BERLIN2_AVPLL_SCRAMBLE_QUIRK	BIT(1)
 
-struct clk * __init
+struct clk_core * __init
 berlin2_avpll_vco_register(void __iomem *base, const char *name,
 	   const char *parent_name, u8 vco_flags, unsigned long flags);
 
-struct clk * __init
+struct clk_core * __init
 berlin2_avpll_channel_register(void __iomem *base, const char *name,
 		       u8 index, const char *parent_name, u8 ch_flags,
 		       unsigned long flags);
diff --git a/drivers/clk/berlin/berlin2-div.c b/drivers/clk/berlin/berlin2-div.c
index 81ff97f..c673082 100644
--- a/drivers/clk/berlin/berlin2-div.c
+++ b/drivers/clk/berlin/berlin2-div.c
@@ -234,7 +234,7 @@ static const struct clk_ops berlin2_div_mux_ops = {
 	.get_parent	= berlin2_div_get_parent,
 };
 
-struct clk * __init
+struct clk_core * __init
 berlin2_div_register(const struct berlin2_div_map *map,
 		     void __iomem *base, const char *name, u8 div_flags,
 		     const char **parent_names, int num_parents,
diff --git a/drivers/clk/berlin/berlin2-div.h b/drivers/clk/berlin/berlin2-div.h
index 15e3384..3ddb87a 100644
--- a/drivers/clk/berlin/berlin2-div.h
+++ b/drivers/clk/berlin/berlin2-div.h
@@ -80,7 +80,7 @@ struct berlin2_div_data {
 	u8 div_flags;
 };
 
-struct clk * __init
+struct clk_core * __init
 berlin2_div_register(const struct berlin2_div_map *map,
 	     void __iomem *base,  const char *name, u8 div_flags,
 	     const char **parent_names, int num_parents,
diff --git a/drivers/clk/berlin/berlin2-pll.c b/drivers/clk/berlin/berlin2-pll.c
index bdc506b..b7a3016 100644
--- a/drivers/clk/berlin/berlin2-pll.c
+++ b/drivers/clk/berlin/berlin2-pll.c
@@ -91,7 +91,7 @@ static const struct clk_ops berlin2_pll_ops = {
 	.recalc_rate	= berlin2_pll_recalc_rate,
 };
 
-struct clk * __init
+struct clk_core * __init
 berlin2_pll_register(const struct berlin2_pll_map *map,
 		     void __iomem *base, const char *name,
 		     const char *parent_name, unsigned long flags)
diff --git a/drivers/clk/berlin/berlin2-pll.h b/drivers/clk/berlin/berlin2-pll.h
index 8831ce2..6b6a6ed 100644
--- a/drivers/clk/berlin/berlin2-pll.h
+++ b/drivers/clk/berlin/berlin2-pll.h
@@ -29,7 +29,7 @@ struct berlin2_pll_map {
 	u8 divsel_shift;
 };
 
-struct clk * __init
+struct clk_core * __init
 berlin2_pll_register(const struct berlin2_pll_map *map,
 		     void __iomem *base, const char *name,
 		     const char *parent_name, unsigned long flags);
diff --git a/drivers/clk/berlin/bg2.c b/drivers/clk/berlin/bg2.c
index 4c81e09..1329721 100644
--- a/drivers/clk/berlin/bg2.c
+++ b/drivers/clk/berlin/bg2.c
@@ -93,7 +93,7 @@
  */
 
 #define	MAX_CLKS 41
-static struct clk *clks[MAX_CLKS];
+static struct clk_core *clks[MAX_CLKS];
 static struct clk_onecell_data clk_data;
 static DEFINE_SPINLOCK(lock);
 static void __iomem *gbase;
@@ -504,7 +504,7 @@ static const struct berlin2_gate_data bg2_gates[] __initconst = {
 static void __init berlin2_clock_setup(struct device_node *np)
 {
 	const char *parent_names[9];
-	struct clk *clk;
+	struct clk_core *clk;
 	u8 avpll_flags = 0;
 	int n;
 
@@ -513,16 +513,16 @@ static void __init berlin2_clock_setup(struct device_node *np)
 		return;
 
 	/* overwrite default clock names with DT provided ones */
-	clk = of_clk_get_by_name(np, clk_names[REFCLK]);
+	clk = of_clk_provider_get_by_name(np, clk_names[REFCLK]);
 	if (!IS_ERR(clk)) {
 		clk_names[REFCLK] = __clk_get_name(clk);
-		clk_put(clk);
+		__clk_put(clk);
 	}
 
-	clk = of_clk_get_by_name(np, clk_names[VIDEO_EXT0]);
+	clk = of_clk_provider_get_by_name(np, clk_names[VIDEO_EXT0]);
 	if (!IS_ERR(clk)) {
 		clk_names[VIDEO_EXT0] = __clk_get_name(clk);
-		clk_put(clk);
+		__clk_put(clk);
 	}
 
 	/* simple register PLLs */
diff --git a/drivers/clk/berlin/bg2q.c b/drivers/clk/berlin/bg2q.c
index 748da9b..0b251bd 100644
--- a/drivers/clk/berlin/bg2q.c
+++ b/drivers/clk/berlin/bg2q.c
@@ -47,7 +47,7 @@
 #define REG_SDIO1XIN_CLKCTL	0x015c
 
 #define	MAX_CLKS 27
-static struct clk *clks[MAX_CLKS];
+static struct clk_core *clks[MAX_CLKS];
 static struct clk_onecell_data clk_data;
 static DEFINE_SPINLOCK(lock);
 static void __iomem *gbase;
@@ -293,7 +293,7 @@ static const struct berlin2_gate_data bg2q_gates[] __initconst = {
 static void __init berlin2q_clock_setup(struct device_node *np)
 {
 	const char *parent_names[9];
-	struct clk *clk;
+	struct clk_core *clk;
 	int n;
 
 	gbase = of_iomap(np, 0);
@@ -311,10 +311,10 @@ static void __init berlin2q_clock_setup(struct device_node *np)
 	}
 
 	/* overwrite default clock names with DT provided ones */
-	clk = of_clk_get_by_name(np, clk_names[REFCLK]);
+	clk = of_clk_provider_get_by_name(np, clk_names[REFCLK]);
 	if (!IS_ERR(clk)) {
 		clk_names[REFCLK] = __clk_get_name(clk);
-		clk_put(clk);
+		__clk_put(clk);
 	}
 
 	/* simple register PLLs */
diff --git a/drivers/clk/clk-axi-clkgen.c b/drivers/clk/clk-axi-clkgen.c
index 1127ee4..4b64834 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -489,7 +489,7 @@ static int axi_clkgen_probe(struct platform_device *pdev)
 	const char *parent_name;
 	const char *clk_name;
 	struct resource *mem;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (!pdev->dev.of_node)
 		return -ENODEV;
diff --git a/drivers/clk/clk-axm5516.c b/drivers/clk/clk-axm5516.c
index d2f1e11..3dc6e58 100644
--- a/drivers/clk/clk-axm5516.c
+++ b/drivers/clk/clk-axm5516.c
@@ -532,7 +532,7 @@ MODULE_DEVICE_TABLE(of, axmclk_match_table);
 
 struct axmclk_priv {
 	struct clk_onecell_data onecell;
-	struct clk *clks[];
+	struct clk_core *clks[];
 };
 
 static int axmclk_probe(struct platform_device *pdev)
@@ -541,7 +541,7 @@ static int axmclk_probe(struct platform_device *pdev)
 	struct resource *res;
 	int i, ret;
 	struct device *dev = &pdev->dev;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct regmap *regmap;
 	size_t num_clks;
 	struct axmclk_priv *priv;
diff --git a/drivers/clk/clk-bcm2835.c b/drivers/clk/clk-bcm2835.c
index 6b950ca..f25e85e 100644
--- a/drivers/clk/clk-bcm2835.c
+++ b/drivers/clk/clk-bcm2835.c
@@ -29,7 +29,7 @@
  */
 void __init bcm2835_init_clocks(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	int ret;
 
 	clk = clk_register_fixed_rate(NULL, "sys_pclk", NULL, CLK_IS_ROOT,
diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
index 57a078e..e505693 100644
--- a/drivers/clk/clk-composite.c
+++ b/drivers/clk/clk-composite.c
@@ -57,7 +57,7 @@ static unsigned long clk_composite_recalc_rate(struct clk_hw *hw,
 
 static long clk_composite_determine_rate(struct clk_hw *hw, unsigned long rate,
 					unsigned long *best_parent_rate,
-					struct clk **best_parent_p)
+					struct clk_core **best_parent_p)
 {
 	struct clk_composite *composite = to_clk_composite(hw);
 	const struct clk_ops *rate_ops = composite->rate_ops;
@@ -136,14 +136,14 @@ static void clk_composite_disable(struct clk_hw *hw)
 	gate_ops->disable(gate_hw);
 }
 
-struct clk *clk_register_composite(struct device *dev, const char *name,
+struct clk_core *clk_register_composite(struct device *dev, const char *name,
 			const char **parent_names, int num_parents,
 			struct clk_hw *mux_hw, const struct clk_ops *mux_ops,
 			struct clk_hw *rate_hw, const struct clk_ops *rate_ops,
 			struct clk_hw *gate_hw, const struct clk_ops *gate_ops,
 			unsigned long flags)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 	struct clk_composite *composite;
 	struct clk_ops *clk_composite_ops;
diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 18a9de2..3c78139 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -366,14 +366,14 @@ const struct clk_ops clk_divider_ro_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_divider_ro_ops);
 
-static struct clk *_register_divider(struct device *dev, const char *name,
+static struct clk_core *_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, const struct clk_div_table *table,
 		spinlock_t *lock)
 {
 	struct clk_divider *div;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	if (clk_divider_flags & CLK_DIVIDER_HIWORD_MASK) {
@@ -429,7 +429,7 @@ static struct clk *_register_divider(struct device *dev, const char *name,
  * @clk_divider_flags: divider-specific flags for this clock
  * @lock: shared register lock for this clock
  */
-struct clk *clk_register_divider(struct device *dev, const char *name,
+struct clk_core *clk_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, spinlock_t *lock)
@@ -453,7 +453,7 @@ EXPORT_SYMBOL_GPL(clk_register_divider);
  * @table: array of divider/value pairs ending with a div set to 0
  * @lock: shared register lock for this clock
  */
-struct clk *clk_register_divider_table(struct device *dev, const char *name,
+struct clk_core *clk_register_divider_table(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, const struct clk_div_table *table,
diff --git a/drivers/clk/clk-efm32gg.c b/drivers/clk/clk-efm32gg.c
index bac2ddf..26e0485 100644
--- a/drivers/clk/clk-efm32gg.c
+++ b/drivers/clk/clk-efm32gg.c
@@ -16,7 +16,7 @@
 
 #define CMU_HFPERCLKEN0		0x44
 
-static struct clk *clk[37];
+static struct clk_core *clk[37];
 static struct clk_onecell_data clk_data = {
 	.clks = clk,
 	.clk_num = ARRAY_SIZE(clk),
diff --git a/drivers/clk/clk-fixed-factor.c b/drivers/clk/clk-fixed-factor.c
index d9e3f67..ae1fef0 100644
--- a/drivers/clk/clk-fixed-factor.c
+++ b/drivers/clk/clk-fixed-factor.c
@@ -65,13 +65,13 @@ struct clk_ops clk_fixed_factor_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_fixed_factor_ops);
 
-struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
+struct clk_core *clk_register_fixed_factor(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned int mult, unsigned int div)
 {
 	struct clk_fixed_factor *fix;
 	struct clk_init_data init;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	fix = kmalloc(sizeof(*fix), GFP_KERNEL);
 	if (!fix) {
@@ -105,7 +105,7 @@ EXPORT_SYMBOL_GPL(clk_register_fixed_factor);
  */
 void __init of_fixed_factor_clk_setup(struct device_node *node)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *clk_name = node->name;
 	const char *parent_name;
 	u32 div, mult;
diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index 0fc56ab..56c0ced 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -56,12 +56,12 @@ EXPORT_SYMBOL_GPL(clk_fixed_rate_ops);
  * @fixed_rate: non-adjustable clock rate
  * @fixed_accuracy: non-adjustable clock rate
  */
-struct clk *clk_register_fixed_rate_with_accuracy(struct device *dev,
+struct clk_core *clk_register_fixed_rate_with_accuracy(struct device *dev,
 		const char *name, const char *parent_name, unsigned long flags,
 		unsigned long fixed_rate, unsigned long fixed_accuracy)
 {
 	struct clk_fixed_rate *fixed;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	/* allocate fixed-rate clock */
@@ -99,7 +99,7 @@ EXPORT_SYMBOL_GPL(clk_register_fixed_rate_with_accuracy);
  * @flags: framework-specific flags
  * @fixed_rate: non-adjustable clock rate
  */
-struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
+struct clk_core *clk_register_fixed_rate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned long fixed_rate)
 {
@@ -114,7 +114,7 @@ EXPORT_SYMBOL_GPL(clk_register_fixed_rate);
  */
 void of_fixed_clk_setup(struct device_node *node)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *clk_name = node->name;
 	u32 rate;
 	u32 accuracy = 0;
diff --git a/drivers/clk/clk-fractional-divider.c b/drivers/clk/clk-fractional-divider.c
index ede685c..8104683 100644
--- a/drivers/clk/clk-fractional-divider.c
+++ b/drivers/clk/clk-fractional-divider.c
@@ -96,14 +96,14 @@ const struct clk_ops clk_fractional_divider_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_fractional_divider_ops);
 
-struct clk *clk_register_fractional_divider(struct device *dev,
+struct clk_core *clk_register_fractional_divider(struct device *dev,
 		const char *name, const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 mshift, u8 mwidth, u8 nshift, u8 nwidth,
 		u8 clk_divider_flags, spinlock_t *lock)
 {
 	struct clk_fractional_divider *fd;
 	struct clk_init_data init;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	fd = kzalloc(sizeof(*fd), GFP_KERNEL);
 	if (!fd) {
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index 4a58c55..429d302 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -118,13 +118,13 @@ EXPORT_SYMBOL_GPL(clk_gate_ops);
  * @clk_gate_flags: gate-specific flags for this clock
  * @lock: shared register lock for this clock
  */
-struct clk *clk_register_gate(struct device *dev, const char *name,
+struct clk_core *clk_register_gate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 bit_idx,
 		u8 clk_gate_flags, spinlock_t *lock)
 {
 	struct clk_gate *gate;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	if (clk_gate_flags & CLK_GATE_HIWORD_MASK) {
diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index 2e7e9d9..cc1bae1 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -271,10 +271,10 @@ static const struct clk_ops periclk_ops = {
 	.set_rate = clk_periclk_set_rate,
 };
 
-static __init struct clk *hb_clk_init(struct device_node *node, const struct clk_ops *ops)
+static __init struct clk_core *hb_clk_init(struct device_node *node, const struct clk_ops *ops)
 {
 	u32 reg;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct hb_clk *hb_clk;
 	const char *clk_name = node->name;
 	const char *parent_name;
@@ -330,8 +330,8 @@ CLK_OF_DECLARE(hb_a9periph, "calxeda,hb-a9periph-clock", hb_a9periph_init);
 
 static void __init hb_a9bus_init(struct device_node *node)
 {
-	struct clk *clk = hb_clk_init(node, &a9bclk_ops);
-	clk_prepare_enable(clk);
+	struct clk_core *clk = hb_clk_init(node, &a9bclk_ops);
+	clk_prepare_enable(clk_core_to_clk(clk));
 }
 CLK_OF_DECLARE(hb_a9bus, "calxeda,hb-a9bus-clock", hb_a9bus_init);
 
diff --git a/drivers/clk/clk-ls1x.c b/drivers/clk/clk-ls1x.c
index f20b750..c7d46d1 100644
--- a/drivers/clk/clk-ls1x.c
+++ b/drivers/clk/clk-ls1x.c
@@ -48,11 +48,11 @@ static const struct clk_ops ls1x_pll_clk_ops = {
 	.recalc_rate = ls1x_pll_recalc_rate,
 };
 
-static struct clk * __init clk_register_pll(struct device *dev,
+static struct clk_core * __init clk_register_pll(struct device *dev,
 	 const char *name, const char *parent_name, unsigned long flags)
 {
 	struct clk_hw *hw;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	/* allocate the divider */
@@ -80,32 +80,32 @@ static struct clk * __init clk_register_pll(struct device *dev,
 
 void __init ls1x_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = clk_register_pll(NULL, "pll_clk", NULL, CLK_IS_ROOT);
-	clk_prepare_enable(clk);
+	clk_prepare_enable(clk_core_to_clk(clk));
 
 	clk = clk_register_divider(NULL, "cpu_clk", "pll_clk",
 			CLK_SET_RATE_PARENT, LS1X_CLK_PLL_DIV, DIV_CPU_SHIFT,
 			DIV_CPU_WIDTH, CLK_DIVIDER_ONE_BASED, &_lock);
-	clk_prepare_enable(clk);
+	clk_prepare_enable(clk_core_to_clk(clk));
 	clk_register_clkdev(clk, "cpu", NULL);
 
 	clk = clk_register_divider(NULL, "dc_clk", "pll_clk",
 			CLK_SET_RATE_PARENT, LS1X_CLK_PLL_DIV, DIV_DC_SHIFT,
 			DIV_DC_WIDTH, CLK_DIVIDER_ONE_BASED, &_lock);
-	clk_prepare_enable(clk);
+	clk_prepare_enable(clk_core_to_clk(clk));
 	clk_register_clkdev(clk, "dc", NULL);
 
 	clk = clk_register_divider(NULL, "ahb_clk", "pll_clk",
 			CLK_SET_RATE_PARENT, LS1X_CLK_PLL_DIV, DIV_DDR_SHIFT,
 			DIV_DDR_WIDTH, CLK_DIVIDER_ONE_BASED, &_lock);
-	clk_prepare_enable(clk);
+	clk_prepare_enable(clk_core_to_clk(clk));
 	clk_register_clkdev(clk, "ahb", NULL);
 	clk_register_clkdev(clk, "stmmaceth", NULL);
 
 	clk = clk_register_fixed_factor(NULL, "apb_clk", "ahb_clk", 0, 1, 2);
-	clk_prepare_enable(clk);
+	clk_prepare_enable(clk_core_to_clk(clk));
 	clk_register_clkdev(clk, "apb", NULL);
 	clk_register_clkdev(clk, "serial8250", NULL);
 }
diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
index 3d7e8dd..42fa43a 100644
--- a/drivers/clk/clk-max77686.c
+++ b/drivers/clk/clk-max77686.c
@@ -112,10 +112,10 @@ static struct clk_init_data max77686_clks_init[MAX77686_CLKS_NUM] = {
 	},
 };
 
-static struct clk *max77686_clk_register(struct device *dev,
+static struct clk_core *max77686_clk_register(struct device *dev,
 				struct max77686_clk *max77686)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_hw *hw = &max77686->hw;
 
 	clk = clk_register(dev, hw);
@@ -138,10 +138,10 @@ static int max77686_clk_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct max77686_clk *max77686_clks[MAX77686_CLKS_NUM];
-	struct clk **clocks;
+	struct clk_core **clocks;
 	int i, ret;
 
-	clocks = devm_kzalloc(&pdev->dev, sizeof(struct clk *)
+	clocks = devm_kzalloc(&pdev->dev, sizeof(struct clk_core *)
 					* MAX77686_CLKS_NUM, GFP_KERNEL);
 	if (!clocks)
 		return -ENOMEM;
@@ -203,7 +203,7 @@ err_clocks:
 static int max77686_clk_remove(struct platform_device *pdev)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct clk **clocks = platform_get_drvdata(pdev);
+	struct clk_core **clocks = platform_get_drvdata(pdev);
 	int i;
 
 	if (iodev->dev->of_node)
diff --git a/drivers/clk/clk-moxart.c b/drivers/clk/clk-moxart.c
index 30a3b69..c503c09 100644
--- a/drivers/clk/clk-moxart.c
+++ b/drivers/clk/clk-moxart.c
@@ -18,7 +18,7 @@
 void __init moxart_of_pll_clk_init(struct device_node *node)
 {
 	static void __iomem *base;
-	struct clk *clk, *ref_clk;
+	struct clk_core *clk, *ref_clk;
 	unsigned int mul;
 	const char *name = node->name;
 	const char *parent_name;
@@ -35,7 +35,7 @@ void __init moxart_of_pll_clk_init(struct device_node *node)
 	mul = readl(base + 0x30) >> 3 & 0x3f;
 	iounmap(base);
 
-	ref_clk = of_clk_get(node, 0);
+	ref_clk = of_clk_provider_get(node, 0);
 	if (IS_ERR(ref_clk)) {
 		pr_err("%s: of_clk_get failed\n", node->full_name);
 		return;
@@ -56,7 +56,7 @@ CLK_OF_DECLARE(moxart_pll_clock, "moxa,moxart-pll-clock",
 void __init moxart_of_apb_clk_init(struct device_node *node)
 {
 	static void __iomem *base;
-	struct clk *clk, *pll_clk;
+	struct clk_core *clk, *pll_clk;
 	unsigned int div, val;
 	unsigned int div_idx[] = { 2, 3, 4, 6, 8};
 	const char *name = node->name;
@@ -78,7 +78,7 @@ void __init moxart_of_apb_clk_init(struct device_node *node)
 		val = 0;
 	div = div_idx[val] * 2;
 
-	pll_clk = of_clk_get(node, 0);
+	pll_clk = of_clk_provider_get(node, 0);
 	if (IS_ERR(pll_clk)) {
 		pr_err("%s: of_clk_get failed\n", node->full_name);
 		return;
diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 4f96ff3..2879053 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -113,13 +113,13 @@ const struct clk_ops clk_mux_ro_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_mux_ro_ops);
 
-struct clk *clk_register_mux_table(struct device *dev, const char *name,
+struct clk_core *clk_register_mux_table(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u32 mask,
 		u8 clk_mux_flags, u32 *table, spinlock_t *lock)
 {
 	struct clk_mux *mux;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 	u8 width = 0;
 
@@ -165,7 +165,7 @@ struct clk *clk_register_mux_table(struct device *dev, const char *name,
 }
 EXPORT_SYMBOL_GPL(clk_register_mux_table);
 
-struct clk *clk_register_mux(struct device *dev, const char *name,
+struct clk_core *clk_register_mux(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_mux_flags, spinlock_t *lock)
diff --git a/drivers/clk/clk-nomadik.c b/drivers/clk/clk-nomadik.c
index 05e04ce..5d87366 100644
--- a/drivers/clk/clk-nomadik.c
+++ b/drivers/clk/clk-nomadik.c
@@ -254,11 +254,11 @@ static const struct clk_ops pll_clk_ops = {
 	.recalc_rate = pll_clk_recalc_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 pll_clk_register(struct device *dev, const char *name,
 		 const char *parent_name, u32 id)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_pll *pll;
 	struct clk_init_data init;
 
@@ -346,11 +346,11 @@ static const struct clk_ops src_clk_ops = {
 	.recalc_rate = src_clk_recalc_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 src_clk_register(struct device *dev, const char *name,
 		 const char *parent_name, u8 id)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_src *sclk;
 	struct clk_init_data init;
 
@@ -510,7 +510,7 @@ module_init(nomadik_src_clk_init_debugfs);
 
 static void __init of_nomadik_pll_setup(struct device_node *np)
 {
-	struct clk *clk = ERR_PTR(-EINVAL);
+	struct clk_core *clk = ERR_PTR(-EINVAL);
 	const char *clk_name = np->name;
 	const char *parent_name;
 	u32 pll_id;
@@ -533,7 +533,7 @@ CLK_OF_DECLARE(nomadik_pll_clk,
 
 static void __init of_nomadik_hclk_setup(struct device_node *np)
 {
-	struct clk *clk = ERR_PTR(-EINVAL);
+	struct clk_core *clk = ERR_PTR(-EINVAL);
 	const char *clk_name = np->name;
 	const char *parent_name;
 
@@ -557,7 +557,7 @@ CLK_OF_DECLARE(nomadik_hclk_clk,
 
 static void __init of_nomadik_src_clk_setup(struct device_node *np)
 {
-	struct clk *clk = ERR_PTR(-EINVAL);
+	struct clk_core *clk = ERR_PTR(-EINVAL);
 	const char *clk_name = np->name;
 	const char *parent_name;
 	u32 clk_id;
diff --git a/drivers/clk/clk-nspire.c b/drivers/clk/clk-nspire.c
index a378db7..e9c43f4 100644
--- a/drivers/clk/clk-nspire.c
+++ b/drivers/clk/clk-nspire.c
@@ -69,7 +69,7 @@ static void __init nspire_ahbdiv_setup(struct device_node *node,
 {
 	u32 val;
 	void __iomem *io;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *clk_name = node->name;
 	const char *parent_name;
 	struct nspire_clk_info info;
@@ -111,7 +111,7 @@ static void __init nspire_clk_setup(struct device_node *node,
 {
 	u32 val;
 	void __iomem *io;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *clk_name = node->name;
 	struct nspire_clk_info info;
 
diff --git a/drivers/clk/clk-ppc-corenet.c b/drivers/clk/clk-ppc-corenet.c
index 8b284be..b82e7f0 100644
--- a/drivers/clk/clk-ppc-corenet.c
+++ b/drivers/clk/clk-ppc-corenet.c
@@ -64,7 +64,7 @@ const struct clk_ops cmux_ops = {
 
 static void __init core_mux_init(struct device_node *np)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 	struct cmux_clk *cmux_clk;
 	struct device_node *node;
@@ -150,7 +150,7 @@ static void __init core_pll_init(struct device_node *np)
 	int i, rc, count;
 	const char *clk_name, *parent_name;
 	struct clk_onecell_data *onecell_data;
-	struct clk      **subclks;
+	struct clk_core      **subclks;
 	void __iomem *base;
 
 	base = of_iomap(np, 0);
@@ -184,7 +184,7 @@ static void __init core_pll_init(struct device_node *np)
 	/* output clock number per PLL */
 	clocks_per_pll = count;
 
-	subclks = kzalloc(sizeof(struct clk *) * count, GFP_KERNEL);
+	subclks = kzalloc(sizeof(struct clk_core *) * count, GFP_KERNEL);
 	if (!subclks) {
 		pr_err("%s: could not allocate subclks\n", __func__);
 		goto err_map;
@@ -246,7 +246,7 @@ err_map:
 
 static void __init sysclk_init(struct device_node *node)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *clk_name = node->name;
 	struct device_node *np = of_get_parent(node);
 	u32 rate;
diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 9b7b585..7d3c50f 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -29,7 +29,7 @@
 
 #define s2mps11_name(a) (a->hw.init->name)
 
-static struct clk **clk_table;
+static struct clk_core **clk_table;
 static struct clk_onecell_data clk_data;
 
 enum {
@@ -43,7 +43,7 @@ struct s2mps11_clk {
 	struct sec_pmic_dev *iodev;
 	struct device_node *clk_np;
 	struct clk_hw hw;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_lookup *lookup;
 	u32 mask;
 	bool enabled;
@@ -178,7 +178,7 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 
 	s2mps11_clk = s2mps11_clks;
 
-	clk_table = devm_kzalloc(&pdev->dev, sizeof(struct clk *) *
+	clk_table = devm_kzalloc(&pdev->dev, sizeof(struct clk_core *) *
 				 S2MPS11_CLKS_NUM, GFP_KERNEL);
 	if (!clk_table)
 		return -ENOMEM;
diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index 3b2a66f..57c9eb5 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -56,10 +56,10 @@ struct si5351_driver_data {
 	struct regmap		*regmap;
 	struct clk_onecell_data onecell;
 
-	struct clk		*pxtal;
+	struct clk_core		*pxtal;
 	const char		*pxtal_name;
 	struct clk_hw		xtal;
-	struct clk		*pclkin;
+	struct clk_core		*pclkin;
 	const char		*pclkin_name;
 	struct clk_hw		clkin;
 
@@ -1128,12 +1128,12 @@ static int si5351_dt_parse(struct i2c_client *client,
 	if (!pdata)
 		return -ENOMEM;
 
-	pdata->clk_xtal = of_clk_get(np, 0);
+	pdata->clk_xtal = of_clk_provider_get(np, 0);
 	if (!IS_ERR(pdata->clk_xtal))
-		clk_put(pdata->clk_xtal);
-	pdata->clk_clkin = of_clk_get(np, 1);
+		__clk_put(pdata->clk_xtal);
+	pdata->clk_clkin = of_clk_provider_get(np, 1);
 	if (!IS_ERR(pdata->clk_clkin))
-		clk_put(pdata->clk_clkin);
+		__clk_put(pdata->clk_clkin);
 
 	/*
 	 * property silabs,pll-source : <num src>, [<..>]
@@ -1306,7 +1306,7 @@ static int si5351_i2c_probe(struct i2c_client *client,
 	struct si5351_platform_data *pdata;
 	struct si5351_driver_data *drvdata;
 	struct clk_init_data init;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_names[4];
 	u8 num_parents, num_clocks;
 	int ret, n;
@@ -1545,7 +1545,8 @@ static int si5351_i2c_probe(struct i2c_client *client,
 		/* set initial clkout rate */
 		if (pdata->clkout[n].rate != 0) {
 			int ret;
-			ret = clk_set_rate(clk, pdata->clkout[n].rate);
+			ret = clk_provider_set_rate(clk,
+						    pdata->clkout[n].rate);
 			if (ret != 0) {
 				dev_err(&client->dev, "Cannot set rate : %d\n",
 					ret);
diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
index fc167b3..f0eec4e 100644
--- a/drivers/clk/clk-si570.c
+++ b/drivers/clk/clk-si570.c
@@ -407,7 +407,7 @@ static int si570_probe(struct i2c_client *client,
 {
 	struct clk_si570 *data;
 	struct clk_init_data init;
-	struct clk *clk;
+	struct clk_core *clk;
 	u32 initial_fout, factory_fout, stability;
 	int err;
 	enum clk_si570_variant variant = id->driver_data;
@@ -476,7 +476,7 @@ static int si570_probe(struct i2c_client *client,
 	/* Read the requested initial output frequency from device tree */
 	if (!of_property_read_u32(client->dev.of_node, "clock-frequency",
 				&initial_fout)) {
-		err = clk_set_rate(clk, initial_fout);
+		err = clk_provider_set_rate(clk, initial_fout);
 		if (err) {
 			of_clk_del_provider(client->dev.of_node);
 			return err;
diff --git a/drivers/clk/clk-twl6040.c b/drivers/clk/clk-twl6040.c
index 1ada79a..2422857 100644
--- a/drivers/clk/clk-twl6040.c
+++ b/drivers/clk/clk-twl6040.c
@@ -31,7 +31,7 @@ struct twl6040_clk {
 	struct twl6040 *twl6040;
 	struct device *dev;
 	struct clk_hw mcpdm_fclk;
-	struct clk *clk;
+	struct clk_core *clk;
 	int enabled;
 };
 
diff --git a/drivers/clk/clk-u300.c b/drivers/clk/clk-u300.c
index 406bfc1..7e9ec00 100644
--- a/drivers/clk/clk-u300.c
+++ b/drivers/clk/clk-u300.c
@@ -688,7 +688,7 @@ static const struct clk_ops syscon_clk_ops = {
 	.set_rate = syscon_clk_set_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 syscon_clk_register(struct device *dev, const char *name,
 		    const char *parent_name, unsigned long flags,
 		    bool hw_ctrld,
@@ -696,7 +696,7 @@ syscon_clk_register(struct device *dev, const char *name,
 		    void __iomem *en_reg, u8 en_bit,
 		    u16 clk_val)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_syscon *sclk;
 	struct clk_init_data init;
 
@@ -867,7 +867,7 @@ static struct u300_clock const u300_clk_lookup[] __initconst = {
 
 static void __init of_u300_syscon_clk_init(struct device_node *np)
 {
-	struct clk *clk = ERR_PTR(-EINVAL);
+	struct clk_core *clk = ERR_PTR(-EINVAL);
 	const char *clk_name = np->name;
 	const char *parent_name;
 	void __iomem *res_reg;
@@ -1110,11 +1110,11 @@ static const struct clk_ops mclk_ops = {
 	.set_rate = mclk_clk_set_rate,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 mclk_clk_register(struct device *dev, const char *name,
 		  const char *parent_name, bool is_mspro)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_mclk *mclk;
 	struct clk_init_data init;
 
@@ -1141,7 +1141,7 @@ mclk_clk_register(struct device *dev, const char *name,
 
 static void __init of_u300_syscon_mclk_init(struct device_node *np)
 {
-	struct clk *clk = ERR_PTR(-EINVAL);
+	struct clk_core *clk = ERR_PTR(-EINVAL);
 	const char *clk_name = np->name;
 	const char *parent_name;
 
diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index 37e9288..e5fb933 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -232,7 +232,7 @@ static const struct clk_ops vt8500_gated_divisor_clk_ops = {
 static __init void vtwm_device_clk_init(struct device_node *node)
 {
 	u32 en_reg, div_reg;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_device *dev_clk;
 	const char *clk_name = node->name;
 	const char *parent_name;
@@ -650,7 +650,7 @@ static const struct clk_ops vtwm_pll_ops = {
 static __init void vtwm_pll_clk_init(struct device_node *node, int pll_type)
 {
 	u32 reg;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_pll *pll_clk;
 	const char *clk_name = node->name;
 	const char *parent_name;
diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
index b131041..d2d745e 100644
--- a/drivers/clk/clk-wm831x.c
+++ b/drivers/clk/clk-wm831x.c
@@ -25,9 +25,9 @@ struct wm831x_clk {
 	struct clk_hw xtal_hw;
 	struct clk_hw fll_hw;
 	struct clk_hw clkout_hw;
-	struct clk *xtal;
-	struct clk *fll;
-	struct clk *clkout;
+	struct clk_core *xtal;
+	struct clk_core *fll;
+	struct clk_core *clkout;
 	bool xtal_ena;
 };
 
diff --git a/drivers/clk/clk-xgene.c b/drivers/clk/clk-xgene.c
index dd8a62d..ce3ed34 100644
--- a/drivers/clk/clk-xgene.c
+++ b/drivers/clk/clk-xgene.c
@@ -124,13 +124,13 @@ const struct clk_ops xgene_clk_pll_ops = {
 	.recalc_rate = xgene_clk_pll_recalc_rate,
 };
 
-static struct clk *xgene_register_clk_pll(struct device *dev,
+static struct clk_core *xgene_register_clk_pll(struct device *dev,
 	const char *name, const char *parent_name,
 	unsigned long flags, void __iomem *reg, u32 pll_offset,
 	u32 type, spinlock_t *lock)
 {
 	struct xgene_clk_pll *apmclk;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	/* allocate the APM clock structure */
@@ -166,7 +166,7 @@ static struct clk *xgene_register_clk_pll(struct device *dev,
 static void xgene_pllclk_init(struct device_node *np, enum xgene_pll_type pll_type)
 {
         const char *clk_name = np->full_name;
-        struct clk *clk;
+        struct clk_core *clk;
         void *reg;
 
         reg = of_iomap(np, 0);
@@ -395,12 +395,12 @@ const struct clk_ops xgene_clk_ops = {
 	.round_rate = xgene_clk_round_rate,
 };
 
-static struct clk *xgene_register_clk(struct device *dev,
+static struct clk_core *xgene_register_clk(struct device *dev,
 		const char *name, const char *parent_name,
 		struct xgene_dev_parameters *parameters, spinlock_t *lock)
 {
 	struct xgene_clk *apmclk;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 	int rc;
 
@@ -442,7 +442,7 @@ static struct clk *xgene_register_clk(struct device *dev,
 static void __init xgene_devclk_init(struct device_node *np)
 {
 	const char *clk_name = np->full_name;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct resource res;
 	int rc;
 	struct xgene_dev_parameters parameters;
diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
index c798138..d278572 100644
--- a/drivers/clk/clk.h
+++ b/drivers/clk/clk.h
@@ -10,8 +10,8 @@
  */
 
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
-struct clk *of_clk_get_by_clkspec(struct of_phandle_args *clkspec);
-struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
+struct clk_core *of_clk_get_by_clkspec(struct of_phandle_args *clkspec);
+struct clk_core *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
 void of_clk_lock(void);
 void of_clk_unlock(void);
 #endif
diff --git a/drivers/clk/hisilicon/clk-hi3620.c b/drivers/clk/hisilicon/clk-hi3620.c
index 339945d..d7d3667 100644
--- a/drivers/clk/hisilicon/clk-hi3620.c
+++ b/drivers/clk/hisilicon/clk-hi3620.c
@@ -296,7 +296,7 @@ static unsigned long mmc_clk_recalc_rate(struct clk_hw *hw,
 
 static long mmc_clk_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
-			      struct clk **best_parent_p)
+			      struct clk_core **best_parent_p)
 {
 	struct clk_mmc *mclk = to_mmc(hw);
 	unsigned long best = 0;
@@ -427,11 +427,11 @@ static struct clk_ops clk_mmc_ops = {
 	.recalc_rate = mmc_clk_recalc_rate,
 };
 
-static struct clk *hisi_register_clk_mmc(struct hisi_mmc_clock *mmc_clk,
+static struct clk_core *hisi_register_clk_mmc(struct hisi_mmc_clock *mmc_clk,
 			void __iomem *base, struct device_node *np)
 {
 	struct clk_mmc *mclk;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	mclk = kzalloc(sizeof(*mclk), GFP_KERNEL);
@@ -487,7 +487,7 @@ static void __init hi3620_mmc_clk_init(struct device_node *node)
 	if (WARN_ON(!clk_data))
 		return;
 
-	clk_data->clks = kzalloc(sizeof(struct clk *) * num, GFP_KERNEL);
+	clk_data->clks = kzalloc(sizeof(struct clk_core *) * num, GFP_KERNEL);
 	if (!clk_data->clks) {
 		pr_err("%s: fail to allocate mmc clk\n", __func__);
 		return;
diff --git a/drivers/clk/hisilicon/clk.c b/drivers/clk/hisilicon/clk.c
index a078e84..3fcd2ba 100644
--- a/drivers/clk/hisilicon/clk.c
+++ b/drivers/clk/hisilicon/clk.c
@@ -42,7 +42,7 @@ struct hisi_clock_data __init *hisi_clk_init(struct device_node *np,
 					     int nr_clks)
 {
 	struct hisi_clock_data *clk_data;
-	struct clk **clk_table;
+	struct clk_core **clk_table;
 	void __iomem *base;
 
 	if (np) {
@@ -63,7 +63,7 @@ struct hisi_clock_data __init *hisi_clk_init(struct device_node *np,
 	}
 	clk_data->base = base;
 
-	clk_table = kzalloc(sizeof(struct clk *) * nr_clks, GFP_KERNEL);
+	clk_table = kzalloc(sizeof(struct clk_core *) * nr_clks, GFP_KERNEL);
 	if (!clk_table) {
 		pr_err("%s: could not allocate clock lookup table\n", __func__);
 		goto err_data;
@@ -81,7 +81,7 @@ err:
 void __init hisi_clk_register_fixed_rate(struct hisi_fixed_rate_clock *clks,
 					 int nums, struct hisi_clock_data *data)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	int i;
 
 	for (i = 0; i < nums; i++) {
@@ -102,7 +102,7 @@ void __init hisi_clk_register_fixed_factor(struct hisi_fixed_factor_clock *clks,
 					   int nums,
 					   struct hisi_clock_data *data)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	int i;
 
 	for (i = 0; i < nums; i++) {
@@ -122,7 +122,7 @@ void __init hisi_clk_register_fixed_factor(struct hisi_fixed_factor_clock *clks,
 void __init hisi_clk_register_mux(struct hisi_mux_clock *clks,
 				  int nums, struct hisi_clock_data *data)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	void __iomem *base = data->base;
 	int i;
 
@@ -151,7 +151,7 @@ void __init hisi_clk_register_mux(struct hisi_mux_clock *clks,
 void __init hisi_clk_register_divider(struct hisi_divider_clock *clks,
 				      int nums, struct hisi_clock_data *data)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	void __iomem *base = data->base;
 	int i;
 
@@ -180,7 +180,7 @@ void __init hisi_clk_register_divider(struct hisi_divider_clock *clks,
 void __init hisi_clk_register_gate(struct hisi_gate_clock *clks,
 				       int nums, struct hisi_clock_data *data)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	void __iomem *base = data->base;
 	int i;
 
@@ -208,7 +208,7 @@ void __init hisi_clk_register_gate(struct hisi_gate_clock *clks,
 void __init hisi_clk_register_gate_sep(struct hisi_gate_clock *clks,
 				       int nums, struct hisi_clock_data *data)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	void __iomem *base = data->base;
 	int i;
 
diff --git a/drivers/clk/hisilicon/clk.h b/drivers/clk/hisilicon/clk.h
index 31083ff..f7fc4b9 100644
--- a/drivers/clk/hisilicon/clk.h
+++ b/drivers/clk/hisilicon/clk.h
@@ -90,7 +90,7 @@ struct hisi_gate_clock {
 	const char		*alias;
 };
 
-struct clk *hisi_register_clkgate_sep(struct device *, const char *,
+struct clk_core *hisi_register_clkgate_sep(struct device *, const char *,
 				const char *, unsigned long,
 				void __iomem *, u8,
 				u8, spinlock_t *);
diff --git a/drivers/clk/hisilicon/clkgate-separated.c b/drivers/clk/hisilicon/clkgate-separated.c
index b03d5a7..61f7236 100644
--- a/drivers/clk/hisilicon/clkgate-separated.c
+++ b/drivers/clk/hisilicon/clkgate-separated.c
@@ -96,14 +96,14 @@ static struct clk_ops clkgate_separated_ops = {
 	.is_enabled	= clkgate_separated_is_enabled,
 };
 
-struct clk *hisi_register_clkgate_sep(struct device *dev, const char *name,
+struct clk_core *hisi_register_clkgate_sep(struct device *dev, const char *name,
 				      const char *parent_name,
 				      unsigned long flags,
 				      void __iomem *reg, u8 bit_idx,
 				      u8 clk_gate_flags, spinlock_t *lock)
 {
 	struct clkgate_separated *sclk;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	sclk = kzalloc(sizeof(*sclk), GFP_KERNEL);
diff --git a/drivers/clk/keystone/gate.c b/drivers/clk/keystone/gate.c
index 86f1e36..3f7db44 100644
--- a/drivers/clk/keystone/gate.c
+++ b/drivers/clk/keystone/gate.c
@@ -163,7 +163,7 @@ static const struct clk_ops clk_psc_ops = {
  * @psc_data: platform data to configure this clock
  * @lock: spinlock used by this clock
  */
-static struct clk *clk_register_psc(struct device *dev,
+static struct clk_core *clk_register_psc(struct device *dev,
 			const char *name,
 			const char *parent_name,
 			struct clk_psc_data *psc_data,
@@ -171,7 +171,7 @@ static struct clk *clk_register_psc(struct device *dev,
 {
 	struct clk_init_data init;
 	struct clk_psc *psc;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	psc = kzalloc(sizeof(*psc), GFP_KERNEL);
 	if (!psc)
@@ -204,7 +204,7 @@ static void __init of_psc_clk_init(struct device_node *node, spinlock_t *lock)
 	const char *clk_name = node->name;
 	const char *parent_name;
 	struct clk_psc_data *data;
-	struct clk *clk;
+	struct clk_core *clk;
 	int i;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
diff --git a/drivers/clk/keystone/pll.c b/drivers/clk/keystone/pll.c
index 0dd8a4b..fc3156e 100644
--- a/drivers/clk/keystone/pll.c
+++ b/drivers/clk/keystone/pll.c
@@ -116,14 +116,14 @@ static const struct clk_ops clk_pll_ops = {
 	.recalc_rate = clk_pllclk_recalc,
 };
 
-static struct clk *clk_register_pll(struct device *dev,
+static struct clk_core *clk_register_pll(struct device *dev,
 			const char *name,
 			const char *parent_name,
 			struct clk_pll_data *pll_data)
 {
 	struct clk_init_data init;
 	struct clk_pll *pll;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
 	if (!pll)
@@ -158,7 +158,7 @@ static void __init _of_pll_clk_init(struct device_node *node, bool pllctrl)
 {
 	struct clk_pll_data *pll_data;
 	const char *parent_name;
-	struct clk *clk;
+	struct clk_core *clk;
 	int i;
 
 	pll_data = kzalloc(sizeof(*pll_data), GFP_KERNEL);
@@ -239,7 +239,7 @@ static void __init of_pll_div_clk_init(struct device_node *node)
 	const char *parent_name;
 	void __iomem *reg;
 	u32 shift, mask;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *clk_name = node->name;
 
 	of_property_read_string(node, "clock-output-names", &clk_name);
@@ -282,7 +282,7 @@ static void __init of_pll_mux_clk_init(struct device_node *node)
 {
 	void __iomem *reg;
 	u32 shift, mask;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parents[2];
 	const char *clk_name = node->name;
 
diff --git a/drivers/clk/mmp/clk-apbc.c b/drivers/clk/mmp/clk-apbc.c
index d14120e..4ca8713 100644
--- a/drivers/clk/mmp/clk-apbc.c
+++ b/drivers/clk/mmp/clk-apbc.c
@@ -120,12 +120,12 @@ struct clk_ops clk_apbc_ops = {
 	.unprepare = clk_apbc_unprepare,
 };
 
-struct clk *mmp_clk_register_apbc(const char *name, const char *parent_name,
+struct clk_core *mmp_clk_register_apbc(const char *name, const char *parent_name,
 		void __iomem *base, unsigned int delay,
 		unsigned int apbc_flags, spinlock_t *lock)
 {
 	struct clk_apbc *apbc;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	apbc = kzalloc(sizeof(*apbc), GFP_KERNEL);
diff --git a/drivers/clk/mmp/clk-apmu.c b/drivers/clk/mmp/clk-apmu.c
index abe182b..c24e6e7 100644
--- a/drivers/clk/mmp/clk-apmu.c
+++ b/drivers/clk/mmp/clk-apmu.c
@@ -66,11 +66,11 @@ struct clk_ops clk_apmu_ops = {
 	.disable = clk_apmu_disable,
 };
 
-struct clk *mmp_clk_register_apmu(const char *name, const char *parent_name,
+struct clk_core *mmp_clk_register_apmu(const char *name, const char *parent_name,
 		void __iomem *base, u32 enable_mask, spinlock_t *lock)
 {
 	struct clk_apmu *apmu;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	apmu = kzalloc(sizeof(*apmu), GFP_KERNEL);
diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
index 23a56f5..0386cdd 100644
--- a/drivers/clk/mmp/clk-frac.c
+++ b/drivers/clk/mmp/clk-frac.c
@@ -116,14 +116,14 @@ static struct clk_ops clk_factor_ops = {
 	.set_rate = clk_factor_set_rate,
 };
 
-struct clk *mmp_clk_register_factor(const char *name, const char *parent_name,
+struct clk_core *mmp_clk_register_factor(const char *name, const char *parent_name,
 		unsigned long flags, void __iomem *base,
 		struct clk_factor_masks *masks, struct clk_factor_tbl *ftbl,
 		unsigned int ftbl_cnt)
 {
 	struct clk_factor *factor;
 	struct clk_init_data init;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (!masks) {
 		pr_err("%s: must pass a clk_factor_mask\n", __func__);
diff --git a/drivers/clk/mmp/clk-mmp2.c b/drivers/clk/mmp/clk-mmp2.c
index b2721ca..98bd73f 100644
--- a/drivers/clk/mmp/clk-mmp2.c
+++ b/drivers/clk/mmp/clk-mmp2.c
@@ -77,8 +77,8 @@ static const char *ccic_parent[] = {"pll1_2", "pll1_16", "vctcxo"};
 
 void __init mmp2_clk_init(void)
 {
-	struct clk *clk;
-	struct clk *vctcxo;
+	struct clk_core *clk;
+	struct clk_core *vctcxo;
 	void __iomem *mpmu_base;
 	void __iomem *apmu_base;
 	void __iomem *apbc_base;
@@ -192,7 +192,7 @@ void __init mmp2_clk_init(void)
 				mpmu_base + MPMU_UART_PLL,
 				&uart_factor_masks, uart_factor_tbl,
 				ARRAY_SIZE(uart_factor_tbl));
-	clk_set_rate(clk, 14745600);
+	clk_provider_set_rate(clk, 14745600);
 	clk_register_clkdev(clk, "uart_pll", NULL);
 
 	clk = mmp_clk_register_apbc("twsi0", "vctcxo",
@@ -251,7 +251,7 @@ void __init mmp2_clk_init(void)
 				ARRAY_SIZE(uart_parent),
 				CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
 				apbc_base + APBC_UART0, 4, 3, 0, &clk_lock);
-	clk_set_parent(clk, vctcxo);
+	clk_provider_set_parent(clk, vctcxo);
 	clk_register_clkdev(clk, "uart_mux.0", NULL);
 
 	clk = mmp_clk_register_apbc("uart0", "uart0_mux",
@@ -262,7 +262,7 @@ void __init mmp2_clk_init(void)
 				ARRAY_SIZE(uart_parent),
 				CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
 				apbc_base + APBC_UART1, 4, 3, 0, &clk_lock);
-	clk_set_parent(clk, vctcxo);
+	clk_provider_set_parent(clk, vctcxo);
 	clk_register_clkdev(clk, "uart_mux.1", NULL);
 
 	clk = mmp_clk_register_apbc("uart1", "uart1_mux",
@@ -273,7 +273,7 @@ void __init mmp2_clk_init(void)
 				ARRAY_SIZE(uart_parent),
 				CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
 				apbc_base + APBC_UART2, 4, 3, 0, &clk_lock);
-	clk_set_parent(clk, vctcxo);
+	clk_provider_set_parent(clk, vctcxo);
 	clk_register_clkdev(clk, "uart_mux.2", NULL);
 
 	clk = mmp_clk_register_apbc("uart2", "uart2_mux",
@@ -284,7 +284,7 @@ void __init mmp2_clk_init(void)
 				ARRAY_SIZE(uart_parent),
 				CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
 				apbc_base + APBC_UART3, 4, 3, 0, &clk_lock);
-	clk_set_parent(clk, vctcxo);
+	clk_provider_set_parent(clk, vctcxo);
 	clk_register_clkdev(clk, "uart_mux.3", NULL);
 
 	clk = mmp_clk_register_apbc("uart3", "uart3_mux",
diff --git a/drivers/clk/mmp/clk-pxa168.c b/drivers/clk/mmp/clk-pxa168.c
index 014396b..e4f50ab 100644
--- a/drivers/clk/mmp/clk-pxa168.c
+++ b/drivers/clk/mmp/clk-pxa168.c
@@ -68,8 +68,8 @@ static const char *ccic_phy_parent[] = {"pll1_6", "pll1_12"};
 
 void __init pxa168_clk_init(void)
 {
-	struct clk *clk;
-	struct clk *uart_pll;
+	struct clk_core *clk;
+	struct clk_core *uart_pll;
 	void __iomem *mpmu_base;
 	void __iomem *apmu_base;
 	void __iomem *apbc_base;
@@ -159,7 +159,7 @@ void __init pxa168_clk_init(void)
 				mpmu_base + MPMU_UART_PLL,
 				&uart_factor_masks, uart_factor_tbl,
 				ARRAY_SIZE(uart_factor_tbl));
-	clk_set_rate(uart_pll, 14745600);
+	clk_provider_set_rate(uart_pll, 14745600);
 	clk_register_clkdev(uart_pll, "uart_pll", NULL);
 
 	clk = mmp_clk_register_apbc("twsi0", "pll1_13_1_5",
@@ -202,7 +202,7 @@ void __init pxa168_clk_init(void)
 				ARRAY_SIZE(uart_parent),
 				CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
 				apbc_base + APBC_UART0, 4, 3, 0, &clk_lock);
-	clk_set_parent(clk, uart_pll);
+	clk_provider_set_parent(clk, uart_pll);
 	clk_register_clkdev(clk, "uart_mux.0", NULL);
 
 	clk = mmp_clk_register_apbc("uart0", "uart0_mux",
@@ -213,7 +213,7 @@ void __init pxa168_clk_init(void)
 				ARRAY_SIZE(uart_parent),
 				CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
 				apbc_base + APBC_UART1, 4, 3, 0, &clk_lock);
-	clk_set_parent(clk, uart_pll);
+	clk_provider_set_parent(clk, uart_pll);
 	clk_register_clkdev(clk, "uart_mux.1", NULL);
 
 	clk = mmp_clk_register_apbc("uart1", "uart1_mux",
@@ -224,7 +224,7 @@ void __init pxa168_clk_init(void)
 				ARRAY_SIZE(uart_parent),
 				CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
 				apbc_base + APBC_UART2, 4, 3, 0, &clk_lock);
-	clk_set_parent(clk, uart_pll);
+	clk_provider_set_parent(clk, uart_pll);
 	clk_register_clkdev(clk, "uart_mux.2", NULL);
 
 	clk = mmp_clk_register_apbc("uart2", "uart2_mux",
diff --git a/drivers/clk/mmp/clk-pxa910.c b/drivers/clk/mmp/clk-pxa910.c
index 9efc6a4..b5c215e 100644
--- a/drivers/clk/mmp/clk-pxa910.c
+++ b/drivers/clk/mmp/clk-pxa910.c
@@ -66,8 +66,8 @@ static const char *ccic_phy_parent[] = {"pll1_6", "pll1_12"};
 
 void __init pxa910_clk_init(void)
 {
-	struct clk *clk;
-	struct clk *uart_pll;
+	struct clk_core *clk;
+	struct clk_core *uart_pll;
 	void __iomem *mpmu_base;
 	void __iomem *apmu_base;
 	void __iomem *apbcp_base;
@@ -164,7 +164,7 @@ void __init pxa910_clk_init(void)
 				mpmu_base + MPMU_UART_PLL,
 				&uart_factor_masks, uart_factor_tbl,
 				ARRAY_SIZE(uart_factor_tbl));
-	clk_set_rate(uart_pll, 14745600);
+	clk_provider_set_rate(uart_pll, 14745600);
 	clk_register_clkdev(uart_pll, "uart_pll", NULL);
 
 	clk = mmp_clk_register_apbc("twsi0", "pll1_13_1_5",
@@ -207,7 +207,7 @@ void __init pxa910_clk_init(void)
 				ARRAY_SIZE(uart_parent),
 				CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
 				apbc_base + APBC_UART0, 4, 3, 0, &clk_lock);
-	clk_set_parent(clk, uart_pll);
+	clk_provider_set_parent(clk, uart_pll);
 	clk_register_clkdev(clk, "uart_mux.0", NULL);
 
 	clk = mmp_clk_register_apbc("uart0", "uart0_mux",
@@ -218,7 +218,7 @@ void __init pxa910_clk_init(void)
 				ARRAY_SIZE(uart_parent),
 				CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
 				apbc_base + APBC_UART1, 4, 3, 0, &clk_lock);
-	clk_set_parent(clk, uart_pll);
+	clk_provider_set_parent(clk, uart_pll);
 	clk_register_clkdev(clk, "uart_mux.1", NULL);
 
 	clk = mmp_clk_register_apbc("uart1", "uart1_mux",
@@ -229,7 +229,7 @@ void __init pxa910_clk_init(void)
 				ARRAY_SIZE(uart_parent),
 				CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
 				apbcp_base + APBCP_UART2, 4, 3, 0, &clk_lock);
-	clk_set_parent(clk, uart_pll);
+	clk_provider_set_parent(clk, uart_pll);
 	clk_register_clkdev(clk, "uart_mux.2", NULL);
 
 	clk = mmp_clk_register_apbc("uart2", "uart2_mux",
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
index ab86dd4..1477e61 100644
--- a/drivers/clk/mmp/clk.h
+++ b/drivers/clk/mmp/clk.h
@@ -20,15 +20,15 @@ struct clk_factor_tbl {
 	unsigned int den;
 };
 
-extern struct clk *mmp_clk_register_pll2(const char *name,
+extern struct clk_core *mmp_clk_register_pll2(const char *name,
 		const char *parent_name, unsigned long flags);
-extern struct clk *mmp_clk_register_apbc(const char *name,
+extern struct clk_core *mmp_clk_register_apbc(const char *name,
 		const char *parent_name, void __iomem *base,
 		unsigned int delay, unsigned int apbc_flags, spinlock_t *lock);
-extern struct clk *mmp_clk_register_apmu(const char *name,
+extern struct clk_core *mmp_clk_register_apmu(const char *name,
 		const char *parent_name, void __iomem *base, u32 enable_mask,
 		spinlock_t *lock);
-extern struct clk *mmp_clk_register_factor(const char *name,
+extern struct clk_core *mmp_clk_register_factor(const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *base, struct clk_factor_masks *masks,
 		struct clk_factor_tbl *ftbl, unsigned int ftbl_cnt);
diff --git a/drivers/clk/mvebu/clk-corediv.c b/drivers/clk/mvebu/clk-corediv.c
index d1e5863..1be15c4 100644
--- a/drivers/clk/mvebu/clk-corediv.c
+++ b/drivers/clk/mvebu/clk-corediv.c
@@ -238,7 +238,7 @@ mvebu_corediv_clk_init(struct device_node *node,
 {
 	struct clk_init_data init;
 	struct clk_corediv *corediv;
-	struct clk **clks;
+	struct clk_core **clks;
 	void __iomem *base;
 	const char *parent_name;
 	const char *clk_name;
@@ -253,7 +253,7 @@ mvebu_corediv_clk_init(struct device_node *node,
 	clk_data.clk_num = soc_desc->ndescs;
 
 	/* clks holds the clock array */
-	clks = kcalloc(clk_data.clk_num, sizeof(struct clk *),
+	clks = kcalloc(clk_data.clk_num, sizeof(struct clk_core *),
 				GFP_KERNEL);
 	if (WARN_ON(!clks))
 		goto err_unmap;
diff --git a/drivers/clk/mvebu/clk-cpu.c b/drivers/clk/mvebu/clk-cpu.c
index 8ebf757..225124b 100644
--- a/drivers/clk/mvebu/clk-cpu.c
+++ b/drivers/clk/mvebu/clk-cpu.c
@@ -30,7 +30,7 @@ struct cpu_clk {
 	void __iomem *reg_base;
 };
 
-static struct clk **clks;
+static struct clk_core **clks;
 
 static struct clk_onecell_data clk_data;
 
@@ -127,8 +127,8 @@ static void __init of_cpu_clk_setup(struct device_node *node)
 
 	for_each_node_by_type(dn, "cpu") {
 		struct clk_init_data init;
-		struct clk *clk;
-		struct clk *parent_clk;
+		struct clk_core *clk;
+		struct clk_core *parent_clk;
 		char *clk_name = kzalloc(5, GFP_KERNEL);
 		int cpu, err;
 
@@ -140,7 +140,7 @@ static void __init of_cpu_clk_setup(struct device_node *node)
 			goto bail_out;
 
 		sprintf(clk_name, "cpu%d", cpu);
-		parent_clk = of_clk_get(node, 0);
+		parent_clk = of_clk_provider_get(node, 0);
 
 		cpuclk[cpu].parent_name = __clk_get_name(parent_clk);
 		cpuclk[cpu].clk_name = clk_name;
diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
index 25ceccf..7e6c320 100644
--- a/drivers/clk/mvebu/common.c
+++ b/drivers/clk/mvebu/common.c
@@ -43,7 +43,7 @@ void __init mvebu_coreclk_setup(struct device_node *np,
 
 	/* Allocate struct for TCLK, cpu clk, and core ratio clocks */
 	clk_data.clk_num = 2 + desc->num_ratios;
-	clk_data.clks = kzalloc(clk_data.clk_num * sizeof(struct clk *),
+	clk_data.clks = kzalloc(clk_data.clk_num * sizeof(struct clk_core *),
 				GFP_KERNEL);
 	if (WARN_ON(!clk_data.clks)) {
 		iounmap(base);
@@ -91,13 +91,13 @@ void __init mvebu_coreclk_setup(struct device_node *np,
 
 struct clk_gating_ctrl {
 	spinlock_t lock;
-	struct clk **gates;
+	struct clk_core **gates;
 	int num_gates;
 };
 
 #define to_clk_gate(_hw) container_of(_hw, struct clk_gate, hw)
 
-static struct clk *clk_gating_get_src(
+static struct clk_core *clk_gating_get_src(
 	struct of_phandle_args *clkspec, void *data)
 {
 	struct clk_gating_ctrl *ctrl = (struct clk_gating_ctrl *)data;
@@ -119,7 +119,7 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
 				   const struct clk_gating_soc_desc *desc)
 {
 	struct clk_gating_ctrl *ctrl;
-	struct clk *clk;
+	struct clk_core *clk;
 	void __iomem *base;
 	const char *default_parent = NULL;
 	int n;
@@ -128,10 +128,10 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
 	if (WARN_ON(!base))
 		return;
 
-	clk = of_clk_get(np, 0);
+	clk = of_clk_provider_get(np, 0);
 	if (!IS_ERR(clk)) {
 		default_parent = __clk_get_name(clk);
-		clk_put(clk);
+		__clk_put(clk);
 	}
 
 	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
@@ -145,7 +145,7 @@ void __init mvebu_clk_gating_setup(struct device_node *np,
 		n++;
 
 	ctrl->num_gates = n;
-	ctrl->gates = kzalloc(ctrl->num_gates * sizeof(struct clk *),
+	ctrl->gates = kzalloc(ctrl->num_gates * sizeof(struct clk_core *),
 			      GFP_KERNEL);
 	if (WARN_ON(!ctrl->gates))
 		goto gates_out;
diff --git a/drivers/clk/mxs/clk-div.c b/drivers/clk/mxs/clk-div.c
index 90e1da9..57f93e5 100644
--- a/drivers/clk/mxs/clk-div.c
+++ b/drivers/clk/mxs/clk-div.c
@@ -74,11 +74,11 @@ static struct clk_ops clk_div_ops = {
 	.set_rate = clk_div_set_rate,
 };
 
-struct clk *mxs_clk_div(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_div(const char *name, const char *parent_name,
 			void __iomem *reg, u8 shift, u8 width, u8 busy)
 {
 	struct clk_div *div;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	div = kzalloc(sizeof(*div), GFP_KERNEL);
diff --git a/drivers/clk/mxs/clk-frac.c b/drivers/clk/mxs/clk-frac.c
index e6aa6b5..87083e4 100644
--- a/drivers/clk/mxs/clk-frac.c
+++ b/drivers/clk/mxs/clk-frac.c
@@ -108,11 +108,11 @@ static struct clk_ops clk_frac_ops = {
 	.set_rate = clk_frac_set_rate,
 };
 
-struct clk *mxs_clk_frac(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_frac(const char *name, const char *parent_name,
 			 void __iomem *reg, u8 shift, u8 width, u8 busy)
 {
 	struct clk_frac *frac;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	frac = kzalloc(sizeof(*frac), GFP_KERNEL);
diff --git a/drivers/clk/mxs/clk-imx23.c b/drivers/clk/mxs/clk-imx23.c
index 9fc9359..2b1b323 100644
--- a/drivers/clk/mxs/clk-imx23.c
+++ b/drivers/clk/mxs/clk-imx23.c
@@ -94,7 +94,7 @@ enum imx23_clk {
 	clk_max
 };
 
-static struct clk *clks[clk_max];
+static struct clk_core *clks[clk_max];
 static struct clk_onecell_data clk_data;
 
 static enum imx23_clk clks_init_on[] __initdata = {
@@ -171,7 +171,7 @@ static void __init mx23_clocks_init(struct device_node *np)
 	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
 
 	for (i = 0; i < ARRAY_SIZE(clks_init_on); i++)
-		clk_prepare_enable(clks[clks_init_on[i]]);
+		clk_prepare_enable(clk_core_to_clk(clks[clks_init_on[i]]));
 
 }
 CLK_OF_DECLARE(imx23_clkctrl, "fsl,imx23-clkctrl", mx23_clocks_init);
diff --git a/drivers/clk/mxs/clk-imx28.c b/drivers/clk/mxs/clk-imx28.c
index a6c3501..cfa4748 100644
--- a/drivers/clk/mxs/clk-imx28.c
+++ b/drivers/clk/mxs/clk-imx28.c
@@ -148,7 +148,7 @@ enum imx28_clk {
 	clk_max
 };
 
-static struct clk *clks[clk_max];
+static struct clk_core *clks[clk_max];
 static struct clk_onecell_data clk_data;
 
 static enum imx28_clk clks_init_on[] __initdata = {
@@ -250,6 +250,6 @@ static void __init mx28_clocks_init(struct device_node *np)
 	clk_register_clkdev(clks[enet_out], NULL, "enet_out");
 
 	for (i = 0; i < ARRAY_SIZE(clks_init_on); i++)
-		clk_prepare_enable(clks[clks_init_on[i]]);
+		clk_prepare_enable(clk_core_to_clk(clks[clks_init_on[i]]));
 }
 CLK_OF_DECLARE(imx28_clkctrl, "fsl,imx28-clkctrl", mx28_clocks_init);
diff --git a/drivers/clk/mxs/clk-pll.c b/drivers/clk/mxs/clk-pll.c
index fadae41..8e29d79 100644
--- a/drivers/clk/mxs/clk-pll.c
+++ b/drivers/clk/mxs/clk-pll.c
@@ -86,11 +86,11 @@ static const struct clk_ops clk_pll_ops = {
 	.recalc_rate = clk_pll_recalc_rate,
 };
 
-struct clk *mxs_clk_pll(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_pll(const char *name, const char *parent_name,
 			void __iomem *base, u8 power, unsigned long rate)
 {
 	struct clk_pll *pll;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
diff --git a/drivers/clk/mxs/clk-ref.c b/drivers/clk/mxs/clk-ref.c
index 4adeed6..ad1aa00 100644
--- a/drivers/clk/mxs/clk-ref.c
+++ b/drivers/clk/mxs/clk-ref.c
@@ -125,11 +125,11 @@ static const struct clk_ops clk_ref_ops = {
 	.set_rate	= clk_ref_set_rate,
 };
 
-struct clk *mxs_clk_ref(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_ref(const char *name, const char *parent_name,
 			void __iomem *reg, u8 idx)
 {
 	struct clk_ref *ref;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	ref = kzalloc(sizeof(*ref), GFP_KERNEL);
diff --git a/drivers/clk/mxs/clk-ssp.c b/drivers/clk/mxs/clk-ssp.c
index af7bdbf..d1221a4 100644
--- a/drivers/clk/mxs/clk-ssp.c
+++ b/drivers/clk/mxs/clk-ssp.c
@@ -30,7 +30,7 @@ void mxs_ssp_set_clk_rate(struct mxs_ssp *ssp, unsigned int rate)
 	u32 clock_divide, clock_rate;
 	u32 val;
 
-	ssp_clk = clk_get_rate(ssp->clk);
+	ssp_clk = clk_provider_get_rate(ssp->clk);
 
 	for (clock_divide = 2; clock_divide <= 254; clock_divide += 2) {
 		clock_rate = DIV_ROUND_UP(ssp_clk, rate * clock_divide);
diff --git a/drivers/clk/mxs/clk.h b/drivers/clk/mxs/clk.h
index ef10ad9..b258ea5 100644
--- a/drivers/clk/mxs/clk.h
+++ b/drivers/clk/mxs/clk.h
@@ -23,24 +23,24 @@ extern spinlock_t mxs_lock;
 
 int mxs_clk_wait(void __iomem *reg, u8 shift);
 
-struct clk *mxs_clk_pll(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_pll(const char *name, const char *parent_name,
 			void __iomem *base, u8 power, unsigned long rate);
 
-struct clk *mxs_clk_ref(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_ref(const char *name, const char *parent_name,
 			void __iomem *reg, u8 idx);
 
-struct clk *mxs_clk_div(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_div(const char *name, const char *parent_name,
 			void __iomem *reg, u8 shift, u8 width, u8 busy);
 
-struct clk *mxs_clk_frac(const char *name, const char *parent_name,
+struct clk_core *mxs_clk_frac(const char *name, const char *parent_name,
 			 void __iomem *reg, u8 shift, u8 width, u8 busy);
 
-static inline struct clk *mxs_clk_fixed(const char *name, int rate)
+static inline struct clk_core *mxs_clk_fixed(const char *name, int rate)
 {
 	return clk_register_fixed_rate(NULL, name, NULL, CLK_IS_ROOT, rate);
 }
 
-static inline struct clk *mxs_clk_gate(const char *name,
+static inline struct clk_core *mxs_clk_gate(const char *name,
 			const char *parent_name, void __iomem *reg, u8 shift)
 {
 	return clk_register_gate(NULL, name, parent_name, CLK_SET_RATE_PARENT,
@@ -48,7 +48,7 @@ static inline struct clk *mxs_clk_gate(const char *name,
 				 &mxs_lock);
 }
 
-static inline struct clk *mxs_clk_mux(const char *name, void __iomem *reg,
+static inline struct clk_core *mxs_clk_mux(const char *name, void __iomem *reg,
 		u8 shift, u8 width, const char **parent_names, int num_parents)
 {
 	return clk_register_mux(NULL, name, parent_names, num_parents,
@@ -56,7 +56,7 @@ static inline struct clk *mxs_clk_mux(const char *name, void __iomem *reg,
 				reg, shift, width, 0, &mxs_lock);
 }
 
-static inline struct clk *mxs_clk_fixed_factor(const char *name,
+static inline struct clk_core *mxs_clk_fixed_factor(const char *name,
 		const char *parent_name, unsigned int mult, unsigned int div)
 {
 	return clk_register_fixed_factor(NULL, name, parent_name,
diff --git a/drivers/clk/qcom/clk-rcg.c b/drivers/clk/qcom/clk-rcg.c
index abfc2b6..e7d0bfb 100644
--- a/drivers/clk/qcom/clk-rcg.c
+++ b/drivers/clk/qcom/clk-rcg.c
@@ -375,7 +375,7 @@ struct freq_tbl *find_freq(const struct freq_tbl *f, unsigned long rate)
 
 static long _freq_tbl_determine_rate(struct clk_hw *hw,
 		const struct freq_tbl *f, unsigned long rate,
-		unsigned long *p_rate, struct clk **p)
+		unsigned long *p_rate, struct clk_core **p)
 {
 	unsigned long clk_flags;
 
@@ -402,7 +402,7 @@ static long _freq_tbl_determine_rate(struct clk_hw *hw,
 }
 
 static long clk_rcg_determine_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *p_rate, struct clk **p)
+		unsigned long *p_rate, struct clk_core **p)
 {
 	struct clk_rcg *rcg = to_clk_rcg(hw);
 
@@ -410,7 +410,7 @@ static long clk_rcg_determine_rate(struct clk_hw *hw, unsigned long rate,
 }
 
 static long clk_dyn_rcg_determine_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *p_rate, struct clk **p)
+		unsigned long *p_rate, struct clk_core **p)
 {
 	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
 
diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index cd185d5..6aac1ec 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -188,7 +188,7 @@ struct freq_tbl *find_freq(const struct freq_tbl *f, unsigned long rate)
 
 static long _freq_tbl_determine_rate(struct clk_hw *hw,
 		const struct freq_tbl *f, unsigned long rate,
-		unsigned long *p_rate, struct clk **p)
+		unsigned long *p_rate, struct clk_core **p)
 {
 	unsigned long clk_flags;
 
@@ -219,7 +219,7 @@ static long _freq_tbl_determine_rate(struct clk_hw *hw,
 }
 
 static long clk_rcg2_determine_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *p_rate, struct clk **p)
+		unsigned long *p_rate, struct clk_core **p)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
 
@@ -372,7 +372,7 @@ static int clk_edp_pixel_set_rate_and_parent(struct clk_hw *hw,
 }
 
 static long clk_edp_pixel_determine_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *p_rate, struct clk **p)
+				 unsigned long *p_rate, struct clk_core **p)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
 	const struct freq_tbl *f = rcg->freq_tbl;
@@ -423,7 +423,7 @@ const struct clk_ops clk_edp_pixel_ops = {
 EXPORT_SYMBOL_GPL(clk_edp_pixel_ops);
 
 static long clk_byte_determine_rate(struct clk_hw *hw, unsigned long rate,
-			 unsigned long *p_rate, struct clk **p)
+			 unsigned long *p_rate, struct clk_core **p)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
 	const struct freq_tbl *f = rcg->freq_tbl;
@@ -485,14 +485,14 @@ static const struct frac_entry frac_table_pixel[] = {
 };
 
 static long clk_pixel_determine_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *p_rate, struct clk **p)
+				 unsigned long *p_rate, struct clk_core **p)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
 	unsigned long request, src_rate;
 	int delta = 100000;
 	const struct freq_tbl *f = rcg->freq_tbl;
 	const struct frac_entry *frac = frac_table_pixel;
-	struct clk *parent = *p = clk_get_parent_by_index(hw->clk, f->src);
+	struct clk_core *parent = *p = clk_get_parent_by_index(hw->clk, f->src);
 
 	for (; frac->num; frac++) {
 		request = (rate * frac->den) / frac->num;
@@ -519,7 +519,7 @@ static int clk_pixel_set_rate(struct clk_hw *hw, unsigned long rate,
 	int delta = 100000;
 	u32 mask = BIT(rcg->hid_width) - 1;
 	u32 hid_div;
-	struct clk *parent = clk_get_parent_by_index(hw->clk, f.src);
+	struct clk_core *parent = clk_get_parent_by_index(hw->clk, f.src);
 
 	for (; frac->num; frac++) {
 		request = (rate * frac->den) / frac->num;
diff --git a/drivers/clk/qcom/clk-regmap.c b/drivers/clk/qcom/clk-regmap.c
index a58ba39..2a98040 100644
--- a/drivers/clk/qcom/clk-regmap.c
+++ b/drivers/clk/qcom/clk-regmap.c
@@ -101,7 +101,7 @@ EXPORT_SYMBOL_GPL(clk_disable_regmap);
  * clk_regmap struct via this function so that the regmap is initialized
  * and so that the clock is registered with the common clock framework.
  */
-struct clk *devm_clk_register_regmap(struct device *dev,
+struct clk_core *devm_clk_register_regmap(struct device *dev,
 				     struct clk_regmap *rclk)
 {
 	if (dev && dev_get_regmap(dev, NULL))
diff --git a/drivers/clk/qcom/clk-regmap.h b/drivers/clk/qcom/clk-regmap.h
index 491a63d..89258cb 100644
--- a/drivers/clk/qcom/clk-regmap.h
+++ b/drivers/clk/qcom/clk-regmap.h
@@ -39,7 +39,7 @@ struct clk_regmap {
 int clk_is_enabled_regmap(struct clk_hw *hw);
 int clk_enable_regmap(struct clk_hw *hw);
 void clk_disable_regmap(struct clk_hw *hw);
-struct clk *
+struct clk_core *
 devm_clk_register_regmap(struct device *dev, struct clk_regmap *rclk);
 
 #endif
diff --git a/drivers/clk/qcom/common.c b/drivers/clk/qcom/common.c
index 9b5a1cf..bfa36bd 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -24,7 +24,7 @@
 struct qcom_cc {
 	struct qcom_reset_controller reset;
 	struct clk_onecell_data data;
-	struct clk *clks[];
+	struct clk_core *clks[];
 };
 
 int qcom_cc_probe(struct platform_device *pdev, const struct qcom_cc_desc *desc)
@@ -33,9 +33,9 @@ int qcom_cc_probe(struct platform_device *pdev, const struct qcom_cc_desc *desc)
 	struct resource *res;
 	int i, ret;
 	struct device *dev = &pdev->dev;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_onecell_data *data;
-	struct clk **clks;
+	struct clk_core **clks;
 	struct regmap *regmap;
 	struct qcom_reset_controller *reset;
 	struct qcom_cc *cc;
diff --git a/drivers/clk/qcom/gcc-msm8660.c b/drivers/clk/qcom/gcc-msm8660.c
index 0c4b727..2d41fdb 100644
--- a/drivers/clk/qcom/gcc-msm8660.c
+++ b/drivers/clk/qcom/gcc-msm8660.c
@@ -2718,7 +2718,7 @@ MODULE_DEVICE_TABLE(of, gcc_msm8660_match_table);
 
 static int gcc_msm8660_probe(struct platform_device *pdev)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct device *dev = &pdev->dev;
 
 	/* Temporary until RPM clocks supported */
diff --git a/drivers/clk/qcom/gcc-msm8960.c b/drivers/clk/qcom/gcc-msm8960.c
index f4ffd91..f3bf005 100644
--- a/drivers/clk/qcom/gcc-msm8960.c
+++ b/drivers/clk/qcom/gcc-msm8960.c
@@ -2911,7 +2911,7 @@ MODULE_DEVICE_TABLE(of, gcc_msm8960_match_table);
 
 static int gcc_msm8960_probe(struct platform_device *pdev)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct device *dev = &pdev->dev;
 	const struct of_device_id *match;
 
diff --git a/drivers/clk/qcom/gcc-msm8974.c b/drivers/clk/qcom/gcc-msm8974.c
index 7af7c18..8326b1f 100644
--- a/drivers/clk/qcom/gcc-msm8974.c
+++ b/drivers/clk/qcom/gcc-msm8974.c
@@ -2699,7 +2699,7 @@ static void msm8974_pro_clock_override(void)
 
 static int gcc_msm8974_probe(struct platform_device *pdev)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct device *dev = &pdev->dev;
 	bool pro;
 	const struct of_device_id *id;
diff --git a/drivers/clk/qcom/mmcc-msm8960.c b/drivers/clk/qcom/mmcc-msm8960.c
index 12f3c0b..28a5d30 100644
--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -458,7 +458,7 @@ static int pix_rdi_set_parent(struct clk_hw *hw, u8 index)
 	int ret = 0;
 	u32 val;
 	struct clk_pix_rdi *rdi = to_clk_pix_rdi(hw);
-	struct clk *clk = hw->clk;
+	struct clk_core *clk = hw->clk;
 	int num_parents = __clk_get_num_parents(hw->clk);
 
 	/*
@@ -470,7 +470,7 @@ static int pix_rdi_set_parent(struct clk_hw *hw, u8 index)
 	 * needs to be on at what time.
 	 */
 	for (i = 0; i < num_parents; i++) {
-		ret = clk_prepare_enable(clk_get_parent_by_index(clk, i));
+		ret = clk_prepare_enable(clk_core_to_clk(clk_get_parent_by_index(clk, i)));
 		if (ret)
 			goto err;
 	}
@@ -499,7 +499,7 @@ static int pix_rdi_set_parent(struct clk_hw *hw, u8 index)
 
 err:
 	for (i--; i >= 0; i--)
-		clk_disable_unprepare(clk_get_parent_by_index(clk, i));
+		clk_disable_unprepare(clk_core_to_clk(clk_get_parent_by_index(clk, i)));
 
 	return ret;
 }
diff --git a/drivers/clk/rockchip/clk-rockchip.c b/drivers/clk/rockchip/clk-rockchip.c
index 4cf838d5..faa8dfa 100644
--- a/drivers/clk/rockchip/clk-rockchip.c
+++ b/drivers/clk/rockchip/clk-rockchip.c
@@ -54,7 +54,7 @@ static void __init rk2928_gate_clk_init(struct device_node *node)
 	if (!clk_data)
 		return;
 
-	clk_data->clks = kzalloc(qty * sizeof(struct clk *), GFP_KERNEL);
+	clk_data->clks = kzalloc(qty * sizeof(struct clk_core *), GFP_KERNEL);
 	if (!clk_data->clks) {
 		kfree(clk_data);
 		return;
diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
index 13eae14c..f5639bf 100644
--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -26,7 +26,7 @@ enum exynos_audss_clk_type {
 };
 
 static DEFINE_SPINLOCK(lock);
-static struct clk **clk_table;
+static struct clk_core **clk_table;
 static void __iomem *reg_base;
 static struct clk_onecell_data clk_data;
 
@@ -83,7 +83,7 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 	const char *mout_audss_p[] = {"fin_pll", "fout_epll"};
 	const char *mout_i2s_p[] = {"mout_audss", "cdclk0", "sclk_audio0"};
 	const char *sclk_pcm_p = "sclk_pcm0";
-	struct clk *pll_ref, *pll_in, *cdclk, *sclk_audio, *sclk_pcm_in;
+	struct clk_core *pll_ref, *pll_in, *cdclk, *sclk_audio, *sclk_pcm_in;
 	const struct of_device_id *match;
 	enum exynos_audss_clk_type variant;
 
@@ -100,7 +100,7 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 	}
 
 	clk_table = devm_kzalloc(&pdev->dev,
-				sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,
+				sizeof(struct clk_core *) * EXYNOS_AUDSS_MAX_CLKS,
 				GFP_KERNEL);
 	if (!clk_table)
 		return -ENOMEM;
@@ -111,8 +111,8 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 	else
 		clk_data.clk_num = EXYNOS_AUDSS_MAX_CLKS - 1;
 
-	pll_ref = devm_clk_get(&pdev->dev, "pll_ref");
-	pll_in = devm_clk_get(&pdev->dev, "pll_in");
+	pll_ref = devm_clk_provider_get(&pdev->dev, "pll_ref");
+	pll_in = devm_clk_provider_get(&pdev->dev, "pll_in");
 	if (!IS_ERR(pll_ref))
 		mout_audss_p[0] = __clk_get_name(pll_ref);
 	if (!IS_ERR(pll_in))
@@ -122,8 +122,8 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 				CLK_SET_RATE_NO_REPARENT,
 				reg_base + ASS_CLK_SRC, 0, 1, 0, &lock);
 
-	cdclk = devm_clk_get(&pdev->dev, "cdclk");
-	sclk_audio = devm_clk_get(&pdev->dev, "sclk_audio");
+	cdclk = devm_clk_provider_get(&pdev->dev, "cdclk");
+	sclk_audio = devm_clk_provider_get(&pdev->dev, "sclk_audio");
 	if (!IS_ERR(cdclk))
 		mout_i2s_p[1] = __clk_get_name(cdclk);
 	if (!IS_ERR(sclk_audio))
@@ -161,7 +161,7 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 				 "sclk_pcm", CLK_SET_RATE_PARENT,
 				reg_base + ASS_CLK_GATE, 4, 0, &lock);
 
-	sclk_pcm_in = devm_clk_get(&pdev->dev, "sclk_pcm_in");
+	sclk_pcm_in = devm_clk_provider_get(&pdev->dev, "sclk_pcm_in");
 	if (!IS_ERR(sclk_pcm_in))
 		sclk_pcm_p = __clk_get_name(sclk_pcm_in);
 	clk_table[EXYNOS_SCLK_PCM] = clk_register_gate(NULL, "sclk_pcm",
diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 4f150c9..179df56 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -1046,19 +1046,19 @@ static unsigned long exynos4_get_xom(void)
 static void __init exynos4_clk_register_finpll(struct samsung_clk_provider *ctx)
 {
 	struct samsung_fixed_rate_clock fclk;
-	struct clk *clk;
+	struct clk_core *clk;
 	unsigned long finpll_f = 24000000;
 	char *parent_name;
 	unsigned int xom = exynos4_get_xom();
 
 	parent_name = xom & 1 ? "xusbxti" : "xxti";
-	clk = clk_get(NULL, parent_name);
+	clk = clk_provider_get(NULL, parent_name);
 	if (IS_ERR(clk)) {
 		pr_err("%s: failed to lookup parent clock %s, assuming "
 			"fin_pll clock frequency is 24MHz\n", __func__,
 			parent_name);
 	} else {
-		finpll_f = clk_get_rate(clk);
+		finpll_f = clk_provider_get_rate(clk);
 	}
 
 	fclk.id = CLK_FIN_PLL;
diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
index b07fad2..aaf234a 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -910,12 +910,12 @@ static const struct clk_ops samsung_pll2550x_clk_ops = {
 	.recalc_rate = samsung_pll2550x_recalc_rate,
 };
 
-struct clk * __init samsung_clk_register_pll2550x(const char *name,
+struct clk_core * __init samsung_clk_register_pll2550x(const char *name,
 			const char *pname, const void __iomem *reg_base,
 			const unsigned long offset)
 {
 	struct samsung_clk_pll2550x *pll;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
@@ -1149,7 +1149,7 @@ static void __init _samsung_clk_register_pll(struct samsung_clk_provider *ctx,
 				void __iomem *base)
 {
 	struct samsung_clk_pll *pll;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 	int ret, len;
 
diff --git a/drivers/clk/samsung/clk-pll.h b/drivers/clk/samsung/clk-pll.h
index c0ed4d4..81af344 100644
--- a/drivers/clk/samsung/clk-pll.h
+++ b/drivers/clk/samsung/clk-pll.h
@@ -97,7 +97,7 @@ struct samsung_pll_rate_table {
 	unsigned int vsel;
 };
 
-extern struct clk * __init samsung_clk_register_pll2550x(const char *name,
+extern struct clk_core * __init samsung_clk_register_pll2550x(const char *name,
 			const char *pname, const void __iomem *reg_base,
 			const unsigned long offset);
 
diff --git a/drivers/clk/samsung/clk-s3c2410-dclk.c b/drivers/clk/samsung/clk-s3c2410-dclk.c
index 0449cc0..70baecf 100644
--- a/drivers/clk/samsung/clk-s3c2410-dclk.c
+++ b/drivers/clk/samsung/clk-s3c2410-dclk.c
@@ -87,12 +87,12 @@ const struct clk_ops s3c24xx_clkout_ops = {
 	.determine_rate = __clk_mux_determine_rate,
 };
 
-struct clk *s3c24xx_register_clkout(struct device *dev, const char *name,
+struct clk_core *s3c24xx_register_clkout(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents,
 		u8 shift, u32 mask)
 {
 	struct s3c24xx_clkout *clkout;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	/* allocate the clkout */
@@ -237,7 +237,7 @@ static int s3c24xx_dclk_probe(struct platform_device *pdev)
 {
 	struct s3c24xx_dclk *s3c24xx_dclk;
 	struct resource *mem;
-	struct clk **clk_table;
+	struct clk_core **clk_table;
 	struct s3c24xx_dclk_drv_data *dclk_variant;
 	int ret, i;
 
@@ -251,7 +251,7 @@ static int s3c24xx_dclk_probe(struct platform_device *pdev)
 	spin_lock_init(&s3c24xx_dclk->dclk_lock);
 
 	clk_table = devm_kzalloc(&pdev->dev,
-				 sizeof(struct clk *) * DCLK_MAX_CLKS,
+				 sizeof(struct clk_core *) * DCLK_MAX_CLKS,
 				 GFP_KERNEL);
 	if (!clk_table)
 		return -ENOMEM;
@@ -355,7 +355,7 @@ err_clk_register:
 static int s3c24xx_dclk_remove(struct platform_device *pdev)
 {
 	struct s3c24xx_dclk *s3c24xx_dclk = platform_get_drvdata(pdev);
-	struct clk **clk_table = s3c24xx_dclk->clk_data.clks;
+	struct clk_core **clk_table = s3c24xx_dclk->clk_data.clks;
 	int i;
 
 	clk_notifier_unregister(clk_table[DIV_DCLK1],
diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
index 49629c7..59bf393 100644
--- a/drivers/clk/samsung/clk.c
+++ b/drivers/clk/samsung/clk.c
@@ -52,7 +52,7 @@ struct samsung_clk_provider *__init samsung_clk_init(struct device_node *np,
 			void __iomem *base, unsigned long nr_clks)
 {
 	struct samsung_clk_provider *ctx;
-	struct clk **clk_table;
+	struct clk_core **clk_table;
 	int ret;
 	int i;
 
@@ -60,7 +60,7 @@ struct samsung_clk_provider *__init samsung_clk_init(struct device_node *np,
 	if (!ctx)
 		panic("could not allocate clock provider context.\n");
 
-	clk_table = kcalloc(nr_clks, sizeof(struct clk *), GFP_KERNEL);
+	clk_table = kcalloc(nr_clks, sizeof(struct clk_core *), GFP_KERNEL);
 	if (!clk_table)
 		panic("could not allocate clock lookup table\n");
 
@@ -84,7 +84,7 @@ struct samsung_clk_provider *__init samsung_clk_init(struct device_node *np,
 }
 
 /* add a clock instance to the clock lookup table used for dt based lookup */
-void samsung_clk_add_lookup(struct samsung_clk_provider *ctx, struct clk *clk,
+void samsung_clk_add_lookup(struct samsung_clk_provider *ctx, struct clk_core *clk,
 				unsigned int id)
 {
 	if (ctx->clk_data.clks && id)
@@ -96,7 +96,7 @@ void __init samsung_clk_register_alias(struct samsung_clk_provider *ctx,
 				struct samsung_clock_alias *list,
 				unsigned int nr_clk)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	unsigned int idx, ret;
 
 	if (!ctx->clk_data.clks) {
@@ -129,7 +129,7 @@ void __init samsung_clk_register_alias(struct samsung_clk_provider *ctx,
 void __init samsung_clk_register_fixed_rate(struct samsung_clk_provider *ctx,
 		struct samsung_fixed_rate_clock *list, unsigned int nr_clk)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	unsigned int idx, ret;
 
 	for (idx = 0; idx < nr_clk; idx++, list++) {
@@ -158,7 +158,7 @@ void __init samsung_clk_register_fixed_rate(struct samsung_clk_provider *ctx,
 void __init samsung_clk_register_fixed_factor(struct samsung_clk_provider *ctx,
 		struct samsung_fixed_factor_clock *list, unsigned int nr_clk)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	unsigned int idx;
 
 	for (idx = 0; idx < nr_clk; idx++, list++) {
@@ -179,7 +179,7 @@ void __init samsung_clk_register_mux(struct samsung_clk_provider *ctx,
 				struct samsung_mux_clock *list,
 				unsigned int nr_clk)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	unsigned int idx, ret;
 
 	for (idx = 0; idx < nr_clk; idx++, list++) {
@@ -211,7 +211,7 @@ void __init samsung_clk_register_div(struct samsung_clk_provider *ctx,
 				struct samsung_div_clock *list,
 				unsigned int nr_clk)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	unsigned int idx, ret;
 
 	for (idx = 0; idx < nr_clk; idx++, list++) {
@@ -250,7 +250,7 @@ void __init samsung_clk_register_gate(struct samsung_clk_provider *ctx,
 				struct samsung_gate_clock *list,
 				unsigned int nr_clk)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	unsigned int idx, ret;
 
 	for (idx = 0; idx < nr_clk; idx++, list++) {
@@ -302,7 +302,7 @@ void __init samsung_clk_of_register_fixed_ext(struct samsung_clk_provider *ctx,
 /* utility function to get the rate of a specified clock */
 unsigned long _get_rate(const char *clk_name)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = __clk_lookup(clk_name);
 	if (!clk) {
@@ -310,5 +310,5 @@ unsigned long _get_rate(const char *clk_name)
 		return 0;
 	}
 
-	return clk_get_rate(clk);
+	return clk_provider_get_rate(clk);
 }
diff --git a/drivers/clk/samsung/clk.h b/drivers/clk/samsung/clk.h
index 9693b80..33f14bb 100644
--- a/drivers/clk/samsung/clk.h
+++ b/drivers/clk/samsung/clk.h
@@ -334,7 +334,7 @@ extern void __init samsung_clk_of_register_fixed_ext(
 			struct of_device_id *clk_matches);
 
 extern void samsung_clk_add_lookup(struct samsung_clk_provider *ctx,
-			struct clk *clk, unsigned int id);
+			struct clk_core *clk, unsigned int id);
 
 extern void samsung_clk_register_alias(struct samsung_clk_provider *ctx,
 			struct samsung_clock_alias *list,
diff --git a/drivers/clk/shmobile/clk-div6.c b/drivers/clk/shmobile/clk-div6.c
index f065f69..c6712fb 100644
--- a/drivers/clk/shmobile/clk-div6.c
+++ b/drivers/clk/shmobile/clk-div6.c
@@ -119,7 +119,7 @@ static void __init cpg_div6_clock_init(struct device_node *np)
 	struct div6_clock *clock;
 	const char *parent_name;
 	const char *name;
-	struct clk *clk;
+	struct clk_core *clk;
 	int ret;
 
 	clock = kzalloc(sizeof(*clock), GFP_KERNEL);
diff --git a/drivers/clk/shmobile/clk-emev2.c b/drivers/clk/shmobile/clk-emev2.c
index 6c7c929..2e3a45b 100644
--- a/drivers/clk/shmobile/clk-emev2.c
+++ b/drivers/clk/shmobile/clk-emev2.c
@@ -71,7 +71,7 @@ static void __init emev2_smu_init(void)
 static void __init emev2_smu_clkdiv_init(struct device_node *np)
 {
 	u32 reg[2];
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name = of_clk_get_parent_name(np, 0);
 	if (WARN_ON(of_property_read_u32_array(np, "reg", reg, 2)))
 		return;
@@ -89,7 +89,7 @@ CLK_OF_DECLARE(emev2_smu_clkdiv, "renesas,emev2-smu-clkdiv",
 static void __init emev2_smu_gclk_init(struct device_node *np)
 {
 	u32 reg[2];
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name = of_clk_get_parent_name(np, 0);
 	if (WARN_ON(of_property_read_u32_array(np, "reg", reg, 2)))
 		return;
diff --git a/drivers/clk/shmobile/clk-mstp.c b/drivers/clk/shmobile/clk-mstp.c
index 2d2fe77..2659676 100644
--- a/drivers/clk/shmobile/clk-mstp.c
+++ b/drivers/clk/shmobile/clk-mstp.c
@@ -121,13 +121,13 @@ static const struct clk_ops cpg_mstp_clock_ops = {
 	.is_enabled = cpg_mstp_clock_is_enabled,
 };
 
-static struct clk * __init
+static struct clk_core * __init
 cpg_mstp_clock_register(const char *name, const char *parent_name,
 			unsigned int index, struct mstp_clock_group *group)
 {
 	struct clk_init_data init;
 	struct mstp_clock *clock;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clock = kzalloc(sizeof(*clock), GFP_KERNEL);
 	if (!clock) {
@@ -157,7 +157,7 @@ static void __init cpg_mstp_clocks_init(struct device_node *np)
 {
 	struct mstp_clock_group *group;
 	const char *idxname;
-	struct clk **clks;
+	struct clk_core **clks;
 	unsigned int i;
 
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
diff --git a/drivers/clk/shmobile/clk-r8a7740.c b/drivers/clk/shmobile/clk-r8a7740.c
index 1e2eaae..8889e6a 100644
--- a/drivers/clk/shmobile/clk-r8a7740.c
+++ b/drivers/clk/shmobile/clk-r8a7740.c
@@ -61,7 +61,7 @@ static const struct clk_div_table div4_div_table[] = {
 
 static u32 cpg_mode __initdata;
 
-static struct clk * __init
+static struct clk_core * __init
 r8a7740_cpg_register_clock(struct device_node *np, struct r8a7740_cpg *cpg,
 			     const char *name)
 {
@@ -147,7 +147,7 @@ r8a7740_cpg_register_clock(struct device_node *np, struct r8a7740_cpg *cpg,
 static void __init r8a7740_cpg_clocks_init(struct device_node *np)
 {
 	struct r8a7740_cpg *cpg;
-	struct clk **clks;
+	struct clk_core **clks;
 	unsigned int i;
 	int num_clks;
 
@@ -180,7 +180,7 @@ static void __init r8a7740_cpg_clocks_init(struct device_node *np)
 
 	for (i = 0; i < num_clks; ++i) {
 		const char *name;
-		struct clk *clk;
+		struct clk_core *clk;
 
 		of_property_read_string_index(np, "clock-output-names", i,
 					      &name);
diff --git a/drivers/clk/shmobile/clk-r8a7779.c b/drivers/clk/shmobile/clk-r8a7779.c
index 652ecac..96b51b1 100644
--- a/drivers/clk/shmobile/clk-r8a7779.c
+++ b/drivers/clk/shmobile/clk-r8a7779.c
@@ -90,7 +90,7 @@ static const unsigned int cpg_plla_mult[4] __initconst = { 42, 48, 56, 64 };
 
 static u32 cpg_mode __initdata;
 
-static struct clk * __init
+static struct clk_core * __init
 r8a7779_cpg_register_clock(struct device_node *np, struct r8a7779_cpg *cpg,
 			   const struct cpg_clk_config *config,
 			   unsigned int plla_mult, const char *name)
@@ -124,7 +124,7 @@ static void __init r8a7779_cpg_clocks_init(struct device_node *np)
 {
 	const struct cpg_clk_config *config;
 	struct r8a7779_cpg *cpg;
-	struct clk **clks;
+	struct clk_core **clks;
 	unsigned int i, plla_mult;
 	int num_clks;
 
@@ -153,7 +153,7 @@ static void __init r8a7779_cpg_clocks_init(struct device_node *np)
 
 	for (i = 0; i < num_clks; ++i) {
 		const char *name;
-		struct clk *clk;
+		struct clk_core *clk;
 
 		of_property_read_string_index(np, "clock-output-names", i,
 					      &name);
diff --git a/drivers/clk/shmobile/clk-rcar-gen2.c b/drivers/clk/shmobile/clk-rcar-gen2.c
index dff7f79..d8bdeb8 100644
--- a/drivers/clk/shmobile/clk-rcar-gen2.c
+++ b/drivers/clk/shmobile/clk-rcar-gen2.c
@@ -133,12 +133,12 @@ static const struct clk_ops cpg_z_clk_ops = {
 	.set_rate = cpg_z_clk_set_rate,
 };
 
-static struct clk * __init cpg_z_clk_register(struct rcar_gen2_cpg *cpg)
+static struct clk_core * __init cpg_z_clk_register(struct rcar_gen2_cpg *cpg)
 {
 	static const char *parent_name = "pll0";
 	struct clk_init_data init;
 	struct cpg_z_clk *zclk;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	zclk = kzalloc(sizeof(*zclk), GFP_KERNEL);
 	if (!zclk)
@@ -212,7 +212,7 @@ static const struct clk_div_table cpg_sd01_div_table[] = {
 
 static u32 cpg_mode __initdata;
 
-static struct clk * __init
+static struct clk_core * __init
 rcar_gen2_cpg_register_clock(struct device_node *np, struct rcar_gen2_cpg *cpg,
 			     const struct cpg_pll_config *config,
 			     const char *name)
@@ -279,7 +279,7 @@ static void __init rcar_gen2_cpg_clocks_init(struct device_node *np)
 {
 	const struct cpg_pll_config *config;
 	struct rcar_gen2_cpg *cpg;
-	struct clk **clks;
+	struct clk_core **clks;
 	unsigned int i;
 	int num_clks;
 
@@ -312,7 +312,7 @@ static void __init rcar_gen2_cpg_clocks_init(struct device_node *np)
 
 	for (i = 0; i < num_clks; ++i) {
 		const char *name;
-		struct clk *clk;
+		struct clk_core *clk;
 
 		of_property_read_string_index(np, "clock-output-names", i,
 					      &name);
diff --git a/drivers/clk/shmobile/clk-rz.c b/drivers/clk/shmobile/clk-rz.c
index 7e68e86..414e20e 100644
--- a/drivers/clk/shmobile/clk-rz.c
+++ b/drivers/clk/shmobile/clk-rz.c
@@ -28,7 +28,7 @@ struct rz_cpg {
  * Initialization
  */
 
-static struct clk * __init
+static struct clk_core * __init
 rz_cpg_register_clock(struct device_node *np, struct rz_cpg *cpg, const char *name)
 {
 	u32 val;
@@ -67,7 +67,7 @@ rz_cpg_register_clock(struct device_node *np, struct rz_cpg *cpg, const char *na
 static void __init rz_cpg_clocks_init(struct device_node *np)
 {
 	struct rz_cpg *cpg;
-	struct clk **clks;
+	struct clk_core **clks;
 	unsigned i;
 	int num_clks;
 
@@ -86,7 +86,7 @@ static void __init rz_cpg_clocks_init(struct device_node *np)
 
 	for (i = 0; i < num_clks; ++i) {
 		const char *name;
-		struct clk *clk;
+		struct clk_core *clk;
 
 		of_property_read_string_index(np, "clock-output-names", i, &name);
 
diff --git a/drivers/clk/sirf/clk-atlas6.c b/drivers/clk/sirf/clk-atlas6.c
index d63b76c..9cce269 100644
--- a/drivers/clk/sirf/clk-atlas6.c
+++ b/drivers/clk/sirf/clk-atlas6.c
@@ -113,7 +113,7 @@ static __initdata struct clk_hw *atlas6_clk_hw_array[maxclk] = {
 	&clk_cphif.hw,
 };
 
-static struct clk *atlas6_clks[maxclk];
+static struct clk_core *atlas6_clks[maxclk];
 
 static void __init atlas6_clk_init(struct device_node *np)
 {
diff --git a/drivers/clk/sirf/clk-common.c b/drivers/clk/sirf/clk-common.c
index 37af51c..05f5040 100644
--- a/drivers/clk/sirf/clk-common.c
+++ b/drivers/clk/sirf/clk-common.c
@@ -165,9 +165,9 @@ static long cpu_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 	 * SiRF SoC has not cpu clock control,
 	 * So bypass to it's parent pll.
 	 */
-	struct clk *parent_clk = clk_get_parent(hw->clk);
-	struct clk *pll_parent_clk = clk_get_parent(parent_clk);
-	unsigned long pll_parent_rate = clk_get_rate(pll_parent_clk);
+	struct clk_core *parent_clk = clk_provider_get_parent(hw->clk);
+	struct clk_core *pll_parent_clk = clk_provider_get_parent(parent_clk);
+	unsigned long pll_parent_rate = clk_provider_get_rate(pll_parent_clk);
 	return pll_clk_round_rate(__clk_get_hw(parent_clk), rate, &pll_parent_rate);
 }
 
@@ -178,7 +178,7 @@ static unsigned long cpu_clk_recalc_rate(struct clk_hw *hw,
 	 * SiRF SoC has not cpu clock control,
 	 * So return the parent pll rate.
 	 */
-	struct clk *parent_clk = clk_get_parent(hw->clk);
+	struct clk_core *parent_clk = clk_provider_get_parent(hw->clk);
 	return __clk_get_rate(parent_clk);
 }
 
@@ -403,34 +403,34 @@ static int cpu_clk_set_rate(struct clk_hw *hw, unsigned long rate,
 		unsigned long parent_rate)
 {
 	int ret1, ret2;
-	struct clk *cur_parent;
+	struct clk_core *cur_parent;
 
-	if (rate == clk_get_rate(clk_pll1.hw.clk)) {
-		ret1 = clk_set_parent(hw->clk, clk_pll1.hw.clk);
+	if (rate == clk_provider_get_rate(clk_pll1.hw.clk)) {
+		ret1 = clk_provider_set_parent(hw->clk, clk_pll1.hw.clk);
 		return ret1;
 	}
 
-	if (rate == clk_get_rate(clk_pll2.hw.clk)) {
-		ret1 = clk_set_parent(hw->clk, clk_pll2.hw.clk);
+	if (rate == clk_provider_get_rate(clk_pll2.hw.clk)) {
+		ret1 = clk_provider_set_parent(hw->clk, clk_pll2.hw.clk);
 		return ret1;
 	}
 
-	if (rate == clk_get_rate(clk_pll3.hw.clk)) {
-		ret1 = clk_set_parent(hw->clk, clk_pll3.hw.clk);
+	if (rate == clk_provider_get_rate(clk_pll3.hw.clk)) {
+		ret1 = clk_provider_set_parent(hw->clk, clk_pll3.hw.clk);
 		return ret1;
 	}
 
-	cur_parent = clk_get_parent(hw->clk);
+	cur_parent = clk_provider_get_parent(hw->clk);
 
 	/* switch to tmp pll before setting parent clock's rate */
 	if (cur_parent ==  clk_pll1.hw.clk) {
-		ret1 = clk_set_parent(hw->clk, clk_pll2.hw.clk);
+		ret1 = clk_provider_set_parent(hw->clk, clk_pll2.hw.clk);
 		BUG_ON(ret1);
 	}
 
-	ret2 = clk_set_rate(clk_pll1.hw.clk, rate);
+	ret2 = clk_provider_set_rate(clk_pll1.hw.clk, rate);
 
-	ret1 = clk_set_parent(hw->clk, clk_pll1.hw.clk);
+	ret1 = clk_provider_set_parent(hw->clk, clk_pll1.hw.clk);
 
 	return ret2 ? ret2 : ret1;
 }
diff --git a/drivers/clk/sirf/clk-prima2.c b/drivers/clk/sirf/clk-prima2.c
index 6968e2e..751187b 100644
--- a/drivers/clk/sirf/clk-prima2.c
+++ b/drivers/clk/sirf/clk-prima2.c
@@ -112,7 +112,7 @@ static __initdata struct clk_hw *prima2_clk_hw_array[maxclk] = {
 	&clk_cphif.hw,
 };
 
-static struct clk *prima2_clks[maxclk];
+static struct clk_core *prima2_clks[maxclk];
 
 static void __init prima2_clk_init(struct device_node *np)
 {
diff --git a/drivers/clk/socfpga/clk-gate.c b/drivers/clk/socfpga/clk-gate.c
index dd3a78c..e3a6fe6 100644
--- a/drivers/clk/socfpga/clk-gate.c
+++ b/drivers/clk/socfpga/clk-gate.c
@@ -188,7 +188,7 @@ static void __init __socfpga_gate_init(struct device_node *node,
 	u32 div_reg[3];
 	u32 clk_phase[2];
 	u32 fixed_div;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct socfpga_gate_clk *socfpga_clk;
 	const char *clk_name = node->name;
 	const char *parent_name[SOCFPGA_MAX_PARENTS];
diff --git a/drivers/clk/socfpga/clk-periph.c b/drivers/clk/socfpga/clk-periph.c
index 46531c3..a63be19 100644
--- a/drivers/clk/socfpga/clk-periph.c
+++ b/drivers/clk/socfpga/clk-periph.c
@@ -53,7 +53,7 @@ static __init void __socfpga_periph_init(struct device_node *node,
 	const struct clk_ops *ops)
 {
 	u32 reg;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct socfpga_periph_clk *periph_clk;
 	const char *clk_name = node->name;
 	const char *parent_name;
diff --git a/drivers/clk/socfpga/clk-pll.c b/drivers/clk/socfpga/clk-pll.c
index de6da95..4ed91a4 100644
--- a/drivers/clk/socfpga/clk-pll.c
+++ b/drivers/clk/socfpga/clk-pll.c
@@ -81,11 +81,11 @@ static struct clk_ops clk_pll_ops = {
 	.get_parent = clk_pll_get_parent,
 };
 
-static __init struct clk *__socfpga_pll_init(struct device_node *node,
+static __init struct clk_core *__socfpga_pll_init(struct device_node *node,
 	const struct clk_ops *ops)
 {
 	u32 reg;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct socfpga_pll *pll_clk;
 	const char *clk_name = node->name;
 	const char *parent_name[SOCFPGA_MAX_PARENTS];
diff --git a/drivers/clk/spear/clk-aux-synth.c b/drivers/clk/spear/clk-aux-synth.c
index bdfb442..18334c3 100644
--- a/drivers/clk/spear/clk-aux-synth.c
+++ b/drivers/clk/spear/clk-aux-synth.c
@@ -134,14 +134,14 @@ static struct clk_ops clk_aux_ops = {
 	.set_rate = clk_aux_set_rate,
 };
 
-struct clk *clk_register_aux(const char *aux_name, const char *gate_name,
+struct clk_core *clk_register_aux(const char *aux_name, const char *gate_name,
 		const char *parent_name, unsigned long flags, void __iomem *reg,
 		struct aux_clk_masks *masks, struct aux_rate_tbl *rtbl,
-		u8 rtbl_cnt, spinlock_t *lock, struct clk **gate_clk)
+		u8 rtbl_cnt, spinlock_t *lock, struct clk_core **gate_clk)
 {
 	struct clk_aux *aux;
 	struct clk_init_data init;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (!aux_name || !parent_name || !reg || !rtbl || !rtbl_cnt) {
 		pr_err("Invalid arguments passed");
@@ -177,7 +177,7 @@ struct clk *clk_register_aux(const char *aux_name, const char *gate_name,
 		goto free_aux;
 
 	if (gate_name) {
-		struct clk *tgate_clk;
+		struct clk_core *tgate_clk;
 
 		tgate_clk = clk_register_gate(NULL, gate_name, aux_name,
 				CLK_SET_RATE_PARENT, reg,
diff --git a/drivers/clk/spear/clk-frac-synth.c b/drivers/clk/spear/clk-frac-synth.c
index dffd4ce..bce2c0e 100644
--- a/drivers/clk/spear/clk-frac-synth.c
+++ b/drivers/clk/spear/clk-frac-synth.c
@@ -122,13 +122,13 @@ static struct clk_ops clk_frac_ops = {
 	.set_rate = clk_frac_set_rate,
 };
 
-struct clk *clk_register_frac(const char *name, const char *parent_name,
+struct clk_core *clk_register_frac(const char *name, const char *parent_name,
 		unsigned long flags, void __iomem *reg,
 		struct frac_rate_tbl *rtbl, u8 rtbl_cnt, spinlock_t *lock)
 {
 	struct clk_init_data init;
 	struct clk_frac *frac;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (!name || !parent_name || !reg || !rtbl || !rtbl_cnt) {
 		pr_err("Invalid arguments passed");
diff --git a/drivers/clk/spear/clk-gpt-synth.c b/drivers/clk/spear/clk-gpt-synth.c
index 1afc18c..f8e13f3 100644
--- a/drivers/clk/spear/clk-gpt-synth.c
+++ b/drivers/clk/spear/clk-gpt-synth.c
@@ -111,13 +111,13 @@ static struct clk_ops clk_gpt_ops = {
 	.set_rate = clk_gpt_set_rate,
 };
 
-struct clk *clk_register_gpt(const char *name, const char *parent_name, unsigned
+struct clk_core *clk_register_gpt(const char *name, const char *parent_name, unsigned
 		long flags, void __iomem *reg, struct gpt_rate_tbl *rtbl, u8
 		rtbl_cnt, spinlock_t *lock)
 {
 	struct clk_init_data init;
 	struct clk_gpt *gpt;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (!name || !parent_name || !reg || !rtbl || !rtbl_cnt) {
 		pr_err("Invalid arguments passed");
diff --git a/drivers/clk/spear/clk-vco-pll.c b/drivers/clk/spear/clk-vco-pll.c
index 1b9b65b..226f2ec 100644
--- a/drivers/clk/spear/clk-vco-pll.c
+++ b/drivers/clk/spear/clk-vco-pll.c
@@ -272,16 +272,16 @@ static struct clk_ops clk_vco_ops = {
 	.set_rate = clk_vco_set_rate,
 };
 
-struct clk *clk_register_vco_pll(const char *vco_name, const char *pll_name,
+struct clk_core *clk_register_vco_pll(const char *vco_name, const char *pll_name,
 		const char *vco_gate_name, const char *parent_name,
 		unsigned long flags, void __iomem *mode_reg, void __iomem
 		*cfg_reg, struct pll_rate_tbl *rtbl, u8 rtbl_cnt,
-		spinlock_t *lock, struct clk **pll_clk,
-		struct clk **vco_gate_clk)
+		spinlock_t *lock, struct clk_core **pll_clk,
+		struct clk_core **vco_gate_clk)
 {
 	struct clk_vco *vco;
 	struct clk_pll *pll;
-	struct clk *vco_clk, *tpll_clk, *tvco_gate_clk;
+	struct clk_core *vco_clk, *tpll_clk, *tvco_gate_clk;
 	struct clk_init_data vco_init, pll_init;
 	const char **vco_parent_name;
 
diff --git a/drivers/clk/spear/clk.h b/drivers/clk/spear/clk.h
index 9317376..777322e 100644
--- a/drivers/clk/spear/clk.h
+++ b/drivers/clk/spear/clk.h
@@ -110,22 +110,22 @@ typedef unsigned long (*clk_calc_rate)(struct clk_hw *hw, unsigned long prate,
 		int index);
 
 /* clk register routines */
-struct clk *clk_register_aux(const char *aux_name, const char *gate_name,
+struct clk_core *clk_register_aux(const char *aux_name, const char *gate_name,
 		const char *parent_name, unsigned long flags, void __iomem *reg,
 		struct aux_clk_masks *masks, struct aux_rate_tbl *rtbl,
-		u8 rtbl_cnt, spinlock_t *lock, struct clk **gate_clk);
-struct clk *clk_register_frac(const char *name, const char *parent_name,
+		u8 rtbl_cnt, spinlock_t *lock, struct clk_core **gate_clk);
+struct clk_core *clk_register_frac(const char *name, const char *parent_name,
 		unsigned long flags, void __iomem *reg,
 		struct frac_rate_tbl *rtbl, u8 rtbl_cnt, spinlock_t *lock);
-struct clk *clk_register_gpt(const char *name, const char *parent_name, unsigned
+struct clk_core *clk_register_gpt(const char *name, const char *parent_name, unsigned
 		long flags, void __iomem *reg, struct gpt_rate_tbl *rtbl, u8
 		rtbl_cnt, spinlock_t *lock);
-struct clk *clk_register_vco_pll(const char *vco_name, const char *pll_name,
+struct clk_core *clk_register_vco_pll(const char *vco_name, const char *pll_name,
 		const char *vco_gate_name, const char *parent_name,
 		unsigned long flags, void __iomem *mode_reg, void __iomem
 		*cfg_reg, struct pll_rate_tbl *rtbl, u8 rtbl_cnt,
-		spinlock_t *lock, struct clk **pll_clk,
-		struct clk **vco_gate_clk);
+		spinlock_t *lock, struct clk_core **pll_clk,
+		struct clk_core **vco_gate_clk);
 
 long clk_round_rate_index(struct clk_hw *hw, unsigned long drate,
 		unsigned long parent_rate, clk_calc_rate calc_rate, u8 rtbl_cnt,
diff --git a/drivers/clk/spear/spear1310_clock.c b/drivers/clk/spear/spear1310_clock.c
index 65894f7..31c5ccb 100644
--- a/drivers/clk/spear/spear1310_clock.c
+++ b/drivers/clk/spear/spear1310_clock.c
@@ -385,7 +385,7 @@ static const char *tdm_parents[] = { "ras_pll3_clk", "gen_syn1_clk", };
 
 void __init spear1310_clk_init(void __iomem *misc_base, void __iomem *ras_base)
 {
-	struct clk *clk, *clk1;
+	struct clk_core *clk, *clk1;
 
 	clk = clk_register_fixed_rate(NULL, "osc_32k_clk", NULL, CLK_IS_ROOT,
 			32000);
diff --git a/drivers/clk/spear/spear1340_clock.c b/drivers/clk/spear/spear1340_clock.c
index fe835c1..843ced4 100644
--- a/drivers/clk/spear/spear1340_clock.c
+++ b/drivers/clk/spear/spear1340_clock.c
@@ -442,7 +442,7 @@ static const char *gen_synth2_3_parents[] = { "vco1div4_clk", "vco2div2_clk",
 
 void __init spear1340_clk_init(void __iomem *misc_base)
 {
-	struct clk *clk, *clk1;
+	struct clk_core *clk, *clk1;
 
 	clk = clk_register_fixed_rate(NULL, "osc_32k_clk", NULL, CLK_IS_ROOT,
 			32000);
diff --git a/drivers/clk/spear/spear3xx_clock.c b/drivers/clk/spear/spear3xx_clock.c
index c2d2043..b1840d9 100644
--- a/drivers/clk/spear/spear3xx_clock.c
+++ b/drivers/clk/spear/spear3xx_clock.c
@@ -140,7 +140,7 @@ static const char *ddr_parents[] = { "ahb_clk", "ahbmult2_clk", "none",
 #ifdef CONFIG_MACH_SPEAR300
 static void __init spear300_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = clk_register_fixed_factor(NULL, "clcd_clk", "ras_pll3_clk", 0,
 			1, 1);
@@ -170,7 +170,7 @@ static inline void spear300_clk_init(void) { }
 #ifdef CONFIG_MACH_SPEAR310
 static void __init spear310_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = clk_register_fixed_factor(NULL, "emi_clk", "ras_ahb_clk", 0, 1,
 			1);
@@ -247,7 +247,7 @@ static const char *uartx_parents[] = { "ras_syn1_gclk", "ras_apb_clk", };
 
 static void __init spear320_clk_init(void __iomem *soc_config_base)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = clk_register_fixed_rate(NULL, "smii_125m_pad_clk", NULL,
 			CLK_IS_ROOT, 125000000);
@@ -384,7 +384,7 @@ static inline void spear320_clk_init(void __iomem *soc_config_base) { }
 
 void __init spear3xx_clk_init(void __iomem *misc_base, void __iomem *soc_config_base)
 {
-	struct clk *clk, *clk1;
+	struct clk_core *clk, *clk1;
 
 	clk = clk_register_fixed_rate(NULL, "osc_32k_clk", NULL, CLK_IS_ROOT,
 			32000);
diff --git a/drivers/clk/spear/spear6xx_clock.c b/drivers/clk/spear/spear6xx_clock.c
index 4f649c9..db946f7 100644
--- a/drivers/clk/spear/spear6xx_clock.c
+++ b/drivers/clk/spear/spear6xx_clock.c
@@ -116,7 +116,7 @@ static struct gpt_rate_tbl gpt_rtbl[] = {
 
 void __init spear6xx_clk_init(void __iomem *misc_base)
 {
-	struct clk *clk, *clk1;
+	struct clk_core *clk, *clk1;
 
 	clk = clk_register_fixed_rate(NULL, "osc_32k_clk", NULL, CLK_IS_ROOT,
 			32000);
diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index 4f53ee0..a27a876 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -474,13 +474,13 @@ static const struct clk_ops st_quadfs_pll_c32_ops = {
 	.set_rate	= quadfs_pll_fs660c32_set_rate,
 };
 
-static struct clk * __init st_clk_register_quadfs_pll(
+static struct clk_core * __init st_clk_register_quadfs_pll(
 		const char *name, const char *parent_name,
 		struct clkgen_quadfs_data *quadfs, void __iomem *reg,
 		spinlock_t *lock)
 {
 	struct st_clk_quadfs_pll *pll;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	/*
@@ -875,13 +875,13 @@ static const struct clk_ops st_quadfs_ops = {
 	.recalc_rate	= quadfs_recalc_rate,
 };
 
-static struct clk * __init st_clk_register_quadfs_fsynth(
+static struct clk_core * __init st_clk_register_quadfs_fsynth(
 		const char *name, const char *parent_name,
 		struct clkgen_quadfs_data *quadfs, void __iomem *reg, u32 chan,
 		spinlock_t *lock)
 {
 	struct st_clk_quadfs_fsynth *fs;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	/*
@@ -947,7 +947,7 @@ static void __init st_of_create_quadfs_fsynths(
 		return;
 
 	clk_data->clk_num = QUADFS_MAX_CHAN;
-	clk_data->clks = kzalloc(QUADFS_MAX_CHAN * sizeof(struct clk *),
+	clk_data->clks = kzalloc(QUADFS_MAX_CHAN * sizeof(struct clk_core *),
 				 GFP_KERNEL);
 
 	if (!clk_data->clks) {
@@ -956,7 +956,7 @@ static void __init st_of_create_quadfs_fsynths(
 	}
 
 	for (fschan = 0; fschan < QUADFS_MAX_CHAN; fschan++) {
-		struct clk *clk;
+		struct clk_core *clk;
 		const char *clk_name;
 
 		if (of_property_read_string_index(np, "clock-output-names",
@@ -981,8 +981,8 @@ static void __init st_of_create_quadfs_fsynths(
 			clk_data->clks[fschan] = clk;
 			pr_debug("%s: parent %s rate %u\n",
 				__clk_get_name(clk),
-				__clk_get_name(clk_get_parent(clk)),
-				(unsigned int)clk_get_rate(clk));
+				__clk_get_name(clk_provider_get_parent(clk)),
+				(unsigned int)clk_provider_get_rate(clk));
 		}
 	}
 
@@ -992,7 +992,7 @@ static void __init st_of_create_quadfs_fsynths(
 static void __init st_of_quadfs_setup(struct device_node *np)
 {
 	const struct of_device_id *match;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *pll_name, *clk_parent_name;
 	void __iomem *reg;
 	spinlock_t *lock;
@@ -1026,8 +1026,8 @@ static void __init st_of_quadfs_setup(struct device_node *np)
 	else
 		pr_debug("%s: parent %s rate %u\n",
 			__clk_get_name(clk),
-			__clk_get_name(clk_get_parent(clk)),
-			(unsigned int)clk_get_rate(clk));
+			__clk_get_name(clk_provider_get_parent(clk)),
+			(unsigned int)clk_provider_get_rate(clk));
 
 	st_of_create_quadfs_fsynths(np, pll_name,
 				    (struct clkgen_quadfs_data *)match->data,
diff --git a/drivers/clk/st/clkgen-mux.c b/drivers/clk/st/clkgen-mux.c
index a329906..b144315 100644
--- a/drivers/clk/st/clkgen-mux.c
+++ b/drivers/clk/st/clkgen-mux.c
@@ -215,7 +215,7 @@ static const struct clk_ops clkgena_divmux_ops = {
 /**
  * clk_register_genamux - register a genamux clock with the clock framework
  */
-struct clk *clk_register_genamux(const char *name,
+struct clk_core *clk_register_genamux(const char *name,
 				const char **parent_names, u8 num_parents,
 				void __iomem *reg,
 				const struct clkgena_divmux_data *muxdata,
@@ -227,7 +227,7 @@ struct clk *clk_register_genamux(const char *name,
 	const int mux_width = 2;
 	const int divider_width = 5;
 	struct clkgena_divmux *genamux;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 	int i;
 
@@ -280,8 +280,8 @@ struct clk *clk_register_genamux(const char *name,
 
 	pr_debug("%s: parent %s rate %lu\n",
 			__clk_get_name(clk),
-			__clk_get_name(clk_get_parent(clk)),
-			clk_get_rate(clk));
+			__clk_get_name(clk_provider_get_parent(clk)),
+			clk_provider_get_rate(clk));
 err:
 	return clk;
 }
@@ -413,14 +413,14 @@ void __init st_of_clkgena_divmux_setup(struct device_node *np)
 		goto err;
 
 	clk_data->clk_num = data->num_outputs;
-	clk_data->clks = kzalloc(clk_data->clk_num * sizeof(struct clk *),
+	clk_data->clks = kzalloc(clk_data->clk_num * sizeof(struct clk_core *),
 				 GFP_KERNEL);
 
 	if (!clk_data->clks)
 		goto err;
 
 	for (i = 0; i < clk_data->clk_num; i++) {
-		struct clk *clk;
+		struct clk_core *clk;
 		const char *clk_name;
 
 		if (of_property_read_string_index(np, "clock-output-names",
@@ -490,7 +490,7 @@ void __init st_of_clkgena_prediv_setup(struct device_node *np)
 	const struct of_device_id *match;
 	void __iomem *reg;
 	const char *parent_name, *clk_name;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clkgena_prediv_data *data;
 
 	match = of_match_node(clkgena_prediv_of_match, np);
@@ -522,8 +522,8 @@ void __init st_of_clkgena_prediv_setup(struct device_node *np)
 	of_clk_add_provider(np, of_clk_src_simple_get, clk);
 	pr_debug("%s: parent %s rate %u\n",
 		__clk_get_name(clk),
-		__clk_get_name(clk_get_parent(clk)),
-		(unsigned int)clk_get_rate(clk));
+		__clk_get_name(clk_provider_get_parent(clk)),
+		(unsigned int)clk_provider_get_rate(clk));
 
 	return;
 }
@@ -616,7 +616,7 @@ static struct of_device_id mux_of_match[] = {
 void __init st_of_clkgen_mux_setup(struct device_node *np)
 {
 	const struct of_device_id *match;
-	struct clk *clk;
+	struct clk_core *clk;
 	void __iomem *reg;
 	const char **parents;
 	int num_parents;
@@ -653,8 +653,8 @@ void __init st_of_clkgen_mux_setup(struct device_node *np)
 
 	pr_debug("%s: parent %s rate %u\n",
 			__clk_get_name(clk),
-			__clk_get_name(clk_get_parent(clk)),
-			(unsigned int)clk_get_rate(clk));
+			__clk_get_name(clk_provider_get_parent(clk)),
+			(unsigned int)clk_provider_get_rate(clk));
 
 	of_clk_add_provider(np, of_clk_src_simple_get, clk);
 
@@ -717,14 +717,14 @@ void __init st_of_clkgen_vcc_setup(struct device_node *np)
 		goto err;
 
 	clk_data->clk_num = VCC_MAX_CHANNELS;
-	clk_data->clks = kzalloc(clk_data->clk_num * sizeof(struct clk *),
+	clk_data->clks = kzalloc(clk_data->clk_num * sizeof(struct clk_core *),
 				 GFP_KERNEL);
 
 	if (!clk_data->clks)
 		goto err;
 
 	for (i = 0; i < clk_data->clk_num; i++) {
-		struct clk *clk;
+		struct clk_core *clk;
 		const char *clk_name;
 		struct clk_gate *gate;
 		struct clk_divider *div;
@@ -786,8 +786,8 @@ void __init st_of_clkgen_vcc_setup(struct device_node *np)
 
 		pr_debug("%s: parent %s rate %u\n",
 			__clk_get_name(clk),
-			__clk_get_name(clk_get_parent(clk)),
-			(unsigned int)clk_get_rate(clk));
+			__clk_get_name(clk_provider_get_parent(clk)),
+			(unsigned int)clk_provider_get_rate(clk));
 
 		clk_data->clks[i] = clk;
 	}
diff --git a/drivers/clk/st/clkgen-pll.c b/drivers/clk/st/clkgen-pll.c
index d8b9b1a..26cec54 100644
--- a/drivers/clk/st/clkgen-pll.c
+++ b/drivers/clk/st/clkgen-pll.c
@@ -342,13 +342,13 @@ static const struct clk_ops st_pll1200c32_ops = {
 	.recalc_rate	= recalc_stm_pll1200c32,
 };
 
-static struct clk * __init clkgen_pll_register(const char *parent_name,
+static struct clk_core * __init clkgen_pll_register(const char *parent_name,
 				struct clkgen_pll_data	*pll_data,
 				void __iomem *reg,
 				const char *clk_name)
 {
 	struct clkgen_pll *pll;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
@@ -374,16 +374,16 @@ static struct clk * __init clkgen_pll_register(const char *parent_name,
 
 	pr_debug("%s: parent %s rate %lu\n",
 			__clk_get_name(clk),
-			__clk_get_name(clk_get_parent(clk)),
-			clk_get_rate(clk));
+			__clk_get_name(clk_provider_get_parent(clk)),
+			clk_provider_get_rate(clk));
 
 	return clk;
 }
 
-static struct clk * __init clkgen_c65_lsdiv_register(const char *parent_name,
+static struct clk_core * __init clkgen_c65_lsdiv_register(const char *parent_name,
 						     const char *clk_name)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = clk_register_fixed_factor(NULL, clk_name, parent_name, 0, 1, 2);
 	if (IS_ERR(clk))
@@ -391,8 +391,8 @@ static struct clk * __init clkgen_c65_lsdiv_register(const char *parent_name,
 
 	pr_debug("%s: parent %s rate %lu\n",
 			__clk_get_name(clk),
-			__clk_get_name(clk_get_parent(clk)),
-			clk_get_rate(clk));
+			__clk_get_name(clk_provider_get_parent(clk)),
+			clk_provider_get_rate(clk));
 	return clk;
 }
 
@@ -436,7 +436,7 @@ static void __init clkgena_c65_pll_setup(struct device_node *np)
 		return;
 
 	clk_data->clk_num = num_pll_outputs;
-	clk_data->clks = kzalloc(clk_data->clk_num * sizeof(struct clk *),
+	clk_data->clks = kzalloc(clk_data->clk_num * sizeof(struct clk_core *),
 				 GFP_KERNEL);
 
 	if (!clk_data->clks)
@@ -497,14 +497,14 @@ err:
 CLK_OF_DECLARE(clkgena_c65_plls,
 	       "st,clkgena-plls-c65", clkgena_c65_pll_setup);
 
-static struct clk * __init clkgen_odf_register(const char *parent_name,
+static struct clk_core * __init clkgen_odf_register(const char *parent_name,
 					       void * __iomem reg,
 					       struct clkgen_pll_data *pll_data,
 					       int odf,
 					       spinlock_t *odf_lock,
 					       const char *odf_name)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	unsigned long flags;
 	struct clk_gate *gate;
 	struct clk_divider *div;
@@ -542,8 +542,8 @@ static struct clk * __init clkgen_odf_register(const char *parent_name,
 
 	pr_debug("%s: parent %s rate %lu\n",
 			__clk_get_name(clk),
-			__clk_get_name(clk_get_parent(clk)),
-			clk_get_rate(clk));
+			__clk_get_name(clk_provider_get_parent(clk)),
+			clk_provider_get_rate(clk));
 	return clk;
 }
 
@@ -578,7 +578,7 @@ static struct of_device_id c32_pll_of_match[] = {
 static void __init clkgen_c32_pll_setup(struct device_node *np)
 {
 	const struct of_device_id *match;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name, *pll_name;
 	void __iomem *pll_base;
 	int num_odfs, odf;
@@ -614,14 +614,14 @@ static void __init clkgen_c32_pll_setup(struct device_node *np)
 		return;
 
 	clk_data->clk_num = num_odfs;
-	clk_data->clks = kzalloc(clk_data->clk_num * sizeof(struct clk *),
+	clk_data->clks = kzalloc(clk_data->clk_num * sizeof(struct clk_core *),
 				 GFP_KERNEL);
 
 	if (!clk_data->clks)
 		goto err;
 
 	for (odf = 0; odf < num_odfs; odf++) {
-		struct clk *clk;
+		struct clk_core *clk;
 		const char *clk_name;
 
 		if (of_property_read_string_index(np, "clock-output-names",
@@ -661,7 +661,7 @@ static struct of_device_id c32_gpu_pll_of_match[] = {
 static void __init clkgengpu_c32_pll_setup(struct device_node *np)
 {
 	const struct of_device_id *match;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name;
 	void __iomem *reg;
 	const char *clk_name;
diff --git a/drivers/clk/sunxi/clk-a10-hosc.c b/drivers/clk/sunxi/clk-a10-hosc.c
index 0481d5d..c5e4c41 100644
--- a/drivers/clk/sunxi/clk-a10-hosc.c
+++ b/drivers/clk/sunxi/clk-a10-hosc.c
@@ -25,7 +25,7 @@ static DEFINE_SPINLOCK(hosc_lock);
 
 static void __init sun4i_osc_clk_setup(struct device_node *node)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_fixed_rate *fixed;
 	struct clk_gate *gate;
 	const char *clk_name = node->name;
diff --git a/drivers/clk/sunxi/clk-a20-gmac.c b/drivers/clk/sunxi/clk-a20-gmac.c
index 633ddc4..3e58734 100644
--- a/drivers/clk/sunxi/clk-a20-gmac.c
+++ b/drivers/clk/sunxi/clk-a20-gmac.c
@@ -55,7 +55,7 @@ static DEFINE_SPINLOCK(gmac_lock);
 
 static void __init sun7i_a20_gmac_clk_setup(struct device_node *node)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_mux *mux;
 	struct clk_gate *gate;
 	const char *clk_name = node->name;
diff --git a/drivers/clk/sunxi/clk-factors.c b/drivers/clk/sunxi/clk-factors.c
index 3806d97..3acdda6 100644
--- a/drivers/clk/sunxi/clk-factors.c
+++ b/drivers/clk/sunxi/clk-factors.c
@@ -79,9 +79,9 @@ static long clk_factors_round_rate(struct clk_hw *hw, unsigned long rate,
 
 static long clk_factors_determine_rate(struct clk_hw *hw, unsigned long rate,
 				       unsigned long *best_parent_rate,
-				       struct clk **best_parent_p)
+				       struct clk_core **best_parent_p)
 {
-	struct clk *clk = hw->clk, *parent, *best_parent = NULL;
+	struct clk_core *clk = hw->clk, *parent, *best_parent = NULL;
 	int i, num_parents;
 	unsigned long parent_rate, best = 0, child_rate, best_child_rate = 0;
 
diff --git a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
index 44cd27c..e7e2db9 100644
--- a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
+++ b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
@@ -50,7 +50,7 @@ static int sun6i_a31_apb0_gates_clk_probe(struct platform_device *pdev)
 
 	clk_data->clks = devm_kzalloc(&pdev->dev,
 				      SUN6I_APB0_GATES_MAX_SIZE *
-				      sizeof(struct clk *),
+				      sizeof(struct clk_core *),
 				      GFP_KERNEL);
 	if (!clk_data->clks)
 		return -ENOMEM;
diff --git a/drivers/clk/sunxi/clk-sun6i-apb0.c b/drivers/clk/sunxi/clk-sun6i-apb0.c
index 11f17c3..241d274 100644
--- a/drivers/clk/sunxi/clk-sun6i-apb0.c
+++ b/drivers/clk/sunxi/clk-sun6i-apb0.c
@@ -35,7 +35,7 @@ static int sun6i_a31_apb0_clk_probe(struct platform_device *pdev)
 	const char *clk_parent;
 	struct resource *r;
 	void __iomem *reg;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	reg = devm_ioremap_resource(&pdev->dev, r);
diff --git a/drivers/clk/sunxi/clk-sun6i-ar100.c b/drivers/clk/sunxi/clk-sun6i-ar100.c
index f73cc05..1e95eb4 100644
--- a/drivers/clk/sunxi/clk-sun6i-ar100.c
+++ b/drivers/clk/sunxi/clk-sun6i-ar100.c
@@ -46,7 +46,7 @@ static unsigned long ar100_recalc_rate(struct clk_hw *hw,
 
 static long ar100_determine_rate(struct clk_hw *hw, unsigned long rate,
 				 unsigned long *best_parent_rate,
-				 struct clk **best_parent_clk)
+				 struct clk_core **best_parent_clk)
 {
 	int nparents = __clk_get_num_parents(hw->clk);
 	long best_rate = -EINVAL;
@@ -57,7 +57,7 @@ static long ar100_determine_rate(struct clk_hw *hw, unsigned long rate,
 	for (i = 0; i < nparents; i++) {
 		unsigned long parent_rate;
 		unsigned long tmp_rate;
-		struct clk *parent;
+		struct clk_core *parent;
 		unsigned long div;
 		int shift;
 
@@ -176,7 +176,7 @@ static int sun6i_a31_ar100_clk_probe(struct platform_device *pdev)
 	struct clk_init_data init;
 	struct ar100_clk *ar100;
 	struct resource *r;
-	struct clk *clk;
+	struct clk_core *clk;
 	int nparents;
 	int i;
 
diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index fb2ce84..5de44c1 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -355,7 +355,7 @@ static void sun7i_a20_get_out_factors(u32 *freq, u32 parent_rate,
  * clk_sunxi_mmc_phase_control() - configures MMC clock phase control
  */
 
-void clk_sunxi_mmc_phase_control(struct clk *clk, u8 sample, u8 output)
+void clk_sunxi_mmc_phase_control(struct clk_core *clk, u8 sample, u8 output)
 {
 	#define to_clk_composite(_hw) container_of(_hw, struct clk_composite, hw)
 	#define to_clk_factors(_hw) container_of(_hw, struct clk_factors, hw)
@@ -516,10 +516,10 @@ static const struct factors_data sun7i_a20_out_data __initconst = {
 	.getter = sun7i_a20_get_out_factors,
 };
 
-static struct clk * __init sunxi_factors_clk_setup(struct device_node *node,
+static struct clk_core * __init sunxi_factors_clk_setup(struct device_node *node,
 						const struct factors_data *data)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_factors *factors;
 	struct clk_gate *gate = NULL;
 	struct clk_mux *mux = NULL;
@@ -629,7 +629,7 @@ static const struct mux_data sun4i_apb1_mux_data __initconst = {
 static void __init sunxi_mux_clk_setup(struct device_node *node,
 				       struct mux_data *data)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *clk_name = node->name;
 	const char *parents[SUNXI_MAX_PARENTS];
 	void *reg;
@@ -693,7 +693,7 @@ static const struct div_data sun6i_a31_apb2_div_data __initconst = {
 static void __init sunxi_divider_clk_setup(struct device_node *node,
 					   struct div_data *data)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *clk_name = node->name;
 	const char *clk_parent;
 	void *reg;
@@ -881,7 +881,7 @@ static void __init sunxi_gates_clk_setup(struct device_node *node,
 	clk_data = kmalloc(sizeof(struct clk_onecell_data), GFP_KERNEL);
 	if (!clk_data)
 		return;
-	clk_data->clks = kzalloc((qty+1) * sizeof(struct clk *), GFP_KERNEL);
+	clk_data->clks = kzalloc((qty+1) * sizeof(struct clk_core *), GFP_KERNEL);
 	if (!clk_data->clks) {
 		kfree(clk_data);
 		return;
@@ -985,7 +985,7 @@ static void __init sunxi_divs_clk_setup(struct device_node *node,
 	struct clk_onecell_data *clk_data;
 	const char *parent;
 	const char *clk_name;
-	struct clk **clks, *pclk;
+	struct clk_core **clks, *pclk;
 	struct clk_hw *gate_hw, *rate_hw;
 	const struct clk_ops *rate_ops;
 	struct clk_gate *gate = NULL;
@@ -1193,10 +1193,10 @@ static void __init sunxi_init_clocks(const char *clocks[], int nclocks)
 
 	/* Protect the clocks that needs to stay on */
 	for (i = 0; i < nclocks; i++) {
-		struct clk *clk = clk_get(NULL, clocks[i]);
+		struct clk_core *clk = clk_provider_get(NULL, clocks[i]);
 
 		if (!IS_ERR(clk))
-			clk_prepare_enable(clk);
+			clk_prepare_enable(clk_core_to_clk(clk));
 	}
 }
 
diff --git a/drivers/clk/tegra/clk-audio-sync.c b/drivers/clk/tegra/clk-audio-sync.c
index c0f7843..53c3488 100644
--- a/drivers/clk/tegra/clk-audio-sync.c
+++ b/drivers/clk/tegra/clk-audio-sync.c
@@ -54,12 +54,12 @@ const struct clk_ops tegra_clk_sync_source_ops = {
 	.recalc_rate = clk_sync_source_recalc_rate,
 };
 
-struct clk *tegra_clk_register_sync_source(const char *name,
+struct clk_core *tegra_clk_register_sync_source(const char *name,
 		unsigned long rate, unsigned long max_rate)
 {
 	struct tegra_clk_sync_source *sync;
 	struct clk_init_data init;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	sync = kzalloc(sizeof(*sync), GFP_KERNEL);
 	if (!sync) {
diff --git a/drivers/clk/tegra/clk-divider.c b/drivers/clk/tegra/clk-divider.c
index 290f9c1..7a1212b7 100644
--- a/drivers/clk/tegra/clk-divider.c
+++ b/drivers/clk/tegra/clk-divider.c
@@ -147,13 +147,13 @@ const struct clk_ops tegra_clk_frac_div_ops = {
 	.round_rate = clk_frac_div_round_rate,
 };
 
-struct clk *tegra_clk_register_divider(const char *name,
+struct clk_core *tegra_clk_register_divider(const char *name,
 		const char *parent_name, void __iomem *reg,
 		unsigned long flags, u8 clk_divider_flags, u8 shift, u8 width,
 		u8 frac_width, spinlock_t *lock)
 {
 	struct tegra_clk_frac_div *divider;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	divider = kzalloc(sizeof(*divider), GFP_KERNEL);
diff --git a/drivers/clk/tegra/clk-periph-gate.c b/drivers/clk/tegra/clk-periph-gate.c
index 5070153..5aaedd3 100644
--- a/drivers/clk/tegra/clk-periph-gate.c
+++ b/drivers/clk/tegra/clk-periph-gate.c
@@ -127,12 +127,12 @@ const struct clk_ops tegra_clk_periph_gate_ops = {
 	.disable = clk_periph_disable,
 };
 
-struct clk *tegra_clk_register_periph_gate(const char *name,
+struct clk_core *tegra_clk_register_periph_gate(const char *name,
 		const char *parent_name, u8 gate_flags, void __iomem *clk_base,
 		unsigned long flags, int clk_num, int *enable_refcnt)
 {
 	struct tegra_clk_periph_gate *gate;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 	struct tegra_clk_periph_regs *pregs;
 
diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c
index 9e899c18..ea26de3 100644
--- a/drivers/clk/tegra/clk-periph.c
+++ b/drivers/clk/tegra/clk-periph.c
@@ -138,13 +138,13 @@ static const struct clk_ops tegra_clk_periph_no_gate_ops = {
 	.set_rate = clk_periph_set_rate,
 };
 
-static struct clk *_tegra_clk_register_periph(const char *name,
+static struct clk_core *_tegra_clk_register_periph(const char *name,
 			const char **parent_names, int num_parents,
 			struct tegra_clk_periph *periph,
 			void __iomem *clk_base, u32 offset,
 			unsigned long flags)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 	struct tegra_clk_periph_regs *bank;
 	bool div = !(periph->gate.flags & TEGRA_PERIPH_NO_DIV);
@@ -186,7 +186,7 @@ static struct clk *_tegra_clk_register_periph(const char *name,
 	return clk;
 }
 
-struct clk *tegra_clk_register_periph(const char *name,
+struct clk_core *tegra_clk_register_periph(const char *name,
 		const char **parent_names, int num_parents,
 		struct tegra_clk_periph *periph, void __iomem *clk_base,
 		u32 offset, unsigned long flags)
@@ -195,7 +195,7 @@ struct clk *tegra_clk_register_periph(const char *name,
 			periph, clk_base, offset, flags);
 }
 
-struct clk *tegra_clk_register_periph_nodiv(const char *name,
+struct clk_core *tegra_clk_register_periph_nodiv(const char *name,
 		const char **parent_names, int num_parents,
 		struct tegra_clk_periph *periph, void __iomem *clk_base,
 		u32 offset)
diff --git a/drivers/clk/tegra/clk-pll-out.c b/drivers/clk/tegra/clk-pll-out.c
index 3598987..49ae7b1 100644
--- a/drivers/clk/tegra/clk-pll-out.c
+++ b/drivers/clk/tegra/clk-pll-out.c
@@ -87,13 +87,13 @@ const struct clk_ops tegra_clk_pll_out_ops = {
 	.disable = clk_pll_out_disable,
 };
 
-struct clk *tegra_clk_register_pll_out(const char *name,
+struct clk_core *tegra_clk_register_pll_out(const char *name,
 		const char *parent_name, void __iomem *reg, u8 enb_bit_idx,
 		u8 rst_bit_idx, unsigned long flags, u8 pll_out_flags,
 		spinlock_t *lock)
 {
 	struct tegra_clk_pll_out *pll_out;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	pll_out = kzalloc(sizeof(*pll_out), GFP_KERNEL);
diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 637b62c..34063ed 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -723,7 +723,7 @@ static int clk_plle_training(struct tegra_clk_pll *pll)
 static int clk_plle_enable(struct clk_hw *hw)
 {
 	struct tegra_clk_pll *pll = to_clk_pll(hw);
-	unsigned long input_rate = clk_get_rate(clk_get_parent(hw->clk));
+	unsigned long input_rate = clk_provider_get_rate(clk_provider_get_parent(hw->clk));
 	struct tegra_clk_pll_freq_table sel;
 	u32 val;
 	int err;
@@ -1027,7 +1027,7 @@ static int clk_pllm_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	state = clk_pll_is_enabled(hw);
 	if (state) {
-		if (rate != clk_get_rate(hw->clk)) {
+		if (rate != clk_provider_get_rate(hw->clk)) {
 			pr_err("%s: Cannot change active PLLM\n", __func__);
 			ret = -EINVAL;
 			goto out;
@@ -1279,7 +1279,7 @@ static int clk_plle_tegra114_enable(struct clk_hw *hw)
 	u32 val;
 	int ret;
 	unsigned long flags = 0;
-	unsigned long input_rate = clk_get_rate(clk_get_parent(hw->clk));
+	unsigned long input_rate = clk_provider_get_rate(clk_provider_get_parent(hw->clk));
 
 	if (_get_table_rate(hw, &sel, pll->params->fixed_rate, input_rate))
 		return -EINVAL;
@@ -1411,7 +1411,7 @@ static struct tegra_clk_pll *_tegra_init_pll(void __iomem *clk_base,
 	return pll;
 }
 
-static struct clk *_tegra_clk_register_pll(struct tegra_clk_pll *pll,
+static struct clk_core *_tegra_clk_register_pll(struct tegra_clk_pll *pll,
 		const char *name, const char *parent_name, unsigned long flags,
 		const struct clk_ops *ops)
 {
@@ -1429,13 +1429,13 @@ static struct clk *_tegra_clk_register_pll(struct tegra_clk_pll *pll,
 	return clk_register(NULL, &pll->hw);
 }
 
-struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_pll(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
 		unsigned long flags, struct tegra_clk_pll_params *pll_params,
 		spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	pll_params->flags |= TEGRA_PLL_BYPASS;
 	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
@@ -1460,13 +1460,13 @@ static struct div_nmp pll_e_nmp = {
 	.divp_width = PLLE_BASE_DIVP_WIDTH,
 };
 
-struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_plle(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
 		unsigned long flags, struct tegra_clk_pll_params *pll_params,
 		spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	pll_params->flags |= TEGRA_PLL_LOCK_MISC | TEGRA_PLL_BYPASS;
 	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
@@ -1531,14 +1531,14 @@ static const struct clk_ops tegra_clk_plle_tegra114_ops = {
 };
 
 
-struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_pllxc(const char *name, const char *parent_name,
 			  void __iomem *clk_base, void __iomem *pmc,
 			  unsigned long flags,
 			  struct tegra_clk_pll_params *pll_params,
 			  spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
-	struct clk *clk, *parent;
+	struct clk_core *clk, *parent;
 	unsigned long parent_rate;
 	int err;
 	u32 val, val_iddq;
@@ -1584,7 +1584,7 @@ struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
 	return clk;
 }
 
-struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_pllre(const char *name, const char *parent_name,
 			  void __iomem *clk_base, void __iomem *pmc,
 			  unsigned long flags,
 			  struct tegra_clk_pll_params *pll_params,
@@ -1592,7 +1592,7 @@ struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
 {
 	u32 val;
 	struct tegra_clk_pll *pll;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE | TEGRA_PLL_LOCK_MISC;
 
@@ -1630,14 +1630,14 @@ struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
 	return clk;
 }
 
-struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_pllm(const char *name, const char *parent_name,
 			  void __iomem *clk_base, void __iomem *pmc,
 			  unsigned long flags,
 			  struct tegra_clk_pll_params *pll_params,
 			  spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
-	struct clk *clk, *parent;
+	struct clk_core *clk, *parent;
 	unsigned long parent_rate;
 
 	if (!pll_params->pdiv_tohw)
@@ -1669,13 +1669,13 @@ struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
 	return clk;
 }
 
-struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_pllc(const char *name, const char *parent_name,
 			  void __iomem *clk_base, void __iomem *pmc,
 			  unsigned long flags,
 			  struct tegra_clk_pll_params *pll_params,
 			  spinlock_t *lock)
 {
-	struct clk *parent, *clk;
+	struct clk_core *parent, *clk;
 	struct pdiv_map *p_tohw = pll_params->pdiv_tohw;
 	struct tegra_clk_pll *pll;
 	struct tegra_clk_pll_freq_table cfg;
@@ -1743,14 +1743,14 @@ struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
 	return clk;
 }
 
-struct clk *tegra_clk_register_plle_tegra114(const char *name,
+struct clk_core *tegra_clk_register_plle_tegra114(const char *name,
 				const char *parent_name,
 				void __iomem *clk_base, unsigned long flags,
 				struct tegra_clk_pll_params *pll_params,
 				spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
-	struct clk *clk;
+	struct clk_core *clk;
 	u32 val, val_aux;
 
 	pll_params->flags |= TEGRA_PLL_HAS_LOCK_ENABLE;
@@ -1793,13 +1793,13 @@ static const struct clk_ops tegra_clk_pllss_ops = {
 	.set_rate = clk_pllxc_set_rate,
 };
 
-struct clk *tegra_clk_register_pllss(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_pllss(const char *name, const char *parent_name,
 				void __iomem *clk_base, unsigned long flags,
 				struct tegra_clk_pll_params *pll_params,
 				spinlock_t *lock)
 {
 	struct tegra_clk_pll *pll;
-	struct clk *clk, *parent;
+	struct clk_core *clk, *parent;
 	struct tegra_clk_pll_freq_table cfg;
 	unsigned long parent_rate;
 	u32 val;
diff --git a/drivers/clk/tegra/clk-super.c b/drivers/clk/tegra/clk-super.c
index 2fd924d..e843d20 100644
--- a/drivers/clk/tegra/clk-super.c
+++ b/drivers/clk/tegra/clk-super.c
@@ -127,13 +127,13 @@ const struct clk_ops tegra_clk_super_ops = {
 	.set_parent = clk_super_set_parent,
 };
 
-struct clk *tegra_clk_register_super_mux(const char *name,
+struct clk_core *tegra_clk_register_super_mux(const char *name,
 		const char **parent_names, u8 num_parents,
 		unsigned long flags, void __iomem *reg, u8 clk_super_flags,
 		u8 width, u8 pllx_index, u8 div2_index, spinlock_t *lock)
 {
 	struct tegra_clk_super_mux *super;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	super = kzalloc(sizeof(*super), GFP_KERNEL);
diff --git a/drivers/clk/tegra/clk-tegra-audio.c b/drivers/clk/tegra/clk-tegra-audio.c
index 5c38aab..484a900 100644
--- a/drivers/clk/tegra/clk-tegra-audio.c
+++ b/drivers/clk/tegra/clk-tegra-audio.c
@@ -128,8 +128,8 @@ void __init tegra_audio_clk_init(void __iomem *clk_base,
 			void __iomem *pmc_base, struct tegra_clk *tegra_clks,
 			struct tegra_clk_pll_params *pll_a_params)
 {
-	struct clk *clk;
-	struct clk **dt_clk;
+	struct clk_core *clk;
+	struct clk_core **dt_clk;
 	int i;
 
 	/* PLLA */
diff --git a/drivers/clk/tegra/clk-tegra-fixed.c b/drivers/clk/tegra/clk-tegra-fixed.c
index f3b7738..503e261 100644
--- a/drivers/clk/tegra/clk-tegra-fixed.c
+++ b/drivers/clk/tegra/clk-tegra-fixed.c
@@ -36,8 +36,8 @@ int __init tegra_osc_clk_init(void __iomem *clk_base,
 				unsigned long *osc_freq,
 				unsigned long *pll_ref_freq)
 {
-	struct clk *clk;
-	struct clk **dt_clk;
+	struct clk_core *clk;
+	struct clk_core **dt_clk;
 	u32 val, pll_ref_div;
 	unsigned osc_idx;
 
@@ -81,8 +81,8 @@ int __init tegra_osc_clk_init(void __iomem *clk_base,
 
 void __init tegra_fixed_clk_init(struct tegra_clk *tegra_clks)
 {
-	struct clk *clk;
-	struct clk **dt_clk;
+	struct clk_core *clk;
+	struct clk_core **dt_clk;
 
 	/* clk_32k */
 	dt_clk = tegra_lookup_dt_id(tegra_clk_clk_32k, tegra_clks);
diff --git a/drivers/clk/tegra/clk-tegra-periph.c b/drivers/clk/tegra/clk-tegra-periph.c
index adf6b81..dd06579 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -585,8 +585,8 @@ static void __init periph_clk_init(void __iomem *clk_base,
 				struct tegra_clk *tegra_clks)
 {
 	int i;
-	struct clk *clk;
-	struct clk **dt_clk;
+	struct clk_core *clk;
+	struct clk_core **dt_clk;
 
 	for (i = 0; i < ARRAY_SIZE(periph_clks); i++) {
 		struct tegra_clk_periph_regs *bank;
@@ -615,8 +615,8 @@ static void __init gate_clk_init(void __iomem *clk_base,
 				struct tegra_clk *tegra_clks)
 {
 	int i;
-	struct clk *clk;
-	struct clk **dt_clk;
+	struct clk_core *clk;
+	struct clk_core **dt_clk;
 
 	for (i = 0; i < ARRAY_SIZE(gate_clks); i++) {
 		struct tegra_periph_init_data *data;
@@ -640,8 +640,8 @@ static void __init init_pllp(void __iomem *clk_base, void __iomem *pmc_base,
 				struct tegra_clk *tegra_clks,
 				struct tegra_clk_pll_params *pll_params)
 {
-	struct clk *clk;
-	struct clk **dt_clk;
+	struct clk_core *clk;
+	struct clk_core **dt_clk;
 	int i;
 
 	dt_clk = tegra_lookup_dt_id(tegra_clk_pll_p, tegra_clks);
diff --git a/drivers/clk/tegra/clk-tegra-pmc.c b/drivers/clk/tegra/clk-tegra-pmc.c
index 08b21c1..2ff427a 100644
--- a/drivers/clk/tegra/clk-tegra-pmc.c
+++ b/drivers/clk/tegra/clk-tegra-pmc.c
@@ -82,8 +82,8 @@ static struct pmc_clk_init_data pmc_clks[] = {
 void __init tegra_pmc_clk_init(void __iomem *pmc_base,
 				struct tegra_clk *tegra_clks)
 {
-	struct clk *clk;
-	struct clk **dt_clk;
+	struct clk_core *clk;
+	struct clk_core **dt_clk;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(pmc_clks); i++) {
diff --git a/drivers/clk/tegra/clk-tegra-super-gen4.c b/drivers/clk/tegra/clk-tegra-super-gen4.c
index feb3201..e6224c4 100644
--- a/drivers/clk/tegra/clk-tegra-super-gen4.c
+++ b/drivers/clk/tegra/clk-tegra-super-gen4.c
@@ -53,8 +53,8 @@ static const char *cclk_lp_parents[] = { "clk_m", "pll_c", "clk_32k", "pll_m",
 static void __init tegra_sclk_init(void __iomem *clk_base,
 				struct tegra_clk *tegra_clks)
 {
-	struct clk *clk;
-	struct clk **dt_clk;
+	struct clk_core *clk;
+	struct clk_core **dt_clk;
 
 	/* SCLK */
 	dt_clk = tegra_lookup_dt_id(tegra_clk_sclk, tegra_clks);
@@ -99,8 +99,8 @@ void __init tegra_super_clk_gen4_init(void __iomem *clk_base,
 				struct tegra_clk *tegra_clks,
 				struct tegra_clk_pll_params *params)
 {
-	struct clk *clk;
-	struct clk **dt_clk;
+	struct clk_core *clk;
+	struct clk_core **dt_clk;
 
 	/* CCLKG */
 	dt_clk = tegra_lookup_dt_id(tegra_clk_cclk_g, tegra_clks);
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index b9c8ba2..a16e064 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -923,14 +923,14 @@ static struct tegra_devclk devclks[] __initdata = {
 	{ .dev_id = "timer", .dt_id = TEGRA114_CLK_TIMER },
 };
 
-static struct clk **clks;
+static struct clk_core **clks;
 
 static unsigned long osc_freq;
 static unsigned long pll_ref_freq;
 
 static int __init tegra114_osc_clk_init(void __iomem *clk_base)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	u32 val, pll_ref_div;
 
 	val = readl_relaxed(clk_base + OSC_CTRL);
@@ -960,7 +960,7 @@ static int __init tegra114_osc_clk_init(void __iomem *clk_base)
 
 static void __init tegra114_fixed_clk_init(void __iomem *clk_base)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* clk_32k */
 	clk = clk_register_fixed_rate(NULL, "clk_32k", NULL, CLK_IS_ROOT,
@@ -1065,7 +1065,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				     void __iomem *pmc)
 {
 	u32 val;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* PLLC */
 	clk = tegra_clk_register_pllxc("pll_c", "pll_ref", clk_base,
@@ -1181,7 +1181,7 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 static __init void tegra114_periph_clk_init(void __iomem *clk_base,
 					    void __iomem *pmc_base)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* xusb_ss_div2 */
 	clk = clk_register_fixed_factor(NULL, "xusb_ss_div2", "xusb_ss_src", 0,
diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 80efe51..b77cb64 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -1017,7 +1017,7 @@ static struct tegra_devclk devclks[] __initdata = {
 	{ .dev_id = "timer", .dt_id = TEGRA124_CLK_TIMER },
 };
 
-static struct clk **clks;
+static struct clk_core **clks;
 
 static void tegra124_utmi_param_configure(void __iomem *clk_base)
 {
@@ -1104,7 +1104,7 @@ static void tegra124_utmi_param_configure(void __iomem *clk_base)
 static __init void tegra124_periph_clk_init(void __iomem *clk_base,
 					    void __iomem *pmc_base)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* xusb_ss_div2 */
 	clk = clk_register_fixed_factor(NULL, "xusb_ss_div2", "xusb_ss_src", 0,
@@ -1148,7 +1148,7 @@ static void __init tegra124_pll_init(void __iomem *clk_base,
 				     void __iomem *pmc)
 {
 	u32 val;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* PLLC */
 	clk = tegra_clk_register_pllxc("pll_c", "pll_ref", clk_base,
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index dace2b1..6783355 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -162,7 +162,7 @@ static void __iomem *pmc_base;
 			_clk_num, _gate_flags,	\
 			_clk_id)
 
-static struct clk **clks;
+static struct clk_core **clks;
 
 static struct tegra_clk_pll_freq_table pll_c_freq_table[] = {
 	{ 12000000, 600000000, 600, 12, 0, 8 },
@@ -633,7 +633,7 @@ static unsigned int tegra20_get_pll_ref_div(void)
 
 static void tegra20_pll_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* PLLC */
 	clk = tegra_clk_register_pll("pll_c", "pll_ref", clk_base, NULL, 0,
@@ -713,7 +713,7 @@ static const char *sclk_parents[] = { "clk_m", "pll_c_out1", "pll_p_out4",
 
 static void tegra20_super_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* CCLK */
 	clk = tegra_clk_register_super_mux("cclk", cclk_parents,
@@ -738,7 +738,7 @@ static const char *audio_parents[] = {"spdif_in", "i2s1", "i2s2", "unused",
 
 static void __init tegra20_audio_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* audio */
 	clk = clk_register_mux(NULL, "audio_mux", audio_parents,
@@ -800,7 +800,7 @@ static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
 static void __init tegra20_periph_clk_init(void)
 {
 	struct tegra_periph_init_data *data;
-	struct clk *clk;
+	struct clk_core *clk;
 	int i;
 
 	/* ac97 */
@@ -871,7 +871,7 @@ static void __init tegra20_periph_clk_init(void)
 
 static void __init tegra20_osc_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	unsigned long input_freq;
 	unsigned int pll_ref_div;
 
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 8b10c38..801bb61 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -202,7 +202,7 @@ static DEFINE_SPINLOCK(pll_d_lock);
 			_clk_num, _gate_flags,	\
 			_clk_id)
 
-static struct clk **clks;
+static struct clk_core **clks;
 
 /*
  * Structure defining the fields for USB UTMI clocks Parameters.
@@ -918,7 +918,7 @@ static const char *pll_e_parents[] = {"pll_ref", "pll_p"};
 
 static void __init tegra30_pll_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* PLLC */
 	clk = tegra_clk_register_pll("pll_c", "pll_ref", clk_base, pmc_base, 0,
@@ -1009,7 +1009,7 @@ static const char *sclk_parents[] = { "clk_m", "pll_c_out1", "pll_p_out4",
 
 static void __init tegra30_super_clk_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/*
 	 * Clock input to cclk_g divided from pll_p using
@@ -1131,7 +1131,7 @@ static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
 static void __init tegra30_periph_clk_init(void)
 {
 	struct tegra_periph_init_data *data;
-	struct clk *clk;
+	struct clk_core *clk;
 	int i;
 
 	/* dsia */
diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index c0a7d77..385d101 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -68,7 +68,7 @@ struct tegra_cpu_car_ops *tegra_cpu_car_ops = &dummy_car_ops;
 
 int *periph_clk_enb_refcnt;
 static int periph_banks;
-static struct clk **clks;
+static struct clk_core **clks;
 static int clk_num;
 static struct clk_onecell_data clk_data;
 
@@ -164,7 +164,7 @@ struct tegra_clk_periph_regs *get_reg_bank(int clkid)
 	}
 }
 
-struct clk ** __init tegra_clk_init(void __iomem *regs, int num, int banks)
+struct clk_core ** __init tegra_clk_init(void __iomem *regs, int num, int banks)
 {
 	clk_base = regs;
 
@@ -178,7 +178,7 @@ struct clk ** __init tegra_clk_init(void __iomem *regs, int num, int banks)
 
 	periph_banks = banks;
 
-	clks = kzalloc(num * sizeof(struct clk *), GFP_KERNEL);
+	clks = kzalloc(num * sizeof(struct clk_core *), GFP_KERNEL);
 	if (!clks)
 		kfree(periph_clk_enb_refcnt);
 
@@ -188,9 +188,9 @@ struct clk ** __init tegra_clk_init(void __iomem *regs, int num, int banks)
 }
 
 void __init tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
-				struct clk *clks[], int clk_max)
+				struct clk_core *clks[], int clk_max)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	for (; dup_list->clk_id < clk_max; dup_list++) {
 		clk = clks[dup_list->clk_id];
@@ -200,9 +200,9 @@ void __init tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 }
 
 void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
-				  struct clk *clks[], int clk_max)
+				  struct clk_core *clks[], int clk_max)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	for (; tbl->clk_id < clk_max; tbl++) {
 		clk = clks[tbl->clk_id];
@@ -210,8 +210,8 @@ void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
 			return;
 
 		if (tbl->parent_id < clk_max) {
-			struct clk *parent = clks[tbl->parent_id];
-			if (clk_set_parent(clk, parent)) {
+			struct clk_core *parent = clks[tbl->parent_id];
+			if (clk_provider_set_parent(clk, parent)) {
 				pr_err("%s: Failed to set parent %s of %s\n",
 				       __func__, __clk_get_name(parent),
 				       __clk_get_name(clk));
@@ -220,7 +220,7 @@ void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
 		}
 
 		if (tbl->rate)
-			if (clk_set_rate(clk, tbl->rate)) {
+			if (clk_provider_set_rate(clk, tbl->rate)) {
 				pr_err("%s: Failed to set rate %lu of %s\n",
 				       __func__, tbl->rate,
 				       __clk_get_name(clk));
@@ -228,7 +228,7 @@ void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
 			}
 
 		if (tbl->state)
-			if (clk_prepare_enable(clk)) {
+			if (clk_prepare_enable(clk_core_to_clk(clk))) {
 				pr_err("%s: Failed to enable %s\n", __func__,
 				       __clk_get_name(clk));
 				WARN_ON(1);
@@ -279,7 +279,7 @@ void __init tegra_register_devclks(struct tegra_devclk *dev_clks, int num)
 				dev_clks->dev_id);
 }
 
-struct clk ** __init tegra_lookup_dt_id(int clk_id,
+struct clk_core ** __init tegra_lookup_dt_id(int clk_id,
 					struct tegra_clk *tegra_clk)
 {
 	if (tegra_clk[clk_id].present)
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 16ec8d6..3093aa4 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -39,7 +39,7 @@ struct tegra_clk_sync_source {
 extern const struct clk_ops tegra_clk_sync_source_ops;
 extern int *periph_clk_enb_refcnt;
 
-struct clk *tegra_clk_register_sync_source(const char *name,
+struct clk_core *tegra_clk_register_sync_source(const char *name,
 		unsigned long fixed_rate, unsigned long max_rate);
 
 /**
@@ -82,7 +82,7 @@ struct tegra_clk_frac_div {
 #define TEGRA_DIVIDER_UART BIT(3)
 
 extern const struct clk_ops tegra_clk_frac_div_ops;
-struct clk *tegra_clk_register_divider(const char *name,
+struct clk_core *tegra_clk_register_divider(const char *name,
 		const char *parent_name, void __iomem *reg,
 		unsigned long flags, u8 clk_divider_flags, u8 shift, u8 width,
 		u8 frac_width, spinlock_t *lock);
@@ -258,47 +258,47 @@ struct tegra_clk_pll {
 
 extern const struct clk_ops tegra_clk_pll_ops;
 extern const struct clk_ops tegra_clk_plle_ops;
-struct clk *tegra_clk_register_pll(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_pll(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
 		unsigned long flags, struct tegra_clk_pll_params *pll_params,
 		spinlock_t *lock);
 
-struct clk *tegra_clk_register_plle(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_plle(const char *name, const char *parent_name,
 		void __iomem *clk_base, void __iomem *pmc,
 		unsigned long flags, struct tegra_clk_pll_params *pll_params,
 		spinlock_t *lock);
 
-struct clk *tegra_clk_register_pllxc(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_pllxc(const char *name, const char *parent_name,
 			    void __iomem *clk_base, void __iomem *pmc,
 			    unsigned long flags,
 			    struct tegra_clk_pll_params *pll_params,
 			    spinlock_t *lock);
 
-struct clk *tegra_clk_register_pllm(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_pllm(const char *name, const char *parent_name,
 			   void __iomem *clk_base, void __iomem *pmc,
 			   unsigned long flags,
 			   struct tegra_clk_pll_params *pll_params,
 			   spinlock_t *lock);
 
-struct clk *tegra_clk_register_pllc(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_pllc(const char *name, const char *parent_name,
 			   void __iomem *clk_base, void __iomem *pmc,
 			   unsigned long flags,
 			   struct tegra_clk_pll_params *pll_params,
 			   spinlock_t *lock);
 
-struct clk *tegra_clk_register_pllre(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_pllre(const char *name, const char *parent_name,
 			   void __iomem *clk_base, void __iomem *pmc,
 			   unsigned long flags,
 			   struct tegra_clk_pll_params *pll_params,
 			   spinlock_t *lock, unsigned long parent_rate);
 
-struct clk *tegra_clk_register_plle_tegra114(const char *name,
+struct clk_core *tegra_clk_register_plle_tegra114(const char *name,
 				const char *parent_name,
 				void __iomem *clk_base, unsigned long flags,
 				struct tegra_clk_pll_params *pll_params,
 				spinlock_t *lock);
 
-struct clk *tegra_clk_register_pllss(const char *name, const char *parent_name,
+struct clk_core *tegra_clk_register_pllss(const char *name, const char *parent_name,
 			   void __iomem *clk_base, unsigned long flags,
 			   struct tegra_clk_pll_params *pll_params,
 			   spinlock_t *lock);
@@ -325,7 +325,7 @@ struct tegra_clk_pll_out {
 #define to_clk_pll_out(_hw) container_of(_hw, struct tegra_clk_pll_out, hw)
 
 extern const struct clk_ops tegra_clk_pll_out_ops;
-struct clk *tegra_clk_register_pll_out(const char *name,
+struct clk_core *tegra_clk_register_pll_out(const char *name,
 		const char *parent_name, void __iomem *reg, u8 enb_bit_idx,
 		u8 rst_bit_idx, unsigned long flags, u8 pll_div_flags,
 		spinlock_t *lock);
@@ -394,7 +394,7 @@ struct tegra_clk_periph_gate {
 #define TEGRA_PERIPH_NO_GATE BIT(5)
 
 extern const struct clk_ops tegra_clk_periph_gate_ops;
-struct clk *tegra_clk_register_periph_gate(const char *name,
+struct clk_core *tegra_clk_register_periph_gate(const char *name,
 		const char *parent_name, u8 gate_flags, void __iomem *clk_base,
 		unsigned long flags, int clk_num, int *enable_refcnt);
 
@@ -427,11 +427,11 @@ struct tegra_clk_periph {
 #define TEGRA_CLK_PERIPH_MAGIC 0x18221223
 
 extern const struct clk_ops tegra_clk_periph_ops;
-struct clk *tegra_clk_register_periph(const char *name,
+struct clk_core *tegra_clk_register_periph(const char *name,
 		const char **parent_names, int num_parents,
 		struct tegra_clk_periph *periph, void __iomem *clk_base,
 		u32 offset, unsigned long flags);
-struct clk *tegra_clk_register_periph_nodiv(const char *name,
+struct clk_core *tegra_clk_register_periph_nodiv(const char *name,
 		const char **parent_names, int num_parents,
 		struct tegra_clk_periph *periph, void __iomem *clk_base,
 		u32 offset);
@@ -540,7 +540,7 @@ struct tegra_clk_super_mux {
 #define TEGRA_DIVIDER_2 BIT(0)
 
 extern const struct clk_ops tegra_clk_super_ops;
-struct clk *tegra_clk_register_super_mux(const char *name,
+struct clk_core *tegra_clk_register_super_mux(const char *name,
 		const char **parent_names, u8 num_parents,
 		unsigned long flags, void __iomem *reg, u8 clk_super_flags,
 		u8 width, u8 pllx_index, u8 div2_index, spinlock_t *lock);
@@ -590,15 +590,15 @@ struct tegra_devclk {
 };
 
 void tegra_init_from_table(struct tegra_clk_init_table *tbl,
-		struct clk *clks[], int clk_max);
+		struct clk_core *clks[], int clk_max);
 
 void tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
-		struct clk *clks[], int clk_max);
+		struct clk_core *clks[], int clk_max);
 
 struct tegra_clk_periph_regs *get_reg_bank(int clkid);
-struct clk **tegra_clk_init(void __iomem *clk_base, int num, int periph_banks);
+struct clk_core **tegra_clk_init(void __iomem *clk_base, int num, int periph_banks);
 
-struct clk **tegra_lookup_dt_id(int clk_id, struct tegra_clk *tegra_clk);
+struct clk_core **tegra_lookup_dt_id(int clk_id, struct tegra_clk *tegra_clk);
 
 void tegra_add_of_provider(struct device_node *np);
 void tegra_register_devclks(struct tegra_devclk *dev_clks, int num);
diff --git a/drivers/clk/ti/apll.c b/drivers/clk/ti/apll.c
index 5428c9c..8f9b83c 100644
--- a/drivers/clk/ti/apll.c
+++ b/drivers/clk/ti/apll.c
@@ -137,10 +137,10 @@ static void __init omap_clk_register_apll(struct clk_hw *hw,
 {
 	struct clk_hw_omap *clk_hw = to_clk_hw_omap(hw);
 	struct dpll_data *ad = clk_hw->dpll_data;
-	struct clk *clk;
+	struct clk_core *clk;
 
-	ad->clk_ref = of_clk_get(node, 0);
-	ad->clk_bypass = of_clk_get(node, 1);
+	ad->clk_ref = of_clk_provider_get(node, 0);
+	ad->clk_bypass = of_clk_provider_get(node, 1);
 
 	if (IS_ERR(ad->clk_ref) || IS_ERR(ad->clk_bypass)) {
 		pr_debug("clk-ref or clk-bypass for %s not ready, retry\n",
@@ -334,7 +334,7 @@ static void __init of_omap2_apll_setup(struct device_node *node)
 	struct dpll_data *ad = NULL;
 	struct clk_hw_omap *clk_hw = NULL;
 	struct clk_init_data *init = NULL;
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name;
 	u32 val;
 
diff --git a/drivers/clk/ti/clk-2xxx.c b/drivers/clk/ti/clk-2xxx.c
index c808ab3..a48fe6f 100644
--- a/drivers/clk/ti/clk-2xxx.c
+++ b/drivers/clk/ti/clk-2xxx.c
@@ -237,10 +237,10 @@ static int __init omap2xxx_dt_clk_init(int soc_type)
 				     ARRAY_SIZE(enable_init_clks));
 
 	pr_info("Clocking rate (Crystal/DPLL/MPU): %ld.%01ld/%ld/%ld MHz\n",
-		(clk_get_rate(clk_get_sys(NULL, "sys_ck")) / 1000000),
-		(clk_get_rate(clk_get_sys(NULL, "sys_ck")) / 100000) % 10,
-		(clk_get_rate(clk_get_sys(NULL, "dpll_ck")) / 1000000),
-		(clk_get_rate(clk_get_sys(NULL, "mpu_ck")) / 1000000));
+		(clk_provider_get_rate(clk_provider_get_sys(NULL, "sys_ck")) / 1000000),
+		(clk_provider_get_rate(clk_provider_get_sys(NULL, "sys_ck")) / 100000) % 10,
+		(clk_provider_get_rate(clk_provider_get_sys(NULL, "dpll_ck")) / 1000000),
+		(clk_provider_get_rate(clk_provider_get_sys(NULL, "mpu_ck")) / 1000000));
 
 	return 0;
 }
diff --git a/drivers/clk/ti/clk-33xx.c b/drivers/clk/ti/clk-33xx.c
index 028b337..0988f1e 100644
--- a/drivers/clk/ti/clk-33xx.c
+++ b/drivers/clk/ti/clk-33xx.c
@@ -121,7 +121,7 @@ static const char *enable_init_clks[] = {
 
 int __init am33xx_dt_clk_init(void)
 {
-	struct clk *clk1, *clk2;
+	struct clk_core *clk1, *clk2;
 
 	ti_dt_clocks_register(am33xx_clks);
 
@@ -139,12 +139,12 @@ int __init am33xx_dt_clk_init(void)
 	 *    oscillator clock.
 	 */
 
-	clk1 = clk_get_sys(NULL, "sys_clkin_ck");
-	clk2 = clk_get_sys(NULL, "timer3_fck");
-	clk_set_parent(clk2, clk1);
+	clk1 = clk_provider_get_sys(NULL, "sys_clkin_ck");
+	clk2 = clk_provider_get_sys(NULL, "timer3_fck");
+	clk_provider_set_parent(clk2, clk1);
 
-	clk2 = clk_get_sys(NULL, "timer6_fck");
-	clk_set_parent(clk2, clk1);
+	clk2 = clk_provider_get_sys(NULL, "timer6_fck");
+	clk_provider_set_parent(clk2, clk1);
 	/*
 	 * The On-Chip 32K RC Osc clock is not an accurate clock-source as per
 	 * the design/spec, so as a result, for example, timer which supposed
@@ -152,9 +152,9 @@ int __init am33xx_dt_clk_init(void)
 	 * not expected by any use-case, so change WDT1 clock source to PRCM
 	 * 32KHz clock.
 	 */
-	clk1 = clk_get_sys(NULL, "wdt1_fck");
-	clk2 = clk_get_sys(NULL, "clkdiv32k_ick");
-	clk_set_parent(clk1, clk2);
+	clk1 = clk_provider_get_sys(NULL, "wdt1_fck");
+	clk2 = clk_provider_get_sys(NULL, "clkdiv32k_ick");
+	clk_provider_set_parent(clk1, clk2);
 
 	return 0;
 }
diff --git a/drivers/clk/ti/clk-3xxx.c b/drivers/clk/ti/clk-3xxx.c
index 0d1750a..58ef20e 100644
--- a/drivers/clk/ti/clk-3xxx.c
+++ b/drivers/clk/ti/clk-3xxx.c
@@ -365,10 +365,10 @@ static int __init omap3xxx_dt_clk_init(int soc_type)
 				     ARRAY_SIZE(enable_init_clks));
 
 	pr_info("Clocking rate (Crystal/Core/MPU): %ld.%01ld/%ld/%ld MHz\n",
-		(clk_get_rate(clk_get_sys(NULL, "osc_sys_ck")) / 1000000),
-		(clk_get_rate(clk_get_sys(NULL, "osc_sys_ck")) / 100000) % 10,
-		(clk_get_rate(clk_get_sys(NULL, "core_ck")) / 1000000),
-		(clk_get_rate(clk_get_sys(NULL, "arm_fck")) / 1000000));
+		(clk_provider_get_rate(clk_provider_get_sys(NULL, "osc_sys_ck")) / 1000000),
+		(clk_provider_get_rate(clk_provider_get_sys(NULL, "osc_sys_ck")) / 100000) % 10,
+		(clk_provider_get_rate(clk_provider_get_sys(NULL, "core_ck")) / 1000000),
+		(clk_provider_get_rate(clk_provider_get_sys(NULL, "arm_fck")) / 1000000));
 
 	if (soc_type != OMAP3_SOC_TI81XX && soc_type != OMAP3_SOC_OMAP3430_ES1)
 		omap3_clk_lock_dpll5();
diff --git a/drivers/clk/ti/clk-43xx.c b/drivers/clk/ti/clk-43xx.c
index 3795fce..1277452 100644
--- a/drivers/clk/ti/clk-43xx.c
+++ b/drivers/clk/ti/clk-43xx.c
@@ -116,7 +116,7 @@ static struct ti_dt_clk am43xx_clks[] = {
 
 int __init am43xx_dt_clk_init(void)
 {
-	struct clk *clk1, *clk2;
+	struct clk_core *clk1, *clk2;
 
 	ti_dt_clocks_register(am43xx_clks);
 
@@ -132,9 +132,9 @@ int __init am43xx_dt_clk_init(void)
 	 * By selecting dpll_core_m5_ck as the clocksource fixes this issue.
 	 * In AM335x dpll_core_m5_ck is the default clocksource.
 	 */
-	clk1 = clk_get_sys(NULL, "cpsw_cpts_rft_clk");
-	clk2 = clk_get_sys(NULL, "dpll_core_m5_ck");
-	clk_set_parent(clk1, clk2);
+	clk1 = clk_provider_get_sys(NULL, "cpsw_cpts_rft_clk");
+	clk2 = clk_provider_get_sys(NULL, "dpll_core_m5_ck");
+	clk_provider_set_parent(clk1, clk2);
 
 	return 0;
 }
diff --git a/drivers/clk/ti/clk-44xx.c b/drivers/clk/ti/clk-44xx.c
index 02517a8..1adc399 100644
--- a/drivers/clk/ti/clk-44xx.c
+++ b/drivers/clk/ti/clk-44xx.c
@@ -281,7 +281,7 @@ static struct ti_dt_clk omap44xx_clks[] = {
 int __init omap4xxx_dt_clk_init(void)
 {
 	int rc;
-	struct clk *abe_dpll_ref, *abe_dpll, *sys_32k_ck, *usb_dpll;
+	struct clk_core *abe_dpll_ref, *abe_dpll, *sys_32k_ck, *usb_dpll;
 
 	ti_dt_clocks_register(omap44xx_clks);
 
@@ -291,8 +291,8 @@ int __init omap4xxx_dt_clk_init(void)
 	 * Lock USB DPLL on OMAP4 devices so that the L3INIT power
 	 * domain can transition to retention state when not in use.
 	 */
-	usb_dpll = clk_get_sys(NULL, "dpll_usb_ck");
-	rc = clk_set_rate(usb_dpll, OMAP4_DPLL_USB_DEFFREQ);
+	usb_dpll = clk_provider_get_sys(NULL, "dpll_usb_ck");
+	rc = clk_provider_set_rate(usb_dpll, OMAP4_DPLL_USB_DEFFREQ);
 	if (rc)
 		pr_err("%s: failed to configure USB DPLL!\n", __func__);
 
@@ -302,12 +302,12 @@ int __init omap4xxx_dt_clk_init(void)
 	 * locking the ABE DPLL on boot.
 	 * Lock the ABE DPLL in any case to avoid issues with audio.
 	 */
-	abe_dpll_ref = clk_get_sys(NULL, "abe_dpll_refclk_mux_ck");
-	sys_32k_ck = clk_get_sys(NULL, "sys_32k_ck");
-	rc = clk_set_parent(abe_dpll_ref, sys_32k_ck);
-	abe_dpll = clk_get_sys(NULL, "dpll_abe_ck");
+	abe_dpll_ref = clk_provider_get_sys(NULL, "abe_dpll_refclk_mux_ck");
+	sys_32k_ck = clk_provider_get_sys(NULL, "sys_32k_ck");
+	rc = clk_provider_set_parent(abe_dpll_ref, sys_32k_ck);
+	abe_dpll = clk_provider_get_sys(NULL, "dpll_abe_ck");
 	if (!rc)
-		rc = clk_set_rate(abe_dpll, OMAP4_DPLL_ABE_DEFFREQ);
+		rc = clk_provider_set_rate(abe_dpll, OMAP4_DPLL_ABE_DEFFREQ);
 	if (rc)
 		pr_err("%s: failed to configure ABE DPLL!\n", __func__);
 
diff --git a/drivers/clk/ti/clk-54xx.c b/drivers/clk/ti/clk-54xx.c
index 5e18399..5b603b5 100644
--- a/drivers/clk/ti/clk-54xx.c
+++ b/drivers/clk/ti/clk-54xx.c
@@ -225,34 +225,35 @@ static struct ti_dt_clk omap54xx_clks[] = {
 int __init omap5xxx_dt_clk_init(void)
 {
 	int rc;
-	struct clk *abe_dpll_ref, *abe_dpll, *sys_32k_ck, *usb_dpll;
+	struct clk_core *abe_dpll_ref, *abe_dpll, *sys_32k_ck, *usb_dpll;
 
 	ti_dt_clocks_register(omap54xx_clks);
 
 	omap2_clk_disable_autoidle_all();
 
-	abe_dpll_ref = clk_get_sys(NULL, "abe_dpll_clk_mux");
-	sys_32k_ck = clk_get_sys(NULL, "sys_32k_ck");
-	rc = clk_set_parent(abe_dpll_ref, sys_32k_ck);
-	abe_dpll = clk_get_sys(NULL, "dpll_abe_ck");
+	abe_dpll_ref = clk_provider_get_sys(NULL, "abe_dpll_clk_mux");
+	sys_32k_ck = clk_provider_get_sys(NULL, "sys_32k_ck");
+	rc = clk_provider_set_parent(abe_dpll_ref, sys_32k_ck);
+	abe_dpll = clk_provider_get_sys(NULL, "dpll_abe_ck");
 	if (!rc)
-		rc = clk_set_rate(abe_dpll, OMAP5_DPLL_ABE_DEFFREQ);
+		rc = clk_provider_set_rate(abe_dpll, OMAP5_DPLL_ABE_DEFFREQ);
 	if (rc)
 		pr_err("%s: failed to configure ABE DPLL!\n", __func__);
 
-	abe_dpll = clk_get_sys(NULL, "dpll_abe_m2x2_ck");
+	abe_dpll = clk_provider_get_sys(NULL, "dpll_abe_m2x2_ck");
 	if (!rc)
-		rc = clk_set_rate(abe_dpll, OMAP5_DPLL_ABE_DEFFREQ * 2);
+		rc = clk_provider_set_rate(abe_dpll,
+					   OMAP5_DPLL_ABE_DEFFREQ * 2);
 	if (rc)
 		pr_err("%s: failed to configure ABE m2x2 DPLL!\n", __func__);
 
-	usb_dpll = clk_get_sys(NULL, "dpll_usb_ck");
-	rc = clk_set_rate(usb_dpll, OMAP5_DPLL_USB_DEFFREQ);
+	usb_dpll = clk_provider_get_sys(NULL, "dpll_usb_ck");
+	rc = clk_provider_set_rate(usb_dpll, OMAP5_DPLL_USB_DEFFREQ);
 	if (rc)
 		pr_err("%s: failed to configure USB DPLL!\n", __func__);
 
-	usb_dpll = clk_get_sys(NULL, "dpll_usb_m2_ck");
-	rc = clk_set_rate(usb_dpll, OMAP5_DPLL_USB_DEFFREQ/2);
+	usb_dpll = clk_provider_get_sys(NULL, "dpll_usb_m2_ck");
+	rc = clk_provider_set_rate(usb_dpll, OMAP5_DPLL_USB_DEFFREQ / 2);
 	if (rc)
 		pr_err("%s: failed to set USB_DPLL M2 OUT\n", __func__);
 
diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
index e158133..02e5598 100644
--- a/drivers/clk/ti/clk-7xx.c
+++ b/drivers/clk/ti/clk-7xx.c
@@ -306,24 +306,24 @@ static struct ti_dt_clk dra7xx_clks[] = {
 int __init dra7xx_dt_clk_init(void)
 {
 	int rc;
-	struct clk *abe_dpll_mux, *sys_clkin2, *dpll_ck;
+	struct clk_core *abe_dpll_mux, *sys_clkin2, *dpll_ck;
 
 	ti_dt_clocks_register(dra7xx_clks);
 
 	omap2_clk_disable_autoidle_all();
 
-	abe_dpll_mux = clk_get_sys(NULL, "abe_dpll_sys_clk_mux");
-	sys_clkin2 = clk_get_sys(NULL, "sys_clkin2");
-	dpll_ck = clk_get_sys(NULL, "dpll_abe_ck");
+	abe_dpll_mux = clk_provider_get_sys(NULL, "abe_dpll_sys_clk_mux");
+	sys_clkin2 = clk_provider_get_sys(NULL, "sys_clkin2");
+	dpll_ck = clk_provider_get_sys(NULL, "dpll_abe_ck");
 
-	rc = clk_set_parent(abe_dpll_mux, sys_clkin2);
+	rc = clk_provider_set_parent(abe_dpll_mux, sys_clkin2);
 	if (!rc)
-		rc = clk_set_rate(dpll_ck, DRA7_DPLL_ABE_DEFFREQ);
+		rc = clk_provider_set_rate(dpll_ck, DRA7_DPLL_ABE_DEFFREQ);
 	if (rc)
 		pr_err("%s: failed to configure ABE DPLL!\n", __func__);
 
-	dpll_ck = clk_get_sys(NULL, "dpll_gmac_ck");
-	rc = clk_set_rate(dpll_ck, DRA7_DPLL_GMAC_DEFFREQ);
+	dpll_ck = clk_provider_get_sys(NULL, "dpll_gmac_ck");
+	rc = clk_provider_set_rate(dpll_ck, DRA7_DPLL_GMAC_DEFFREQ);
 	if (rc)
 		pr_err("%s: failed to configure GMAC DPLL!\n", __func__);
 
diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
index 4a65b41..029a0d3 100644
--- a/drivers/clk/ti/clk-dra7-atl.c
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -40,7 +40,7 @@
 struct dra7_atl_clock_info;
 
 struct dra7_atl_desc {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_hw hw;
 	struct dra7_atl_clock_info *cinfo;
 	int id;
@@ -165,7 +165,7 @@ static void __init of_dra7_atl_clock_setup(struct device_node *node)
 	struct dra7_atl_desc *clk_hw = NULL;
 	struct clk_init_data init = { 0 };
 	const char **parent_names = NULL;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk_hw = kzalloc(sizeof(*clk_hw), GFP_KERNEL);
 	if (!clk_hw) {
@@ -233,7 +233,7 @@ static int of_dra7_atl_clk_probe(struct platform_device *pdev)
 		char prop[5];
 		struct dra7_atl_desc *cdesc;
 		struct of_phandle_args clkspec;
-		struct clk *clk;
+		struct clk_core *clk;
 		int rc;
 
 		rc = of_parse_phandle_with_args(node, "ti,provided-clocks",
diff --git a/drivers/clk/ti/clk.c b/drivers/clk/ti/clk.c
index b1a6f71..d88a70d0 100644
--- a/drivers/clk/ti/clk.c
+++ b/drivers/clk/ti/clk.c
@@ -41,7 +41,7 @@ void __init ti_dt_clocks_register(struct ti_dt_clk oclks[])
 {
 	struct ti_dt_clk *c;
 	struct device_node *node;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct of_phandle_args clkspec;
 
 	for (c = oclks; c->node_name != NULL; c++) {
diff --git a/drivers/clk/ti/clockdomain.c b/drivers/clk/ti/clockdomain.c
index f1e0038..6bc75d8 100644
--- a/drivers/clk/ti/clockdomain.c
+++ b/drivers/clk/ti/clockdomain.c
@@ -26,7 +26,7 @@
 
 static void __init of_ti_clockdomain_setup(struct device_node *node)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_hw *clk_hw;
 	const char *clkdm_name = node->name;
 	int i;
@@ -35,7 +35,7 @@ static void __init of_ti_clockdomain_setup(struct device_node *node)
 	num_clks = of_count_phandle_with_args(node, "clocks", "#clock-cells");
 
 	for (i = 0; i < num_clks; i++) {
-		clk = of_clk_get(node, i);
+		clk = of_clk_provider_get(node, i);
 		if (__clk_get_flags(clk) & CLK_IS_BASIC) {
 			pr_warn("can't setup clkdm for basic clk %s\n",
 				__clk_get_name(clk));
diff --git a/drivers/clk/ti/composite.c b/drivers/clk/ti/composite.c
index 19d8980..2cbee34 100644
--- a/drivers/clk/ti/composite.c
+++ b/drivers/clk/ti/composite.c
@@ -119,7 +119,7 @@ static inline struct clk_hw *_get_hw(struct clk_hw_omap_comp *clk, int idx)
 static void __init ti_clk_register_composite(struct clk_hw *hw,
 					     struct device_node *node)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_hw_omap_comp *cclk = to_clk_hw_comp(hw);
 	struct component_clk *comp;
 	int num_parents = 0;
diff --git a/drivers/clk/ti/divider.c b/drivers/clk/ti/divider.c
index e6aa10d..1c41515 100644
--- a/drivers/clk/ti/divider.c
+++ b/drivers/clk/ti/divider.c
@@ -246,7 +246,7 @@ const struct clk_ops ti_clk_divider_ops = {
 	.set_rate = ti_clk_divider_set_rate,
 };
 
-static struct clk *_register_divider(struct device *dev, const char *name,
+static struct clk_core *_register_divider(struct device *dev, const char *name,
 				     const char *parent_name,
 				     unsigned long flags, void __iomem *reg,
 				     u8 shift, u8 width, u8 clk_divider_flags,
@@ -254,7 +254,7 @@ static struct clk *_register_divider(struct device *dev, const char *name,
 				     spinlock_t *lock)
 {
 	struct clk_divider *div;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	if (clk_divider_flags & CLK_DIVIDER_HIWORD_MASK) {
@@ -434,7 +434,7 @@ static int __init ti_clk_divider_populate(struct device_node *node,
  */
 static void __init of_ti_divider_clk_setup(struct device_node *node)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *parent_name;
 	void __iomem *reg;
 	u8 clk_divider_flags = 0;
diff --git a/drivers/clk/ti/dpll.c b/drivers/clk/ti/dpll.c
index abd956d..d7b1d4c 100644
--- a/drivers/clk/ti/dpll.c
+++ b/drivers/clk/ti/dpll.c
@@ -128,10 +128,10 @@ static void __init ti_clk_register_dpll(struct clk_hw *hw,
 {
 	struct clk_hw_omap *clk_hw = to_clk_hw_omap(hw);
 	struct dpll_data *dd = clk_hw->dpll_data;
-	struct clk *clk;
+	struct clk_core *clk;
 
-	dd->clk_ref = of_clk_get(node, 0);
-	dd->clk_bypass = of_clk_get(node, 1);
+	dd->clk_ref = of_clk_provider_get(node, 0);
+	dd->clk_bypass = of_clk_provider_get(node, 1);
 
 	if (IS_ERR(dd->clk_ref) || IS_ERR(dd->clk_bypass)) {
 		pr_debug("clk-ref or clk-bypass missing for %s, retry later\n",
@@ -174,7 +174,7 @@ static void ti_clk_register_dpll_x2(struct device_node *node,
 				    const struct clk_ops *ops,
 				    const struct clk_hw_omap_ops *hw_ops)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init = { NULL };
 	struct clk_hw_omap *clk_hw;
 	const char *name = node->name;
diff --git a/drivers/clk/ti/fixed-factor.c b/drivers/clk/ti/fixed-factor.c
index c2c8a28..2aa2701 100644
--- a/drivers/clk/ti/fixed-factor.c
+++ b/drivers/clk/ti/fixed-factor.c
@@ -33,7 +33,7 @@
  */
 static void __init of_ti_fixed_factor_clk_setup(struct device_node *node)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	const char *clk_name = node->name;
 	const char *parent_name;
 	u32 div, mult;
diff --git a/drivers/clk/ti/gate.c b/drivers/clk/ti/gate.c
index b326d27..dd1b813 100644
--- a/drivers/clk/ti/gate.c
+++ b/drivers/clk/ti/gate.c
@@ -94,7 +94,7 @@ static void __init _of_ti_gate_clk_setup(struct device_node *node,
 					 const struct clk_ops *ops,
 					 const struct clk_hw_omap_ops *hw_ops)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init = { NULL };
 	struct clk_hw_omap *clk_hw;
 	const char *clk_name = node->name;
diff --git a/drivers/clk/ti/interface.c b/drivers/clk/ti/interface.c
index 9c3e8c4..e2f2bc0 100644
--- a/drivers/clk/ti/interface.c
+++ b/drivers/clk/ti/interface.c
@@ -34,7 +34,7 @@ static const struct clk_ops ti_interface_clk_ops = {
 static void __init _of_ti_interface_clk_setup(struct device_node *node,
 					      const struct clk_hw_omap_ops *ops)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init = { NULL };
 	struct clk_hw_omap *clk_hw;
 	const char *parent_name;
diff --git a/drivers/clk/ti/mux.c b/drivers/clk/ti/mux.c
index 0197a47..4290f27 100644
--- a/drivers/clk/ti/mux.c
+++ b/drivers/clk/ti/mux.c
@@ -104,14 +104,14 @@ const struct clk_ops ti_clk_mux_ops = {
 	.determine_rate = __clk_mux_determine_rate,
 };
 
-static struct clk *_register_mux(struct device *dev, const char *name,
+static struct clk_core *_register_mux(struct device *dev, const char *name,
 				 const char **parent_names, u8 num_parents,
 				 unsigned long flags, void __iomem *reg,
 				 u8 shift, u32 mask, u8 clk_mux_flags,
 				 u32 *table, spinlock_t *lock)
 {
 	struct clk_mux *mux;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_init_data init;
 
 	/* allocate the mux */
@@ -152,7 +152,7 @@ static struct clk *_register_mux(struct device *dev, const char *name,
  */
 static void of_mux_clk_setup(struct device_node *node)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	void __iomem *reg;
 	int num_parents;
 	const char **parent_names;
diff --git a/drivers/clk/ux500/abx500-clk.c b/drivers/clk/ux500/abx500-clk.c
index e7bd62c..dabb8e6 100644
--- a/drivers/clk/ux500/abx500-clk.c
+++ b/drivers/clk/ux500/abx500-clk.c
@@ -23,7 +23,7 @@
 static int ab8500_reg_clks(struct device *dev)
 {
 	int ret;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	const char *intclk_parents[] = {"ab8500_sysclk", "ulpclk"};
 	u16 intclk_reg_sel[] = {0 , AB8500_SYSULPCLKCTRL1};
diff --git a/drivers/clk/ux500/clk-prcc.c b/drivers/clk/ux500/clk-prcc.c
index bd4769a..7eb055f 100644
--- a/drivers/clk/ux500/clk-prcc.c
+++ b/drivers/clk/ux500/clk-prcc.c
@@ -92,7 +92,7 @@ static struct clk_ops clk_prcc_kclk_ops = {
 	.is_enabled = clk_prcc_is_enabled,
 };
 
-static struct clk *clk_reg_prcc(const char *name,
+static struct clk_core *clk_reg_prcc(const char *name,
 				const char *parent_name,
 				resource_size_t phy_base,
 				u32 cg_sel,
@@ -101,7 +101,7 @@ static struct clk *clk_reg_prcc(const char *name,
 {
 	struct clk_prcc *clk;
 	struct clk_init_data clk_prcc_init;
-	struct clk *clk_reg;
+	struct clk_core *clk_reg;
 
 	if (!name) {
 		pr_err("clk_prcc: %s invalid arguments passed\n", __func__);
@@ -142,7 +142,7 @@ free_clk:
 	return ERR_PTR(-ENOMEM);
 }
 
-struct clk *clk_reg_prcc_pclk(const char *name,
+struct clk_core *clk_reg_prcc_pclk(const char *name,
 			      const char *parent_name,
 			      resource_size_t phy_base,
 			      u32 cg_sel,
@@ -152,7 +152,7 @@ struct clk *clk_reg_prcc_pclk(const char *name,
 			&clk_prcc_pclk_ops);
 }
 
-struct clk *clk_reg_prcc_kclk(const char *name,
+struct clk_core *clk_reg_prcc_kclk(const char *name,
 			      const char *parent_name,
 			      resource_size_t phy_base,
 			      u32 cg_sel,
diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
index e2d63bc..bac54c9 100644
--- a/drivers/clk/ux500/clk-prcmu.c
+++ b/drivers/clk/ux500/clk-prcmu.c
@@ -243,7 +243,7 @@ static struct clk_ops clk_prcmu_opp_volt_scalable_ops = {
 	.set_rate = clk_prcmu_set_rate,
 };
 
-static struct clk *clk_reg_prcmu(const char *name,
+static struct clk_core *clk_reg_prcmu(const char *name,
 				 const char *parent_name,
 				 u8 cg_sel,
 				 unsigned long rate,
@@ -252,7 +252,7 @@ static struct clk *clk_reg_prcmu(const char *name,
 {
 	struct clk_prcmu *clk;
 	struct clk_init_data clk_prcmu_init;
-	struct clk *clk_reg;
+	struct clk_core *clk_reg;
 
 	if (!name) {
 		pr_err("clk_prcmu: %s invalid arguments passed\n", __func__);
@@ -292,7 +292,7 @@ free_clk:
 	return ERR_PTR(-ENOMEM);
 }
 
-struct clk *clk_reg_prcmu_scalable(const char *name,
+struct clk_core *clk_reg_prcmu_scalable(const char *name,
 				   const char *parent_name,
 				   u8 cg_sel,
 				   unsigned long rate,
@@ -302,7 +302,7 @@ struct clk *clk_reg_prcmu_scalable(const char *name,
 			&clk_prcmu_scalable_ops);
 }
 
-struct clk *clk_reg_prcmu_gate(const char *name,
+struct clk_core *clk_reg_prcmu_gate(const char *name,
 			       const char *parent_name,
 			       u8 cg_sel,
 			       unsigned long flags)
@@ -311,7 +311,7 @@ struct clk *clk_reg_prcmu_gate(const char *name,
 			&clk_prcmu_gate_ops);
 }
 
-struct clk *clk_reg_prcmu_scalable_rate(const char *name,
+struct clk_core *clk_reg_prcmu_scalable_rate(const char *name,
 					const char *parent_name,
 					u8 cg_sel,
 					unsigned long rate,
@@ -321,7 +321,7 @@ struct clk *clk_reg_prcmu_scalable_rate(const char *name,
 			&clk_prcmu_scalable_rate_ops);
 }
 
-struct clk *clk_reg_prcmu_rate(const char *name,
+struct clk_core *clk_reg_prcmu_rate(const char *name,
 			       const char *parent_name,
 			       u8 cg_sel,
 			       unsigned long flags)
@@ -330,7 +330,7 @@ struct clk *clk_reg_prcmu_rate(const char *name,
 			&clk_prcmu_rate_ops);
 }
 
-struct clk *clk_reg_prcmu_opp_gate(const char *name,
+struct clk_core *clk_reg_prcmu_opp_gate(const char *name,
 				   const char *parent_name,
 				   u8 cg_sel,
 				   unsigned long flags)
@@ -339,7 +339,7 @@ struct clk *clk_reg_prcmu_opp_gate(const char *name,
 			&clk_prcmu_opp_gate_ops);
 }
 
-struct clk *clk_reg_prcmu_opp_volt_scalable(const char *name,
+struct clk_core *clk_reg_prcmu_opp_volt_scalable(const char *name,
 					    const char *parent_name,
 					    u8 cg_sel,
 					    unsigned long rate,
diff --git a/drivers/clk/ux500/clk-sysctrl.c b/drivers/clk/ux500/clk-sysctrl.c
index e364c9d..dc6608a 100644
--- a/drivers/clk/ux500/clk-sysctrl.c
+++ b/drivers/clk/ux500/clk-sysctrl.c
@@ -114,7 +114,7 @@ static struct clk_ops clk_sysctrl_set_parent_ops = {
 	.get_parent = clk_sysctrl_get_parent,
 };
 
-static struct clk *clk_reg_sysctrl(struct device *dev,
+static struct clk_core *clk_reg_sysctrl(struct device *dev,
 				const char *name,
 				const char **parent_names,
 				u8 num_parents,
@@ -128,7 +128,7 @@ static struct clk *clk_reg_sysctrl(struct device *dev,
 {
 	struct clk_sysctrl *clk;
 	struct clk_init_data clk_sysctrl_init;
-	struct clk *clk_reg;
+	struct clk_core *clk_reg;
 	int i;
 
 	if (!dev)
@@ -176,7 +176,7 @@ static struct clk *clk_reg_sysctrl(struct device *dev,
 	return clk_reg;
 }
 
-struct clk *clk_reg_sysctrl_gate(struct device *dev,
+struct clk_core *clk_reg_sysctrl_gate(struct device *dev,
 				const char *name,
 				const char *parent_name,
 				u16 reg_sel,
@@ -193,7 +193,7 @@ struct clk *clk_reg_sysctrl_gate(struct device *dev,
 			flags, &clk_sysctrl_gate_ops);
 }
 
-struct clk *clk_reg_sysctrl_gate_fixed_rate(struct device *dev,
+struct clk_core *clk_reg_sysctrl_gate_fixed_rate(struct device *dev,
 					const char *name,
 					const char *parent_name,
 					u16 reg_sel,
@@ -212,7 +212,7 @@ struct clk *clk_reg_sysctrl_gate_fixed_rate(struct device *dev,
 			&clk_sysctrl_gate_fixed_rate_ops);
 }
 
-struct clk *clk_reg_sysctrl_set_parent(struct device *dev,
+struct clk_core *clk_reg_sysctrl_set_parent(struct device *dev,
 				const char *name,
 				const char **parent_names,
 				u8 num_parents,
diff --git a/drivers/clk/ux500/clk.h b/drivers/clk/ux500/clk.h
index a2bb92d..da40a2d 100644
--- a/drivers/clk/ux500/clk.h
+++ b/drivers/clk/ux500/clk.h
@@ -14,52 +14,52 @@
 #include <linux/device.h>
 #include <linux/types.h>
 
-struct clk *clk_reg_prcc_pclk(const char *name,
+struct clk_core *clk_reg_prcc_pclk(const char *name,
 			      const char *parent_name,
 			      resource_size_t phy_base,
 			      u32 cg_sel,
 			      unsigned long flags);
 
-struct clk *clk_reg_prcc_kclk(const char *name,
+struct clk_core *clk_reg_prcc_kclk(const char *name,
 			      const char *parent_name,
 			      resource_size_t phy_base,
 			      u32 cg_sel,
 			      unsigned long flags);
 
-struct clk *clk_reg_prcmu_scalable(const char *name,
+struct clk_core *clk_reg_prcmu_scalable(const char *name,
 				   const char *parent_name,
 				   u8 cg_sel,
 				   unsigned long rate,
 				   unsigned long flags);
 
-struct clk *clk_reg_prcmu_gate(const char *name,
+struct clk_core *clk_reg_prcmu_gate(const char *name,
 			       const char *parent_name,
 			       u8 cg_sel,
 			       unsigned long flags);
 
-struct clk *clk_reg_prcmu_scalable_rate(const char *name,
+struct clk_core *clk_reg_prcmu_scalable_rate(const char *name,
 					const char *parent_name,
 					u8 cg_sel,
 					unsigned long rate,
 					unsigned long flags);
 
-struct clk *clk_reg_prcmu_rate(const char *name,
+struct clk_core *clk_reg_prcmu_rate(const char *name,
 			       const char *parent_name,
 			       u8 cg_sel,
 			       unsigned long flags);
 
-struct clk *clk_reg_prcmu_opp_gate(const char *name,
+struct clk_core *clk_reg_prcmu_opp_gate(const char *name,
 				   const char *parent_name,
 				   u8 cg_sel,
 				   unsigned long flags);
 
-struct clk *clk_reg_prcmu_opp_volt_scalable(const char *name,
+struct clk_core *clk_reg_prcmu_opp_volt_scalable(const char *name,
 					    const char *parent_name,
 					    u8 cg_sel,
 					    unsigned long rate,
 					    unsigned long flags);
 
-struct clk *clk_reg_sysctrl_gate(struct device *dev,
+struct clk_core *clk_reg_sysctrl_gate(struct device *dev,
 				 const char *name,
 				 const char *parent_name,
 				 u16 reg_sel,
@@ -68,7 +68,7 @@ struct clk *clk_reg_sysctrl_gate(struct device *dev,
 				 unsigned long enable_delay_us,
 				 unsigned long flags);
 
-struct clk *clk_reg_sysctrl_gate_fixed_rate(struct device *dev,
+struct clk_core *clk_reg_sysctrl_gate_fixed_rate(struct device *dev,
 					    const char *name,
 					    const char *parent_name,
 					    u16 reg_sel,
@@ -78,7 +78,7 @@ struct clk *clk_reg_sysctrl_gate_fixed_rate(struct device *dev,
 					    unsigned long enable_delay_us,
 					    unsigned long flags);
 
-struct clk *clk_reg_sysctrl_set_parent(struct device *dev,
+struct clk_core *clk_reg_sysctrl_set_parent(struct device *dev,
 				       const char *name,
 				       const char **parent_names,
 				       u8 num_parents,
diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
index 80069c3..8a2b4bc 100644
--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -19,7 +19,7 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 {
 	struct prcmu_fw_version *fw_version;
 	const char *sgaclk_parent = NULL;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* Clock sources */
 	clk = clk_reg_prcmu_gate("soc0_pll", NULL, PRCMU_PLLSOC0,
diff --git a/drivers/clk/ux500/u8500_of_clk.c b/drivers/clk/ux500/u8500_of_clk.c
index 7b55ef8..afda303 100644
--- a/drivers/clk/ux500/u8500_of_clk.c
+++ b/drivers/clk/ux500/u8500_of_clk.c
@@ -18,9 +18,9 @@
 #define PRCC_NUM_PERIPH_CLUSTERS 6
 #define PRCC_PERIPHS_PER_CLUSTER 32
 
-static struct clk *prcmu_clk[PRCMU_NUM_CLKS];
-static struct clk *prcc_pclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
-static struct clk *prcc_kclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
+static struct clk_core *prcmu_clk[PRCMU_NUM_CLKS];
+static struct clk_core *prcc_pclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
+static struct clk_core *prcc_kclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_CLUSTER];
 
 #define PRCC_SHOW(clk, base, bit) \
 	clk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit]
@@ -29,10 +29,10 @@ static struct clk *prcc_kclk[(PRCC_NUM_PERIPH_CLUSTERS + 1) * PRCC_PERIPHS_PER_C
 #define PRCC_KCLK_STORE(clk, base, bit)        \
 	prcc_kclk[(base * PRCC_PERIPHS_PER_CLUSTER) + bit] = clk
 
-static struct clk *ux500_twocell_get(struct of_phandle_args *clkspec,
+static struct clk_core *ux500_twocell_get(struct of_phandle_args *clkspec,
 				     void *data)
 {
-	struct clk **clk_data = data;
+	struct clk_core **clk_data = data;
 	unsigned int base, bit;
 
 	if (clkspec->args_count != 2)
@@ -61,7 +61,7 @@ void u8500_of_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	struct device_node *np = NULL;
 	struct device_node *child = NULL;
 	const char *sgaclk_parent = NULL;
-	struct clk *clk, *rtc_clk, *twd_clk;
+	struct clk_core *clk, *rtc_clk, *twd_clk;
 
 	if (of_have_populated_dt())
 		np = of_find_matching_node(NULL, u8500_clk_of_match);
diff --git a/drivers/clk/ux500/u8540_clk.c b/drivers/clk/ux500/u8540_clk.c
index 20c8add..897daf6 100644
--- a/drivers/clk/ux500/u8540_clk.c
+++ b/drivers/clk/ux500/u8540_clk.c
@@ -17,7 +17,7 @@
 void u8540_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 		    u32 clkrst5_base, u32 clkrst6_base)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* Clock sources. */
 	/* Fixed ClockGen */
diff --git a/drivers/clk/versatile/clk-icst.c b/drivers/clk/versatile/clk-icst.c
index bc96f10..8df4acc 100644
--- a/drivers/clk/versatile/clk-icst.c
+++ b/drivers/clk/versatile/clk-icst.c
@@ -121,13 +121,13 @@ static const struct clk_ops icst_ops = {
 	.set_rate = icst_set_rate,
 };
 
-struct clk *icst_clk_register(struct device *dev,
+struct clk_core *icst_clk_register(struct device *dev,
 			const struct clk_icst_desc *desc,
 			const char *name,
 			const char *parent_name,
 			void __iomem *base)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_icst *icst;
 	struct clk_init_data init;
 	struct icst_params *pclone;
diff --git a/drivers/clk/versatile/clk-icst.h b/drivers/clk/versatile/clk-icst.h
index 04e6f0a..ede867b 100644
--- a/drivers/clk/versatile/clk-icst.h
+++ b/drivers/clk/versatile/clk-icst.h
@@ -13,7 +13,7 @@ struct clk_icst_desc {
 	u32 lock_offset;
 };
 
-struct clk *icst_clk_register(struct device *dev,
+struct clk_core *icst_clk_register(struct device *dev,
 			      const struct clk_icst_desc *desc,
 			      const char *name,
 			      const char *parent_name,
diff --git a/drivers/clk/versatile/clk-impd1.c b/drivers/clk/versatile/clk-impd1.c
index 1cc1330..6b35629 100644
--- a/drivers/clk/versatile/clk-impd1.c
+++ b/drivers/clk/versatile/clk-impd1.c
@@ -21,18 +21,18 @@
 
 struct impd1_clk {
 	char *pclkname;
-	struct clk *pclk;
+	struct clk_core *pclk;
 	char *vco1name;
-	struct clk *vco1clk;
+	struct clk_core *vco1clk;
 	char *vco2name;
-	struct clk *vco2clk;
-	struct clk *mmciclk;
+	struct clk_core *vco2clk;
+	struct clk_core *mmciclk;
 	char *uartname;
-	struct clk *uartclk;
+	struct clk_core *uartclk;
 	char *spiname;
-	struct clk *spiclk;
+	struct clk_core *spiclk;
 	char *scname;
-	struct clk *scclk;
+	struct clk_core *scclk;
 	struct clk_lookup *clks[15];
 };
 
@@ -87,8 +87,8 @@ static const struct clk_icst_desc impd1_icst2_desc = {
 void integrator_impd1_clk_init(void __iomem *base, unsigned int id)
 {
 	struct impd1_clk *imc;
-	struct clk *clk;
-	struct clk *pclk;
+	struct clk_core *clk;
+	struct clk_core *pclk;
 	int i;
 
 	if (id > 3) {
diff --git a/drivers/clk/versatile/clk-integrator.c b/drivers/clk/versatile/clk-integrator.c
index 734c4b8..dbcaa7b 100644
--- a/drivers/clk/versatile/clk-integrator.c
+++ b/drivers/clk/versatile/clk-integrator.c
@@ -39,7 +39,7 @@ static const struct clk_icst_desc __initdata cm_auxosc_desc = {
 
 static void __init of_integrator_cm_osc_setup(struct device_node *np)
 {
-	struct clk *clk = ERR_PTR(-EINVAL);
+	struct clk_core *clk = ERR_PTR(-EINVAL);
 	const char *clk_name = np->name;
 	const struct clk_icst_desc *desc = &cm_auxosc_desc;
 	const char *parent_name;
diff --git a/drivers/clk/versatile/clk-realview.c b/drivers/clk/versatile/clk-realview.c
index c8b5231..4fa61b3 100644
--- a/drivers/clk/versatile/clk-realview.c
+++ b/drivers/clk/versatile/clk-realview.c
@@ -50,7 +50,7 @@ static const struct clk_icst_desc __initdata realview_osc4_desc = {
  */
 void __init realview_clk_init(void __iomem *sysbase, bool is_pb1176)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	/* APB clock dummy */
 	clk = clk_register_fixed_rate(NULL, "apb_pclk", NULL, CLK_IS_ROOT, 0);
diff --git a/drivers/clk/versatile/clk-sp810.c b/drivers/clk/versatile/clk-sp810.c
index c6e86a9..9256d25 100644
--- a/drivers/clk/versatile/clk-sp810.c
+++ b/drivers/clk/versatile/clk-sp810.c
@@ -25,7 +25,7 @@ struct clk_sp810;
 
 struct clk_sp810_timerclken {
 	struct clk_hw hw;
-	struct clk *clk;
+	struct clk_core *clk;
 	struct clk_sp810 *sp810;
 	int channel;
 };
@@ -36,8 +36,8 @@ struct clk_sp810 {
 	void __iomem *base;
 	spinlock_t lock;
 	struct clk_sp810_timerclken timerclken[4];
-	struct clk *refclk;
-	struct clk *timclk;
+	struct clk_core *refclk;
+	struct clk_core *timclk;
 };
 
 static u8 clk_sp810_timerclken_get_parent(struct clk_hw *hw)
@@ -79,29 +79,31 @@ static int clk_sp810_timerclken_prepare(struct clk_hw *hw)
 {
 	struct clk_sp810_timerclken *timerclken = to_clk_sp810_timerclken(hw);
 	struct clk_sp810 *sp810 = timerclken->sp810;
-	struct clk *old_parent = __clk_get_parent(hw->clk);
-	struct clk *new_parent;
+	struct clk_core *old_parent = __clk_get_parent(hw->clk);
+	struct clk_core *new_parent;
 
 	if (!sp810->refclk)
-		sp810->refclk = of_clk_get(sp810->node, sp810->refclk_index);
+		sp810->refclk = of_clk_provider_get(sp810->node,
+						    sp810->refclk_index);
 
 	if (!sp810->timclk)
-		sp810->timclk = of_clk_get(sp810->node, sp810->timclk_index);
+		sp810->timclk = of_clk_provider_get(sp810->node,
+						    sp810->timclk_index);
 
 	if (WARN_ON(IS_ERR(sp810->refclk) || IS_ERR(sp810->timclk)))
 		return -ENOENT;
 
 	/* Select fastest parent */
-	if (clk_get_rate(sp810->refclk) > clk_get_rate(sp810->timclk))
+	if (clk_provider_get_rate(sp810->refclk) > clk_provider_get_rate(sp810->timclk))
 		new_parent = sp810->refclk;
 	else
 		new_parent = sp810->timclk;
 
 	/* Switch the parent if necessary */
 	if (old_parent != new_parent) {
-		clk_prepare(new_parent);
-		clk_set_parent(hw->clk, new_parent);
-		clk_unprepare(old_parent);
+		clk_provider_prepare(new_parent);
+		clk_provider_set_parent(hw->clk, new_parent);
+		clk_provider_unprepare(old_parent);
 	}
 
 	return 0;
@@ -112,8 +114,8 @@ static void clk_sp810_timerclken_unprepare(struct clk_hw *hw)
 	struct clk_sp810_timerclken *timerclken = to_clk_sp810_timerclken(hw);
 	struct clk_sp810 *sp810 = timerclken->sp810;
 
-	clk_put(sp810->timclk);
-	clk_put(sp810->refclk);
+	__clk_put(sp810->timclk);
+	__clk_put(sp810->refclk);
 }
 
 static const struct clk_ops clk_sp810_timerclken_ops = {
@@ -123,7 +125,7 @@ static const struct clk_ops clk_sp810_timerclken_ops = {
 	.set_parent = clk_sp810_timerclken_set_parent,
 };
 
-static struct clk *clk_sp810_timerclken_of_get(struct of_phandle_args *clkspec,
+static struct clk_core *clk_sp810_timerclken_of_get(struct of_phandle_args *clkspec,
 		void *data)
 {
 	struct clk_sp810 *sp810 = data;
diff --git a/drivers/clk/versatile/clk-vexpress-osc.c b/drivers/clk/versatile/clk-vexpress-osc.c
index 529a59c..c9e175f 100644
--- a/drivers/clk/versatile/clk-vexpress-osc.c
+++ b/drivers/clk/versatile/clk-vexpress-osc.c
@@ -73,7 +73,7 @@ static int vexpress_osc_probe(struct platform_device *pdev)
 	struct clk_lookup *cl = pdev->dev.platform_data; /* Non-DT lookup */
 	struct clk_init_data init;
 	struct vexpress_osc *osc;
-	struct clk *clk;
+	struct clk_core *clk;
 	u32 range[2];
 
 	osc = devm_kzalloc(&pdev->dev, sizeof(*osc), GFP_KERNEL);
diff --git a/drivers/clk/versatile/clk-vexpress.c b/drivers/clk/versatile/clk-vexpress.c
index 2d5e1b4..e77f3d5 100644
--- a/drivers/clk/versatile/clk-vexpress.c
+++ b/drivers/clk/versatile/clk-vexpress.c
@@ -17,7 +17,7 @@
 #include <linux/err.h>
 #include <linux/vexpress.h>
 
-static struct clk *vexpress_sp810_timerclken[4];
+static struct clk_core *vexpress_sp810_timerclken[4];
 static DEFINE_SPINLOCK(vexpress_sp810_lock);
 
 static void __init vexpress_sp810_init(void __iomem *base)
@@ -54,7 +54,7 @@ static const char * const vexpress_clk_24mhz_periphs[] __initconst = {
 
 void __init vexpress_clk_init(void __iomem *sp810_base)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	int i;
 
 	clk = clk_register_fixed_rate(NULL, "dummy_apb_pclk", NULL,
@@ -77,7 +77,7 @@ void __init vexpress_clk_init(void __iomem *sp810_base)
 	vexpress_sp810_init(sp810_base);
 
 	for (i = 0; i < ARRAY_SIZE(vexpress_sp810_timerclken); i++)
-		WARN_ON(clk_set_parent(vexpress_sp810_timerclken[i], clk));
+		WARN_ON(clk_provider_set_parent(vexpress_sp810_timerclken[i], clk));
 
 	WARN_ON(clk_register_clkdev(vexpress_sp810_timerclken[0],
 				"v2m-timer0", "sp804"));
diff --git a/drivers/clk/x86/clk-lpt.c b/drivers/clk/x86/clk-lpt.c
index 812f83f..1b4a5e1 100644
--- a/drivers/clk/x86/clk-lpt.c
+++ b/drivers/clk/x86/clk-lpt.c
@@ -21,7 +21,7 @@
 static int lpt_clk_probe(struct platform_device *pdev)
 {
 	struct lpss_clk_data *drvdata;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata)
diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index 246cf12..c58c540 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -67,8 +67,8 @@ enum zynq_clk {
 	i2c0_aper, i2c1_aper, uart0_aper, uart1_aper, gpio_aper, lqspi_aper,
 	smc_aper, swdt, dbg_trc, dbg_apb, clk_max};
 
-static struct clk *ps_clk;
-static struct clk *clks[clk_max];
+static struct clk_core *ps_clk;
+static struct clk_core *clks[clk_max];
 static struct clk_onecell_data clk_data;
 
 static DEFINE_SPINLOCK(armpll_lock);
@@ -108,7 +108,7 @@ static void __init zynq_clk_register_fclk(enum zynq_clk fclk,
 		const char *clk_name, void __iomem *fclk_ctrl_reg,
 		const char **parents, int enable)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	u32 enable_reg;
 	char *mux_name;
 	char *div0_name;
@@ -154,7 +154,7 @@ static void __init zynq_clk_register_fclk(enum zynq_clk fclk,
 			0, CLK_GATE_SET_TO_DISABLE, fclk_gate_lock);
 	enable_reg = clk_readl(fclk_gate_reg) & 1;
 	if (enable && !enable_reg) {
-		if (clk_prepare_enable(clks[fclk]))
+		if (clk_prepare_enable(clk_core_to_clk(clks[fclk])))
 			pr_warn("%s: FCLK%u enable failed\n", __func__,
 					fclk - fclk0);
 	}
@@ -181,7 +181,7 @@ static void __init zynq_clk_register_periph_clk(enum zynq_clk clk0,
 		const char *clk_name1, void __iomem *clk_ctrl,
 		const char **parents, unsigned int two_gates)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	char *mux_name;
 	char *div_name;
 	spinlock_t *lock;
@@ -222,7 +222,7 @@ static void __init zynq_clk_setup(struct device_node *np)
 	int i;
 	u32 tmp;
 	int ret;
-	struct clk *clk;
+	struct clk_core *clk;
 	char *clk_name;
 	unsigned int fclk_enable = 0;
 	const char *clk_output_name[clk_max];
@@ -333,13 +333,13 @@ static void __init zynq_clk_setup(struct device_node *np)
 			CLK_DIVIDER_ALLOW_ZERO, &ddrclk_lock);
 	clks[ddr2x] = clk_register_gate(NULL, clk_output_name[ddr2x],
 			"ddr2x_div", 0, SLCR_DDR_CLK_CTRL, 1, 0, &ddrclk_lock);
-	clk_prepare_enable(clks[ddr2x]);
+	clk_prepare_enable(clk_core_to_clk(clks[ddr2x]));
 	clk = clk_register_divider(NULL, "ddr3x_div", "ddrpll", 0,
 			SLCR_DDR_CLK_CTRL, 20, 6, CLK_DIVIDER_ONE_BASED |
 			CLK_DIVIDER_ALLOW_ZERO, &ddrclk_lock);
 	clks[ddr3x] = clk_register_gate(NULL, clk_output_name[ddr3x],
 			"ddr3x_div", 0, SLCR_DDR_CLK_CTRL, 0, 0, &ddrclk_lock);
-	clk_prepare_enable(clks[ddr3x]);
+	clk_prepare_enable(clk_core_to_clk(clks[ddr3x]));
 
 	clk = clk_register_divider(NULL, "dci_div0", "ddrpll", 0,
 			SLCR_DCI_CLK_CTRL, 8, 6, CLK_DIVIDER_ONE_BASED |
@@ -351,7 +351,7 @@ static void __init zynq_clk_setup(struct device_node *np)
 	clks[dci] = clk_register_gate(NULL, clk_output_name[dci], "dci_div1",
 			CLK_SET_RATE_PARENT, SLCR_DCI_CLK_CTRL, 0, 0,
 			&dciclk_lock);
-	clk_prepare_enable(clks[dci]);
+	clk_prepare_enable(clk_core_to_clk(clks[dci]));
 
 	/* Peripheral clocks */
 	for (i = fclk0; i <= fclk3; i++) {
@@ -505,10 +505,10 @@ static void __init zynq_clk_setup(struct device_node *np)
 	/* leave debug clocks in the state the bootloader set them up to */
 	tmp = clk_readl(SLCR_DBG_CLK_CTRL);
 	if (tmp & DBG_CLK_CTRL_CLKACT_TRC)
-		if (clk_prepare_enable(clks[dbg_trc]))
+		if (clk_prepare_enable(clk_core_to_clk(clks[dbg_trc])))
 			pr_warn("%s: trace clk enable failed\n", __func__);
 	if (tmp & DBG_CLK_CTRL_CPU_1XCLKACT)
-		if (clk_prepare_enable(clks[dbg_apb]))
+		if (clk_prepare_enable(clk_core_to_clk(clks[dbg_apb])))
 			pr_warn("%s: debug APB clk enable failed\n", __func__);
 
 	/* One gated clock for all APER clocks. */
diff --git a/drivers/clk/zynq/pll.c b/drivers/clk/zynq/pll.c
index cec9759..5176f65 100644
--- a/drivers/clk/zynq/pll.c
+++ b/drivers/clk/zynq/pll.c
@@ -193,12 +193,12 @@ static const struct clk_ops zynq_pll_ops = {
  * @lock	Register lock
  * Returns handle to the registered clock.
  */
-struct clk *clk_register_zynq_pll(const char *name, const char *parent,
+struct clk_core *clk_register_zynq_pll(const char *name, const char *parent,
 		void __iomem *pll_ctrl, void __iomem *pll_status, u8 lock_index,
 		spinlock_t *lock)
 {
 	struct zynq_pll *pll;
-	struct clk *clk;
+	struct clk_core *clk;
 	u32 reg;
 	const char *parent_arr[1] = {parent};
 	unsigned long flags = 0;
diff --git a/include/linux/clk/ti.h b/include/linux/clk/ti.h
index e8d8a35..6b9e6b4 100644
--- a/include/linux/clk/ti.h
+++ b/include/linux/clk/ti.h
@@ -22,8 +22,8 @@
  * @mult_div1_reg: register containing the DPLL M and N bitfields
  * @mult_mask: mask of the DPLL M bitfield in @mult_div1_reg
  * @div1_mask: mask of the DPLL N bitfield in @mult_div1_reg
- * @clk_bypass: struct clk pointer to the clock's bypass clock input
- * @clk_ref: struct clk pointer to the clock's reference clock input
+ * @clk_bypass: struct clk_core pointer to the clock's bypass clock input
+ * @clk_ref: struct clk_core pointer to the clock's reference clock input
  * @control_reg: register containing the DPLL mode bitfield
  * @enable_mask: mask of the DPLL mode bitfield in @control_reg
  * @last_rounded_rate: cache of the last rate result of omap2_dpll_round_rate()
@@ -68,8 +68,8 @@ struct dpll_data {
 	void __iomem		*mult_div1_reg;
 	u32			mult_mask;
 	u32			div1_mask;
-	struct clk		*clk_bypass;
-	struct clk		*clk_ref;
+	struct clk_core		*clk_bypass;
+	struct clk_core		*clk_ref;
 	void __iomem		*control_reg;
 	u32			enable_mask;
 	unsigned long		last_rounded_rate;
@@ -251,7 +251,7 @@ extern const struct clk_ops ti_clk_mux_ops;
 
 #define to_clk_hw_omap(_hw) container_of(_hw, struct clk_hw_omap, hw)
 
-void omap2_init_clk_hw_omap_clocks(struct clk *clk);
+void omap2_init_clk_hw_omap_clocks(struct clk_core *clk);
 int omap3_noncore_dpll_enable(struct clk_hw *hw);
 void omap3_noncore_dpll_disable(struct clk_hw *hw);
 int omap3_noncore_dpll_set_rate(struct clk_hw *hw, unsigned long rate,
diff --git a/include/linux/clk/zynq.h b/include/linux/clk/zynq.h
index a990a59..6c35291 100644
--- a/include/linux/clk/zynq.h
+++ b/include/linux/clk/zynq.h
@@ -25,7 +25,7 @@
 
 void zynq_clock_init(void);
 
-struct clk *clk_register_zynq_pll(const char *name, const char *parent,
+struct clk_core *clk_register_zynq_pll(const char *name, const char *parent,
 		void __iomem *pll_ctrl, void __iomem *pll_status, u8 lock_index,
 		spinlock_t *lock);
 #endif
diff --git a/include/linux/platform_data/si5351.h b/include/linux/platform_data/si5351.h
index a947ab8..4b34c69 100644
--- a/include/linux/platform_data/si5351.h
+++ b/include/linux/platform_data/si5351.h
@@ -107,8 +107,8 @@ struct si5351_clkout_config {
  * @clkout: array of clkout configuration
  */
 struct si5351_platform_data {
-	struct clk *clk_xtal;
-	struct clk *clk_clkin;
+	struct clk_core *clk_xtal;
+	struct clk_core *clk_clkin;
 	enum si5351_pll_src pll_src[2];
 	struct si5351_clkout_config clkout[8];
 };
-- 
1.9.3

