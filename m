Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab3EIWcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:32:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab3EIWci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/73] 3.8.13-stable review
Date: Thu,  9 May 2013 15:31:23 -0700
Message-Id: <20130509222757.917088509@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------------
NOTE:  This is the LAST 3.8.y kernel release to be done by me.  After
this one, it is end-of-life.  You should have moved on to the 3.9.y
kernel series by now.
--------------------

This is the start of the stable review cycle for the 3.8.13 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat May 11 22:26:18 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.13-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.8.13-rc1

Jerry Hoemann <jerry.hoemann@hp.com>
    x86/mm: account for PGDIR_SIZE alignment

Chen Gang <gang.chen@asianux.com>
    kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4.x: Fix handling of partially delegated locks

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    EDAC: Don't give write permission to read-only files

Josef Bacik <jbacik@fusionio.com>
    Btrfs: fix extent logging with O_DIRECT into prealloc

Josef Bacik <jbacik@fusionio.com>
    Btrfs: compare relevant parts of delayed tree refs

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Fix ftrace_dump()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix handling of v6 power tables

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add new richland pci ids

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix possible segfault when parsing pm tables

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix endian bugs in atom_allocate_fb_scratch()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: disable the crtcs in mc_stop (r5xx-r7xx) (v2)

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: Always flush the VM

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in si_select_se_sh()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix hdmi mode enable on RS600/RS690/RS740

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: cleanup properly if mmio mapping fails

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add some new SI PCI ids

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: disable the crtcs in mc_stop (evergreen+) (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: update wait_for_vblank for r1xx-r4xx

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: properly lock disp in mc_stop/resume for r5xx-r7xx

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: properly lock disp in mc_stop/resume for evergreen+

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: update wait_for_vblank for evergreen+

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: update wait_for_vblank for r5xx-r7xx

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dce6: add missing display reg for tiling setup

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in rv515_mc_resume()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: use frac fb div on RS780/RS880

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: don't use get_engine_clock() on APUs

David Müller <d.mueller@elsoft.ch>
    drm/i915: Fall back to bit banging mode for DVO transmitter detection

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Fixup Oops in the pipe config computation

Jani Nikula <jani.nikula@intel.com>
    drm/i915: ensure single initialization and cleanup of backlight device

Paulo Zanoni <paulo.r.zanoni@intel.com>
    drm/i915: set CPT FDI RX polarity bits based on VBT

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Use MLC (l3$) for context objects

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Workaround incoherence between fences and LLC across multiple CPUs

Egbert Eich <eich@suse.de>
    drm/i915: Fix SDVO connector and encoder get_hw_state functions

Christian Lamparter <chunkeey@googlemail.com>
    drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Fix sdvo connector get_hw_state function

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix detection of base of stolen memory

Dave Airlie <airlied@redhat.com>
    drm/ast: deal with bo reserve fail in dirty update path

Dave Airlie <airlied@gmail.com>
    drm/prime: keep a reference from the handle to exported dma-buf (v6)

Anisse Astier <anisse@astier.eu>
    drm/gma500: fix backlight hotkeys behaviour on netbooks

Dave Airlie <airlied@redhat.com>
    drm/mgag200: deal with bo reserve fail in dirty update path

Dave Airlie <airlied@redhat.com>
    drm/cirrus: deal with bo reserve fail in dirty update path

James Bottomley <JBottomley@Parallels.com>
    block: fix max discard sectors limit

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Ignore the 'write' ESR flag on cache maintenance faults

Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
    RDMA/cxgb4: Fix SQ allocation when on-chip SQ is disabled

Stefan Bader <stefan.bader@canonical.com>
    r8169: fix 8168evl frame padding.

Theodore Ts'o <tytso@mit.edu>
    ext4: add check for inodes_count overflow in new resize ioctl

Matthias Schiffer <mschiffer@universe-factory.net>
    netfilter: ip6t_NPT: Fix translation for non-multiple of 32 prefix lengths

Florian Westphal <fw@strlen.de>
    netfilter: xt_rpfilter: skip locally generated broadcast/multicast, too

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: don't permit ct creation with random tuple

Florian Westphal <fw@strlen.de>
    netfilter: nf_ct_helper: don't discard helper if it is actually the same

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
    netfilter: ipset: "Directory not empty" error message

Patrick McHardy <kaber@trash.net>
    netfilter: nf_ct_sip: don't drop packets with offsets pointing outside the packet

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
    netfilter: ipset: list:set: fix reference counter update

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat: fix race when unloading protocol modules

Hans Schillstrom <hans@schillstrom.com>
    ipvs: ip_vs_sip_fill_param() BUG: bad check of return value

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Don't warn on empty ring for suspended devices.

Konstantin Khlebnikov <khlebnikov@openvz.org>
    e1000e: fix accessing to suspended device

Konstantin Khlebnikov <khlebnikov@openvz.org>
    e1000e: fix runtime power management transitions

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI/PM: Clear state_saved during suspend

Peter Zijlstra <a.p.zijlstra@chello.nl>
    perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL

Peter Zijlstra <a.p.zijlstra@chello.nl>
    perf/x86/intel/lbr: Fix LBR filter

Jan-Simon Möller <dl9pf@gmx.de>
    perf/x86/intel: Fix unintended variable name reuse

Vince Weaver <vincent.weaver@maine.edu>
    perf/x86/intel: Add support for IvyBridge model 58 Uncore

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    net/eth/ibmveth: Fixup retrieval of MAC address

Joerg Roedel <joro@8bytes.org>
    iommu/amd: Properly initialize irq-table lock

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    hugetlbfs: fix mmap failure in unaligned size request

David Jeffery <djeffery@redhat.com>
    autofs - remove autofs dentry mount check

Axel Lin <axel.lin@ingics.com>
    pwm: spear: Fix checking return value of clk_enable() and clk_prepare()

Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
    powerpc: fix numa distance for form0 device tree

Anton Blanchard <anton@samba.org>
    powerpc: Emulate non privileged DSCR read and write

Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    xen/arm: actually pass a non-NULL percpu pointer to request_percpu_irq


-------------

Diffstat:

 Makefile                                      |   4 +-
 arch/arm/xen/enlighten.c                      |   2 +-
 arch/arm64/mm/fault.c                         |   3 +-
 arch/powerpc/include/asm/ppc-opcode.h         |   4 +
 arch/powerpc/kernel/traps.c                   |  10 ++-
 arch/powerpc/mm/numa.c                        |   2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c    |  27 +++++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |  17 ++--
 arch/x86/mm/init.c                            |   5 ++
 drivers/edac/edac_mc_sysfs.c                  |  12 +--
 drivers/gpu/drm/ast/ast_drv.h                 |   2 +
 drivers/gpu/drm/ast/ast_fb.c                  |  43 +++++++++-
 drivers/gpu/drm/ast/ast_ttm.c                 |   2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.h           |   2 +
 drivers/gpu/drm/cirrus/cirrus_fbdev.c         |  38 ++++++++-
 drivers/gpu/drm/cirrus/cirrus_ttm.c           |   2 +-
 drivers/gpu/drm/drm_gem.c                     |   4 +-
 drivers/gpu/drm/drm_prime.c                   |  76 +++++++++---------
 drivers/gpu/drm/gma500/psb_irq.c              |   2 +-
 drivers/gpu/drm/i915/i915_drv.h               |   2 +
 drivers/gpu/drm/i915/i915_gem.c               |  28 +++++--
 drivers/gpu/drm/i915/i915_gem_context.c       |   7 ++
 drivers/gpu/drm/i915/i915_gem_stolen.c        |  81 +++++++++----------
 drivers/gpu/drm/i915/i915_reg.h               |   2 +-
 drivers/gpu/drm/i915/intel_bios.c             |   6 +-
 drivers/gpu/drm/i915/intel_bios.h             |   4 +-
 drivers/gpu/drm/i915/intel_display.c          |  26 +++---
 drivers/gpu/drm/i915/intel_dp.c               |   5 +-
 drivers/gpu/drm/i915/intel_dvo.c              |  13 ++-
 drivers/gpu/drm/i915/intel_lvds.c             |   9 ++-
 drivers/gpu/drm/i915/intel_panel.c            |   7 +-
 drivers/gpu/drm/i915/intel_pm.c               |   9 ++-
 drivers/gpu/drm/i915/intel_sdvo.c             |   5 +-
 drivers/gpu/drm/mgag200/mgag200_drv.h         |   2 +
 drivers/gpu/drm/mgag200/mgag200_fb.c          |  43 +++++++++-
 drivers/gpu/drm/mgag200/mgag200_ttm.c         |   4 +-
 drivers/gpu/drm/radeon/atom.c                 |   6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c        |   3 +
 drivers/gpu/drm/radeon/evergreen.c            | 111 +++++++++++++++++++++++---
 drivers/gpu/drm/radeon/evergreen_reg.h        |   2 +
 drivers/gpu/drm/radeon/ni.c                   |   8 +-
 drivers/gpu/drm/radeon/nid.h                  |   4 +
 drivers/gpu/drm/radeon/r100.c                 |  77 ++++++++++++------
 drivers/gpu/drm/radeon/r500_reg.h             |   2 +
 drivers/gpu/drm/radeon/r600_hdmi.c            |   4 +-
 drivers/gpu/drm/radeon/radeon_atombios.c      |  21 +++--
 drivers/gpu/drm/radeon/radeon_kms.c           |   4 +
 drivers/gpu/drm/radeon/radeon_pm.c            |   6 +-
 drivers/gpu/drm/radeon/radeon_ring.c          |   3 +-
 drivers/gpu/drm/radeon/rs600.c                |  52 ++++++++++--
 drivers/gpu/drm/radeon/rv515.c                |  56 ++++++++++++-
 drivers/gpu/drm/radeon/si.c                   |   3 +-
 drivers/gpu/drm/radeon/sid.h                  |   2 +
 drivers/infiniband/hw/cxgb4/qp.c              |  25 +++---
 drivers/iommu/amd_iommu.c                     |   3 +
 drivers/net/ethernet/ibm/ibmveth.c            |  23 +++---
 drivers/net/ethernet/intel/e1000e/ethtool.c   |  13 +++
 drivers/net/ethernet/intel/e1000e/netdev.c    |  80 +++++--------------
 drivers/net/ethernet/realtek/r8169.c          |   9 +++
 drivers/pci/pci-driver.c                      |   4 +
 drivers/pwm/pwm-spear.c                       |   6 +-
 drivers/usb/host/xhci-ring.c                  |  23 ++++--
 fs/autofs4/expire.c                           |   9 ---
 fs/btrfs/delayed-ref.c                        |  24 +++---
 fs/btrfs/inode.c                              |  21 +++--
 fs/ext4/resize.c                              |   4 +
 fs/hugetlbfs/inode.c                          |  24 +++---
 fs/nfs/nfs4proc.c                             |   4 +-
 include/drm/drmP.h                            |   5 +-
 include/drm/drm_pciids.h                      |   5 ++
 include/linux/blkdev.h                        |   2 +-
 include/linux/hugetlb.h                       |  19 +++--
 ipc/shm.c                                     |   6 +-
 kernel/audit_tree.c                           |   2 +-
 kernel/trace/trace.c                          |  62 ++++++--------
 kernel/trace/trace_selftest.c                 |   9 ++-
 mm/mmap.c                                     |   7 +-
 net/ipv4/netfilter/ipt_rpfilter.c             |   8 +-
 net/ipv6/netfilter/ip6t_NPT.c                 |   2 +-
 net/ipv6/netfilter/ip6t_rpfilter.c            |   8 +-
 net/netfilter/ipset/ip_set_core.c             |   3 +-
 net/netfilter/ipset/ip_set_list_set.c         |  10 ++-
 net/netfilter/ipvs/ip_vs_pe_sip.c             |   6 +-
 net/netfilter/nf_conntrack_helper.c           |   4 +-
 net/netfilter/nf_conntrack_netlink.c          |   3 +
 net/netfilter/nf_conntrack_sip.c              |   2 +-
 net/netfilter/nf_nat_core.c                   |  40 ++--------
 87 files changed, 903 insertions(+), 446 deletions(-)


