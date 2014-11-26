Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaKZVvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:51:09 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11777 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbaKZVvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:51:07 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Brown <broonie@kernel.org>
CC: Josh Cartwright <joshc@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>
Subject: [PATCH v8 0/3] Qualcomm Resource Power Manager
Date: Wed, 26 Nov 2014 13:50:58 -0800
Message-ID: <1417038661-30209-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support the SoC assisted power save features of the Qualcomm
platform some changes are most likely needed to the regulator part of the DT
bindings provided before.

This version of the patchset carries the RPM core part, which allows us to move
forward with merging Josh's patches [1] as well as aiding the discussion and
development of the additional patches needed to properly implement the power
save features being discussed.

It also carries the patch to the already merged regulator driver, to make it
compile.

[1] https://lkml.org/lkml/2014/11/20/629

Changes since v7:
  - Mark merged the regulator part of the previous series
  - Removed regulator part of dt binding, for further discussions

Changes since v6:
  - Changed filenames from qcom,rpm.{txt,h} to qcom-rpm.{txt,h}

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
  regulator: qcom-rpm: Add missing state flag in call to RPM

 Documentation/devicetree/bindings/mfd/qcom-rpm.txt |  70 +++
 drivers/mfd/Kconfig                                |  14 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/qcom_rpm.c                             | 581 +++++++++++++++++++++
 drivers/regulator/qcom_rpm-regulator.c             |   1 +
 include/dt-bindings/mfd/qcom-rpm.h                 | 154 ++++++
 include/linux/mfd/qcom_rpm.h                       |  13 +
 7 files changed, 834 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom-rpm.txt
 create mode 100644 drivers/mfd/qcom_rpm.c
 create mode 100644 include/dt-bindings/mfd/qcom-rpm.h
 create mode 100644 include/linux/mfd/qcom_rpm.h

--
1.8.2.2

