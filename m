Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810Ab3CUQ0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:26:30 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54368 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933783Ab3CUQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:26:27 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH 0/5] arm: mvebu: Enable LPAE support for Armada XP SoCs
Date: Thu, 21 Mar 2013 17:26:13 +0100
Message-Id: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The Armada XP SoCs have LPAE support. This patch set allow to run
kernel on this SoCs with LPAE support.

The biggest changes are the conversion of the device tree file to 64
bits in order to be able to use more than 4GB of memory (without this
the LPAE is pointless).

This patch set have been tested on a Armada XP GP board with 8GB of
DRAM with LPAE selected. It have been tested on Armada XP DB board
with 3GB of DRAM with and without LPAE. And also on the Armada 370 DB
board (without LPAE) to check that no regression appeared.

This patch set is based on 3.9-rc3 and is 3.10 material. The
git branch called lpae is available at:
https://github.com/MISL-EBU-System-SW/mainline-public.git.

Thanks,

Gregory CLEMENT (1):
  arm: dts: Convert mvebu device tree files to 64 bits

Lior Amsalem (4):
  arm: mvebu: Aligne the internal registers virtual base to support
    LPAE
  arm: mvebu: Select DMA_BOUNCE when LPAE is selected in Kconfig
  arm: mvebu: Enable pj4b on LPAE compilations
  arm: dts: Add a 64 bits version of the skeleton device tree

 arch/arm/boot/dts/armada-370-db.dts              |    2 +-
 arch/arm/boot/dts/armada-370-mirabox.dts         |    2 +-
 arch/arm/boot/dts/armada-370-rd.dts              |    2 +-
 arch/arm/boot/dts/armada-370-xp.dtsi             |   45 +++++++++++-----------
 arch/arm/boot/dts/armada-370.dtsi                |   28 +++++++-------
 arch/arm/boot/dts/armada-xp-db.dts               |    2 +-
 arch/arm/boot/dts/armada-xp-gp.dts               |   14 ++++---
 arch/arm/boot/dts/armada-xp-mv78230.dtsi         |    6 +--
 arch/arm/boot/dts/armada-xp-mv78260.dtsi         |   10 ++---
 arch/arm/boot/dts/armada-xp-mv78460.dtsi         |   10 ++---
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |    2 +-
 arch/arm/boot/dts/armada-xp.dtsi                 |   34 ++++++++--------
 arch/arm/boot/dts/skeleton64.dtsi                |   13 +++++++
 arch/arm/include/debug/mvebu.S                   |    2 +-
 arch/arm/mach-mvebu/Kconfig                      |    1 +
 arch/arm/mach-mvebu/armada-370-xp.h              |    2 +-
 arch/arm/mm/proc-v7.S                            |    3 +-
 17 files changed, 98 insertions(+), 80 deletions(-)
 create mode 100644 arch/arm/boot/dts/skeleton64.dtsi

-- 
1.7.9.5

