Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab3AOWov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:44:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:44792 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331Ab3AOWop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:44:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/171] 3.4.26-stable review
Date: Tue, 15 Jan 2013 14:42:45 -0800
Message-Id: <20130115224313.394976595@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.26 release.
There are 171 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jan 17 22:42:47 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.26-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.26-rc1

Alan Stern <stern@rowland.harvard.edu>
    USB: fix endpoint-disabling for failed config changes

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should select COMEDI_FC

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: don't hijack hardware device private data

David Zafman <david.zafman@inktank.com>
    libceph: Unlock unprocessed pages in start_read() error path

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: call handle_cap_grant() for cap import message

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: Fix __ceph_do_pending_vmtruncate

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: Don't add dirty inode to dirty list if caps is in migration

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: Fix infinite loop in __wake_requests

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: Don't update i_max_size when handling non-auth cap

Alex Elder <elder@inktank.com>
    rbd: do not allow remove of mounted-on image

Alex Elder <elder@inktank.com>
    rbd: fix bug in rbd_dev_id_put()

Sage Weil <sage@inktank.com>
    rbd: BUG on invalid layout

Alex Elder <elder@inktank.com>
    rbd: remove linger unconditionally

Alex Elder <elder@inktank.com>
    ceph: don't reference req after put

Sage Weil <sage@inktank.com>
    libceph: remove 'osdtimeout' option

Alex Elder <elder@inktank.com>
    rbd: kill notify_timeout option

Alex Elder <elder@inktank.com>
    rbd: add read_only rbd map option

Alex Elder <elder@inktank.com>
    rbd: kill create_snap sysfs entry

Alex Elder <elder@inktank.com>
    libceph: avoid using freed osd in __kick_osd_requests()

Sage Weil <sage@inktank.com>
    libceph: fix osdmap decode error paths

Sage Weil <sage@inktank.com>
    libceph: fix protocol feature mismatch failure path

Alex Elder <elder@inktank.com>
    libceph: WARN, don't BUG on unexpected connection states

Alex Elder <elder@inktank.com>
    libceph: always reset osds when kicking

Alex Elder <elder@inktank.com>
    libceph: move linger requests sooner in kick_requests()

Alex Elder <elder@inktank.com>
    libceph: register request before unregister linger

Alex Elder <elder@inktank.com>
    libceph: don't use rb_init_node() in ceph_osdc_alloc_request()

Alex Elder <elder@inktank.com>
    libceph: init event->node in ceph_osdc_create_event()

Alex Elder <elder@inktank.com>
    libceph: init osd->o_node in create_osd()

Alex Elder <elder@inktank.com>
    libceph: report connection fault with warning

Alex Elder <elder@inktank.com>
    libceph: socket can close in any connection state

Sage Weil <sage@inktank.com>
    ceph: propagate layout error on osd request creation

Alex Elder <elder@inktank.com>
    rbd: drop dev reference on error in rbd_open()

Sage Weil <sage@inktank.com>
    ceph: tolerate (and warn on) extraneous dentry from mds

Josh Durgin <josh.durgin@dreamhost.com>
    rbd: send header version when notifying

Josh Durgin <josh.durgin@dreamhost.com>
    rbd: use reference counting for the snap context

Josh Durgin <josh.durgin@dreamhost.com>
    rbd: set image size when header is updated

Josh Durgin <josh.durgin@dreamhost.com>
    rbd: expose the correct size of the device in sysfs

Josh Durgin <josh.durgin@inktank.com>
    rbd: only reset capacity when pointing to head

Josh Durgin <josh.durgin@inktank.com>
    rbd: return errors for mapped but deleted snapshot

Sage Weil <sage@inktank.com>
    ceph: close old con before reopening on mds reconnect

Daniel Vetter <daniel.vetter@ffwll.ch>
    Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Flush the pending flips on the CRTC before modification

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: call drm_handle_vblank before finish_page_flip

Ben Widawsky <ben@bwidawsk.net>
    drm/i915: Fix GT_MODE default value

Eugeni Dodonov <eugeni.dodonov@intel.com>
    drm/i915: prevent possible pin leak on error path

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Reduce a pin-leak BUG into a WARN

Jani Nikula <jani.nikula@intel.com>
    drm/i915: only enable sdvo hotplug irq if needed

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix ordering in pll picking on dce4+

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: SDVO hotplug have different interrupt status bits for i915/i965/g4x

Paulo Zanoni <paulo.r.zanoni@intel.com>
    drm/i915: add some barriers when changing DIPs

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix up pll selection on DCE5/6

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: don't pwrite tiled objects through the gtt

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Wait for all pending operations to the fb before disabling the pipe

Sean Paul <seanpaul@chromium.org>
    drm/i915: Add wait_for in init_ring_common

Takashi Iwai <tiwai@suse.de>
    drm/i915: Check VBIOS value for determining LVDS dual channel mode, too

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: hold forcewake around ring hw init

Jesse Barnes <jbarnes@virtuousgeek.org>
    drm/i915: move NEEDS_FORCE_WAKE to i915_drv.c

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: fix up ivb plane 3 pageflips

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Unpin the flip target if we fail to queue the flip

Adam Jackson <ajax@redhat.com>
    drm/edid/quirks: ViewSonic VA2026w

Alexander Graf <agraf@suse.de>
    KVM: PPC: 44x: fix DCR read/write

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: disable cpt phase pointer fdi rx workaround

Benjamin Marzinski <bmarzins@redhat.com>
    GFS2: Test bufdata with buffer locked and gfs2_log_lock held

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Handle HS bulk/ctrl endpoints that don't NAK.

Oliver Neukum <oliver@neukum.org>
    USB: hub: handle claim of enabled remote wakeup after reset

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Avoid "dead ports", add roothub port polling.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Handle warm reset failure on empty port.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Ignore port state until reset completes.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Increase reset timeout.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Allow USB 3.0 ports to be disabled.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Ignore xHCI Reset Device status.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Handle auto-transition from hot to warm reset.

Marcin Slusarz <marcin.slusarz@gmail.com>
    drm/nouveau: fix blank LVDS screen regression on pre-nv50 cards

Sergei Shtylyov <sshtylyov@ru.mvista.com>
    usb: musb: core: print new line in the driver banner again

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: dummy: fix enumeration with g_multi

Denis N Ladin <denladin@gmail.com>
    USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"

Tomasz Mloduchowski <q@qdot.me>
    usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added

Bjørn Mork <bjorn@mork.no>
    USB: option: add Telekom Speedstick LTE II

Quentin.Li <snowmanli88@163.com>
    USB: option: Add new MEDIATEK PID support

Bjørn Mork <bjorn@mork.no>
    USB: option: blacklist network interface on ZTE MF880

Dzianis Kahanovich <mahatma@bspu.unibel.by>
    USB: option: add Nexpring NP10T terminal id

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Fix firmware loading when driver is built into the kernel

Bing Zhao <bzhao@marvell.com>
    mwifiex: check wait_event_interruptible return value

Johannes Berg <johannes.berg@intel.com>
    mac80211: use del_timer_sync for final sta cleanup timer deletion

Stanislaw Gruszka <sgruszka@redhat.com>
    mac80211: fix ibss scanning

Jerome Glisse <jglisse@redhat.com>
    radeon/kms: force rn50 chip to always report connected on analog output

Samuel Thibault <samuel.thibault@ens-lyon.org>
    staging: speakup: avoid out-of-range access in synth_add()

Nickolai Zeldovich <nickolai@csail.mit.edu>
    staging: speakup: avoid out-of-range access in synth_init()

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8712u: Add new device ID

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: comedi_test: fix race when cancelling command

Éric Piel <piel@delmic.com>
    staging: comedi: fix minimum AO period for NI 625x and NI 628x

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: prevent auto-unconfig of manually configured devices

Mike Dunn <mikedunn@newsguy.com>
    ALSA: pxa27x: fix ac97 warm reset

Mike Dunn <mikedunn@newsguy.com>
    ALSA: pxa27x: fix ac97 cold reset

Hans de Goede <hdegoede@redhat.com>
    udldrmfb: udl_get_edid: drop unneeded i--

Hans de Goede <hdegoede@redhat.com>
    udldrmfb: udl_get_edid: usb_control_msg buffer must not be on the stack

Hans de Goede <hdegoede@redhat.com>
    udldrmfb: Fix EDID not working with monitors with EDID extension blocks

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm5100: Remove DSP B and left justified formats

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm2200: Remove DSP B and left justified AIF modes

Axel Lin <axel.lin@ingics.com>
    ASoC: wm2200: Fix setting dai format in wm2200_set_fmt

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm2000: Fix sense of speech clarity enable

Marek Vasut <marex@denx.de>
    HID: add quirk for Freescale i.MX23 ROM recovery

Eric Wong <normalperson@yhbt.net>
    epoll: prevent missed events on EPOLL_CTL_MOD

Mark Brown <broonie@opensource.wolfsonmicro.com>
    regmap: debugfs: Avoid overflows for very small reads

Zhang Rui <rui.zhang@intel.com>
    ACPI : do not use Lid and Sleep button for S5 wakeup

Andre Przywara <andre.przywara@amd.com>
    x86, amd: Disable way access filter on Piledriver CPUs

David Rientjes <rientjes@google.com>
    thp, memcg: split hugepage for memcg oom on cow

Namjae Jeon <namjae.jeon@samsung.com>
    udf: don't increment lenExtents while writing to a hole

Namjae Jeon <namjae.jeon@samsung.com>
    udf: fix memory leak while allocating blocks during write

Ed L. Cashin <ecashin@coraid.com>
    aoe: do not call bdi_init after blk_alloc_queue

Theodore Ts'o <tytso@mit.edu>
    ext4: lock i_mutex when truncating orphan inodes

Michael Tokarev <mjt@tls.msk.ru>
    ext4: do not try to write superblock on ro remount w/o journal

Jan Kara <jack@suse.cz>
    jbd2: fix assertion failure in jbd2_journal_flush()

Jan Kara <jack@suse.cz>
    ext4: check dioread_nolock on remount

Forrest Liu <forrestl@synology.com>
    ext4: fix extent tree corruption caused by hole punch

Seth Forshee <seth.forshee@canonical.com>
    samsung-laptop: Add quirk for broken acpi_video backlight on N250P

Lothar Waßmann <LW@KARO-electronics.de>
    video: mxsfb: fix crash when unblanking the display

Chris Verges <kg4ysn@gmail.com>
    hwmon: (lm73} Detect and report i2c bus errors

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: 64bit fixes: vCommandTimerWait change calculation of timer.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: 64 bit fixes: fix long warning messages.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: 64 bit fixes : correct all type sizes

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: 64 bit fixes: use u32 for QWORD definition.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [BUG] out of bound array reference in RFbSetPower.

Alasdair G Kergon <agk@redhat.com>
    dm ioctl: prevent unsafe change to dm_ioctl data_size

Mikulas Patocka <mpatocka@redhat.com>
    dm persistent data: rename node to btree_node

Steven Rostedt <srostedt@redhat.com>
    ring-buffer: Fix race between integrity check and readers

Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
    RDMA/nes: Fix for terminate timer crash

Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
    RDMA/nes: Fix for crash when registering zero length MR for CQ

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Fix validity issues with rpc_pipefs sb->s_fs_info

Paulo Zanoni <paulo.r.zanoni@intel.com>
    drm/i915: make the panel fitter work on pipes B and C on IVB

Niels Ole Salscheider <niels_ole@salscheider-online.de>
    drm/radeon: Properly handle DDC probe for DP bridges

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add WAIT_UNTIL to evergreen VM safe reg list

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix eDP clk and lane setup for scaled modes

Woodhouse, David <david.woodhouse@intel.com>
    intel-iommu: Free old page tables before creating superpage

Dan Williams <dcbw@redhat.com>
    i2400m: add Intel 6150 device IDs

Alexey Khoroshilov <khoroshilov@ispras.ru>
    jffs2: hold erase_completion_lock on exit

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Ensure we release the socket write lock if the rpc_task exits early

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Ensure that we free the rpc_task after cleanups are done

Stanislav Kinsbursky <skinsbursky@parallels.com>
    SUNRPC: continue run over clients list on PipeFS event instead of break

Wolfram Sang <w.sang@pengutronix.de>
    mtd: nand: gpmi: reset BCH earlier, too, to avoid NAND startup problems

Nathan Williams <nathan@traverse.com.au>
    mtd cs553x_nand: Initialise ecc.strength before nand_scan()

Theodore Ts'o <tytso@mit.edu>
    ext4: fix possible use after free with metadata csum

Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
    ext4: fix memory leak in ext4_xattr_set_acl()'s error path

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    mfd: Only unregister platform devices allocated by the mfd core

Mark Brown <broonie@opensource.wolfsonmicro.com>
    mfd: wm8994: Add support for WM1811 rev E

Yi Zou <yi.zou@intel.com>
    target/tcm_fc: fix the lockdep warning due to inconsistent lock state

Xiaotian Feng <xtfeng@gmail.com>
    libata: fix Null pointer dereference on disk error

Aaron Lu <aaron.lu@intel.com>
    libata: set dma_mode to 0xff in reset

Mikael Pettersson <mikpe@it.uu.se>
    sata_promise: fix hardreset lockdep error

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    iscsit: use GFP_ATOMIC under spin lock

David Jeffery <djeffery@redhat.com>
    SCSI: qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.

Sasha Levin <sasha.levin@oracle.com>
    SCSI: prevent stack buffer overflow in host_reset

Xi Wang <xi.wang@gmail.com>
    SCSI: mvsas: fix undefined bit shift

Jianpeng Ma <majianpeng@gmail.com>
    SCSI: mvsas: Fix oops when ata commond timeout.

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: sigmadsp: Fix endianness conversion issue

Stephan Gatzka <stephan.gatzka@gmail.com>
    firewire: net: Fix handling of fragmented multicast/broadcast packets.

Felix Fietkau <nbd@openwrt.org>
    ath9k_hw: Fix signal strength / channel noise reporting

Gabor Juhos <juhosg@openwrt.org>
    ath9k: ar9003: fix OTP register offsets for AR9340

Felix Fietkau <nbd@openwrt.org>
    Revert "ath9k_hw: Update AR9003 high_power tx gain table"

Laura Abbott <lauraa@codeaurora.org>
    mm: use aligned zone start for pfn_to_bitidx calculation

Jason Liu <r64343@freescale.com>
    mm: compaction: fix echo 1 > compact_memory return error issue

Huacai Chen <chenhc@lemote.com>
    MIPS: Fix poweroff failure when HOTPLUG_CPU configured.

Sebastian Ott <sebott@linux.vnet.ibm.com>
    s390/cio: fix pgid reserved check

Alex Williamson <alex.williamson@redhat.com>
    KVM: Fix user memslot overlap check

Gabor Juhos <juhosg@openwrt.org>
    powerpc: Add missing NULL terminator to avoid boot panic on PPC40x

Shan Hai <shan.hai@windriver.com>
    powerpc/vdso: Remove redundant locking in update_vsyscall_tz()

Anton Blanchard <anton@samba.org>
    powerpc: Fix CONFIG_RELOCATABLE=y CONFIG_CRASH_DUMP=n build

Rafał Miłecki <zajec5@gmail.com>
    bcma: mips: fix clearing device IRQ

Felix Fietkau <nbd@openwrt.org>
    ath5k: fix tx path skb leaks

Mark Brown <broonie@opensource.wolfsonmicro.com>
    regulator: wm831x: Set the new rather than old value for DVS VSEL


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-rbd            |   6 -
 Makefile                                           |   4 +-
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h        |   3 +
 arch/arm/mach-pxa/pxa27x.c                         |   4 +-
 arch/mips/kernel/process.c                         |   4 +-
 arch/powerpc/kernel/head_64.S                      |   2 +-
 arch/powerpc/kernel/time.c                         |   5 -
 arch/powerpc/kvm/44x_emulate.c                     |   2 +
 arch/powerpc/platforms/40x/ppc40x_simple.c         |   3 +-
 arch/x86/kernel/cpu/amd.c                          |  14 +
 drivers/acpi/scan.c                                |   7 +-
 drivers/ata/libata-core.c                          |   1 +
 drivers/ata/libata-eh.c                            |   1 +
 drivers/ata/libata-scsi.c                          |   6 +-
 drivers/ata/sata_promise.c                         |  15 +-
 drivers/base/regmap/regmap-debugfs.c               |   2 +-
 drivers/bcma/driver_mips.c                         |   2 +-
 drivers/block/aoe/aoe.h                            |   2 +-
 drivers/block/aoe/aoeblk.c                         |   5 -
 drivers/block/rbd.c                                | 293 +++++++--------------
 drivers/firewire/net.c                             |  13 +-
 drivers/gpu/drm/drm_edid.c                         |  22 +-
 drivers/gpu/drm/i915/i915_drv.c                    |  10 +
 drivers/gpu/drm/i915/i915_drv.h                    |  11 +-
 drivers/gpu/drm/i915/i915_gem.c                    |   4 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  44 ++--
 drivers/gpu/drm/i915/i915_reg.h                    |  23 +-
 drivers/gpu/drm/i915/intel_bios.c                  |  36 +++
 drivers/gpu/drm/i915/intel_display.c               | 190 +++++++------
 drivers/gpu/drm/i915/intel_hdmi.c                  |  11 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   8 -
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  22 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |  30 ++-
 drivers/gpu/drm/nouveau/nv04_dfp.c                 |   2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |   6 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   2 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   1 +
 drivers/gpu/drm/radeon/radeon_connectors.c         |  10 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  13 +-
 drivers/gpu/drm/radeon/radeon_i2c.c                |  10 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |   8 +
 drivers/gpu/drm/radeon/radeon_mode.h               |   2 +-
 drivers/gpu/drm/udl/udl_connector.c                |  17 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/usbhid/hid-quirks.c                    |   1 +
 drivers/hwmon/lm73.c                               |  16 +-
 drivers/infiniband/hw/nes/nes.h                    |   1 +
 drivers/infiniband/hw/nes/nes_hw.c                 |   9 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |   9 +-
 drivers/iommu/intel-iommu.c                        |  11 +-
 drivers/md/dm-ioctl.c                              |   8 +
 drivers/md/persistent-data/dm-btree-internal.h     |  16 +-
 drivers/md/persistent-data/dm-btree-remove.c       |  50 ++--
 drivers/md/persistent-data/dm-btree-spine.c        |   6 +-
 drivers/md/persistent-data/dm-btree.c              |  22 +-
 drivers/mfd/mfd-core.c                             |  15 +-
 drivers/mfd/wm8994-core.c                          |   1 +
 drivers/mtd/nand/cs553x_nand.c                     |   3 +-
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |   9 +
 drivers/net/wimax/i2400m/i2400m-usb.h              |   3 +
 drivers/net/wimax/i2400m/usb.c                     |   6 +
 drivers/net/wireless/ath/ath5k/base.c              |   4 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   2 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   | 172 ++++++------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |   6 +-
 drivers/net/wireless/ath/ath9k/calib.c             |   1 +
 drivers/net/wireless/ath/ath9k/calib.h             |   3 +
 drivers/net/wireless/b43/b43.h                     |   5 +
 drivers/net/wireless/b43/main.c                    |  54 +++-
 drivers/net/wireless/b43/main.h                    |   5 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |  21 +-
 drivers/platform/x86/samsung-laptop.c              |  10 +
 drivers/regulator/wm831x-dcdc.c                    |   2 +-
 drivers/s390/cio/device_pgid.c                     |  10 +-
 drivers/scsi/mvsas/mv_94xx.h                       |  14 +-
 drivers/scsi/mvsas/mv_sas.c                        |   2 +-
 drivers/scsi/mvsas/mv_sas.h                        |   2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   4 +-
 drivers/scsi/scsi_sysfs.c                          |  11 +-
 drivers/staging/comedi/Kconfig                     |   1 +
 drivers/staging/comedi/comedi_fops.c               |  21 ++
 drivers/staging/comedi/comedidev.h                 |   1 +
 drivers/staging/comedi/drivers.c                   |  34 +--
 drivers/staging/comedi/drivers/comedi_test.c       |   2 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |  16 +-
 drivers/staging/comedi/internal.h                  |   1 +
 drivers/staging/rtl8712/usb_intf.c                 |   2 +
 drivers/staging/speakup/synth.c                    |   4 +-
 drivers/staging/vt6656/dpc.c                       |   4 +-
 drivers/staging/vt6656/key.c                       |  53 ++--
 drivers/staging/vt6656/key.h                       |   8 +-
 drivers/staging/vt6656/mac.c                       |   6 +-
 drivers/staging/vt6656/rf.c                        |   3 +
 drivers/staging/vt6656/rxtx.c                      |  18 +-
 drivers/staging/vt6656/ttype.h                     |  16 +-
 drivers/staging/vt6656/wcmd.c                      |  20 +-
 drivers/staging/vt6656/wpa2.h                      |   4 +-
 drivers/target/iscsi/iscsi_target.c                |   2 +-
 drivers/target/tcm_fc/tfc_sess.c                   |   2 +-
 drivers/usb/class/cdc-acm.c                        |   3 +
 drivers/usb/core/hub.c                             | 120 +++++++--
 drivers/usb/core/message.c                         |  53 ++--
 drivers/usb/gadget/dummy_hcd.c                     |   9 +-
 drivers/usb/host/xhci-hub.c                        |  38 ++-
 drivers/usb/host/xhci-mem.c                        |   2 +
 drivers/usb/host/xhci-ring.c                       |   9 +
 drivers/usb/host/xhci.c                            |  10 +
 drivers/usb/musb/musb_core.c                       |   5 +-
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   6 +
 drivers/usb/serial/option.c                        |  18 +-
 drivers/video/mxsfb.c                              |   3 +-
 fs/ceph/addr.c                                     |  17 +-
 fs/ceph/caps.c                                     |  16 +-
 fs/ceph/file.c                                     |   4 +-
 fs/ceph/inode.c                                    |  30 ++-
 fs/ceph/mds_client.c                               |  10 +-
 fs/ceph/super.c                                    |   2 -
 fs/eventpoll.c                                     |  22 +-
 fs/ext4/acl.c                                      |   6 +-
 fs/ext4/extents.c                                  |  22 +-
 fs/ext4/ialloc.c                                   |   2 +-
 fs/ext4/super.c                                    |  26 +-
 fs/gfs2/lops.c                                     |  18 +-
 fs/gfs2/trans.c                                    |   8 +
 fs/jbd2/transaction.c                              |   3 +-
 fs/jffs2/nodemgmt.c                                |   6 +-
 fs/udf/inode.c                                     |  11 +-
 include/linux/ceph/libceph.h                       |   2 -
 kernel/trace/ring_buffer.c                         |   7 +-
 mm/compaction.c                                    |   6 +-
 mm/huge_memory.c                                   |   3 +
 mm/memory.c                                        |  18 +-
 mm/page_alloc.c                                    |   2 +-
 net/ceph/ceph_common.c                             |   3 +-
 net/ceph/messenger.c                               |  72 ++---
 net/ceph/osd_client.c                              | 108 +++-----
 net/ceph/osdmap.c                                  |  31 ++-
 net/mac80211/ibss.c                                |   9 +-
 net/mac80211/ieee80211_i.h                         |   6 +-
 net/mac80211/scan.c                                |  34 ++-
 net/mac80211/sta_info.c                            |   2 +-
 net/sunrpc/clnt.c                                  |   2 +-
 net/sunrpc/rpc_pipe.c                              |   7 +-
 net/sunrpc/sched.c                                 |  30 ++-
 net/sunrpc/xprt.c                                  |  12 +-
 sound/arm/pxa2xx-ac97-lib.c                        |  26 +-
 sound/soc/codecs/sigmadsp.c                        |   2 +-
 sound/soc/codecs/wm2000.c                          |   4 +-
 sound/soc/codecs/wm2200.c                          |   8 +-
 sound/soc/codecs/wm5100.c                          |   6 -
 virt/kvm/kvm_main.c                                |  13 +-
 152 files changed, 1520 insertions(+), 985 deletions(-)


