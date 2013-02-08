Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197Ab3BHQfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:35:22 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:35689 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098Ab3BHQfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:35:20 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <FlorianSchandinat@gmx.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <jhovold@gmail.com>,
        <jacmet@sunsite.dk>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/5] at91: atmel_lcdfb: regression fixes and cpu_is removal
Date: Fri, 8 Feb 2013 17:35:13 +0100
Message-ID: <cover.1360340791.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix a regression in 16-bpp support for older SOCs which use
IBGR:555 rather than BGR:565 pixel layout. Use SOC-type to determine if the
controller uses the intensity-bit and restore the old layout in that case.

The last patch is a removal of uses of cpu_is_xxxx() macros in atmel_lcdfb with
a platform-device-id table and static configurations.


Patches from Johan Hovold taken from:
"[PATCH 0/3] atmel_lcdfb: fix 16-bpp regression"
and
"[PATCH v2 0/3] ARM: at91/avr32/atmel_lcdfb: remove cpu_is macros"
patch series to form a clean patch series with my signature.

Arnd, Olof,
as it seems that old fbdev drivers are not so much reviewed those days, can we
take the decision to queue this material through arm-soc with other AT91
drivers updates?

Best regards,

Johan Hovold (5):
  atmel_lcdfb: fix 16-bpp modes on older SOCs
  ARM: at91/neocore926: fix LCD-wiring mode
  ARM: at91/avr32/atmel_lcdfb: add bus-clock entry
  atmel_lcdfb: move lcdcon2 register access to compute_hozval
  ARM: at91/avr32/atmel_lcdfb: add platform device-id table

 arch/arm/mach-at91/at91sam9261.c         |   2 +
 arch/arm/mach-at91/at91sam9261_devices.c |   6 +-
 arch/arm/mach-at91/at91sam9263.c         |   1 +
 arch/arm/mach-at91/at91sam9263_devices.c |   2 +-
 arch/arm/mach-at91/at91sam9g45.c         |   2 +
 arch/arm/mach-at91/at91sam9g45_devices.c |   6 +-
 arch/arm/mach-at91/at91sam9rl.c          |   1 +
 arch/arm/mach-at91/at91sam9rl_devices.c  |   2 +-
 arch/arm/mach-at91/board-neocore926.c    |   2 +-
 arch/avr32/mach-at32ap/at32ap700x.c      |   6 +-
 drivers/video/atmel_lcdfb.c              | 130 ++++++++++++++++++++++++-------
 include/video/atmel_lcdc.h               |   4 +-
 12 files changed, 127 insertions(+), 37 deletions(-)

-- 
1.8.0

