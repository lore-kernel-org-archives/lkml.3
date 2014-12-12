Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786AbaLLJq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:46:58 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:54484 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934631AbaLLJq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:46:56 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <arm@kernel.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: fixes for 3.19 #1
Date: Fri, 12 Dec 2014 10:46:55 +0100
Message-ID: <1418377615-15122-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof, Kevin,

I'm sending today a "fixes" branch which somehow continues the cleanup with
only code removal. I was waiting for the arm-soc *and* pinctrl material to
reach Linus T.'s tree before sending this pull-request. In fact this sequence
was needed for the gpio header removal. The little patch about #include
deletion just follows an earlier merge conflict in arm-soc tree: I was also
waiting for this moment before sending the definitive fix, just to be sure.

Otherwise, all is pretty straightforward.

Oh, one more thing: it is based on the current Linus' git tree, I can obviously
rebase everything on top of 3.19-rc1 once it is released if you prefer.

Thanks, best regards,

The following changes since commit 2756d373a3f45a3a9ebf4ac389f9e0e02bd35a93:

  Merge branch 'for-3.19' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup (2014-12-11 18:57:19 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-fixes

for you to fetch changes up to 23db86fb6b514788f57b4ee96962352281139a63:

  ARM: at91/config: sama5: Remove DEBUG_LL (2014-12-12 10:14:56 +0100)

----------------------------------------------------------------
First fixes batch for AT91 on 3.19 folowing The big cleanup:
- removal of unused Kconfig RTC options
- GPIO header file is now close to the pinctrl driver
- little fix on #includes
- removal of DEBUG_LL from the sama5 common defconfig

----------------------------------------------------------------
Boris Brezillon (1):
      ARM: at91: remove useless header file includes

Maxime Ripard (1):
      ARM: at91/config: sama5: Remove DEBUG_LL

Nicolas Ferre (2):
      rtc: at91/Kconfig: remove useless options
      ARM: at91: remove unneeded header file

 arch/arm/configs/sama5_defconfig           |  2 -
 arch/arm/mach-at91/at91sam9g45.c           |  1 -
 arch/arm/mach-at91/at91sam9rl.c            |  1 -
 arch/arm/mach-at91/include/mach/at91_pio.h | 80 ------------------------------
 drivers/rtc/Kconfig                        | 28 -----------
 5 files changed, 112 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_pio.h

-- 
Nicolas Ferre
