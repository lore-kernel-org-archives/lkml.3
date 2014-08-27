Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965168AbaH0Vb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:31:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55774 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965100AbaH0Vb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:31:26 -0400
Message-ID: <53FE4E2C.9010207@infradead.org>
Date: Wed, 27 Aug 2014 14:31:24 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: fix kernel-doc warnings in header files
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc warnings in regulator header files:

Warning(..//include/linux/regulator/machine.h:140): No description found for parameter 'ramp_disable'
Warning(..//include/linux/regulator/driver.h:279): No description found for parameter 'linear_ranges'
Warning(..//include/linux/regulator/driver.h:279): No description found for parameter 'n_linear_ranges'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 include/linux/regulator/driver.h  |    2 ++
 include/linux/regulator/machine.h |    1 +
 2 files changed, 3 insertions(+)

Please feel free to change these descriptions.

Index: lnx-317-rc2/include/linux/regulator/machine.h
===================================================================
--- lnx-317-rc2.orig/include/linux/regulator/machine.h
+++ lnx-317-rc2/include/linux/regulator/machine.h
@@ -85,6 +85,7 @@ struct regulator_state {
  *           bootloader then it will be enabled when the constraints are
  *           applied.
  * @apply_uV: Apply the voltage constraint when initialising.
+ * @ramp_disable: Disable ramp delay when initialising or when setting voltage.
  *
  * @input_uV: Input voltage for regulator when supplied by another regulator.
  *
Index: lnx-317-rc2/include/linux/regulator/driver.h
===================================================================
--- lnx-317-rc2.orig/include/linux/regulator/driver.h
+++ lnx-317-rc2/include/linux/regulator/driver.h
@@ -218,6 +218,8 @@ enum regulator_type {
  * @linear_min_sel: Minimal selector for starting linear mapping
  * @fixed_uV: Fixed voltage of rails.
  * @ramp_delay: Time to settle down after voltage change (unit: uV/us)
+ * @linear_ranges: A constant table of possible voltage ranges.
+ * @n_linear_ranges: Number of entries in the @linear_ranges table.
  * @volt_table: Voltage mapping table (if table based mapping)
  *
  * @vsel_reg: Register for selector when using regulator_regmap_X_voltage_
