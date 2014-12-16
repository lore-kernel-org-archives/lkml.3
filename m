Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103AbaLPCSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:18:44 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:29838 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaLPCSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:18:42 -0500
X-IronPort-AV: E=Sophos;i="5.07,583,1413270000"; 
   d="scan'208";a="52996626"
From: Ray Jui <rjui@broadcom.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        "Arnd Bergmann" <arnd@arndb.de>
CC: Scott Branden <sbranden@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH v6 0/3] Add gpio support to Broadcom Cygnus SoC
Date: Mon, 15 Dec 2014 18:18:24 -0800
Message-ID: <1418696307-19392-1-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Ray Jui <rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the initial GPIO support for the Broadcom Cygnus SoC.
Cygnus has 3 GPIO controllers: 1) the ASIU GPIO; 2) the chipCommonG GPIO;
and 3) the ALWAYS-ON GPIO. All 3 types of GPIO controllers are supported by
the same Cygnus GPIO driver

Changes from v5:
 - Get rid of DT property "linux,gpio-base". Use dynamic allocation for GPIO base
   number

Changes from v4:
 - Use DT property "linux,gpio-base" to define GPIO base number
 - factorize common code to improve code readability and reduce code size
 - remove "bcm_" prefix on function and struct names
 - improve debugging prints
 - default GPIO_BCM_CYGNUS to y in Kconfig (it still depends on
   ARCH_BCM_CYGNUS). This way we do not need to select it from the
   arch/arm/mach-bcm/Kconfig
 - Get rid of redundant MAINTAINER entry for this driver. It will be maintained
   by Broadcom iProc/Cygnus maintainers
 - Update device tree document based on driver changes

Changes from v3:
 - Fix dt property tpyo
 - Fix incorrect GPIO compatible ID in device tree binding document example

Changes from v2:
 - Consolidate different compatible IDs into "brcm,cygnus-gpio"
 - Get rid of redundant "no-interrupt" property

Changes from v1:
 - Get rid of inline qualifier
 - Get rid of redundant check in the ISR
 - Other minor fixes to imrove code readability

Ray Jui (3):
  gpio: Cygnus: define Broadcom Cygnus GPIO binding
  gpio: Cygnus: add GPIO driver
  ARM: dts: enable GPIO for Broadcom Cygnus

 .../devicetree/bindings/gpio/brcm,cygnus-gpio.txt  |   82 +++
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |   30 +
 drivers/gpio/Kconfig                               |   12 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-bcm-cygnus.c                     |  607 ++++++++++++++++++++
 5 files changed, 732 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/brcm,cygnus-gpio.txt
 create mode 100644 drivers/gpio/gpio-bcm-cygnus.c

-- 
1.7.9.5

