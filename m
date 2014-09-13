Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaIMSb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:31:59 -0400
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:51214 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752268AbaIMSb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:31:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:1:41:69:355:379:541:800:960:973:988:989:1042:1260:1345:1359:1437:1605:1730:1747:1777:1792:2194:2199:2393:2538:2553:2559:2562:2639:2898:3138:3139:3140:3141:3142:3865:3867:3870:4225:4250:4321:4605:5007:6119:6261:7903:9040:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:13972:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: yard70_107d40e37d554
X-Filterd-Recvd-Size: 14210
From: Joe Perches <joe@perches.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] arm: mach-omap2: Convert pr_warning to pr_warn
Date: Sat, 13 Sep 2014 11:31:16 -0700
Message-Id: <1f7bd81d1a391defa61327143d258e6cda23ead6.1410632835.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1410632834.git.joe@perches.com>
References: <cover.1410632834.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common pr_warn.

Other miscellanea:

o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-omap2/display.c            |  2 +-
 arch/arm/mach-omap2/hdq1w.c              |  4 ++--
 arch/arm/mach-omap2/i2c.c                |  2 +-
 arch/arm/mach-omap2/msdi.c               |  4 ++--
 arch/arm/mach-omap2/mux.c                |  2 +-
 arch/arm/mach-omap2/omap_hwmod.c         | 26 +++++++++++++-------------
 arch/arm/mach-omap2/pdata-quirks.c       |  4 ++--
 arch/arm/mach-omap2/pm34xx.c             |  2 +-
 arch/arm/mach-omap2/smartreflex-class3.c |  4 ++--
 arch/arm/mach-omap2/sr_device.c          |  2 +-
 arch/arm/mach-omap2/vc.c                 |  2 +-
 arch/arm/mach-omap2/voltage.c            | 22 +++++++++++-----------
 arch/arm/mach-omap2/wd_timer.c           |  4 ++--
 13 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index bf852d7..7a050f9 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -544,7 +544,7 @@ int omap_dss_reset(struct omap_hwmod *oh)
 			MAX_MODULE_SOFTRESET_WAIT, c);
 
 	if (c == MAX_MODULE_SOFTRESET_WAIT)
-		pr_warning("dss_core: waiting for reset to finish failed\n");
+		pr_warn("dss_core: waiting for reset to finish failed\n");
 	else
 		pr_debug("dss_core: softreset done\n");
 
diff --git a/arch/arm/mach-omap2/hdq1w.c b/arch/arm/mach-omap2/hdq1w.c
index f78b4a1..f3897d8 100644
--- a/arch/arm/mach-omap2/hdq1w.c
+++ b/arch/arm/mach-omap2/hdq1w.c
@@ -67,8 +67,8 @@ int omap_hdq1w_reset(struct omap_hwmod *oh)
 			  MAX_MODULE_SOFTRESET_WAIT, c);
 
 	if (c == MAX_MODULE_SOFTRESET_WAIT)
-		pr_warning("%s: %s: softreset failed (waited %d usec)\n",
-			   __func__, oh->name, MAX_MODULE_SOFTRESET_WAIT);
+		pr_warn("%s: %s: softreset failed (waited %d usec)\n",
+			__func__, oh->name, MAX_MODULE_SOFTRESET_WAIT);
 	else
 		pr_debug("%s: %s: softreset in %d usec\n", __func__,
 			 oh->name, c);
diff --git a/arch/arm/mach-omap2/i2c.c b/arch/arm/mach-omap2/i2c.c
index b456b44..b9d8e47 100644
--- a/arch/arm/mach-omap2/i2c.c
+++ b/arch/arm/mach-omap2/i2c.c
@@ -99,7 +99,7 @@ int omap_i2c_reset(struct omap_hwmod *oh)
 				MAX_MODULE_SOFTRESET_WAIT, c);
 
 	if (c == MAX_MODULE_SOFTRESET_WAIT)
-		pr_warning("%s: %s: softreset failed (waited %d usec)\n",
+		pr_warn("%s: %s: softreset failed (waited %d usec)\n",
 			__func__, oh->name, MAX_MODULE_SOFTRESET_WAIT);
 	else
 		pr_debug("%s: %s: softreset in %d usec\n", __func__,
diff --git a/arch/arm/mach-omap2/msdi.c b/arch/arm/mach-omap2/msdi.c
index 828e0db..8bdf182 100644
--- a/arch/arm/mach-omap2/msdi.c
+++ b/arch/arm/mach-omap2/msdi.c
@@ -76,8 +76,8 @@ int omap_msdi_reset(struct omap_hwmod *oh)
 			  MAX_MODULE_SOFTRESET_WAIT, c);
 
 	if (c == MAX_MODULE_SOFTRESET_WAIT)
-		pr_warning("%s: %s: softreset failed (waited %d usec)\n",
-			   __func__, oh->name, MAX_MODULE_SOFTRESET_WAIT);
+		pr_warn("%s: %s: softreset failed (waited %d usec)\n",
+			__func__, oh->name, MAX_MODULE_SOFTRESET_WAIT);
 	else
 		pr_debug("%s: %s: softreset in %d usec\n", __func__,
 			 oh->name, c);
diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index ac8a249..78064b0 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -814,7 +814,7 @@ int __init omap_mux_late_init(void)
 			"hwmod_io", omap_mux_late_init);
 
 	if (ret)
-		pr_warning("mux: Failed to setup hwmod io irq %d\n", ret);
+		pr_warn("mux: Failed to setup hwmod io irq %d\n", ret);
 
 	return 0;
 }
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 8fd87a3..98f8ec0 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -769,8 +769,8 @@ static int _init_main_clk(struct omap_hwmod *oh)
 
 	oh->_clk = clk_get(NULL, oh->main_clk);
 	if (IS_ERR(oh->_clk)) {
-		pr_warning("omap_hwmod: %s: cannot clk_get main_clk %s\n",
-			   oh->name, oh->main_clk);
+		pr_warn("omap_hwmod: %s: cannot clk_get main_clk %s\n",
+			oh->name, oh->main_clk);
 		return -EINVAL;
 	}
 	/*
@@ -814,8 +814,8 @@ static int _init_interface_clks(struct omap_hwmod *oh)
 
 		c = clk_get(NULL, os->clk);
 		if (IS_ERR(c)) {
-			pr_warning("omap_hwmod: %s: cannot clk_get interface_clk %s\n",
-				   oh->name, os->clk);
+			pr_warn("omap_hwmod: %s: cannot clk_get interface_clk %s\n",
+				oh->name, os->clk);
 			ret = -EINVAL;
 			continue;
 		}
@@ -851,8 +851,8 @@ static int _init_opt_clks(struct omap_hwmod *oh)
 	for (i = oh->opt_clks_cnt, oc = oh->opt_clks; i > 0; i--, oc++) {
 		c = clk_get(NULL, oc->clk);
 		if (IS_ERR(c)) {
-			pr_warning("omap_hwmod: %s: cannot clk_get opt_clk %s\n",
-				   oh->name, oc->clk);
+			pr_warn("omap_hwmod: %s: cannot clk_get opt_clk %s\n",
+				oh->name, oc->clk);
 			ret = -EINVAL;
 			continue;
 		}
@@ -1576,7 +1576,7 @@ static int _init_clkdm(struct omap_hwmod *oh)
 
 	oh->clkdm = clkdm_lookup(oh->clkdm_name);
 	if (!oh->clkdm) {
-		pr_warning("omap_hwmod: %s: could not associate to clkdm %s\n",
+		pr_warn("omap_hwmod: %s: could not associate to clkdm %s\n",
 			oh->name, oh->clkdm_name);
 		return 0;
 	}
@@ -1616,7 +1616,7 @@ static int _init_clocks(struct omap_hwmod *oh, void *data)
 	if (!ret)
 		oh->_state = _HWMOD_STATE_CLKS_INITED;
 	else
-		pr_warning("omap_hwmod: %s: cannot _init_clocks\n", oh->name);
+		pr_warn("omap_hwmod: %s: cannot _init_clocks\n", oh->name);
 
 	return ret;
 }
@@ -1739,7 +1739,7 @@ static int _deassert_hardreset(struct omap_hwmod *oh, const char *name)
 	_disable_clocks(oh);
 
 	if (ret == -EBUSY)
-		pr_warning("omap_hwmod: %s: failed to hardreset\n", oh->name);
+		pr_warn("omap_hwmod: %s: failed to hardreset\n", oh->name);
 
 	if (!ret) {
 		/*
@@ -1953,8 +1953,8 @@ static int _ocp_softreset(struct omap_hwmod *oh)
 
 	c = _wait_softreset_complete(oh);
 	if (c == MAX_MODULE_SOFTRESET_WAIT) {
-		pr_warning("omap_hwmod: %s: softreset failed (waited %d usec)\n",
-			   oh->name, MAX_MODULE_SOFTRESET_WAIT);
+		pr_warn("omap_hwmod: %s: softreset failed (waited %d usec)\n",
+			oh->name, MAX_MODULE_SOFTRESET_WAIT);
 		ret = -ETIMEDOUT;
 		goto dis_opt_clks;
 	} else {
@@ -2618,8 +2618,8 @@ static int __init _setup_reset(struct omap_hwmod *oh)
 	if (oh->rst_lines_cnt == 0) {
 		r = _enable(oh);
 		if (r) {
-			pr_warning("omap_hwmod: %s: cannot be enabled for reset (%d)\n",
-				   oh->name, oh->_state);
+			pr_warn("omap_hwmod: %s: cannot be enabled for reset (%d)\n",
+				oh->name, oh->_state);
 			return -EINVAL;
 		}
 	}
diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 90c88d4..73b333f 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -244,8 +244,8 @@ static void __init nokia_n900_legacy_init(void)
 			/* set IBE to 1 */
 			rx51_secure_update_aux_cr(BIT(6), 0);
 		} else {
-			pr_warning("RX-51: Not enabling ARM errata 430973 workaround\n");
-			pr_warning("Thumb binaries may crash randomly without this workaround\n");
+			pr_warn("RX-51: Not enabling ARM errata 430973 workaround\n");
+			pr_warn("Thumb binaries may crash randomly without this workaround\n");
 		}
 
 		pr_info("RX-51: Registring OMAP3 HWRNG device\n");
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 3f80929..175564c 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -465,7 +465,7 @@ int __init omap3_pm_init(void)
 	int ret;
 
 	if (!omap3_has_io_chain_ctrl())
-		pr_warning("PM: no software I/O chain control; some wakeups may be lost\n");
+		pr_warn("PM: no software I/O chain control; some wakeups may be lost\n");
 
 	pm_errata_configure();
 
diff --git a/arch/arm/mach-omap2/smartreflex-class3.c b/arch/arm/mach-omap2/smartreflex-class3.c
index 7a42e19..d3a588c 100644
--- a/arch/arm/mach-omap2/smartreflex-class3.c
+++ b/arch/arm/mach-omap2/smartreflex-class3.c
@@ -20,8 +20,8 @@ static int sr_class3_enable(struct omap_sr *sr)
 	unsigned long volt = voltdm_get_voltage(sr->voltdm);
 
 	if (!volt) {
-		pr_warning("%s: Curr voltage unknown. Cannot enable %s\n",
-				__func__, sr->name);
+		pr_warn("%s: Curr voltage unknown. Cannot enable %s\n",
+			__func__, sr->name);
 		return -ENODATA;
 	}
 
diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-omap2/sr_device.c
index 1b91ef0..d7cff26 100644
--- a/arch/arm/mach-omap2/sr_device.c
+++ b/arch/arm/mach-omap2/sr_device.c
@@ -154,7 +154,7 @@ static int __init sr_dev_init(struct omap_hwmod *oh, void *user)
 
 	pdev = omap_device_build(name, i, oh, sr_data, sizeof(*sr_data));
 	if (IS_ERR(pdev))
-		pr_warning("%s: Could not build omap_device for %s: %s.\n\n",
+		pr_warn("%s: Could not build omap_device for %s: %s\n",
 			__func__, name, oh->name);
 exit:
 	i++;
diff --git a/arch/arm/mach-omap2/vc.c b/arch/arm/mach-omap2/vc.c
index a4628a9..be9ef83 100644
--- a/arch/arm/mach-omap2/vc.c
+++ b/arch/arm/mach-omap2/vc.c
@@ -198,7 +198,7 @@ int omap_vc_bypass_scale(struct voltagedomain *voltdm,
 		loop_cnt++;
 
 		if (retries_cnt > 10) {
-			pr_warning("%s: Retry count exceeded\n", __func__);
+			pr_warn("%s: Retry count exceeded\n", __func__);
 			return -ETIMEDOUT;
 		}
 
diff --git a/arch/arm/mach-omap2/voltage.c b/arch/arm/mach-omap2/voltage.c
index 3ac8fe1..3783b86 100644
--- a/arch/arm/mach-omap2/voltage.c
+++ b/arch/arm/mach-omap2/voltage.c
@@ -55,7 +55,7 @@ static LIST_HEAD(voltdm_list);
 unsigned long voltdm_get_voltage(struct voltagedomain *voltdm)
 {
 	if (!voltdm || IS_ERR(voltdm)) {
-		pr_warning("%s: VDD specified does not exist!\n", __func__);
+		pr_warn("%s: VDD specified does not exist!\n", __func__);
 		return 0;
 	}
 
@@ -77,7 +77,7 @@ int voltdm_scale(struct voltagedomain *voltdm,
 	unsigned long volt = 0;
 
 	if (!voltdm || IS_ERR(voltdm)) {
-		pr_warning("%s: VDD specified does not exist!\n", __func__);
+		pr_warn("%s: VDD specified does not exist!\n", __func__);
 		return -EINVAL;
 	}
 
@@ -96,8 +96,8 @@ int voltdm_scale(struct voltagedomain *voltdm,
 	}
 
 	if (!volt) {
-		pr_warning("%s: not scaling. OPP voltage for %lu, not found.\n",
-			   __func__, target_volt);
+		pr_warn("%s: not scaling. OPP voltage for %lu, not found.\n",
+			__func__, target_volt);
 		return -EINVAL;
 	}
 
@@ -122,7 +122,7 @@ void voltdm_reset(struct voltagedomain *voltdm)
 	unsigned long target_volt;
 
 	if (!voltdm || IS_ERR(voltdm)) {
-		pr_warning("%s: VDD specified does not exist!\n", __func__);
+		pr_warn("%s: VDD specified does not exist!\n", __func__);
 		return;
 	}
 
@@ -152,7 +152,7 @@ void omap_voltage_get_volttable(struct voltagedomain *voltdm,
 				struct omap_volt_data **volt_data)
 {
 	if (!voltdm || IS_ERR(voltdm)) {
-		pr_warning("%s: VDD specified does not exist!\n", __func__);
+		pr_warn("%s: VDD specified does not exist!\n", __func__);
 		return;
 	}
 
@@ -180,12 +180,12 @@ struct omap_volt_data *omap_voltage_get_voltdata(struct voltagedomain *voltdm,
 	int i;
 
 	if (!voltdm || IS_ERR(voltdm)) {
-		pr_warning("%s: VDD specified does not exist!\n", __func__);
+		pr_warn("%s: VDD specified does not exist!\n", __func__);
 		return ERR_PTR(-EINVAL);
 	}
 
 	if (!voltdm->volt_data) {
-		pr_warning("%s: voltage table does not exist for vdd_%s\n",
+		pr_warn("%s: voltage table does not exist for vdd_%s\n",
 			__func__, voltdm->name);
 		return ERR_PTR(-ENODATA);
 	}
@@ -214,7 +214,7 @@ int omap_voltage_register_pmic(struct voltagedomain *voltdm,
 			       struct omap_voltdm_pmic *pmic)
 {
 	if (!voltdm || IS_ERR(voltdm)) {
-		pr_warning("%s: VDD specified does not exist!\n", __func__);
+		pr_warn("%s: VDD specified does not exist!\n", __func__);
 		return -EINVAL;
 	}
 
@@ -237,7 +237,7 @@ void omap_change_voltscale_method(struct voltagedomain *voltdm,
 				  int voltscale_method)
 {
 	if (!voltdm || IS_ERR(voltdm)) {
-		pr_warning("%s: VDD specified does not exist!\n", __func__);
+		pr_warn("%s: VDD specified does not exist!\n", __func__);
 		return;
 	}
 
@@ -279,7 +279,7 @@ int __init omap_voltage_late_init(void)
 
 		sys_ck = clk_get(NULL, voltdm->sys_clk.name);
 		if (IS_ERR(sys_ck)) {
-			pr_warning("%s: Could not get sys clk.\n", __func__);
+			pr_warn("%s: Could not get sys clk.\n", __func__);
 			return -EINVAL;
 		}
 		voltdm->sys_clk.rate = clk_get_rate(sys_ck);
diff --git a/arch/arm/mach-omap2/wd_timer.c b/arch/arm/mach-omap2/wd_timer.c
index 97d6607..ff0a68c 100644
--- a/arch/arm/mach-omap2/wd_timer.c
+++ b/arch/arm/mach-omap2/wd_timer.c
@@ -93,8 +93,8 @@ int omap2_wd_timer_reset(struct omap_hwmod *oh)
 		udelay(oh->class->sysc->srst_udelay);
 
 	if (c == MAX_MODULE_SOFTRESET_WAIT)
-		pr_warning("%s: %s: softreset failed (waited %d usec)\n",
-			   __func__, oh->name, MAX_MODULE_SOFTRESET_WAIT);
+		pr_warn("%s: %s: softreset failed (waited %d usec)\n",
+			__func__, oh->name, MAX_MODULE_SOFTRESET_WAIT);
 	else
 		pr_debug("%s: %s: softreset in %d usec\n", __func__,
 			 oh->name, c);
-- 
1.8.1.2.459.gbcd45b4.dirty

