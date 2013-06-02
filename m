Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3FBPA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 11:00:29 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:37178 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab3FBPAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 11:00:23 -0400
From: Oliver Schinagl <oliver+list@schinagl.nl>
To: maxime.ripard@free-electrons.com, arnd@arndb.de,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 0/2] v2 Driver for Allwinner sunxi Security ID
Date: Sun,  2 Jun 2013 16:58:48 +0200
Message-Id: <1370185130-15332-1-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

Changes from v1:
* Renamed the sys-fs exported key to eeprom, since it really a read-only eeprom
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
  Add sunxi-sid to dts for sun4i and sun5i

 arch/arm/boot/dts/sun4i-a10.dtsi |   5 ++
 arch/arm/boot/dts/sun5i-a13.dtsi |   5 ++
 drivers/misc/eeprom/Kconfig      |  17 ++++
 drivers/misc/eeprom/Makefile     |   1 +
 drivers/misc/eeprom/sunxi_sid.c  | 172 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 200 insertions(+)
 create mode 100644 drivers/misc/eeprom/sunxi_sid.c

-- 
1.8.1.5

