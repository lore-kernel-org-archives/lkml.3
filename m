Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaBFX0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:26:18 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36349 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaBFX0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:26:13 -0500
MIME-Version: 1.0
Date: Fri, 7 Feb 2014 00:26:12 +0100
X-Google-Sender-Auth: qNOgKyGkOQRotwKYA03Hp3iDkXY
Message-ID: <CAJZ5v0ht94v9Rap4EN4kMUTLJFZPD_AKMYz8FdrDOQ-E=ifJZQ@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for v3.14-rc2
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
pm+acpi-3.14-rc2

to receive ACPI and power management fixes for v3.14-rc2
with top-most commit a2ff34c433932e201ea3c5081335f3beeb2509bd

  Merge branches 'acpi-cleanup' and 'acpi-video'

on top of commit 38dbfb59d1175ef458d006556061adeaa8751b72

  Linus 3.14-rc1

These include a fix for a recent ACPI hotplug regression, four concurrency
related fixes and one PCI device removal fix for ACPI-based PCI hotplug
(ACPIPHP), intel_pstate fix that should go into stable, three simple
ACPI cleanups and a new entry for the ACPI video blacklist.

Specifics:

 - Fix for a recent ACPI hotplug regression causing a NULL pointer
   dereference to occur while handling ACPI eject notifications for
   already ejected devices.  From Toshi Kani.

 - Four concurrency-related fixes for ACPIPHP.  Two of them add
   missing locking and the other two fix race conditions related to
   reference counting.

 - ACPIPHP fix to avoid NULL pointer dereferences during device removal
   involving Virtual Funcions.

 - intel_pstate fix to make it compute the percentage of time the CPU
   is busy properly.  From Dirk Brandewie.

 - Removal of two unnecessary NULL pointer checks in ACPI code and a
   fix for sscanf() format string from Dan Carpenter and Luis G.F.

 - New ACPI video blacklist entry for HP EliteBook Revolve 810 from
   Mika Westerberg.

Thanks!


---------------

Dan Carpenter (2):
      ACPI / utils: remove a pointless NULL check
      ACPI / proc: remove unneeded NULL check

Dirk Brandewie (1):
      intel_pstate: Take core C0 time into account for core busy calculation

Luis G.F (1):
      ACPI / battery: Fix incorrect sscanf() string in acpi_battery_init_alarm()

Mika Westerberg (1):
      ACPI / video: Add HP EliteBook Revolve 810 to the blacklist

Rafael J. Wysocki (5):
      ACPI / hotplug / PCI: Remove entries from bus->devices in reverse order
      ACPI / hotplug / PCI: Move PCI rescan-remove locking to hotplug_event()
      ACPI / hotplug / PCI: Scan root bus under the PCI rescan-remove lock
      ACPI / hotplug / PCI: Fix bridge removal race in handle_hotplug_event()
      ACPI / hotplug / PCI: Fix bridge removal race vs dock events

Toshi Kani (1):
      ACPI / hotplug: Fix panic on eject to ejected device

---------------

 drivers/acpi/battery.c             |    2 +-
 drivers/acpi/proc.c                |    2 +-
 drivers/acpi/scan.c                |    6 ++--
 drivers/acpi/utils.c               |    4 ---
 drivers/acpi/video_detect.c        |    8 ++++++
 drivers/cpufreq/intel_pstate.c     |   21 +++++++++++---
 drivers/pci/hotplug/acpiphp_glue.c |   55 ++++++++++++++++++++++++++++--------
 7 files changed, 75 insertions(+), 23 deletions(-)
