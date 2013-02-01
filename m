Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161172Ab3BAKtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:49:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:38828 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161153Ab3BAKs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:48:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/33] 3.4.29-stable review
Date: Fri,  1 Feb 2013 11:49:05 +0100
Message-Id: <20130201104724.605715763@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.29 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Feb  3 10:47:08 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.29-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.29-rc1

Nicholas Bellinger <nab@linux-iscsi.org>
    target: fix regression with dev_link_magic in target_fabric_port_link

H. Peter Anvin <hpa@linux.intel.com>
    x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI

Matt Fleming <matt.fleming@intel.com>
    x86, efi: Set runtime_version to the EFI spec revision

Nathan Zimmer <nzimmer@sgi.com>
    efi, x86: Pass a proper identity mapping in efi_call_phys_prelog

Alan Cox <alan@linux.intel.com>
    x86/msr: Add capabilities check

Wang YanQing <udknight@gmail.com>
    smp: Fix SMP function call empty cpu mask race

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Don't silently fail setattr() requests on mountpoints

Stanislaw Gruszka <sgruszka@redhat.com>
    mac80211: synchronize scan off/on-channel and PS states

Daniel Vetter <daniel.vetter@ffwll.ch>
    iommu/intel: disable DMAR for g4x integrated gfx

Anderson Lizardo <anderson.lizardo@openbossa.org>
    Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()

Chris Rattray <crattray@opensource.wolfsonmicro.com>
    ASoC: wm2200: correct mixer values and text

Dan Carpenter <dan.carpenter@oracle.com>
    EDAC: Test correct variable in ->store function

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add a fixup for Packard-Bell desktop with ALC880

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: fix invalid length check for RME and other UAC 2 devices

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix double-free bug on beacon generate failure

Felix Fietkau <nbd@openwrt.org>
    ath9k: do not link receive buffers during flush

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k_htc: Fix memory leak

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix FT roaming

Piotr Haber <phaber@broadcom.com>
    brcmsmac: increase timer reference count for new timers only

Stanislaw Gruszka <sgruszka@redhat.com>
    iwlegacy: fix IBSS cleanup

Avinash Patil <patila@marvell.com>
    mwifiex: fix typo in PCIe adapter NULL check

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

Stephen Boyd <sboyd@codeaurora.org>
    ARM: 7627/1: Predicate preempt logic on PREEMP_COUNT not PREEMPT alone

Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
    ARM: at91: rm9200: remake the BGA as default version

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: DMA: Fix struct page iterator in dma_cache_maint() to work with sparsemem

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

 Makefile                                           |  4 +--
 arch/arm/mach-at91/setup.c                         |  2 ++
 arch/arm/mm/dma-mapping.c                          | 18 ++++++-----
 arch/arm/vfp/entry.S                               |  6 ++--
 arch/arm/vfp/vfphw.S                               |  4 +--
 arch/x86/kernel/msr.c                              |  3 ++
 arch/x86/kernel/setup.c                            |  2 ++
 arch/x86/platform/efi/efi.c                        |  2 +-
 arch/x86/platform/efi/efi_64.c                     | 22 ++++++++++----
 drivers/edac/edac_pci_sysfs.c                      |  2 +-
 drivers/gpu/drm/radeon/radeon_cursor.c             |  3 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  2 +-
 drivers/iommu/amd_iommu_init.c                     | 34 +++++++++++++++++++++
 drivers/iommu/intel-iommu.c                        | 21 +++++++++----
 drivers/net/can/c_can/c_can.c                      |  4 +--
 drivers/net/can/pch_can.c                          |  2 +-
 drivers/net/can/ti_hecc.c                          |  4 +--
 drivers/net/wireless/ath/ath9k/beacon.c            |  1 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |  2 ++
 drivers/net/wireless/ath/ath9k/recv.c              | 10 ++++---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  7 +++--
 drivers/net/wireless/iwlegacy/common.c             | 35 +++++++++-------------
 drivers/net/wireless/mwifiex/pcie.c                |  2 +-
 drivers/target/target_core_fabric_configfs.c       | 11 ++++---
 fs/cifs/cifs_dfs_ref.c                             |  2 ++
 fs/nfs/namespace.c                                 | 20 +++++++++++++
 fs/xfs/xfs_aops.c                                  |  2 +-
 kernel/smp.c                                       | 13 +++++++-
 net/bluetooth/hci_event.c                          |  2 +-
 net/bluetooth/hidp/core.c                          |  2 +-
 net/mac80211/cfg.c                                 | 12 +++++++-
 net/mac80211/ieee80211_i.h                         |  6 ++--
 net/mac80211/offchannel.c                          | 17 ++++-------
 net/mac80211/scan.c                                | 15 ++++------
 net/mac80211/work.c                                |  4 +--
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/soc/codecs/wm2200.c                          |  3 --
 sound/usb/mixer.c                                  | 17 +++++++----
 38 files changed, 209 insertions(+), 110 deletions(-)


