Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbaJVJ6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:58:42 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:49655 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbaJVJ6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:58:39 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Georgi Djakov <gdjakov@mm-sol.com>, Andy Gross <agross@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v6 0/4] Qualcomm SPMI PMIC pin controller drivers
Date: Wed, 22 Oct 2014 12:58:43 +0300
Message-Id: <1413971927-9168-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v4:

- Rebased on v3.18-rc1:
  pinmux_ops.enable is now pinmux_ops.set_mux
  gpiochip_remove() did not return a value.
- Added Ack's from Bjorn

Short description:

Patches adds pin control drivers for Multi-Purpose Pin (MPP) and
General-purpose pin (GPIO) controllers found in Qualcomm SPMI based
PMIC chips.

MPP's are enhanced GPIO's with analog circuits, which support 
analog and digital input/output.

v5: http://thread.gmane.org/gmane.linux.ports.arm.msm/10074

Bjorn Andersson (1):
  pinctrl: Device tree bindings for Qualcomm PMIC GPIO block

Ivan T. Ivanov (3):
  pinctrl: Device tree bindings for Qualcomm PMIC MPP block
  pinctrl: Qualcomm SPMI PMIC GPIO pin controller driver
  pinctrl: Qualcomm SPMI PMIC MPP pin controller driver

 .../devicetree/bindings/pinctrl/qcom,pmic-gpio.txt | 215 +++++
 .../devicetree/bindings/pinctrl/qcom,pmic-mpp.txt  | 162 ++++
 drivers/pinctrl/qcom/Kconfig                       |  13 +
 drivers/pinctrl/qcom/Makefile                      |   2 +
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           | 933 ++++++++++++++++++++
 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c            | 949 +++++++++++++++++++++
 include/dt-bindings/pinctrl/qcom,pmic-gpio.h       | 142 +++
 include/dt-bindings/pinctrl/qcom,pmic-mpp.h        |  44 +
 8 files changed, 2460 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
 create mode 100644 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
 create mode 100644 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-gpio.h
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-mpp.h

-- 
1.9.1

