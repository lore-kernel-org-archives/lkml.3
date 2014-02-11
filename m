Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaBKUSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:18:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbaBKTG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.12 000/107] 3.12.11-stable review
Date: Tue, 11 Feb 2014 11:04:26 -0800
Message-Id: <20140211184748.191276235@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.11 release.
There are 107 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb 13 18:47:29 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.11-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.12.11-rc1

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Fix possibility of chip->fixes being null

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Fix BYT sd card getting stuck in runtime suspend

Borislav Petkov <bp@alien8.de>
    rtc-cmos: Add an alarm disable quirk

John Stultz <john.stultz@linaro.org>
    timekeeping: Fix missing timekeeping_update in suspend path

John Stultz <john.stultz@linaro.org>
    timekeeping: Fix CLOCK_TAI timer/nanosleep delays

John Stultz <john.stultz@linaro.org>
    3.13.y: timekeeping: Fix clock_set/clock_was_set think-o

John Stultz <john.stultz@linaro.org>
    timekeeping: Avoid possible deadlock from clock_was_set_delayed

John Stultz <john.stultz@linaro.org>
    timekeeping: Fix potential lost pv notification of time change

John Stultz <john.stultz@linaro.org>
    timekeeping: Fix lost updates to tai adjustment

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Have function graph only trace based on global_ops filters

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Fix synchronization location disabling and freeing ftrace_ops

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Synchronize setting function_trace_op with ftrace_trace_function

Dave Airlie <airlied@redhat.com>
    drm/mgag200,ast,cirrus: fix regression with drm_can_sleep conversion

Dave Airlie <airlied@redhat.com>
    drm/mgag200: fix typo causing bw limits to be ignored on some chips

Dave Airlie <airlied@redhat.com>
    drm/mgag200: fix oops in cursor code.

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix regression caused by "drm/ttm: make ttm reservation calls behave like reservation calls"

Dave Airlie <airlied@redhat.com>
    drm: ast,cirrus,mgag200: use drm_can_sleep

Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
    drm/gma500: Lock struct_mutex around cursor updates

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    drm/rcar-du: Update plane pitch in .mode_set_base() operation

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/gem: Always initialize the gem object in object_init

Takashi Iwai <tiwai@suse.de>
    drm/cirrus: correct register values for 16bpp

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Decouple GPU error reporting from ring initialisation

Stanislaw Gruszka <sgruszka@redhat.com>
    i915: remove pm_qos request on error

Todd Previte <tprevite@gmail.com>
    drm/i915: VLV2 - Fix hotplug detect bits

Akash Goel <akash.goel@intel.com>
    drm/i915: Fix the offset issue for the stolen GEM objects

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Flush outstanding requests before allocating new seqno

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/falcon: use vmalloc to create firwmare copies

Maarten Lankhorst <maarten.lankhorst@canonical.com>
    drm/nouveau: fix m2mf copy to tiled gart

Mikulas Patocka <mpatocka@redhat.com>
    dm sysfs: fix a module unload race

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dce8: workaround for atom BlankCrtc table

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/DCE4+: clear bios scratch dpms bit (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix DAC interrupt handling on DCE5+

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add UVD support for OLAND

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: set the full cache bit for fences on r7xx+

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix surface sync in fence on cayman (v2)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: disable ss on DP for DCE3.x

Marek Olšák <marek.olsak@amd.com>
    drm/radeon: skip colorbuffer checking if COLOR_INFO.FORMAT is set to INVALID

Malcolm Priestley <tvboxspy@gmail.com>
    m88rs2000: set symbol rate accurately

Malcolm Priestley <tvboxspy@gmail.com>
    m88rs2000: add m88rs2000_set_carrieroffset

Olivier Grenie <olivier.grenie@parrot.com>
    dib8000: fix regression with dib807x

Mauro Carvalho Chehab <m.chehab@samsung.com>
    nxt200x: increase write buffer size

Malcolm Priestley <tvboxspy@gmail.com>
    it913x: Add support for Avermedia H335 id 0x0335

Marek Szyprowski <m.szyprowski@samsung.com>
    media: s5p_mfc: remove s5p_mfc_get_node_type() function

Mauro Carvalho Chehab <m.chehab@samsung.com>
    dib8000: make 32 bits read atomic

Antti Palosaari <crope@iki.fi>
    media: anysee: fix non-working E30 Combo Plus DVB-T

Marek Szyprowski <m.szyprowski@samsung.com>
    media: media: v4l2-dev: fix video device index assignment

David Rientjes <rientjes@google.com>
    mm, oom: base root bonus on current usage

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix connection reset hang with percpu_ida_alloc

Kent Overstreet <kmo@daterainc.com>
    percpu_ida: Make percpu_ida_alloc + callers accept task state bitmask

Paul Bolle <pebolle@tiscali.nl>
    mei: mei_hbm_dispatch() returns void

Michel Dänzer <michel.daenzer@amd.com>
    radeon/pm: Guard access to rdev->pm.power_state array

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm: disable mclk switching on desktop RV770

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: warn users when hw_i2c is enabled (v2)

Joe Thornber <ejt@redhat.com>
    dm space map metadata: fix bug in resizing of thin metadata

Joe Thornber <ejt@redhat.com>
    dm space map metadata: fix extending the space map

Joe Thornber <ejt@redhat.com>
    dm space map common: make sure new space is used during extend

Mikulas Patocka <mpatocka@redhat.com>
    dm: wait until embedded kobject is released before destroying a device

Mike Snitzer <snitzer@redhat.com>
    dm thin: fix set_pool_mode exposed pool operation races

Mike Snitzer <snitzer@redhat.com>
    dm thin: initialize dm_thin_new_mapping returned by get_next_mapping

Joe Thornber <ejt@redhat.com>
    dm thin: fix discard support to a previously shared block

Jeff Layton <jlayton@redhat.com>
    sunrpc: don't wait for write before allowing reads from use-gss-proxy file

Weston Andros Adamson <dros@netapp.com>
    sunrpc: Fix infinite loop in RPC state machine

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix a slot leak in nfs40_sequence_done

Boaz Harrosh <bharrosh@panasas.com>
    pnfs: Proper delay for NFS4ERR_RECALLCONFLICT in layout_get_done

Weston Andros Adamson <dros@primarydata.com>
    nfs4: fix discover_server_trunking use after free

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4.1: Handle errors correctly in nfs41_walk_client_list

Scott Mayhew <smayhew@redhat.com>
    nfs: always make sure page is up-to-date before extending a write to cover the entire page

Weston Andros Adamson <dros@primarydata.com>
    nfs4.1: properly handle ENOTSUP in SECINFO_NO_NAME

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: OPEN must handle the NFS4ERR_IO return code correctly

Mika Westerberg <mika.westerberg@linux.intel.com>
    spi/pxa2xx: initialize DMA channels to -1 to prevent inadvertent match

Daniel Santos <daniel.santos@pobox.com>
    spidev: fix hang when transfer_one_message fails

Jonas Gorski <jogo@openwrt.org>
    spi/bcm63xx: don't substract prepend length from total length

Ira Weiny <ira.weiny@intel.com>
    IB/qib: Fix QP check when looping back to/from QP1

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: xtfpga: fix definitions of platform devices

Boaz Harrosh <bharrosh@panasas.com>
    ore: Fix wrong math in allocation of per device BIO

Michael Grzeschik <m.grzeschik@pengutronix.de>
    mtd: mxc_nand: remove duplicated ecc_stats counting

Heiko Carstens <heiko.carstens@de.ibm.com>
    tile: remove compat_sys_lookup_dcookie declaration to fix compile error

Heiko Carstens <heiko.carstens@de.ibm.com>
    fs/compat: fix lookup_dcookie() parameter handling

Heiko Carstens <heiko.carstens@de.ibm.com>
    fs/compat: fix parameter handling for compat readv/writev syscalls

Heiko Carstens <heiko.carstens@de.ibm.com>
    compat: fix sys_fanotify_mark

Mark Brown <broonie@linaro.org>
    ACPI / init: Flag use of ACPI and ACPI idioms for power supplies to regulator API

Josh Triplett <josh@joshtriplett.org>
    turbostat: Use GCC's CPUID functions to support PIC

Josh Triplett <josh@joshtriplett.org>
    turbostat: Don't put unprocessed uapi headers in the include path

Li Zefan <lizefan@huawei.com>
    slub: Fix calculation of cpu slabs

Gregory CLEMENT <gregory.clement@free-electrons.com>
    ARM: mvebu: Fix kernel hang in mvebu_soc_id_init() when of_iomap failed

Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    ARM: orion: provide C-style interrupt handler for MULTI_IRQ_HANDLER

Wolfram Sang <wsa@the-dreams.de>
    mmc: core: sd: implement proper support for sd3.0 au sizes

Ludovic Desroches <ludovic.desroches@atmel.com>
    mmc: atmel-mci: fix timeout errors in SDIO mode when using DMA

Ray Jui <rjui@broadcom.com>
    mmc: fix host release issue after discard operation

Andrey Vagin <avagin@openvz.org>
    mm: don't lose the SOFT_DIRTY flag on mprotect

Cyrill Gorcunov <gorcunov@gmail.com>
    mm: ignore VM_SOFTDIRTY on VMA merging

Michal Hocko <mhocko@suse.cz>
    memcg: fix css reference leak and endless loop in mem_cgroup_iter

Michal Hocko <mhocko@suse.cz>
    memcg: fix endless loop caused by mem_cgroup_iter

Johannes Weiner <hannes@cmpxchg.org>
    mm/page-writeback.c: do not count anon pages as dirtyable memory

Johannes Weiner <hannes@cmpxchg.org>
    mm/page-writeback.c: fix dirty_balance_reserve subtraction from dirtyable memory

Hugh Dickins <hughd@google.com>
    mm/memcg: iteration skip memcgs not yet fully initialized

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm/memory-failure.c: shift page lock from head page to tail page after thp split

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pvhvm: If xen_platform_pci=0 is set don't blow up (v4).

AKASHI Takahiro <takahiro.akashi@linaro.org>
    audit: correct a type mismatch in audit_syscall_exit()

Richard Guy Briggs <rgb@redhat.com>
    audit: reset audit backlog wait time after error recovery

Miklos Szeredi <mszeredi@suse.cz>
    fuse: fix pipe_buf_operations

Bjorn Helgaas <bhelgaas@google.com>
    Revert "EISA: Initialize device before its resources"

Alex Williamson <alex.williamson@redhat.com>
    intel-iommu: fix off-by-one in pagetable freeing

Wanlong Gao <gaowanlong@cn.fujitsu.com>
    arch/sh/kernel/kgdb.c: add missing #include <linux/sched.h>

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Check if tracing is enabled in trace_puts()

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Have trace buffer point back to trace_array

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    SELinux: Fix memory leak upon loading policy


-------------

Diffstat:

 Documentation/filesystems/proc.txt                 |   4 +-
 Makefile                                           |   4 +-
 arch/arm/mach-mvebu/mvebu-soc-id.c                 |   2 +-
 arch/arm/plat-orion/irq.c                          |  47 +++++
 arch/sh/kernel/kgdb.c                              |   1 +
 arch/tile/include/asm/compat.h                     |   1 -
 arch/x86/include/asm/pgtable_types.h               |   3 +-
 arch/x86/xen/platform-pci-unplug.c                 |  74 ++++++++
 arch/xtensa/platforms/xtfpga/setup.c               |  12 +-
 drivers/acpi/bus.c                                 |   9 +
 drivers/block/xen-blkfront.c                       |   4 +-
 drivers/char/tpm/xen-tpmfront.c                    |   4 +
 drivers/eisa/eisa-bus.c                            |  26 +--
 drivers/gpu/drm/ast/ast_fb.c                       |   2 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c              |   2 +-
 drivers/gpu/drm/cirrus/cirrus_mode.c               |   4 +-
 drivers/gpu/drm/drm_gem.c                          |   3 +-
 drivers/gpu/drm/gma500/gma_display.c               |  12 +-
 drivers/gpu/drm/i915/i915_dma.c                    |   1 +
 drivers/gpu/drm/i915/i915_drv.h                    |   1 +
 drivers/gpu/drm/i915/i915_gem_stolen.c             |   2 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |  22 ++-
 drivers/gpu/drm/i915/i915_reg.h                    |  10 +-
 drivers/gpu/drm/i915/intel_dp.c                    |  40 +++--
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  12 +-
 drivers/gpu/drm/mgag200/mgag200_cursor.c           |   8 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c               |   2 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |   4 +-
 drivers/gpu/drm/nouveau/core/engine/falcon.c       |  20 ++-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  33 +---
 drivers/gpu/drm/radeon/atombios_crtc.c             |  25 ++-
 drivers/gpu/drm/radeon/evergreen.c                 |   4 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   5 +-
 drivers/gpu/drm/radeon/ni.c                        |  16 +-
 drivers/gpu/drm/radeon/nid.h                       |   1 +
 drivers/gpu/drm/radeon/r600.c                      |  13 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |   5 +-
 drivers/gpu/drm/radeon/r600d.h                     |   1 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |   4 +
 drivers/gpu/drm/radeon/radeon_i2c.c                |   3 +
 drivers/gpu/drm/radeon/radeon_pm.c                 |   6 +-
 drivers/gpu/drm/radeon/radeon_uvd.c                |   1 +
 drivers/gpu/drm/radeon/rv770_dpm.c                 |   6 +
 drivers/gpu/drm/radeon/si.c                        |   2 +-
 drivers/gpu/drm/radeon/sid.h                       |   2 +-
 drivers/gpu/drm/radeon/uvd_v2_2.c                  |   1 +
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |   1 -
 drivers/gpu/drm/rcar-du/rcar_du_plane.c            |  21 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   9 +-
 drivers/infiniband/hw/qib/qib_ud.c                 |   9 +-
 drivers/input/misc/xen-kbdfront.c                  |   4 +
 drivers/iommu/intel-iommu.c                        |   2 +-
 drivers/md/Kconfig                                 |   4 +
 drivers/md/Makefile                                |   1 +
 drivers/md/dm-builtin.c                            |  48 ++++++
 drivers/md/dm-sysfs.c                              |   5 +-
 drivers/md/dm-thin-metadata.c                      |  20 +++
 drivers/md/dm-thin-metadata.h                      |   2 +
 drivers/md/dm-thin.c                               |  71 +++++---
 drivers/md/dm.c                                    |  15 +-
 drivers/md/dm.h                                    |  17 ++
 drivers/md/persistent-data/dm-space-map-common.c   |   6 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |  28 ++-
 drivers/media/dvb-core/dvb-usb-ids.h               |   1 +
 drivers/media/dvb-frontends/dib8000.c              |  42 +++--
 drivers/media/dvb-frontends/m88rs2000.c            | 117 +++++++++----
 drivers/media/dvb-frontends/m88rs2000.h            |   2 +
 drivers/media/dvb-frontends/nxt200x.c              |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  28 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   9 -
 drivers/media/usb/dvb-usb-v2/anysee.c              |   3 +-
 drivers/media/usb/dvb-usb-v2/it913x.c              |   3 +
 drivers/media/v4l2-core/v4l2-dev.c                 |   2 +-
 drivers/misc/mei/hbm.c                             |   2 +-
 drivers/mmc/card/block.c                           |   7 +-
 drivers/mmc/core/sd.c                              |  37 ++--
 drivers/mmc/host/atmel-mci.c                       |  13 +-
 drivers/mmc/host/sdhci-pci.c                       |  12 ++
 drivers/mtd/nand/mxc_nand.c                        |   1 -
 drivers/net/xen-netfront.c                         |   2 +-
 drivers/pci/xen-pcifront.c                         |   4 +
 drivers/rtc/rtc-cmos.c                             |  52 +++++-
 drivers/spi/spi-bcm63xx.c                          |   2 -
 drivers/spi/spi-pxa2xx.c                           |   2 +
 drivers/spi/spi.c                                  |   4 +-
 drivers/target/iscsi/iscsi_target_util.c           |   8 +-
 drivers/vhost/scsi.c                               |   2 +-
 drivers/video/xen-fbfront.c                        |   4 +
 drivers/xen/xenbus/xenbus_probe_frontend.c         |   2 +-
 fs/dcookies.c                                      |   2 +-
 fs/exofs/ore.c                                     |  37 ++--
 fs/fuse/dev.c                                      |  22 +--
 fs/nfs/nfs4client.c                                |  18 +-
 fs/nfs/nfs4proc.c                                  |  40 ++++-
 fs/nfs/nfs4xdr.c                                   |  47 +++--
 fs/nfs/write.c                                     |  11 +-
 fs/notify/fanotify/fanotify_user.c                 |   4 +-
 fs/read_write.c                                    |  16 +-
 fs/splice.c                                        |  18 ++
 include/linux/audit.h                              |   2 +-
 include/linux/compat.h                             |  18 +-
 include/linux/percpu_ida.h                         |   3 +-
 include/linux/pipe_fs_i.h                          |   2 +
 include/linux/vmstat.h                             |   2 -
 include/scsi/osd_ore.h                             |   1 +
 include/xen/platform_pci.h                         |  23 +++
 kernel/audit.c                                     |   5 +-
 kernel/time/timekeeping.c                          |  47 +++--
 kernel/trace/ftrace.c                              | 190 ++++++++++++++++-----
 kernel/trace/trace.c                               |   8 +
 lib/percpu_ida.c                                   |  21 ++-
 mm/internal.h                                      |   1 -
 mm/memcontrol.c                                    |  37 ++--
 mm/memory-failure.c                                |  21 +--
 mm/mmap.c                                          |  12 +-
 mm/oom_kill.c                                      |   2 +-
 mm/page-writeback.c                                |  57 +++----
 mm/slub.c                                          |   8 +-
 mm/vmscan.c                                        |  23 +--
 net/core/skbuff.c                                  |  32 +---
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |   2 -
 net/sunrpc/auth_gss/svcauth_gss.c                  |  33 +---
 net/sunrpc/clnt.c                                  |   8 +-
 net/sunrpc/netns.h                                 |   1 -
 security/selinux/ss/policydb.c                     |  14 +-
 tools/power/x86/turbostat/Makefile                 |   2 +-
 tools/power/x86/turbostat/turbostat.c              |  13 +-
 127 files changed, 1302 insertions(+), 591 deletions(-)


