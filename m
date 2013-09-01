Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab3IALeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 07:34:06 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:34247 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab3IALeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 07:34:04 -0400
From: oliver+list@schinagl.nl
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, tomasz.figa@gmail.com,
        maxime.ripard@free-electrons.com,
        Oliver Schinagl <oliver+list@schinagl.nl>
Subject: [PATCHv6 0/2] ARM: sunxi: Driver for Allwinner sunxi Security ID
Date: Sun,  1 Sep 2013 13:30:17 +0200
Message-Id: <1378035019-9649-1-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver+list@schinagl.nl>

Hopefully it is polished enough for inclusion now :)

Oliver

Changes from v5:
  * Added dts for A10s
  * Move ABI documentation to testing
  * Improve documentation overal
  * Expand comments about future changes for when Greg fixes sysfs bin attrs
  * Rename sun7i-sid to sun7i-a20-sid for the compatible field

Changes from v4:
  * Added sun7i (A20) support, also tested on Cubieboard 2.0 and OlinuXino A20
  * prepare source for move to binary attribute groups
  * Removed useless internal braces
  * Dropped DRV_NAME from dvb_dvb
  * Add and pass struct using platform_[gs]et_drvdata()
  * Add Documentation!
  * Reviewed-by: Tomasz Figa <tomasz.figa@gmail.com>

Changes from v3:
  * Cleanup comments
  * Remove last byte masking and useless casting, the C standard guarntees
we are ok
  * Removed some complexity from sid_read, thanks to Russel
  * Replace dev_info with dev_dbg reducing the verbosity
  * Removed driver version
  * Reorderd variable declrations based on usage, return value always last
  * Removed all goto in exchange for return, due to popular request
  * Reduced line count by removing extra lines

Changes from v2:
  * Removed the global pointer, we can change that when the need for external
    access arises
  * Fixed header inclusions
  * Corrected if guards. There where some crude mistakes there
  * Changed offset to an unsigned int so we don't have to worry about negatives
  * Cleaned up variable declarations
  * Changed ret value, ENXIO (No device/io) as that better matches a missing dt
  * Made the loading informercial print version so it is somewhat usefull

Changes from v1:
  * Rename the sys-fs exported key to eeprom, since it really a read-only eeprom
  * Removed mention of sun[67]i since we haven't tested those
  * Fixed up mistakes in comments
  * Removed PAGE_SIZE references, since this is a binary only driver
  * Removed lookup table and calculate offsets better
  * Use proper endianess
  * Add the SID to seed the kernel entropy pool
  * Rewrite probe to use platform_get_resource/devm_ioremap_resource instead

The Allwinner A-series of SoC's have efuses exposed via registers to read the
factory programmed e-fuses. These should in theory be programmable but this is
still to be confirmed. It does appear that these fuses are unique enough to be
used as serial numbers, RSA keys, generate MAC addresses from etc. If it turns
out to be user programmable, the use obviously increases. Allwinner did use the
fuses initially to determine the chip-type.

This driver supports all currently known chips based on datasheets and 'dumped'
drivers that we have so far, the dts is only implemented for known chips.

It has been tested on a Cubieboard 1

This is my very first driver so please try to be gentle 

Oliver Schinagl (2):
  ARM: sunxi: Initial support for Allwinner's Security ID fuses
  ARM: sunxi: dt: Add sunxi-sid to dts for sun4i, sun5i and sun7i

 Documentation/ABI/testing/sysfs-driver-sunxi-sid   |  22 +++
 .../bindings/misc/allwinner,sunxi-sid.txt          |  17 ++
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   5 +
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |   5 +
 arch/arm/boot/dts/sun5i-a13.dtsi                   |   5 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   5 +
 drivers/misc/eeprom/Kconfig                        |  13 ++
 drivers/misc/eeprom/Makefile                       |   1 +
 drivers/misc/eeprom/sunxi_sid.c                    | 177 +++++++++++++++++++++
 9 files changed, 250 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-sunxi-sid
 create mode 100644 Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
 create mode 100644 drivers/misc/eeprom/sunxi_sid.c

-- 
1.8.1.5

