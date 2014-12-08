Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaLHCgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 21:36:18 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:11463 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaLHCgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 21:36:15 -0500
X-IronPort-AV: E=Sophos;i="5.07,536,1413270000"; 
   d="scan'208";a="52653924"
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
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>
CC: Scott Branden <sbranden@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH v2 0/5] Add gpio support to Broadcom Cygnus SoC
Date: Sun, 7 Dec 2014 18:38:31 -0800
Message-ID: <1418006316-324-1-git-send-email-rjui@broadcom.com>
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

Changes from v1:
 - Get rid of inline qualifier
 - Get rid of redundant check in the ISR
 - Other minor fixes to imrove code readability

Ray Jui (5):
  gpio: Cygnus: define Broadcom Cygnus GPIO binding
  gpio: Cygnus: add GPIO driver
  ARM: mach-bcm: Enable GPIO support for Cygnus
  ARM: dts: enable GPIO for Broadcom Cygnus
  MAINTAINERS: Entry for Cygnus GPIO driver

 .../devicetree/bindings/gpio/brcm,cygnus-gpio.txt  |   85 +++
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |   30 +
 arch/arm/mach-bcm/Kconfig                          |    1 +
 drivers/gpio/Kconfig                               |   11 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-bcm-cygnus.c                     |  712 ++++++++++++++++++++
 7 files changed, 847 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/brcm,cygnus-gpio.txt
 create mode 100644 drivers/gpio/gpio-bcm-cygnus.c

-- 
1.7.9.5

