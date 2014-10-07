Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaJGK7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:59:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14259 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaJGK6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:58:49 -0400
X-AuditID: cbfee68d-f79296d000004278-93-5433c766518c
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        jenny.tc@intel.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 1/3] power: core: Add generic interface to get battery
 specification.
Date: Tue, 07 Oct 2014 19:58:36 +0900
Message-id: <1412679518-21499-2-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkQDf9uHGIwXQHi4NbNS0mPXnPbDFx
	5WRmi7Vfe9gtOs8+Yba4vGsOm8Xn3iOMFndPHWWzOL27xIHTY0L/J0aPnbPusntsXqHlsXjP
	SyaPTas62Tz6tqxi9Fix+ju7x+dNcgEcUVw2Kak5mWWpRfp2CVwZ22ZzFZxTqrjQu4qxgfGm
	bBcjJ4eEgInEx32djBC2mMSFe+vZuhi5OIQEljJK9Bx+zwpT9Of9FxaIxHRGiVVn10JVtTFJ
	HP42hQ2kik1AR+L/vpvsILaIgILE5t5nYN3MAtsZJeZ+SgaxhQXCJToOtjKD2CwCqhJv5iwH
	W80r4CFx+O8KIJsDaJuCxJxJNiBhTgFPicbb7SwgthBQyaIHb1lB9koI7GKX2LRlGxPEHAGJ
	b5MPsUD0ykpsOsAMcbSkxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iREY
	D6f/PevdwXj7gPUhRgEORiUe3hVaxiFCrIllxZW5hxhNgTZMZJYSTc4HRl1eSbyhsZmRhamJ
	qbGRuaWZkjivotTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mi5tk7rjfX7D+xbbW/siq
	G/X3tPkalxoKOkZPLLV98lvQyum+WeP53DkfP+qWvxY6xBds0Ly84V6M2EoV/8M5TXIFzRMK
	G7o3aL6W2Ob30eun/8cMGZ3APWH1mw5z/DTuV+MvkJdYzrR93tabdbrXBW8cXmCcs2jKgguS
	11tKfk+IObevsX26EktxRqKhFnNRcSIASkP0W4ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQd2048YhBk/+m1gc3KppMenJe2aL
	iSsnM1us/drDbtF59gmzxeVdc9gsPvceYbS4e+oom8Xp3SUOnB4T+j8xeuycdZfdY/MKLY/F
	e14yeWxa1cnm0bdlFaPHitXf2T0+b5IL4IhqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBc
	j5EBGkhYw5ixbTZXwTmligu9qxgbGG/KdjFyckgImEj8ef+FBcIWk7hwbz1bFyMXh5DAdEaJ
	VWfXQjltTBKHv01hA6liE9CR+L/vJjuILSKgILG59xkriM0ssJ1RYu6nZBBbWCBcouNgKzOI
	zSKgKvFmznJGEJtXwEPi8N8VQDYH0DYFiTmTbEDCnAKeEo2328GOEAIqWfTgLesERt4FjAyr
	GEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLj7ZnUDsaVDRaHGAU4GJV4eFdoGYcIsSaWFVfm
	HmKU4GBWEuEtOwYU4k1JrKxKLcqPLyrNSS0+xGgKdNREZinR5HxgKsgriTc0NjEzsjQyN7Qw
	MjZXEuc90GodKCSQnliSmp2aWpBaBNPHxMEp1cC4cNehlZyzN5wPTDyte25e7XO3DvUre1Of
	CRmIKD+QES1IvL8/otTzQsk14ys3J5dPun3wvdoNkyMNrVu8D/q7z7xwR5b7StQB4Y1hb0zf
	TP1ndlHpfPnuBkWFU23LA7adFlh/bgF74JX2GeWnZn8N5hGYznbv06Jskc13xO1qhYoTbzOe
	tOj4ocRSnJFoqMVcVJwIAOHLmK/NAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In power supply system, battery specification's dealt as static
information regardless of battery chainging. And it often assumed
fuelgauge's role to hold battery specification even same driver is
used with different batteries. To make subsystem handles above cases
properly, this patch adds helper functions to manager the battery
specification.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/power/power_supply_core.c |   91 +++++++++++++++++++++++++++++++++++++
 include/linux/power_supply.h      |    7 +++
 2 files changed, 98 insertions(+)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 078afd6..59207d9 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -653,6 +653,97 @@ static void __exit power_supply_class_exit(void)
 subsys_initcall(power_supply_class_init);
 module_exit(power_supply_class_exit);
 
+/****************************************************************
+ *                   Battery information interface              *
+ ****************************************************************/
+
+ATOMIC_NOTIFIER_HEAD(psy_battery_info_notifier);
+static LIST_HEAD(psy_battery_info_list);
+
+struct psy_battery_info {
+	struct list_head entry;
+	struct power_supply_info *info;
+};
+
+enum battery_info_notifier_events {
+	PSY_BATT_INFO_REGISTERED,
+	PSY_BATT_INFO_UNREGISTERED,
+};
+
+int psy_battery_info_notifier_register(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&psy_battery_info_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(psy_battery_info_notifier_register);
+
+void psy_battery_info_notifier_unregister(struct notifier_block *nb)
+{
+	atomic_notifier_chain_unregister(&psy_battery_info_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(psy_battery_info_notifier_unregister);
+
+struct power_supply_info *psy_get_battery_info(const char *name)
+{
+	struct psy_battery_info *battery;
+
+	/* Sanity check */
+	if (!name)
+		goto err_out;
+
+	list_for_each_entry(battery, &psy_battery_info_list, entry) {
+		if (!strcmp(battery->info->name, name))
+			return battery->info;
+	}
+
+err_out:
+	return NULL;
+}
+EXPORT_SYMBOL(psy_get_battery_info);
+
+int psy_register_battery_info(struct power_supply_info *info)
+{
+	struct psy_battery_info *battery;
+
+	/* Sanity check */
+	if (!info->name)
+		return -EINVAL;
+
+	/* Check if same data is existed */
+	list_for_each_entry(battery, &psy_battery_info_list, entry)
+		if (!strcmp(battery->info->name, info->name))
+			return -EEXIST;
+
+	battery = kzalloc(sizeof(*battery), GFP_KERNEL);
+	if (!battery)
+		return -ENOMEM;
+
+	battery->info = info;
+	list_add_tail(&battery->entry, &psy_battery_info_list);
+
+	atomic_notifier_call_chain(&psy_battery_info_notifier,
+				PSY_BATT_INFO_REGISTERED, info);
+
+	return 0;
+}
+EXPORT_SYMBOL(psy_register_battery_info);
+
+void psy_unregister_battery_info(struct power_supply_info *info)
+{
+	struct psy_battery_info *battery, *tmp;
+
+	list_for_each_entry_safe(battery, tmp, &psy_battery_info_list, entry) {
+		if (battery->info == info) {
+			list_del(&battery->entry);
+			kfree(battery);
+			return;
+		}
+	}
+
+	atomic_notifier_call_chain(&psy_battery_info_notifier,
+				PSY_BATT_INFO_UNREGISTERED, info);
+}
+EXPORT_SYMBOL(psy_unregister_battery_info);
+
 MODULE_DESCRIPTION("Universal power supply monitor class");
 MODULE_AUTHOR("Ian Molton <spyro@f2s.com>, "
 	      "Szabolcs Gyurko, "
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index f3dea41..99306aa 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -276,6 +276,13 @@ extern int power_supply_powers(struct power_supply *psy, struct device *dev);
 /* For APM emulation, think legacy userspace. */
 extern struct class *power_supply_class;
 
+/* Battery information helper */
+extern int psy_battery_info_notifier_register(struct notifier_block *);
+extern void psy_battery_info_notifier_unregister(struct notifier_block *);
+extern struct power_supply_info *psy_get_battery_info(const char *);
+extern int psy_register_battery_info(struct power_supply_info *);
+extern void psy_unregister_battery_info(struct power_supply_info *);
+
 static inline bool power_supply_is_amp_property(enum power_supply_property psp)
 {
 	switch (psp) {
-- 
1.7.9.5

