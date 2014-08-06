Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaHFSPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:15:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40596 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbaHFSPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:15:15 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] IPQ NSS/GMAC clock support
Date: Wed,  6 Aug 2014 11:15:09 -0700
Message-Id: <1407348912-9124-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NSS and GMAC clocks were missing from the initial IPQ clock
control driver. This patch series adds them by adding support for
PLL rate switching, generalizing the dyn_rcg code a bit to deal
with more exotic variants of the register layouts, and finally
adding support for the clocks. Please note that the last patch
depends on the safe switch hook that I've already sent out[1].

Stephen Boyd (3):
  clk: qcom: Add support for setting rates on PLLs
  clk: qcom: Add support for banked MD RCGs
  clk: qcom: Add support for NSS/GMAC clocks and resets

 drivers/clk/qcom/clk-pll.c                   |  68 ++-
 drivers/clk/qcom/clk-pll.h                   |  20 +
 drivers/clk/qcom/clk-rcg.c                   |  99 ++--
 drivers/clk/qcom/clk-rcg.h                   |   6 +-
 drivers/clk/qcom/gcc-ipq806x.c               | 710 ++++++++++++++++++++++++++-
 drivers/clk/qcom/mmcc-msm8960.c              |  28 +-
 include/dt-bindings/clock/qcom,gcc-ipq806x.h |   3 +
 include/dt-bindings/reset/qcom,gcc-ipq806x.h |  43 ++
 8 files changed, 919 insertions(+), 58 deletions(-)

[1] https://lkml.org/lkml/2014/6/24/921
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

