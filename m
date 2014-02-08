Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaBHNK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 08:10:56 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42941 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaBHNKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 08:10:55 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v2 0/3] Prepare for running ACPI on !x86 and !ia64
Date: Sat,  8 Feb 2014 21:10:15 +0800
Message-Id: <1391865018-3446-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the ACPI code is arch-dependent and make the code can't be
compiled on !x86 or !ia64, the first two patches just do some rework
on the idle_boot_override and _PDC related stuff to make the ACPI
code more arch-independent.

The third patch just introduce map_gic_id() for ACPI processor core
followed by the ACPI 5.0 spec.

I have compiled the kernel successfully after appling this patch set
on x86 and ia64.

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

Hanjun Guo (3):
  ACPI / idle: Make idle_boot_override depend on x86 and ia64
  ACPI / processor_core: Rework _PDC related stuff to make it more
    arch-independent
  ACPI: Introduce map_gic_id() to get apic id from MADT or _MAT method

 arch/ia64/include/asm/acpi.h  |    5 +--
 arch/ia64/kernel/acpi.c       |   17 +++++++++
 arch/x86/include/asm/acpi.h   |   19 +--------
 arch/x86/kernel/acpi/cstate.c |   31 +++++++++++++++
 drivers/acpi/processor_core.c |   85 ++++++++++++++++++++++++-----------------
 5 files changed, 99 insertions(+), 58 deletions(-)

-- 
1.7.9.5

