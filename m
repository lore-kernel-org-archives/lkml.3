Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773Ab3IXEQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 00:16:08 -0400
Received: from gw.cm.dream.jp ([59.157.128.2]:40234 "EHLO vsmtp02.cm.dti.ne.jp"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750706Ab3IXEQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 00:16:06 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Sep 2013 00:16:06 EDT
Date: Tue, 24 Sep 2013 13:15:42 +0900
From: takasi-y@ops.dti.ne.jp
To: SH-Linux <linux-sh@vger.kernel.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] clk: emev2: Add support for emev2 SMU clocks with DT
Message-Id: <20130924131542.f865fad4dec98e024c0d4676@ops.dti.ne.jp>
In-Reply-To: <52410F86.4040301@renesas.com>
References: <52410F86.4040301@renesas.com>
X-Mailer: Sylpheed 3.4.0beta3 (GTK+ 2.24.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common clock framework version of emev2 clock support.
smu_clkdiv and smu_gclk are handled.
So far, reparent is not implemented, and is fixed to index #0.
SMU and small numbers of clocks are described in emev2.dtsi.

That function and numbers of clocks are equivalent to current
sh-clkfwk version. It is just enough to run kzm9d-reference.

Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
---
 arch/arm/boot/dts/emev2.dtsi     |  84 +++++++++++++++++++++++++++++++
 drivers/clk/Makefile             |   2 +
 drivers/clk/shmobile/Makefile    |   5 ++
 drivers/clk/shmobile/clk-emev2.c | 104 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 195 insertions(+)
 create mode 100644 drivers/clk/shmobile/Makefile
 create mode 100644 drivers/clk/shmobile/clk-emev2.c

diff --git a/arch/arm/boot/dts/emev2.dtsi b/arch/arm/boot/dts/emev2.dtsi
index 9063a44..c6a4767 100644
--- a/arch/arm/boot/dts/emev2.dtsi
+++ b/arch/arm/boot/dts/emev2.dtsi
@@ -52,34 +52,118 @@
 			     <0 121 4>;
 	};
 
+	smu {
+		compatible = "renesas,emev2-smu";
+		reg = <0xe0110000 0x10000>;
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		c32ki: c32ki {
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
+			#clock-cells = <0>;
+		};
+		pll3_fo: pll3_fo {
+			compatible = "fixed-factor-clock";
+			clocks = <&c32ki>;
+			clock-div = <1>;
+			clock-mult = <7000>;
+			#clock-cells = <0>;
+		};
+		usia_u0_sclkdiv: usia_u0_sclkdiv {
+			compatible = "renesas,emev2-smu-clkdiv";
+			reg = <0x610 0>;
+			clocks = <&pll3_fo>;
+			#clock-cells = <0>;
+		};
+		usib_u1_sclkdiv: usib_u1_sclkdiv {
+			compatible = "renesas,emev2-smu-clkdiv";
+			reg = <0x65c 0>;
+			clocks = <&pll3_fo>;
+			#clock-cells = <0>;
+		};
+		usib_u2_sclkdiv: usib_u2_sclkdiv {
+			compatible = "renesas,emev2-smu-clkdiv";
+			reg = <0x65c 16>;
+			clocks = <&pll3_fo>;
+			#clock-cells = <0>;
+		};
+		usib_u3_sclkdiv: usib_u3_sclkdiv {
+			compatible = "renesas,emev2-smu-clkdiv";
+			reg = <0x660 0>;
+			clocks = <&pll3_fo>;
+			#clock-cells = <0>;
+		};
+		usia_u0_sclk: usia_u0_sclk {
+			compatible = "renesas,emev2-smu-gclk";
+			reg = <0x4a0 1>;
+			clocks = <&usia_u0_sclkdiv>;
+			#clock-cells = <0>;
+		};
+		usib_u1_sclk: usib_u1_sclk {
+			compatible = "renesas,emev2-smu-gclk";
+			reg = <0x4b8 1>;
+			clocks = <&usib_u1_sclkdiv>;
+			#clock-cells = <0>;
+		};
+		usib_u2_sclk: usib_u2_sclk {
+			compatible = "renesas,emev2-smu-gclk";
+			reg = <0x4bc 1>;
+			clocks = <&usib_u2_sclkdiv>;
+			#clock-cells = <0>;
+		};
+		usib_u3_sclk: usib_u3_sclk {
+			compatible = "renesas,emev2-smu-gclk";
+			reg = <0x4c0 1>;
+			clocks = <&usib_u3_sclkdiv>;
+			#clock-cells = <0>;
+		};
+		sti_sclk: sti_sclk {
+			compatible = "renesas,emev2-smu-gclk";
+			reg = <0x528 1>;
+			clocks = <&c32ki>;
+			#clock-cells = <0>;
+		};
+	};
+
 	sti@e0180000 {
 		compatible = "renesas,em-sti";
 		reg = <0xe0180000 0x54>;
 		interrupts = <0 125 0>;
+		clocks = <&sti_sclk>;
+		clock-names = "sclk";
 	};
 
 	uart@e1020000 {
 		compatible = "renesas,em-uart";
 		reg = <0xe1020000 0x38>;
 		interrupts = <0 8 0>;
+		clocks = <&usia_u0_sclk>;
+		clock-names = "sclk";
 	};
 
 	uart@e1030000 {
 		compatible = "renesas,em-uart";
 		reg = <0xe1030000 0x38>;
 		interrupts = <0 9 0>;
+		clocks = <&usib_u1_sclk>;
+		clock-names = "sclk";
 	};
 
 	uart@e1040000 {
 		compatible = "renesas,em-uart";
 		reg = <0xe1040000 0x38>;
 		interrupts = <0 10 0>;
+		clocks = <&usib_u2_sclk>;
+		clock-names = "sclk";
 	};
 
 	uart@e1050000 {
 		compatible = "renesas,em-uart";
 		reg = <0xe1050000 0x38>;
 		interrupts = <0 11 0>;
+		clocks = <&usib_u3_sclk>;
+		clock-names = "sclk";
 	};
 
 	gpio0: gpio@e0050000 {
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 7b11106..3e64ac4 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -32,6 +32,8 @@ obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
 obj-$(CONFIG_ARCH_ZYNQ)		+= zynq/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_PLAT_SAMSUNG)	+= samsung/
+obj-$(CONFIG_ARCH_SHMOBILE)	+= shmobile/
+obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+= shmobile/
 
 obj-$(CONFIG_X86)		+= x86/
 
diff --git a/drivers/clk/shmobile/Makefile b/drivers/clk/shmobile/Makefile
new file mode 100644
index 0000000..6a26eb6
--- /dev/null
+++ b/drivers/clk/shmobile/Makefile
@@ -0,0 +1,5 @@
+ifeq ($(CONFIG_COMMON_CLK), y)
+obj-$(CONFIG_ARCH_EMEV2)	+= clk-emev2.o
+endif
+# for emply built-in.o
+obj-n	:= dummy
diff --git a/drivers/clk/shmobile/clk-emev2.c b/drivers/clk/shmobile/clk-emev2.c
new file mode 100644
index 0000000..6c7c929
--- /dev/null
+++ b/drivers/clk/shmobile/clk-emev2.c
@@ -0,0 +1,104 @@
+/*
+ * EMMA Mobile EV2 common clock framework support
+ *
+ * Copyright (C) 2013 Takashi Yoshii <takashi.yoshii.ze@renesas.com>
+ * Copyright (C) 2012 Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+/* EMEV2 SMU registers */
+#define USIAU0_RSTCTRL 0x094
+#define USIBU1_RSTCTRL 0x0ac
+#define USIBU2_RSTCTRL 0x0b0
+#define USIBU3_RSTCTRL 0x0b4
+#define STI_RSTCTRL 0x124
+#define STI_CLKSEL 0x688
+
+static DEFINE_SPINLOCK(lock);
+
+/* not pretty, but hey */
+void __iomem *smu_base;
+
+static void __init emev2_smu_write(unsigned long value, int offs)
+{
+	BUG_ON(!smu_base || (offs >= PAGE_SIZE));
+	writel_relaxed(value, smu_base + offs);
+}
+
+static const struct of_device_id smu_id[] __initconst = {
+	{ .compatible = "renesas,emev2-smu", },
+	{},
+};
+
+static void __init emev2_smu_init(void)
+{
+	struct device_node *np;
+
+	np = of_find_matching_node(NULL, smu_id);
+	BUG_ON(!np);
+	smu_base = of_iomap(np, 0);
+	BUG_ON(!smu_base);
+	of_node_put(np);
+
+	/* setup STI timer to run on 32.768 kHz and deassert reset */
+	emev2_smu_write(0, STI_CLKSEL);
+	emev2_smu_write(1, STI_RSTCTRL);
+
+	/* deassert reset for UART0->UART3 */
+	emev2_smu_write(2, USIAU0_RSTCTRL);
+	emev2_smu_write(2, USIBU1_RSTCTRL);
+	emev2_smu_write(2, USIBU2_RSTCTRL);
+	emev2_smu_write(2, USIBU3_RSTCTRL);
+}
+
+static void __init emev2_smu_clkdiv_init(struct device_node *np)
+{
+	u32 reg[2];
+	struct clk *clk;
+	const char *parent_name = of_clk_get_parent_name(np, 0);
+	if (WARN_ON(of_property_read_u32_array(np, "reg", reg, 2)))
+		return;
+	if (!smu_base)
+		emev2_smu_init();
+	clk = clk_register_divider(NULL, np->name, parent_name, 0,
+				   smu_base + reg[0], reg[1], 8, 0, &lock);
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	clk_register_clkdev(clk, np->name, NULL);
+	pr_debug("## %s %s %p\n", __func__, np->name, clk);
+}
+CLK_OF_DECLARE(emev2_smu_clkdiv, "renesas,emev2-smu-clkdiv",
+		emev2_smu_clkdiv_init);
+
+static void __init emev2_smu_gclk_init(struct device_node *np)
+{
+	u32 reg[2];
+	struct clk *clk;
+	const char *parent_name = of_clk_get_parent_name(np, 0);
+	if (WARN_ON(of_property_read_u32_array(np, "reg", reg, 2)))
+		return;
+	if (!smu_base)
+		emev2_smu_init();
+	clk = clk_register_gate(NULL, np->name, parent_name, 0,
+				smu_base + reg[0], reg[1], 0, &lock);
+	of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	clk_register_clkdev(clk, np->name, NULL);
+	pr_debug("## %s %s %p\n", __func__, np->name, clk);
+}
+CLK_OF_DECLARE(emev2_smu_gclk, "renesas,emev2-smu-gclk", emev2_smu_gclk_init);
-- 
1.8.1.5

