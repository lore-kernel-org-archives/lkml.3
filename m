Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3GQOJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:09:30 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55557 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab3GQOGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:06:41 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Russell King <linux@arm.linux.org.uk>, Shawn Guo <shawn.guo@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH v2 07/15] cpufreq: imx6q-cpufreq: remove device tree parsing for cpu nodes
Date: Wed, 17 Jul 2013 15:06:16 +0100
Message-Id: <1374069984-20567-8-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 17 Jul 2013 14:06:38.0805 (UTC) FILETIME=[DAFF4050:01CE82F6]
X-MC-Unique: 113071715063917501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6HE9ZYN026369

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes all DT parsing and uses cpu->of_node instead.

Acked-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/mach-imx/mach-imx6q.c  | 3 +--
 drivers/cpufreq/imx6q-cpufreq.c | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 7be13f8..a02f275 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -254,13 +254,12 @@ static void __init imx6q_opp_init(struct device *cpu_dev)
 {
 	struct device_node *np;
 
-	np = of_find_node_by_path("/cpus/cpu@0");
+	np = of_node_get(cpu_dev->of_node);
 	if (!np) {
 		pr_warn("failed to find cpu0 node\n");
 		return;
 	}
 
-	cpu_dev->of_node = np;
 	if (of_init_opp_table(cpu_dev)) {
 		pr_warn("failed to init OPP table\n");
 		goto put_node;
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index e37cdae..b16632b 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -221,14 +221,12 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 
 	cpu_dev = &pdev->dev;
 
-	np = of_find_node_by_path("/cpus/cpu@0");
+	np = of_node_get(cpu_dev->of_node);
 	if (!np) {
 		dev_err(cpu_dev, "failed to find cpu0 node\n");
 		return -ENOENT;
 	}
 
-	cpu_dev->of_node = np;
-
 	arm_clk = devm_clk_get(cpu_dev, "arm");
 	pll1_sys_clk = devm_clk_get(cpu_dev, "pll1_sys");
 	pll1_sw_clk = devm_clk_get(cpu_dev, "pll1_sw");
-- 
1.8.1.2


