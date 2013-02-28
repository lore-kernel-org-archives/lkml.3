Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab3B1WzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:55:14 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52464 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3B1WzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:55:08 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 1/3] arm-soc: i.MX DT changes
Date: Thu, 28 Feb 2013 14:54:50 -0800
Message-Id: <1362092093-4839-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1362092093-4839-1-git-send-email-olof@lixom.net>
References: <1362092093-4839-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains of devicetree changes for the Freescale i.MX platform.

The base patch of the branch changes the format of the dts files to a
slightly different format that makes it easier to do derivative board
definitions, but it also introduces a lot of churn in the process since
every line of the file is touched.

On top of that are a handful of the regular changes; enabling more boards
as DT-based instead of legacy board files (mx25pdk), enabling another
driver for devicetree and thus adding bindings (onewire), etc.

I'm not happy about the churn, and will likely not take it for other platforms
in the future.

----------------------------------------------------------------

The following changes since commit 2a7d2b96d5cba7568139d9ab157a0e97ab32440f:

  Merge branch 'akpm' (final batch from Andrew)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/late-dt

for you to fetch changes up to 4a9226a3d192c38493106dcaf5f47f291ede9ed5:

  Merge branch 'imx/cpuidle' into late/dt

----------------------------------------------------------------

Anson Huang (1):
      ARM: dts: i.MX6: Add regulator delay support

Arnd Bergmann (1):
      Merge branch 'imx/cpuidle' into late/dt

Fabio Estevam (5):
      ARM: dts: imx27-3ds: Rename it to imx27-pdk
      ARM: boot: dts: Add an entry for imx27-pdk.dtb
      ARM: mx25pdk: Add device tree support
      ARM: dts: imx25-karo-tx25: Put status entry in the end
      ARM: dts: imx6q: Remove silicon version from SDMA firmware

Laurent Cans (1):
      ARM: dts: Add apf51 basic support

Liu Ying (2):
      ARM: dts: imx: Add imx51 KPP entry
      ARM i.MX51 babbage: Add keypad support

Martin Fuzzey (3):
      W1: Add device tree support to MXC onewire master.
      ARM: i.MX53: Add clocks for i.mx53 onewire master.
      ARM: dts: Add device tree entry for onewire master on i.MX53

Olof Johansson (1):
      Merge tag 'imx-dt-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into late/dt

Peter Chen (1):
      ARM i.MX6: change mxs usbphy clock usage

Sascha Hauer (1):
      ARM i.MX53: add dts for the TQ tqma53 module

Shawn Guo (6):
      Merge tag 'imx-fixes-3.8-4' into imx/dt
      ARM: dts: add missing imx dtb targets
      ARM: dts: imx: use nodes label in board dts
      ARM: imx: enable imx6q-cpufreq support
      ARM: dts: rename imx6q.dtsi to imx6qdl.dtsi
      ARM: dts: add dtsi for imx6q and imx6dl

Steffen Trumtrar (2):
      ARM: dts: imx53: pinctrl update
      ARM i.MX53: dts: add oftree for MBa53 baseboard


 .../devicetree/bindings/arm/armadeus.txt        |   6 +
 Documentation/devicetree/bindings/arm/fsl.txt   |   8 +
 .../devicetree/bindings/clock/imx5-clock.txt    |   1 +
 .../devicetree/bindings/clock/imx6q-clock.txt   |   2 +
 .../devicetree/bindings/w1/fsl-imx-owire.txt    |  19 +
 arch/arm/boot/dts/Makefile                      |  10 +-
 arch/arm/boot/dts/imx25-karo-tx25.dts           |  30 +-
 arch/arm/boot/dts/imx25-pdk.dts                 |  36 +
 arch/arm/boot/dts/imx25.dtsi                    |   2 +-
 arch/arm/boot/dts/imx27-apf27.dts               |  82 +-
 .../boot/dts/{imx27-3ds.dts => imx27-pdk.dts}   |  24 +-
 arch/arm/boot/dts/imx31-bug.dts                 |  12 +-
 arch/arm/boot/dts/imx51-apf51.dts               |  52 ++
 arch/arm/boot/dts/imx51-babbage.dts             | 478 +++++------
 arch/arm/boot/dts/imx51.dtsi                    |  53 ++
 arch/arm/boot/dts/imx53-ard.dts                 | 126 ++-
 arch/arm/boot/dts/imx53-evk.dts                 | 194 +++--
 arch/arm/boot/dts/imx53-mba53.dts               | 130 +++
 arch/arm/boot/dts/imx53-qsb.dts                 | 380 +++++----
 arch/arm/boot/dts/imx53-smd.dts                 | 294 ++++---
 arch/arm/boot/dts/imx53-tqma53.dtsi             | 172 ++++
 arch/arm/boot/dts/imx53.dtsi                    |  68 ++
 arch/arm/boot/dts/imx6dl.dtsi                   |  59 ++
 arch/arm/boot/dts/imx6q-arm2.dts                | 124 ++-
 arch/arm/boot/dts/imx6q-sabreauto.dts           |  64 +-
 arch/arm/boot/dts/imx6q-sabrelite.dts           | 216 +++--
 arch/arm/boot/dts/imx6q-sabresd.dts             | 102 ++-
 arch/arm/boot/dts/imx6q.dtsi                    | 796 +-----------------
 arch/arm/boot/dts/imx6qdl.dtsi                  | 800 +++++++++++++++++++
 arch/arm/mach-imx/clk-imx51-imx53.c             |   4 +-
 arch/arm/mach-imx/clk-imx6q.c                   |  26 +-
 arch/arm/mach-imx/mach-imx6q.c                  |  65 ++
 drivers/w1/masters/mxc_w1.c                     |   9 +-
 33 files changed, 2560 insertions(+), 1884 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/armadeus.txt
 create mode 100644 Documentation/devicetree/bindings/w1/fsl-imx-owire.txt
 create mode 100644 arch/arm/boot/dts/imx25-pdk.dts
 rename arch/arm/boot/dts/{imx27-3ds.dts => imx27-pdk.dts} (59%)
 create mode 100644 arch/arm/boot/dts/imx51-apf51.dts
 create mode 100644 arch/arm/boot/dts/imx53-mba53.dts
 create mode 100644 arch/arm/boot/dts/imx53-tqma53.dtsi
 create mode 100644 arch/arm/boot/dts/imx6dl.dtsi
 create mode 100644 arch/arm/boot/dts/imx6qdl.dtsi
