Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaBYLqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:46:13 -0500
Received: from gloria.sntech.de ([95.129.55.99]:33560 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaBYLqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:46:11 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: arm@kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: [PATCH v8 0/6] ARM: rockchip: add smp functionality
Date: Tue, 25 Feb 2014 12:44:59 +0100
Message-ID: <21117503.1c6iOkvYSr@phil>
User-Agent: KMail/4.11.5 (Linux/3.12-1-amd64; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series enables the use of the additional cores on Rockchip
Cortex-A9 SoCs.

To achieve this, add the scu, the needed sram and power-management-unit.

Tested on both a BQ Curie2 (rk3066a / dual core) and
on a Radxa Rock (rk3188 / quad core).

As this version again involves bigger changes to the way reserved sram-
regions are handled, I've dropped the ACKs I had for binding and driver
changes again and therefore would be very happy if I could get new ones
if applicable (dt-maintainers and Philipp Zabel for sram.c).


changes since v7:
- move reserved sram regions to be described through subnodes, similar
  to the general memory-reserve bindings, as suggested by Grant Likely.

changes since v6:
- address comments from Mark Rutland
  - using of_property_read_u32_index instead of parsing the list manually
  - include v4 of "of: add functions to count number of elements in a property"
    to not have to count property-elements manually anymore

changes since v5:
- Grant Likely liked it better to "specify reserved regions of the
  memory instead of the valid ranges", so go back to the mmio-sram-reserved
  property originally suggested by Rob Herring

changes since v4:
- rebase on top of the recent rk3188 board support
- implement suggestion from Matt Sealey in moving the sram-limit from
  marking reserved regions to marking available regions - hopefully
  I got the usage right 
- remove __CPUINIT as suggested by Fabio Estevam

changes since v3:
- address comments from Rob Herring:
  - split the gathering of the reserve-data into a separate loop
  - spelling and style fixes
- first patch only included for reference, already part of the
  char-misc git tree

changes since v2:
- rework the sram allocation following the suggestion from Philipp Zabel

changes since v1:
- add reserved block feature for mmio-sram, to not use two logical
  sram nodes
- the sram content is kept intact while the device is running, so
  copying the trampoline is only needed once

Heiko Stuebner (6):
  dt-bindings: sram: describe option to reserve parts of the memory
  misc: sram: implement reserved sram areas
  ARM: rockchip: add snoop-control-unit
  ARM: rockchip: add sram dt nodes and documentation
  ARM: rockchip: add power-management-unit
  ARM: rockchip: add smp bringup code

 .../devicetree/bindings/arm/rockchip/pmu.txt       |  16 ++
 .../devicetree/bindings/arm/rockchip/smp-sram.txt  |  30 ++++
 Documentation/devicetree/bindings/misc/sram.txt    |  33 ++++
 arch/arm/boot/dts/rk3066a.dtsi                     |  13 ++
 arch/arm/boot/dts/rk3188.dtsi                      |  13 ++
 arch/arm/boot/dts/rk3xxx.dtsi                      |  10 ++
 arch/arm/mach-rockchip/Kconfig                     |   1 +
 arch/arm/mach-rockchip/Makefile                    |   1 +
 arch/arm/mach-rockchip/core.h                      |  22 +++
 arch/arm/mach-rockchip/headsmp.S                   |  30 ++++
 arch/arm/mach-rockchip/platsmp.c                   | 184 +++++++++++++++++++++
 arch/arm/mach-rockchip/rockchip.c                  |   2 +
 drivers/misc/sram.c                                | 125 +++++++++++++-
 13 files changed, 473 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/pmu.txt
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/smp-sram.txt
 create mode 100644 arch/arm/mach-rockchip/core.h
 create mode 100644 arch/arm/mach-rockchip/headsmp.S
 create mode 100644 arch/arm/mach-rockchip/platsmp.c

-- 
1.8.5.3


