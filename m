Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaBSBwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:52:16 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43925 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaBSBwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:52:13 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH RFC v1 0/3] hibernation support on ARM
Date: Tue, 18 Feb 2014 17:52:06 -0800
Message-Id: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches adding support for hibernation on ARM
  - ARM hibernation / suspend-to-disk
  - Fix hang in freeze_processes during hibernation
  - add an irq disabled version of soft_restart

Patches based on v3.13 tag, verified hibernation on beaglebone black on a branch
based on 3.13 merged with initial omap support from Russ Dill which be found here:
http://git.linaro.org/git-ro/people/sebastian.capella/linux.git hibernation_3.13_russMerge

[PATCH RFC v1 1/3] ARM: Add irq disabled version of soft_restart.
 arch/arm/include/asm/system_misc.h |    1 +
 arch/arm/kernel/process.c          |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

 Adds the ability to run soft restart with local_irq/fiq_disable
 Useful in hibernation code paths

[PATCH RFC v1 2/3] Fix hibernation restore hang in freeze_processes
 drivers/base/firmware_class.c |    1 +
 1 file changed, 1 insertion(+)

 Add handling for PM_RESTORE_PREPARE notifier

[PATCH RFC v1 3/3] ARM hibernation / suspend-to-disk
 arch/arm/include/asm/memory.h |    1 +
 arch/arm/kernel/Makefile      |    1 +
 arch/arm/kernel/hibernate.c   |  106 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/Kconfig           |    5 ++
 include/linux/suspend.h       |    2 +
 5 files changed, 115 insertions(+)

 Adds support for ARM based hibernation



Additional notes:

There are two checkpatch warnings added by this patch.  These follow
behavior in existing hibernation implementations on other platforms.

    WARNING: externs should be avoided in .c files
    #116: FILE: arch/arm/kernel/hibernate.c:26:
    +extern const void __nosave_begin, __nosave_end;

  This extern is picking up the linker nosave region definitions, only
  used in hibernate.  Follows same extern line used mips, powerpc, s390,
  sh, sparc, x86 & unicore32

    WARNING: externs should be avoided in .c files
    #191: FILE: arch/arm/kernel/hibernate.c:101:
    +extern void call_with_stack(void (*fn)(void *), void *arg, void *sp);

  This extern is used in the arch/arm/ in hibernate, process and bL_switcher





