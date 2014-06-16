Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbaFPSqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:46:21 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8171 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932441AbaFPSqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:46:18 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
CC: Lee Jones <lee.jones@linaro.org>, Josh Cartwright <joshc@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: [PATCH v3 0/3] Qualcomm Resource Power Manager driver
Date: Mon, 16 Jun 2014 11:46:09 -0700
Message-ID: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds a regulator driver for the Resource Power Manager found in
Qualcomm 8660, 8960 and 8064 based devices.

The RPM driver exposes resources to its child devices, that can be accessed to
implement drivers for the regulators, clocks and bus frequency control that's
owned by the RPM in these devices.

Changes since v2:
  - Fix copy-paste error in dt binding
  - Correct incomplete move from mfd to soc
  - Correct const mistake in regulator driver

Changes since v1:
  - Moved rpm driver to drivers/soc
  - Extracted resource table structs from rpm struct, as per Srinivas request
  - Dropped mode setting support for the regulators for now. Unsure if we need
    it and it requires some rework from the codeaurora solution.
  - Using set_voltage_sel instead of rolling my own "snapping", as per Marks
    request
  - Split regulator ops in mV, uV and swtich versions as per Marks request.
  - Added devicetree property to enable pull down.

Bjorn Andersson (3):
  soc: devicetree: bindings: Add Qualcomm RPM DT binding
  soc: qcom-rpm: Driver for the Qualcomm RPM
  regulator: qcom-rpm: Regulator driver for the Qualcomm RPM

 .../devicetree/bindings/soc/qcom/qcom,rpm.txt      | 261 +++++++
 drivers/regulator/Kconfig                          |  12 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/qcom_rpm-regulator.c             | 787 +++++++++++++++++++++
 drivers/soc/qcom/Kconfig                           |  14 +
 drivers/soc/qcom/Makefile                          |   1 +
 drivers/soc/qcom/qcom_rpm.c                        | 573 +++++++++++++++
 include/dt-bindings/soc/qcom,rpm.h                 | 142 ++++
 include/linux/soc/qcom_rpm.h                       |  12 +
 9 files changed, 1803 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt
 create mode 100644 drivers/regulator/qcom_rpm-regulator.c
 create mode 100644 drivers/soc/qcom/qcom_rpm.c
 create mode 100644 include/dt-bindings/soc/qcom,rpm.h
 create mode 100644 include/linux/soc/qcom_rpm.h

-- 
1.8.2.2

