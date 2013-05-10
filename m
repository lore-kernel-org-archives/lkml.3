Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3EJALU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 20:11:20 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52901 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab3EJALT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 20:11:19 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [PATCH 0/3] ARM: KDB FIQ debugger
Date: Thu,  9 May 2013 17:10:48 -0700
Message-Id: <1368144651-11250-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all,
	Just wanted to try to revive Anton's KDB FIQ patches
which have been sent out a number of times since last October
and have gotten almost no response at all.

I've simply updated them to apply to Linus' current HEAD,
and figured I'd send them out again to try to spur some
interest.

Any feedback would be appreciated!

thanks
-john

Short description of the KDB/FIQ debugger:

 The FIQ debugger is a facility that can be used to debug situations when
 the kernel stuck in uninterruptable sections, e.g. the kernel infinitely
 loops or deadlocked in an interrupt or with interrupts disabled. On some
 development boards there is even a special NMI button, which is very
 useful for debugging weird kernel hangs.

 And FIQ is basically an NMI, it has a higher priority than IRQs, and upon
 IRQ exception FIQs are not disabled. It is still possible to disable FIQs
 (as well as some "NMIs" on other architectures), but via special means.

Old changelogs and a full rationale for these patches can be found here:

	v1-v5, rationale: http://lkml.org/lkml/2012/9/10/2
	v6: http://lkml.org/lkml/2012/9/10/2
	v7: http://lkml.org/lkml/2012/9/13/367
	v8: http://lkml.org/lkml/2012/9/19/525
	v9: http://lkml.org/lkml/2012/9/24/538


Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kernel-team@android.com


Anton Vorontsov (3):
  ARM: Move some macros from entry-armv to entry-header
  ARM: Add KGDB/KDB FIQ debugger generic code
  ARM: versatile: Make able to use UART ports for KGDB FIQ debugger

 arch/arm/Kconfig                   |  19 +++++
 arch/arm/include/asm/kgdb.h        |   7 ++
 arch/arm/kernel/Makefile           |   1 +
 arch/arm/kernel/entry-armv.S       | 169 +-----------------------------------
 arch/arm/kernel/entry-header.S     | 171 +++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/kgdb_fiq.c         | 118 +++++++++++++++++++++++++
 arch/arm/kernel/kgdb_fiq_entry.S   |  87 +++++++++++++++++++
 arch/arm/mach-versatile/Makefile   |   1 +
 arch/arm/mach-versatile/kgdb_fiq.c |  55 ++++++++++++
 9 files changed, 460 insertions(+), 168 deletions(-)
 create mode 100644 arch/arm/kernel/kgdb_fiq.c
 create mode 100644 arch/arm/kernel/kgdb_fiq_entry.S
 create mode 100644 arch/arm/mach-versatile/kgdb_fiq.c

-- 
1.8.1.2

