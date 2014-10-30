Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019AbaJ3Mni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:43:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23881 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759976AbaJ3Mne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:34 -0400
X-AuditID: cbfee68e-f79b46d000002b74-16-5452326a2a25
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 10/10] power: charger-manager: Support to change polling rate
 in runtime.
Date: Thu, 30 Oct 2014 21:43:16 +0900
Message-id: <1414672996-28355-11-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkUDfLKCjE4NJ0M4uDWzUtrn95zmox
	6cl7ZouJKyczW3SefcJscXnXHDaLz71HGC1uN65gs7h76iibxendJQ5cHhP6PzF67Jx1l91j
	8wotj02rOtk8+rasYvRYsfo7u8fnTXIB7FFcNimpOZllqUX6dglcGb++H2UqOCNW8a11BUsD
	40mhLkZODgkBE4nLux6wQthiEhfurWfrYuTiEBJYyihx5ccXZpiivuP7oRKLGCVWPXnNDuG0
	MUncaVrBDlLFJqAj8X/fTTBbREBBYnPvM1aQImaBK4wSNxevZwJJCAtES0xbfwbMZhFQlVi4
	fy+YzSvgKTH9zUIgmwNonYLEnEk2IGFOoPCmKzNZQGwhAQ+JB7u6wBZLCOxil/h0bwIjxBwB
	iW+TD7FA9MpKbDoAdbWkxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iREY
	Faf/PevbwXjzgPUhRgEORiUeXo0TgSFCrIllxZW5hxhNgTZMZJYSTc4Hxl5eSbyhsZmRhamJ
	qbGRuaWZkjhvgtTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M+W5z2QW6flhzzGlJU+5f
	LvvaWfLPev+NfNXzZb+97V7oL7fM6+UZhntvmNNPmvZfnFd2mafgh2bnnYzHQT8cFxvUXrta
	X5bLbrzt+I7FtimH9vBc6Zsz4/KTuwKtk5Y8O/p5V6OsNutJz29ZH1ZFb7c2unP9YfmNvB0L
	r/F955xa6hTMeKAmTYmlOCPRUIu5qDgRACJN+w6FAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd0so6AQg6UdehYHt2paXP/ynNVi
	0pP3zBYTV05mtug8+4TZ4vKuOWwWn3uPMFrcblzBZnH31FE2i9O7Sxy4PCb0f2L02DnrLrvH
	5hVaHptWdbJ59G1ZxeixYvV3do/Pm+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0M
	DHUNLS3MlRTyEnNTbZVcfAJ03TJzgK5TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTX
	Y2SABhLWMGb8+n6UqeCMWMW31hUsDYwnhboYOTkkBEwk+o7vZ4OwxSQu3FsPZHNxCAksYpRY
	9eQ1O4TTxiRxp2kFO0gVm4COxP99N8FsEQEFic29z1hBipgFrjBK3Fy8ngkkISwQLTFt/Rkw
	m0VAVWLh/r1gNq+Ap8T0NwuBbA6gdQoScybZgIQ5gcKbrsxkAbGFBDwkHuzqYp/AyLuAkWEV
	o2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDMPZPewbiqweIQowAHoxIPr8aJwBAh1sSy4src
	Q4wSHMxKIrxHdYJChHhTEiurUovy44tKc1KLDzGaAh01kVlKNDkfmA7ySuINjU3MjCyNzA0t
	jIzNlcR5D7ZaBwoJpCeWpGanphakFsH0MXFwSjUw5izOYi2cv//piXdLtxlXXdtiN2P+wyO9
	nVwHPlx+bVrtNtNoR1Z6cPVE3YYkhyKbqSVX3zwIWH2I68n22DuRZquWndWy/qJX9F3iTebc
	aV2JP5bvrdTgqZK081znIsekF/lK63fqr9X11+t/JbNzGCj+6I8NZrvrnhv+y81yg9Q9G+f9
	pWFZSizFGYmGWsxFxYkAkYziG88CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'polling_ms' sysfs node to change charger-manager's monitoring rate
in runtime. It can set only bigger than 2 jiffies (for 200 HZ system it
is 10 msecs.) as it's allowed for minimum poling rate in previous.
It resets poller and re-configure polling rate based on new input if next
polling time is far enough. Otherwise, it just waits expiration of timer
and new polling rate will affects the next scheduling.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/power/charger-manager.c |   62 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 0a0834f..7a007f4 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1054,6 +1054,63 @@ static ssize_t charger_externally_control_store(struct device *dev,
 	return count;
 }
 
+static ssize_t show_polling_ms(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct charger_manager *cm;
+	ssize_t len;
+
+	list_for_each_entry(cm, &cm_list, entry)
+		if (cm->charger_psy.dev == dev)
+			break;
+
+	if (cm->charger_psy.dev != dev)
+		return -EINVAL;
+
+	len = sprintf(buf, "%d\n", cm->desc->polling_interval_ms);
+
+	return len;
+}
+
+static ssize_t store_polling_ms(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	struct charger_manager *cm;
+	int polling_ms;
+	int ret;
+
+	ret = sscanf(buf, "%d", &polling_ms);
+	if (ret < 0 )
+		return -EINVAL;
+
+	if (polling_ms < CM_JIFFIES_SMALL * MSEC_PER_SEC / HZ)
+		return -EINVAL;
+
+	list_for_each_entry(cm, &cm_list, entry)
+		if (cm->charger_psy.dev == dev)
+			break;
+
+	if (cm->charger_psy.dev != dev)
+		return -ENODEV;
+
+	cm->desc->polling_interval_ms = polling_ms;
+
+	pr_info("Polling interval's changed to %u ms.\n",
+		cm->desc->polling_interval_ms);
+
+	if (next_polling - jiffies >
+		msecs_to_jiffies(cm->desc->polling_interval_ms)) {
+		pr_info("Reset poller now... \n");
+		cancel_delayed_work(&cm_monitor_work);
+		schedule_work(&setup_polling);
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR(polling_ms, 0644, show_polling_ms, store_polling_ms);
+
 /**
  * charger_manager_register_sysfs - Register sysfs entry for each charger
  * @cm: the Charger Manager representing the battery.
@@ -1077,6 +1134,11 @@ static int charger_manager_register_sysfs(struct charger_manager *cm)
 	int ret = 0;
 	int i;
 
+	/* Create polling_ms sysfs node */
+	ret = device_create_file(cm->charger_psy.dev, &dev_attr_polling_ms);
+	if (ret)
+		pr_err("Failed to create poling_ms sysfs node (%d)\n", ret);
+
 	/* Create sysfs entry to control charger(regulator) */
 	for (i = 0; i < desc->num_charger_regulators; i++) {
 		charger = &desc->charger_regulators[i];
-- 
1.7.9.5

