Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbbAHBlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:41:09 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38622 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbAHBlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:41:02 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-1c-54ade02a04b9
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv3 1/8] devfreq: exynos: Add generic exynos memory bus frequency
 driver
Date: Thu, 08 Jan 2015 10:40:50 +0900
Message-id: <1420681257-3078-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkSFfrwdoQgzPnLCwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlXHm4EvGgukTGStudv5jbGBcU9rFyMkhIWAi8eX8FFYIW0zi
	wr31bF2MXBxCAksZJe7sf8YCU/RpxVx2iMQiRombz+YxQjhNTBKvVsxnBKliE9CS2P/iBhuI
	LSKgJ9F5bA87iM0s8IdJomkT2CRhgQiJlY9fMYHYLAKqEtv7H4Ct5hVwkbi2+SDUGQoSy5bP
	BLM5BVwl+p9eA7OFgGouP14FtlhC4CW7xNKOo1CDBCS+TT4EtIADKCErsekAM8QcSYmDK26w
	TGAUXsDIsIpRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjMKpO/3s2YQfjvQPWhxgFOBiVeHgL
	+taECLEmlhVX5h5iNAXaMJFZSjQ5Hxi7eSXxhsZmRhamJqbGRuaWZkrivK+lfgYLCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYEzR0sy7lrRrzzSdU0JRSn1Clh0HHgZPuCKxfHHR3qmnBCr/
	TGTYveDX/D9O/CeeNBkb5ZZFnmFwY1zmwZo9Rd1HdmrziTi3+20JE7pZTxww1HydWHoo5mtX
	wgWNjf+//4r/2fFFqJ77268Fm/1Ondv98YJNhZqIWZi0w5NDfROmlJx/Wy510VuJpTgj0VCL
	uag4EQBKEgdipQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV2tB2tDDP4t17J4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMMwdfMhZMn8hYcbPz
	H2MD45rSLkZODgkBE4lPK+ayQ9hiEhfurWfrYuTiEBJYxChx89k8RginiUni1Yr5jCBVbAJa
	Evtf3GADsUUE9CQ6j+0B62YW+MMk0bSJBcQWFoiQWPn4FROIzSKgKrG9/wEriM0r4CJxbfNB
	VohtChLLls8EszkFXCX6n14Ds4WAai4/XsU4gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS9
	5PzcTYzgmH0mvYNxVYPFIUYBDkYlHt6CvjUhQqyJZcWVuYcYJTiYlUR4u86uDRHiTUmsrEot
	yo8vKs1JLT7EaAp01URmKdHkfGA6ySuJNzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0t
	SC2C6WPi4JRqYGQ9X5FyONDiFl9aU/j2h9M6rPSfqVj56ef/eFm2Ps2tTn/p5JyYSLt7GpX5
	Z4T7bExqZP77bn0x231KkYo9C8trpjn/mJnDnk7cNG+u6rcmiYuu/+u27djn4r1xjvOK7lMh
	Jj+Yo209/0h9U3Bjl9n6fU71/PJXjQJ/p85JrXi1J/9fRtIMJSWW4oxEQy3mouJEAMgucOnv	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the generic exynos bus frequency driver for memory bus
with DEVFREQ framework. The Samsung Exynos SoCs have the common architecture
for memory bus between DRAM memory and MMC/sub IP in SoC. This driver can
support the memory bus frequency driver for Exynos SoCs.

Each memory bus block has a clock for memory bus speed and frequency
table which is changed according to the utilization of memory bus on runtime.
And then each memory bus group has the one more memory bus blocks and
OPP table (including frequency and voltage), regulator, devfreq-event
devices.

There are a little difference about the number of memory bus because each Exynos
SoC have the different sub-IP and different memory bus speed. In spite of this
difference among Exynos SoCs, we can support almost Exynos SoC by adding
unique data of memory bus to devicetree file.

Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/Kconfig          |  15 +
 drivers/devfreq/Makefile         |   1 +
 drivers/devfreq/exynos-busfreq.c | 589 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 605 insertions(+)
 create mode 100644 drivers/devfreq/exynos-busfreq.c

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 21f8f17..f1003eb 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -65,6 +65,21 @@ config DEVFREQ_GOV_USERSPACE
 
 comment "DEVFREQ Drivers"
 
+config ARM_EXYNOS_BUS_DEVFREQ
+	bool "EXYNOS Memory Bus DEVFREQ Driver"
+	depends on ARCH_EXYNOS
+	select DEVFREQ_GOV_SIMPLE_ONDEMAND
+	select DEVFREQ_EVENT_EXYNOS_PPMU
+	select PM_DEVFREQ_EVENT
+	select PM_OPP
+	help
+	  This adds the common DEVFREQ driver for Exynos Memory bus. Exynos
+	  Memory bus has one more group of memory bus (e.g, MIF and INT block).
+	  Each memory bus group could contain many memoby bus block. It reads
+	  PPMU counters of memory controllers by using DEVFREQ-event device
+	  and adjusts the operating frequencies and voltages with OPP support.
+	  This does not yet operate with optimal voltages.
+
 config ARM_EXYNOS4_BUS_DEVFREQ
 	bool "ARM Exynos4210/4212/4412 Memory Bus DEVFREQ Driver"
 	depends on (CPU_EXYNOS4210 || SOC_EXYNOS4212 || SOC_EXYNOS4412) && !ARCH_MULTIPLATFORM
diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
index c449336..2b82a4c 100644
--- a/drivers/devfreq/Makefile
+++ b/drivers/devfreq/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_DEVFREQ_GOV_POWERSAVE)	+= governor_powersave.o
 obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
 
 # DEVFREQ Drivers
+obj-$(CONFIG_ARCH_EXYNOS)		+= exynos-busfreq.o
 obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos/
 obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos/
 
diff --git a/drivers/devfreq/exynos-busfreq.c b/drivers/devfreq/exynos-busfreq.c
new file mode 100644
index 0000000..b180f43
--- /dev/null
+++ b/drivers/devfreq/exynos-busfreq.c
@@ -0,0 +1,589 @@
+/*
+ * Generic Exynos Memory Bus Frequency driver with DEVFREQ Framework
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ * Author : Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This driver is based on exynos4_bus.c, which was written
+ * by MyungJoo Ham <myungjoo.ham@samsung.com>, Samsung Electronics.
+ *
+ * This driver support Exynos Memory Bus frequency feature by using in DEVFREQ
+ * framework. This version supprots Exynos3250/Exynos4 series/Exynos5260 SoC.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/devfreq.h>
+#include <linux/devfreq-event.h>
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/pm_opp.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+#define BUS_SATURATION_RATIO	40
+#define SAFEVOLT		50000
+
+struct exynos_memory_bus_opp_info {
+	unsigned long rate;
+	unsigned long volt;
+};
+
+struct exynos_memory_bus_block {
+	struct clk *clk;
+	struct exynos_memory_bus_opp_info *freq_table;
+};
+
+struct exynos_memory_bus_data {
+	/* devfreq device to monitor and control memory bus group */
+	struct device *dev;
+	struct devfreq *devfreq;
+
+	struct exynos_memory_bus_opp_info *freq_table;
+	unsigned int freq_count;
+	struct regulator *regulator;
+	struct mutex lock;
+
+	struct exynos_memory_bus_opp_info curr_opp;
+
+	struct exynos_memory_bus_block *block;
+	unsigned int block_count;
+
+	/* devfreq-event device to get current state of memory bus group */
+	struct devfreq_event_dev **edev;
+	unsigned int edev_count;
+};
+
+/*
+ * Initialize the memory bus group/block by parsing dt node in the devicetree
+ */
+static int of_init_memory_bus(struct device_node *np,
+			      struct exynos_memory_bus_data *data)
+{
+	struct device *dev = data->dev;
+	struct dev_pm_opp *opp;
+	unsigned long rate, volt;
+	int i, ret, count, size;
+
+	/* Get the freq/voltage OPP table to scale memory bus frequency */
+	ret = of_init_opp_table(dev);
+	if (ret < 0) {
+		dev_err(dev, "failed to get OPP table\n");
+		return ret;
+	}
+
+	rcu_read_lock();
+
+	data->freq_count = dev_pm_opp_get_opp_count(dev);
+	if (data->freq_count <= 0) {
+		dev_err(dev, "failed to get the count of OPP entry\n");
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	size = sizeof(*data->freq_table) * data->freq_count;
+	data->freq_table = devm_kzalloc(dev, size, GFP_KERNEL);
+	if (!data->freq_table) {
+		rcu_read_unlock();
+		return -ENOMEM;
+	}
+
+	for (i = 0, rate = 0; i < data->freq_count; i++, rate++) {
+		opp = dev_pm_opp_find_freq_ceil(dev, &rate);
+		if (IS_ERR(opp)) {
+			dev_err(dev, "failed to find dev_pm_opp\n");
+			rcu_read_unlock();
+			return PTR_ERR(opp);
+		}
+
+		volt = dev_pm_opp_get_voltage(opp);
+
+		data->freq_table[i].rate = rate;
+		data->freq_table[i].volt = volt;
+
+		dev_dbg(dev, "Level%d : freq(%ld), voltage(%ld)\n", i, rate, volt);
+	}
+
+	rcu_read_unlock();
+
+	/* Get the regulator to provide memory bus group with the power */
+	data->regulator = devm_regulator_get(dev, "vdd-mem");
+	if (IS_ERR(data->regulator)) {
+		dev_err(dev, "failed to get vdd-memory regulator\n");
+		return PTR_ERR(data->regulator);
+	}
+
+	ret = regulator_enable(data->regulator);
+	if (ret < 0) {
+		dev_err(dev, "failed to enable vdd-memory regulator\n");
+		return ret;
+	}
+
+	/*
+	 * Get the devfreq-event devices to get the current state of
+	 * memory bus group. This raw data will be used in devfreq governor.
+	 */
+	count = devfreq_event_get_edev_count(dev);
+	if (count < 0) {
+		dev_err(dev, "failed to get the count of devfreq-event dev\n");
+		return count;
+	}
+	data->edev_count = count;
+
+	size = sizeof(*data->edev) * count;
+	data->edev = devm_kzalloc(dev, size, GFP_KERNEL);
+	if (!data->edev)
+		return -ENOMEM;
+
+	for (i = 0; i < count; i++) {
+		data->edev[i] = devfreq_event_get_edev_by_phandle(dev, i);
+		if (IS_ERR(data->edev[i])) {
+			of_free_opp_table(dev);
+			return -EPROBE_DEFER;
+		}
+	}
+
+	return 0;
+}
+
+static int of_init_memory_bus_block(struct device_node *np,
+				    struct exynos_memory_bus_data *data)
+{
+	struct exynos_memory_bus_block *block;
+	struct device *dev = data->dev;
+	struct device_node *buses_np, *node;
+	int i, count;
+
+	buses_np = of_get_child_by_name(np, "blocks");
+	if (!buses_np) {
+		dev_err(dev,
+			"failed to get child node of memory bus\n");
+		return -EINVAL;
+	}
+
+	count = of_get_child_count(buses_np);
+	block = devm_kzalloc(dev, sizeof(*block) * count, GFP_KERNEL);
+	if (!block)
+		return -ENOMEM;
+	data->block = block;
+	data->block_count = count;
+
+	/* Parse the information of memory bus block */
+	i = 0;
+	for_each_child_of_node(buses_np, node) {
+		const struct property *prop;
+		const __be32 *val;
+		int j, nr, size;
+
+		block = &data->block[i++];
+
+		/* Get the frequency table of each memory bus block */
+		prop = of_find_property(node, "frequency", NULL);
+		if (!prop)
+			return -ENODEV;
+		if (!prop->value)
+			return -ENODATA;
+
+		nr = prop->length / sizeof(u32);
+		if (!nr)
+			return -EINVAL;
+
+		if (nr != data->freq_count) {
+			dev_err(dev, "the size of frequency table is different \
+					from OPP table\n");
+			return -EINVAL;
+		}
+
+		size = sizeof(*block->freq_table) * nr;
+		block->freq_table = devm_kzalloc(dev, size, GFP_KERNEL);
+		if (!block->freq_table)
+			return -ENOMEM;
+
+		val = prop->value;
+		for (j = nr - 1; j >= 0; j--)
+			block->freq_table[j].rate = be32_to_cpup(val++) * 1000;
+
+		for (j = 0; j < nr; j++)
+			dev_dbg(dev, "%s: Level%d : freq(%ld)\n",
+				node->name, j, block->freq_table[j].rate);
+
+		/* Get the clock of each memory bus block */
+		block->clk = of_clk_get_by_name(node, "memory-bus");
+		if (IS_ERR(block->clk)) {
+			dev_err(dev, "failed to get memory-bus clock in %s\n",
+					node->name);
+			return PTR_ERR(block->clk);
+		}
+		clk_prepare_enable(block->clk);
+
+		of_node_put(node);
+	}
+
+	of_node_put(buses_np);
+
+	return 0;
+}
+
+/*
+ * Control the devfreq-event device to get the current state of memory bus
+ */
+static int exynos_busfreq_enable_edev(struct exynos_memory_bus_data *data)
+{
+	int i, ret;
+
+	for (i = 0; i < data->edev_count; i++) {
+		ret = devfreq_event_enable_edev(data->edev[i]);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int exynos_busfreq_disable_edev(struct exynos_memory_bus_data *data)
+{
+	int i, ret;
+
+	for (i = 0; i < data->edev_count; i++) {
+		ret = devfreq_event_disable_edev(data->edev[i]);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+
+static int exynos_busfreq_set_event(struct exynos_memory_bus_data *data)
+{
+	int i, ret;
+
+	for (i = 0; i < data->edev_count; i++) {
+		ret = devfreq_event_set_event(data->edev[i],
+					DEVFREQ_EVENT_TYPE_RAW_DATA);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int exynos_busfreq_get_event(struct exynos_memory_bus_data *data,
+					struct devfreq_event_data *edata)
+{
+	struct devfreq_event_data event_data;
+	unsigned long event = 0, total_event = 0;
+	int i, ret = 0;
+
+	for (i = 0; i < data->edev_count; i++) {
+		ret = devfreq_event_get_event(data->edev[i],
+					DEVFREQ_EVENT_TYPE_RAW_DATA,
+					&event_data);
+		if (ret < 0)
+			return ret;
+
+		if (i == 0 || event_data.event > event) {
+			event = event_data.event;
+			total_event = event_data.total_event;
+		}
+	}
+
+	edata->event = event;
+	edata->total_event = total_event;
+
+	return ret;
+}
+
+/*
+ * Must necessary function for devfreq governor
+ */
+
+static int exynos_busfreq_set_frequency(struct exynos_memory_bus_data *data,
+				struct exynos_memory_bus_opp_info *new_opp)
+{
+	int i, j;
+
+	for (i = 0; i < data->freq_count; i++)
+		if (new_opp->rate == data->freq_table[i].rate)
+			break;
+
+	if (i == data->freq_count)
+		i = data->freq_count - 1;
+
+	for (j = 0; j < data->block_count; j++)
+		clk_set_rate(data->block[j].clk,
+				data->block[j].freq_table[i].rate);
+
+	return 0;
+}
+
+static int exynos_busfreq_target(struct device *dev, unsigned long *freq,
+				 u32 flags)
+{
+	struct exynos_memory_bus_data *data = dev_get_drvdata(dev);
+	struct exynos_memory_bus_opp_info new_opp;
+	unsigned long new_freq, old_freq;
+	struct dev_pm_opp *opp;
+	int ret = 0;
+
+	/* Get new opp-info instance according to new busfreq clock */
+	rcu_read_lock();
+	opp = devfreq_recommended_opp(dev, freq, flags);
+	if (IS_ERR_OR_NULL(opp)) {
+		dev_err(dev, "failed to get recommed opp instance\n");
+		rcu_read_unlock();
+		return PTR_ERR(opp);
+	}
+	new_opp.rate = dev_pm_opp_get_freq(opp);
+	new_opp.volt = dev_pm_opp_get_voltage(opp);
+	rcu_read_unlock();
+
+	old_freq = data->curr_opp.rate;
+	new_freq = new_opp.rate;
+	if (old_freq == new_freq)
+		return 0;
+
+	dev_dbg(dev, "Change the frequency of memory bus (%ld kHz -> %ld kHz)\n",
+			old_freq / 1000, new_freq / 1000);
+
+	/* Change voltage/clock according to new busfreq level */
+	mutex_lock(&data->lock);
+
+	if (old_freq < new_freq) {
+		ret = regulator_set_voltage(data->regulator, new_opp.volt,
+						new_opp.volt + SAFEVOLT);
+		if (ret < 0) {
+			dev_err(data->dev, "failed to set voltage\n");
+			regulator_set_voltage(data->regulator,
+					data->curr_opp.rate,
+					data->curr_opp.rate + SAFEVOLT);
+			goto out;
+		}
+	}
+
+	exynos_busfreq_set_frequency(data, &new_opp);
+	if (ret < 0) {
+		dev_err(dev, "failed to change clock of memory bus\n");
+		goto out;
+	}
+
+	if (old_freq > new_freq) {
+		ret = regulator_set_voltage(data->regulator, new_opp.volt,
+						new_opp.volt + SAFEVOLT);
+		if (ret < 0) {
+			dev_err(data->dev, "failed to set voltage\n");
+			regulator_set_voltage(data->regulator,
+					data->curr_opp.rate,
+					data->curr_opp.rate + SAFEVOLT);
+			goto out;
+		}
+	}
+
+	data->curr_opp = new_opp;
+
+out:
+	mutex_unlock(&data->lock);
+
+	return ret;
+}
+
+static int exynos_busfreq_get_dev_status(struct device *dev,
+					 struct devfreq_dev_status *stat)
+{
+	struct exynos_memory_bus_data *data = dev_get_drvdata(dev);
+	struct devfreq_event_data edata;
+	int ret;
+
+	stat->current_frequency = data->curr_opp.rate;
+
+	ret = exynos_busfreq_get_event(data, &edata);
+	if (ret < 0) {
+		stat->total_time = stat->busy_time = 0;
+		goto err;
+	}
+
+	stat->busy_time = (edata.event * 100) / BUS_SATURATION_RATIO;
+	stat->total_time = edata.total_event;
+
+	dev_dbg(dev, "Usage of devfreq-event : %ld/%ld\n", stat->busy_time,
+							stat->total_time);
+
+err:
+	ret = exynos_busfreq_set_event(data);
+	if (ret < 0) {
+		dev_err(dev, "failed to set event to devfreq-event devices\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static void exynos_busfreq_exit(struct device *dev)
+{
+	struct exynos_memory_bus_data *data = dev_get_drvdata(dev);
+	int i, ret;
+
+	ret = exynos_busfreq_disable_edev(data);
+	if (ret < 0)
+		dev_warn(dev, "failed to disable the devfreq-event devices\n");
+
+	for (i = 0; i < data->block_count; i++)
+		clk_disable_unprepare(data->block[i].clk);
+
+	if (regulator_is_enabled(data->regulator))
+		regulator_disable(data->regulator);
+
+	of_free_opp_table(dev);
+}
+
+static struct devfreq_dev_profile exynos_memory_bus_profile = {
+	.polling_ms	= 100,
+	.target		= exynos_busfreq_target,
+	.get_dev_status	= exynos_busfreq_get_dev_status,
+	.exit		= exynos_busfreq_exit,
+};
+
+static struct devfreq_simple_ondemand_data exynos_memory_bus_ondemand_data = {
+	.upthreshold		= 40,
+	.downdifferential	= 5,
+};
+
+static int exynos_busfreq_probe(struct platform_device *pdev)
+{
+	struct exynos_memory_bus_data *data;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	int ret;
+
+	if (!np) {
+		dev_err(dev, "failed to find devicetree node\n");
+		return -EINVAL;
+	}
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	mutex_init(&data->lock);
+	data->dev = &pdev->dev;
+	platform_set_drvdata(pdev, data);
+
+	/* Initialize */
+	ret = of_init_memory_bus(np, data);
+	if (ret < 0) {
+		dev_err(dev, "failed to initialize memory-bus\n");
+		return ret;
+	}
+
+	ret = of_init_memory_bus_block(np, data);
+	if (ret < 0) {
+		dev_err(dev, "failed to initialize memory-bus block\n");
+		return ret;
+	}
+
+	/* Add devfreq device for DVFS of memory bus */
+	data->devfreq = devm_devfreq_add_device(dev,
+					&exynos_memory_bus_profile,
+					"simple_ondemand",
+					&exynos_memory_bus_ondemand_data);
+	if (IS_ERR_OR_NULL(data->devfreq)) {
+		dev_err(dev, "failed to add devfreq device\n");
+		return  PTR_ERR(data->devfreq);
+	}
+
+	/* Register opp_notifier to catch the change of OPP  */
+	ret = devm_devfreq_register_opp_notifier(dev, data->devfreq);
+	if (ret < 0) {
+		dev_err(dev, "failed to register opp notifier\n");
+		return ret;
+	}
+
+	/*
+	 * Enable devfreq-event to get raw data which is used to determine
+	 * current memory bus load.
+	 */
+	ret = exynos_busfreq_enable_edev(data);
+	if (ret < 0) {
+		dev_err(dev, "failed to enable devfreq-event devices\n");
+		return ret;
+	}
+
+	ret = exynos_busfreq_set_event(data);
+	if (ret < 0) {
+		dev_err(dev, "failed to set event to devfreq-event devices\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int exynos_busfreq_remove(struct platform_device *pdev)
+{
+	/*
+	 * devfreq_dev_profile.exit() have to free the resource of this
+	 * device driver.
+	 */
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int exynos_busfreq_resume(struct device *dev)
+{
+	struct exynos_memory_bus_data *data = dev_get_drvdata(dev);
+	int ret;
+
+	ret = exynos_busfreq_enable_edev(data);
+	if (ret < 0) {
+		dev_err(dev, "failed to enable the devfreq-event devices\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int exynos_busfreq_suspend(struct device *dev)
+{
+	struct exynos_memory_bus_data *data = dev_get_drvdata(dev);
+	int ret;
+
+	ret = exynos_busfreq_disable_edev(data);
+	if (ret < 0) {
+		dev_err(dev, "failed to disable the devfreq-event devices\n");
+		return ret;
+	}
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops exynos_busfreq_pm = {
+	SET_SYSTEM_SLEEP_PM_OPS(exynos_busfreq_suspend, exynos_busfreq_resume)
+};
+
+static const struct of_device_id exynos_busfreq_of_match[] = {
+	{ .compatible = "samsung,exynos-memory-bus", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, exynos_busfreq_of_match);
+
+static struct platform_driver exynos_busfreq_platdrv = {
+	.probe		= exynos_busfreq_probe,
+	.remove		= exynos_busfreq_remove,
+	.driver = {
+		.name	= "exynos-memory-bus",
+		.owner	= THIS_MODULE,
+		.pm	= &exynos_busfreq_pm,
+		.of_match_table = of_match_ptr(exynos_busfreq_of_match),
+	},
+};
+module_platform_driver(exynos_busfreq_platdrv);
+
+MODULE_DESCRIPTION("Generic Exynos Memory Bus Frequency driver");
+MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.8.5.5

