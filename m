Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaDAELl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:11:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaDAELj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:11:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.13 00/22] 3.13.9-stable review
Date: Mon, 31 Mar 2014 21:08:30 -0700
Message-Id: <20140401040703.045139933@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.13.9 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Apr  3 04:06:39 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.9-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.13.9-rc1

Daniel Borkmann <dborkman@redhat.com>
    netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages

Li Zefan <lizefan@huawei.com>
    cgroup: protect modifications to cgroup_idr with cgroup_mutex

David Rientjes <rientjes@google.com>
    mm: close PageTail race

Al Viro <viro@zeniv.linux.org.uk>
    switch mnt_hash to hlist

Al Viro <viro@zeniv.linux.org.uk>
    don't bother with propagate_mnt() unless the target is shared

Al Viro <viro@zeniv.linux.org.uk>
    keep shadowed vfsmounts together

Al Viro <viro@zeniv.linux.org.uk>
    resizable namespace.c hashes

Sasha Levin <sasha.levin@oracle.com>
    random32: avoid attempt to late reseed if in the middle of seeding

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    net: mvneta: fix usage as a module on RGMII configurations

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    net: mvneta: rename MVNETA_GMAC2_PSC_ENABLE to MVNETA_GMAC2_PCS_ENABLE

Al Viro <viro@zeniv.linux.org.uk>
    make prepend_name() work correctly when called with negative *buflen

Artem Fetishev <artem_fetishev@epam.com>
    x86: fix boot on uniprocessor systems

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Undo gtt scratch pte unmapping again

Scott Wood <scottwood@freescale.com>
    i2c: cpm: Fix build by adding of_address.h and of_irq.h

David Vrabel <david.vrabel@citrix.com>
    Revert "xen: properly account for _PAGE_NUMA during xen pte translations"

Wei Liu <wei.liu2@citrix.com>
    xen/balloon: flush persistent kmaps in correct position

Hans de Goede <hdegoede@redhat.com>
    Input: cypress_ps2 - don't report as a button pads

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - add manual min/max quirk for ThinkPad X240

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    Input: synaptics - add manual min/max quirk

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: mousedev - fix race when creating mixed device

Al Viro <viro@zeniv.linux.org.uk>
    rcuwalk: recheck mount_lock after mountpoint crossing attempts

Theodore Ts'o <tytso@mit.edu>
    ext4: atomically set inode->i_flags in ext4_set_inode_flags()


-------------

Diffstat:

 Makefile                                |   4 +-
 arch/x86/include/asm/pgtable.h          |  14 +--
 arch/x86/include/asm/topology.h         |   3 +-
 arch/x86/xen/mmu.c                      |   4 +-
 drivers/block/aoe/aoecmd.c              |   4 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c     |   2 +-
 drivers/i2c/busses/i2c-cpm.c            |   2 +
 drivers/input/mouse/cypress_ps2.c       |   1 -
 drivers/input/mouse/synaptics.c         |  55 ++++++++++
 drivers/input/mousedev.c                |  73 +++++++------
 drivers/net/ethernet/marvell/mvneta.c   |  43 ++------
 drivers/vfio/vfio_iommu_type1.c         |   4 +-
 drivers/xen/balloon.c                   |  24 +++--
 fs/dcache.c                             |   4 +-
 fs/ext4/inode.c                         |  15 +--
 fs/mount.h                              |   4 +-
 fs/namei.c                              |  29 +++---
 fs/namespace.c                          | 177 +++++++++++++++++++++-----------
 fs/pnode.c                              |  26 +++--
 fs/pnode.h                              |   4 +-
 fs/proc/page.c                          |   2 +-
 include/linux/bitops.h                  |  15 +++
 include/linux/cgroup.h                  |   2 +
 include/linux/huge_mm.h                 |  18 ----
 include/linux/mm.h                      |  14 ++-
 kernel/cgroup.c                         |  26 ++---
 lib/random32.c                          |  13 ++-
 mm/ksm.c                                |   2 +-
 mm/memory-failure.c                     |   2 +-
 mm/page_alloc.c                         |   4 +-
 mm/swap.c                               |   4 +-
 net/netfilter/nf_conntrack_proto_dccp.c |   6 +-
 32 files changed, 362 insertions(+), 238 deletions(-)


