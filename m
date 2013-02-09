Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947597Ab3BIBIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:08:40 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:48166 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947579Ab3BIBIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:38 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 03/16] davinci: cpuidle - move code to prevent forward declaration
Date: Fri,  8 Feb 2013 20:08:07 -0500
Message-Id: <8d60143a2367616a9d4f7c11656ade8521eb1874.1360371180.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360372100-28482-1-git-send-email-lenb@kernel.org>
References: <1360372100-28482-1-git-send-email-lenb@kernel.org>
In-Reply-To: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
References: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

The patch is mindless, it just moves the idle function below in the file
in order to prevent forward declaration in the next patch.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/arm/mach-davinci/cpuidle.c | 72 ++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
index 5fbd470..697febe 100644
--- a/arch/arm/mach-davinci/cpuidle.c
+++ b/arch/arm/mach-davinci/cpuidle.c
@@ -31,42 +31,6 @@ struct davinci_ops {
 	u32 flags;
 };
 
-/* Actual code that puts the SoC in different idle states */
-static int davinci_enter_idle(struct cpuidle_device *dev,
-				struct cpuidle_driver *drv,
-						int index)
-{
-	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
-	struct davinci_ops *ops = cpuidle_get_statedata(state_usage);
-
-	if (ops && ops->enter)
-		ops->enter();
-
-	index = cpuidle_wrap_enter(dev,	drv, index,
-				arm_cpuidle_simple_enter);
-
-	if (ops && ops->exit)
-		ops->exit();
-
-	return index;
-}
-
-static struct cpuidle_driver davinci_idle_driver = {
-	.name			= "cpuidle-davinci",
-	.owner			= THIS_MODULE,
-	.en_core_tk_irqen	= 1,
-	.states[0]		= ARM_CPUIDLE_WFI_STATE,
-	.states[1]		= {
-		.enter			= davinci_enter_idle,
-		.exit_latency		= 10,
-		.target_residency	= 100000,
-		.flags			= CPUIDLE_FLAG_TIME_VALID,
-		.name			= "DDR SR",
-		.desc			= "WFI and DDR Self Refresh",
-	},
-	.state_count = DAVINCI_CPUIDLE_MAX_STATES,
-};
-
 static DEFINE_PER_CPU(struct cpuidle_device, davinci_cpuidle_device);
 static void __iomem *ddr2_reg_base;
 static bool ddr2_pdown;
@@ -107,6 +71,42 @@ static struct davinci_ops davinci_states[DAVINCI_CPUIDLE_MAX_STATES] = {
 	},
 };
 
+/* Actual code that puts the SoC in different idle states */
+static int davinci_enter_idle(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
+						int index)
+{
+	struct cpuidle_state_usage *state_usage = &dev->states_usage[index];
+	struct davinci_ops *ops = cpuidle_get_statedata(state_usage);
+
+	if (ops && ops->enter)
+		ops->enter();
+
+	index = cpuidle_wrap_enter(dev,	drv, index,
+				arm_cpuidle_simple_enter);
+
+	if (ops && ops->exit)
+		ops->exit();
+
+	return index;
+}
+
+static struct cpuidle_driver davinci_idle_driver = {
+	.name			= "cpuidle-davinci",
+	.owner			= THIS_MODULE,
+	.en_core_tk_irqen	= 1,
+	.states[0]		= ARM_CPUIDLE_WFI_STATE,
+	.states[1]		= {
+		.enter			= davinci_enter_idle,
+		.exit_latency		= 10,
+		.target_residency	= 100000,
+		.flags			= CPUIDLE_FLAG_TIME_VALID,
+		.name			= "DDR SR",
+		.desc			= "WFI and DDR Self Refresh",
+	},
+	.state_count = DAVINCI_CPUIDLE_MAX_STATES,
+};
+
 static int __init davinci_cpuidle_probe(struct platform_device *pdev)
 {
 	int ret;
-- 
1.8.1.3.535.ga923c31

