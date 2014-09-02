Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaIBNOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:14:18 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:55775 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbaIBNOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:14:14 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linus.walleij@linaro.org, galak@codeaurora.org,
        bjorn.andersson@sonymobile.com, agross@codeaurora.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, grant.likely@linaro.org,
        sboyd@codeaurora.org, iivanov@mm-sol.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v3 0/4] pinctrl: qcom: Add APQ8084 pinctrl support
Date: Tue,  2 Sep 2014 16:13:41 +0300
Message-Id: <1409663625-3185-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds pinctrl support for the Qualcomm APQ8084 platform.
The first patch adds the pin definitions. The second patch contains the
devicetree binding documentation. The third patch adds the DT node.
The last patch makes the INTR_TARGET_PROC_APPS value configurable and
defines it for each existing SoC.

Tested on IFC6540 board.

Changes since v2:
 - Fixed some incorrect bits and offsets. (suggested by Bjorn Andersson)
 - Updated binding documentation to follow the format of msm8960.
   (suggested by Bjorn Andersson)
 - Added fourth patch, which removes the hardcoded INTR_TARGET_PROC_APPS
   value and makes it configurable. Also we keep the current value for
   existing SoCs. (suggested by Bjorn Andersson)

Changes since v1:
 - Updated the total number of pins (suggested by Bjorn Andersson)
 - Added the missing pin info (provided by Andy Gross)
 - Updated groups and functions to be consistent with other pinctrls.
   (suggested by Andy Gross)
 - Removed unused functions, qdss and test pins. (suggested by Andy Gross)
 - Updated the documentation with the possible functions.

Georgi Djakov (4):
  pinctrl: qcom: Add APQ8084 pinctrl support
  dt: Document Qualcomm APQ8084 pinctrl binding
  ARM: dts: qcom: Add TLMM DT node for APQ8084
  pinctrl: qcom: Make the target processor value configurable

 .../bindings/pinctrl/qcom,apq8084-pinctrl.txt      |  179 +++
 arch/arm/boot/dts/qcom-apq8084.dtsi                |   10 +
 drivers/pinctrl/qcom/Kconfig                       |    8 +
 drivers/pinctrl/qcom/Makefile                      |    1 +
 drivers/pinctrl/qcom/pinctrl-apq8064.c             |    2 +
 drivers/pinctrl/qcom/pinctrl-apq8084.c             | 1245 ++++++++++++++++++++
 drivers/pinctrl/qcom/pinctrl-ipq8064.c             |    2 +
 drivers/pinctrl/qcom/pinctrl-msm.c                 |    4 +-
 drivers/pinctrl/qcom/pinctrl-msm.h                 |    3 +
 drivers/pinctrl/qcom/pinctrl-msm8960.c             |    2 +
 drivers/pinctrl/qcom/pinctrl-msm8x74.c             |    2 +
 11 files changed, 1455 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,apq8084-pinctrl.txt
 create mode 100644 drivers/pinctrl/qcom/pinctrl-apq8084.c

-- 
1.7.9.5

