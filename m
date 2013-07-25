Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3GYRjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:39:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41087 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3GYRjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:39:40 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Subject: [PATCH v2 0/2] Add Dialog DA9063 core and regulator drivers
Date: Thu, 25 Jul 2013 19:39:01 +0200
Message-Id: <1374773943-7454-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 10.1.0.104
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a second round of the DA9063 mfd core and regulator patch, with the
following changes since v1:
 - Reordered to avoid forward declarations
 - Split set/get_mode into buck and ldo specific versions and
   dropped da9063_get/update_mode_internal
 - Dropped suspend_enable/disable for 32K_OUT and stopped buck
   enable from touching suspend register fields
 - Replaced custom bitfield handling with reg(map)_field
 - Register all regulators instead of only those listed in platform data
 - Check for model id (0x61) and revision id (3)
 - Use module_i2c_driver instead of subsys_initcall
 - Fixed DA9063_BMEM/BCORE2_ILIM_MASK values
 - Removed da9063_model accessor functions and unused DA9063_PAGE/REG defines
 - Removed the unused SHIFT defines, reg_fields are initialized
   from MASK alone

The core driver depends on a patch I've sent earlier:
"[RFC] regmap: core: allow a virtual range to cover its own data window"
(https://lkml.org/lkml/2013/7/23/165).

regards
Philipp

 drivers/mfd/Kconfig                  |   12 +
 drivers/mfd/Makefile                 |    3 +
 drivers/mfd/da9063-core.c            |  185 ++++++
 drivers/mfd/da9063-i2c.c             |  182 ++++++
 drivers/mfd/da9063-irq.c             |  193 +++++++
 drivers/regulator/Kconfig            |   10 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/da9063-regulator.c |  960 +++++++++++++++++++++++++++++++
 include/linux/mfd/da9063/core.h      |   93 +++
 include/linux/mfd/da9063/pdata.h     |  114 ++++
 include/linux/mfd/da9063/registers.h | 1028 ++++++++++++++++++++++++++++++++++
 11 files changed, 2781 insertions(+)

