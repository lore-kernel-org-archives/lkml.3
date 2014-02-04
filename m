Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbaBDTyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:54:01 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:61592 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403AbaBDTwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:52:51 -0500
X-IronPort-AV: E=Sophos;i="4.95,781,1384329600"; 
   d="scan'208";a="12926909"
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 0/5] Add Broadcom Kona PWM Support
Date: Tue, 4 Feb 2014 11:51:38 -0800
Message-ID: <1391543503-14773-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces the driver for the Kona PWM controller found in
Broadcom mobile SoCs like bcm281xx and updates the device tree and the
defconfig to enable use of this hardware on the bcm28155 AP board.

Changes since v1:
  - Fixed up macros to be clearer and more complete
  - Corrected spelling and punctuation mistakes
  - Added support for polarity
  - Made peripheral clock use more efficient
  - Made prescale and duty computation clearer
  - Moved Makefile addition to keep alphabetical
  - Split complex lines into multiple steps

Tim Kryger (5):
  Documentation: dt: Add Kona PWM binding
  pwm: kona: Introduce Kona PWM controller support
  ARM: dts: Declare the PWM for bcm11351 (bcm281xx)
  ARM: dts: Enable the PWM for bcm28155 AP board
  ARM: bcm_defconfig: Enable PWM and Backlight

 .../devicetree/bindings/pwm/bcm-kona-pwm.txt       |  24 ++
 arch/arm/boot/dts/bcm11351.dtsi                    |   8 +
 arch/arm/boot/dts/bcm28155-ap.dts                  |   4 +
 arch/arm/configs/bcm_defconfig                     |   2 +
 drivers/pwm/Kconfig                                |  10 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-bcm-kona.c                         | 291 +++++++++++++++++++++
 7 files changed, 340 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
 create mode 100644 drivers/pwm/pwm-bcm-kona.c

-- 
1.8.0.1

