Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205AbaKSVZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:25:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933851AbaKSVOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/70] 3.10.61-stable review
Date: Wed, 19 Nov 2014 12:51:51 -0800
Message-Id: <20141119205210.913169042@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.61 release.
There are 70 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Nov 21 20:51:58 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.61-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.61-rc1

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcg: handle non-error OOM situations more gracefully

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcg: do not trap chargers with full callstack on OOM

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcg: rework and document OOM waiting and wakeup

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcg: enable memcg OOM killer only for user faults

Johannes Weiner <hannes@cmpxchg.org>
    x86: finish user fault error path with fatal signal

Johannes Weiner <hannes@cmpxchg.org>
    arch: mm: pass userspace fault flag to generic fault handler

Johannes Weiner <hannes@cmpxchg.org>
    arch: mm: do not invoke OOM killer on kernel fault OOM

Johannes Weiner <hannes@cmpxchg.org>
    arch: mm: remove obsolete init OOM protection

Johannes Weiner <hannes@cmpxchg.org>
    mm: invoke oom-killer from remaining unconverted page fault handlers

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix panic on duplicate ASCONF chunks

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix remote memory pressure from excessive queueing

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Don't report guest userspace emulation error to userspace

Tomas Henzl <thenzl@redhat.com>
    SCSI: hpsa: fix a race in cmd_free/scsi_done

Eugenia Emantayev <eugenia@mellanox.com>
    net/mlx4_en: Fix BlueFlame race

Ben Dooks <ben.dooks@codethink.co.uk>
    ARM: Correct BUG() assembly to ensure it is endian-agnostic

Vince Weaver <vincent.weaver@maine.edu>
    perf/x86/intel: Use proper dTLB-load-misses event on IvyBridge

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus: fix possible boundaries violation

Pawel Moll <pawel.moll@arm.com>
    perf: Handle compat ioctl

Yoichi Yuasa <yuasa@linux-mips.org>
    MIPS: Fix forgotten preempt_enable() when CPU has inclusive pcaches

Pali Rohár <pali.rohar@gmail.com>
    dell-wmi: Fix access out of memory

Ben Dooks <ben.dooks@codethink.co.uk>
    ARM: probes: fix instruction fetch order with <asm/opcodes.h>

Jiri Pirko <jiri@resnulli.us>
    br: fix use of ->rx_handler_data in code executed on non-rx_handler path

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat: fix oops on netns removal

Pablo Neira <pablo@netfilter.org>
    netfilter: xt_bpf: add mising opaque struct sk_filter definition

Houcheng Lin <houcheng@gmail.com>
    netfilter: nf_log: release skbuff on nlmsg put failure

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: fix maximum packet length logged to userspace

Florian Westphal <fw@strlen.de>
    netfilter: nf_log: account for size of NLMSG_DONE attribute

Andrey Vagin <avagin@openvz.org>
    ipc: always handle a new value of auto_msgmni

Bjorn Helgaas <bhelgaas@google.com>
    clocksource: Remove "weak" from clocksource_default_clock() declaration

Bjorn Helgaas <bhelgaas@google.com>
    kgdb: Remove "weak" from kgdb_arch_pc() declaration

Dan Carpenter <dan.carpenter@oracle.com>
    media: ttusb-dec: buffer overflow in ioctl

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix races between nfs_remove_bad_delegation() and delegation return

Jan Kara <jack@suse.cz>
    nfs: Fix use of uninitialized variable in nfs_getattr()

Trond Myklebust <trond.myklebust@primarydata.com>
    NFS: Don't try to reclaim delegation open state if recovery failed

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Ensure that we remove NFSv4.0 delegations when state has expired

Pali Rohár <pali.rohar@gmail.com>
    Input: alps - allow up to 2 invalid packets without resetting device

Pali Rohár <pali.rohar@gmail.com>
    Input: alps - ignore potential bare packets when device is out of sync

Heinz Mauelshagen <heinzm@redhat.com>
    dm raid: ensure superblock's size matches device's logical block size

Joe Thornber <ejt@redhat.com>
    dm btree: fix a recursion depth bug in btree walking code

Jan Kara <jack@suse.cz>
    block: Fix computation of merged request priority

Helge Deller <deller@gmx.de>
    parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop syscalls

Christoph Hellwig <hch@lst.de>
    scsi: only re-lock door after EH on devices that were reset

Peng Tao <tao.peng@primarydata.com>
    nfs: fix pnfs direct write memory leak

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: cdev: prevent kernel stack leaking into ioctl arguments

Kyle McMartin <kyle@redhat.com>
    arm64: __clear_user: handle exceptions on strb

Nathan Lynch <nathan_lynch@mentor.com>
    ARM: 8198/1: make kuser helpers depend on MMU

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add missing crtc unlock when setting up the MC

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix use-after-free in defragmentation

Herbert Xu <herbert@gondor.apana.org.au>
    macvtap: Fix csum_start when VLAN tags are present

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: configure the LTR

Ilya Dryomov <idryomov@redhat.com>
    libceph: do not crash on large auth tickets

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: re-wire umount syscall to sys_oldumount

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix memory leak in FTU quirk

Tejun Heo <tj@kernel.org>
    ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks

James Ralston <james.d.ralston@intel.com>
    ahci: Add Device IDs for Intel Sunrise Point PCH

Miklos Szeredi <mszeredi@suse.cz>
    audit: keep inode pinned

Andy Lutomirski <luto@amacapital.net>
    x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit

Andreas Larsson <andreas@gaisler.com>
    sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks

David S. Miller <davem@davemloft.net>
    sparc64: Do irq_{enter,exit}() around generic_smp_call_function*().

David S. Miller <davem@davemloft.net>
    sparc64: Fix crashes in schizo_pcierr_intr_other().

Dwight Engen <dwight.engen@oracle.com>
    sunvdc: don't call VD_OP_GET_VTOC

Dwight Engen <dwight.engen@oracle.com>
    vio: fix reuse of vio_dring slot

Dwight Engen <dwight.engen@oracle.com>
    sunvdc: limit each sg segment to a page

Allen Pais <allen.pais@oracle.com>
    sunvdc: compute vdisk geometry from capacity

Allen Pais <allen.pais@oracle.com>
    sunvdc: add cdrom and v1.1 protocol support

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix memory leak in auth key management

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix NULL pointer dereference in af->from_addr_param on malformed packet

Steffen Klassert <steffen.klassert@secunet.com>
    gre6: Move the setting of dev->iflink into the ndo_init functions.

Steffen Klassert <steffen.klassert@secunet.com>
    ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/alpha/mm/fault.c                           |   7 +-
 arch/arc/mm/fault.c                             |  17 ++-
 arch/arm/include/asm/bug.h                      |  10 +-
 arch/arm/kernel/kprobes-common.c                |  19 +--
 arch/arm/kernel/kprobes-thumb.c                 |  20 +--
 arch/arm/kernel/kprobes.c                       |   9 +-
 arch/arm/kernel/traps.c                         |   8 +-
 arch/arm/mm/Kconfig                             |   1 +
 arch/arm/mm/fault.c                             |  23 +--
 arch/arm64/lib/clear_user.S                     |   2 +-
 arch/arm64/mm/fault.c                           |  31 ++--
 arch/avr32/mm/fault.c                           |   4 +-
 arch/cris/mm/fault.c                            |   6 +-
 arch/frv/mm/fault.c                             |  10 +-
 arch/hexagon/mm/vm_fault.c                      |   6 +-
 arch/ia64/mm/fault.c                            |   6 +-
 arch/m32r/mm/fault.c                            |  10 +-
 arch/m68k/mm/fault.c                            |   2 +
 arch/metag/mm/fault.c                           |  12 +-
 arch/microblaze/mm/fault.c                      |   7 +-
 arch/mips/mm/c-r4k.c                            |   2 +
 arch/mips/mm/fault.c                            |   8 +-
 arch/mn10300/mm/fault.c                         |   9 +-
 arch/openrisc/mm/fault.c                        |   9 +-
 arch/parisc/include/uapi/asm/shmbuf.h           |  25 ++--
 arch/parisc/kernel/syscall_table.S              |   8 +-
 arch/parisc/mm/fault.c                          |   7 +-
 arch/powerpc/mm/fault.c                         |   7 +-
 arch/s390/mm/fault.c                            |   2 +
 arch/score/mm/fault.c                           |  21 ++-
 arch/sh/mm/fault.c                              |   9 +-
 arch/sparc/include/asm/atomic_32.h              |   2 +-
 arch/sparc/include/asm/cmpxchg_32.h             |  12 +-
 arch/sparc/include/asm/vio.h                    |  14 +-
 arch/sparc/kernel/pci_schizo.c                  |   6 +-
 arch/sparc/kernel/smp_64.c                      |   4 +
 arch/sparc/lib/atomic32.c                       |  27 ++++
 arch/sparc/mm/fault_32.c                        |  12 +-
 arch/sparc/mm/fault_64.c                        |   6 +-
 arch/tile/mm/fault.c                            |  21 ++-
 arch/um/kernel/trap.c                           |  22 +--
 arch/unicore32/mm/fault.c                       |  22 +--
 arch/x86/kernel/cpu/perf_event_intel.c          |   3 +
 arch/x86/kernel/ptrace.c                        |  11 +-
 arch/x86/kvm/x86.c                              |   2 +-
 arch/x86/mm/fault.c                             |  43 +++---
 arch/xtensa/include/uapi/asm/unistd.h           |   3 +-
 arch/xtensa/mm/fault.c                          |   2 +
 drivers/ata/ahci.c                              |  19 ++-
 drivers/block/sunvdc.c                          | 176 +++++++++++++++++------
 drivers/firewire/core-cdev.c                    |   3 +-
 drivers/gpu/drm/radeon/evergreen.c              |   1 +
 drivers/input/mouse/alps.c                      |  11 +-
 drivers/md/dm-raid.c                            |  11 +-
 drivers/md/persistent-data/dm-btree-internal.h  |   6 +
 drivers/md/persistent-data/dm-btree-spine.c     |   2 +-
 drivers/md/persistent-data/dm-btree.c           |  24 ++--
 drivers/media/usb/ttusb-dec/ttusbdecfe.c        |   3 +
 drivers/misc/mei/bus.c                          |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c      |  61 +++++---
 drivers/net/ethernet/sun/sunvnet.c              |   4 +-
 drivers/net/macvtap.c                           |   2 +
 drivers/net/wireless/iwlwifi/iwl-trans.h        |   2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |  35 ++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |   1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c           |   9 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c          |   1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c       |  17 ++-
 drivers/platform/x86/dell-wmi.c                 |  12 +-
 drivers/scsi/hpsa.c                             |   4 +-
 drivers/scsi/scsi_error.c                       |   4 +-
 fs/ioprio.c                                     |  14 +-
 fs/nfs/delegation.c                             |  25 +++-
 fs/nfs/delegation.h                             |   1 +
 fs/nfs/direct.c                                 |   1 +
 fs/nfs/inode.c                                  |   2 +-
 fs/nfs/nfs4proc.c                               |  26 +++-
 include/linux/clocksource.h                     |   2 +-
 include/linux/kgdb.h                            |   2 +-
 include/linux/memcontrol.h                      |  37 +++++
 include/linux/mm.h                              |   1 +
 include/linux/nfs_xdr.h                         |  11 ++
 include/linux/sched.h                           |   6 +
 include/net/sctp/sctp.h                         |   5 +
 include/net/sctp/sm.h                           |   6 +-
 include/uapi/linux/netfilter/xt_bpf.h           |   2 +
 ipc/ipc_sysctl.c                                |   3 +-
 kernel/audit_tree.c                             |   1 +
 kernel/events/core.c                            |  22 ++-
 mm/memcontrol.c                                 | 182 ++++++++++++++----------
 mm/memory.c                                     |  49 +++++--
 mm/oom_kill.c                                   |   7 +-
 net/bridge/br_private.h                         |  10 ++
 net/bridge/br_stp_bpdu.c                        |   2 +-
 net/ceph/crypto.c                               | 169 +++++++++++++++++-----
 net/ipv6/ip6_gre.c                              |   7 +-
 net/ipv6/ip6_tunnel.c                           |  10 +-
 net/mac80211/rx.c                               |  14 +-
 net/netfilter/nf_nat_core.c                     |  35 ++++-
 net/netfilter/nfnetlink_log.c                   |  31 ++--
 net/sctp/associola.c                            |   2 +
 net/sctp/auth.c                                 |   2 -
 net/sctp/inqueue.c                              |  33 +----
 net/sctp/sm_make_chunk.c                        | 102 +++++++------
 net/sctp/sm_statefuns.c                         |  21 +--
 sound/usb/mixer_quirks.c                        |   6 +
 107 files changed, 1197 insertions(+), 595 deletions(-)


