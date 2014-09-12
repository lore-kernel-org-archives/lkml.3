Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaILRuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:50:09 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:59014 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaILRuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:50:07 -0400
From: Robert Richter <rric@kernel.org>
To: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>
Subject: [PATCH v3 0/4] arm64, thunder: Enable Cavium Thunder SoC Family
Date: Fri, 12 Sep 2014 19:49:43 +0200
Message-Id: <1410544187-15876-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rrichter@cavium.com>

This initial patches enable Cavium Thunder SoC Family. The patches add
devicetree and Kconfig support and then add Thunder to the defconfig.

The Thunder system needs more enablement patches for subsystems and
devices, this includes network, ahci, gicv3/gicv3-its, pci, smmu, kvm.
We will send separate patch sets for these. All of them base on this
initial patches.

I sent a separate patch set independently that introduces support for
dts vendor subdirs. After both patch sets have been applied I will
send a patch in addition that moves the dts file into a subdirectory.

I sent another separate patch that sets NR_CPUS to 64 per default.

The first patch introduces dts files without having a Kconfig option
for the soc (ARCH_THUNDER). However, this is introduced in patch 3 and
added to defconfig in patch 4 as this is my preferred solution. If
there is still resistance having an ARCH_THUNDER option, just drop
them.

Patches are available here:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/linux.git thunder/init

v3 changes:
* removed setting NR_CPUS for Thunder, I sent a separate patch that
  increases this to 64 cpus per default
* reordered patches, dts files changes are know first using dtb-y
  instead of ARCH_THUNDER option
* moved soc nodes to thunder-88xx.dtsi

v2 changes:
* rebased to 3.17
* placed commas between 32-bit portions of 64 bit addresses
* removed #address-cells and size-cells in gic node
* get rid of the clocks node
* changed to gpl/x11 dual license
* removed memreserve
* moved gic to bus node

Radha Mohan Chintakuntla (3):
  arm64, thunder: Add initial dts for Cavium Thunder SoC
  arm64, thunder: Document devicetree bindings for Cavium Thunder SoC
  arm64, thunder: Add Kconfig option for Cavium Thunder SoC Family

Robert Richter (1):
  arm64, defconfig: Enable Cavium Thunder SoC in defconfig

 .../devicetree/bindings/arm/cavium-thunder.txt     |  10 +
 Documentation/devicetree/bindings/arm/cpus.txt     |   1 +
 arch/arm64/Kconfig                                 |   5 +
 arch/arm64/boot/dts/Makefile                       |   1 +
 arch/arm64/boot/dts/thunder-88xx.dts               |  67 ++++
 arch/arm64/boot/dts/thunder-88xx.dtsi              | 401 +++++++++++++++++++++
 arch/arm64/configs/defconfig                       |   1 +
 7 files changed, 486 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/cavium-thunder.txt
 create mode 100644 arch/arm64/boot/dts/thunder-88xx.dts
 create mode 100644 arch/arm64/boot/dts/thunder-88xx.dtsi

-- 
2.1.0

