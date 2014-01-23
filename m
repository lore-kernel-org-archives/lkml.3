Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaAWQuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:50:51 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:58128 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaAWQut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:50:49 -0500
MIME-Version: 1.0
Date: Thu, 23 Jan 2014 10:50:48 -0600
Message-ID: <CAL_JsqJe=ge2CsF2GuMd=Ua57V-zDvd-L0nrZNnOdmNdDaPn=A@mail.gmail.com>
Subject: [GIT PULL] DeviceTree for 3.14
From: Rob Herring <robherring2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull DeviceTree updates for 3.14.

Rob

The following changes since commit d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc:

  Linux 3.13-rc7 (2014-01-04 15:12:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
tags/devicetree-for-3.14

for you to fetch changes up to e48ca29d30a10556eb7abd8d91980b8a57dabf10:

  dt-bindings: add rockchip vendor prefix (2014-01-23 09:15:23 -0600)

----------------------------------------------------------------
DeviceTree updates for 3.14:

- Add new documents with guidelines for DT binding stability and review
  process. This is one of the outcomes of Kernel Summit DT discussions.
- Remove a bunch of device_type usage which is only for OF and
  deprecated with FDT.
- Fix a long standing issue with compatible string match ordering.
- Various minor binding documentation updates.

----------------------------------------------------------------
Florian Vaussard (2):
      of: add vendor prefix for Gumstix
      of: add vendor prefixe for EPFL

Gerhard Sittig (1):
      dts: bindings: trivial clock bindings doc fixes

Grant Likely (5):
      dt/bindings: Remove all references to device_type "ethernet-phy"
      dt/bindings: Remove references to linux,phandle properties
      dt/bindings: remove users of device_type "mdio"
      dt/bindings: remove device_type "network" references
      dt/bindings: Remove device_type "serial" from marvell,mv64360-mpsc

Heiko Stübner (1):
      dt-bindings: add rockchip vendor prefix

Jason Cooper (1):
      dt/bindings: submitting patches and ABI documents

Lothar Waßmann (2):
      of: add vendor prefix for Ka-Ro electronics GmbH
      DT: Add vendor prefix for Emerging Display Technologies

Peter Crosthwaite (2):
      of: irq: Ignore disabled interrupt controllers
      of: irq: Ignore disabled intc's when searching map

Rob Herring (3):
      dt-bindings: add GIC-400 binding
      Merge remote-tracking branch 'grant/devicetree/next' into for-3.14
      Merge remote-tracking branch 'grant/devicetree/next' into for-3.14

Sebastian Hesselbarth (1):
      OF: base: match each node compatible against all given matches first

Soren Brinkmann (1):
      devicetree: macb: Document clock properties

Tony Prisk (1):
      serial: vt8500: Add missing binding document for arch-vt8500
serial driver.

Xiubo Li (1):
      of: Fix __of_device_is_available check

 Documentation/devicetree/bindings/ABI.txt          | 39 +++++++++++++++
 Documentation/devicetree/bindings/arm/gic.txt      |  1 +
 .../devicetree/bindings/clock/clock-bindings.txt   |  2 +-
 Documentation/devicetree/bindings/marvell.txt      |  8 ----
 Documentation/devicetree/bindings/net/macb.txt     |  6 +++
 .../devicetree/bindings/net/marvell-orion-net.txt  |  3 --
 Documentation/devicetree/bindings/net/phy.txt      |  5 --
 .../bindings/powerpc/fsl/cpm_qe/network.txt        |  2 -
 .../bindings/powerpc/fsl/cpm_qe/qe/pincfg.txt      |  3 --
 .../devicetree/bindings/serial/vt8500-uart.txt     | 26 ++++++++++
 .../devicetree/bindings/submitting-patches.txt     | 38 +++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  5 ++
 Documentation/devicetree/booting-without-of.txt    |  3 --
 arch/arm/boot/dts/dove.dtsi                        |  2 -
 arch/arm/boot/dts/kirkwood-cloudbox.dts            |  1 -
 arch/arm/boot/dts/kirkwood-db.dtsi                 |  1 -
 arch/arm/boot/dts/kirkwood-dnskw.dtsi              |  1 -
 arch/arm/boot/dts/kirkwood-dockstar.dts            |  1 -
 arch/arm/boot/dts/kirkwood-dreamplug.dts           |  2 -
 arch/arm/boot/dts/kirkwood-goflexnet.dts           |  1 -
 .../arm/boot/dts/kirkwood-guruplug-server-plus.dts |  2 -
 arch/arm/boot/dts/kirkwood-ib62x0.dts              |  1 -
 arch/arm/boot/dts/kirkwood-iconnect.dts            |  1 -
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts      |  1 -
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts         |  1 -
 arch/arm/boot/dts/kirkwood-lsxl.dtsi               |  2 -
 arch/arm/boot/dts/kirkwood-mplcec4.dts             |  2 -
 .../boot/dts/kirkwood-netgear_readynas_duo_v2.dts  |  1 -
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi         |  1 -
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts       |  1 -
 arch/arm/boot/dts/kirkwood-openblocks_a7.dts       |  2 -
 arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi  |  1 -
 arch/arm/boot/dts/kirkwood-topkick.dts             |  1 -
 arch/arm/boot/dts/kirkwood-ts219.dtsi              |  1 -
 arch/arm/boot/dts/kirkwood.dtsi                    |  2 -
 .../dts/orion5x-lacie-ethernet-disk-mini-v2.dts    |  1 -
 arch/arm/boot/dts/orion5x.dtsi                     |  1 -
 arch/microblaze/platform/generic/system.dts        |  1 -
 arch/powerpc/boot/dts/adder875-redboot.dts         |  2 -
 arch/powerpc/boot/dts/adder875-uboot.dts           |  2 -
 arch/powerpc/boot/dts/asp834x-redboot.dts          |  2 -
 arch/powerpc/boot/dts/c2k.dts                      |  5 --
 arch/powerpc/boot/dts/ep8248e.dts                  |  3 --
 arch/powerpc/boot/dts/ep88xc.dts                   |  2 -
 arch/powerpc/boot/dts/gef_ppc9a.dts                |  2 -
 arch/powerpc/boot/dts/gef_sbc310.dts               |  2 -
 arch/powerpc/boot/dts/gef_sbc610.dts               |  2 -
 arch/powerpc/boot/dts/holly.dts                    |  1 -
 arch/powerpc/boot/dts/ksi8560.dts                  |  3 --
 arch/powerpc/boot/dts/mpc7448hpc2.dts              |  1 -
 arch/powerpc/boot/dts/mpc8272ads.dts               |  3 --
 arch/powerpc/boot/dts/mpc8308_p1m.dts              |  2 -
 arch/powerpc/boot/dts/mpc8308rdb.dts               |  1 -
 arch/powerpc/boot/dts/mpc8313erdb.dts              |  1 -
 arch/powerpc/boot/dts/mpc8315erdb.dts              |  2 -
 arch/powerpc/boot/dts/mpc832x_mds.dts              |  2 -
 arch/powerpc/boot/dts/mpc832x_rdb.dts              |  2 -
 arch/powerpc/boot/dts/mpc8349emitx.dts             |  1 -
 arch/powerpc/boot/dts/mpc8349emitxgp.dts           |  1 -
 arch/powerpc/boot/dts/mpc834x_mds.dts              |  2 -
 arch/powerpc/boot/dts/mpc836x_mds.dts              |  2 -
 arch/powerpc/boot/dts/mpc836x_rdk.dts              |  4 --
 arch/powerpc/boot/dts/mpc8377_mds.dts              |  2 -
 arch/powerpc/boot/dts/mpc8377_rdb.dts              |  1 -
 arch/powerpc/boot/dts/mpc8377_wlan.dts             |  2 -
 arch/powerpc/boot/dts/mpc8378_mds.dts              |  2 -
 arch/powerpc/boot/dts/mpc8378_rdb.dts              |  1 -
 arch/powerpc/boot/dts/mpc8379_mds.dts              |  2 -
 arch/powerpc/boot/dts/mpc8379_rdb.dts              |  1 -
 arch/powerpc/boot/dts/mpc8536ds.dtsi               |  2 -
 arch/powerpc/boot/dts/mpc8540ads.dts               |  3 --
 arch/powerpc/boot/dts/mpc8541cds.dts               |  2 -
 arch/powerpc/boot/dts/mpc8544ds.dtsi               |  2 -
 arch/powerpc/boot/dts/mpc8548cds.dtsi              |  4 --
 arch/powerpc/boot/dts/mpc8555cds.dts               |  2 -
 arch/powerpc/boot/dts/mpc8560ads.dts               |  4 --
 arch/powerpc/boot/dts/mpc8568mds.dts               |  8 ----
 arch/powerpc/boot/dts/mpc8569mds.dts               |  6 ---
 arch/powerpc/boot/dts/mpc8641_hpcn.dts             |  4 --
 arch/powerpc/boot/dts/mpc8641_hpcn_36b.dts         |  4 --
 arch/powerpc/boot/dts/mpc866ads.dts                |  1 -
 arch/powerpc/boot/dts/mpc885ads.dts                |  3 --
 arch/powerpc/boot/dts/p1021mds.dts                 |  2 -
 arch/powerpc/boot/dts/p1025rdb_32b.dts             |  2 -
 arch/powerpc/boot/dts/ppa8548.dts                  |  2 -
 arch/powerpc/boot/dts/pq2fads.dts                  |  3 --
 arch/powerpc/boot/dts/prpmc2800.dts                |  5 --
 arch/powerpc/boot/dts/sbc8349.dts                  |  2 -
 arch/powerpc/boot/dts/sbc8548-post.dtsi            |  2 -
 arch/powerpc/boot/dts/sbc8641d.dts                 |  4 --
 arch/powerpc/boot/dts/stx_gp3_8560.dts             |  2 -
 arch/powerpc/boot/dts/stxssa8555.dts               |  2 -
 arch/powerpc/boot/dts/tqm8540.dts                  |  3 --
 arch/powerpc/boot/dts/tqm8541.dts                  |  3 --
 arch/powerpc/boot/dts/tqm8548-bigflash.dts         |  5 --
 arch/powerpc/boot/dts/tqm8548.dts                  |  5 --
 arch/powerpc/boot/dts/tqm8555.dts                  |  3 --
 arch/powerpc/boot/dts/tqm8560.dts                  |  3 --
 arch/powerpc/boot/dts/tqm8xx.dts                   |  1 -
 arch/powerpc/sysdev/mv64x60_dev.c                  |  2 +-
 arch/powerpc/sysdev/mv64x60_udbg.c                 |  2 +-
 drivers/of/base.c                                  | 56 +++++++++++++++-------
 drivers/of/irq.c                                   |  6 ++-
 103 files changed, 163 insertions(+), 231 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ABI.txt
 create mode 100644 Documentation/devicetree/bindings/serial/vt8500-uart.txt
 create mode 100644 Documentation/devicetree/bindings/submitting-patches.txt
