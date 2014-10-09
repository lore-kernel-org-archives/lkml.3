Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaJITbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:31:11 -0400
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:45255
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751462AbaJIT3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:29:55 -0400
From: John Crispin <blogic@openwrt.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH 0/4] pinctrl: ralink: add support for rt2880 pinmux
Date: Thu,  9 Oct 2014 04:55:23 +0200
Message-Id: <1412823327-10296-1-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds a pinctrl driver for ralink SoC. as it touches both arch and
pinctrl files i would prefer to have this go via the mips tree with the other
ralink pathes that i have sent.

John Crispin (4):
  MIPS: ralink: cleanup the soc specific pinmux data
  pinctrl: ralink: add a pinctrl driver for the rt2880 family of SoCs
  pinctrl: ralink: add binding documentation
  MIPS: ralink: always enable pinctrl on ralink SoC

 .../bindings/pinctrl/ralink,rt2880-pinmux.txt      |   74 +++
 arch/mips/Kconfig                                  |    2 +
 arch/mips/include/asm/mach-ralink/mt7620.h         |   41 +-
 arch/mips/include/asm/mach-ralink/pinmux.h         |   55 +++
 arch/mips/include/asm/mach-ralink/rt305x.h         |   35 +-
 arch/mips/include/asm/mach-ralink/rt3883.h         |   16 +-
 arch/mips/ralink/common.h                          |   19 -
 arch/mips/ralink/mt7620.c                          |  159 +++----
 arch/mips/ralink/rt288x.c                          |   62 +--
 arch/mips/ralink/rt305x.c                          |  153 +++----
 arch/mips/ralink/rt3883.c                          |  173 ++-----
 drivers/pinctrl/Kconfig                            |    5 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-rt2880.c                   |  474 ++++++++++++++++++++
 14 files changed, 849 insertions(+), 420 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/ralink,rt2880-pinmux.txt
 create mode 100644 arch/mips/include/asm/mach-ralink/pinmux.h
 create mode 100644 drivers/pinctrl/pinctrl-rt2880.c

-- 
1.7.10.4

