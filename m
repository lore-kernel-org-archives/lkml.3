Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3EQNoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:44:06 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:40092 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461Ab3EQNoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:44:04 -0400
From: Oliver Schinagl <oliver+list@schinagl.nl>
To: maxime.ripard@free-electrons.com, arnd@ardb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Oliver Schinagl <oliver+list@schinagl.nl>
Subject: [PATCH 0/2] Driver for Allwinner sunxi Security ID
Date: Fri, 17 May 2013 15:35:42 +0200
Message-Id: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A-series of SoC's have efuses exposed via registers to read the
factory programmed e-fuses. These should in theory be programmable but this is
still to be confirmed. It does appear that these fuses are unique enough to be
used as serial numbers, RSA keys, generate MAC addresses from etc. If it turns
out to be user programmable, the use obviously increases. Allwinner did use the
fuses initially to determine the chip-type.

This driver supports all currently known chips based on datasheets and 'dumped'
drivers that we have so far, the dts is only implemented for known chips.

This is my very first driver so please try to be gentle ;)

Oliver Schinagl (2):
  Initial support for Allwinner's Security ID fuses
  Add sunxi-sid to dts for sun4i and sun5i

 arch/arm/boot/dts/sun4i-a10.dtsi |   5 +
 arch/arm/boot/dts/sun5i-a13.dtsi |   5 +
 drivers/misc/eeprom/Kconfig      |  19 ++++
 drivers/misc/eeprom/Makefile     |   1 +
 drivers/misc/eeprom/sunxi_sid.c  | 218 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 248 insertions(+)
 create mode 100644 drivers/misc/eeprom/sunxi_sid.c

-- 
1.8.1.5

