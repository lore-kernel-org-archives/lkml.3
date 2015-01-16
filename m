Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbbAPOsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:48:35 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49624 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbbAPOsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:48:33 -0500
From: Archit Taneja <architt@codeaurora.org>
To: linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agross@codeaurora.org, galak@codeaurora.org,
        Archit Taneja <architt@codeaurora.org>
Subject: [PATCH 0/5] mtd: Qualcomm NAND controller driver
Date: Fri, 16 Jan 2015 20:18:17 +0530
Message-Id: <1421419702-17812-1-git-send-email-architt@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the NAND controller driver for SoC's that contain EBI2. For now,
the only SoC upstream that has EBI2 is IPQ806x.

The patchset requires the ADM dmaengine patches posted by Andy:

http://thread.gmane.org/gmane.linux.ports.arm.msm/11136

Archit Taneja (5):
  clk: qcom: Add EBI2 clocks for IPQ806x
  mtd: nand: Add qcom nand controller driver
  Documentaion: dt: add DT bindings for Qualcomm NAND controller
  arm: qcom: dts: Add NAND controller node for ipq806x
  arm: qcom: dts: Enale NAND node on IPQ8064 AP148 pplatform

 .../devicetree/bindings/mtd/qcom_nandc.txt         |   48 +
 arch/arm/boot/dts/qcom-ipq8064-ap148.dts           |   32 +
 arch/arm/boot/dts/qcom-ipq8064.dtsi                |   19 +-
 drivers/clk/qcom/gcc-ipq806x.c                     |   34 +
 drivers/mtd/nand/Kconfig                           |    7 +
 drivers/mtd/nand/Makefile                          |    1 +
 drivers/mtd/nand/qcom_nandc.c                      | 1995 ++++++++++++++++++++
 include/dt-bindings/clock/qcom,gcc-ipq806x.h       |    1 +
 8 files changed, 2136 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/mtd/qcom_nandc.txt
 create mode 100644 drivers/mtd/nand/qcom_nandc.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

