Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3BANG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:06:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:44155 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab3BANGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:06:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/89] 3.7.6-stable review
Date: Fri,  1 Feb 2013 14:07:15 +0100
Message-Id: <20130201130207.444989281@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.7.6 release.
There are 89 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Feb  3 13:01:49 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.7.6-rc1

CAI Qian <caiqian@redhat.com>
    slub: assign refcount for kmalloc_caches

Jani Nikula <jani.nikula@intel.com>
    drm/i915: fix FORCEWAKE posting reads

Jesper Juhl <jj@chaosbits.net>
    netfilter: ctnetlink: fix leak in error path of ctnetlink_create_expect

Jan Engelhardt <jengelh@inai.de>
    netfilter: x_tables: print correct hook names for ARP

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack: fix BUG_ON while removing nf_conntrack with netns

Eric Dumazet <edumazet@google.com>
    netfilter: xt_recent: avoid high order page allocations

Vitaly E. Lavrov <lve@guap.ru>
    netfilter: xt_recent: fix namespace destroy path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xt_hashlimit: fix race that results in duplicated entries

Vitaly E. Lavrov <lve@guap.ru>
    netfilter: xt_hashlimit: fix namespace destroy path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: fix missing dependencies for the NOTRACK target

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xt_CT: recover NOTRACK target support

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink_log: fix possible compilation issue due to missing include

Bob Hockney <bhockney@ix.netcom.com>
    netfilter: nfnetlink_log: fix mac address for 6in4 tunnels

Nicholas Bellinger <nab@linux-iscsi.org>
    target: fix regression with dev_link_magic in target_fabric_port_link

Dave Chinner <dchinner@redhat.com>
    xfs: fix periodic log flushing

H. Peter Anvin <hpa@linux.intel.com>
    x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI

Haibo Xi <haibbo@gmail.com>
    netfilter: nf_ct_reasm: fix conntrack reassembly expire code

Mukund Jampala <jbmukund@gmail.com>
    netfilter: ip[6]t_REJECT: fix wrong transport header pointer in TCP reset

Alex Williamson <alex.williamson@redhat.com>
    kvm: Fix irqfd resampler list walk

Ilija Hadzic <ihadzic@research.bell-labs.com>
    drm/radeon: fix a rare case of double kfree

Ilija Hadzic <ihadzic@research.bell-labs.com>
    drm/radeon: fix error path in kpage allocation

Dave Chinner <dchinner@redhat.com>
    xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end

Matt Fleming <matt.fleming@intel.com>
    x86, efi: Set runtime_version to the EFI spec revision

Nathan Zimmer <nzimmer@sgi.com>
    efi, x86: Pass a proper identity mapping in efi_call_phys_prelog

David Woodhouse <David.Woodhouse@intel.com>
    x86, efi: Fix 32-bit EFI handover protocol entry point

David Woodhouse <David.Woodhouse@intel.com>
    x86, efi: Fix display detection in EFI boot stub

Matt Fleming <matt.fleming@intel.com>
    samsung-laptop: Disable on EFI hardware

Matt Fleming <matt.fleming@intel.com>
    efi: Make 'efi_enabled' a function to query EFI facilities

Alan Cox <alan@linux.intel.com>
    x86/msr: Add capabilities check

Wang YanQing <udknight@gmail.com>
    smp: Fix SMP function call empty cpu mask race

Nicholas Santos <nicholas.santos@gmail.com>
    HID: usbhid: quirk for Formosa IR receiver

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4.1: Handle NFS4ERR_DELAY when resetting the NFSv4.1 session

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4.1: Ensure that nfs41_walk_client_list() does start lease recovery

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Fix NFSv4 trunking discovery

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Fix NFSv4 reference counting for trunked sessions

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Don't silently fail setattr() requests on mountpoints

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Fix error reporting in nfs_xdev_mount

Daniel Vetter <daniel.vetter@ffwll.ch>
    iommu/intel: disable DMAR for g4x integrated gfx

Anderson Lizardo <anderson.lizardo@openbossa.org>
    Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()

Chris Rattray <crattray@opensource.wolfsonmicro.com>
    ASoC: wm2200: correct mixer values and text

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: arizona: Use actual rather than desired BCLK when calculating LRCLK

Dan Carpenter <dan.carpenter@oracle.com>
    EDAC: Test correct variable in ->store function

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix non-snoop page handling

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - fix inverted internal mic on Acer AOA150/ZG5

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add a fixup for Packard-Bell desktop with ALC880

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: fix invalid length check for RME and other UAC 2 devices

Felix Fietkau <nbd@openwrt.org>
    ath9k: allow setting arbitrary antenna masks on AR9003+

Felix Fietkau <nbd@openwrt.org>
    ath9k_hw: fix chain swap setting when setting rx chainmask to 5

Felix Fietkau <nbd@openwrt.org>
    ath9k: disable the tasklet before taking the PCU lock

Felix Fietkau <nbd@openwrt.org>
    ath9k: remove sc->rx.rxbuflock to fix a deadlock

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix rx flush handling

Felix Fietkau <nbd@openwrt.org>
    ath9k: add a better fix for the rx tasklet vs rx flush race

Felix Fietkau <nbd@openwrt.org>
    ath9k: remove the WARN_ON that triggers if generating a beacon fails

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix double-free bug on beacon generate failure

Felix Fietkau <nbd@openwrt.org>
    ath9k: do not link receive buffers during flush

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k_htc: Fix memory leak

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix FT roaming

Stanislaw Gruszka <sgruszka@redhat.com>
    mac80211: synchronize scan off/on-channel and PS states

Jonathan Brassow <jbrassow@redhat.com>
    DM-RAID: Fix RAID10's check for sufficient redundancy

Piotr Haber <phaber@broadcom.com>
    brcmsmac: handle packet drop during transmit correctly

Piotr Haber <phaber@broadcom.com>
    brcmsmac: increase timer reference count for new timers only

Stanislaw Gruszka <sgruszka@redhat.com>
    iwlegacy: fix IBSS cleanup

Avinash Patil <patila@marvell.com>
    mwifiex: fix typo in PCIe adapter NULL check

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: update config_bands during infra association

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: dump UTS_RELEASE into the error_state

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: GFX_MODE Flush TLB Invalidate Mode must be '1' for scanline waits

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Disable AsyncFlip performance optimisations

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    s390/thp: implement pmdp_set_wrprotect()

Jan Kara <jack@suse.cz>
    xfs: Fix possible use-after-free with AIO

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround

xueminsu <xuemin.su@intel.com>
    radeon_display: Use pointer return error codes

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: fix cursor corruption on DCE6 and newer

Szymon Janc <szymon.janc@tieto.com>
    Bluetooth: Fix sending HCI commands after reset

Linus Walleij <linus.walleij@stericsson.com>
    mfd: tc3589x: Use simple irqdomain

Marc Zyngier <marc.zyngier@arm.com>
    ARM: virt: simplify __hyp_stub_install epilog

Marc Zyngier <marc.zyngier@arm.com>
    ARM: virt: boot secondary CPUs through the right entry point

Dave Martin <dave.martin@linaro.org>
    ARM: virt: Avoid bx instruction for compatibility with <=ARMv4

Nicolas Pitre <nicolas.pitre@linaro.org>
    ARM: 7628/1: head.S: map one extra section for the ATAG/DTB area

Stephen Boyd <sboyd@codeaurora.org>
    ARM: 7627/1: Predicate preempt logic on PREEMP_COUNT not PREEMPT alone

Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
    ARM: S3C64XX: Fix up IRQ mapping for balblair on Cragganmore

Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
    ARM: at91: rm9200: remake the BGA as default version

Luciano Coelho <coelho@ti.com>
    ARM: OMAP2+: omap4-panda: add UART2 muxing for WiLink shared transport

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: DMA: Fix struct page iterator in dma_cache_maint() to work with sparsemem

Tiejun Chen <tiejun.chen@windriver.com>
    powerpc/book3e: Disable interrupt after preempt_schedule_irq

Alexander Graf <agraf@suse.de>
    KVM: PPC: Emulate dcbf

Cong Ding <dinggnu@gmail.com>
    fs/cifs/cifs_dfs_ref.c: fix potential memory leakage

Olivier Sobrie <olivier@sobrie.be>
    can: pch_can: fix invalid error codes

Olivier Sobrie <olivier@sobrie.be>
    can: ti_hecc: fix invalid error codes

Olivier Sobrie <olivier@sobrie.be>
    can: c_can: fix invalid error codes


-------------

Diffstat:

 Documentation/device-mapper/dm-raid.txt            |   1 +
 Makefile                                           |   4 +-
 arch/arm/kernel/head.S                             |   5 +-
 arch/arm/kernel/hyp-stub.S                         |  18 ++--
 arch/arm/mach-at91/setup.c                         |   2 +
 arch/arm/mach-omap2/board-omap4panda.c             |   6 ++
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |   2 +-
 arch/arm/mm/dma-mapping.c                          |  18 ++--
 arch/arm/vfp/entry.S                               |   6 +-
 arch/arm/vfp/vfphw.S                               |   4 +-
 arch/powerpc/kernel/entry_64.S                     |  13 +++
 arch/powerpc/kvm/emulate.c                         |   2 +
 arch/s390/include/asm/pgtable.h                    |  12 +++
 arch/x86/boot/compressed/eboot.c                   |   3 +-
 arch/x86/boot/compressed/head_32.S                 |   2 +
 arch/x86/include/asm/efi.h                         |   1 +
 arch/x86/kernel/msr.c                              |   3 +
 arch/x86/kernel/reboot.c                           |   2 +-
 arch/x86/kernel/setup.c                            |  30 +++---
 arch/x86/platform/efi/efi.c                        |  59 +++++++-----
 arch/x86/platform/efi/efi_64.c                     |  22 ++++-
 drivers/acpi/osl.c                                 |   2 +-
 drivers/edac/edac_pci_sysfs.c                      |   2 +-
 drivers/firmware/dmi_scan.c                        |   2 +-
 drivers/firmware/efivars.c                         |   4 +-
 drivers/firmware/iscsi_ibft_find.c                 |   2 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |   2 +
 drivers/gpu/drm/i915/i915_reg.h                    |   1 +
 drivers/gpu/drm/i915/intel_pm.c                    |  15 ++-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  24 +++--
 drivers/gpu/drm/radeon/radeon_cs.c                 |   6 +-
 drivers/gpu/drm/radeon/radeon_cursor.c             |   3 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   3 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   2 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/usbhid/hid-quirks.c                    |   1 +
 drivers/iommu/amd_iommu_init.c                     |  34 +++++++
 drivers/iommu/intel-iommu.c                        |  21 +++--
 drivers/md/dm-raid.c                               | 101 ++++++++-------------
 drivers/mfd/tc3589x.c                              |  17 +---
 drivers/net/can/c_can/c_can.c                      |   4 +-
 drivers/net/can/pch_can.c                          |   2 +-
 drivers/net/can/ti_hecc.c                          |   4 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  25 ++---
 drivers/net/wireless/ath/ath9k/ath9k.h             |   3 -
 drivers/net/wireless/ath/ath9k/beacon.c            |   2 +-
 drivers/net/wireless/ath/ath9k/debug.c             |   1 -
 drivers/net/wireless/ath/ath9k/debug.h             |   2 -
 drivers/net/wireless/ath/ath9k/htc_hst.c           |   2 +
 drivers/net/wireless/ath/ath9k/main.c              |  22 ++---
 drivers/net/wireless/ath/ath9k/recv.c              |  54 +++--------
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  11 ++-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  14 ++-
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |   2 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |   2 +-
 drivers/net/wireless/iwlegacy/common.c             |  35 +++----
 drivers/net/wireless/mwifiex/cfg80211.c            |  15 +--
 drivers/net/wireless/mwifiex/pcie.c                |   2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |  14 +++
 drivers/platform/x86/ibm_rtl.c                     |   2 +-
 drivers/platform/x86/samsung-laptop.c              |   4 +
 drivers/scsi/isci/init.c                           |   2 +-
 drivers/target/target_core_fabric_configfs.c       |  11 +--
 fs/cifs/cifs_dfs_ref.c                             |   2 +
 fs/nfs/namespace.c                                 |  20 ++++
 fs/nfs/nfs4client.c                                |  62 ++++++-------
 fs/nfs/nfs4state.c                                 |  22 +++--
 fs/nfs/super.c                                     |  22 ++---
 fs/xfs/xfs_aops.c                                  |   2 +-
 fs/xfs/xfs_buf.c                                   |  18 ++++
 fs/xfs/xfs_sync.c                                  |   2 +-
 include/linux/efi.h                                |  24 +++--
 include/net/netfilter/nf_conntrack_core.h          |   2 +
 include/net/netns/x_tables.h                       |   1 +
 init/main.c                                        |   4 +-
 kernel/smp.c                                       |  13 ++-
 mm/slub.c                                          |   1 +
 net/bluetooth/hci_event.c                          |   2 +-
 net/bluetooth/hidp/core.c                          |   2 +-
 net/ipv4/netfilter/ipt_REJECT.c                    |   1 +
 net/ipv6/netfilter/ip6t_REJECT.c                   |   1 +
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   5 +-
 net/mac80211/cfg.c                                 |  12 ++-
 net/mac80211/ieee80211_i.h                         |   6 +-
 net/mac80211/offchannel.c                          |  19 ++--
 net/mac80211/scan.c                                |  15 +--
 net/netfilter/Kconfig                              |   7 ++
 net/netfilter/nf_conntrack_core.c                  |   9 +-
 net/netfilter/nf_conntrack_netlink.c               |   2 +-
 net/netfilter/nf_conntrack_standalone.c            |   1 +
 net/netfilter/nfnetlink_log.c                      |  16 +++-
 net/netfilter/x_tables.c                           |  28 ++++--
 net/netfilter/xt_CT.c                              |  50 +++++++++-
 net/netfilter/xt_hashlimit.c                       |  54 +++++++++--
 net/netfilter/xt_recent.c                          |  43 +++++++--
 sound/pci/hda/hda_intel.c                          |  40 +++++---
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/codecs/arizona.c                         |   2 +-
 sound/soc/codecs/wm2200.c                          |   3 -
 sound/usb/mixer.c                                  |  17 +++-
 virt/kvm/eventfd.c                                 |   2 +-
 101 files changed, 755 insertions(+), 474 deletions(-)


