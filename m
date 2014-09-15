Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaIOOoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:44:19 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45762 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbaIOOoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:44:18 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        David Collins <collinsd@codeaurora.org>,
        Wu Fenglin <fenglinw@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v4 0/4] Qualcomm SPMI PMIC pin controller drivers
Date: Mon, 15 Sep 2014 17:44:10 +0300
Message-Id: <1410792254-24126-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

This is forth version of the patches posted earlier here[1].

Changes:
- Driver for SSBI PMIC dropped from this patchest - let Bjorn to handle it.
- Separate MPP and GPIO drivers.
- Second value in 'reg' propriety is used to specify address range length
  and this number of GPIO/MPP's that drivers should handle.
- Using generic compatible = "qcom,spmi-pmic-gpio" in GPIO driver to handle
  any PMIC SPMI based GPIO block.
- Using generic compatible = "qcom,spmi-pmic-mpp" in MPP driver to handle
  any PMIC SPMI based MPP block.
- Analog functionality for MPP's is activated with qcom,analog-mode.
- Fixed review comments and driver issues.

Short description:

Patches adds pin control drivers for Multi-Purpose Pin (MPP) and
General-purpose pin (GPIO) controllers found in Qualcomm SPMI based
PMIC chips.

MPP's are enhanced GPIO's with analog circuits, which support 
analog and digital input/output.

[1] https://www.mail-archive.com/linux-arm-msm@vger.kernel.org/msg10095.html

Bjorn Andersson (1):
  pinctrl: Device tree bindings for Qualcomm PMIC GPIO block

Ivan T. Ivanov (3):
  pinctrl: Device tree bindings for Qualcomm PMIC MPP block
  pinctrl: Qualcomm SPMI PMIC GPIO pin controller driver
  pinctrl: Qualcomm SPMI PMIC MPP pin controller driver

 .../devicetree/bindings/pinctrl/qcom,pmic-gpio.txt | 214 +++++
 .../devicetree/bindings/pinctrl/qcom,pmic-mpp.txt  | 159 ++++
 drivers/pinctrl/qcom/Kconfig                       |  12 +
 drivers/pinctrl/qcom/Makefile                      |   2 +
 drivers/pinctrl/qcom/pinctrl-spmi-pmic-gpio.c      | 944 ++++++++++++++++++++
 drivers/pinctrl/qcom/pinctrl-spmi-pmic-mpp.c       | 958 +++++++++++++++++++++
 include/dt-bindings/pinctrl/qcom,pmic-gpio.h       | 142 +++
 include/dt-bindings/pinctrl/qcom,pmic-mpp.h        |  44 +
 8 files changed, 2475 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
 create mode 100644 drivers/pinctrl/qcom/pinctrl-spmi-pmic-gpio.c
 create mode 100644 drivers/pinctrl/qcom/pinctrl-spmi-pmic-mpp.c
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-gpio.h
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-mpp.h

-- 
1.9.1

