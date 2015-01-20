Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbbATCFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:05:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41455 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbbATCFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:05:38 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kenneth Westfield <kwestfie@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Rajendra Nayak <rnayak@codeaurora.org>, devicetree@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v3 0/8] qcom audio clock control drivers
Date: Mon, 19 Jan 2015 18:05:27 -0800
Message-Id: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the low power audio subsystem (LPASS)
clock controller hardware. I split out the #define patch for IPQ so that
it can go through the clock tree and the arm-soc tree in parallel
if desired.

Changes since v2:
 * Rebased onto v3.19-rc2
 * One fix to a clock parent name

Change since v1:
 * Renamed clk-cdiv to clk-regmap-divider
 * Added msm8960/apq8064 support
 * Split out dividers and branches to check for halt bits

Josh Cartwright (1):
  clk: qcom: Add support for regmap divider clocks

Rajendra Nayak (3):
  dt-bindings: Add #defines for IPQ806x lpass clock control
  clk: qcom: Add IPQ806X LPASS clock controller (LCC) driver
  devicetree: bindings: Document qcom,lcc

Stephen Boyd (4):
  clk: Add __clk_mux_determine_rate_closest
  clk: divider: Make generic for usage elsewhere
  clk: qcom: Add simple regmap based muxes
  clk: qcom: Add MSM8960/APQ8064 LPASS clock controller (LCC) driver

 .../devicetree/bindings/clock/qcom,lcc.txt         |  21 +
 drivers/clk/clk-divider.c                          | 212 +++++---
 drivers/clk/clk.c                                  |  47 +-
 drivers/clk/qcom/Kconfig                           |  18 +
 drivers/clk/qcom/Makefile                          |   4 +
 drivers/clk/qcom/clk-regmap-divider.c              |  70 +++
 drivers/clk/qcom/clk-regmap-divider.h              |  29 +
 drivers/clk/qcom/clk-regmap-mux.c                  |  59 +++
 drivers/clk/qcom/clk-regmap-mux.h                  |  29 +
 drivers/clk/qcom/gcc-ipq806x.c                     |  12 +
 drivers/clk/qcom/lcc-ipq806x.c                     | 473 +++++++++++++++++
 drivers/clk/qcom/lcc-msm8960.c                     | 585 +++++++++++++++++++++
 include/dt-bindings/clock/qcom,gcc-ipq806x.h       |   1 -
 include/dt-bindings/clock/qcom,lcc-ipq806x.h       |  30 ++
 include/dt-bindings/clock/qcom,lcc-msm8960.h       |  50 ++
 include/linux/clk-provider.h                       |  19 +-
 16 files changed, 1564 insertions(+), 95 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,lcc.txt
 create mode 100644 drivers/clk/qcom/clk-regmap-divider.c
 create mode 100644 drivers/clk/qcom/clk-regmap-divider.h
 create mode 100644 drivers/clk/qcom/clk-regmap-mux.c
 create mode 100644 drivers/clk/qcom/clk-regmap-mux.h
 create mode 100644 drivers/clk/qcom/lcc-ipq806x.c
 create mode 100644 drivers/clk/qcom/lcc-msm8960.c
 create mode 100644 include/dt-bindings/clock/qcom,lcc-ipq806x.h
 create mode 100644 include/dt-bindings/clock/qcom,lcc-msm8960.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

