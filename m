Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbaGBP3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:29:10 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:53517 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaGBP3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:29:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/12] mfd: intel_soc_pmic: Rid compiler working for unused ACPI match table
Date: Wed,  2 Jul 2014 16:28:35 +0100
Message-Id: <1404314924-23564-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONIFG_ACPI is not enabled we receive the following warning:

drivers/mfd/intel_soc_pmic_core.c:144:30:
	warning: ‘intel_soc_pmic_acpi_match’ defined but not used

This patch rids it.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/intel_soc_pmic_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/intel_soc_pmic_core.c b/drivers/mfd/intel_soc_pmic_core.c
index cddbf5a..2720922 100644
--- a/drivers/mfd/intel_soc_pmic_core.c
+++ b/drivers/mfd/intel_soc_pmic_core.c
@@ -141,11 +141,13 @@ static const struct i2c_device_id intel_soc_pmic_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, intel_soc_pmic_i2c_id);
 
+#if defined(CONFIG_ACPI)
 static struct acpi_device_id intel_soc_pmic_acpi_match[] = {
 	{"INT33FD", (kernel_ulong_t)&intel_soc_pmic_config_crc},
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, intel_soc_pmic_acpi_match);
+#endif
 
 static struct i2c_driver intel_soc_pmic_i2c_driver = {
 	.driver = {
-- 
1.8.3.2

