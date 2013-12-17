Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3LQNXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:23:43 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25605 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3LQNXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:23:35 -0500
X-AuditID: cbfec7f4-b7fc96d000006cd4-d7-52b050564313
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
Subject: [PATCH 3/5] mfd: sec: Remove sec_reg* regmap helpers
Date: Tue, 17 Dec 2013 14:23:19 +0100
Message-id: <1387286601-21646-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xK7phARuCDK49ZbZouBpiMfXhEzaL
	+UfOsVr0v1nIanHgzw5Gi3OvVjJavH5haHG26Q27xf2vRxktvl3pYLJY2LaExeLyrjlsFmuP
	3GW3WHr9IpPFhOlrWSwOrzjAZLHu5XQWi5N/ehktTnezWlxc8YXJ4tiMJYwOoh5r5q1h9Fjw
	+Qq7x+W+XiaPnbPusnusXP6FzWPTqk42j1erZ7J63Lm2h81j3slAj74tqxg9Pm+SC+CO4rJJ
	Sc3JLEst0rdL4Mq4/v0Xa8EEsYq1898xNzB+Eepi5OSQEDCRmPHrCTuELSZx4d56ti5GLg4h
	gaWMEu/O/Ydy+pgkfv9oZwOpYhMwlti8fAmYLSJwjVXizJnQLkYODmaBGIkXU+xAwsICthJ7
	Vn0EK2ERUJX4suk+I0gJr4C7xI5n+iCmhICCxJxJNiAVnAIeEp+WnmABCQsBVWyfVzWBkXcB
	I8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJB4+LKDcfExq0OMAhyMSjy8O+avDxJiTSwr
	rsw9xCjBwawkwvvNY0OQEG9KYmVValF+fFFpTmrxIUYmDk6pBkbm2c377t5Su/Cx6ehkztVF
	PW+kJmzMfMgsIRmy8p9MlLDj3HPLrq6ewufDey7xvJ/h2l/LHus/7/UN/7TbSuy0iMjra53b
	t23/n192qvDbor35wWniSdOmPCpv3schmmF/u3+P+eKZrb/+Xq3SMr14qcKivnjmRq+Uj8v3
	GbAdntSwpia95UCaEktxRqKhFnNRcSIABVmU52UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove sec_reg* helpers as they are not used anymore. These helpers were
error-prone as they mixed u8 with unsigned int and they changed order of
some of parameters (val and mask in sec_reg_update()).

Also the helpers didn't give any way of useful abstraction as they just
called corresponding regmap function.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/mfd/sec-core.c           |   30 ------------------------------
 include/linux/mfd/samsung/core.h |    6 ------
 2 files changed, 36 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 83f31e2e5754..ab4c77b01f9f 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -79,36 +79,6 @@ static struct of_device_id sec_dt_match[] = {
 };
 #endif
 
-int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest)
-{
-	return regmap_read(sec_pmic->regmap_pmic, reg, dest);
-}
-EXPORT_SYMBOL_GPL(sec_reg_read);
-
-int sec_bulk_read(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf)
-{
-	return regmap_bulk_read(sec_pmic->regmap_pmic, reg, buf, count);
-}
-EXPORT_SYMBOL_GPL(sec_bulk_read);
-
-int sec_reg_write(struct sec_pmic_dev *sec_pmic, u8 reg, u8 value)
-{
-	return regmap_write(sec_pmic->regmap_pmic, reg, value);
-}
-EXPORT_SYMBOL_GPL(sec_reg_write);
-
-int sec_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf)
-{
-	return regmap_raw_write(sec_pmic->regmap_pmic, reg, buf, count);
-}
-EXPORT_SYMBOL_GPL(sec_bulk_write);
-
-int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 val, u8 mask)
-{
-	return regmap_update_bits(sec_pmic->regmap_pmic, reg, mask, val);
-}
-EXPORT_SYMBOL_GPL(sec_reg_update);
-
 static bool s2mps11_volatile(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index cab2dd279076..41c9bde410c5 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -59,12 +59,6 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic);
 void sec_irq_exit(struct sec_pmic_dev *sec_pmic);
 int sec_irq_resume(struct sec_pmic_dev *sec_pmic);
 
-extern int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest);
-extern int sec_bulk_read(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf);
-extern int sec_reg_write(struct sec_pmic_dev *sec_pmic, u8 reg, u8 value);
-extern int sec_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf);
-extern int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 val, u8 mask);
-
 struct sec_platform_data {
 	struct sec_regulator_data	*regulators;
 	struct sec_opmode_data		*opmode;
-- 
1.7.9.5

