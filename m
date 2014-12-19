Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaLSIzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:55:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20572 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaLSIzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:55:38 -0500
X-AuditID: cbfee691-f79b86d000004a5a-67-5493e804257a
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH V3 11/11] power: charger-manager: Support to change polling
 rate in runtime.
Date: Fri, 19 Dec 2014 17:55:23 +0900
Message-id: <1418979323-7188-12-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkQJflxeQQg0U7hCwObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZfS/+89UcFas4tCb10wN
	jKeEuhg5OCQETCQu3BftYuQEMsUkLtxbz9bFyMUhJLCUUeLXgwmsMDX3/4lBxKczSlxYfhuq
	qI1J4vODT+wg3WwCOhL/990Es0UEFCQ29z5jBSliFrjCKHFz8XomkISwQJzEsR3vwIpYBFQl
	9h3fxQZi8wp4SNx9NY8NYpuCxJxJNiBhTqDwn5NbwFqFBNwlGrd8ZweZKSGwi11i5ZMpjBBz
	BCS+TT7EAtErK7HpADPEN5ISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kalecWJucWleul5yfu4m
	RmBEnP73bOIOxvsHrA8xCnAwKvHwPiieHCLEmlhWXJl7iNEUaMNEZinR5Hxg3OWVxBsamxlZ
	mJqYGhuZW5opifPqSP8MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAoEh5VtdTQ17/BYKGJ
	3itl/nmf/8ae3SoWsFy08kyYb7R1m/IR4fV3bn0o+256pd3yj0aCVcqMtRI6dv3ZC/Y4V1X7
	b9qXVrL27VddDS2xZ7UtMlmzb6/mXpDhqb659Kts0fKN4bMeC28L+GO3vevn948Pv7zMfxVx
	++HjbzMLXqctY5444XSVEktxRqKhFnNRcSIA594sb4MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jQV2WF5NDDF43cFkc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2aLz7BNmi8u75rBZfO49wmhxu3EFm8XdU0fZLE7vLnHg8pjQ/4nRY+esu+we
	m1doeWxa1cnm0bdlFaPHitXf2T0+b5ILYI9qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBc
	j5EBGkhYw5jR/+4/U8FZsYpDb14zNTCeEupi5OCQEDCRuP9PrIuRE8gUk7hwbz1bFyMXh5DA
	dEaJC8tvQzltTBKfH3xiB6liE9CR+L/vJpgtIqAgsbn3GStIEbPAFUaJm4vXM4EkhAXiJI7t
	eAdWxCKgKrHv+C42EJtXwEPi7qt5bBCbFSTmTLIBCXMChf+c3ALWKiTgLtG45Tv7BEbeBYwM
	qxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCI+6Z9A7GVQ0WhxgFOBiVeHg7CieHCLEmlhVX
	5h5ilOBgVhLhdTwOFOJNSaysSi3Kjy8qzUktPsRoCnTURGYp0eR8YDLIK4k3NDYxM7I0Mje0
	MDI2VxLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpg1NBo/jJlZ9Sm8u1HfJbEnInckF/tFf71
	tZ+anwuLXN/9E28tE07lbVXgnOvc/sdaZF7okuunF3rcr9GZdm5/8M+yzIfHplbYqCpP+3nb
	XPSz0J3ne553b/x0dUOT1AE7oYTdD57wKDQszjVuLqszar9yJ/2yr4DAjcCKq39UbuYYnxY0
	vWAuoMRSnJFoqMVcVJwIAGe1NtXOAgAA
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
index f5787bc..a8cabf09 100644
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

