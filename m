Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaH2VPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 17:15:01 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:53338 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaH2VO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 17:14:59 -0400
MIME-Version: 1.0
Date: Fri, 29 Aug 2014 23:14:58 +0200
X-Google-Sender-Auth: TUkQ3zxB3ppRl1ooc4uamKHDy2g
Message-ID: <CAJZ5v0g9XMKUQSfrm7so=PFQF0j3xSnBYpKuk8nY_52t7=Cung@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for 3.17-rc3
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.17-rc3

to receive more ACPI and power management fixes for v3.17-rc3 with
top-most commit 0b4f58b7cebd74ede19d13b81fb43a7eaeba10a3

 Merge branch 'pm-cpufreq'

on top of commit 52addcf9d6669fa439387610bc65c92fa0980cef

 Linux 3.17-rc2

These are ACPI regression fixes (fixed events handling, EC driver
and PNP enumeration), intel_pstate fix for excessive messages on
boot, spurious __init removal from the s5pv210 cpufreq driver and
new IDs for Intel Braswell.

Specifics:

 - Fix for an ACPI regression related to the handling of fixed events
   that caused netlink routines to be (incorrectly) run in interrupt
   context from Lan Tianyu.

 - Fix for an ACPI EC driver regression on Acer Aspire V5-573G that
   caused AC/battery plug/unplug and video brightness change
   notifications to be delayed on that machine from Lv Zheng.

 - Fix for an ACPI device enumeration regression that caused ACPI
   driver probe to fail for some devices where it succeeded before
   (Rafael J Wysocki).

 - intel_pstate driver fix to prevent it from printing an information
   message for every CPU in the system on every boot from Andi Kleen.

 - s5pv210 cpufreq driver fix to remove an __init annotation from
   a routine that in fact can be called at any time after init too
   from Mark Brown.

 - New Intel Braswell device IDs for the ACPI LPSS (Low-Power Subsystem)
   driver from Alan Cox.

 - New Intel Braswell CPU ID for intel_pstate from Mika Westerberg.

Thanks!


---------------

Alan Cox (1):
      ACPI / LPSS: Add ACPI IDs for Intel Braswell

Andi Kleen (1):
      intel_pstate: Turn per cpu printk into pr_debug

Lan Tianyu (1):
      ACPI: Run fixed event device notifications in process context

Lv Zheng (2):
      ACPI / EC: Add support to disallow QR_EC to be issued when
SCI_EVT isn't set
      ACPI / EC: Add support to disallow QR_EC to be issued before
completing previous QR_EC

Mark Brown (1):
      cpufreq: s5pv210: Remove spurious __init annotation

Mika Westerberg (1):
      cpufreq: intel_pstate: Add CPU ID for Braswell processor

Rafael J. Wysocki (1):
      ACPI / scan: Allow ACPI drivers to bind to PNP device objects

---------------

 drivers/acpi/acpi_lpss.c          | 17 +++++++++++++++++
 drivers/acpi/ec.c                 | 21 ++++++++++++++++++---
 drivers/acpi/scan.c               | 17 +++++++++++------
 drivers/cpufreq/intel_pstate.c    |  3 ++-
 drivers/cpufreq/s5pv210-cpufreq.c |  2 +-
 5 files changed, 49 insertions(+), 11 deletions(-)
