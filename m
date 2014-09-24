Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaIXMAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:00:22 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52295 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaIXMAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:00:18 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-92-5422b24fd05a
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH on mfd-regulator-power-v3.17] charger: max14577: Fix build
 breakage when compiled as module
Date: Wed, 24 Sep 2014 14:00:06 +0200
Message-id: <1411560006-16471-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xy7r+m5RCDHYdkrWY+vAJm8WkJ++Z
	LSaunMxs8fqFocX9r0cZLS7vmsNm8bn3CKPF6d0lDhweO2fdZffYvELLY9OqTjaPO9f2sHn0
	bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXRtOCTtaCtxwVq3esZGxgvM3excjJISFgItE/tZ8J
	whaTuHBvPVsXIxeHkMBSRonG2TfAErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoC4xad4iZoj6
	PiaJvv0PGEESbALGEpuXLwEbJCJwF2jQounsEB0hEpcu/QGzhQVyJQ79/QU2lEVAVWLuYmmI
	Xe4Sx/5OZ4M4SE7i5LHJrBMY+WYhOWMWwhmzkJyxgJF5FaNoamlyQXFSeq6hXnFibnFpXrpe
	cn7uJkZIAH/Zwbj4mNUhRgEORiUe3gniSiFCrIllxZW5hxglOJiVRHi/rQMK8aYkVlalFuXH
	F5XmpBYfYmTi4JRqYOTxc7NcfHRTJn+rTMvFmF9/v90JXHGyT3lV4qSylC1P2tbKnrsdEfL3
	R5Hu+SdNX9ckZGzx2LrP5YgQ7/q1QrvLnz4qeJ+zJL3rKCvj0iwHnRmJmZPEpeZ5bJ53vSCr
	v0u69tukSXELWGPVwp7zTvjxpiWyRDSrUOZW29qtk3wyqqbo5vQ6XFdiKc5INNRiLipOBACl
	0svjPgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The charger's module device table used the same name as regulator driver
causing a build break when charger was compiled as a module:

drivers/power/max14577_charger.c:598:1: error: ‘__mod_platform__max14577_regulator_id_device_table’ aliased to undefined symbol ‘max14577_regulator_id’
make[2]: *** [drivers/power/max14577_charger.o] Error 1

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
---
 drivers/power/max14577_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/max14577_charger.c b/drivers/power/max14577_charger.c
index c2e87c41d853..0a2bc7277026 100644
--- a/drivers/power/max14577_charger.c
+++ b/drivers/power/max14577_charger.c
@@ -595,7 +595,7 @@ static const struct platform_device_id max14577_charger_id[] = {
 	{ "max77836-charger", MAXIM_DEVICE_TYPE_MAX77836, },
 	{ }
 };
-MODULE_DEVICE_TABLE(platform, max14577_regulator_id);
+MODULE_DEVICE_TABLE(platform, max14577_charger_id);
 
 static struct platform_driver max14577_charger_driver = {
 	.driver = {
-- 
1.9.1

