Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaJHF1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 01:27:39 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:56525 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaJHF1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 01:27:37 -0400
X-IronPort-AV: E=Sophos;i="5.04,675,1406617200"; 
   d="scan'208";a="47678150"
From: Scott Branden <sbranden@broadcom.com>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>
CC: JD Zheng <jdzheng@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Scott Branden <sbranden@broadcom.com>
Subject: [PATCH V3 0/6] Add initial support for Broadcom Cygnus SoC 
Date: Tue, 7 Oct 2014 22:26:59 -0700
Message-ID: <1412746025-11998-1-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Scott Branden <sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains initial support for Broadcom's Cygnus SoC based on our
iProc architecture. Initial support is minimal and includes just the mach
platform code, clock driver, and a basic device tree configuration. Peripheral
drivers will be submitted soon, as will device tree configurations for other
Cygnus board variants.

Changes from v2:
 - rebased to 3.17 kernel

Changes from v1:
 - Address code review comments as per previous responses.
 - Copyright headers updated to remove Broadcom URL.
 - mach platform code still contains hard coded addresses. These address are
   the same for all Cygnus variants. Could you please provide guidance on where
   they should go if you would still like them changed.  There does not seem to
   be a reason to change them to device tree as they do not change.

Jonathan Richardson (6):
  ARM: cygnus: Initial support for Broadcom Cygnus SoC
  clk: Clock driver support for Broadcom Cygnus SoC
  dt-bindings: Document Broadcom Cygnus SoC and clock driver
  ARM: cygnus defconfig : Initial defconfig for Broadcom Cygnus SoC
  ARM: dts: Enable Broadcom Cygnus SoC
  MAINTAINERS: Entry for Cygnus/iproc arm architecture and clock
    drivers

 Documentation/devicetree/bindings/arm/cygnus.txt   |   12 +
 .../devicetree/bindings/clock/clk-cygnus.txt       |  121 ++
 .../devicetree/bindings/clock/clk-iproc.txt        |   48 +
 MAINTAINERS                                        |   15 +
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |  349 ++++++
 arch/arm/boot/dts/bcm911360_entphn.dts             |   22 +
 arch/arm/configs/bcm_cygnus_defconfig              |  222 ++++
 arch/arm/mach-bcm/Kconfig                          |   31 +
 arch/arm/mach-bcm/Makefile                         |    3 +
 arch/arm/mach-bcm/bcm_cygnus.c                     |  166 +++
 drivers/clk/Makefile                               |    1 +
 drivers/clk/bcm/Makefile                           |    2 +
 drivers/clk/bcm/clk-cygnus.c                       | 1186 ++++++++++++++++++++
 drivers/clk/bcm/clk-iproc.c                        |  451 ++++++++
 15 files changed, 2630 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/cygnus.txt
 create mode 100644 Documentation/devicetree/bindings/clock/clk-cygnus.txt
 create mode 100644 Documentation/devicetree/bindings/clock/clk-iproc.txt
 create mode 100644 arch/arm/boot/dts/bcm-cygnus.dtsi
 create mode 100644 arch/arm/boot/dts/bcm911360_entphn.dts
 create mode 100644 arch/arm/configs/bcm_cygnus_defconfig
 create mode 100644 arch/arm/mach-bcm/bcm_cygnus.c
 create mode 100644 drivers/clk/bcm/clk-cygnus.c
 create mode 100644 drivers/clk/bcm/clk-iproc.c

-- 
1.7.9.5

