Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaKQWu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:50:29 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38909 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaKQWu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:50:27 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 0/4] spi: Add support for Amlogic Meson SPIFC
Date: Mon, 17 Nov 2014 23:47:47 +0100
Message-Id: <1416264471-774-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patchset adds a driver for the SPIFC (SPI flash controller)
available in Amlogic Meson6 and Meson8 SoCs. The driver has been
tested on a Meson8 based device to communicate with a Macronix
mx25l1606e serial flash.

The first patch adds a field to the spi_transfer structure that allows
the driver to know in transfer_one() whether the transfer is the last
one and change CS accordingly, without the need to reimplement
transfer_one_message().

Changes since v1 [ https://lkml.org/lkml/2014/11/9/35 ]:
 - decrease busy wait timeout
 - remove check on xfer->speed_hz value in meson_spifc_transfer_one()
 - implement transfer_one() instead of transfer_one_message()
 - remove useless memset of devdata
 - use fixed regmap config
 - implement PM operations
 - don't set master->bus_num
 - allow modular build of the driver

Beniamino Galvani (4):
  spi: Add 'last' flag to spi_transfer structure
  spi: meson: Add device tree bindings documentation for SPIFC
  spi: meson: Add support for Amlogic Meson SPIFC
  ARM: dts: meson: add node for SPIFC

 .../devicetree/bindings/spi/spi-meson.txt          |  22 +
 arch/arm/boot/dts/meson.dtsi                       |   9 +
 drivers/spi/Kconfig                                |   7 +
 drivers/spi/Makefile                               |   1 +
 drivers/spi/spi-meson-spifc.c                      | 461 +++++++++++++++++++++
 drivers/spi/spi.c                                  |   6 +
 include/linux/spi/spi.h                            |   2 +
 7 files changed, 508 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-meson.txt
 create mode 100644 drivers/spi/spi-meson-spifc.c

-- 
1.9.1

