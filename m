Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab3IKLQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:16:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26170 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab3IKLOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:14:51 -0400
X-AuditID: cbfee68e-b7f756d000004512-57-523050aa4a1a
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [RFC 1/4] power: asv: Add common ASV support for samsung SoCs
Date: Wed, 11 Sep 2013 16:44:05 +0530
Message-id: <1378898048-25205-2-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1378898048-25205-1-git-send-email-yadi.brar@samsung.com>
References: <1378898048-25205-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSq7sqwCDI4GCfikXvgqtsFpseX2O1
	uLxrDpvFjPP7mCxuN65gs+hf2MtksX7GaxaLYzOWMFps/OphMWf6OyYHLo871/aweWxeUu/R
	t2UVo8ejxS2MHp83yQWwRnHZpKTmZJalFunbJXBlXOvaw1hwIrTi16STrA2Mx127GDk5JARM
	JB7vWs4MYYtJXLi3nq2LkYtDSGApo8Szw1dYYYrerlrLBJGYziixZ/1xKKeNSWLFh+tAVRwc
	bAJGEq+O2YE0iAgoSGzufcYKUsMs8JxJ4uueuWwgCWEBN4m9B1tZQGwWAVWJ1e83ga3mFXCV
	+LxoNRPENgWJ1mWH2EFmcgLVr5liDxIWAiq5vfkUM8hMCYFN7BIvJvSyQswRkPg2+RALSL2E
	gKzEpgNQ30hKHFxxg2UCo/ACRoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIERcPrfs74d
	jDcPWB9iTAYaN5FZSjQ5HxhBeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphak
	FsUXleakFh9iZOLglGpgbKkzCQpXmLh3u8axr7fKTvTutiw+Obn9pmJpaR/7qocCTso7FbYa
	MiyPrS69Y/NPcuv1BMOPkmf+hdS4rk7yzmE7UBjheOanmmDjkx3WjjIrgkusKk3/75F/+2N2
	0X3ug0qyH1dllJVKvrDwCG0s0d1uciZfar3WuqfuB58a7TmZMfvL5oQJSizFGYmGWsxFxYkA
	XLs4J5YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQd1VAQZBBq33JS16F1xls9j0+Bqr
	xeVdc9gsZpzfx2Rxu3EFm0X/wl4mi/UzXrNYHJuxhNFi41cPiznT3zE5cHncubaHzWPzknqP
	vi2rGD0eLW5h9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8a1
	rj2MBSdCK35NOsnawHjctYuRk0NCwETi7aq1TBC2mMSFe+vZuhi5OIQEpjNK7Fl/nAnCaWOS
	WPHhOmsXIwcHm4CRxKtjdiANIgIKEpt7n7GC1DALPGeS+LpnLhtIQljATWLvwVYWEJtFQFVi
	9ftNzCA2r4CrxOdFq6G2KUi0LjvEDjKTE6h+zRR7kLAQUMntzaeYJzDyLmBkWMUomlqQXFCc
	lJ5rqFecmFtcmpeul5yfu4kRHF/PpHYwrmywOMQowMGoxMN7Q04/SIg1say4MvcQowQHs5II
	7wNTgyAh3pTEyqrUovz4otKc1OJDjMlAR01klhJNzgfGfl5JvKGxibmpsamliYWJmSVpwkri
	vAdarQOFBNITS1KzU1MLUotgtjBxcEo1MFoYtMxT/719h0aP14QVGp27Mp+ubDPcLLb+4Yxv
	5v4ScTteLD/zxt2G65eIW8JjodnCga82vXFNF5wUpOoW9pXFwsozrfOk2eTsoH9GO233FT7n
	Y7/c9+ir4QG/FrfOknP22j7zPy1xy54Z8KSPzcMpOe3TI95p7rHpDT8Npbn5VK48vuksrMRS
	nJFoqMVcVJwIAITEnCbzAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a common ASV(Adaptive Supply Voltage) basic framework
for samsung SoCs. It provides common APIs (to be called by users to get ASV
values or init opp_table) and an interface for SoC specific drivers to
register ASV members(instances).

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---

Hopefully asv_get_volt() can go out in future, once all users start using OPP
library.

---
 drivers/power/Kconfig                    |    1 +
 drivers/power/Makefile                   |    1 +
 drivers/power/asv/Kconfig                |   11 ++
 drivers/power/asv/Makefile               |    1 +
 drivers/power/asv/samsung-asv.c          |  175 ++++++++++++++++++++++++++++++
 include/linux/power/samsung-asv-driver.h |   61 +++++++++++
 include/linux/power/samsung-asv.h        |   37 +++++++
 7 files changed, 287 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/asv/Kconfig
 create mode 100644 drivers/power/asv/Makefile
 create mode 100644 drivers/power/asv/samsung-asv.c
 create mode 100644 include/linux/power/samsung-asv-driver.h
 create mode 100644 include/linux/power/samsung-asv.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 7b8979c..2e6b087 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -367,3 +367,4 @@ source "drivers/power/reset/Kconfig"
 endif # POWER_SUPPLY
 
 source "drivers/power/avs/Kconfig"
+source "drivers/power/asv/Kconfig"
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 653bf6c..da93c46 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
 obj-$(CONFIG_CHARGER_BQ2415X)	+= bq2415x_charger.o
 obj-$(CONFIG_POWER_AVS)		+= avs/
+obj-$(CONFIG_POWER_ASV)		+= asv/
 obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
 obj-$(CONFIG_CHARGER_TPS65090)	+= tps65090-charger.o
 obj-$(CONFIG_POWER_RESET)	+= reset/
diff --git a/drivers/power/asv/Kconfig b/drivers/power/asv/Kconfig
new file mode 100644
index 0000000..7cd84bd
--- /dev/null
+++ b/drivers/power/asv/Kconfig
@@ -0,0 +1,11 @@
+menuconfig POWER_ASV
+	bool "Adaptive Supply Voltage support"
+	help
+	  ASV is a technique used on samsung SoCs, which provides the
+	  recommended supply voltage for some specific parts(like arm, mif etc)
+	  of SoCs which supports dvfs. For a given operating frequency, the
+	  voltage is recommended based on SoCs ASV group.
+	  ASV group info is provided in the chip id info which depends on chip
+	  manufacturing process.
+
+	  Say Y here to enable Adaptive Supply voltage support.
diff --git a/drivers/power/asv/Makefile b/drivers/power/asv/Makefile
new file mode 100644
index 0000000..62921da
--- /dev/null
+++ b/drivers/power/asv/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_POWER_ASV)			+= asv.o
diff --git a/drivers/power/asv/asv.c b/drivers/power/asv/asv.c
new file mode 100644
index 0000000..61f4a83
--- /dev/null
+++ b/drivers/power/asv/asv.c
@@ -0,0 +1,175 @@
+/*
+ * ASV(Adaptive Supply Voltage) common core
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/io.h>
+#include <linux/opp.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/power/asv-driver.h>
+
+static LIST_HEAD(asv_list);
+static DEFINE_MUTEX(asv_mutex);
+
+struct asv_member {
+	struct list_head		node;
+	struct asv_info *asv_info;
+};
+
+static void add_asv_member(struct asv_member *asv_mem)
+{
+	mutex_lock(&asv_mutex);
+	list_add_tail(&asv_mem->node, &asv_list);
+	mutex_unlock(&asv_mutex);
+}
+
+static struct asv_member *asv_get_mem(enum asv_type_id asv_type)
+{
+	struct asv_member *asv_mem;
+	struct asv_info *asv_info;
+
+	list_for_each_entry(asv_mem, &asv_list, node) {
+		asv_info = asv_mem->asv_info;
+		if (asv_type == asv_info->type)
+			return asv_mem;
+	}
+
+	return NULL;
+}
+
+unsigned int asv_get_volt(enum asv_type_id target_type,
+						unsigned int target_freq)
+{
+	struct asv_member *asv_mem = asv_get_mem(target_type);
+	struct asv_freq_table *dvfs_table;
+	struct asv_info *asv_info;
+	unsigned int i;
+
+	if (!asv_mem)
+		return 0;
+
+	asv_info = asv_mem->asv_info;
+	dvfs_table = asv_info->dvfs_table;
+
+	for (i = 0; i < asv_info->nr_dvfs_level; i++) {
+		if (dvfs_table[i].freq == target_freq)
+			return dvfs_table[i].volt;
+	}
+
+	return 0;
+}
+
+int asv_init_opp_table(struct device *dev, enum asv_type_id target_type)
+{
+	struct asv_member *asv_mem = asv_get_mem(target_type);
+	struct asv_info *asv_info;
+	struct asv_freq_table *dvfs_table;
+	unsigned int i;
+
+	if (!asv_mem)
+		return -EINVAL;
+
+	asv_info = asv_mem->asv_info;
+	dvfs_table = asv_info->dvfs_table;
+
+	for (i = 0; i < asv_info->nr_dvfs_level; i++) {
+		if (opp_add(dev, dvfs_table[i].freq * 1000,
+			dvfs_table[i].volt)) {
+			dev_warn(dev, "%s: Failed to add OPP %d\n",
+				 __func__, dvfs_table[i].freq);
+			continue;
+		}
+	}
+
+	return 0;
+}
+
+static struct asv_member *asv_init_member(struct asv_info *asv_info)
+{
+	struct asv_member *asv_mem;
+	int ret = 0;
+
+	if (!asv_info) {
+		pr_err("%s: No ASV info provided\n", __func__);
+		return NULL;
+	}
+
+	asv_mem = kzalloc(sizeof(struct asv_member), GFP_KERNEL);
+	if (!asv_mem) {
+		pr_err("%s: Allocation failed for member: %s\n", __func__,
+			asv_info->name);
+		return NULL;
+	}
+
+	asv_mem->asv_info = kmemdup(asv_info, sizeof(*asv_info), GFP_KERNEL);
+	if (!asv_mem->asv_info) {
+		pr_err("%s: Copying asv_info failed for member: %s\n",
+			__func__, asv_info->name);
+		return NULL;
+	}
+	asv_info = asv_mem->asv_info;
+
+	if (asv_info->ops->get_asv_group) {
+		ret = asv_info->ops->get_asv_group(asv_info);
+		if (ret) {
+			pr_err("%s: get_asv_group failed for %s : %d\n",
+				__func__, asv_info->name, ret);
+			goto err;
+		}
+	}
+
+	if (asv_info->ops->init_asv)
+		ret = asv_info->ops->init_asv(asv_info);
+		if (ret) {
+			pr_err("%s: asv_init failed for %s : %d\n", __func__,
+				asv_info->name, ret);
+			goto err;
+		}
+
+	/* In case of parsing table from DT, we may need to add flag to identify
+	DT supporting members and call init_asv_table from asv_init_opp_table(
+	after getting dev_node from dev,if required), instead of calling here.
+	*/
+
+	if (asv_info->ops->init_asv_table) {
+		ret = asv_info->ops->init_asv_table(asv_info);
+		if (ret) {
+			pr_err("%s: init_asv_table failed for %s : %d\n",
+				__func__, asv_info->name, ret);
+			goto err;
+		}
+	}
+
+	if (!asv_info->nr_dvfs_level || !asv_info->dvfs_table) {
+		pr_err("%s: No dvfs_table for %s\n", __func__, asv_info->name);
+		goto err;
+	}
+
+	pr_info("%s: Registered asv member: %s with group: %d", __func__,
+		asv_info->name, asv_info->asv_grp);
+
+	return asv_mem;
+err:
+	kfree(asv_mem->asv_info);
+	kfree(asv_mem);
+	return NULL;
+}
+
+void register_asv_member(struct asv_info *list, unsigned int nr_member)
+{
+	struct asv_member *asv_mem;
+	int cnt;
+	for (cnt = 0; cnt < nr_member; cnt++) {
+		asv_mem = asv_init_member(&list[cnt]);
+
+		if (asv_mem)
+			add_asv_member(asv_mem);
+	}
+}
diff --git a/include/linux/power/asv-driver.h b/include/linux/power/asv-driver.h
new file mode 100644
index 0000000..faab388
--- /dev/null
+++ b/include/linux/power/asv-driver.h
@@ -0,0 +1,61 @@
+/*
+ * Adaptive Supply Voltage Driver Header File
+ *
+ * copyright (c) 2013 samsung electronics co., ltd.
+ *		http://www.samsung.com/
+ *
+ * this program is free software; you can redistribute it and/or modify
+ * it under the terms of the gnu general public license version 2 as
+ * published by the free software foundation.
+*/
+
+#ifndef __ASV_D_H
+#define __ASV_D_H __FILE__
+
+#include <linux/power/asv.h>
+
+struct asv_freq_table {
+	unsigned int	freq;	/* KHz */
+	unsigned int	volt;	/* uV */
+};
+
+/* struct asv_info - information of ASV member for intialisation
+ *
+ * Each member to be registered should be described using this struct
+ * intialised with all required information for that member.
+ *
+ * @asv_type: Type to identify particular member.
+ * @name: Name to used for member.
+ * @asv_ops: Callbacks which can be used for SoC specific operations.
+ * @nr_dvfs_level: Number of dvfs levels supported by member.
+ * @dvfs_table: Table containing supported ASV freqs and corresponding volts.
+ * @asv_grp: ASV group of member.
+ */
+struct asv_info {
+	const char		*name;
+	enum asv_type_id	type;
+	struct asv_ops		*ops;
+	unsigned int		nr_dvfs_level;
+	struct asv_freq_table	*dvfs_table;
+	unsigned int		asv_grp;
+	unsigned int		flags;
+};
+
+/* struct asv_ops - SoC specific operation for ASV members
+ * @get_asv_group - Calcuates and intializes asv_grp of asv_info.
+ * @init_asv - SoC specific intilisation(if anything required)based on asv_grp.
+ * @init_asv_table - Intializes linear array(dvfs_table) for corresponding
+ *		asv_grp.
+ *
+ * All ops should return 0 on sucess.
+ */
+struct asv_ops {
+	int (*init_asv)(struct asv_info *);
+	int (*get_asv_group)(struct asv_info *);
+	int (*init_asv_table)(struct asv_info *);
+};
+
+/* function for registering ASV members */
+void register_asv_member(struct asv_info *list, unsigned int nr_member);
+
+#endif /* __ASV_D_H */
diff --git a/include/linux/power/asv.h b/include/linux/power/asv.h
new file mode 100644
index 0000000..9b187f7
--- /dev/null
+++ b/include/linux/power/asv.h
@@ -0,0 +1,37 @@
+/*
+ * Adaptive Supply Voltage Header File
+ *
+ * copyright (c) 2013 samsung electronics co., ltd.
+ *		http://www.samsung.com/
+ *
+ * this program is free software; you can redistribute it and/or modify
+ * it under the terms of the gnu general public license version 2 as
+ * published by the free software foundation.
+*/
+
+#ifndef __ASV_H
+#define __ASV_H __FILE__
+
+enum asv_type_id {
+	ASV_ARM,
+	ASV_INT,
+	ASV_MIF,
+	ASV_G3D,
+};
+
+#ifdef CONFIG_POWER_ASV
+/* asv_get_volt - get the ASV for target_freq for particular target_type.
+ *	returns 0 if target_freq is not supported
+ */
+extern unsigned int asv_get_volt(enum asv_type_id target_type,
+					unsigned int target_freq);
+extern int asv_init_opp_table(struct device *dev,
+					enum asv_type_id target_type);
+#else
+static inline unsigned int asv_get_volt(enum asv_type_id target_type,
+				unsigned int target_freq) { return 0; }
+static int asv_init_opp_table(struct device *dev, enum asv_type_id target_type)
+	{ return 0; }
+
+#endif /* CONFIG_POWER_EXYNOS_AVS */
+#endif /* __ASV_H */
-- 
1.7.0.4

