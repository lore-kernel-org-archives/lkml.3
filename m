Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab3KOLYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:24:35 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:8466 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab3KOLY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:24:27 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [GIT PULL] at91: non-critical fixes for 3.13 #1
Date: Fri, 15 Nov 2013 12:24:25 +0100
Message-ID: <1384514665-32174-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

This is a pull-request for AT91 about non-critical fixes for 3.13. This means
that you can certainly plan it for early 3.14.
It is not a 3.13 regression as this issue has been present for ages. I have
tagged the patch for "-stable" down to 3.11.y as they need modification to
apply on older kernels.

Thanks, best regards,

The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:

  Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes-non-critical

for you to fetch changes up to 94c4c79f2f1acca6e69a50bff5a7d9027509c16b:

  ARM: at91: fix hanged boot due to early rtt-interrupt (2013-11-15 12:13:33 +0100)

----------------------------------------------------------------
Fixes for RTT & RTC interrupts that can fire early
during boot process and kill the system.
This fix has been discussed for months and it is time
for it to reach mainline.

----------------------------------------------------------------
Johan Hovold (2):
      ARM: at91: fix hanged boot due to early rtc-interrupt
      ARM: at91: fix hanged boot due to early rtt-interrupt

 arch/arm/mach-at91/Makefile                   |  2 +-
 arch/arm/mach-at91/at91sam9260.c              |  2 +
 arch/arm/mach-at91/at91sam9261.c              |  2 +
 arch/arm/mach-at91/at91sam9263.c              |  3 ++
 arch/arm/mach-at91/at91sam9g45.c              |  3 ++
 arch/arm/mach-at91/at91sam9n12.c              |  6 +++
 arch/arm/mach-at91/at91sam9rl.c               |  3 ++
 arch/arm/mach-at91/at91sam9x5.c               |  6 +++
 arch/arm/mach-at91/generic.h                  |  2 +
 arch/arm/mach-at91/include/mach/at91sam9n12.h |  5 ++
 arch/arm/mach-at91/include/mach/at91sam9x5.h  |  5 ++
 arch/arm/mach-at91/include/mach/sama5d3.h     |  5 ++
 arch/arm/mach-at91/sama5d3.c                  |  6 +++
 arch/arm/mach-at91/sysirq_mask.c              | 71 +++++++++++++++++++++++++++
 14 files changed, 120 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-at91/sysirq_mask.c

-- 
Nicolas Ferre
