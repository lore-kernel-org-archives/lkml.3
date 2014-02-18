Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbaBRNz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:55:59 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34184 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaBRNz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:55:57 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v4 0/5] Prepare for running ACPI on !x86 and !ia64
Date: Tue, 18 Feb 2014 21:54:55 +0800
Message-Id: <1392731700-10992-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the ACPI code is arch-dependent and make the code can't be
compiled on !x86 or !ia64, the first two patches just do some rework
on the idle_boot_override and _PDC related stuff to make the ACPI
code more arch-independent.

The third patch just introduce map_gic_id() for ACPI processor core
followed the ACPI 5.0 spec. Last two patches are just some cleanups.

I have compiled the kernel successfully after appling this patch set
on x86 and ia64.

Changes for v4:
a) remove preprocessor directives in function bodies;
b) add another two patches for cleanups.

Changes for v3:
Fix the issues pointed out by Lan Tianyu and add the Reviewed-by for
first patch.

Changes for v2:
a) add #if defined(CONFIG_X86) || defined(CONFIG_IA64) for
   idle_boot_override related code;
b) Rebased on 3.14-rc1.

Changes since the RFC version:
a) Remove the RFC tag;
b) Move idle_boot_override out of the arch directory suggested
   by Alan;
c) Make these 3 patches as a separate patch set since there are
   not not related to the ARM/ARM64 platform.

Hanjun Guo (5):
  ACPI / idle: Make idle_boot_override depend on x86 and ia64
  ACPI / processor_core: Rework _PDC related stuff to make it more
    arch-independent
  ACPI / processor: Introduce map_gic_id() to get apic id from MADT or
    _MAT method
  ACPI: Move BAD_MADT_ENTRY() to linux/acpi.h
  ACPI: Replace printk with pr_* in tables.c

 arch/ia64/include/asm/acpi.h  |    5 +--
 arch/ia64/kernel/acpi.c       |   18 ++++++--
 arch/x86/include/asm/acpi.h   |   19 +--------
 arch/x86/kernel/acpi/boot.c   |    4 --
 arch/x86/kernel/acpi/cstate.c |   29 +++++++++++++
 drivers/acpi/processor_core.c |   92 ++++++++++++++++++++++++-----------------
 drivers/acpi/tables.c         |   51 +++++++++--------------
 include/linux/acpi.h          |    4 ++
 8 files changed, 124 insertions(+), 98 deletions(-)

-- 
1.7.9.5

