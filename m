Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161022AbaKNOnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:43:33 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:57880 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965179AbaKNOnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:43:31 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        Johan Hovold <johan@kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: drivers for 3.19 #1
Date: Fri, 14 Nov 2014 15:43:30 +0100
Message-ID: <1415976210-3665-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is a pull-request about AT91-related drivers that are easier to take via
arm-soc.

There is a little merge conflict with the "cleanup" branch because of removal
of at91sam9g45 and at91sam9rl legacy code. The resolution is pretty simple but
you can have a look at the resolution example here:
https://git.kernel.org/cgit/linux/kernel/git/nferre/linux-at91.git/log/?h=at91-next

Thanks, best regards,

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-drivers

for you to fetch changes up to 2c91e61dc97cce57ffd9dd654a6ee284e1f45a1f:

  rtc: at91sam9: add DT bindings documentation (2014-11-13 16:08:48 +0100)

----------------------------------------------------------------
First batch of drivers for 3.19:
It is only about a not so recent driver for old platforms: RTT as RTC driver:
- RTT as RTC driver enhancements and machine specific include files removal
- RTT as RTC driver conversion to device tree

----------------------------------------------------------------
Boris BREZILLON (9):
      rtc: at91sam9: remove references to mach specific headers
      rtc: at91sam9: use standard readl/writel functions instead of raw versions
      rtc: at91sam9: replace devm_ioremap by devm_ioremap_resource
      rtc: at91sam9: add DT support
      rtc: at91sam9: make use of syscon/regmap to access GPBR registers
      rtc: at91sam9: rework the Kconfig description
      ARM: at91: add clk_lookup entry for RTT devices
      rtc: at91sam9: use clk API instead of relying on AT91_SLOW_CLOCK
      rtc: at91sam9: add DT bindings documentation

 .../devicetree/bindings/rtc/atmel,at91sam9-rtc.txt |  23 ++++
 arch/arm/mach-at91/at91sam9260.c                   |   2 +
 arch/arm/mach-at91/at91sam9261.c                   |   2 +
 arch/arm/mach-at91/at91sam9263.c                   |   4 +
 arch/arm/mach-at91/at91sam9g45.c                   |   2 +
 arch/arm/mach-at91/at91sam9rl.c                    |   2 +
 arch/arm/mach-at91/clock.c                         |   2 +-
 arch/arm/mach-at91/clock.h                         |   1 +
 drivers/rtc/Kconfig                                |  24 ++--
 drivers/rtc/rtc-at91sam9.c                         | 138 ++++++++++++++++-----
 10 files changed, 162 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt

-- 
Nicolas Ferre
