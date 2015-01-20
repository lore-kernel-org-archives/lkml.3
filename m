Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbbATIR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:17:29 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:31857 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750722AbbATIR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:17:28 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>
Subject: [PATCH 00/12] AT91 pm cleanup for 3.20
Date: Tue, 20 Jan 2015 16:16:53 +0800
Message-ID: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

This patch set is based on Alexandre's patch set of AT91 cleanup for 3.20 #2.
It also includes the patches from Peter Rosin and Sylvain Rochet.

Removes CONFIG_AT91_SLOW_CLOCK config item to simply the PM config,
The suspend to standby mode uses the same sram function as the suspend to memory mode.
Remove some unused code.

Thank Alexandre for many advices.

Best Regards,
Wenyou Yang

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
  pm: at91: remove the struct ramc_ids .data at91_xxx_standby members
  pm: at91: amend the pm_suspend entry for at91_cpuidle_device

 arch/arm/mach-at91/Kconfig         |   15 +-
 arch/arm/mach-at91/Makefile        |    2 +-
 arch/arm/mach-at91/pm.c            |  156 ++++++++---------
 arch/arm/mach-at91/pm.h            |  112 +------------
 arch/arm/mach-at91/pm_slowclock.S  |  322 ------------------------------------
 arch/arm/mach-at91/pm_suspend.S    |  278 +++++++++++++++++++++++++++++++
 include/soc/at91/at91sam9_ddrsdr.h |    2 +-
 7 files changed, 356 insertions(+), 531 deletions(-)
 delete mode 100644 arch/arm/mach-at91/pm_slowclock.S
 create mode 100644 arch/arm/mach-at91/pm_suspend.S

-- 
1.7.9.5

