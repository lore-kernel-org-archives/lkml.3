Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbbAZNAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:00:25 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:44019 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbbAZNAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:00:23 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: cleanup/soc for 3.20 #3 (bis)
Date: Mon, 26 Jan 2015 14:00:30 +0100
Message-ID: <1422277230-25211-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20150123230609.GV20896@quad.lixom.net>
References: <20150123230609.GV20896@quad.lixom.net>
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnd, Olof, Kevin,

This is the rework of my previous pull-request with modifications advised by
Olof.
This is a batch of cleanup/soc modifications that you may also stack on top of
your "soc" branch as the previous one. It stabilizes a little bit our cleanup
action before going further.
Another one may be proposed before the merge-window opens.

Thanks, best regards,

The following changes since commit 29ee506d0d56f6d39cc237de2512f9cb5629cbf7:

  ARM: at91: move at91rm9200_idle() to clk/at91/pmc.c (2015-01-16 18:08:42 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-cleanup3

for you to fetch changes up to 9726b6892beeaa736610370429a23a481d1b133e:

  ARM: at91: pm: remove warning to remove SOC_AT91SAM9263 usage (2015-01-26 13:44:19 +0100)

----------------------------------------------------------------
Third batch of cleanup/soc for 3.20:
- several fixes and adjustments following the last cleanup batch
- removal of some unused Kconfig options
- slight PM and pm_idle rework to ease future rework
- removal of unneeded mach/system_rev.h

----------------------------------------------------------------
Alexandre Belloni (6):
      ARM: at91: mark const init data with __initconst instead of __initdata
      ARM: at91: fix sam9n12 and sam9x5 arm_pm_idle
      ARM: at91: sam9: set arm_pm_idle from sam9_dt_device_init
      ARM: at91: stop using HAVE_AT91_DBGUx
      ARM: at91: remove unused mach/system_rev.h
      ARM: at91: pm: remove warning to remove SOC_AT91SAM9263 usage

Nicolas Ferre (3):
      ARM: at91: fix Kconfig.debug by adding DEBUG_AT91_UART option
      ARM: at91: fix PM initialization for newer SoCs
      ARM: at91: fix ordering of SRAM and PM initialization

 arch/arm/Kconfig.debug                       | 16 +++++++++-----
 arch/arm/mach-at91/Kconfig                   | 19 ----------------
 arch/arm/mach-at91/at91sam9260.c             |  6 -----
 arch/arm/mach-at91/at91sam9261.c             |  6 -----
 arch/arm/mach-at91/at91sam9263.c             |  6 -----
 arch/arm/mach-at91/at91sam9g45.c             |  5 -----
 arch/arm/mach-at91/at91sam9rl.c              |  6 -----
 arch/arm/mach-at91/board-dt-rm9200.c         |  6 ++---
 arch/arm/mach-at91/board-dt-sam9.c           | 33 +++++++++++++++++++++++++---
 arch/arm/mach-at91/board-dt-sama5.c          |  2 +-
 arch/arm/mach-at91/generic.h                 |  2 ++
 arch/arm/mach-at91/include/mach/system_rev.h | 27 -----------------------
 arch/arm/mach-at91/pm.c                      |  7 ++++++
 arch/arm/mach-at91/pm_slowclock.S            |  9 --------
 14 files changed, 54 insertions(+), 96 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/system_rev.h

-- 
Nicolas Ferre
