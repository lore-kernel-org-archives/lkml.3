Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3LWUqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 15:46:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39373 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab3LWUqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 15:46:07 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v2 0/7] Modernize pm8921 with irqdomains, regmap, DT
Date: Mon, 23 Dec 2013 12:45:56 -0800
Message-Id: <1387831563-13535-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches lay the groundwork for converting the pm8921 sub-devices
to devicetree as well as simplify the API by migrating the core code
to use the regmap API instead of the custom pm8xxx read/write wrapper.

Changes since v1:
 * First 3 cleanup patches dropped because they're applied upstream
 * New regmap read/write helpers
 * New patch for DT match table
 * New binding document

Stephen Boyd (7):
  mfd: Move pm8xxx-irq.c contents into only driver that uses it
  mfd: pm8921: Update for genirq changes
  mfd: pm8921: Migrate to irqdomains
  mfd: ssbi: Add regmap read/write helpers
  mfd: pm8921: Use ssbi regmap
  mfd: pm8921: Add DT match table
  devicetree: bindings: Document PM8921/8058 PMICs

 .../devicetree/bindings/mfd/qcom,pm8xxx.txt        |  63 +++
 drivers/mfd/Kconfig                                |  12 +-
 drivers/mfd/pm8921-core.c                          | 424 ++++++++++++++++++---
 drivers/mfd/pm8xxx-irq.c                           | 371 ------------------
 drivers/mfd/ssbi.c                                 |  13 +
 include/linux/mfd/pm8xxx/irq.h                     |  59 ---
 include/linux/mfd/pm8xxx/pm8921.h                  |  30 --
 include/linux/ssbi.h                               |   3 +
 8 files changed, 449 insertions(+), 526 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
 delete mode 100644 drivers/mfd/pm8xxx-irq.c
 delete mode 100644 include/linux/mfd/pm8xxx/irq.h
 delete mode 100644 include/linux/mfd/pm8xxx/pm8921.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

