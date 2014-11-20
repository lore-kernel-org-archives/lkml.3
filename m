Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbaKTTso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:48:44 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35520 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783AbaKTTsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:48:17 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] regulator: rpm: add support for RPM-controller SMB208
Date: Thu, 20 Nov 2014 13:41:25 -0600
Message-Id: <1416512485-7292-4-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416512485-7292-1-git-send-email-joshc@codeaurora.org>
References: <1416512485-7292-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IPQ8064 reference boards make use of SMB208 regulators which are
controlled by RPM.  Implement support for these regulators in the RPM
regulator driver.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/regulator/qcom_rpm-regulator.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/regulator/qcom_rpm-regulator.c b/drivers/regulator/qcom_rpm-regulator.c
index b869254..36c39e9 100644
--- a/drivers/regulator/qcom_rpm-regulator.c
+++ b/drivers/regulator/qcom_rpm-regulator.c
@@ -183,6 +183,13 @@ static const struct regulator_linear_range ftsmps_ranges[] = {
 	REGULATOR_LINEAR_RANGE(1500000,  64, 100, 50000),
 };
 
+static const struct regulator_linear_range smb208_ranges[] = {
+	REGULATOR_LINEAR_RANGE( 375000,   0,  29, 12500),
+	REGULATOR_LINEAR_RANGE( 750000,  30,  89, 12500),
+	REGULATOR_LINEAR_RANGE(1500000,  90, 153, 25000),
+	REGULATOR_LINEAR_RANGE(3100000, 154, 234, 25000),
+};
+
 static const struct regulator_linear_range ncp_ranges[] = {
 	REGULATOR_LINEAR_RANGE(1500000,   0,  31, 50000),
 };
@@ -559,6 +566,16 @@ static const struct qcom_rpm_reg pm8921_switch = {
 	.parts = &rpm8960_switch_parts,
 };
 
+static const struct qcom_rpm_reg smb208_smps = {
+	.desc.linear_ranges = smb208_ranges,
+	.desc.n_linear_ranges = ARRAY_SIZE(smb208_ranges),
+	.desc.n_voltages = 235,
+	.desc.ops = &uV_ops,
+	.parts = &rpm8960_smps_parts,
+	.supports_force_mode_auto = false,
+	.supports_force_mode_bypass = false,
+};
+
 static const struct of_device_id rpm_of_match[] = {
 	{ .compatible = "qcom,rpm-pm8058-pldo",     .data = &pm8058_pldo },
 	{ .compatible = "qcom,rpm-pm8058-nldo",     .data = &pm8058_nldo },
@@ -578,6 +595,8 @@ static const struct of_device_id rpm_of_match[] = {
 	{ .compatible = "qcom,rpm-pm8921-ftsmps",   .data = &pm8921_ftsmps },
 	{ .compatible = "qcom,rpm-pm8921-ncp",      .data = &pm8921_ncp },
 	{ .compatible = "qcom,rpm-pm8921-switch",   .data = &pm8921_switch },
+
+	{ .compatible = "qcom,rpm-smb208", .data = &smb208_smps },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, rpm_of_match);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

