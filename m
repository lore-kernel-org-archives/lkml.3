Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbbATJra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:47:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55101 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbbATJr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:47:28 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: MediaTek PMIC support
Date: Tue, 20 Jan 2015 10:47:03 +0100
Message-Id: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.1.4
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds initial support for the MediaTek MT6397 PMIC and the
necessary infrastructure to attach it on the MT8135 / MT8173 SoCs.

The infrastructure includes:

- pericfg / infracfg controller support
  The pericfg / infracfg controllers contain miscellaneous registers for
  reset controllers and clocks.

- PMIC wrapper support
  On MediaTek MT8135, MT8173 and other SoCs the PMIC is connected via
  SPI. The SPI master interface is not directly visible to the CPU, but
  only through the PMIC wrapper inside the SoC. The communication between
  the SoC and the PMIC can optionally be encrypted. Also a non standard
  Dual IO SPI mode can be used to increase speed. The MT8135 also supports
  a special feature named "IP Pairing". With IP Pairing the pins of some
  SoC internal peripherals can be on the PMIC. The signals of these pins
  are routed over the SPI bus using the pwrap bridge. Because of these
  optional non SPI conform features the PMIC driver is not implemented as
  a SPI bus master driver.

The MT6397 PMIC itself is implemented as a regular mfd device driver which
uses regmap to access the PMIC registers.

This series also adds regulator support for the MT6397 PMIC.

The first 6 patches can be merged through the ARM SoC tree. The mfd/regulator
patches are independent of the first 6 patches and can be merged through the
mfd/regulator maintainer trees.

Sascha

