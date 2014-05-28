Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaE1Jjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:39:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36801 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaE1Jju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:39:50 -0400
X-AuditID: cbfee68f-b7fef6d000003970-92-5385aee411f5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/4] extcon: sm5502: Detect cable state after completing
 platform booting
Date: Wed, 28 May 2014 18:39:34 +0900
Message-id: <1401269976-12754-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1401269976-12754-1-git-send-email-cw00.choi@samsung.com>
References: <1401269976-12754-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWyRsSkUPfJutZggx1HlC2uf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6M1vlz2QqWi1V8uraQtYFx
	uVAXIyeHhICJRNeKzUwQtpjEhXvr2boYuTiEBJYySuz8coIRpmj708csILaQwHRGiYs3nSCK
	mpgkXrTPYgdJsAloSex/cYMNxBYRUJDY3PuMFcRmFoiXONvdDTZIWCBaoq+5F6ieg4NFQFVi
	1bRsEJNXwFXixlxWiFVyEh/2PAKbyCngJjFjxmE2iLWuEsuPHGQCWSsh8J5N4nH3Q7AEi4CA
	xLfJh1hA5kgIyEpsOsAMMUdS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/d
	xAgM09P/nvXvYLx7wPoQYzLQuInMUqLJ+cAwzyuJNzQ2M7IwNTE1NjK3NCNNWEmc9/7DpCAh
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjDPuejYkHl20fe6yX89/W21JanVKDV+jxqyvdiL1
	XsIpF9+J+pKTZ/AnOeiKPzmVrGKe9Nh1xvO1K912Wf5vPPgz5M7yhWHCm2RttS/seX9hgUPP
	H14uu+AfE+6+ttBc737+37qlihNqdjy4c/Vbwt3Pnves1h5uZn/m/PuTaNNW61MBF/R/mjsq
	sRRnJBpqMRcVJwIAbN47eWkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jQd0n61qDDb7Plba4/uU5q8XZpjfs
	Fpd3zWGzuN24gs2BxaNvyypGj8+b5AKYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCWsYM1rnz2UrWC5W8enaQtYGxuVCXYycHBICJhLbnz5mgbDFJC7cW88GYgsJTGeUuHjT
	qYuRC8huYpJ40T6LHSTBJqAlsf/FDbAiEQEFic29z1hBbGaBeImz3d2MILawQLREX3MvUD0H
	B4uAqsSqadkgJq+Aq8SNuawQq+QkPux5BDaRU8BNYsaMw1BrXSWWHznINIGRdwEjwypG0dSC
	5ILipPRcI73ixNzi0rx0veT83E2M4Ch4Jr2DcVWDxSFGAQ5GJR7eA4tbgoVYE8uKK3MPMUpw
	MCuJ8DotbQ0W4k1JrKxKLcqPLyrNSS0+xJgMdNNEZinR5HxghOaVxBsam5gZWRqZG1oYGZuT
	Jqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+OkCJt3J951uJevWjbpzmHzCw17TF0qONpu
	ZD+dF+v1oX9l8qsmwykaAs8Z5wvNvZJxn2WBiU6pl1loWFVpyV2VndP7lbv2bnjaz6V16012
	Za3Bs/cTf56ViHFcO7Fr7eIvPceiFZ3lNs5+kPa60fbuJ9PUPr2QudOafkvXmCXmn3kW6jR7
	yRclluKMREMt5qLiRADsd1qtxgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch detect whether cable is connected or not and the cable type
after completing kernel/platform booting using system_power_efficient_wq.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-sm5502.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/extcon/extcon-sm5502.c b/drivers/extcon/extcon-sm5502.c
index ebf3d5c..3588df0 100644
--- a/drivers/extcon/extcon-sm5502.c
+++ b/drivers/extcon/extcon-sm5502.c
@@ -28,6 +28,8 @@
 #include <linux/extcon.h>
 #include <linux/extcon/sm5502.h>
 
+#define	DELAY_MS_DEFAULT		17000	/* unit: millisecond */
+
 struct muic_irq {
 	unsigned int irq;
 	const char *name;
@@ -59,6 +61,14 @@ struct sm5502_muic_info {
 	unsigned int num_reg_data;
 
 	struct mutex mutex;
+
+	/*
+	 * Use delayed workqueue to detect cable state and then
+	 * notify cable state to notifiee/platform through uevent.
+	 * After completing the booting of platform, the extcon provider
+	 * driver should notify cable state to upper layer.
+	 */
+	struct delayed_work wq_detcable;
 };
 
 /* Default value of SM5502 register to bring up MUIC device. */
@@ -341,6 +351,8 @@ static int sm5502_muic_cable_handler(struct sm5502_muic_info *info,
 	case SM5502_MUIC_ADC_OPEN_USB_OTG:
 		idx = EXTCON_CABLE_USB_HOST;
 		break;
+	case SM5502_MUIC_ADC_GROUND:
+		break;
 	default:
 		dev_dbg(info->dev,
 			"cannot handle this cable_type (0x%x)\n", cable_type);
@@ -433,6 +445,18 @@ static irqreturn_t sm5502_muic_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static void sm5502_muic_detect_cable_wq(struct work_struct *work)
+{
+	struct sm5502_muic_info *info = container_of(to_delayed_work(work),
+				struct sm5502_muic_info, wq_detcable);
+	int ret;
+
+	/* Notify the state of connector cable or not  */
+	ret = sm5502_muic_cable_handler(info, true);
+	if (ret < 0)
+		dev_warn(info->dev, "failed to detect cable state\n");
+}
+
 static void sm5502_init_dev_type(struct sm5502_muic_info *info)
 {
 	unsigned int reg_data, vendor_id, version_id;
@@ -548,6 +572,18 @@ static int sm5022_muic_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
+	/*
+	 * Detect accessory after completing the initialization of platform
+	 *
+	 * - Use delayed workqueue to detect cable state and then
+	 * notify cable state to notifiee/platform through uevent.
+	 * After completing the booting of platform, the extcon provider
+	 * driver should notify cable state to upper layer.
+	 */
+	INIT_DELAYED_WORK(&info->wq_detcable, sm5502_muic_detect_cable_wq);
+	queue_delayed_work(system_power_efficient_wq, &info->wq_detcable,
+			msecs_to_jiffies(DELAY_MS_DEFAULT));
+
 	/* Initialize SM5502 device and print vendor id and version id */
 	sm5502_init_dev_type(info);
 
-- 
1.8.0

