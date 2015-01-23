Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbbAWOKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:10:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52280 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbbAWOKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:10:15 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?Yingjoe=20Chen=20=28=E9=99=B3=E8=8B=B1=E6=B4=B2=29?= 
	<Yingjoe.Chen@mediatek.com>,
        Henry Chen <henryc.chen@mediatek.com>,
        =?UTF-8?q?YH=20Chen=20=28=E9=99=B3=E6=98=B1=E8=B1=AA=29?= 
	<yh.chen@mediatek.com>
Subject: [PATCH v2] MediaTek PMIC support
Date: Fri, 23 Jan 2015 15:09:55 +0100
Message-Id: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
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

The first 6 patches can be merged through the ARM SoC tree. The mfd
patch is independent of the first 6 patches and can be merged through the
mfd maintainer trees.

Changes since v1:

- document reset bindings for infracfg/pericfg
- fix base addresses in infracfg binding example
- Remove more Email addresses from Flora Fu (She is not working at
  MediaTek anymore, her address is no longer valid)
- drop Regulator support patch, it's already in next

Sascha

