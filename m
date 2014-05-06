Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934124AbaEFGiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:38:05 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27488 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934029AbaEFGh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:37:58 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-d3-53688344f940
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 3/3] regulator: s2mpa01: Use rdev_get_id() to access id of
 regulator
Date: Tue, 06 May 2014 08:37:38 +0200
Message-id: <1399358258-21536-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399358258-21536-1-git-send-email-k.kozlowski@samsung.com>
References: <1399358258-21536-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJJMWRmVeSWpSXmKPExsVy+t/xK7ouzRnBBut/M1scmfOV2WLqwyds
	Fq9fGFp8u9LBZHF51xw2i5N/ehktLq74wuTA7rFz1l12j7afZR6bVnWyedy5tofNo2/LKkaP
	z5vkAtiiuGxSUnMyy1KL9O0SuDLmnGctmMxRsfzcT7YGxudsXYycHBICJhJrnvxjhrDFJC7c
	Ww8U5+IQEljKKPHl/C92CKePSeLMv+ksIFVsAsYSm5cvAasSEdjGKDGhv5cJJMEsECyx7ulJ
	sLHCApESqy6uBrNZBFQl5n2bxApi8wq4Syw70cACsU5O4uSxyWBxTgEPiTdrtoHZQkA1S8/f
	Z5/AyLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkhwfd3BuPSY1SFGAQ5GJR7eBTIZ
	wUKsiWXFlbmHGCU4mJVEeOvzgUK8KYmVValF+fFFpTmpxYcYmTg4pRoYZ95ReT5pzbrdU1L6
	5Kd5zJPJfDtxbpJf5pKQT1c3b179cjI39w2TOo6wo6sdnPW+zE2fE8Gj8MDmyOtT01sva8ju
	dZuVIbdNIHmdomL0e2Yn5mX9fo/tjFKOyW9dEHXnTcNPkxMse2ctnLQ1brLDgiMZF6dHH89I
	MxGxeell0jFF+BODQHKhpBJLcUaioRZzUXEiAM11/rkMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use regulator API rdev_get_id() to access id of regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s2mpa01.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
index cab1a2b9efc5..b71e11a6c773 100644
--- a/drivers/regulator/s2mpa01.c
+++ b/drivers/regulator/s2mpa01.c
@@ -61,7 +61,7 @@ static int s2mpa01_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 	unsigned int ramp_delay = 0;
 	int old_volt, new_volt;
 
-	switch (rdev->desc->id) {
+	switch (rdev_get_id(rdev)) {
 	case S2MPA01_BUCK2:
 	case S2MPA01_BUCK4:
 		ramp_delay = s2mpa01->ramp_delay24;
@@ -102,7 +102,7 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 	unsigned int ramp_enable = 1, enable_shift = 0;
 	int ret;
 
-	switch (rdev->desc->id) {
+	switch (rdev_get_id(rdev)) {
 	case S2MPA01_BUCK1:
 		enable_shift = S2MPA01_BUCK1_RAMP_EN_SHIFT;
 		if (!ramp_delay) {
-- 
1.9.1

