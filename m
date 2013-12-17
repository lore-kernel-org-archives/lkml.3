Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3LQNXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:23:40 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25084 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab3LQNXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:23:34 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-00-52b05054c3e0
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/5] regulator: s5m8767: Add symbols for hard-coded DVS_RAMP
 register
Date: Tue, 17 Dec 2013 14:23:17 +0100
Message-id: <1387286601-21646-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xK7ohARuCDH5vE7BouBpiMfXhEzaL
	+UfOsVr0v1nIanHgzw5Gi3OvVjJavH5haHG26Q27xf2vRxktvl3pYLJY2LaExeLyrjlsFmuP
	3GW3WHr9IpPFhOlrWSwOrzjAZLHu5XQWi5N/ehktTnezWlxc8YXJ4tiMJYwOoh5r5q1h9Fjw
	+Qq7x+W+XiaPnbPusnusXP6FzWPTqk42j1erZ7J63Lm2h81j3slAj74tqxg9Pm+SC+CO4rJJ
	Sc3JLEst0rdL4MrYu/MgS8E/0YrDV3+wNDD2CnUxcnJICJhInN20nwnCFpO4cG89WxcjF4eQ
	wFJGiVU35zBBOH1MEle/v2YFqWITMJbYvHwJG4gtInCNVeLMmdAuRg4OZoEYiRdT7EDCwgLh
	El83bmUHsVkEVCXm/JjIDGLzCrhLbFu+hxWkXEJAQWLOJBuQMKeAh8SnpSdYQMJCQCXb51VN
	YORdwMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkIr7uYFx6zOoQowAHoxIP74Fl64OE
	WBPLiitzDzFKcDArifB+89gQJMSbklhZlVqUH19UmpNafIiRiYNTqoFRx+/i+/bpn2qdijkv
	17IX+ps0MbR6/JNZsiB6suLiLSZ1qU36C9/bekqnixtutH3yfNHkv/GGzysCmjY8vyEmzMRx
	+KPqEl/RJw9XXQl3W/Bo/pQVt3U1j+25Mrf0xT8/9vMrRBLu7/a5dXq5zfxAd+63j6Zrif4W
	nGU/f9+OEysvNf5fdlZtsxJLcUaioRZzUXEiAKlLfftmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add symbols for hard-coded values of BUCK_RAMP field in DVS_RAMP
register. This simplifies a little the code as register update is called
only once.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/s5m8767.c         |   22 ++++++++++------------
 include/linux/mfd/samsung/s5m8767.h |   15 +++++++++++++++
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 397917611ecd..10b4b6a5b08e 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -881,31 +881,29 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 
 	if (s5m8767->buck2_ramp || s5m8767->buck3_ramp
 		|| s5m8767->buck4_ramp) {
+		unsigned int val;
 		switch (s5m8767->ramp_delay) {
 		case 5:
-			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					0x40, 0xf0);
+			val = S5M8767_DVS_BUCK_RAMP_5;
 			break;
 		case 10:
-			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					0x90, 0xf0);
+			val = S5M8767_DVS_BUCK_RAMP_10;
 			break;
 		case 25:
-			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					0xd0, 0xf0);
+			val = S5M8767_DVS_BUCK_RAMP_25;
 			break;
 		case 50:
-			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					0xe0, 0xf0);
+			val = S5M8767_DVS_BUCK_RAMP_50;
 			break;
 		case 100:
-			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					0xf0, 0xf0);
+			val = S5M8767_DVS_BUCK_RAMP_100;
 			break;
 		default:
-			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					0x90, 0xf0);
+			val = S5M8767_DVS_BUCK_RAMP_10;
 		}
+		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+					val << S5M8767_DVS_BUCK_RAMP_SHIFT,
+					S5M8767_DVS_BUCK_RAMP_MASK);
 	}
 
 	for (i = 0; i < pdata->num_regulators; i++) {
diff --git a/include/linux/mfd/samsung/s5m8767.h b/include/linux/mfd/samsung/s5m8767.h
index 9198377ee859..2ab0b0f03641 100644
--- a/include/linux/mfd/samsung/s5m8767.h
+++ b/include/linux/mfd/samsung/s5m8767.h
@@ -186,4 +186,19 @@ enum s5m8767_regulators {
 #define S5M8767_ENCTRL_SHIFT		6
 #define S5M8767_ENCTRL_MASK		(0x3 << S5M8767_ENCTRL_SHIFT)
 
+/*
+ * Values for BUCK_RAMP field in DVS_RAMP register, matching raw values
+ * in mV/us.
+ */
+enum s5m8767_dvs_buck_ramp_values {
+	S5M8767_DVS_BUCK_RAMP_5		= 0x4,
+	S5M8767_DVS_BUCK_RAMP_10	= 0x9,
+	S5M8767_DVS_BUCK_RAMP_12_5	= 0xb,
+	S5M8767_DVS_BUCK_RAMP_25	= 0xd,
+	S5M8767_DVS_BUCK_RAMP_50	= 0xe,
+	S5M8767_DVS_BUCK_RAMP_100	= 0xf,
+};
+#define S5M8767_DVS_BUCK_RAMP_SHIFT	4
+#define S5M8767_DVS_BUCK_RAMP_MASK	(0xf << S5M8767_DVS_BUCK_RAMP_SHIFT)
+
 #endif /* __LINUX_MFD_S5M8767_H */
-- 
1.7.9.5

