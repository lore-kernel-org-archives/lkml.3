Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762097AbbA1WZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:25:47 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:64354 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbbA1ULh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:11:37 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <sergei.shtylyov@cogentembedded.com>,
        <linux@maxim.org.za>, <wenyou.yang@atmel.com>
Subject: [PATCH v4 00/13 RESEND] AT91 pm cleanup for 3.20
Date: Wed, 28 Jan 2015 17:14:47 +0800
Message-ID: <1422436487-21890-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422409172-24178-1-git-send-email-wenyou.yang@atmel.com>
References: <1422409172-24178-1-git-send-email-wenyou.yang@atmel.com>
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

Changes in v4:
 - Clear unused state argument in at91_pm_verify_clocks()
 - Remove pr_info("AT91:... slow_clock ? ..") in patch 07/13.

Changes in v3
 - Sylvain splits the patch in two
 - Add handling if no sram allocated for PM
 - Retain the STANDBY and SUSPEND_MEM select in at91_pm_enter.

Changes in v2:
 - Rebase on the at91-3.20-cleanup branch
 - Recover the verify clock condition, only for suspend to memory.
 - Collect ACK from Alexandre
 - Add the macro for PM mode

Peter Rosin (1):
  pm: at91: Workaround DDRSDRC self-refresh bug with LPDDR1 memories.

Sylvain Rochet (2):
  pm: at91: pm_slowclock: fix suspend/resume hang up in timeouts
  pm: at91: pm_slowclock: remove clocks which are already stopped when
    entering slow clock mode

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
 arch/arm/mach-at91/pm.c            |  148 +++++++++--------
 arch/arm/mach-at91/pm.h            |  100 +----------
 arch/arm/mach-at91/pm_slowclock.S  |  323 ------------------------------------
 arch/arm/mach-at91/pm_suspend.S    |  277 +++++++++++++++++++++++++++++++
 arch/arm/mach-at91/setup.c         |   19 +--
 include/soc/at91/at91sam9_ddrsdr.h |    2 +-
 8 files changed, 366 insertions(+), 522 deletions(-)
 delete mode 100644 arch/arm/mach-at91/pm_slowclock.S
 create mode 100644 arch/arm/mach-at91/pm_suspend.S

-- 
1.7.9.5

