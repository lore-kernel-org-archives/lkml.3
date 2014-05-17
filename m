Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaEQOiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 10:38:00 -0400
Received: from mout.gmx.net ([212.227.17.22]:64502 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821AbaEQOh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 10:37:59 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: linus.walleij@linaro.org
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] pinctrl: Cleanup string initializations (char[] instead of char *)
Date: Sat, 17 May 2014 16:37:25 +0200
Message-Id: <1400337445-25750-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:2V+coJi2cuP1HQnnSZLREcGDkBshHP7OLBIpMHmL9GcV9LgiHB0
 Dm6WPsm6rzWQ9HJQ9AYu7H5BhHu5wKfDupydD1PRmFTVa6vHWDCNGFPS+igLSD5gVtgy8vP
 vb9C3ocaO8Eg4uX2o/CsOdmRgH+KJ/OgBN6OsAgNXeCX1PztNkIDjZUnCew+ZaWwqTBGWQw
 ps15SLrG67YYo3DJY1GIw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initializations like 'char *foo = "bar"' will create two variables: a static
string and a pointer (foo) to that static string. Instead 'char foo[] = "bar"'
will declare a single variable and will end up in shorter
assembly (according to Jeff Garzik on the KernelJanitor's TODO list).

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/pinctrl/pinctrl-mxs.c    |    6 +++---
 drivers/pinctrl/pinctrl-single.c |    4 ++--
 drivers/pinctrl/pinctrl-tegra.c  |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
index 40c76f2..cd4215e 100644
--- a/drivers/pinctrl/pinctrl-mxs.c
+++ b/drivers/pinctrl/pinctrl-mxs.c
@@ -351,7 +351,7 @@ static int mxs_pinctrl_parse_group(struct platform_device *pdev,
 	struct mxs_pinctrl_data *d = platform_get_drvdata(pdev);
 	struct mxs_group *g = &d->soc->groups[idx];
 	struct property *prop;
-	const char *propname = "fsl,pinmux-ids";
+	const char propname[] = "fsl,pinmux-ids";
 	char *group;
 	int length = strlen(np->name) + SUFFIX_LEN;
 	u32 val, i;
@@ -399,8 +399,8 @@ static int mxs_pinctrl_probe_dt(struct platform_device *pdev,
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *child;
 	struct mxs_function *f;
-	const char *gpio_compat = "fsl,mxs-gpio";
-	const char *fn, *fnull = "";
+	const char gpio_compat[] = "fsl,mxs-gpio";
+	const char *fn, fnull[] = "";
 	int i = 0, idxf = 0, idxg = 0;
 	int ret;
 	u32 val;
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 2960557..a3ed99f 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1561,8 +1561,8 @@ static struct of_device_id pcs_of_match[];
 
 static int pcs_add_gpio_func(struct device_node *node, struct pcs_device *pcs)
 {
-	const char *propname = "pinctrl-single,gpio-range";
-	const char *cellname = "#pinctrl-single,gpio-range-cells";
+	const char propname[] = "pinctrl-single,gpio-range";
+	const char cellname[] = "#pinctrl-single,gpio-range-cells";
 	struct of_phandle_args gpiospec;
 	struct pcs_gpiofunc_range *range;
 	int ret, i;
diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index 6545809..43eeb1b 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -576,7 +576,7 @@ static void tegra_pinconf_config_dbg_show(struct pinctrl_dev *pctldev,
 {
 	enum tegra_pinconf_param param = TEGRA_PINCONF_UNPACK_PARAM(config);
 	u16 arg = TEGRA_PINCONF_UNPACK_ARG(config);
-	const char *pname = "unknown";
+	const char pname[] = "unknown";
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
-- 
1.7.10.4

