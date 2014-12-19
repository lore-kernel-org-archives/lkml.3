Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaLSCrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:47:48 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14641 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaLSCrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:47:45 -0500
X-AuditID: cbfee68d-f79296d000004278-cf-549391c96f21
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH RESEND v2 10/10] power: charger-manager: Support to change
 polling rate in runtime.
Date: Fri, 19 Dec 2014 11:47:30 +0900
Message-id: <1418957250-6542-11-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkWPfkxMkhBpO2Glkc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2aLz7BNmi8u75rBZfO49wmhxu3EFm8XdU0fZLE7vLnHg8pjQ/4nRY+esu+we
	m1doeWxa1cnm0bdlFaPHitXf2T0+b5ILYI/isklJzcksSy3St0vgyvj1/ShTwRmxim+tK1ga
	GE8KdTFyckgImEicmnueGcIWk7hwbz1bFyMXh5DAUkaJ/VP/sMIUnZ5wmgkisYhRYu+pDewQ
	ThuTxI7LX9lAqtgEdCT+77vJDmKLCChIbO59xgpSxCxwhVHi5uL1TCAJYYFUiV137oKNZRFQ
	lVjwdAlYA6+Ah8SECXOA7uAAWqcgMWeSDUiYEyj89FIT2HwhAXeJE9/esoDMlBDYxy5xeP80
	Nog5AhLfJh9igeiVldh0AOodSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/
	dxMjMCpO/3vWu4Px9gHrQ4wCHIxKPLydhZNDhFgTy4orcw8xmgJtmMgsJZqcD4y9vJJ4Q2Mz
	IwtTE1NjI3NLMyVxXkWpn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGDPmpX628kia0xCh
	ZPLtn3EM07NZs6rcZxROFDm4k7GxRImvLOQqx7rYCwrppma30xgsdPOYFWXP2UW+tWS+efzO
	XRfua78f7f8yrZ//1vuJrKf2Z290j9ZU3dJ17v3EpAcSHfu/V5g/8JdIepku/HxTLoN2k6h1
	u4OZdE5qXbKmoJGaQV2dEktxRqKhFnNRcSIAeysMKYUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd2TEyeHGBzcq2VxcKumxfUvz1kt
	Jj15z2wxceVkZovOs0+YLS7vmsNm8bn3CKPF7cYVbBZ3Tx1lszi9u8SBy2NC/ydGj52z7rJ7
	bF6h5bFpVSebR9+WVYweK1Z/Z/f4vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhDWPGr+9HmQrOiFV8a13B0sB4UqiLkZNDQsBE4vSE00wQtpjEhXvr2boYuTiEBBYx
	Suw9tYEdwmljkthx+SsbSBWbgI7E/3032UFsEQEFic29z1hBipgFrjBK3Fy8HmyUsECqxK47
	d1lBbBYBVYkFT5eANfAKeEhMmDCHuYuRA2idgsScSTYgYU6g8NNLTWDzhQTcJU58e8sygZF3
	ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgmHsmvYNxVYPFIUYBDkYlHt6OwskhQqyJ
	ZcWVuYcYJTiYlUR4zTOBQrwpiZVVqUX58UWlOanFhxhNgY6ayCwlmpwPTAd5JfGGxiZmRpZG
	5oYWRsbmSuK8SvZtIUIC6YklqdmpqQWpRTB9TBycUg2MGqKud533Kh/d9Z/vScPCH3xTePJW
	LOzy+HFkadZjjm3F1aWMN3fMvXhlUauIsqOI++OLHMY+hbsa5C8JV1V+YT5qZd3Jt+ju7j0z
	Xqxc3fJyDcP+3JkrrRwqa6T+tPNltj4umMH7o8VM7fRU2RPShh8KFX/3nTUw3Ramx1Sw6f+G
	/V01x+oLlFiKMxINtZiLihMBf95Jys8CAAA=
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

