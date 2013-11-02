Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab3KBPj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 11:39:58 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60621 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3KBPjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 11:39:53 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Alex Elder <alex.elder@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-gpio@vger.kernel.org, Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v4 0/6] gpio: daVinci: Fixes and feature enhancement
Date: Sat,  2 Nov 2013 21:09:29 +0530
Message-Id: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Patches 1, 2 and 3 are newly added. This patch series does the following
a> Fixes check for offset for unbanked gpios.
b> Ports the driver to use irqdomain.
c> Adds dt binding support for gpio-davinci.
d> Adds DA850 dt support goio.

Changes for v4:
1: Added irqdomain support for the driver.
2: Dropped the ACK's.
3: Removed unnecessary DT property.

This patch series has been tested on DA850 for GPIO7_4
(ie switch 8 on SW7.). Patches can be found at [1].

[1] http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git/shortlog/refs/heads/davinci_gpio

KV Sujith (3):
  gpio: davinci: add OF support
  ARM: davinci: da850: add GPIO DT node
  ARM: davinci: da850 evm: add GPIO pinumux entries DT node

Lad, Prabhakar (3):
  gpio: davinci: Fixed a check for unbanked gpio
  gpio: davinci: remove unnecessary printk
  gpio: davinci: use irqdomain

 .../devicetree/bindings/gpio/gpio-davinci.txt      |   32 ++++++
 arch/arm/boot/dts/da850-evm.dts                    |   20 ++++
 arch/arm/boot/dts/da850.dtsi                       |   15 +++
 arch/arm/mach-davinci/da830.c                      |    1 -
 arch/arm/mach-davinci/da850.c                      |    1 -
 arch/arm/mach-davinci/dm355.c                      |    1 -
 arch/arm/mach-davinci/dm365.c                      |    1 -
 arch/arm/mach-davinci/dm644x.c                     |    1 -
 arch/arm/mach-davinci/dm646x.c                     |    1 -
 drivers/gpio/gpio-davinci.c                        |  111 +++++++++++++++-----
 include/linux/platform_data/gpio-davinci.h         |    3 +-
 11 files changed, 153 insertions(+), 34 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-davinci.txt

-- 
1.7.9.5

