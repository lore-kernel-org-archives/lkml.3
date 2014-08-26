Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbaHZE6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:58:34 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:1975 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbaHZE6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:58:32 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>
CC: Pawel Moll <pawel.moll@arm.com>, Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: [PATCH v6 0/3] Qualcomm Resource Power Manager driver
Date: Mon, 25 Aug 2014 21:58:26 -0700
Message-ID: <1409029109-28769-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
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

Changes since v5:
  - Clarified dt binding
  - Converted regulator qcom,force-mode to enum instead of multi-boolean
  - Remove unecessary version handshake
  - Cleaned up naming of RPM resources between different RPM versions
  - Updated regulator qcom,force-mode parsing
  - Updated regulator qcom,power-mode-* parsing
  - Cleanups in rpm driver
  - Dropped dev_get_qcom_rpm helper function

Changes since v4:
  - Moved RPM driver to mfd

Changes since v3:
  - IPC register is acquired through syscon, as it's shared with others

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
  mfd: devicetree: bindings: Add Qualcomm RPM DT binding
  mfd: qcom-rpm: Driver for the Qualcomm RPM
  regulator: qcom-rpm: Regulator driver for the Qualcomm RPM

 Documentation/devicetree/bindings/mfd/qcom,rpm.txt |  246 ++++++
 drivers/mfd/Kconfig                                |   14 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/qcom_rpm.c                             |  580 ++++++++++++++
 drivers/regulator/Kconfig                          |   12 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/qcom_rpm-regulator.c             |  798 ++++++++++++++++++++
 include/dt-bindings/mfd/qcom,rpm.h                 |  154 ++++
 include/linux/mfd/qcom_rpm.h                       |   10 +
 9 files changed, 1816 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom,rpm.txt
 create mode 100644 drivers/mfd/qcom_rpm.c
 create mode 100644 drivers/regulator/qcom_rpm-regulator.c
 create mode 100644 include/dt-bindings/mfd/qcom,rpm.h
 create mode 100644 include/linux/mfd/qcom_rpm.h

-- 
1.7.9.5

