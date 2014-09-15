Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaIOOB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:01:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38248 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752747AbaIOOB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:01:57 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/9] ARM: Berlin: Ethernet support
Date: Mon, 15 Sep 2014 16:01:44 +0200
Message-Id: <1410789713-15341-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This series introduce support for the Ethernet controller on Berlin SoCs,
using the existing pxa168 Ethernet driver. In order to do this, DT
support is added to the driver alongside some other modifications and
fixes.

This has been tested on a Berlin BG2Q DMP board.

Changes since v2:
	- reworked how the MAC address is configured
	- made the clock anonymous

Changes since v1:
        - removed custom Berlin Ethernet driver
        - used the pxa168 Ethernet driver instead
        - made modifications to the pxa168 driver (DT support, fixes)

Antoine Tenart (9):
  net: pxa168_eth: clean up
  net: pxa168_eth: add device tree support
  Documentation: bindings: net: add the Marvell PXA168 Ethernet
    controller
  net: pxa168_eth: fix Ethernet flow control status
  net: pxa168_eth: get and set the mac address on the Ethernet
    controller
  net: pxa168_eth: rework the MAC address setup
  net: pxa168_eth: allow Berlin SoCs to use the pxa168_eth driver
  ARM: dts: berlin: add the Ethernet node
  ARM: dts: berlin: enable the Ethernet port on the BG2Q DMP

 .../devicetree/bindings/net/marvell-pxa168.txt     |  21 ++
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |   4 +
 arch/arm/boot/dts/berlin2q.dtsi                    |  10 +
 drivers/net/ethernet/marvell/Kconfig               |   2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          | 216 +++++++++++++--------
 5 files changed, 174 insertions(+), 79 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell-pxa168.txt

-- 
1.9.1

