Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaCDSez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:34:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54961 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaCDSex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:34:53 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Josh Cartwright <joshc@codeaurora.org>,
        "linux-input@vger.kernel.orgdevicetree"@vger.kernel.org
Subject: [PATCH v5 0/9] Use regmap+devm+DT in pm8xxx input drivers
Date: Tue,  4 Mar 2014 10:34:39 -0800
Message-Id: <1393958088-1456-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches move the pm8xxx input drivers over to use devm_* APIs
and regmap. This breaks the dependency of these drivers on the pm8xxx
specific read/write calls and also simplifies the probe code a bit.
Finally we add devicetree support to these drivers so they can be probed
on the platforms that are supported upstream.

Changes since v4:
 * Added reg property to bindings
 * Added linux,* properties to keypad binding

Changes since v3:
 * Dropped devm conversion patch for pwrkey
 * Fixed compilation of keypad

Changes since v2:
 * Rebased to v3.14-rc3

Changes since v1:
 * Picked up Dmitry's version of devm for pwrkey
 * Added DT bindings and parsing patches
 * Dropped patches picked up by Dmitry

Stephen Boyd (9):
  Input: pmic8xxx-keypad - Fix build by removing gpio configuration
  Input: pmic8xxx-keypad - Migrate to devm_* APIs
  Input: pmic8xxx-keypad - Migrate to regmap APIs
  Input: pmic8xxx-keypad - Migrate to DT
  Input: pmic8xxx-pwrkey - Migrate to DT
  Input: pm8xxx-vibrator - Add DT match table
  devicetree: bindings: Document PM8921/8058 keypads
  devicetree: bindings: Document PM8921/8058 power keys
  devicetree: bindings: Document PM8921/8058 vibrators

 .../bindings/input/qcom,pm8xxx-keypad.txt          |  89 ++++++
 .../bindings/input/qcom,pm8xxx-pwrkey.txt          |  46 +++
 .../devicetree/bindings/input/qcom,pm8xxx-vib.txt  |  22 ++
 drivers/input/keyboard/pmic8xxx-keypad.c           | 348 ++++++++-------------
 drivers/input/misc/pm8xxx-vibrator.c               |   8 +
 drivers/input/misc/pmic8xxx-pwrkey.c               |  33 +-
 include/linux/input/pmic8xxx-keypad.h              |  52 ---
 include/linux/input/pmic8xxx-pwrkey.h              |  31 --
 8 files changed, 316 insertions(+), 313 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-pwrkey.txt
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-vib.txt
 delete mode 100644 include/linux/input/pmic8xxx-keypad.h
 delete mode 100644 include/linux/input/pmic8xxx-pwrkey.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

