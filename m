Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaGUV0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:26:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43310 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaGUV0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:26:37 -0400
Date: Mon, 21 Jul 2014 14:26:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] qcom clock changes for 3.17
Message-ID: <20140721212635.GA19933@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-clocks-for-3.17

for you to fetch changes up to e216ce60a9e05ab399d098f05cd86fd95c9da8d5:

  clk: qcom: Add support for APQ8064 multimedia clocks (2014-07-15 16:39:03 -0700)

----------------------------------------------------------------
qcom clock changes for 3.17

These patches add support for a handful of Qualcomm's SoC clock
controllers: APQ8084 gcc and mmcc, IPQ8064 gcc, and APQ8064.
There's also a small collection of bug fixes that aren't critical
-rc worthy regressions because the consumer drivers aren't present
or using the buggy clocks and one optimization for HDMI.

----------------------------------------------------------------
Georgi Djakov (4):
      clk: qcom: Add APQ8084 Global Clock Controller documentation
      clk: qcom: Add APQ8084 Global Clock Controller support
      clk: qcom: Add APQ8084 clocks for SATA, PCIe and UFS
      clk: qcom: Add APQ8084 Multimedia Clock Controller (MMCC) support

Kumar Gala (1):
      clk: qcom: Add support for IPQ8064's global clock controller (GCC)

Srinivas Kandagatla (1):
      clk: qcom: add clocks necessary for apq8064 sdcc

Stephen Boyd (7):
      clk: qcom: Fully support apq8064 global clock control
      clk: qcom: Support bypass RCG configuration
      clk: qcom: Fix MN frequency tables, parent map, and jpegd
      clk: qcom: Fix PLL rate configurations
      clk: qcom: mdp_lut_clk is a child of mdp_src
      clk: qcom: pll: Add support for configuring SR PLLs
      clk: qcom: Add support for APQ8064 multimedia clocks

 .../devicetree/bindings/clock/qcom,gcc.txt         |    2 +
 .../devicetree/bindings/clock/qcom,mmcc.txt        |    2 +
 drivers/clk/qcom/Kconfig                           |   25 +
 drivers/clk/qcom/Makefile                          |    3 +
 drivers/clk/qcom/clk-pll.c                         |   15 +-
 drivers/clk/qcom/clk-pll.h                         |    2 +
 drivers/clk/qcom/clk-rcg.c                         |   51 +-
 drivers/clk/qcom/clk-rcg.h                         |    1 +
 drivers/clk/qcom/common.c                          |   39 +-
 drivers/clk/qcom/common.h                          |    6 +
 drivers/clk/qcom/gcc-apq8084.c                     | 3611 ++++++++++++++++++++
 drivers/clk/qcom/gcc-ipq806x.c                     | 2424 +++++++++++++
 drivers/clk/qcom/gcc-msm8960.c                     |  583 +++-
 drivers/clk/qcom/mmcc-apq8084.c                    | 3352 ++++++++++++++++++
 drivers/clk/qcom/mmcc-msm8960.c                    |  526 ++-
 drivers/clk/qcom/mmcc-msm8974.c                    |   10 +-
 include/dt-bindings/clock/qcom,gcc-apq8084.h       |  351 ++
 include/dt-bindings/clock/qcom,gcc-ipq806x.h       |  293 ++
 include/dt-bindings/clock/qcom,gcc-msm8960.h       |   11 +
 include/dt-bindings/clock/qcom,mmcc-apq8084.h      |  183 +
 include/dt-bindings/clock/qcom,mmcc-msm8960.h      |    8 +
 include/dt-bindings/reset/qcom,gcc-apq8084.h       |  109 +
 include/dt-bindings/reset/qcom,gcc-ipq806x.h       |  132 +
 include/dt-bindings/reset/qcom,gcc-msm8960.h       |   16 +
 include/dt-bindings/reset/qcom,mmcc-apq8084.h      |   64 +
 include/dt-bindings/reset/qcom,mmcc-msm8960.h      |    8 +
 26 files changed, 11747 insertions(+), 80 deletions(-)
 create mode 100644 drivers/clk/qcom/gcc-apq8084.c
 create mode 100644 drivers/clk/qcom/gcc-ipq806x.c
 create mode 100644 drivers/clk/qcom/mmcc-apq8084.c
 create mode 100644 include/dt-bindings/clock/qcom,gcc-apq8084.h
 create mode 100644 include/dt-bindings/clock/qcom,gcc-ipq806x.h
 create mode 100644 include/dt-bindings/clock/qcom,mmcc-apq8084.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-apq8084.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-ipq806x.h
 create mode 100644 include/dt-bindings/reset/qcom,mmcc-apq8084.h
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
