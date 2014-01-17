Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaAQUJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 15:09:47 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53472 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaAQUJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 15:09:44 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kbuild-all@01.org
Subject: [PATCH] clk: qcom: Fix modular build
Date: Fri, 17 Jan 2014 12:09:40 -0800
Message-Id: <1389989380-17441-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <52d8dde8.Mqtb7njO7G6foYTt%fengguang.wu@intel.com>
References: <52d8dde8.Mqtb7njO7G6foYTt%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/kbuild/makefiles.txt these symbols
should be clk-qcom-y. Otherwise the build will fail if
CONFIG_COMMON_CLK_QCOM=m. Fix it.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Makefile | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index 190d38433202..f60db2ef1aee 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -1,11 +1,11 @@
 obj-$(CONFIG_COMMON_CLK_QCOM) += clk-qcom.o
 
-clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-regmap.o
-clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-pll.o
-clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-rcg.o
-clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-rcg2.o
-clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += clk-branch.o
-clk-qcom-$(CONFIG_COMMON_CLK_QCOM) += reset.o
+clk-qcom-y += clk-regmap.o
+clk-qcom-y += clk-pll.o
+clk-qcom-y += clk-rcg.o
+clk-qcom-y += clk-rcg2.o
+clk-qcom-y += clk-branch.o
+clk-qcom-y += reset.o
 
 obj-$(CONFIG_MSM_GCC_8660) += gcc-msm8660.o
 obj-$(CONFIG_MSM_GCC_8960) += gcc-msm8960.o
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

