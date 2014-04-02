Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbaDBUMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:12:08 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42795 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932496AbaDBUME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:12:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 00/40] 3.12.17-stable review
Date: Wed,  2 Apr 2014 22:12:01 +0200
Message-Id: <cover.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.17 release.
There are 40 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Apr  4 20:06:31 2014
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.17-rc1.xz
and the diffstat can be found below.

thanks,
js

===============


Al Viro (1):
  make prepend_name() work correctly when called with negative *buflen

Alexander Aring (1):
  nfs: fix dead code of ipv6_addr_scope

Andy Adamson (2):
  SUNRPC: do not fail gss proc NULL calls with EACCES
  NFSv4.1 free slot before resending I/O to MDS

Artem Fetishev (1):
  x86: fix boot on uniprocessor systems

Benjamin Tissoires (1):
  Input: synaptics - add manual min/max quirk

Christoph Hellwig (3):
  nfs: fix size updates for aio writes
  nfs: defer inode_dio_done call until size update is done
  nfs: increment i_dio_count for reads, too

Daniel Borkmann (1):
  netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages

Daniel Vetter (1):
  drm/i915: Undo gtt scratch pte unmapping again

David Howells (2):
  X.509: struct x509_certificate needs struct tm declaring
  FS-Cache: Handle removal of unadded object to the fscache_object_list
    rb tree

David Rientjes (1):
  mm: close PageTail race

David Vrabel (1):
  Revert "xen: properly account for _PAGE_NUMA during xen pte
    translations"

Dmitry Torokhov (1):
  Input: mousedev - fix race when creating mixed device

Dongmao Zhang (1):
  dlm: set zero linger time on sctp socket

Hans de Goede (2):
  Input: synaptics - add manual min/max quirk for ThinkPad X240
  Input: cypress_ps2 - don't report as a button pads

J. Bruce Fields (1):
  nfs: use IS_ROOT not DCACHE_DISCONNECTED

James Ralston (1):
  i2c: i801: Add Device IDs for Intel Wildcat Point-LP PCH

Jeff Layton (2):
  NFS: fix the handling of NFS_INO_INVALID_DATA flag in
    nfs_revalidate_mapping
  nfs: add memory barriers around NFS_INO_INVALID_DATA and
    NFS_INO_INVALIDATING

Jeff Mahoney (1):
  drm/nouveau: make vga_switcheroo code depend on VGA_SWITCHEROO

Len Brown (1):
  intel_idle: Support Intel Atom Processor C2000 Product Family

Martin Schwidefsky (1):
  s390/time,vdso: fix clock_gettime for CLOCK_MONOTONIC

Michal Kubecek (1):
  ipvs: fix AF assignment in ip_vs_conn_new()

Olaf Hering (1):
  fbmem: really support wildcard video=options for all fbdev drivers

Oliver Neukum (1):
  crypto: sha256_ssse3 - also test for BMI2

Ping Cheng (1):
  Input: wacom - add support for three new Intuos Pro devices

Scott Wood (1):
  i2c: cpm: Fix build by adding of_address.h and of_irq.h

Takashi Iwai (1):
  ALSA: hda - Fix inconsistent Mic mute LED

Theodore Ts'o (1):
  ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Thomas Petazzoni (2):
  net: mvneta: rename MVNETA_GMAC2_PSC_ENABLE to MVNETA_GMAC2_PCS_ENABLE
  net: mvneta: fix usage as a module on RGMII configurations

Toshi Kani (1):
  arch/x86/mm/srat: Skip NUMA_NO_NODE while parsing SLIT

Trond Myklebust (2):
  NFSv4.1: Prevent a 3-way deadlock between layoutreturn, open and state
    recovery
  NFS: Fix races in nfs_revalidate_mapping

Wei Liu (1):
  xen/balloon: flush persistent kmaps in correct position

Weston Andros Adamson (1):
  pnfs: fix BUG in filelayout_recover_commit_reqs

 Documentation/i2c/busses/i2c-i801       |  1 +
 arch/s390/kernel/vdso32/clock_gettime.S |  9 +---
 arch/s390/kernel/vdso64/clock_gettime.S |  6 +--
 arch/x86/crypto/sha256_ssse3_glue.c     |  2 +-
 arch/x86/include/asm/pgtable.h          | 14 +------
 arch/x86/include/asm/topology.h         |  3 +-
 arch/x86/mm/srat.c                      | 16 ++++++--
 arch/x86/xen/mmu.c                      |  4 +-
 crypto/asymmetric_keys/x509_parser.h    |  1 +
 drivers/block/aoe/aoecmd.c              |  4 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c     |  2 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c  |  6 +++
 drivers/i2c/busses/Kconfig              |  1 +
 drivers/i2c/busses/i2c-cpm.c            |  2 +
 drivers/i2c/busses/i2c-i801.c           |  3 ++
 drivers/idle/intel_idle.c               | 24 ++++++++++-
 drivers/input/mouse/cypress_ps2.c       |  1 -
 drivers/input/mouse/synaptics.c         | 55 +++++++++++++++++++++++++
 drivers/input/mousedev.c                | 73 +++++++++++++++++++--------------
 drivers/input/tablet/wacom_sys.c        | 10 ++++-
 drivers/input/tablet/wacom_wac.c        | 61 ++++++++++++++++++++-------
 drivers/input/tablet/wacom_wac.h        |  3 ++
 drivers/net/ethernet/marvell/mvneta.c   | 43 ++++---------------
 drivers/vfio/vfio_iommu_type1.c         |  4 +-
 drivers/video/fbmem.c                   |  3 ++
 drivers/xen/balloon.c                   | 24 ++++++++---
 fs/dcache.c                             |  4 +-
 fs/dlm/lowcomms.c                       |  8 ++++
 fs/ext4/inode.c                         | 15 ++++---
 fs/fscache/object-list.c                |  5 +++
 fs/fscache/object.c                     |  3 ++
 fs/nfs/dir.c                            | 21 ++++++++--
 fs/nfs/direct.c                         | 38 +++++++++++------
 fs/nfs/inode.c                          | 51 +++++++++++++++++++----
 fs/nfs/nfs4_fs.h                        |  1 +
 fs/nfs/nfs4filelayout.c                 | 18 +++++---
 fs/nfs/nfs4filelayoutdev.c              |  2 +-
 fs/nfs/nfs4proc.c                       | 12 +++++-
 fs/nfs/nfstrace.h                       |  1 +
 fs/nfs/write.c                          |  7 +++-
 fs/proc/page.c                          |  2 +-
 include/linux/bitops.h                  | 15 +++++++
 include/linux/huge_mm.h                 | 18 --------
 include/linux/mm.h                      | 14 ++++++-
 include/linux/nfs_fs.h                  |  1 +
 mm/ksm.c                                |  2 +-
 mm/memory-failure.c                     |  2 +-
 mm/page_alloc.c                         |  4 +-
 mm/swap.c                               |  4 +-
 net/netfilter/ipvs/ip_vs_conn.c         |  8 ++--
 net/netfilter/nf_conntrack_proto_dccp.c |  6 +--
 net/sunrpc/auth_gss/auth_gss.c          |  2 +-
 sound/pci/hda/hda_generic.c             |  8 ++--
 sound/pci/hda/hda_generic.h             |  1 +
 sound/pci/hda/patch_conexant.c          |  3 +-
 sound/pci/hda/patch_realtek.c           |  9 ++--
 sound/pci/hda/patch_sigmatel.c          | 27 +++++++-----
 57 files changed, 469 insertions(+), 218 deletions(-)

-- 
1.9.1

