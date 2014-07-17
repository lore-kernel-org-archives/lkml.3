Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801AbaGQP0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:26:24 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:60058 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934214AbaGQP0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:26:15 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 0/4] New Qualcomm PMIC pin controller drivers
Date: Thu, 17 Jul 2014 18:25:44 +0300
Message-Id: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Hi, 

This is second version of the patches posted earlier[1].

Patches could be applied on top of the Bjorn Andersson
qcom,pm8xxx-gpio driver, which could be found here[2].

Fist patch modify Bjorn's driver and bindings to make room
for newer Qualcomm PMIC chips. It is not completely ready.

Changes:
- Remove registers values cache.
- Merge pm8941 and pm8841 into qpnp-pinctrl driver.
- Rebase on top of the "Qualcomm pm8xxx gpio driver" to reuse
  "qcom,pm8xxx-gpio" DT document.
- Split compatibles string to MPP's and GPIO's to use
  similar naming convention like "Qualcomm pm8xxx gpio driver"[2]
- Add support for pma8084 chip

Short description:

Patches adds pin control drivers for Multi-purpose pin (MPP) and
General-purpose pin (GPIO) controllers found in Qualcomm SPMI
based PMIC chips.

MPP's are enhanced GPIO's with analog circuits, which support 
following functions in addition to digital input/output: analog
input/output and current sinks. 

[1] http://lwn.net/Articles/604637/
[2] https://lkml.org/lkml/2014/7/7/945

Ivan T. Ivanov (4):
  pinctrl: Update Qualcomm PMXXX GPIO parameters definitions
  pinctrl: qpnp: Qualcomm PMIC pin controller driver
  pinctrl: qcom: Add documentation for pinctrl-qpnp driver bindings
  ARM: dts: qcom: Add PM8941 and PM8841 pinctrl nodes

 .../bindings/pinctrl/qcom,pm8xxx-gpio.txt          |   97 +-
 .../bindings/pinctrl/qcom,pm8xxx-mpp.txt           |  199 +++
 arch/arm/boot/dts/qcom-msm8974.dtsi                |   61 +
 drivers/pinctrl/Kconfig                            |   12 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-pm8xxx-gpio.c              |   34 +-
 drivers/pinctrl/pinctrl-qpnp.c                     | 1565 ++++++++++++++++++++
 include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h     |   33 +-
 include/dt-bindings/pinctrl/qcom,pm8xxx-mpp.h      |   34 +
 9 files changed, 1953 insertions(+), 83 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-mpp.txt
 create mode 100644 drivers/pinctrl/pinctrl-qpnp.c
 create mode 100644 include/dt-bindings/pinctrl/qcom,pm8xxx-mpp.h

-- 
1.8.3.2

