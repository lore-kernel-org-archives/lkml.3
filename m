Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927Ab3CLXAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:00:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab3CLWoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/40] 3.4.36-stable review
Date: Tue, 12 Mar 2013 15:43:21 -0700
Message-Id: <20130312223211.492954675@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.36 release.
There are 40 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Mar 14 22:31:37 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.36-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.36-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ALSA: hda - hdmi: Make jacks phantom, if they're not detectable"

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Rip out recursive call on warm port reset.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Prepare for refactoring by adding extra udev checks.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    USB: Don't use EHCI port sempahore for USB 3.0 hubs.

Ben Hutchings <ben@decadent.org.uk>
    dmi_scan: fix missing check for _DMI_ signature in smbios_present()

Steven Rostedt <srostedt@redhat.com>
    ftrace: Update the kconfig for DYNAMIC_FTRACE

Tu, Xiaobing <xiaobing.tu@intel.com>
    Fix memory leak in cpufreq stats.

Andrew Lunn <andrew@lunn.ch>
    rtc: rtc-mv: Add support for clk to avoid lockups

Al Viro <viro@ZenIV.linux.org.uk>
    vfs: fix pipe counter breakage

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Fix: compat_rw_copy_check_uvector() misuse in aio, readv, writev, and security keys

David Howells <dhowells@redhat.com>
    keys: fix race with concurrent install_user_keyrings()

Mathias Krause <minipli@googlemail.com>
    crypto: user - fix info leaks in report API

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pat: Disable PAT using pat_enabled value.

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: logitech-dj: do not directly call hid_output_raw_report() during probe

Konstantin Khlebnikov <khlebnikov@openvz.org>
    e1000e: fix pci-device enable-counter balance

Takashi Iwai <tiwai@suse.de>
    ALSA: vmaster: Fix slave change notification

Sean Connor <sconnor004@allyinics.org>
    ALSA: ice1712: Initialize card->private_data properly

Will Deacon <will.deacon@arm.com>
    ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK to include NSH bit

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add primary dac adj quirk for R200 board

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/ltc2978) Use detected chip ID to select supported functionality

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/ltc2978) Fix peak attribute handling

Mark Brown <broonie@opensource.wolfsonmicro.com>
    hwmon: (sht15) Check return value of regulator_enable()

NeilBrown <neilb@suse.de>
    md: raid0: fix error return from create_stripe_zones.

NeilBrown <neilb@suse.de>
    md: fix two bugs when attempting to resize RAID0 array.

Sebastian Riemer <sebastian.riemer@profitbricks.com>
    md: protect against crash upon fsync on ro array

Felix Fietkau <nbd@openwrt.org>
    ath9k_hw: improve reset reliability after errors

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix RSSI dummy marker value

Avinash Patil <patila@marvell.com>
    mwifiex: correct sleep delay counter

Rusty Russell <rusty@rustcorp.com.au>
    hw_random: make buffer usable in scatterlist.

Olaf Hering <olaf@aepfle.de>
    ata_piix: reenable MS Virtual PC guests

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Don't start the retransmission timer when out of socket space

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Don't allow NFS silly-renamed files to be deleted, no signal

Jeff Layton <jlayton@redhat.com>
    cifs: ensure that cifs_get_root() only traverses directories

Thomas Gleixner <tglx@linutronix.de>
    btrfs: Init io_lock after cloning btrfs device struct

Asias He <asias@redhat.com>
    target/pscsi: Fix page increment

K. Y. Srinivasan <kys@microsoft.com>
    SCSI: storvsc: Initialize the sglist

Dan Carpenter <dan.carpenter@oracle.com>
    SCSI: dc395x: uninitialized variable in device_alloc()

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pci: We don't do multiple MSI's.

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: fix scheduling while atomic warning in alignment handling code

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: VFP: fix emulation of second VFP instruction


-------------

Diffstat:

 Makefile                                   |   4 +-
 arch/arm/boot/dts/kirkwood.dtsi            |   1 +
 arch/arm/kernel/perf_event_v7.c            |   2 +-
 arch/arm/mm/alignment.c                    |  11 +--
 arch/arm/vfp/vfpmodule.c                   |   2 +-
 arch/x86/pci/xen.c                         |   9 ++
 arch/x86/xen/enlighten.c                   |  10 +-
 crypto/ablkcipher.c                        |  12 +--
 crypto/aead.c                              |   9 +-
 crypto/ahash.c                             |   2 +-
 crypto/blkcipher.c                         |   6 +-
 crypto/crypto_user.c                       |  22 ++---
 crypto/pcompress.c                         |   3 +-
 crypto/rng.c                               |   2 +-
 crypto/shash.c                             |   3 +-
 drivers/ata/ata_piix.c                     |  25 ++++-
 drivers/char/hw_random/core.c              |  19 +++-
 drivers/cpufreq/cpufreq_stats.c            |   1 +
 drivers/firmware/dmi_scan.c                |   5 +-
 drivers/gpu/drm/radeon/radeon_combios.c    |   9 ++
 drivers/hid/hid-logitech-dj.c              |  22 +++--
 drivers/hwmon/pmbus/ltc2978.c              |  30 +++---
 drivers/hwmon/sht15.c                      |   8 +-
 drivers/md/md.c                            |   7 ++
 drivers/md/raid0.c                         |   5 +-
 drivers/net/ethernet/intel/e1000e/netdev.c |   2 +-
 drivers/net/wireless/ath/ath9k/common.h    |   2 +-
 drivers/net/wireless/ath/ath9k/hw.c        |   4 +-
 drivers/net/wireless/mwifiex/pcie.c        |   2 +-
 drivers/rtc/rtc-mv.c                       |  28 +++++-
 drivers/scsi/dc395x.c                      |   2 +-
 drivers/scsi/storvsc_drv.c                 |   1 +
 drivers/target/target_core_pscsi.c         |   1 -
 drivers/usb/core/hub.c                     | 148 ++++++++++++++---------------
 fs/btrfs/volumes.c                         |   1 +
 fs/cifs/cifsfs.c                           |   5 +
 fs/compat.c                                |  15 ++-
 fs/nfs/unlink.c                            |  20 ++--
 fs/pipe.c                                  |   3 +
 kernel/trace/Kconfig                       |  24 +++--
 mm/process_vm_access.c                     |   8 --
 net/sunrpc/xprt.c                          |   6 +-
 security/keys/compat.c                     |   4 +-
 security/keys/process_keys.c               |   2 +-
 sound/core/vmaster.c                       |   5 +-
 sound/pci/hda/patch_hdmi.c                 |   3 -
 sound/pci/ice1712/ice1712.c                |   2 +
 47 files changed, 311 insertions(+), 206 deletions(-)


