Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaHKPk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:40:58 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45761 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbaHKPkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:40:55 -0400
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
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] Qualcomm PMIC pin controller drivers
Date: Mon, 11 Aug 2014 18:40:28 +0300
Message-Id: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Hi, 

This is third version of the patches posted earlier here[1].

Changes:
- pm8xxx-gpio driver renamed to ssbi-pmic-gpio and qpnp-pinctrl
  to spmi-pmic-pinctrl
- Functions are described with strings. Available functions for
  each PMIC GPIO are described in DT include file.
- Available 'power-sources' are described per PMIC in DT include files
  and per chip definitions from pm8xxx-gpio driver are removed.
- Property 'qcom,pull-up' renamed 'qcom,pull-up-strength' possible
  are listed in DT include file.
- Property 'qcom,strength' renamed to 'qcom,drive-strength'
- Added parsing code for above 2 properties to ssbi-pmic-gpio driver
- Added AP8074 Dragonboard PMIC GPIO DT files.
- Added qcom,mode property for Multi-Purpose Pins
- Fixed review comments and driver issues.

Short description:

Patches adds pin control drivers for Multi-purpose pin (MPP) and
General-purpose pin (GPIO) controllers found in Qualcomm SSBI and 
SPMI based PMIC chips.

MPP's are enhanced GPIO's with analog circuits, which support 
following functions in addition to digital input/output: analog
input/output and current sinks. 

[1] http://thread.gmane.org/gmane.linux.kernel/1749903

Bjorn Andersson (2):
  pinctrl: Device tree bindings for Qualcomm pm8xxx gpio block
  pinctrl: Introduce pinctrl driver for Qualcomm SSBI PMIC's

Ivan T. Ivanov (4):
  pinctrl: Add documentation for SPMI PMIC pinctrl driver bindings
  pinctrl: Qualcomm SPMI PMIC pin controller driver
  ARM: dts: qcom: Add PM8941 and PM8841 pinctrl nodes
  ARM: dts: qcom: Add APQ8074 Dragonboard PMIC GPIO bindings

 .../devicetree/bindings/pinctrl/qcom,pmic-gpio.txt |  212 +++
 .../devicetree/bindings/pinctrl/qcom,pmic-mpp.txt  |  179 +++
 .../dts/qcom-apq8074-dragonboard-pmics-pins.dtsi   |  103 ++
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts     |    1 +
 arch/arm/boot/dts/qcom-msm8974.dtsi                |   33 +
 drivers/pinctrl/qcom/Kconfig                       |   23 +
 drivers/pinctrl/qcom/Makefile                      |    2 +
 drivers/pinctrl/qcom/pinctrl-spmi-pmic.c           | 1532 ++++++++++++++++++++
 drivers/pinctrl/qcom/pinctrl-ssbi-pmic.c           |  870 +++++++++++
 include/dt-bindings/pinctrl/qcom,pmic-gpio.h       |  142 ++
 include/dt-bindings/pinctrl/qcom,pmic-mpp.h        |   70 +
 11 files changed, 3167 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
 create mode 100644 arch/arm/boot/dts/qcom-apq8074-dragonboard-pmics-pins.dtsi
 create mode 100644 drivers/pinctrl/qcom/pinctrl-spmi-pmic.c
 create mode 100644 drivers/pinctrl/qcom/pinctrl-ssbi-pmic.c
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-gpio.h
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-mpp.h

-- 
1.8.3.2

