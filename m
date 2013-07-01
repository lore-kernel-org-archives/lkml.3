Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3GAM6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:58:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41287 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3GAM6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:58:13 -0400
Date: Mon, 1 Jul 2013 08:58:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, sfr@canb.auug.org.au
Subject: [GIT PULL] (xen) stable/for-linus-3.11-rc0-tag-two
Message-ID: <20130701125801.GA7449@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git  stable/for-linus-3.11-rc0-tag-two

which has just bug-fixes. No new features - just fixes and fixes. The signed
tag goes in more details, but the bulk is just the cleanups (use pr_*
instead of printk, fix strings being split across 80 characters, etc).

Please pull!

Sorry about the previous GIT PULL email. I ended up tagging the wrong branch
(the test one). Fortunatly for me Stephen spotted it right away. Thanks!


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

