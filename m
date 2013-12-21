Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3LUCOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 21:14:55 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:20483 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3LUCOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 21:14:08 -0500
X-IronPort-AV: E=Sophos;i="4.95,525,1384329600"; 
   d="scan'208";a="4514645"
From: Sherman Yin <syin@broadcom.com>
To: Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Sherman Yin <syin@broadcom.com>
Subject: [PATCH v4 0/6] Add Broadcom Capri pinctrl driver
Date: Fri, 20 Dec 2013 18:13:32 -0800
Message-ID: <1387592016-13740-1-git-send-email-syin@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386787041-6035-1-git-send-email-syin@broadcom.com>
References: <1386787041-6035-1-git-send-email-syin@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches adds a pinctrl driver for Broadcom Capri (BCM281xx) SoCs.
The first patch, adding the void * to pinctrl_pin_desc, has been previously
discussed with LinusW.  See this thread:

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-April/165880.html
---
v4: - removed patch to add new properties to generic pinconfig (merged)
    - Updated bias-pull-up property to accept R value in Ohms instead of an enum
    - move PINCTRL_CAPRI to defconfig
    - Use regmap MMIO
v3: Re-worked driver to be based on generic pinconfig, addressed review
    comments and other supporting changes:
    - moved config selection from Kconfig to defconfig
    - added slew-rate, input enable, input disable properties for generic
      pinconfig
    - added a description for PINCTRL config
v2: Use hyphens instead of underscore in DT property names.

Sherman Yin (6):
  pinctrl: Add void * to pinctrl_pin_desc
  pinctrl: Adds slew-rate, input-enable/disable
  pinctrl: Make PINCTRL selectable by defconfig/menuconfig
  pinctrl: Add pinctrl binding for Broadcom Capri SoCs
  ARM: pinctrl: Add Broadcom Capri pinctrl driver
  pinctrl: Enable pinctrl for Broadcom Capri SoCs

 .../bindings/pinctrl/brcm,capri-pinctrl.txt        |  429 ++++++
 .../bindings/pinctrl/pinctrl-bindings.txt          |    3 +
 arch/arm/boot/dts/bcm11351.dtsi                    |    4 +
 arch/arm/configs/bcm_defconfig                     |    5 +
 drivers/pinctrl/Kconfig                            |   13 +-
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinconf-generic.c                  |    4 +
 drivers/pinctrl/pinctrl-capri.c                    | 1408 ++++++++++++++++++++
 include/linux/pinctrl/pinconf-generic.h            |    4 +
 include/linux/pinctrl/pinctrl.h                    |    2 +
 10 files changed, 1872 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/brcm,capri-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-capri.c

-- 
1.7.9.5

