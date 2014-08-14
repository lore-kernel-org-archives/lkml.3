Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbaHNPqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:46:01 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:57026 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaHNPqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:46:00 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: move of AIC drivers for 3.17: fixes #1
Date: Thu, 14 Aug 2014 17:45:56 +0200
Message-ID: <1408031156-13573-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

Boris moved both of our AIC drivers to their new home: the drivers/irqchip
directory taking advantage of the genirc framework. For DT-enabled SoCs, we can
use these drivers (aic and aic5) right now: Jason merged them and they are
available in early 3.17 merge window.
So, I build this pull-request for enabling the use of these drivers now as:
- we are very early in 3.17 development
- it allowed us to avoid having to depend on Jason's branch before the opening
  of the merge window
- it removes some code from the mach-at91 directory: including the whole
  aic5 driver
- we'd have quite a bit of time to solve issues if we found a bug
- the code is basically moved so it should be error free.

I base my pull-request on Linus' tree at the point you built your previous
"3.17 fixes-for-linus" tag.
Tell me if you think it can be integrated now.

Thanks, best regards,

The following changes since commit c309bfa9b481e7dbd3e1ab819271bf3009f44859:

  Merge tag 'for-linus-20140808' of git://git.infradead.org/linux-mtd (2014-08-08 18:13:21 -0700)

are available in the git repository at:


  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 98561f0d9e82682c4be74b6690cb605ccabec364:

  ARM: at91: remove old irq material (2014-08-14 17:00:04 +0200)

----------------------------------------------------------------
AT91 irqchip enhancement for 3.17 (aka fixes #1)
Following the merge of AIC/AIC5 code as standard irqchip drivers during early
3.17 merge window, we can use these drivers for AT91 DT-enabled chips and
boards.

----------------------------------------------------------------
Boris BREZILLON (4):
      ARM: at91: introduce OLD_IRQ_AT91 Kconfig option
      ARM: at91: enclose at91_aic_xx calls in IS_ENABLED(CONFIG_OLD_IRQ_AT91) blocks
      ARM: at91: make use of the new AIC driver for dt enabled boards
      ARM: at91: remove old irq material

 arch/arm/mach-at91/Kconfig           |  17 +--
 arch/arm/mach-at91/Kconfig.non_dt    |   6 +
 arch/arm/mach-at91/Makefile          |   3 +-
 arch/arm/mach-at91/board-dt-rm9200.c |  13 --
 arch/arm/mach-at91/board-dt-sam9.c   |  13 --
 arch/arm/mach-at91/board-dt-sama5.c  |  13 --
 arch/arm/mach-at91/irq.c             | 270 +----------------------------------
 arch/arm/mach-at91/pm.c              |  32 +++--
 arch/arm/mach-at91/setup.c           |   3 +-
 9 files changed, 45 insertions(+), 325 deletions(-)

-- 
Nicolas Ferre
