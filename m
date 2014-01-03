Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaACAhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:37:48 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47279 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaACAho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:37:44 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH v2 00/10] Use regmap+devm+DT in pm8xxx input drivers
Date: Thu,  2 Jan 2014 16:37:30 -0800
Message-Id: <1388709460-19222-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches move the pm8xxx input drivers over to use devm_* APIs
and regmap. This breaks the dependency of these drivers on the pm8xxx
specific read/write calls and also simplifies the probe code a bit.
Finally we add devicetree support to these drivers so they can be probed
on the platforms that are supported upstream.

There was no devm_request_any_context_irq() available, so I've added
it here.

Changes since v1:
 * Picked up Dmitry's version of devm for pwrkey
 * Added DT bindings and parsing patches
 * Dropped patches picked up by Dmitry

Dmitry Torokhov (1):
  Input: pmic8xxx-pwrkey - switch to using managed resources

Stephen Boyd (9):
  genirq: Add devm_request_any_context_irq()
  Input: pmic8xxx-keypad - Switch to using managed resources
  Input: pmic8xxx-keypad - Migrate to regmap APIs
  Input: pmic8xxx-pwrkey - Migrate to DT
  Input: pm8xxx-vibrator - Add DT match table
  Input: pmic8xxx-keypad - Migrate to DT
  devicetree: bindings: Document PM8921/8058 keypads
  devicetree: bindings: Document PM8921/8058 power keys
  devicetree: bindings: Document PM8921/8058 vibrators

 .../bindings/input/qcom,pm8xxx-keypad.txt          |  72 +++++
 .../bindings/input/qcom,pm8xxx-pwrkey.txt          |  39 +++
 .../devicetree/bindings/input/qcom,pm8xxx-vib.txt  |  16 ++
 drivers/input/keyboard/pmic8xxx-keypad.c           | 291 ++++++++++-----------
 drivers/input/misc/pm8xxx-vibrator.c               |   8 +
 drivers/input/misc/pmic8xxx-pwrkey.c               | 107 ++++----
 include/linux/input/pmic8xxx-keypad.h              |  52 ----
 include/linux/input/pmic8xxx-pwrkey.h              |  31 ---
 include/linux/interrupt.h                          |   5 +
 kernel/irq/devres.c                                |  45 ++++
 10 files changed, 361 insertions(+), 305 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-pwrkey.txt
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-vib.txt
 delete mode 100644 include/linux/input/pmic8xxx-keypad.h
 delete mode 100644 include/linux/input/pmic8xxx-pwrkey.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

