Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaH2Obr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:31:47 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:46838 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305AbaH2Obp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:31:45 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>
Subject: [PATCH v3 0/4] Add reset support for apq8064
Date: Fri, 29 Aug 2014 20:00:55 +0530
Message-Id: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reset on apq8064 is provided on gpio78 function1. We need to configure
gpio78 to function as ps_hold and write to base of the register to get the
device rebooted. 

First two patches in this patchset adds necessary DT support for apq8064-pinctrl
and DT support to mux gpio_78 as ps_hold function.

Third patch documents the ps_hold function in apq8064-pinctrl DT binding

Fourth implements the actual reset by initialising arm_pm_restart to a reset
function if ps_hold function is programmed in the pinctrl driver.

Changes since v2 to v3:
1. As per Bjorn's review suggestions consolidated all code which detects ps_hold function and
   initializes arm_pm_restart in a single function named msm_pinctrl_setup_pm_reset under 
   #ifdef CONFIG_ARM
2. Removed 10 second delay after carrying out reset which was copied by mistake
3. Renamed pinctl DT node to tlmm_pinumux from msm_gpio 

Changes since v1 to v2:
1. Added #error log as suggested by Kumar Gala 
2. Correct interrupts in DT from 32 to 16 based on Bjorn's new patch in bindings
3. Replaced hardcoding in DT with IRQ_TYPE_LEVEL_HIGH for interrupt level type

Pramod Gurav (4):
  ARM: DT: APQ8064: Add pinctrl support
  ARM: DT: APQ8064: Add node for ps_hold function in pinctrl
  pinctrl: msm: Add ps_hold function in pinctrl-apq8064 binding
    documentation
  pinctrl: qcom: Add support for reset for apq8064

 .../bindings/pinctrl/qcom,apq8064-pinctrl.txt      |    2 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi                |   21 ++++++++++++++
 drivers/pinctrl/qcom/pinctrl-apq8064.c             |    7 ++++-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |   30 ++++++++++++++++++++
 4 files changed, 58 insertions(+), 2 deletions(-)
