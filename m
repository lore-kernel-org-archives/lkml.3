Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941AbaKSWAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:00:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbaKSVEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 000/122] 3.14.25-stable review
Date: Wed, 19 Nov 2014 12:50:50 -0800
Message-Id: <20141119205208.812884198@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.25 release.
There are 122 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Nov 21 20:51:52 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.25-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.25-rc1

Vlastimil Babka <vbabka@suse.cz>
    mm/page_alloc: prevent MIGRATE_RESERVE pages from being misplaced

Mel Gorman <mgorman@suse.de>
    mm: vmscan: use proportional scanning during direct reclaim and full scan at DEF_PRIORITY

Tim Chen <tim.c.chen@linux.intel.com>
    fs/superblock: avoid locking counting inodes and dentries before reclaiming them

Dave Chinner <david@fromorbit.com>
    fs/superblock: unregister sb shrinker before ->kill_sb()

Hugh Dickins <hughd@google.com>
    mm: fix direct reclaim writeback regression

Shaohua Li <shli@kernel.org>
    x86/mm: In the PTE swapout page reclaim case clear the accessed bit instead of flushing the TLB

Vlastimil Babka <vbabka@suse.cz>
    mm, compaction: properly signal and act upon lock and need_sched() contention

Vlastimil Babka <vbabka@suse.cz>
    mm/compaction: avoid rescanning pageblocks in isolate_freepages

Vlastimil Babka <vbabka@suse.cz>
    mm/compaction: do not count migratepages when unnecessary

David Rientjes <rientjes@google.com>
    mm, compaction: terminate async compaction when rescheduling

David Rientjes <rientjes@google.com>
    mm, compaction: embed migration mode in compact_control

David Rientjes <rientjes@google.com>
    mm, compaction: add per-zone migration pfn cache for async compaction

David Rientjes <rientjes@google.com>
    mm, compaction: return failed migration target pages back to freelist

David Rientjes <rientjes@google.com>
    mm, migration: add destination page freeing callback

Vlastimil Babka <vbabka@suse.cz>
    mm/compaction: cleanup isolate_freepages()

Heesub Shin <heesub.shin@samsung.com>
    mm/compaction: clean up unused code lines

Fabian Frederick <fabf@skynet.be>
    mm/readahead.c: inline ra_submit

Al Viro <viro@zeniv.linux.org.uk>
    callers of iov_copy_from_user_atomic() don't need pagecache_disable()

Sasha Levin <sasha.levin@oracle.com>
    mm: remove read_cache_page_async()

Johannes Weiner <hannes@cmpxchg.org>
    mm: madvise: fix MADV_WILLNEED on shmem swapouts

Johannes Weiner <hannes@cmpxchg.org>
    mm + fs: prepare for non-page entries in page cache radix trees

Johannes Weiner <hannes@cmpxchg.org>
    mm: filemap: move radix tree hole searching here

Johannes Weiner <hannes@cmpxchg.org>
    mm: shmem: save one radix tree lookup when truncating swapped pages

Johannes Weiner <hannes@cmpxchg.org>
    lib: radix-tree: add radix_tree_delete_item()

Quentin Casasnovas <quentin.casasnovas@oracle.com>
    regmap: fix kernel hang on regmap_bulk_write with zero val_count.

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: configure the LTR

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix panic on duplicate ASCONF chunks

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix remote memory pressure from excessive queueing

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Don't report guest userspace emulation error to userspace

Vince Weaver <vincent.weaver@maine.edu>
    perf/x86/intel: Use proper dTLB-load-misses event on IvyBridge

Pawel Moll <pawel.moll@arm.com>
    perf: Handle compat ioctl

Pali Rohár <pali.rohar@gmail.com>
    dell-wmi: Fix access out of memory

Pranith Kumar <bobby.prani@gmail.com>
    rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads

Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    rcu: Make callers awaken grace-period kthread

Steven Whitehouse <swhiteho@redhat.com>
    GFS2: Fix address space from page function

Ben Dooks <ben.dooks@codethink.co.uk>
    ARM: probes: fix instruction fetch order with <asm/opcodes.h>

Pablo Neira <pablo@netfilter.org>
    netfilter: xt_bpf: add mising opaque struct sk_filter definition

Arturo Borrero <arturo.borrero.glez@gmail.com>
    netfilter: nft_compat: fix wrong target lookup in nft_target_select_ops()

Houcheng Lin <houcheng@gmail.com>
    netfilter: nf_log: release skbuff on nlmsg put failure

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: fix maximum packet length logged to userspace

Florian Westphal <fw@strlen.de>
    netfilter: nf_log: account for size of NLMSG_DONE attribute

Dan Carpenter <dan.carpenter@oracle.com>
    netfilter: ipset: off by one in ip_set_nfnl_get_byindex()

Andrey Vagin <avagin@openvz.org>
    ipc: always handle a new value of auto_msgmni

Devesh Sharma <devesh.sharma@emulex.com>
    IB/core: Clear AH attr variable to prevent garbage data

Bjorn Helgaas <bhelgaas@google.com>
    clocksource: Remove "weak" from clocksource_default_clock() declaration

Bjorn Helgaas <bhelgaas@google.com>
    kgdb: Remove "weak" from kgdb_arch_pc() declaration

Bjorn Helgaas <bhelgaas@google.com>
    vmcore: Remove "weak" from function declarations

Bjorn Helgaas <bhelgaas@google.com>
    memory-hotplug: Remove "weak" from memory_block_size_bytes() declaration

Dan Carpenter <dan.carpenter@oracle.com>
    media: ttusb-dec: buffer overflow in ioctl

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4.1: nfs41_clear_delegation_stateid shouldn't trust NFS_DELEGATED_STATE

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix races between nfs_remove_bad_delegation() and delegation return

Jan Kara <jack@suse.cz>
    nfs: Fix use of uninitialized variable in nfs_getattr()

Trond Myklebust <trond.myklebust@primarydata.com>
    NFS: Don't try to reclaim delegation open state if recovery failed

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Ensure that we remove NFSv4.0 delegations when state has expired

NeilBrown <neilb@suse.de>
    md: Always set RECOVERY_NEEDED when clearing RECOVERY_FROZEN

Junjie Mao <eternal.n08@gmail.com>
    x86, kaslr: Prevent .bss from overlaping initrd

Borislav Petkov <bp@suse.de>
    x86, microcode, AMD: Fix ucode patch stashing on 32-bit

Borislav Petkov <bp@suse.de>
    x86, microcode, AMD: Fix early ucode loading on 32-bit

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    power: bq2415x_charger: Fix memory leak on DTS parsing error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    power: bq2415x_charger: Properly handle ENODEV from power_supply_get_by_phandle

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    power: charger-manager: Fix accessing invalidated power supply after charger unbind

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    power: charger-manager: Fix accessing invalidated power supply after fuel gauge unbind

Pali Rohár <pali.rohar@gmail.com>
    Input: alps - ignore bad data on Dell Latitudes E6440 and E7440

Pali Rohár <pali.rohar@gmail.com>
    Input: alps - allow up to 2 invalid packets without resetting device

Pali Rohár <pali.rohar@gmail.com>
    Input: alps - ignore potential bare packets when device is out of sync

Takashi Iwai <tiwai@suse.de>
    Input: synaptics - add min/max quirk for Lenovo T440s

Heinz Mauelshagen <heinzm@redhat.com>
    dm raid: ensure superblock's size matches device's logical block size

Joe Thornber <ejt@redhat.com>
    dm btree: fix a recursion depth bug in btree walking code

Mikulas Patocka <mpatocka@redhat.com>
    dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks

Jan Kara <jack@suse.cz>
    block: Fix computation of merged request priority

Helge Deller <deller@gmx.de>
    parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop syscalls

Christoph Hellwig <hch@lst.de>
    scsi: only re-lock door after EH on devices that were reset

William Cohen <wcohen@redhat.com>
    Correct the race condition in aarch64_insn_patch_text_sync()

Peng Tao <tao.peng@primarydata.com>
    nfs: fix pnfs direct write memory leak

Simon Horman <horms+renesas@verge.net.au>
    ata: sata_rcar: Disable DIPM mode for r8a7790 ES1

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: cdev: prevent kernel stack leaking into ioctl arguments

Kyle McMartin <kyle@redhat.com>
    arm64: __clear_user: handle exceptions on strb

Joe Thornber <ejt@redhat.com>
    dm thin: grab a virtual cell before looking up the mapping

Roger Quadros <rogerq@ti.com>
    pinctrl: dra: dt-bindings: Fix output pull up/down

Will Deacon <will.deacon@arm.com>
    ARM: 8191/1: decompressor: ensure I-side picks up relocated code

Nathan Lynch <nathan_lynch@mentor.com>
    ARM: 8198/1: make kuser helpers depend on MMU

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add missing crtc unlock when setting up the MC

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: make sure mode init is complete in bandwidth_update

Jammy Zhou <Jammy.Zhou@amd.com>
    drm/radeon: set correct CE ram size for CIK

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix use-after-free in defragmentation

Luciano Coelho <luciano.coelho@intel.com>
    mac80211: schedule the actual switch of the station before CSA count 0

Luciano Coelho <luciano.coelho@intel.com>
    mac80211: use secondary channel offset IE also beacons during CSA

Johannes Berg <johannes@sipsolutions.net>
    mac80211: properly flush delayed scan work on interface removal

Junjie Mao <eternal.n08@gmail.com>
    mac80211_hwsim: release driver when ieee80211_register_hw fails

Herbert Xu <herbert@gondor.apana.org.au>
    macvtap: Fix csum_start when VLAN tags are present

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

Richard Guy Briggs <rgb@redhat.com>
    audit: AUDIT_FEATURE_CHANGE message format missing delimiting space

Richard Guy Briggs <rgb@redhat.com>
    audit: correct AUDIT_GET_FEATURE return message type

Andy Lutomirski <luto@amacapital.net>
    x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit

Herbert Xu <herbert@gondor.apana.org.au>
    tun: Fix csum_start with VLAN acceleration

Greg Kurz <gkurz@linux.vnet.ibm.com>
    hwrng: pseries - port to new read API and fix stack corruption

Cristian Stoica <cristian.stoica@freescale.com>
    crypto: caam - remove duplicated sg copy functions

Cristian Stoica <cristian.stoica@freescale.com>
    crypto: caam - fix missing dma unmap on error path

Weijie Yang <weijie.yang@samsung.com>
    zram: avoid kunmap_atomic() of a NULL pointer

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

Enric Balletbo i Serra <eballetbo@iseebcn.com>
    smsc911x: power-up phydev before doing a software reset.

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix memory leak in auth key management

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix NULL pointer dereference in af->from_addr_param on malformed packet

Marcelo Leitner <mleitner@redhat.com>
    vxlan: Do not reuse sockets for a different address family

Steffen Klassert <steffen.klassert@secunet.com>
    gre6: Move the setting of dev->iflink into the ndo_init functions.

Steffen Klassert <steffen.klassert@secunet.com>
    sit: Use ipip6_tunnel_init as the ndo_init function.

Steffen Klassert <steffen.klassert@secunet.com>
    vti6: Use vti6_dev_init as the ndo_init function.

Steffen Klassert <steffen.klassert@secunet.com>
    ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drivers/net: Disable UFO through virtio"


-------------

Diffstat:

 .../devicetree/bindings/ata/sata_rcar.txt          |   3 +-
 Makefile                                           |   4 +-
 arch/arm/boot/compressed/head.S                    |  20 +-
 arch/arm/kernel/kprobes-common.c                   |  19 +-
 arch/arm/kernel/kprobes-thumb.c                    |  21 +-
 arch/arm/kernel/kprobes.c                          |   9 +-
 arch/arm/mm/Kconfig                                |   1 +
 arch/arm64/kernel/insn.c                           |   5 +-
 arch/arm64/lib/clear_user.S                        |   2 +-
 arch/parisc/include/uapi/asm/shmbuf.h              |  25 +-
 arch/parisc/kernel/syscall_table.S                 |   8 +-
 arch/sparc/include/asm/atomic_32.h                 |   2 +-
 arch/sparc/include/asm/cmpxchg_32.h                |  12 +-
 arch/sparc/include/asm/vio.h                       |  14 +-
 arch/sparc/kernel/pci_schizo.c                     |   6 +-
 arch/sparc/kernel/smp_64.c                         |   4 +
 arch/sparc/lib/atomic32.c                          |  27 ++
 arch/x86/boot/compressed/Makefile                  |   4 +-
 arch/x86/boot/compressed/head_32.S                 |   5 +-
 arch/x86/boot/compressed/head_64.S                 |   5 +-
 arch/x86/boot/compressed/misc.c                    |  13 +-
 arch/x86/boot/compressed/mkpiggy.c                 |   9 +-
 arch/x86/kernel/cpu/microcode/amd_early.c          |  33 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   3 +
 arch/x86/kernel/ptrace.c                           |  11 +-
 arch/x86/kvm/x86.c                                 |   2 +-
 arch/x86/mm/pgtable.c                              |  21 +-
 arch/x86/tools/calc_run_size.pl                    |  30 ++
 arch/xtensa/include/uapi/asm/unistd.h              |   3 +-
 drivers/ata/ahci.c                                 |  19 +-
 drivers/ata/sata_rcar.c                            |  10 +
 drivers/base/regmap/regmap.c                       |   6 +-
 drivers/block/sunvdc.c                             | 176 ++++++++---
 drivers/block/zram/zram_drv.c                      |   3 +-
 drivers/char/hw_random/pseries-rng.c               |  11 +-
 drivers/crypto/caam/caamhash.c                     |  22 +-
 drivers/crypto/caam/key_gen.c                      |  29 +-
 drivers/crypto/caam/sg_sw_sec4.h                   |  54 ----
 drivers/firewire/core-cdev.c                       |   3 +-
 drivers/gpu/drm/radeon/cik.c                       |   7 +-
 drivers/gpu/drm/radeon/evergreen.c                 |   4 +
 drivers/gpu/drm/radeon/r100.c                      |   3 +
 drivers/gpu/drm/radeon/rs600.c                     |   3 +
 drivers/gpu/drm/radeon/rs690.c                     |   3 +
 drivers/gpu/drm/radeon/rv515.c                     |   3 +
 drivers/gpu/drm/radeon/si.c                        |   3 +
 drivers/infiniband/core/uverbs_cmd.c               |   2 +
 drivers/input/mouse/alps.c                         |  28 +-
 drivers/input/mouse/synaptics.c                    |   5 +-
 drivers/md/dm-bufio.c                              |  12 +-
 drivers/md/dm-raid.c                               |  11 +-
 drivers/md/dm-thin.c                               |  16 +-
 drivers/md/md.c                                    |   4 +
 drivers/md/persistent-data/dm-btree-internal.h     |   6 +
 drivers/md/persistent-data/dm-btree-spine.c        |   2 +-
 drivers/md/persistent-data/dm-btree.c              |  24 +-
 drivers/media/usb/ttusb-dec/ttusbdecfe.c           |   3 +
 drivers/net/ethernet/smsc/smsc911x.c               |  46 +++
 drivers/net/ethernet/sun/sunvnet.c                 |   4 +-
 drivers/net/macvtap.c                              |  15 +-
 drivers/net/tun.c                                  |  35 +--
 drivers/net/virtio_net.c                           |  24 +-
 drivers/net/vxlan.c                                |  28 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h           |   2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h    |  35 ++-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h          |   1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c              |   9 +
 drivers/net/wireless/iwlwifi/mvm/ops.c             |   1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  16 +-
 drivers/net/wireless/mac80211_hwsim.c              |   4 +-
 drivers/platform/x86/dell-wmi.c                    |  12 +-
 drivers/power/bq2415x_charger.c                    |  23 +-
 drivers/power/charger-manager.c                    | 163 ++++++----
 drivers/scsi/scsi_error.c                          |   4 +-
 fs/btrfs/compression.c                             |   2 +-
 fs/btrfs/file.c                                    |   5 -
 fs/cramfs/inode.c                                  |   3 +-
 fs/fuse/file.c                                     |   2 -
 fs/gfs2/meta_io.c                                  |   5 +
 fs/gfs2/meta_io.h                                  |   3 +
 fs/gfs2/ops_fstype.c                               |   2 +-
 fs/ioprio.c                                        |  14 +-
 fs/jffs2/fs.c                                      |   2 +-
 fs/nfs/blocklayout/blocklayout.c                   |   2 +-
 fs/nfs/delegation.c                                |  25 +-
 fs/nfs/delegation.h                                |   1 +
 fs/nfs/direct.c                                    |   1 +
 fs/nfs/inode.c                                     |   2 +-
 fs/nfs/nfs4proc.c                                  |  68 ++--
 fs/super.c                                         |  16 +-
 include/dt-bindings/pinctrl/dra.h                  |   4 +-
 include/linux/clocksource.h                        |   2 +-
 include/linux/compaction.h                         |   4 +-
 include/linux/crash_dump.h                         |  15 +-
 include/linux/kgdb.h                               |   2 +-
 include/linux/memory.h                             |   2 +-
 include/linux/migrate.h                            |  11 +-
 include/linux/mm.h                                 |  11 +-
 include/linux/mmzone.h                             |   5 +-
 include/linux/nfs_xdr.h                            |  11 +
 include/linux/pagemap.h                            |  30 +-
 include/linux/pagevec.h                            |   5 +
 include/linux/power/charger-manager.h              |   3 -
 include/linux/radix-tree.h                         |   5 +-
 include/linux/shmem_fs.h                           |   1 +
 include/net/sctp/sctp.h                            |   5 +
 include/net/sctp/sm.h                              |   6 +-
 include/trace/events/compaction.h                  |  25 +-
 include/uapi/linux/netfilter/xt_bpf.h              |   2 +
 ipc/ipc_sysctl.c                                   |   3 +-
 kernel/audit.c                                     |   4 +-
 kernel/audit_tree.c                                |   1 +
 kernel/events/core.c                               |  23 +-
 kernel/rcu/tree.c                                  |  22 +-
 lib/radix-tree.c                                   | 106 ++-----
 mm/compaction.c                                    | 249 ++++++++-------
 mm/filemap.c                                       | 341 +++++++++++++++++----
 mm/internal.h                                      |  22 +-
 mm/madvise.c                                       |   2 +-
 mm/memory-failure.c                                |   4 +-
 mm/memory_hotplug.c                                |   2 +-
 mm/mempolicy.c                                     |   4 +-
 mm/migrate.c                                       |  56 +++-
 mm/mincore.c                                       |  20 +-
 mm/page_alloc.c                                    |  62 ++--
 mm/readahead.c                                     |  27 +-
 mm/shmem.c                                         | 122 ++------
 mm/swap.c                                          |  51 +++
 mm/truncate.c                                      |  74 ++++-
 mm/vmscan.c                                        |  36 ++-
 net/ceph/crypto.c                                  | 169 +++++++---
 net/ipv6/ip6_gre.c                                 |   5 +-
 net/ipv6/ip6_tunnel.c                              |  10 +-
 net/ipv6/ip6_vti.c                                 |  11 +-
 net/ipv6/sit.c                                     |  15 +-
 net/mac80211/ibss.c                                |   2 +-
 net/mac80211/ieee80211_i.h                         |   3 +-
 net/mac80211/iface.c                               |   7 +-
 net/mac80211/mesh.c                                |   2 +-
 net/mac80211/mlme.c                                |   5 +-
 net/mac80211/rx.c                                  |  14 +-
 net/mac80211/spectmgmt.c                           |  18 +-
 net/netfilter/ipset/ip_set_core.c                  |   2 +-
 net/netfilter/nfnetlink_log.c                      |  31 +-
 net/netfilter/nft_compat.c                         |   2 +-
 net/sctp/associola.c                               |   2 +
 net/sctp/auth.c                                    |   2 -
 net/sctp/inqueue.c                                 |  33 +-
 net/sctp/sm_make_chunk.c                           | 102 +++---
 net/sctp/sm_statefuns.c                            |  21 +-
 sound/usb/mixer_quirks.c                           |   6 +
 151 files changed, 2038 insertions(+), 1172 deletions(-)


