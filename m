Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3IIQEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:04:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab3IIQD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:03:59 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 0/4] ARM: shmobile: CPUFreq support on Lager
Date: Mon,  9 Sep 2013 18:03:52 +0200
Message-Id: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:nm/E4pP5CQMxdGOa4zO3q7GgMh5WRD8BhAW5u2y28uy
 UE3JhqlmyZGUzVGqqiYhm6PotL7vc5D81a11MMz68OZqXhJm04
 xrVb+EhiyH9ZWH4oHG59d5bBMIX4JpXzkTm7F5nmRUZCyaVJ9K
 FkG1WkaVdkkcRLhvSQrPM8nYkvyif7tA/pEtIYc8pwaWa3hLMD
 ksVwnSJIB3zb5ZAjV8C2gKwO9SNLJrfOfYgeceMj6aQ5wc0s15
 0Zql42vHccEAu7MAcPqT6P1KjOVorMiW1n+bqjkdDQkL3nMesL
 LyAseL1llk6kNcIv2j1MecCZxKK/WoBS+nV18crIHJlycfgv76
 ESV2Grav3ozuASqdse6qNF5vpXfV6C0lBeAh73mq5KdIaCgz5x
 X32Ysi7vPYxpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Lager a da9210 regulator is used to supply DVFS power to the SoC. This
patch series adds I2C and Z-clock support on r8a7790 and CPUFreq support
for the Lager board. Please note, that patch 4/4 is an RFC as explained
inline.

Developed on top of -next of 09.09.2013 with my recent shmobile patches,
including "ARM: shmobile: lager: disable MMCIF Command Completion Signal,
add CLK_CTRL2" and my two earlier patch series from today:

[PATCH 0/2] regulator: da9210: support Device Tree initialisation
[PATCH 0/5] i2c: rcar: Device Tree support and clock improvements

If these patches are used without da9210 DT support, the driver won't
initialise correctly, otherwise applying these patches without the above
dependencies will compile and shouldn't do any harm.

Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Guennadi Liakhovetski (4):
  pinctrl: sh-pfc: r8a7790: add pin definitions for the I2C3 interface
  ARM: shmobile: r8a7790: add I2C support in Device Tree mode
  ARM: shmobile: r8a7790: add CPUFreq clock support
  ARM: shmobile: lager: add CPUFreq support

 arch/arm/boot/dts/r8a7790-lager-reference.dts  |   32 +++++
 arch/arm/boot/dts/r8a7790.dtsi                 |   36 ++++++
 arch/arm/mach-shmobile/Kconfig                 |    2 +
 arch/arm/mach-shmobile/board-lager-reference.c |    4 +-
 arch/arm/mach-shmobile/clock-r8a7790.c         |  160 ++++++++++++++++++++++++
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c           |   28 ++++
 6 files changed, 261 insertions(+), 1 deletions(-)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
