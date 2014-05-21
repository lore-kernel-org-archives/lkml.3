Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaEUO25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:28:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54754 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaEUO2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:28:55 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <santosh.shilimkar@ti.com>,
        <arnd@arndb.de>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch v4 0/5] Introduce keystone reset driver
Date: Wed, 21 May 2014 17:27:29 +0300
Message-ID: <1400682454-24535-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches introduce keystone reset driver.

The keystone SoC can be rebooted in several ways. By external reset
pin, by soft and by watchdogs. This driver allows software reset and reset
by one of the watchdogs. Also added opportunity to set soft/hard reset type.

Based on linux-next/master

v4..v3
  Power: reset: keystone-reset: introduce keystone reset driver
  	- change to use syscon framework
  	- change to use regmap to access registers
  Power: reset: add bindings for keystone reset driver
  	- deleted properties "reg", "reg-names"
	- added properties "ti,syscon-pll", "ti,syscon-dev"
  ARM: dts: keystone: update reset node to work with reset driver
  	- deleted properties "reg", "reg-names"
	- added properties "ti,syscon-pll", "ti,syscon-dev"

v2..v3
  Power: reset: keystone-reset: introduce keystone reset driver
	- no functional changes, only sanity
  Power: reset: add bindings for keystone reset driver
  	- corrected WDT numeration in examples
	- extended description of wdt_list property

v1..v2
	- re basedon on v3.15-rc1 without changes

Ivan Khoronzhuk (5):
  Power: reset: keystone-reset: introduce keystone reset driver
  Power: reset: add bindings for keystone reset driver
  ARM: keystone: remove redundant reset stuff
  ARM: dts: keystone: update reset node to work with reset driver
  ARM: keystone: enable reset driver support

 .../bindings/power/reset/keystone-reset.txt        |  66 +++++++++
 arch/arm/boot/dts/keystone.dtsi                    |   4 +-
 arch/arm/configs/keystone_defconfig                |   3 +
 arch/arm/mach-keystone/keystone.c                  |  34 -----
 drivers/power/reset/Kconfig                        |   8 ++
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/keystone-reset.c               | 153 +++++++++++++++++++++
 7 files changed, 234 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/reset/keystone-reset.txt
 create mode 100644 drivers/power/reset/keystone-reset.c

-- 
1.8.3.2

