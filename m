Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3JaMhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:37:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61794 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753545Ab3JaMhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:37:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Last-minute ACPI and power management fixes for v3.12
Date: Thu, 31 Oct 2013 13:49:13 +0100
Message-ID: <23460898.v0KnXzAEpz@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.12-late

to receive last-minute ACPI and power management fixes for v3.12
with top-most commit ab1225901da2d4cd2dcbae6840e93abbef417064

  Revert "ACPI / hotplug / PCI: Avoid doing too much for spurious notifies"

on top of commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb

  Linux 3.12-rc7

These revert two troublesome freezer-related commits introduced during the
3.11 cycle and a recent commit related to PCI hotplug that was applied to
fix one machine, but causes problems to happen elsewhere and turns out
to be unnecessary after another fix that went in later.

Specifics:

 - Revert epoll and select commits related to the freezer, introduced
   during the 3.11 cycle, that cause mysterious user space breakage
   to occur during resume from suspend to RAM for multiple users of
   32-bit x86 systems.  Material for 3.11.y stable kernels.

 - Revert a recent ACPI-based PCI hotplug (ACPIPHP) commit that was
   part of boot problem fixes for one machine, but turns out to cause
   issues with hotplug on Thunderbolt chains with multiple devices.
   It also turns out to be unnecessary after another fix in the
   same area that went in later.  From Mika Westerberg.

Thanks!


---------------

Mika Westerberg (1):
      Revert "ACPI / hotplug / PCI: Avoid doing too much for spurious notifies"

Rafael J. Wysocki (2):
      Revert "epoll: use freezable blocking call"
      Revert "select: use freezable blocking call"

---------------

 drivers/pci/hotplug/acpiphp_glue.c |    6 +-----
 fs/eventpoll.c                     |    4 +---
 fs/select.c                        |    3 +--
 3 files changed, 3 insertions(+), 10 deletions(-)

