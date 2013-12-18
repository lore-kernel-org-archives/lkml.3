Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab3LRWOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:14:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3LRVLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:11:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/78] 3.10.25-stable review
Date: Wed, 18 Dec 2013 13:10:28 -0800
Message-Id: <20131218211111.903835960@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.25 release.
There are 78 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Dec 20 21:10:56 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.25-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.25-rc1

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: do not run snapshot-aware defragment on error

Filipe David Borba Manana <fdmanana@gmail.com>
    Btrfs: fix incorrect inode acl reset

Josef Bacik <jbacik@fusionio.com>
    Btrfs: fix hole check in log_one_extent

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: fix memory leak of chunks' extent map

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST"

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip6tnl: fix use after free of fb_tnl_dev

Andy Adamson <andros@netapp.com>
    NFSv4 wait on recovery for async session errors

Alan <gnomes@lxorguk.ukuu.org.uk>
    sc1200_wdt: Fix oops

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: ssv_dnp: use comedi_dio_update_state()

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: drivers: use comedi_dio_update_state() for simple cases

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: pcmuio: fix possible NULL deref on detach

Ben Segall <bsegall@google.com>
    sched: Avoid throttle_cfs_rq() racing with period_timer stopping

Hans Verkuil <hans.verkuil@cisco.com>
    cxd2820r_core: fix sparse warnings

Helge Deller <deller@gmx.de>
    nfs: fix do_div() warning by instead using sector_div()

Joe Thornber <ejt@redhat.com>
    dm thin: switch to read only mode if a mapping insert fails

Mikulas Patocka <mpatocka@redhat.com>
    dm table: fail dm_table_create on dm_round_up overflow

Mike Snitzer <snitzer@redhat.com>
    dm space map metadata: return on failure in sm_metadata_new_block

Mikulas Patocka <mpatocka@redhat.com>
    dm delay: fix a possible deadlock due to shared workqueue

Joe Thornber <ejt@redhat.com>
    dm array: fix a reference counting bug in shadow_ablock

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: avoid snapshot space leak on crash

Mikulas Patocka <mpatocka@redhat.com>
    dm bufio: initialize read-only module parameters

David Sterba <dsterba@suse.cz>
    btrfs: call mnt_drop_write after interrupted subvol deletion

Dan Carpenter <dan.carpenter@oracle.com>
    Btrfs: fix access_ok() check in btrfs_ioctl_send()

Dan Carpenter <dan.carpenter@oracle.com>
    media: af9035: unlock on error in af9035_i2c_master_xfer()

Antti Palosaari <crope@iki.fi>
    media: af9035: add [0413:6a05] Leadtek WinFast DTV Dongle Dual

Hans Verkuil <hans.verkuil@cisco.com>
    media: wm8775: fix broken audio routing

Antti Palosaari <crope@iki.fi>
    media: af9033: fix broken I2C

Hans Verkuil <hans.verkuil@cisco.com>
    media: bttv: don't setup the controls if there are no video devices

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    media: saa7164: fix return value check in saa7164_initdev()

H. Peter Anvin <hpa@linux.intel.com>
    x86, build, icc: Remove uninitialized_var() from compiler-intel.h

H. Peter Anvin <hpa@linux.intel.com>
    x86, build: Pass in additional -mno-mmx, -mno-sse options

Matthew Garrett <matthew.garrett@nebula.com>
    x86, efi: Don't use (U)EFI time services on 32 bit

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fixup bad vram size on SI

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: program DCE2 audio dto just like DCE3

Carolyn Wyborny <carolyn.wyborny@intel.com>
    igb: Fix for issue where values could be too high for udelay function.

Ujjal Roy <royujjal@gmail.com>
    mwifiex: fix memory leak issue for ibss join

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: check sta_id/drain values in debugfs

Johannes Berg <johannes.berg@intel.com>
    mac80211: don't attempt to reorder multicast frames

Bob Copeland <me@bobcopeland.com>
    Revert "mac80211: allow disable power save in mesh"

Paul Moore <pmoore@redhat.com>
    selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute()

Paul Moore <pmoore@redhat.com>
    selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Fix XLNA bias strength

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Fix QuickDrop usage

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix pipe CSC post offset calculation

Linus Pizunski <linus@narrativeteam.com>
    drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap

Hong H. Pham <hong.pham@windriver.com>
    powerpc: Fix PTE page address mismatch in pgtable ctor/dtor

Antti Palosaari <crope@iki.fi>
    media: af9035: fix broken I2C and USB I/O

Christian Engelmayer <christian.engelmayer@frequentis.com>
    Input: usbtouchscreen - separate report and transmit buffer size handling

Fangxiaozhi (Franko) <fangxiaozhi@huawei.com>
    USB: option: support new huawei devices

Gustavo Zacarias <gustavo@zacarias.com.ar>
    USB: serial: option: blacklist interface 1 for Huawei E173s-6

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: composite: reset delayed_status on reset_config

Alan Stern <stern@rowland.harvard.edu>
    usb: dwc3: fix implementation of endpoint wedge

Julius Werner <jwerner@chromium.org>
    usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED

Jeff Layton <jlayton@redhat.com>
    nfsd: when reusing an existing repcache entry, unhash it first

Linus Torvalds <torvalds@linux-foundation.org>
    futex: fix handling of read-only-mapped hugepages

Khalid Aziz <khalid.aziz@oracle.com>
    PCI: Disable Bus Master only on kexec reboot

Dan Carpenter <dan.carpenter@oracle.com>
    xfs: underflow bug in xfs_attrlist_by_handle()

Dave Chinner <dchinner@redhat.com>
    xfs: growfs overruns AGFL buffer on V4 filesystems

Jean Delvare <khali@linux-fr.org>
    hwmon: (w83l768ng) Fix fan speed control range

Brian Carnes <bmcarnes@gmail.com>
    hwmon: (w83l786ng) Fix fan speed control mode setting and reporting

José Miguel Gonçalves <jose.goncalves@inov.pt>
    hwmon: HIH-6130: Support I2C bus drivers without I2C_FUNC_SMBUS_QUICK

Dan Carpenter <dan.carpenter@oracle.com>
    hwmon: Prevent some divide by zeros in FAN_TO_REG()

Gleb Natapov <gleb@redhat.com>
    KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376)

Andy Honig <ahonig@google.com>
    KVM: x86: Convert vapic synchronization to _cached functions (CVE-2013-6368)

Andy Honig <ahonig@google.com>
    KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)

Andy Honig <ahonig@google.com>
    KVM: Improve create VCPU parameter (CVE-2013-4587)

Konstantin Khlebnikov <k.khlebnikov@samsung.com>
    ARM: 7913/1: fix framepointer check in unwind_frame

Konstantin Khlebnikov <k.khlebnikov@samsung.com>
    ARM: 7912/1: check stack pointer in get_wchan

Roger Quadros <rogerq@ti.com>
    ARM: OMAP3: hwmod data: Don't prevent RESET of USB Host module

Sergei Ianovich <ynvich@gmail.com>
    ARM: pxa: prevent PXA270 occasional reboot freezes

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
    ARM: pxa: tosa: fix keys mapping

Anssi Hannula <anssi.hannula@iki.fi>
    ALSA: hda - hdmi: Fix IEC958 ctl indexes for some simple HDMI devices

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Mute all aamix inputs as default

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add static DAC/pin mapping for AD1986A codec

Stefano Panella <stefano.panella@citrix.com>
    ALSA: memalloc.h - fix wrong truncation of dma_addr_t

Takashi Iwai <tiwai@suse.de>
    ALSA: compress: Fix 64bit ABI incompatibility

Mag <magissia@magissia.com>
    Input: xpad - add signature for Razer Onza Classic Edition

Jim Quinlan <jim2101024@gmail.com>
    MIPS: DMA: For BMIPS5000 cores flush region just like non-coherent R10000


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/kernel/process.c                          |   7 +-
 arch/arm/kernel/stacktrace.c                       |   2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  13 +--
 arch/arm/mach-pxa/reset.c                          |   8 +-
 arch/arm/mach-pxa/tosa.c                           | 102 ++++++++++-----------
 arch/mips/mm/dma-default.c                         |  16 ++--
 arch/powerpc/include/asm/pgalloc-32.h              |   6 +-
 arch/powerpc/include/asm/pgalloc-64.h              |   6 +-
 arch/x86/Makefile                                  |   8 +-
 arch/x86/boot/Makefile                             |   6 +-
 arch/x86/boot/compressed/Makefile                  |   1 +
 arch/x86/kvm/lapic.c                               |  35 ++++---
 arch/x86/kvm/lapic.h                               |   4 +-
 arch/x86/kvm/x86.c                                 |  40 +-------
 arch/x86/platform/efi/efi.c                        |   7 --
 arch/x86/realmode/rm/Makefile                      |   3 +-
 crypto/algif_hash.c                                |   3 -
 crypto/algif_skcipher.c                            |   3 -
 drivers/gpu/drm/i915/intel_display.c               |   2 +-
 drivers/gpu/drm/radeon/r600_hdmi.c                 |   8 +-
 drivers/gpu/drm/radeon/si.c                        |  11 ++-
 drivers/hwmon/hih6130.c                            |  16 +++-
 drivers/hwmon/lm78.c                               |   2 +
 drivers/hwmon/sis5595.c                            |   2 +
 drivers/hwmon/vt8231.c                             |   2 +-
 drivers/hwmon/w83l786ng.c                          |  13 ++-
 drivers/input/joystick/xpad.c                      |   1 +
 drivers/input/touchscreen/usbtouchscreen.c         |  22 ++++-
 drivers/md/dm-bufio.c                              |   5 +
 drivers/md/dm-delay.c                              |  23 +++--
 drivers/md/dm-snap.c                               |  71 ++++++++++++--
 drivers/md/dm-table.c                              |   5 +
 drivers/md/dm-thin.c                               |   4 +-
 drivers/md/persistent-data/dm-array.c              |  10 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   8 +-
 drivers/media/dvb-frontends/af9033.c               |  12 +--
 drivers/media/dvb-frontends/cxd2820r_core.c        |   4 +-
 drivers/media/i2c/wm8775.c                         |   4 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   3 +-
 drivers/media/pci/saa7164/saa7164-core.c           |   4 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |  17 ++--
 drivers/net/ethernet/intel/igb/e1000_phy.c         |   5 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |  22 +++--
 drivers/net/wireless/iwlwifi/mvm/debugfs.c         |   4 +
 drivers/net/wireless/mwifiex/sta_ioctl.c           |   4 +-
 drivers/pci/pci-driver.c                           |  12 ++-
 drivers/rtc/rtc-at91rm9200.c                       |   2 +
 drivers/staging/comedi/drivers/amplc_pc263.c       |   3 +
 drivers/staging/comedi/drivers/amplc_pci263.c      |   3 +
 drivers/staging/comedi/drivers/pcmuio.c            |  11 ++-
 drivers/staging/comedi/drivers/ssv_dnp.c           |   6 +-
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/dwc3/ep0.c                             |   2 +
 drivers/usb/dwc3/gadget.c                          |   5 +-
 drivers/usb/gadget/composite.c                     |   1 +
 drivers/usb/serial/option.c                        |  27 ++++++
 drivers/watchdog/sc1200wdt.c                       |   3 +-
 fs/btrfs/acl.c                                     |   2 +-
 fs/btrfs/inode.c                                   |  47 ++++++----
 fs/btrfs/ioctl.c                                   |   3 +-
 fs/btrfs/send.c                                    |   4 +-
 fs/btrfs/tree-log.c                                |   2 +-
 fs/btrfs/volumes.c                                 |   2 +
 fs/nfs/blocklayout/extents.c                       |   2 +-
 fs/nfs/nfs4proc.c                                  |   3 +-
 fs/nfsd/nfscache.c                                 |   9 +-
 fs/xfs/xfs_fsops.c                                 |   6 +-
 fs/xfs/xfs_ioctl.c                                 |   3 +-
 fs/xfs/xfs_ioctl32.c                               |   3 +-
 include/linux/compiler-intel.h                     |   2 -
 include/linux/kexec.h                              |   3 +
 include/sound/memalloc.h                           |   2 +-
 include/uapi/sound/compress_offload.h              |   6 +-
 kernel/futex.c                                     |   2 +-
 kernel/kexec.c                                     |   4 +
 kernel/sched/debug.c                               |   8 ++
 kernel/sched/fair.c                                |   2 +
 net/ipv4/udp.c                                     |   3 -
 net/ipv6/ip6_tunnel.c                              |   2 -
 net/mac80211/cfg.c                                 |   3 +-
 net/mac80211/rx.c                                  |   3 +-
 security/selinux/hooks.c                           |  93 +++++++++++++++----
 sound/pci/hda/hda_generic.c                        |  47 +++++++++-
 sound/pci/hda/hda_generic.h                        |   3 +
 sound/pci/hda/patch_analog.c                       |  10 ++
 sound/pci/hda/patch_hdmi.c                         |   5 +-
 virt/kvm/kvm_main.c                                |   3 +
 88 files changed, 608 insertions(+), 317 deletions(-)


