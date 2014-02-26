Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaBZS7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:59:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52608 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbaBZS7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:59:32 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 0/8] Modernize pm8921 with irqdomains, regmap, DT
Date: Wed, 26 Feb 2014 10:59:18 -0800
Message-Id: <1393441166-32692-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches lay the groundwork for converting the pm8921 sub-devices
to devicetree as well as simplify the API by migrating the core code
to use the regmap API instead of the custom pm8xxx read/write wrapper.

Changes since v3:
 * Added irqdomain Kconfig select
 * New patch to loosen Kconfig on PM8921 config
 * Picked up acked-by

Changes since v2:
 * Picked up reviewed-by tags
 * Fixed irqdomain teardown in driver remove
 * No magical 256 constant
 * Renamed domain to irqdomain
 * Clarified kzalloc call
 * Pushed ssbi regmap helpers into header file
 * Fixed whitespace noise in patch 6

Changes since v1:
 * First 3 cleanup patches dropped because they're applied upstream
 * New regmap read/write helpers
 * New patch for DT match table
 * New binding document

Stephen Boyd (8):
  mfd: Move pm8xxx-irq.c contents into only driver that uses it
  mfd: pm8921: Update for genirq changes
  mfd: pm8921: Migrate to irqdomains
  mfd: ssbi: Add regmap read/write helpers
  mfd: pm8921: Use ssbi regmap
  mfd: pm8921: Add DT match table
  mfd: pm8921: Loosen Kconfig dependency
  devicetree: bindings: Document PM8921/8058 PMICs

 .../devicetree/bindings/mfd/qcom,pm8xxx.txt        |  63 +++
 drivers/mfd/Kconfig                                |  15 +-
 drivers/mfd/Makefile                               |   1 -
 drivers/mfd/pm8921-core.c                          | 427 ++++++++++++++++++---
 drivers/mfd/pm8xxx-irq.c                           | 371 ------------------
 include/linux/mfd/pm8xxx/irq.h                     |  59 ---
 include/linux/mfd/pm8xxx/pm8921.h                  |  30 --
 include/linux/ssbi.h                               |  20 +
 8 files changed, 460 insertions(+), 526 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
 delete mode 100644 drivers/mfd/pm8xxx-irq.c
 delete mode 100644 include/linux/mfd/pm8xxx/irq.h
 delete mode 100644 include/linux/mfd/pm8xxx/pm8921.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

