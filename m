Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3LQJ2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:28:36 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8391 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3LQJ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:28:33 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f6f6d000005b3b-3e-52b0193f3e6e
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>, linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH mfd-next] mfd: max14577 and sec: add PM_SLEEP dependency to
 suspend/resume
Date: Tue, 17 Dec 2013 10:28:25 +0100
Message-id: <1387272505-4621-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xy7r2khuCDK7tFbV4/cLQ4v7Xo4wW
	l3fNYbM43c1qcXHFFyaLrXuvsjuweTTeuMHmcefaHjaPeScDPfq2rGL0+LxJLoA1issmJTUn
	syy1SN8ugSvjWd9OtoL7/BVt5xeyNTCu4e1i5OSQEDCRODR7MyOELSZx4d56ti5GLg4hgaWM
	Ekt2nWECSfAKCEr8mHyPpYuRg4NZQF7iyKVskDCzgLrEpHmLmCHq+5gk9jU1s4Mk2ASMJTYv
	XwI2SESgj1Fi2cp5bBAdMRJP3m4H2yYMZN/e1swMYrMIqEr0NsxmAlnAK+AmcaK7AMSUEFCQ
	mDPJZgIj3ywkV8xCuGIWkisWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJ0K87GJce
	szrEKMDBqMTDe2DZ+iAh1sSy4srcQ4wSHMxKIrwsBUAh3pTEyqrUovz4otKc1OJDjEwcnFIN
	jKlPbXyvmD1o0mFre6m3YOP9WcXndqfe3MP8TzcnfoISp6tnmaKo0PvZu2ZYSvDGCmixRwe0
	WM2bP8PH512/g/8Rhzuyn8yUKySk5M+nyAXu0r/3PJmjwDlzk8zKNSYz5hozPVzVnHfx+NmY
	P1uWuh35Lv+7cfOjDUa3vpmqcgeLnBMSeJu/QomlOCPRUIu5qDgRADeFgekuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_PM_SLEEP dependency to suspend and resume functions of
max14577 MFD driver and sec-core.c code.

This fixes the warnings:
drivers/mfd/max14577.c:176:12: warning: ‘max14577_suspend’ defined but not used [-Wunused-function]
drivers/mfd/max14577.c:199:12: warning: ‘max14577_resume’ defined but not used [-Wunused-function]
drivers/mfd/sec-core.c:347:12: warning: ‘sec_pmic_suspend’ defined but not used [-Wunused-function]
drivers/mfd/sec-core.c:369:12: warning: ‘sec_pmic_resume’ defined but not used [-Wunused-function]

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max14577.c |    2 ++
 drivers/mfd/sec-core.c |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index a5e1c370c609..1018a6644469 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -173,6 +173,7 @@ static const struct i2c_device_id max14577_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
 
+#ifdef CONFIG_PM_SLEEP
 static int max14577_suspend(struct device *dev)
 {
 	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
@@ -208,6 +209,7 @@ static int max14577_resume(struct device *dev)
 
 	return 0;
 }
+#endif /* CONFIG_PM_SLEEP */
 
 static struct of_device_id max14577_dt_match[] = {
 	{ .compatible = "maxim,max14577", },
diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 56615af42a28..455e3a8fb95d 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -343,6 +343,7 @@ static int sec_pmic_remove(struct i2c_client *i2c)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int sec_pmic_suspend(struct device *dev)
 {
 	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
@@ -377,6 +378,7 @@ static int sec_pmic_resume(struct device *dev)
 
 	return 0;
 }
+#endif /* CONFIG_PM_SLEEP */
 
 static SIMPLE_DEV_PM_OPS(sec_pmic_pm_ops, sec_pmic_suspend, sec_pmic_resume);
 
-- 
1.7.9.5

