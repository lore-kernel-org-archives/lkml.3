Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3CKCML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 22:12:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27663 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3CKCMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 22:12:06 -0400
X-AuditID: cbfee68e-b7f946d000001e37-a4-513d3d72ae38
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: devicetree-discuss@lists.ozlabs.org, khali@linux-fr.org,
        linux@roeck-us.net, dianders@chromium.org, naveenkrishna.ch@gmail.com,
        dg77.kim@samsung.com
Subject: [PATCH 2/2] hwmon: NTC: add IIO get channel and read support
Date: Mon, 11 Mar 2013 07:39:47 +0530
Message-id: <1362967787-22557-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1362967787-22557-1-git-send-email-ch.naveen@samsung.com>
References: <1362967787-22557-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSo1tsaxtoMOkmi8WB2Q9ZLT7ufc5s
	cXbZQTaLxr+RFpd3zWGzeLLwDJPFnWl72SwWbfvP7MDhMbvhIovHzll32T2uNJxk8zg/YyGj
	x4OJu9k8dn5vYPfo27KK0ePzJrkAjigum5TUnMyy1CJ9uwSujL4dd5gL3ihVTHszhbWB8bpM
	FyMHh4SAicTGHrkuRk4gU0ziwr31bF2MXBxCAksZJd7u+sgKkTCRmN00kwUiMZ1R4tyvPlYI
	p4dJ4uLdi2BVbAJmEgcXrWYHsUUErCUu73nNCFLELDCHUeLq7uuMIAlhAVeJp21vwBpYBFQl
	Fjc9YgY5gxcoPmNKBsRFChJzJtmAVHAKuEl82vwebKQQUMX7xissEAftY5f4f0kfYoqAxLfJ
	h1ggWmUlNh1ghiiRlDi44gbLBEbhBYwMqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzECI+H0
	v2d9OxhvHrA+xJgMNG4is5Rocj4wkvJK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnN
	Tk0tSC2KLyrNSS0+xMjEwSnVwNjof2NLZOaUgKqIiuKiIwIOcZvud91RVon6ky2gbad5wrK4
	8ZiNI/tLRv1DT3bVPwstnVB2SGb9nftpxyY6KAXU+WRdeqjTF17VWjZZy/3BnEVa807xy07b
	kTL3ur7Qx0mbN1xsbD0u5ah+wzksTXHbdbPjR7JSPn1YV+u4R/+NhtOiOexqZ5VYijMSDbWY
	i4oTAUNjQmGaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQd0iW9tAg10zrCwOzH7IavFx73Nm
	i7PLDrJZNP6NtLi8aw6bxZOFZ5gs7kzby2axaNt/ZgcOj9kNF1k8ds66y+5xpeEkm8f5GQsZ
	PR5M3M3msfN7A7tH35ZVjB6fN8kFcEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoa
	WlqYKynkJeam2iq5+AToumXmAJ2mpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gA
	DSSsYczo23GHueCNUsW0N1NYGxivy3QxcnJICJhIzG6ayQJhi0lcuLeerYuRi0NIYDqjxLlf
	fawQTg+TxMW7F1lBqtgEzCQOLlrNDmKLCFhLXN7zmhGkiFlgDqPE1d3XGUESwgKuEk/b3oA1
	sAioSixuesTcxcjBwQsUnzElA8SUEFCQmDPJBqSCU8BN4tPm92AjhYAq3jdeYZnAyLuAkWEV
	o2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCsPZPewbiqweIQowAHoxIP7wQd20Ah1sSy4src
	Q4wSHMxKIrwrN9kECvGmJFZWpRblxxeV5qQWH2JMBrppIrOUaHI+MA3klcQbGpuYmxqbWppY
	mJhZkiasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAPjwtOTTp+Qf3++5EhPlPGVDSZW3Ydv
	Nvhb++utijwkYXCP9fCR5eym81Rj+1973kn4vfimRnCFtNgf3tDQde9ereHi573Gc9FK6nH5
	g/BkBk6LioidK748YrbRMUtkyAxdvOj84t1NNhOePY3NlhC4kLChfcOX4+GzPtqu1Al4cqzf
	OFEvSYhTiaU4I9FQi7moOBEARe3N3PkCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support to work as a iio device.
iio_get_channel and iio_raw_read works.

During the probe ntc driver gets the respective channels of ADC
and uses iio_raw_read calls to get the ADC converted value.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---

Still not sure about the read_uV function parameter change and placement.

There were a few CamelCase warnings during checkpatch run.
I can clean them if anyone insists.

 drivers/hwmon/ntc_thermistor.c               |   36 +++++++++++++++++++++++++-
 include/linux/platform_data/ntc_thermistor.h |    7 ++++-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index cfedbd3..1d31260 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -30,6 +30,11 @@
 
 #include <linux/platform_data/ntc_thermistor.h>
 
+#include <linux/iio/iio.h>
+#include <linux/iio/machine.h>
+#include <linux/iio/driver.h>
+#include <linux/iio/consumer.h>
+
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 
@@ -162,6 +167,28 @@ struct ntc_data {
 	char name[PLATFORM_NAME_SIZE];
 };
 
+static int ntc_adc_read(struct ntc_thermistor_platform_data *pdata)
+{
+	struct iio_channel *channel = pdata->chan;
+	unsigned int result;
+	int val, ret;
+
+	if (!channel)
+		return -EINVAL;
+
+	ret = iio_read_channel_raw(channel, &val);
+	if (ret < 0) {
+		pr_err("read channel() error: %d\n", ret);
+		return ret;
+	}
+
+	/* unit: mV */
+	result = pdata->pullup_uV * (s64) val;
+	result >>= 12;
+
+	return result;
+}
+
 #ifdef CONFIG_OF
 static void ntc_thermistor_parse_dt(struct ntc_thermistor_platform_data *pdata,
 							struct device_node *np)
@@ -173,6 +200,8 @@ static void ntc_thermistor_parse_dt(struct ntc_thermistor_platform_data *pdata,
 		pdata->connect = NTC_CONNECTED_POSITIVE;
 	else /* status change should be possible if not always on. */
 		pdata->connect = NTC_CONNECTED_GROUND;
+
+	pdata->read_uV = ntc_adc_read;
 }
 #else
 static void
@@ -317,7 +346,7 @@ static int ntc_thermistor_get_ohm(struct ntc_data *data)
 		return data->pdata->read_ohm(data->pdev);
 
 	if (data->pdata->read_uV) {
-		read_uV = data->pdata->read_uV(data->pdev);
+		read_uV = data->pdata->read_uV(data->pdata);
 		if (read_uV < 0)
 			return read_uV;
 		return get_ohm_of_thermistor(data, read_uV);
@@ -417,6 +446,8 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
+	pdata->chan = iio_channel_get(&pdev->dev, NULL);
+
 	data->dev = &pdev->dev;
 	data->pdev = pdev;
 	data->pdata = pdata;
@@ -457,15 +488,18 @@ static int ntc_thermistor_probe(struct platform_device *pdev)
 	return 0;
 err_after_sysfs:
 	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
+	iio_channel_release(pdata->chan);
 	return ret;
 }
 
 static int ntc_thermistor_remove(struct platform_device *pdev)
 {
 	struct ntc_data *data = platform_get_drvdata(pdev);
+	struct ntc_thermistor_platform_data *pdata = data->pdata;
 
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&data->dev->kobj, &ntc_attr_group);
+	iio_channel_release(pdata->chan);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
diff --git a/include/linux/platform_data/ntc_thermistor.h b/include/linux/platform_data/ntc_thermistor.h
index 18f3c3a..671d056 100644
--- a/include/linux/platform_data/ntc_thermistor.h
+++ b/include/linux/platform_data/ntc_thermistor.h
@@ -34,19 +34,24 @@ struct ntc_thermistor_platform_data {
 	 *
 	 * pullup_uV, pullup_ohm, pulldown_ohm, and connect are required to use
 	 * read_uV()
+	 * takes the platform data structure as the parameter
 	 *
 	 * How to setup pullup_ohm, pulldown_ohm, and connect is
 	 * described at Documentation/hwmon/ntc_thermistor
 	 *
 	 * pullup/down_ohm: 0 for infinite / not-connected
+	 *
+	 * iio_channel to communicate with the ADC which the
+	 * thermistor is using for conversion of the analog values.
 	 */
-	int (*read_uV)(struct platform_device *);
+	int (*read_uV)(struct ntc_thermistor_platform_data *);
 	int (*read_ohm)(struct platform_device *);
 	unsigned int pullup_uV;
 
 	unsigned int pullup_ohm;
 	unsigned int pulldown_ohm;
 	enum { NTC_CONNECTED_POSITIVE, NTC_CONNECTED_GROUND } connect;
+	struct iio_channel *chan;
 };
 
 #endif /* _LINUX_NTC_H */
-- 
1.7.9.5

