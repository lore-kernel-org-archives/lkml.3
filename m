Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbbAGXpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:45:53 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:51079 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbAGXpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:45:49 -0500
MIME-Version: 1.0
Date: Thu, 8 Jan 2015 00:45:49 +0100
X-Google-Sender-Auth: 0DrsfJMC3csUkH7BZ4anROsiXcM
Message-ID: <CAJZ5v0jz4zNbTNO2NGPvK8D__zEm9MB6Ar_NQ5-yOXaNhtFxSQ@mail.gmail.com>
Subject: [GIT PULL] Power management and ACPI material for 3.19-rc4
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
 pm+acpi-3.19-rc4

to receive power management and ACPI material for v3.19-rc4 with
top-most commit 794c3a0a9380d46cebff14b0d9b409ecb7687480

 Merge branches 'acpi-pm', 'acpi-processor' and 'acpi-video'

on top of commit b1940cd21c0f4abdce101253e860feff547291b0

 Linux 3.19-rc3

These are an ACPI device power management initialization fix (-stable
material), two commits renaming stuff in the ACPI processor driver
to make it more suitable for ARM64 processors and a new ACPI
backlight blacklist entry.

Specifics:

 - Fix ACPI power management intialization for device objects
   corresponding to devices that are not present at the init time
   (the _STA control method returns 0 for them) and therefore should
   not be regarded as power manageable (Rafael J Wysocki).

 - Rename a structure field and two functions used by the ACPI
   processor driver to make them less tied to architectures that
   use APICs (both x86 and ia64) and more suitable for ARM64
   processors (Hanjun Guo).

 - Add a disable_native_backlight quirk for Dell XPS15 L521X
   designed in an unusual way preventing native backlight from
   working on that machine (Hans de Goede).

Thanks!


---------------

Hanjun Guo (2):
      ACPI / processor: Convert apic_id to phys_id to make it arch agnostic
      ACPI / processor: Rename acpi_(un)map_lsapic() to acpi_(un)map_cpu()

Hans de Goede (1):
      ACPI / video: Add disable_native_backlight quirk for Dell XPS15 L521X

Rafael J. Wysocki (1):
      ACPI / PM: Fix PM initialization for devices that are not present

---------------

 arch/ia64/kernel/acpi.c       |  9 ++++---
 arch/x86/kernel/acpi/boot.c   |  9 ++++---
 drivers/acpi/acpi_processor.c | 25 ++++++++++---------
 drivers/acpi/device_pm.c      |  2 +-
 drivers/acpi/processor_core.c | 56 +++++++++++++++++++++----------------------
 drivers/acpi/scan.c           | 13 ++++++----
 drivers/acpi/video.c          | 10 ++++++++
 include/acpi/processor.h      |  8 +++----
 include/linux/acpi.h          |  4 ++--
 9 files changed, 75 insertions(+), 61 deletions(-)
