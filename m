Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaIPT42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:56:28 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:4738 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaIPT40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:56:26 -0400
X-IronPort-AV: E=Sophos;i="5.04,535,1406617200"; 
   d="scan'208";a="46147855"
From: Jonathan Richardson <jonathar@broadcom.com>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, JD Zheng <jdzheng@broadcom.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        Jonathan Richardson <jonathar@broadcom.com>
Subject: [PATCH 0/6] Add initial support for Broadcom Cygnus SoC 
Date: Tue, 16 Sep 2014 12:58:11 -0700
Message-ID: <1410897497-27527-1-git-send-email-jonathar@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Jonathan Richardson <jonathar@broadcom.com>
References: <Jonathan Richardson <jonathar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset contains initial support for Broadcom's Cygnus SoC based on our
iProc architecture. Initial support is minimal and includes just the mach
platform code, clock driver, and a basic device tree configuration. Peripheral
drivers will be submitted soon, as will device tree configurations for other
Cygnus board variants.

Jonathan Richardson (5):
  ARM: cygnus: Initial support for Broadcom Cygnus SoC
  clk: Clock driver support for Broadcom Cygnus SoC
  dt-bindings: Document Broadcom Cygnus SoC and clock driver
  ARM: dts: Enable Broadcom Cygnus SoC
  ARM: cygnus defconfig : Initial defconfig for Broadcom Cygnus SoC
  MAINTAINERS: Entry for Cygnus/iproc arm architecture and clock
    drivers

 Documentation/devicetree/bindings/arm/cygnus.txt   |   12 +
 .../devicetree/bindings/clock/clk-cygnus.txt       |  121 ++
 .../devicetree/bindings/clock/clk-iproc.txt        |   48 +
 MAINTAINERS                                        |   21 +
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |  344 ++++++
 arch/arm/boot/dts/bcm911360_entphn.dts             |   17 +
 arch/arm/configs/bcm_cygnus_defconfig              |  223 ++++
 arch/arm/mach-bcm/Kconfig                          |   34 +
 arch/arm/mach-bcm/Makefile                         |    3 +
 arch/arm/mach-bcm/board_bcm_cygnus.c               |  166 +++
 drivers/clk/Makefile                               |    1 +
 drivers/clk/bcm/Makefile                           |    2 +
 drivers/clk/bcm/clk-cygnus.c                       | 1179 ++++++++++++++++++++
 drivers/clk/bcm/clk-iproc.c                        |  446 ++++++++
 15 files changed, 2618 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/cygnus.txt
 create mode 100644 Documentation/devicetree/bindings/clock/clk-cygnus.txt
 create mode 100644 Documentation/devicetree/bindings/clock/clk-iproc.txt
 create mode 100644 arch/arm/boot/dts/bcm-cygnus.dtsi
 create mode 100644 arch/arm/boot/dts/bcm911360_entphn.dts
 create mode 100644 arch/arm/configs/bcm_cygnus_defconfig
 create mode 100644 arch/arm/mach-bcm/board_bcm_cygnus.c
 create mode 100644 drivers/clk/bcm/clk-cygnus.c
 create mode 100644 drivers/clk/bcm/clk-iproc.c

-- 
1.7.9.5

