Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaJVCKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 22:10:31 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:9512 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaJVCKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 22:10:23 -0400
X-IronPort-AV: E=Sophos;i="5.04,766,1406617200"; 
   d="scan'208";a="48677216"
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
Subject: [PATCH v6 0/6] Add initial support for Broadcom Cygnus SoC
Date: Tue, 21 Oct 2014 19:09:46 -0700
Message-ID: <1413943792-7379-1-git-send-email-sbranden@broadcom.com>
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

Changes from v5:
 - removed one level of menu used in mach-bcm/Kconfig
 - changed MAINTAINERS to use N: to support all files associated with iproc
   and cygnus going forward
 - updated bcm_cygnus_defconfig to remove some DEBUG options that greatly
   hamper performance

Changes from v4:
 - simple clock tree used. reworked clock driver will be submitted later
 - fixed MAINTAINERS patchset error
 - removed DEBUG_UART_8250 Kconfig.debug legacy support
 - made ARCH_BCM_IPROC a silent Kconfig option
 - removed multi_v7_defconfig as it is not needed at this time, can
   support in future patchset but does not seem optimal configs for our
   current usage.
 
Changes from v3:
 - restart functionality removed.  Will be added in a different patchset
   in drivers/power
 - removed NEON init sequence.  Will be moved to bootloader
 - cleaned up Kconfigs for ARCH_BCM_CYGNUS by removing unnecessary selects
 - consolidated ARCH_BCM_IPROC with select from ARCH_BCM_CYGNUS and
   ARCH_BCM5301X
 - removed bcm911360_entphn binding
 - added documentation for SoCs currently supported in Cygnus family

Changes from v2:
 - rebased to 3.17 kernel

Changes from v1:
 - Address code review comments as per previous responses.
 - Copyright headers updated to remove Broadcom URL.
 - mach platform code still contains hard coded addresses. These address are
   the same for all Cygnus variants. Could you please provide guidance on where
   they should go if you would still like them changed.  There does not seem to
   be a reason to change them to device tree as they do not change.

Jonathan Richardson (3):
  ARM: cygnus: Initial support for Broadcom Cygnus SoC
  dt-bindings: Document Broadcom Cygnus SoC and clocks
  ARM: cygnus defconfig : Initial defconfig for Broadcom Cygnus SoC

Scott Branden (3):
  ARM: dts: Enable Broadcom Cygnus SoC
  MAINTAINERS: Entry for Cygnus/iproc arm architecture
  ARM: mach-bcm: Consolidate currently supported IPROC SoCs

 .../devicetree/bindings/arm/bcm/cygnus.txt         |   31 +++
 .../devicetree/bindings/clock/bcm-cygnus-clock.txt |   34 +++
 MAINTAINERS                                        |   14 ++
 arch/arm/boot/dts/Makefile                         |    4 +
 arch/arm/boot/dts/bcm-cygnus-clock.dtsi            |   73 ++++++
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |  109 +++++++++
 arch/arm/boot/dts/bcm911360_entphn.dts             |   22 ++
 arch/arm/boot/dts/bcm911360k.dts                   |   22 ++
 arch/arm/boot/dts/bcm958300k.dts                   |   22 ++
 arch/arm/configs/bcm_cygnus_defconfig              |  237 ++++++++++++++++++++
 arch/arm/mach-bcm/Kconfig                          |   65 ++++--
 arch/arm/mach-bcm/Makefile                         |    3 +
 arch/arm/mach-bcm/bcm_cygnus.c                     |   26 +++
 13 files changed, 641 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/cygnus.txt
 create mode 100644 Documentation/devicetree/bindings/clock/bcm-cygnus-clock.txt
 create mode 100644 arch/arm/boot/dts/bcm-cygnus-clock.dtsi
 create mode 100644 arch/arm/boot/dts/bcm-cygnus.dtsi
 create mode 100644 arch/arm/boot/dts/bcm911360_entphn.dts
 create mode 100644 arch/arm/boot/dts/bcm911360k.dts
 create mode 100644 arch/arm/boot/dts/bcm958300k.dts
 create mode 100644 arch/arm/configs/bcm_cygnus_defconfig
 create mode 100644 arch/arm/mach-bcm/bcm_cygnus.c

-- 
1.7.9.5

