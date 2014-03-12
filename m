Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaCLUQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:16:09 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:11104 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbaCLUQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:16:01 -0400
X-IronPort-AV: E=Sophos;i="4.97,640,1389772800"; 
   d="scan'208";a="19103986"
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>,
        Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, "Rob Landley" <rob@landley.net>,
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
Subject: [PATCH v3 0/5] Add Broadcom Kona PWM Support
Date: Wed, 12 Mar 2014 13:15:41 -0700
Message-ID: <1394655346-30048-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces the driver for the Kona PWM controller found in
Broadcom mobile SoCs like bcm281xx and updates the device tree and the
defconfig to enable use of this hardware on the bcm28155 AP board.

Changes since v2:
  - SoC DTS file updated to use real clock's phandle + specifier
  - Toggle smooth mode off during apply so new settings take immediately

Changes since v1:
  - Fixed up macros to be clearer and more complete
  - Corrected spelling and punctuation mistakes
  - Added support for polarity
  - Made peripheral clock use more efficient
  - Made prescale and duty computation clearer
  - Moved Makefile addition to keep alphabetical
  - Split complex lines into multiple steps

Dependencies:
The "ARM: dts: Declare the PWM for bcm11351 (bcm281xx)" patch depends
upon "ARM: dts: bcm281xx: define real clocks" which is queued up in
for-next of arm-soc. See https://lkml.org/lkml/2014/2/14/451

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
 drivers/pwm/pwm-bcm-kona.c                         | 304 +++++++++++++++++++++
 7 files changed, 353 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
 create mode 100644 drivers/pwm/pwm-bcm-kona.c

-- 
1.8.0.1

