Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3H0OQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:16:26 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:51344 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab3H0OQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:16:25 -0400
From: oliver+list@schinagl.nl
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, maxime.ripard@free-electrons.com,
        tomasz.figa@gmail.com, Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCHv5 0/2] Driver for Allwinner sunxi Security ID
Date: Tue, 27 Aug 2013 16:13:03 +0200
Message-Id: <1377612785-7868-1-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

After a little vacation I had time to address the last few issues and adapted
per request. After a long talk with Greg we decided that after finding some
issues with binary attribute groups that don't currently work with sysfs yet
this micro-driver falls back to the old manual way for now.

Greg said he would clean up all the drivers after his new sysfs patches land
and to ease the conversion I left a few /* fixme */ markers.

Oliver

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
  Initial support for Allwinner's Security ID fuses
  Add sunxi-sid to dts for sun4i, sun5i and sun7i

 Documentation/ABI/stable/sysfs-driver-sunxi-sid    |  22 +++
 .../bindings/misc/allwinner,sunxi-sid.txt          |  16 ++
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   5 +
 arch/arm/boot/dts/sun5i-a13.dtsi                   |   5 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   6 +
 drivers/misc/eeprom/Kconfig                        |  19 +++
 drivers/misc/eeprom/Makefile                       |   1 +
 drivers/misc/eeprom/sunxi_sid.c                    | 177 +++++++++++++++++++++
 8 files changed, 251 insertions(+)
 create mode 100644 Documentation/ABI/stable/sysfs-driver-sunxi-sid
 create mode 100644 Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
 create mode 100644 drivers/misc/eeprom/sunxi_sid.c

-- 
1.8.1.5

