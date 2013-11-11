Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3KKQsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:48:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44083 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab3KKQsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:48:22 -0500
From: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: [PATCH 00/12] Introduce davinci AEMIF driver
Thread-Topic: [PATCH 00/12] Introduce davinci AEMIF driver
Thread-Index: AQHO3vrbsbAOIc0ysUCAl7g5+OlL2pogO+1D
Date: Mon, 11 Nov 2013 16:47:37 +0000
Message-ID: <4F5844B3A985794BA902E12C070812375F8CD5@DNCE04.ent.ti.com>
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.56]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches introduce AEMIF driver for davinci/keystone archs
and defines AEMIF and NAND devices in keystone DT.
Also some changes added to davinci NAND driver in order to reuse it
for Keystone arch.

The patches can be spitted to several series if needed, like

12      - add AEMIF/NAND device entry in DT
arm: dts: keystone: add AEMIF/NAND device entry

9-11    - reuse davinci-nand driver for keystone arch
mtd: nand: davinci: don't request AEMIF address range
mtd: nand: davinci: don't set timings if AEMIF is used
mtd: nand: davinci: reuse driver for Keystone arch

7-8     - introduce AEMIF driver
memory: davinci-aemif: add bindings for AEMIF driver
memory: davinci-aemif: introduce AEMIF driver

4-6     - move davinci-nand bindings under mtd
mtd: nand: davinci: adjust DT properties to MTD generic
mtd: nand: davinci: extend description of bindings
mtd: nand: davinci: move bindings under mtd

1-3     - separate nand fixes
mtd: nand: davinci: simplify error handling
mtd: nand: davinci: check required ti,davinci-chipselect property
mtd: nand: davinci: fix driver registration

See Documentation:
Davinci DM646x - http://www.ti.com/lit/ug/sprueq7c/sprueq7c.pdf
OMAP-L138 - http://www.ti.com/lit/ug/spruh77a/spruh77a.pdf
Kestone - http://www.ti.com/lit/ug/sprugz3a/sprugz3a.pdf

Test:
# flash_erase /dev/mtd2 0 0

Erasing 128 Kibyte @ 7de0000 -- 99 % complete flash_erase: Skipping bad block at
07e00000
flash_erase: Skipping bad block at 07e20000
flash_erase: Skipping bad block at 07e40000
flash_erase: Skipping bad block at 07e60000
Erasing 128 Kibyte @ 7e60000 -- 100 % complete

# nandtest -k -p 3 /dev/mtd2
ECC corrections: 0
ECC failures   : 0
Bad blocks     : 4
BBT blocks     : 0
Bad block at 0x07e00000
Bad block at 0x07e20000
Bad block at 0x07e40000
Bad block at 0x07e60000

Finished pass 1 successfully
Bad block at 0x07e00000F44864
Bad block at 0x07e20000
Bad block at 0x07e40000
Bad block at 0x07e60000

Finished pass 2 successfully
Bad block at 0x07e00000
Bad block at 0x07e20000
Bad block at 0x07e40000
Bad block at 0x07e60000

Finished pass 3 successfully

Based on
git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
keystone/master

Ivan Khoronzhuk (12):
  mtd: nand: davinci: fix driver registration
  mtd: nand: davinci: check required ti,davinci-chipselect property
  mtd: nand: davinci: simplify error handling
  mtd: nand: davinci: move bindings under mtd
  mtd: nand: davinci: extend description of bindings
  mtd: nand: davinci: adjust DT properties to MTD generic
  memory: davinci-aemif: introduce AEMIF driver
  memory: davinci-aemif: add bindings for AEMIF driver
  mtd: nand: davinci: reuse driver for Keystone arch
  mtd: nand: davinci: don't set timings if AEMIF is used
  mtd: nand: davinci: don't request AEMIF address range
  arm: dts: keystone: add AEMIF/NAND device entry

 .../devicetree/bindings/arm/davinci/nand.txt       |   46 ---
 .../bindings/memory-controllers/davinci-aemif.txt  |  198 ++++++++++
 .../devicetree/bindings/mtd/davinci-nand.txt       |   94 +++++
 arch/arm/boot/dts/keystone.dts                     |   63 +++
 drivers/memory/Kconfig                             |   11 +
 drivers/memory/Makefile                            |    1 +
 drivers/memory/davinci-aemif.c                     |  415 ++++++++++++++++++++
 drivers/mtd/nand/Kconfig                           |    6 +-
 drivers/mtd/nand/davinci_nand.c                    |   95 +++--
 9 files changed, 839 insertions(+), 90 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/davinci/nand.txt
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/davinci-aemif.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/davinci-nand.txt
 create mode 100644 drivers/memory/davinci-aemif.c

--
1.7.9.5

