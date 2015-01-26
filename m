Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbbAZJiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:38:25 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:45850 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbAZJiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:38:23 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>
Subject: [PATCH v2 00/12] AT91 pm cleanup for 3.20
Date: Mon, 26 Jan 2015 17:36:45 +0800
Message-ID: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

This version is rebased on the branch: at91-3.20-cleanup of the repository
	git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git

It is purpose to clean up the PM code, includes the patches from Peter Rosin and Sylvain Rochet.

Since verifying the USB clock and USB PLL disabling before suspending to memory,
it aslo depends on the following patch serials from Sylvain:
	[PATCHv6 0/5] USB: gadget: atmel_usba_udc: Driver improvements
	[PATCHv7 0/6] USB: host: Atmel OHCI and EHCI drivers improvements

Removes CONFIG_AT91_SLOW_CLOCK config item to simply the PM config,
The suspend to standby mode uses the same sram function as the suspend to memory mode.
Remove some unused code.

Alexandr & Sylvain, Thank you very much for so many feedbacks.

Changes in v2:
 - Rebase on the at91-3.20-cleanup branch
 - Recover the verify clock condition, only for suspend to memory.
 - Collect ACK from Alexandre
 - Add the macro for PM mode

Peter Rosin (1):
  pm: at91: Workaround DDRSDRC self-refresh bug with LPDDR1 memories.

Sylvain Rochet (1):
  pm: at91: pm_slowclock: improve reliability of suspend/resume

Wenyou Yang (10):
  pm: at91: pm_slowclock: remove the unused code related with
    SLOWDOWN_MASTER_CLOCK
  pm: at91: move the copying the sram function to the sram
    initializationi phase
  ARM: at91: move select SRAM to ARCH_AT91
  pm: at91: remove the config item CONFIG_AT91_SLOW_CLOCK
  pm: at91: the standby mode uses the same sram function as the suspend
    to memory mode
  pm: at91: rename file name: pm_slowclock.S -->pm_suspend.S
  pm: at91: rename function name:
    at91_slow_clock()-->at91_pm_suspend_sram_fn
  pm: at91: remove the at91_xxx_standby() function definitions in the
    pm.h
  pm: at91: setup: remove the struct ramc_ids .data at91_xxx_standby
    members
  pm: at91: amend the pm_suspend entry for at91_cpuidle_device
arch/arm/mach-at91/Kconfig         |   17 +-
 arch/arm/mach-at91/Makefile        |    2 +-
 arch/arm/mach-at91/pm.c            |  143 ++++++++--------
 arch/arm/mach-at91/pm.h            |  100 +----------
 arch/arm/mach-at91/pm_slowclock.S  |  323 ------------------------------------
 arch/arm/mach-at91/pm_suspend.S    |  277 +++++++++++++++++++++++++++++++
 arch/arm/mach-at91/setup.c         |   19 +--
 include/soc/at91/at91sam9_ddrsdr.h |    2 +-
 8 files changed, 362 insertions(+), 521 deletions(-)
 delete mode 100644 arch/arm/mach-at91/pm_slowclock.S
 create mode 100644 arch/arm/mach-at91/pm_suspend.S

-- 
1.7.9.5

