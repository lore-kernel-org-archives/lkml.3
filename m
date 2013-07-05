Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab3GEMkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:40:39 -0400
Received: from gloria.sntech.de ([95.129.55.99]:33573 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab3GEMki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:40:38 -0400
To: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 0/6] ARM: rockchip: add smp functionality
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
Date: Fri, 5 Jul 2013 14:40:18 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307051440.19428.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series enables the use of the additional cores on Rockchip
Cortex-A9 SoCs.

To achieve this, add the scu, the needed sram and power-management-unit.

Tested on a rk3066a (dual core) by me and on a rk3188 (quad core)
by Ulrich Prinz.

(Note: rk3188 support in general needs additional upcoming patchsets)


changes since v2:
- rework the sram allocation following the suggestion from Philipp Zabel

changes since v1:
- add reserved block feature for mmio-sram, to not use two logical
  sram nodes
- the sram content is kept intact while the device is running, so
  copying the trampoline is only needed once

Heiko Stuebner (6):
  misc: sram: fix error path in sram_probe
  misc: sram: add ability to mark sram sections as reserved
  ARM: rockchip: add snoop-control-unit
  ARM: rockchip: add sram dt nodes and documentation
  ARM: rockchip: add power-management-unit dt node
  ARM: rockchip: add smp bringup code

 .../devicetree/bindings/arm/rockchip/pmu.txt       |   16 ++
 .../devicetree/bindings/arm/rockchip/smp-sram.txt  |   23 +++
 Documentation/devicetree/bindings/misc/sram.txt    |    8 +
 arch/arm/boot/dts/rk3066a.dtsi                     |   16 ++
 arch/arm/mach-rockchip/Kconfig                     |    1 +
 arch/arm/mach-rockchip/Makefile                    |    1 +
 arch/arm/mach-rockchip/core.h                      |   22 +++
 arch/arm/mach-rockchip/headsmp.S                   |   32 +++
 arch/arm/mach-rockchip/platsmp.c                   |  203 ++++++++++++++++++++
 arch/arm/mach-rockchip/rockchip.c                  |    2 +
 drivers/misc/sram.c                                |   79 +++++++-
 11 files changed, 398 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/pmu.txt
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/smp-sram.txt
 create mode 100644 arch/arm/mach-rockchip/core.h
 create mode 100644 arch/arm/mach-rockchip/headsmp.S
 create mode 100644 arch/arm/mach-rockchip/platsmp.c

-- 
1.7.10.4

