Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab3LMCKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:10:36 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:47825 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3LMCKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:10:34 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Subject: [PATCH v10] Repost of PVH patches for Linux.
Date: Thu, 12 Dec 2013 21:10:07 -0500
Message-Id: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Mukesh had posted them quite a while ago - they got reviewed, acked, etc,
put in #linux-next, got patches to fix some things from folks.

Then everybody focused on the Xen patches .. and now that is mostly
baked this is what is needed on the Linux side to make it work
with PVH. I had them based on v3.6, then merged on v3.11, then..

Decided to rebase all of them on v3.13-rc3 to make it easier.

Couple of things:

a) the patch:
 [PATCH V10 14/14] xen/pvh: vcpu info placement, load CS selector,

could be split in three - and I think Mukesh did have a version like that.
I can do it myself and will - it should be obvious of how it will be done.

b). Regression testing  - I ran this with a Linux kernel dom0 (32 and 64)
    on the latest Xen hypervisor without PVH enabled. It booted all the
    guests I had:
    RHEL5, SLES11, SLES12, F15, F16, F17, F18, F19, OEL5, OEL6, NetBSD PV,
    FreeBSD HVM; and also 32 and 64 PV and PVHVM combination of the same
    kernel (and save/restore on those). Nothing broke.

c). I hadn't tested it all with PVH enabled. Mukesh I believe has one or
    two patches that need to be put on top of this to make it work with
    the hypervisor changes.

These patches are also available on:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pvh.v10

[but they are out-dated a bit - I messed up on that branch and some
of the authorships are assigned to me instead of Mukesh. I will
provide a stable/pvh.v10 shortly]

 arch/x86/include/asm/xen/interface.h |   11 ++-
 arch/x86/include/asm/xen/page.h      |    3 +
 arch/x86/xen/Kconfig                 |    8 ++
 arch/x86/xen/enlighten.c             |   91 ++++++++++++++++----
 arch/x86/xen/irq.c                   |    5 +-
 arch/x86/xen/mmu.c                   |  155 +++++++++++++++++++++++++++++++---
 arch/x86/xen/mmu.h                   |    2 +
 arch/x86/xen/p2m.c                   |    4 +-
 arch/x86/xen/setup.c                 |   58 ++++++++++---
 arch/x86/xen/smp.c                   |   38 ++++++--
 arch/x86/xen/xen-head.S              |   10 ++-
 drivers/xen/balloon.c                |   37 +++++----
 drivers/xen/cpu_hotplug.c            |    4 +-
 drivers/xen/events.c                 |    9 ++-
 drivers/xen/gntdev.c                 |    3 +-
 drivers/xen/grant-table.c            |   64 +++++++++++++-
 drivers/xen/xenbus/xenbus_client.c   |    3 +-
 17 files changed, 423 insertions(+), 82 deletions(-)

Alexander Duyck (1):
      x86/xen: Use __pa_symbol instead of __pa on C visible symbols

Ian Campbell (2):
      xen: x86 pvh: use XENMEM_add_to_physmap_range for foreign gmfn mappings
      xen: implement updated XENMEM_add_to_physmap_range ABI

Kees Cook (1):
      x86/xen: remove depends on CONFIG_EXPERIMENTAL

Mukesh Rathor (9):
      xen/pvh: Support ParaVirtualized Hardware extensions.
      xen/pvh: Extend vcpu_guest_context, p2m, event, and XenBus.
      xen/pvh: Implement MMU changes for PVH.
      xen/pvh: bootup and setup (E820) related changes.
      xen/pvh: balloon and grant changes.
      xen/pvh: specify xen features strings cleanly for PVH
      xen/pvh: remove code to map iomem from guest
      xen/pvh: Use ballooning to allocate grant table pages [v2]
      xen/pvh: vcpu info placement, load CS selector, and remove debug printk.

Wei Yongjun (1):
      xen/x86: remove duplicated include from enlighten.c

