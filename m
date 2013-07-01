Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3GABDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:03:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28828 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3GABD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:03:29 -0400
Date: Sun, 30 Jun 2013 21:03:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.11-rc0-tag
Message-ID: <20130701010321.GA6763@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Since the merge window opened merely three hours ago and I am sure
you are addictively refreshing your email for the next set of
GIT PULLs and can't wait for them - I figured I would offer you a
nice little evening GIT-PULL snack to sustain you until Monday
GIT-PULL-email-avalanche :-)

With that in mind please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git  stable/for-linus-3.11-rc0-tag

which has bug-fixes. No new features - just fixes and fixes. The signed
tag goes in more details, but the bulk is just the cleanups (use pr_*
instead of printk, fix strings being split across 80 characters, etc).

Please pull!


 arch/x86/xen/smp.c                          | 91 +++++++++++++++++++----------
 arch/x86/xen/spinlock.c                     |  7 ++-
 arch/x86/xen/time.c                         | 58 +++++++++---------
 drivers/pci/xen-pcifront.c                  |  7 +--
 drivers/xen/balloon.c                       |  6 +-
 drivers/xen/cpu_hotplug.c                   |  6 +-
 drivers/xen/events.c                        | 23 ++++----
 drivers/xen/evtchn.c                        |  6 +-
 drivers/xen/gntalloc.c                      |  6 +-
 drivers/xen/gntdev.c                        |  8 ++-
 drivers/xen/grant-table.c                   | 17 +++---
 drivers/xen/manage.c                        | 25 ++++----
 drivers/xen/mcelog.c                        | 36 +++++-------
 drivers/xen/pcpu.c                          | 12 ++--
 drivers/xen/privcmd.c                       |  4 +-
 drivers/xen/swiotlb-xen.c                   | 12 ++--
 drivers/xen/tmem.c                          | 10 ++--
 drivers/xen/xen-acpi-cpuhotplug.c           |  2 +
 drivers/xen/xen-acpi-memhotplug.c           |  2 +
 drivers/xen/xen-acpi-pad.c                  |  2 +
 drivers/xen/xen-acpi-processor.c            | 25 ++++----
 drivers/xen/xen-balloon.c                   |  6 +-
 drivers/xen/xen-pciback/conf_space_header.c | 16 ++---
 drivers/xen/xen-pciback/pci_stub.c          | 35 +++++------
 drivers/xen/xen-pciback/pciback_ops.c       |  9 ++-
 drivers/xen/xen-pciback/vpci.c              | 10 ++--
 drivers/xen/xen-pciback/xenbus.c            |  8 ++-
 drivers/xen/xen-selfballoon.c               | 11 ++--
 drivers/xen/xenbus/xenbus_comms.c           | 13 +++--
 drivers/xen/xenbus/xenbus_dev_backend.c     |  4 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c    |  4 +-
 drivers/xen/xenbus/xenbus_probe.c           | 30 +++++-----
 drivers/xen/xenbus/xenbus_probe_backend.c   |  8 ++-
 drivers/xen/xenbus/xenbus_probe_frontend.c  | 35 +++++------
 drivers/xen/xenbus/xenbus_xs.c              | 22 +++----
 drivers/xen/xencomm.c                       |  2 +
 drivers/xen/xenfs/super.c                   |  4 +-
 include/xen/hvm.h                           |  4 +-
 38 files changed, 321 insertions(+), 265 deletions(-)

Joe Perches (1):
      xen: Convert printks to pr_<level>

Konrad Rzeszutek Wilk (10):
      xen/smp: Coalesce the free_irq calls in one function.
      xen/smp: Introduce a common structure to contain the IRQ name and interrupt line.
      xen/smp: Set the per-cpu IRQ number to a valid default.
      xen/smp: Don't leak interrupt name when offlining.
      xen/spinlock: Don't leak interrupt name when offlining.
      xen/time: Encapsulate the struct clock_event_device in another structure.
      xen/time: Don't leak interrupt name when offlining.
      xen/time: Check that the per_cpu data structure has data before freeing.
      xen/time: Free onlined per-cpu data structure if we want to online it again.
      xen/pcifront: Deal with toolstack missing 'XenbusStateClosing' state.

Laszlo Ersek (1):
      xen/time: remove blocked time accounting from xen "clockchip"

Stefano Stabellini (1):
      xen: ifdef CONFIG_HIBERNATE_CALLBACKS xen_*_suspend

Wei Yongjun (1):
      xen-pciback: fix error return code in pcistub_irq_handler_switch()

