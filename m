Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaICL0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:26:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41457 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbaICL0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:26:46 -0400
From: Fan Wu <fwu@marvell.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Wilbur Wang <wwang27@marvell.com>, Yilu Mao <ylmao@marvell.com>
Date: Wed, 3 Sep 2014 04:26:11 -0700
Subject: RE: [PATCH] pinctrl: clean up after enable refactoring
Thread-Topic: [PATCH] pinctrl: clean up after enable refactoring
Thread-Index: Ac/HZwcL9wWkXPj8Q7iVMU5qIHgp3gAAsVhw
Message-ID: <BD54883EA7DE8B41A61B7E723561C71136EF588587@sc-vexch3.marvell.com>
References: <1409742329-17411-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1409742329-17411-1-git-send-email-linus.walleij@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-09-03_05:2014-09-03,2014-09-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409030115
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s83BR0h3021927

Dear Linus,
This is OK for me.

-----Original Message-----
From: Linus Walleij [mailto:linus.walleij@linaro.org]
Sent: 2014Äê9ÔÂ3ÈÕ 19:05
To: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org; Linus Walleij; Fan Wu
Subject: [PATCH] pinctrl: clean up after enable refactoring

commit 2243a87d90b42eb38bc281957df3e57c712b5e56
"pinctrl: avoid duplicated calling enable_pinmux_setting for a pin"
removed the .disable callback from the struct pinmux_ops, making the .enable() callback the only remaining callback.

However .enable() is a bad name as it seems to imply that a muxing can also be disabled. Rename the callback to .set_mux() and also take this opportunity to clean out any remaining mentions of .disable() from the documentation.

Cc: Fan Wu <fwu@marvell.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt                    | 14 ++------------
 drivers/pinctrl/berlin/berlin.c              |  8 ++++----
 drivers/pinctrl/mvebu/pinctrl-mvebu.c        |  6 +++---
 drivers/pinctrl/nomadik/pinctrl-abx500.c     |  6 +++---
 drivers/pinctrl/nomadik/pinctrl-nomadik.c    |  6 +++---
 drivers/pinctrl/pinctrl-adi2.c               |  6 +++---
 drivers/pinctrl/pinctrl-as3722.c             |  4 ++--
 drivers/pinctrl/pinctrl-at91.c               |  6 +++---
 drivers/pinctrl/pinctrl-bcm281xx.c           |  8 ++++----
 drivers/pinctrl/pinctrl-bcm2835.c            |  4 ++--
 drivers/pinctrl/pinctrl-imx.c                |  6 +++---
 drivers/pinctrl/pinctrl-imx1-core.c          |  6 +++---
 drivers/pinctrl/pinctrl-lantiq.c             |  8 ++++----
 drivers/pinctrl/pinctrl-mxs.c                |  6 +++---
 drivers/pinctrl/pinctrl-palmas.c             |  5 +++--
 drivers/pinctrl/pinctrl-rockchip.c           |  6 +++---
 drivers/pinctrl/pinctrl-single.c             |  4 ++--
 drivers/pinctrl/pinctrl-st.c                 |  6 +++---
 drivers/pinctrl/pinctrl-tb10x.c              |  4 ++--
 drivers/pinctrl/pinctrl-tegra-xusb.c         |  8 ++++----
 drivers/pinctrl/pinctrl-tegra.c              |  7 ++++---
 drivers/pinctrl/pinctrl-tz1090-pdc.c         |  7 ++++---
 drivers/pinctrl/pinctrl-tz1090.c             |  6 +++---
 drivers/pinctrl/pinctrl-u300.c               |  6 +++---
 drivers/pinctrl/pinmux.c                     | 10 +++++-----
 drivers/pinctrl/qcom/pinctrl-msm.c           |  8 ++++----
 drivers/pinctrl/samsung/pinctrl-exynos5440.c |  7 ++++---
 drivers/pinctrl/samsung/pinctrl-samsung.c    |  7 ++++---
 drivers/pinctrl/sh-pfc/pinctrl.c             |  6 +++---
 drivers/pinctrl/sirf/pinctrl-sirf.c          |  7 ++++---
 drivers/pinctrl/spear/pinctrl-spear.c        |  4 ++--
 drivers/pinctrl/sunxi/pinctrl-sunxi.c        |  8 ++++----
 drivers/pinctrl/vt8500/pinctrl-wmt.c         |  8 ++++----
 include/linux/pinctrl/pinmux.h               |  7 +++----
 34 files changed, 110 insertions(+), 115 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt index 23f1590f49fe..b8f2147b96dd 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -702,7 +702,7 @@ static int foo_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
        return 0;
 }

-int foo_enable(struct pinctrl_dev *pctldev, unsigned selector,
+int foo_set_mux(struct pinctrl_dev *pctldev, unsigned selector,
                unsigned group)
 {
        u8 regbit = (1 << selector + group);
@@ -711,21 +711,11 @@ int foo_enable(struct pinctrl_dev *pctldev, unsigned selector,
        return 0;
 }

-void foo_disable(struct pinctrl_dev *pctldev, unsigned selector,
-               unsigned group)
-{
-       u8 regbit = (1 << selector + group);
-
-       writeb((readb(MUX) & ~(regbit)), MUX)
-       return 0;
-}
-
 struct pinmux_ops foo_pmxops = {
        .get_functions_count = foo_get_functions_count,
        .get_function_name = foo_get_fname,
        .get_function_groups = foo_get_groups,
-       .enable = foo_enable,
-       .disable = foo_disable,
+       .set_mux = foo_set_mux,
 };

 /* Pinmux operations are handled by some pin controller */ diff --git a/drivers/pinctrl/berlin/berlin.c b/drivers/pinctrl/berlin/berlin.c index 86db2235ab00..61f1bf0e60ba 100644
--- a/drivers/pinctrl/berlin/berlin.c
+++ b/drivers/pinctrl/berlin/berlin.c
@@ -170,9 +170,9 @@ berlin_pinctrl_find_function_by_name(struct berlin_pinctrl *pctrl,
        return NULL;
 }

-static int berlin_pinmux_enable(struct pinctrl_dev *pctrl_dev,
-                               unsigned function,
-                               unsigned group)
+static int berlin_pinmux_set(struct pinctrl_dev *pctrl_dev,
+                            unsigned function,
+                            unsigned group)
 {
        struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
        const struct berlin_desc_group *group_desc = pctrl->desc->groups + group; @@ -197,7 +197,7 @@ static const struct pinmux_ops berlin_pinmux_ops = {
        .get_functions_count    = &berlin_pinmux_get_functions_count,
        .get_function_name      = &berlin_pinmux_get_function_name,
        .get_function_groups    = &berlin_pinmux_get_function_groups,
-       .enable                 = &berlin_pinmux_enable,
+       .set_mux                = &berlin_pinmux_set,
 };

 static int berlin_pinctrl_add_function(struct berlin_pinctrl *pctrl, diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index 9908374f8f92..f3b426cdaf8f 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -259,8 +259,8 @@ static int mvebu_pinmux_get_groups(struct pinctrl_dev *pctldev, unsigned fid,
        return 0;
 }

-static int mvebu_pinmux_enable(struct pinctrl_dev *pctldev, unsigned fid,
-                       unsigned gid)
+static int mvebu_pinmux_set(struct pinctrl_dev *pctldev, unsigned fid,
+                           unsigned gid)
 {
        struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
        struct mvebu_pinctrl_function *func = &pctl->functions[fid]; @@ -344,7 +344,7 @@ static const struct pinmux_ops mvebu_pinmux_ops = {
        .get_function_groups = mvebu_pinmux_get_groups,
        .gpio_request_enable = mvebu_pinmux_gpio_request_enable,
        .gpio_set_direction = mvebu_pinmux_gpio_set_direction,
-       .enable = mvebu_pinmux_enable,
+       .set_mux = mvebu_pinmux_set,
 };

 static int mvebu_pinctrl_get_groups_count(struct pinctrl_dev *pctldev) diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index a53a689a2bfa..b0289824cf73 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -709,8 +709,8 @@ static int abx500_pmx_get_func_groups(struct pinctrl_dev *pctldev,
        return 0;
 }

-static int abx500_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
-                            unsigned group)
+static int abx500_pmx_set(struct pinctrl_dev *pctldev, unsigned function,
+                         unsigned group)
 {
        struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
        struct gpio_chip *chip = &pct->chip;
@@ -784,7 +784,7 @@ static const struct pinmux_ops abx500_pinmux_ops = {
        .get_functions_count = abx500_pmx_get_funcs_cnt,
        .get_function_name = abx500_pmx_get_func_name,
        .get_function_groups = abx500_pmx_get_func_groups,
-       .enable = abx500_pmx_enable,
+       .set_mux = abx500_pmx_set,
        .gpio_request_enable = abx500_gpio_request_enable,
        .gpio_disable_free = abx500_gpio_disable_free,  }; diff --git a/drivers/pinctrl/nomadik/pinctrl-nomadik.c b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
index e7cab07eef47..c093d75a022a 100644
--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -1647,8 +1647,8 @@ static int nmk_pmx_get_func_groups(struct pinctrl_dev *pctldev,
        return 0;
 }

-static int nmk_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
-                         unsigned group)
+static int nmk_pmx_set(struct pinctrl_dev *pctldev, unsigned function,
+                      unsigned group)
 {
        struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
        const struct nmk_pingroup *g;
@@ -1810,7 +1810,7 @@ static const struct pinmux_ops nmk_pinmux_ops = {
        .get_functions_count = nmk_pmx_get_funcs_cnt,
        .get_function_name = nmk_pmx_get_func_name,
        .get_function_groups = nmk_pmx_get_func_groups,
-       .enable = nmk_pmx_enable,
+       .set_mux = nmk_pmx_set,
        .gpio_request_enable = nmk_gpio_request_enable,
        .gpio_disable_free = nmk_gpio_disable_free,  }; diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c index b092b93c67a1..e02943b0285d 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -619,8 +619,8 @@ static struct pinctrl_ops adi_pctrl_ops = {
        .get_group_pins = adi_get_group_pins,
 };

-static int adi_pinmux_enable(struct pinctrl_dev *pctldev, unsigned func_id,
-       unsigned group_id)
+static int adi_pinmux_set(struct pinctrl_dev *pctldev, unsigned func_id,
+                         unsigned group_id)
 {
        struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
        struct gpio_port *port;
@@ -698,7 +698,7 @@ static int adi_pinmux_request_gpio(struct pinctrl_dev *pctldev,  }

 static struct pinmux_ops adi_pinmux_ops = {
-       .enable = adi_pinmux_enable,
+       .set_mux = adi_pinmux_set,
        .get_functions_count = adi_pinmux_get_funcs_count,
        .get_function_name = adi_pinmux_get_func_name,
        .get_function_groups = adi_pinmux_get_groups, diff --git a/drivers/pinctrl/pinctrl-as3722.c b/drivers/pinctrl/pinctrl-as3722.c
index 0e4ec91f4d49..1f790a4b83fe 100644
--- a/drivers/pinctrl/pinctrl-as3722.c
+++ b/drivers/pinctrl/pinctrl-as3722.c
@@ -230,7 +230,7 @@ static int as3722_pinctrl_get_func_groups(struct pinctrl_dev *pctldev,
        return 0;
 }

-static int as3722_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
+static int as3722_pinctrl_set(struct pinctrl_dev *pctldev, unsigned
+function,
                unsigned group)
 {
        struct as3722_pctrl_info *as_pci = pinctrl_dev_get_drvdata(pctldev); @@ -327,7 +327,7 @@ static const struct pinmux_ops as3722_pinmux_ops = {
        .get_functions_count    = as3722_pinctrl_get_funcs_count,
        .get_function_name      = as3722_pinctrl_get_func_name,
        .get_function_groups    = as3722_pinctrl_get_func_groups,
-       .enable                 = as3722_pinctrl_enable,
+       .set_mux                = as3722_pinctrl_set,
        .gpio_request_enable    = as3722_pinctrl_gpio_request_enable,
        .gpio_set_direction     = as3722_pinctrl_gpio_set_direction,
 };
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c index af1ba4fc150d..4839c36a3a1c 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -554,8 +554,8 @@ static void at91_mux_gpio_enable(void __iomem *pio, unsigned mask, bool input)
        writel_relaxed(mask, pio + (input ? PIO_ODR : PIO_OER));  }

-static int at91_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
-                          unsigned group)
+static int at91_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
+                       unsigned group)
 {
        struct at91_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
        const struct at91_pmx_pin *pins_conf = info->groups[group].pins_conf; @@ -684,7 +684,7 @@ static const struct pinmux_ops at91_pmx_ops = {
        .get_functions_count    = at91_pmx_get_funcs_count,
        .get_function_name      = at91_pmx_get_func_name,
        .get_function_groups    = at91_pmx_get_groups,
-       .enable                 = at91_pmx_enable,
+       .set_mux                = at91_pmx_set,
        .gpio_request_enable    = at91_gpio_request_enable,
        .gpio_disable_free      = at91_gpio_disable_free,
 };
diff --git a/drivers/pinctrl/pinctrl-bcm281xx.c b/drivers/pinctrl/pinctrl-bcm281xx.c
index c5ca9e633fff..a26e0c2ba33e 100644
--- a/drivers/pinctrl/pinctrl-bcm281xx.c
+++ b/drivers/pinctrl/pinctrl-bcm281xx.c
@@ -1055,9 +1055,9 @@ static int bcm281xx_pinctrl_get_fcn_groups(struct pinctrl_dev *pctldev,
        return 0;
 }

-static int bcm281xx_pinmux_enable(struct pinctrl_dev *pctldev,
-                                 unsigned function,
-                                 unsigned group)
+static int bcm281xx_pinmux_set(struct pinctrl_dev *pctldev,
+                              unsigned function,
+                              unsigned group)
 {
        struct bcm281xx_pinctrl_data *pdata = pinctrl_dev_get_drvdata(pctldev);
        const struct bcm281xx_pin_function *f = &pdata->functions[function]; @@ -1084,7 +1084,7 @@ static struct pinmux_ops bcm281xx_pinctrl_pinmux_ops = {
        .get_functions_count = bcm281xx_pinctrl_get_fcns_count,
        .get_function_name = bcm281xx_pinctrl_get_fcn_name,
        .get_function_groups = bcm281xx_pinctrl_get_fcn_groups,
-       .enable = bcm281xx_pinmux_enable,
+       .set_mux = bcm281xx_pinmux_set,
 };

 static int bcm281xx_pinctrl_pin_config_get(struct pinctrl_dev *pctldev, diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c
index 5bcfd7ace0cd..eabba02f71f9 100644
--- a/drivers/pinctrl/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/pinctrl-bcm2835.c
@@ -830,7 +830,7 @@ static int bcm2835_pmx_get_function_groups(struct pinctrl_dev *pctldev,
        return 0;
 }

-static int bcm2835_pmx_enable(struct pinctrl_dev *pctldev,
+static int bcm2835_pmx_set(struct pinctrl_dev *pctldev,
                unsigned func_selector,
                unsigned group_selector)
 {
@@ -869,7 +869,7 @@ static const struct pinmux_ops bcm2835_pmx_ops = {
        .get_functions_count = bcm2835_pmx_get_functions_count,
        .get_function_name = bcm2835_pmx_get_function_name,
        .get_function_groups = bcm2835_pmx_get_function_groups,
-       .enable = bcm2835_pmx_enable,
+       .set_mux = bcm2835_pmx_set,
        .gpio_disable_free = bcm2835_pmx_gpio_disable_free,
        .gpio_set_direction = bcm2835_pmx_gpio_set_direction,  }; diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c index 946d594a64dd..570e5acb4a6a 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -179,8 +179,8 @@ static const struct pinctrl_ops imx_pctrl_ops = {

 };

-static int imx_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
-                          unsigned group)
+static int imx_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
+                      unsigned group)
 {
        struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
        const struct imx_pinctrl_soc_info *info = ipctl->info; @@ -298,7 +298,7 @@ static const struct pinmux_ops imx_pmx_ops = {
        .get_functions_count = imx_pmx_get_funcs_count,
        .get_function_name = imx_pmx_get_func_name,
        .get_function_groups = imx_pmx_get_groups,
-       .enable = imx_pmx_enable,
+       .set_mux = imx_pmx_set,
 };

 static int imx_pinconf_get(struct pinctrl_dev *pctldev, diff --git a/drivers/pinctrl/pinctrl-imx1-core.c b/drivers/pinctrl/pinctrl-imx1-core.c
index 483420757c9f..176a3e62f1cf 100644
--- a/drivers/pinctrl/pinctrl-imx1-core.c
+++ b/drivers/pinctrl/pinctrl-imx1-core.c
@@ -298,8 +298,8 @@ static const struct pinctrl_ops imx1_pctrl_ops = {

 };

-static int imx1_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
-                          unsigned group)
+static int imx1_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
+                       unsigned group)
 {
        struct imx1_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
        const struct imx1_pinctrl_soc_info *info = ipctl->info; @@ -385,7 +385,7 @@ static const struct pinmux_ops imx1_pmx_ops = {
        .get_functions_count = imx1_pmx_get_funcs_count,
        .get_function_name = imx1_pmx_get_func_name,
        .get_function_groups = imx1_pmx_get_groups,
-       .enable = imx1_pmx_enable,
+       .set_mux = imx1_pmx_set,
 };

 static int imx1_pinconf_get(struct pinctrl_dev *pctldev, diff --git a/drivers/pinctrl/pinctrl-lantiq.c b/drivers/pinctrl/pinctrl-lantiq.c
index d22ca252b80d..296e5b37f768 100644
--- a/drivers/pinctrl/pinctrl-lantiq.c
+++ b/drivers/pinctrl/pinctrl-lantiq.c
@@ -257,9 +257,9 @@ static int match_group_mux(const struct ltq_pin_group *grp,
        return ret;
 }

-static int ltq_pmx_enable(struct pinctrl_dev *pctrldev,
-                               unsigned func,
-                               unsigned group)
+static int ltq_pmx_set(struct pinctrl_dev *pctrldev,
+                      unsigned func,
+                      unsigned group)
 {
        struct ltq_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
        const struct ltq_pin_group *pin_grp = &info->grps[group]; @@ -316,7 +316,7 @@ static const struct pinmux_ops ltq_pmx_ops = {
        .get_functions_count    = ltq_pmx_func_count,
        .get_function_name      = ltq_pmx_func_name,
        .get_function_groups    = ltq_pmx_get_groups,
-       .enable                 = ltq_pmx_enable,
+       .set_mux                = ltq_pmx_set,
        .gpio_request_enable    = ltq_pmx_gpio_request_enable,
 };

diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c index 40c76f26998c..67035091f8fd 100644
--- a/drivers/pinctrl/pinctrl-mxs.c
+++ b/drivers/pinctrl/pinctrl-mxs.c
@@ -195,8 +195,8 @@ static int mxs_pinctrl_get_func_groups(struct pinctrl_dev *pctldev,
        return 0;
 }

-static int mxs_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned selector,
-                             unsigned group)
+static int mxs_pinctrl_set_mux(struct pinctrl_dev *pctldev, unsigned selector,
+                              unsigned group)
 {
        struct mxs_pinctrl_data *d = pinctrl_dev_get_drvdata(pctldev);
        struct mxs_group *g = &d->soc->groups[group]; @@ -223,7 +223,7 @@ static const struct pinmux_ops mxs_pinmux_ops = {
        .get_functions_count = mxs_pinctrl_get_funcs_count,
        .get_function_name = mxs_pinctrl_get_func_name,
        .get_function_groups = mxs_pinctrl_get_func_groups,
-       .enable = mxs_pinctrl_enable,
+       .set_mux = mxs_pinctrl_set_mux,
 };

 static int mxs_pinconf_get(struct pinctrl_dev *pctldev, diff --git a/drivers/pinctrl/pinctrl-palmas.c b/drivers/pinctrl/pinctrl-palmas.c
index f13d0e78a41c..e3079d3d19fe 100644
--- a/drivers/pinctrl/pinctrl-palmas.c
+++ b/drivers/pinctrl/pinctrl-palmas.c
@@ -685,7 +685,8 @@ static int palmas_pinctrl_get_func_groups(struct pinctrl_dev *pctldev,
        return 0;
 }

-static int palmas_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
+static int palmas_pinctrl_set_mux(struct pinctrl_dev *pctldev,
+               unsigned function,
                unsigned group)
 {
        struct palmas_pctrl_chip_info *pci = pinctrl_dev_get_drvdata(pctldev); @@ -742,7 +743,7 @@ static const struct pinmux_ops palmas_pinmux_ops = {
        .get_functions_count = palmas_pinctrl_get_funcs_count,
        .get_function_name = palmas_pinctrl_get_func_name,
        .get_function_groups = palmas_pinctrl_get_func_groups,
-       .enable = palmas_pinctrl_enable,
+       .set_mux = palmas_pinctrl_set_mux,
 };

 static int palmas_pinconf_get(struct pinctrl_dev *pctldev, diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 5e8b2e04cd7a..b91b966add8f 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -813,8 +813,8 @@ static int rockchip_pmx_get_groups(struct pinctrl_dev *pctldev,
        return 0;
 }

-static int rockchip_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
-                                                           unsigned group)
+static int rockchip_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
+                           unsigned group)
 {
        struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
        const unsigned int *pins = info->groups[group].pins; @@ -889,7 +889,7 @@ static const struct pinmux_ops rockchip_pmx_ops = {
        .get_functions_count    = rockchip_pmx_get_funcs_count,
        .get_function_name      = rockchip_pmx_get_func_name,
        .get_function_groups    = rockchip_pmx_get_groups,
-       .enable                 = rockchip_pmx_enable,
+       .set_mux                = rockchip_pmx_set,
        .gpio_set_direction     = rockchip_pmx_gpio_set_direction,
 };

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 784de13facf3..9032422ad18f 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -447,7 +447,7 @@ static int pcs_get_function(struct pinctrl_dev *pctldev, unsigned pin,
        return 0;
 }

-static int pcs_enable(struct pinctrl_dev *pctldev, unsigned fselector,
+static int pcs_set_mux(struct pinctrl_dev *pctldev, unsigned fselector,
        unsigned group)
 {
        struct pcs_device *pcs;
@@ -519,7 +519,7 @@ static const struct pinmux_ops pcs_pinmux_ops = {
        .get_functions_count = pcs_get_functions_count,
        .get_function_name = pcs_get_function_name,
        .get_function_groups = pcs_get_function_groups,
-       .enable = pcs_enable,
+       .set_mux = pcs_sex_mux,
        .gpio_request_enable = pcs_request_gpio,  };

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c index 5475374d803f..6c4c41bed1e3 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -914,8 +914,8 @@ static struct st_pio_control *st_get_pio_control(
        return &bank->pc;
 }

-static int st_pmx_enable(struct pinctrl_dev *pctldev, unsigned fselector,
-               unsigned group)
+static int st_pmx_set_mux(struct pinctrl_dev *pctldev, unsigned fselector,
+                       unsigned group)
 {
        struct st_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
        struct st_pinconf *conf = info->groups[group].pin_conf; @@ -951,7 +951,7 @@ static struct pinmux_ops st_pmxops = {
        .get_functions_count    = st_pmx_get_funcs_count,
        .get_function_name      = st_pmx_get_fname,
        .get_function_groups    = st_pmx_get_groups,
-       .enable                 = st_pmx_enable,
+       .set_mux                = st_pmx_set_mux,
        .gpio_set_direction     = st_pmx_set_gpio_direction,
 };

diff --git a/drivers/pinctrl/pinctrl-tb10x.c b/drivers/pinctrl/pinctrl-tb10x.c index 71c5d4f0c538..3b9bfcf717ac 100644
--- a/drivers/pinctrl/pinctrl-tb10x.c
+++ b/drivers/pinctrl/pinctrl-tb10x.c
@@ -697,7 +697,7 @@ static void tb10x_gpio_disable_free(struct pinctrl_dev *pctl,
        mutex_unlock(&state->mutex);
 }

-static int tb10x_pctl_enable(struct pinctrl_dev *pctl,
+static int tb10x_pctl_set_mux(struct pinctrl_dev *pctl,
                        unsigned func_selector, unsigned group_selector)  {
        struct tb10x_pinctrl *state = pinctrl_dev_get_drvdata(pctl); @@ -744,7 +744,7 @@ static struct pinmux_ops tb10x_pinmux_ops = {
        .get_function_groups = tb10x_get_function_groups,
        .gpio_request_enable = tb10x_gpio_request_enable,
        .gpio_disable_free = tb10x_gpio_disable_free,
-       .enable = tb10x_pctl_enable,
+       .set_mux = tb10x_pctl_set_mux,
 };

 static struct pinctrl_desc tb10x_pindesc = { diff --git a/drivers/pinctrl/pinctrl-tegra-xusb.c b/drivers/pinctrl/pinctrl-tegra-xusb.c
index a06620474845..4648c9e5c582 100644
--- a/drivers/pinctrl/pinctrl-tegra-xusb.c
+++ b/drivers/pinctrl/pinctrl-tegra-xusb.c
@@ -281,9 +281,9 @@ static int tegra_xusb_padctl_get_function_groups(struct pinctrl_dev *pinctrl,
        return 0;
 }

-static int tegra_xusb_padctl_pinmux_enable(struct pinctrl_dev *pinctrl,
-                                          unsigned int function,
-                                          unsigned int group)
+static int tegra_xusb_padctl_pinmux_set(struct pinctrl_dev *pinctrl,
+                                       unsigned int function,
+                                       unsigned int group)
 {
        struct tegra_xusb_padctl *padctl = pinctrl_dev_get_drvdata(pinctrl);
        const struct tegra_xusb_padctl_lane *lane; @@ -311,7 +311,7 @@ static const struct pinmux_ops tegra_xusb_padctl_pinmux_ops = {
        .get_functions_count = tegra_xusb_padctl_get_functions_count,
        .get_function_name = tegra_xusb_padctl_get_function_name,
        .get_function_groups = tegra_xusb_padctl_get_function_groups,
-       .enable = tegra_xusb_padctl_pinmux_enable,
+       .set_mux = tegra_xusb_padctl_pinmux_set,
 };

 static int tegra_xusb_padctl_pinconf_group_get(struct pinctrl_dev *pinctrl, diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c index 150af5503c09..e5949d51bc52 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -262,8 +262,9 @@ static int tegra_pinctrl_get_func_groups(struct pinctrl_dev *pctldev,
        return 0;
 }

-static int tegra_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
-                              unsigned group)
+static int tegra_pinctrl_set_mux(struct pinctrl_dev *pctldev,
+                                unsigned function,
+                                unsigned group)
 {
        struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
        const struct tegra_pingroup *g;
@@ -294,7 +295,7 @@ static const struct pinmux_ops tegra_pinmux_ops = {
        .get_functions_count = tegra_pinctrl_get_funcs_count,
        .get_function_name = tegra_pinctrl_get_func_name,
        .get_function_groups = tegra_pinctrl_get_func_groups,
-       .enable = tegra_pinctrl_enable,
+       .set_mux = tegra_pinctrl_set_mux,
 };

 static int tegra_pinconf_reg(struct tegra_pmx *pmx, diff --git a/drivers/pinctrl/pinctrl-tz1090-pdc.c b/drivers/pinctrl/pinctrl-tz1090-pdc.c
index 41e81a35cabb..3bb6a3b78864 100644
--- a/drivers/pinctrl/pinctrl-tz1090-pdc.c
+++ b/drivers/pinctrl/pinctrl-tz1090-pdc.c
@@ -547,8 +547,9 @@ static void tz1090_pdc_pinctrl_mux(struct tz1090_pdc_pmx *pmx,
        __global_unlock2(flags);
 }

-static int tz1090_pdc_pinctrl_enable(struct pinctrl_dev *pctldev,
-                                    unsigned int function, unsigned int group)
+static int tz1090_pdc_pinctrl_set_mux(struct pinctrl_dev *pctldev,
+                                     unsigned int function,
+                                     unsigned int group)
 {
        struct tz1090_pdc_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
        const struct tz1090_pdc_pingroup *grp = &tz1090_pdc_groups[group]; @@ -634,7 +635,7 @@ static struct pinmux_ops tz1090_pdc_pinmux_ops = {
        .get_functions_count    = tz1090_pdc_pinctrl_get_funcs_count,
        .get_function_name      = tz1090_pdc_pinctrl_get_func_name,
        .get_function_groups    = tz1090_pdc_pinctrl_get_func_groups,
-       .enable                 = tz1090_pdc_pinctrl_enable,
+       .set_mux                = tz1090_pdc_pinctrl_set_mux,
        .gpio_request_enable    = tz1090_pdc_pinctrl_gpio_request_enable,
        .gpio_disable_free      = tz1090_pdc_pinctrl_gpio_disable_free,
 };
diff --git a/drivers/pinctrl/pinctrl-tz1090.c b/drivers/pinctrl/pinctrl-tz1090.c
index 24082216842e..48d36413b99f 100644
--- a/drivers/pinctrl/pinctrl-tz1090.c
+++ b/drivers/pinctrl/pinctrl-tz1090.c
@@ -1415,8 +1415,8 @@ found_mux:
  * the effect is the same as enabling the function on each individual pin in the
  * group.
  */
-static int tz1090_pinctrl_enable(struct pinctrl_dev *pctldev,
-                                unsigned int function, unsigned int group)
+static int tz1090_pinctrl_set_mux(struct pinctrl_dev *pctldev,
+                                 unsigned int function, unsigned int group)
 {
        struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
        struct tz1090_pingroup *grp;
@@ -1517,7 +1517,7 @@ static struct pinmux_ops tz1090_pinmux_ops = {
        .get_functions_count    = tz1090_pinctrl_get_funcs_count,
        .get_function_name      = tz1090_pinctrl_get_func_name,
        .get_function_groups    = tz1090_pinctrl_get_func_groups,
-       .enable                 = tz1090_pinctrl_enable,
+       .set_mux                = tz1090_pinctrl_set_mux,
        .gpio_request_enable    = tz1090_pinctrl_gpio_request_enable,
        .gpio_disable_free      = tz1090_pinctrl_gpio_disable_free,
 };
diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c index 0959bb36450f..e9c7113d81f2 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -955,8 +955,8 @@ static void u300_pmx_endisable(struct u300_pmx *upmx, unsigned selector,
        }
 }

-static int u300_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
-                          unsigned group)
+static int u300_pmx_set_mux(struct pinctrl_dev *pctldev, unsigned selector,
+                           unsigned group)
 {
        struct u300_pmx *upmx;

@@ -994,7 +994,7 @@ static const struct pinmux_ops u300_pmx_ops = {
        .get_functions_count = u300_pmx_get_funcs_count,
        .get_function_name = u300_pmx_get_func_name,
        .get_function_groups = u300_pmx_get_groups,
-       .enable = u300_pmx_enable,
+       .set_mux = u300_pmx_set_mux,
 };

 static int u300_pin_config_get(struct pinctrl_dev *pctldev, unsigned pin, diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c index c055daf9a80f..b874458dcb88 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -41,7 +41,7 @@ int pinmux_check_ops(struct pinctrl_dev *pctldev)
            !ops->get_functions_count ||
            !ops->get_function_name ||
            !ops->get_function_groups ||
-           !ops->enable) {
+           !ops->set_mux) {
                dev_err(pctldev->dev, "pinmux ops lacks necessary functions\n");
                return -EINVAL;
        }
@@ -445,15 +445,15 @@ int pinmux_enable_setting(struct pinctrl_setting const *setting)
                desc->mux_setting = &(setting->data.mux);
        }

-       ret = ops->enable(pctldev, setting->data.mux.func,
-                         setting->data.mux.group);
+       ret = ops->set_mux(pctldev, setting->data.mux.func,
+                          setting->data.mux.group);

        if (ret)
-               goto err_enable;
+               goto err_set_mux;

        return 0;

-err_enable:
+err_set_mux:
        for (i = 0; i < num_pins; i++) {
                desc = pin_desc_get(pctldev, pins[i]);
                if (desc)
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 80a64cad907d..01eab47a746f 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -134,9 +134,9 @@ static int msm_get_function_groups(struct pinctrl_dev *pctldev,
        return 0;
 }

-static int msm_pinmux_enable(struct pinctrl_dev *pctldev,
-                            unsigned function,
-                            unsigned group)
+static int msm_pinmux_set_mux(struct pinctrl_dev *pctldev,
+                             unsigned function,
+                             unsigned group)
 {
        struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
        const struct msm_pingroup *g;
@@ -170,7 +170,7 @@ static const struct pinmux_ops msm_pinmux_ops = {
        .get_functions_count    = msm_get_functions_count,
        .get_function_name      = msm_get_function_name,
        .get_function_groups    = msm_get_function_groups,
-       .enable                 = msm_pinmux_enable,
+       .set_mux                = msm_pinmux_set_mux,
 };

 static int msm_config_reg(struct msm_pinctrl *pctrl, diff --git a/drivers/pinctrl/samsung/pinctrl-exynos5440.c b/drivers/pinctrl/samsung/pinctrl-exynos5440.c
index 603da2f9dd95..b995ec2c5d16 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos5440.c
@@ -364,8 +364,9 @@ static void exynos5440_pinmux_setup(struct pinctrl_dev *pctldev, unsigned select  }

 /* enable a specified pinmux by writing to registers */ -static int exynos5440_pinmux_enable(struct pinctrl_dev *pctldev, unsigned selector,
-                                       unsigned group)
+static int exynos5440_pinmux_set_mux(struct pinctrl_dev *pctldev,
+                                    unsigned selector,
+                                    unsigned group)
 {
        exynos5440_pinmux_setup(pctldev, selector, group, true);
        return 0;
@@ -387,7 +388,7 @@ static const struct pinmux_ops exynos5440_pinmux_ops = {
        .get_functions_count    = exynos5440_get_functions_count,
        .get_function_name      = exynos5440_pinmux_get_fname,
        .get_function_groups    = exynos5440_pinmux_get_groups,
-       .enable                 = exynos5440_pinmux_enable,
+       .set_mux                = exynos5440_pinmux_set_mux,
        .gpio_set_direction     = exynos5440_pinmux_gpio_set_direction,
 };

diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index b07406da333c..4a47691c32b1 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -401,8 +401,9 @@ static void samsung_pinmux_setup(struct pinctrl_dev *pctldev, unsigned selector,  }

 /* enable a specified pinmux by writing to registers */ -static int samsung_pinmux_enable(struct pinctrl_dev *pctldev, unsigned selector,
-                                       unsigned group)
+static int samsung_pinmux_set_mux(struct pinctrl_dev *pctldev,
+                                 unsigned selector,
+                                 unsigned group)
 {
        samsung_pinmux_setup(pctldev, selector, group, true);
        return 0;
@@ -413,7 +414,7 @@ static const struct pinmux_ops samsung_pinmux_ops = {
        .get_functions_count    = samsung_get_functions_count,
        .get_function_name      = samsung_pinmux_get_fname,
        .get_function_groups    = samsung_pinmux_get_groups,
-       .enable                 = samsung_pinmux_enable,
+       .set_mux                = samsung_pinmux_set_mux,
 };

 /* set or get the pin config settings for a specified pin */ diff --git a/drivers/pinctrl/sh-pfc/pinctrl.c b/drivers/pinctrl/sh-pfc/pinctrl.c
index 11db3ee39d40..910deaefa0ac 100644
--- a/drivers/pinctrl/sh-pfc/pinctrl.c
+++ b/drivers/pinctrl/sh-pfc/pinctrl.c
@@ -312,8 +312,8 @@ static int sh_pfc_get_function_groups(struct pinctrl_dev *pctldev,
        return 0;
 }

-static int sh_pfc_func_enable(struct pinctrl_dev *pctldev, unsigned selector,
-                             unsigned group)
+static int sh_pfc_func_set_mux(struct pinctrl_dev *pctldev, unsigned selector,
+                              unsigned group)
 {
        struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
        struct sh_pfc *pfc = pmx->pfc;
@@ -442,7 +442,7 @@ static const struct pinmux_ops sh_pfc_pinmux_ops = {
        .get_functions_count    = sh_pfc_get_functions_count,
        .get_function_name      = sh_pfc_get_function_name,
        .get_function_groups    = sh_pfc_get_function_groups,
-       .enable                 = sh_pfc_func_enable,
+       .set_mux                = sh_pfc_func_set_mux,
        .gpio_request_enable    = sh_pfc_gpio_request_enable,
        .gpio_disable_free      = sh_pfc_gpio_disable_free,
        .gpio_set_direction     = sh_pfc_gpio_set_direction,
diff --git a/drivers/pinctrl/sirf/pinctrl-sirf.c b/drivers/pinctrl/sirf/pinctrl-sirf.c
index 45f93f952a39..6f252fd7cb0c 100644
--- a/drivers/pinctrl/sirf/pinctrl-sirf.c
+++ b/drivers/pinctrl/sirf/pinctrl-sirf.c
@@ -179,8 +179,9 @@ static void sirfsoc_pinmux_endisable(struct sirfsoc_pmx *spmx,
        }
 }

-static int sirfsoc_pinmux_enable(struct pinctrl_dev *pmxdev, unsigned selector,
-       unsigned group)
+static int sirfsoc_pinmux_set_mux(struct pinctrl_dev *pmxdev,
+                               unsigned selector,
+                               unsigned group)
 {
        struct sirfsoc_pmx *spmx;

@@ -237,7 +238,7 @@ static int sirfsoc_pinmux_request_gpio(struct pinctrl_dev *pmxdev,  }

 static struct pinmux_ops sirfsoc_pinmux_ops = {
-       .enable = sirfsoc_pinmux_enable,
+       .set_mux = sirfsoc_pinmux_set_mux,
        .get_functions_count = sirfsoc_pinmux_get_funcs_count,
        .get_function_name = sirfsoc_pinmux_get_func_name,
        .get_function_groups = sirfsoc_pinmux_get_groups, diff --git a/drivers/pinctrl/spear/pinctrl-spear.c b/drivers/pinctrl/spear/pinctrl-spear.c
index f72cc4e192bd..abdb05ac43dc 100644
--- a/drivers/pinctrl/spear/pinctrl-spear.c
+++ b/drivers/pinctrl/spear/pinctrl-spear.c
@@ -268,7 +268,7 @@ static int spear_pinctrl_endisable(struct pinctrl_dev *pctldev,
        return 0;
 }

-static int spear_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
+static int spear_pinctrl_set_mux(struct pinctrl_dev *pctldev, unsigned
+function,
                unsigned group)
 {
        return spear_pinctrl_endisable(pctldev, function, group, true); @@ -338,7 +338,7 @@ static const struct pinmux_ops spear_pinmux_ops = {
        .get_functions_count = spear_pinctrl_get_funcs_count,
        .get_function_name = spear_pinctrl_get_func_name,
        .get_function_groups = spear_pinctrl_get_func_groups,
-       .enable = spear_pinctrl_enable,
+       .set_mux = spear_pinctrl_set_mux,
        .gpio_request_enable = gpio_request_enable,
        .gpio_disable_free = gpio_disable_free,  }; diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index 3df66e366c87..ef9d804e55de 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -393,9 +393,9 @@ static void sunxi_pmx_set(struct pinctrl_dev *pctldev,
        spin_unlock_irqrestore(&pctl->lock, flags);  }

-static int sunxi_pmx_enable(struct pinctrl_dev *pctldev,
-                           unsigned function,
-                           unsigned group)
+static int sunxi_pmx_set_mux(struct pinctrl_dev *pctldev,
+                            unsigned function,
+                            unsigned group)
 {
        struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
        struct sunxi_pinctrl_group *g = pctl->groups + group; @@ -441,7 +441,7 @@ static const struct pinmux_ops sunxi_pmx_ops = {
        .get_functions_count    = sunxi_pmx_get_funcs_cnt,
        .get_function_name      = sunxi_pmx_get_func_name,
        .get_function_groups    = sunxi_pmx_get_func_groups,
-       .enable                 = sunxi_pmx_enable,
+       .set_mux                = sunxi_pmx_set_mux,
        .gpio_set_direction     = sunxi_pmx_gpio_set_direction,
 };

diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
index 8cea355f9a81..d055d63309e4 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
@@ -131,9 +131,9 @@ static int wmt_set_pinmux(struct wmt_pinctrl_data *data, unsigned func,
        return 0;
 }

-static int wmt_pmx_enable(struct pinctrl_dev *pctldev,
-                         unsigned func_selector,
-                         unsigned group_selector)
+static int wmt_pmx_set_mux(struct pinctrl_dev *pctldev,
+                          unsigned func_selector,
+                          unsigned group_selector)
 {
        struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
        u32 pinnum = data->pins[group_selector].number;
@@ -168,7 +168,7 @@ static struct pinmux_ops wmt_pinmux_ops = {
        .get_functions_count = wmt_pmx_get_functions_count,
        .get_function_name = wmt_pmx_get_function_name,
        .get_function_groups = wmt_pmx_get_function_groups,
-       .enable = wmt_pmx_enable,
+       .set_mux = wmt_pmx_set_mux,
        .gpio_disable_free = wmt_pmx_gpio_disable_free,
        .gpio_set_direction = wmt_pmx_gpio_set_direction,  }; diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h index 3097aafbeb24..511bda9ed4bf 100644
--- a/include/linux/pinctrl/pinmux.h
+++ b/include/linux/pinctrl/pinmux.h
@@ -39,13 +39,12 @@ struct pinctrl_dev;
  *     name can be used with the generic @pinctrl_ops to retrieve the
  *     actual pins affected. The applicable groups will be returned in
  *     @groups and the number of groups in @num_groups
- * @enable: enable a certain muxing function with a certain pin group. The
+ * @set_mux: enable a certain muxing function with a certain pin group.
+ The
  *     driver does not need to figure out whether enabling this function
  *     conflicts some other use of the pins in that group, such collisions
  *     are handled by the pinmux subsystem. The @func_selector selects a
  *     certain function whereas @group_selector selects a certain set of pins
  *     to be used. On simple controllers the latter argument may be ignored
- * @disable: disable a certain muxing selector with a certain pin group
  * @gpio_request_enable: requests and enables GPIO on a certain pin.
  *     Implement this only if you can mux every pin individually as GPIO. The
  *     affected GPIO range is passed along with an offset(pin number) into that
@@ -68,8 +67,8 @@ struct pinmux_ops {
                                  unsigned selector,
                                  const char * const **groups,
                                  unsigned * const num_groups);
-       int (*enable) (struct pinctrl_dev *pctldev, unsigned func_selector,
-                      unsigned group_selector);
+       int (*set_mux) (struct pinctrl_dev *pctldev, unsigned func_selector,
+                       unsigned group_selector);
        int (*gpio_request_enable) (struct pinctrl_dev *pctldev,
                                    struct pinctrl_gpio_range *range,
                                    unsigned offset);
--
1.9.3

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
