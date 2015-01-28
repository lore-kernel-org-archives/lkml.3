Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972AbbA1B6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:58:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760002AbbA1BiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/77] 3.14.31-stable review
Date: Tue, 27 Jan 2015 17:26:38 -0800
Message-Id: <20150128012745.971137091@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.31 release.
There are 77 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan 30 01:27:34 UTC 2015.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.31-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.31-rc1

NeilBrown <neilb@suse.de>
    md/raid5: fetch_block must fetch all the blocks handle_stripe_dirtying wants.

Michal Hocko <mhocko@suse.cz>
    mm: get rid of radix tree gfp mask for pagecache_get_page

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: reduce cost of the fair zone allocation policy

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: abort fair zone allocation policy when remotes nodes are encountered

Mel Gorman <mgorman@suse.de>
    mm: vmscan: only update per-cpu thresholds for online CPU

Mel Gorman <mgorman@suse.de>
    mm: move zone->pages_scanned into a vmstat counter

Mel Gorman <mgorman@suse.de>
    mm: rearrange zone fields into read-only, page alloc, statistics and page reclaim lines

Mel Gorman <mgorman@suse.de>
    mm: pagemap: avoid unnecessary overhead when tracepoints are deactivated

Jerome Marchand <jmarchan@redhat.com>
    memcg, vmscan: Fix forced scan of anonymous pages

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    vmalloc: use rcu list iterator to reduce vmap_area_lock contention

Jerome Marchand <jmarchan@redhat.com>
    mm: make copy_pte_range static again

David Rientjes <rientjes@google.com>
    mm, thp: only collapse hugepages to nodes with affinity for zone_reclaim_mode

Hugh Dickins <hughd@google.com>
    mm/memory.c: use entry = ACCESS_ONCE(*pte) in handle_pte_fault()

Hugh Dickins <hughd@google.com>
    shmem: fix init_page_accessed use to stop !PageLRU bug

Mel Gorman <mgorman@suse.de>
    mm: avoid unnecessary atomic operations during end_page_writeback()

Mel Gorman <mgorman@suse.de>
    mm: non-atomically mark page accessed during page cache allocation where possible

Mel Gorman <mgorman@suse.de>
    fs: buffer: do not use unnecessary atomic operations when discarding buffers

Mel Gorman <mgorman@suse.de>
    mm: do not use unnecessary atomic operations when adding pages to the LRU

Mel Gorman <mgorman@suse.de>
    mm: do not use atomic operations when releasing pages

Mel Gorman <mgorman@suse.de>
    mm: shmem: avoid atomic operation during shmem_getpage_gfp

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: lookup pageblock migratetype with IRQs enabled during free

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: convert hot/cold parameter and immediate callers to bool

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: reduce number of times page_to_pfn is called

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: use unsigned int for order in more places

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: take the ALLOC_NO_WATERMARK check out of the fast path

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: only check the alloc flags and gfp_mask for dirty once

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: only check the zone id check if pages are buddies

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: calculate classzone_idx once from the zonelist ref

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: use jump labels to avoid checking number_of_cpusets

Mel Gorman <mgorman@suse.de>
    include/linux/jump_label.h: expose the reference count

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: do not treat a zone that cannot be used for dirty pages as "full"

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: do not update zlc unless the zlc is active

Jianyu Zhan <nasa4836@gmail.com>
    mm/swap.c: clean up *lru_cache_add* functions

Sjoerd Simons <sjoerd.simons@collabora.co.uk>
    mmc: sdhci: Don't signal the sdio irq if it's not setup

Francesco Ruggeri <fruggeri@aristanetworks.com>
    tty: Fix pty master poll() after slave closes v2

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: evdev - fix EVIOCG{type} ioctl

Vineet Gupta <vgupta@synopsys.com>
    ARC: Fix build breakage for !CONFIG_ARC_DW2_UNWIND

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    ARC: Delete stale barrier.h

Mathias Krause <minipli@googlemail.com>
    crypto: add missing crypto module aliases

Kees Cook <keescook@chromium.org>
    crypto: include crypto- module prefix in template

Kees Cook <keescook@chromium.org>
    crypto: prefix module autoloading with "crypto-"

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: merge_bvec_fn: properly remap bvm->bi_bdev

David Vrabel <david.vrabel@citrix.com>
    Revert "swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single"

Dan Carpenter <dan.carpenter@oracle.com>
    ipvs: uninitialized data with IP_VS_IPV6

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink: validate nfnetlink header from batch

Sasha Levin <sasha.levin@oracle.com>
    KEYS: close race between key lookup and freeing

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    sata_dwc_460ex: fix resource leak on error path

Andy Lutomirski <luto@amacapital.net>
    x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync_regs

Bryan O'Donoghue <pure.logic@nexus-software.ie>
    x86/apic: Re-enable PCI_MSI support for non-SMP X86_32

Andy Lutomirski <luto@amacapital.net>
    x86, tls: Interpret an all-zero struct user_desc as "no segment"

Andy Lutomirski <luto@amacapital.net>
    x86, tls, ldt: Stop checking lm in LDT_empty

Nadav Amit <nadav.amit@gmail.com>
    KVM: x86: Fix of previously incomplete fix for CVE-2014-8480

Kees Cook <keescook@chromium.org>
    x86, boot: Skip relocs when load address unchanged

Alexandre Demers <alexandre.f.demers@gmail.com>
    x86/tsc: Change Fast TSC calibration failed from error to info

K. Y. Srinivasan <kys@microsoft.com>
    x86, hyperv: Mark the Hyper-V clocksource as being continuous

Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
    clocksource: exynos_mct: Fix bitmask regression for exynos4_mct_write

Oliver Hartkopp <socketcan@hartkopp.net>
    can: dev: fix crtlmode_supported check

Al Viro <viro@zeniv.linux.org.uk>
    fix deadlock in cifs_ioctl_clone()

Andrew Lunn <andrew@lunn.ch>
    bus: mvebu-mbus: fix support of MBus window 13

Fabio Estevam <fabio.estevam@freescale.com>
    ARM: dts: imx25: Fix PWM "per" clocks

Sasha Levin <sasha.levin@oracle.com>
    time: adjtimex: Validate the ADJ_FREQUENCY values

Sasha Levin <sasha.levin@oracle.com>
    time: settimeofday: Validate the values of tv from user

Joe Thornber <ejt@redhat.com>
    dm cache: fix problematic dual use of a single migration count variable

Joe Thornber <ejt@redhat.com>
    dm cache: share cache-metadata object across inactive and active DM tables

Brian King <brking@linux.vnet.ibm.com>
    ipr: wait for aborted command responses

Alex Williamson <alex.williamson@redhat.com>
    PCI: Mark Atheros AR93xx to avoid bus reset

Alex Williamson <alex.williamson@redhat.com>
    PCI: Add flag for devices where we can't use bus reset

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: use rv515_ring_start on r5xx

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add si dpm quirk list

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add a dpm quirk list

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix mutex->owner inspection race under DEBUG_MUTEXES

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    scripts/recordmcount.pl: There is no -m32 gcc option on Super-H anymore

Jason Lee Cragg <jcragg@gmail.com>
    ALSA: usb-audio: Add mic volume fix quirk for Logitech Webcam C210

David Jeffery <djeffery@redhat.com>
    libata: prevent HSM state change race between ISR and PIO

Jim Lin <jilin@nvidia.com>
    pinctrl: Fix two deadlocks

Johan Hovold <johan@kernel.org>
    gpio: sysfs: fix gpio device-attribute leak

Johan Hovold <johan@kernel.org>
    gpio: sysfs: fix gpio-chip device-attribute leak


-------------

Diffstat:

 Makefile                                   |   4 +-
 arch/arc/include/asm/barrier.h             |  37 ----
 arch/arc/kernel/ctx_sw_asm.S               |   2 +-
 arch/arm/boot/dts/imx25.dtsi               |   8 +-
 arch/arm/crypto/aes_glue.c                 |   4 +-
 arch/arm/crypto/sha1_glue.c                |   2 +-
 arch/powerpc/crypto/sha1.c                 |   3 +-
 arch/s390/crypto/aes_s390.c                |   2 +-
 arch/s390/crypto/des_s390.c                |   4 +-
 arch/s390/crypto/ghash_s390.c              |   2 +-
 arch/s390/crypto/sha1_s390.c               |   2 +-
 arch/s390/crypto/sha256_s390.c             |   4 +-
 arch/s390/crypto/sha512_s390.c             |   4 +-
 arch/sparc/crypto/aes_glue.c               |   2 +-
 arch/sparc/crypto/camellia_glue.c          |   2 +-
 arch/sparc/crypto/crc32c_glue.c            |   2 +-
 arch/sparc/crypto/des_glue.c               |   2 +-
 arch/sparc/crypto/md5_glue.c               |   2 +-
 arch/sparc/crypto/sha1_glue.c              |   2 +-
 arch/sparc/crypto/sha256_glue.c            |   4 +-
 arch/sparc/crypto/sha512_glue.c            |   4 +-
 arch/tile/mm/homecache.c                   |   2 +-
 arch/x86/Kconfig                           |   6 +-
 arch/x86/boot/compressed/misc.c            |   9 +-
 arch/x86/crypto/aes_glue.c                 |   4 +-
 arch/x86/crypto/aesni-intel_glue.c         |   2 +-
 arch/x86/crypto/blowfish_glue.c            |   4 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c |   4 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c  |   4 +-
 arch/x86/crypto/camellia_glue.c            |   4 +-
 arch/x86/crypto/cast5_avx_glue.c           |   2 +-
 arch/x86/crypto/cast6_avx_glue.c           |   2 +-
 arch/x86/crypto/crc32-pclmul_glue.c        |   4 +-
 arch/x86/crypto/crc32c-intel_glue.c        |   4 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c    |   4 +-
 arch/x86/crypto/fpu.c                      |   3 +
 arch/x86/crypto/ghash-clmulni-intel_glue.c |   2 +-
 arch/x86/crypto/salsa20_glue.c             |   4 +-
 arch/x86/crypto/serpent_avx2_glue.c        |   4 +-
 arch/x86/crypto/serpent_avx_glue.c         |   2 +-
 arch/x86/crypto/serpent_sse2_glue.c        |   2 +-
 arch/x86/crypto/sha1_ssse3_glue.c          |   2 +-
 arch/x86/crypto/sha256_ssse3_glue.c        |   4 +-
 arch/x86/crypto/sha512_ssse3_glue.c        |   4 +-
 arch/x86/crypto/twofish_avx_glue.c         |   2 +-
 arch/x86/crypto/twofish_glue.c             |   4 +-
 arch/x86/crypto/twofish_glue_3way.c        |   4 +-
 arch/x86/include/asm/desc.h                |  20 +-
 arch/x86/kernel/cpu/mshyperv.c             |   1 +
 arch/x86/kernel/tls.c                      |  25 ++-
 arch/x86/kernel/traps.c                    |   4 +-
 arch/x86/kernel/tsc.c                      |   2 +-
 arch/x86/kvm/emulate.c                     |   4 +-
 crypto/842.c                               |   1 +
 crypto/aes_generic.c                       |   3 +-
 crypto/algapi.c                            |   4 +-
 crypto/ansi_cprng.c                        |   3 +-
 crypto/anubis.c                            |   1 +
 crypto/api.c                               |   4 +-
 crypto/arc4.c                              |   1 +
 crypto/authenc.c                           |   1 +
 crypto/authencesn.c                        |   1 +
 crypto/blowfish_generic.c                  |   3 +-
 crypto/camellia_generic.c                  |   3 +-
 crypto/cast5_generic.c                     |   3 +-
 crypto/cast6_generic.c                     |   3 +-
 crypto/cbc.c                               |   1 +
 crypto/ccm.c                               |   5 +-
 crypto/chainiv.c                           |   1 +
 crypto/cmac.c                              |   1 +
 crypto/crc32.c                             |   1 +
 crypto/crct10dif_generic.c                 |   3 +-
 crypto/cryptd.c                            |   1 +
 crypto/crypto_null.c                       |   6 +-
 crypto/ctr.c                               |   3 +-
 crypto/cts.c                               |   1 +
 crypto/deflate.c                           |   2 +-
 crypto/des_generic.c                       |   7 +-
 crypto/ecb.c                               |   1 +
 crypto/eseqiv.c                            |   1 +
 crypto/fcrypt.c                            |   1 +
 crypto/gcm.c                               |   7 +-
 crypto/ghash-generic.c                     |   3 +-
 crypto/hmac.c                              |   1 +
 crypto/khazad.c                            |   1 +
 crypto/krng.c                              |   3 +-
 crypto/lrw.c                               |   1 +
 crypto/lz4.c                               |   1 +
 crypto/lz4hc.c                             |   1 +
 crypto/lzo.c                               |   1 +
 crypto/md4.c                               |   2 +-
 crypto/md5.c                               |   1 +
 crypto/michael_mic.c                       |   1 +
 crypto/pcbc.c                              |   1 +
 crypto/pcrypt.c                            |   1 +
 crypto/rmd128.c                            |   1 +
 crypto/rmd160.c                            |   1 +
 crypto/rmd256.c                            |   1 +
 crypto/rmd320.c                            |   1 +
 crypto/salsa20_generic.c                   |   3 +-
 crypto/seed.c                              |   1 +
 crypto/seqiv.c                             |   1 +
 crypto/serpent_generic.c                   |   5 +-
 crypto/sha1_generic.c                      |   3 +-
 crypto/sha256_generic.c                    |   6 +-
 crypto/sha512_generic.c                    |   6 +-
 crypto/tea.c                               |   5 +-
 crypto/tgr192.c                            |   5 +-
 crypto/twofish_generic.c                   |   3 +-
 crypto/vmac.c                              |   1 +
 crypto/wp512.c                             |   5 +-
 crypto/xcbc.c                              |   1 +
 crypto/xts.c                               |   1 +
 crypto/zlib.c                              |   1 +
 drivers/ata/libata-sff.c                   |  12 ++
 drivers/ata/sata_dwc_460ex.c               |  26 ++-
 drivers/block/drbd/drbd_req.c              |   1 +
 drivers/bus/mvebu-mbus.c                   |  13 ++
 drivers/clocksource/exynos_mct.c           |   4 +-
 drivers/crypto/padlock-aes.c               |   2 +-
 drivers/crypto/padlock-sha.c               |   8 +-
 drivers/crypto/ux500/cryp/cryp_core.c      |   4 +-
 drivers/crypto/ux500/hash/hash_core.c      |   8 +-
 drivers/gpio/gpiolib.c                     |  46 ++---
 drivers/gpu/drm/i915/i915_gem.c            |   2 +-
 drivers/gpu/drm/radeon/radeon_asic.c       |  18 +-
 drivers/gpu/drm/radeon/radeon_pm.c         |  33 +++
 drivers/gpu/drm/radeon/si_dpm.c            |  39 ++++
 drivers/input/evdev.c                      |  13 +-
 drivers/md/dm-cache-metadata.c             | 101 +++++++++-
 drivers/md/dm-cache-target.c               |  89 ++++----
 drivers/md/raid5.c                         |   3 +-
 drivers/mmc/host/sdhci.c                   |   2 +-
 drivers/net/can/dev.c                      |   8 +-
 drivers/pci/pci.c                          |  40 +++-
 drivers/pci/quirks.c                       |  14 ++
 drivers/pinctrl/core.c                     |   5 +-
 drivers/s390/crypto/ap_bus.c               |   3 +-
 drivers/scsi/ipr.c                         |  92 +++++++++
 drivers/scsi/ipr.h                         |   1 +
 drivers/tty/n_tty.c                        |   9 +-
 drivers/xen/swiotlb-xen.c                  |   2 +-
 fs/btrfs/extent_io.c                       |  11 +-
 fs/btrfs/file.c                            |   5 +-
 fs/buffer.c                                |  28 ++-
 fs/cifs/ioctl.c                            |  21 +-
 fs/ext4/mballoc.c                          |  14 +-
 fs/f2fs/checkpoint.c                       |   1 -
 fs/f2fs/node.c                             |   2 -
 fs/fuse/dev.c                              |   2 +-
 fs/fuse/file.c                             |   2 -
 fs/gfs2/aops.c                             |   1 -
 fs/gfs2/meta_io.c                          |   4 +-
 fs/ntfs/attrib.c                           |   1 -
 fs/ntfs/file.c                             |   1 -
 include/linux/cpuset.h                     |  29 ++-
 include/linux/crypto.h                     |  13 ++
 include/linux/gfp.h                        |   4 +-
 include/linux/huge_mm.h                    |   4 -
 include/linux/jump_label.h                 |  20 +-
 include/linux/mmzone.h                     | 228 +++++++++++----------
 include/linux/page-flags.h                 |   2 +
 include/linux/pageblock-flags.h            |  33 ++-
 include/linux/pagemap.h                    | 108 +++++++++-
 include/linux/pci.h                        |   2 +
 include/linux/swap.h                       |  22 +-
 include/linux/time.h                       |  13 ++
 include/trace/events/pagemap.h             |  16 +-
 kernel/cpuset.c                            |  14 +-
 kernel/time.c                              |   4 +
 kernel/time/ntp.c                          |   7 +
 mm/filemap.c                               | 209 ++++++++-----------
 mm/huge_memory.c                           |  26 +++
 mm/memory.c                                |   4 +-
 mm/page_alloc.c                            | 313 ++++++++++++++++-------------
 mm/shmem.c                                 |  11 +-
 mm/swap.c                                  |  50 ++++-
 mm/swap_state.c                            |   2 +-
 mm/vmalloc.c                               |   6 +-
 mm/vmscan.c                                |  36 ++--
 mm/vmstat.c                                |   9 +-
 net/netfilter/ipvs/ip_vs_ftp.c             |  10 +-
 net/netfilter/nfnetlink.c                  |   3 +-
 scripts/recordmcount.pl                    |   1 -
 security/keys/gc.c                         |   4 +-
 sound/usb/mixer.c                          |   1 +
 186 files changed, 1461 insertions(+), 822 deletions(-)


