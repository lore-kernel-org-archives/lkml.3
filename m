Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3FZNpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:45:13 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:19070 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3FZNpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:45:10 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: <daniel.lezcano@linaro.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: non critical fixes (for early 3.11) #2
Date: Wed, 26 Jun 2013 15:45:07 +0200
Message-ID: <1372254307-2063-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Another fixes-non-critical pull-request for early 3.11. It is of course based
on the patches that you already have in arm-soc/at91/fixes.

Thanks, best regards,

The following changes since commit 133e00116b5bc76110bcc41ded369489209b641f:

  ARM: at91: Change the internal SRAM memory type MT_MEMORY_NONCACHED (2013-06-18 10:20:30 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to bd2da9ca138e446824a7542b381aed442fef4caa:

  ARM: at91/PMC: use at91_usb_rate() for UTMI PLL (2013-06-26 15:24:11 +0200)

----------------------------------------------------------------
Several fixes for:
- external irq on non-DT boards
- cpuidle code in some circumstances
- PMC code in relation with PLLB/PLL_UTMI/USB:
  mainly for SAMA5D3 and AT91SAM9N12

----------------------------------------------------------------
Daniel Lezcano (1):
      ARM: at91: cpuidle: Fix target_residency

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: fix at91_extern_irq usage for non-dt boards

Nicolas Ferre (4):
      ARM: at91/PMC: sama5d3 family doesn't have a PLLB
      ARM: at91/PMC: at91sam9n12 family has a PLLB
      ARM: at91/PMC: fix at91sam9n12 USB FS init
      ARM: at91/PMC: use at91_usb_rate() for UTMI PLL

 arch/arm/mach-at91/at91rm9200.c            |  8 ++++----
 arch/arm/mach-at91/at91sam9260.c           |  4 ++--
 arch/arm/mach-at91/at91sam9261.c           |  4 ++--
 arch/arm/mach-at91/at91sam9263.c           |  2 +-
 arch/arm/mach-at91/at91sam9g45.c           |  2 +-
 arch/arm/mach-at91/at91sam9rl.c            |  2 +-
 arch/arm/mach-at91/at91x40.c               |  7 +++----
 arch/arm/mach-at91/clock.c                 | 30 +++++++++++++++++++++++-------
 arch/arm/mach-at91/cpuidle.c               |  2 +-
 arch/arm/mach-at91/generic.h               |  2 +-
 arch/arm/mach-at91/include/mach/at91_pmc.h |  3 +++
 arch/arm/mach-at91/irq.c                   |  9 ++++++++-
 arch/arm/mach-at91/pm.c                    |  2 +-
 arch/arm/mach-at91/setup.c                 |  2 +-
 arch/arm/mach-at91/soc.h                   |  1 +
 15 files changed, 53 insertions(+), 27 deletions(-)

-- 
Nicolas Ferre
