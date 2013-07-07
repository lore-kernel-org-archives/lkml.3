Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab3GPLyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:54:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17895 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab3GPLxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:53:00 -0400
X-AuditID: cbfee691-b7fef6d000002d62-1c-51e5341bebd1
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, sbkim73@samsung.com,
        sameo@linux.intel.com, mturquette@linaro.org, lee.jones@linaro.org,
        broonie@kernel.org, yadi.brar01@gmail.com,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 1/3] clk: s2mps11: Add support for s2mps11
Date: Sun, 07 Jul 2013 17:14:20 +0530
Message-id: <1373197462-4033-2-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1373197462-4033-1-git-send-email-yadi.brar@samsung.com>
References: <1373197462-4033-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSpytt8jTQoOOTmsXUh0/YLO5/Pcpo
	senxNVaLy7vmsFk8nXCRzeJ0N6vFxRVfmCzm/m5ktZgz/R2TA6fHzll32T02repk87hzbQ+b
	x7yTgR6bl9R79G1ZxejxeZNcAHsUl01Kak5mWWqRvl0CV8a7eSoFK10rOmcuZW1g7LbsYuTk
	kBAwkZjxbAo7hC0mceHeerYuRi4OIYGljBKLrrxigyn68a2DHSIxnVHi1cetLBBOG5PElwWb
	gao4ONgEjCReHbMDaRARUJDY3PuMFaSGWeABo8TDd5tZQRLCAlYSd9c8BLNZBFQlDlxeCmbz
	CrhIXP22AmqbgkTrskNgJ3EKuEqcPrKcHWS+EFDNzFMSIDMlBLaxS8w+NI0JYo6AxLfJh1hA
	aiQEZCU2HWCGGCMpcXDFDZYJjMILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYgTGwel/
	zybuYLx/wPoQYzLQuInMUqLJ+cA4yiuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7
	NbUgtSi+qDQntfgQIxMHp1QDY+za3UbS6Vt2Ofsc3Sw1W6vzVOce/bLnMmtPTvGWl1drXy6t
	v1K+JONAw9ZIoWlHbgZsn+Q102bLusrqK3pCOV0b7x5tVSnZc+Ptz0nKE/dxTzrfdE+5fdaq
	L49D1l7/5tIpsG5B2qcvRluDJi7mN6hxvKP/sWn1u/AzHzYHf4pxehQ842YM6xIlluKMREMt
	5qLiRAADJaoImQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQV1pk6eBBndbZS2mPnzCZnH/61FG
	i02Pr7FaXN41h83i6YSLbBanu1ktLq74wmQx93cjq8Wc6e+YHDg9ds66y+6xaVUnm8eda3vY
	POadDPTYvKTeo2/LKkaPz5vkAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jBmvJunUrDStaJz5lLWBsZuyy5GTg4JAROJH9862CFsMYkL99azdTFycQgJTGeUePVxKwuE
	08Yk8WXBZqAMBwebgJHEq2N2IA0iAgoSm3ufsYLUMAs8YJR4+G4zK0hCWMBK4u6ah2A2i4Cq
	xIHLS8FsXgEXiavfVrBBbFOQaF12CGwzp4CrxOkjy9lB5gsB1cw8JTGBkXcBI8MqRtHUguSC
	4qT0XCO94sTc4tK8dL3k/NxNjOAoeya9g3FVg8UhRgEORiUe3oOcTwKFWBPLiitzDzFKcDAr
	ifDe4n8aKMSbklhZlVqUH19UmpNafIgxGeioicxSosn5wASQVxJvaGxibmpsamliYWJmSZqw
	kjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MMd66Cku/LHf9ZH3qyCdR4YaWyDmu2zNKVt+L
	YHBwSzT+pvXrvOmFRbtsdwSzzjoQsyRrj/O2ifUnJorJNT5WcKw7kXzI+85szsiZp13z04+6
	fjzWkDDdftOKDg3NROkvT5XLVsgeY8iJ7cstEkpwW/FIqfbAbOcnbHvcmsPXBgXFXjm8Y+Ef
	JZbijERDLeai4kQAR4JKbfYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to register three(AP/CP/BT) buffered 32.768 KHz
outputs of mfd-s2mps11 with common clock framework.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/clk/Kconfig       |    6 +
 drivers/clk/Makefile      |    1 +
 drivers/clk/clk-s2mps11.c |  273 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 280 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/clk-s2mps11.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 0357ac4..3fdf10e 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -65,6 +65,12 @@ config COMMON_CLK_SI5351
 	  This driver supports Silicon Labs 5351A/B/C programmable clock
 	  generators.
 
+config COMMON_CLK_S2MPS11
+	tristate "Clock driver for S2MPS11 MFD"
+	depends on MFD_SEC_CORE
+	---help---
+	  This driver supports S2MPS11 crystal oscillator clock.
+
 config CLK_TWL6040
 	tristate "External McPDM functional clock from twl6040"
 	depends on TWL6040_CORE
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 137d3e7..5fd642d 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -38,4 +38,5 @@ obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN) += clk-axi-clkgen.o
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
 obj-$(CONFIG_COMMON_CLK_MAX77686) += clk-max77686.o
 obj-$(CONFIG_COMMON_CLK_SI5351) += clk-si5351.o
+obj-$(CONFIG_COMMON_CLK_S2MPS11) += clk-s2mps11.o
 obj-$(CONFIG_CLK_TWL6040)	+= clk-twl6040.o
diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
new file mode 100644
index 0000000..7be41e6
--- /dev/null
+++ b/drivers/clk/clk-s2mps11.c
@@ -0,0 +1,273 @@
+/*
+ * clk-s2mps11.c - Clock driver for S2MPS11.
+ *
+ * Copyright (C) 2013 Samsung Electornics
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/clkdev.h>
+#include <linux/regmap.h>
+#include <linux/clk-provider.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/samsung/s2mps11.h>
+#include <linux/mfd/samsung/core.h>
+
+#define s2mps11_name(a) (a->hw.init->name)
+
+static struct clk **clk_table;
+static struct clk_onecell_data clk_data;
+
+enum {
+	S2MPS11_CLK_AP = 0,
+	S2MPS11_CLK_CP,
+	S2MPS11_CLK_BT,
+	S2MPS11_CLKS_NUM,
+};
+
+struct s2mps11_clk {
+	struct sec_pmic_dev *iodev;
+	struct clk_hw hw;
+	struct clk *clk;
+	struct clk_lookup *lookup;
+	u32 mask;
+	bool enabled;
+};
+
+static struct s2mps11_clk *to_s2mps11_clk(struct clk_hw *hw)
+{
+	return container_of(hw, struct s2mps11_clk, hw);
+}
+
+static int s2mps11_clk_prepare(struct clk_hw *hw)
+{
+	struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
+	int ret;
+
+	ret = regmap_update_bits(s2mps11->iodev->regmap,
+				S2MPS11_REG_RTC_CTRL,
+				 s2mps11->mask, s2mps11->mask);
+	if (!ret)
+		s2mps11->enabled = true;
+
+	return ret;
+}
+
+static void s2mps11_clk_unprepare(struct clk_hw *hw)
+{
+	struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
+	int ret;
+
+	ret = regmap_update_bits(s2mps11->iodev->regmap, S2MPS11_REG_RTC_CTRL,
+			   s2mps11->mask, ~s2mps11->mask);
+
+	if (!ret)
+		s2mps11->enabled = false;
+}
+
+static int s2mps11_clk_is_enabled(struct clk_hw *hw)
+{
+	struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
+
+	return s2mps11->enabled;
+}
+
+static unsigned long s2mps11_clk_recalc_rate(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
+	if (s2mps11->enabled)
+		return 32768;
+	else
+		return 0;
+}
+
+static struct clk_ops s2mps11_clk_ops = {
+	.prepare	= s2mps11_clk_prepare,
+	.unprepare	= s2mps11_clk_unprepare,
+	.is_enabled	= s2mps11_clk_is_enabled,
+	.recalc_rate	= s2mps11_clk_recalc_rate,
+};
+
+static struct clk_init_data s2mps11_clks_init[S2MPS11_CLKS_NUM] = {
+	[S2MPS11_CLK_AP] = {
+		.name = "s2mps11_ap",
+		.ops = &s2mps11_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+	[S2MPS11_CLK_CP] = {
+		.name = "s2mps11_cp",
+		.ops = &s2mps11_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+	[S2MPS11_CLK_BT] = {
+		.name = "s2mps11_bt",
+		.ops = &s2mps11_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+};
+
+static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
+{
+	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct device_node *clk_np;
+	int i;
+
+	if (!iodev->dev->of_node)
+		return NULL;
+
+	clk_np = of_find_node_by_name(iodev->dev->of_node, "clocks");
+	if (!clk_np) {
+		dev_err(&pdev->dev, "could not find clock sub-node\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	clk_table = devm_kzalloc(&pdev->dev, sizeof(struct clk *) *
+				 S2MPS11_CLKS_NUM, GFP_KERNEL);
+	if (!clk_table)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < S2MPS11_CLKS_NUM; i++)
+		of_property_read_string_index(clk_np, "clock-output-names", i,
+				&s2mps11_clks_init[i].name);
+
+	return clk_np;
+}
+
+static int s2mps11_clk_probe(struct platform_device *pdev)
+{
+	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct s2mps11_clk *s2mps11_clks, *s2mps11_clk;
+	struct device_node *clk_np = NULL;
+	int i, ret = 0;
+	u32 val;
+
+	s2mps11_clks = devm_kzalloc(&pdev->dev, sizeof(*s2mps11_clk) *
+					S2MPS11_CLKS_NUM, GFP_KERNEL);
+	if (!s2mps11_clks)
+		return -ENOMEM;
+
+	s2mps11_clk = s2mps11_clks;
+
+	clk_np = s2mps11_clk_parse_dt(pdev);
+	if (IS_ERR(clk_np))
+		return PTR_ERR(clk_np);
+
+	for (i = 0; i < S2MPS11_CLKS_NUM; i++, s2mps11_clk++) {
+		s2mps11_clk->iodev = iodev;
+		s2mps11_clk->hw.init = &s2mps11_clks_init[i];
+		s2mps11_clk->mask = 1 << i;
+
+		ret = regmap_read(s2mps11_clk->iodev->regmap,
+				  S2MPS11_REG_RTC_CTRL, &val);
+		if (ret < 0)
+			goto err_reg;
+
+		s2mps11_clk->enabled = val & s2mps11_clk->mask;
+
+		s2mps11_clk->clk = devm_clk_register(&pdev->dev,
+							&s2mps11_clk->hw);
+		if (IS_ERR(s2mps11_clk->clk)) {
+			dev_err(&pdev->dev, "Fail to register : %s\n",
+						s2mps11_name(s2mps11_clk));
+			ret = PTR_ERR(s2mps11_clk->clk);
+			goto err_reg;
+		}
+
+		s2mps11_clk->lookup = devm_kzalloc(&pdev->dev,
+					sizeof(struct clk_lookup), GFP_KERNEL);
+		if (!s2mps11_clk->lookup) {
+			ret = -ENOMEM;
+			goto err_lup;
+		}
+
+		s2mps11_clk->lookup->con_id = s2mps11_name(s2mps11_clk);
+		s2mps11_clk->lookup->clk = s2mps11_clk->clk;
+
+		clkdev_add(s2mps11_clk->lookup);
+	}
+
+	if (clk_table) {
+		for (i = 0; i < S2MPS11_CLKS_NUM; i++)
+			clk_table[i] = s2mps11_clks[i].clk;
+
+		clk_data.clks = clk_table;
+		clk_data.clk_num = S2MPS11_CLKS_NUM;
+		of_clk_add_provider(clk_np, of_clk_src_onecell_get, &clk_data);
+	}
+
+	platform_set_drvdata(pdev, s2mps11_clks);
+
+	return ret;
+err_lup:
+	devm_clk_unregister(&pdev->dev, s2mps11_clk->clk);
+err_reg:
+	while (s2mps11_clk > s2mps11_clks) {
+		if (s2mps11_clk->lookup) {
+			clkdev_drop(s2mps11_clk->lookup);
+			devm_clk_unregister(&pdev->dev, s2mps11_clk->clk);
+		}
+		s2mps11_clk--;
+	}
+
+	return ret;
+}
+
+static int s2mps11_clk_remove(struct platform_device *pdev)
+{
+	struct s2mps11_clk *s2mps11_clks = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < S2MPS11_CLKS_NUM; i++)
+		clkdev_drop(s2mps11_clks[i].lookup);
+
+	return 0;
+}
+
+static const struct platform_device_id s2mps11_clk_id[] = {
+	{ "s2mps11-clk", 0},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, s2mps11_clk_id);
+
+static struct platform_driver s2mps11_clk_driver = {
+	.driver = {
+		.name  = "s2mps11-clk",
+		.owner = THIS_MODULE,
+	},
+	.probe = s2mps11_clk_probe,
+	.remove = s2mps11_clk_remove,
+	.id_table = s2mps11_clk_id,
+};
+
+static int __init s2mps11_clk_init(void)
+{
+	return platform_driver_register(&s2mps11_clk_driver);
+}
+subsys_initcall(s2mps11_clk_init);
+
+static void __init s2mps11_clk_cleanup(void)
+{
+	platform_driver_unregister(&s2mps11_clk_driver);
+}
+module_exit(s2mps11_clk_cleanup);
+
+MODULE_DESCRIPTION("S2MPS11 Clock Driver");
+MODULE_AUTHOR("Yadwinder Singh Brar <yadi.brar@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4

