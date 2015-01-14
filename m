Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbbANHij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:38:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342AbbANHig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:38:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/44] 3.10.65-stable review
Date: Tue, 13 Jan 2015 23:23:21 -0800
Message-Id: <20150114072227.419663002@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.65 release.
There are 44 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan 16 07:22:13 UTC 2015.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.65-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.65-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    mm: Don't count the stack guard page towards RLIMIT_STACK

Linus Torvalds <torvalds@linux-foundation.org>
    mm: propagate error from stack expansion even for guard page

Vlastimil Babka <vbabka@suse.cz>
    mm, vmscan: prevent kswapd livelock due to pfmemalloc-throttled process being killed

Jiri Olsa <jolsa@kernel.org>
    perf session: Do not fail on processing out of order event

Jiri Olsa <jolsa@kernel.org>
    perf: Fix events installation during moving group

Jiri Olsa <jolsa@kernel.org>
    perf/x86/intel/uncore: Make sure only uncore events are collected

Chris Mason <clm@fb.com>
    Btrfs: don't delay inode ref updates during log replay

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: disable I/O coherency on non-SMP situations on Armada 370/375/38x/XP

Johannes Berg <johannes.berg@intel.com>
    scripts/kernel-doc: don't eat struct members with __aligned

Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
    nilfs2: fix the nilfs_iget() vs. nilfs_new_inode() races

Benjamin Coddington <bcodding@redhat.com>
    nfsd4: fix xdr4 inclusion of escaped char

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    fs: nfsd: Fix signedness bug in compare_blob

Robert Baldyga <r.baldyga@samsung.com>
    serial: samsung: wait for transfer completion before clock disable

Tejun Heo <tj@kernel.org>
    writeback: fix a subtle race condition in I_DIRTY clearing

Oliver Neukum <oneukum@suse.de>
    cdc-acm: memory leak in error case

Jens Axboe <axboe@fb.com>
    genhd: check for int overflow in disk_expand_part_tbl()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: cdc-acm: check for valid interfaces

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix wrong gpio_dir & gpio_mask hint setups for IDT/STAC codecs

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: hda - using uninitialized data

Jiri Jaburek <jjaburek@redhat.com>
    ALSA: usb-audio: extend KEF X300A FU 10 tweak to Arcam rPAC

Alex Williamson <alex.williamson@redhat.com>
    driver core: Fix unbalanced device reference in drivers_probe

Andy Lutomirski <luto@amacapital.net>
    x86, vdso: Use asm volatile in __getcpu

Andy Lutomirski <luto@amacapital.net>
    x86_64, vdso: Fix the vdso address randomization algorithm

Giedrius Statkevičius <giedrius.statkevicius@gmail.com>
    HID: Add a new id 0x501a for Genius MousePen i608X

Karl Relton <karllinuxtest.relton@ntlworld.com>
    HID: add battery quirk for USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO keyboard

Dan Carpenter <dan.carpenter@oracle.com>
    HID: roccat: potential out of bounds in pyra_sysfs_write_settings()

Gwendal Grignou <gwendal@chromium.org>
    HID: i2c-hid: prevent buffer overflow in early IRQ

Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
    HID: i2c-hid: fix race condition reading reports

Jiang Liu <jiang.liu@linux.intel.com>
    iommu/vt-d: Fix an off-by-one bug in __domain_mapping()

Richard Weinberger <richard@nod.at>
    UBI: Fix double free after do_sync_erase()

Richard Weinberger <richard@nod.at>
    UBI: Fix invalid vfree()

Tony Lindgren <tony@atomide.com>
    pstore-ram: Allow optional mapping with pgprot_noncached

Rob Herring <robherring2@gmail.com>
    pstore-ram: Fix hangs by using write-combine mappings

Myron Stowe <myron.stowe@redhat.com>
    PCI: Restore detection of read-only BARs

Andrew Jackson <Andrew.Jackson@arm.com>
    ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    ASoC: max98090: Fix ill-defined sidetone route

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: sigmadsp: Refuse to load firmware files with a non-supported version

Felix Fietkau <nbd@openwrt.org>
    ath5k: fix hardware queue index assignment

Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: fix memset() usage

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: fix cleanup sequence order in case of error during init

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix BE/BK queue order

Felix Fietkau <nbd@openwrt.org>
    ath9k_hw: fix hardware queue allocation

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: fix journal commit deadlock


-------------

Diffstat:

 Documentation/ramoops.txt                     | 13 ++++++--
 Makefile                                      |  4 +--
 arch/arm/mach-mvebu/coherency.c               | 23 ++++++++++++++
 arch/x86/include/asm/vsyscall.h               |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 22 ++++++++++++--
 arch/x86/vdso/vma.c                           | 43 ++++++++++++++++++---------
 block/genhd.c                                 | 11 +++++--
 drivers/base/bus.c                            |  8 +++--
 drivers/hid/hid-core.c                        |  1 +
 drivers/hid/hid-ids.h                         |  1 +
 drivers/hid/hid-input.c                       |  3 ++
 drivers/hid/hid-kye.c                         |  4 +++
 drivers/hid/hid-roccat-pyra.c                 |  8 +++--
 drivers/hid/i2c-hid/i2c-hid.c                 | 14 +++++----
 drivers/hid/usbhid/hid-quirks.c               |  1 +
 drivers/iommu/intel-iommu.c                   |  8 ++---
 drivers/mtd/ubi/upd.c                         | 10 ++++---
 drivers/mtd/ubi/wl.c                          | 10 ++-----
 drivers/net/can/usb/peak_usb/pcan_usb_core.c  | 17 ++++++-----
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c   |  3 +-
 drivers/net/wireless/ath/ath5k/qcu.c          |  8 +----
 drivers/net/wireless/ath/ath9k/hw.h           |  4 +--
 drivers/net/wireless/ath/ath9k/mac.c          |  9 +-----
 drivers/pci/probe.c                           |  3 ++
 drivers/tty/serial/samsung.c                  |  4 +++
 drivers/usb/class/cdc-acm.c                   | 10 ++++---
 drivers/xen/swiotlb-xen.c                     |  2 +-
 fs/btrfs/delayed-inode.c                      |  8 +++++
 fs/fs-writeback.c                             | 29 +++++++++++++-----
 fs/nfsd/nfs4state.c                           | 15 +++++-----
 fs/nfsd/nfs4xdr.c                             |  3 ++
 fs/nilfs2/inode.c                             | 32 +++++++++++++++-----
 fs/nilfs2/namei.c                             | 15 ++++++++--
 fs/ocfs2/aops.c                               | 16 ++++++++--
 fs/pstore/ram.c                               | 13 ++++++--
 fs/pstore/ram_core.c                          | 31 +++++++++++++------
 include/linux/mm.h                            |  2 +-
 include/linux/pstore_ram.h                    |  4 ++-
 kernel/events/core.c                          |  4 +--
 mm/memory.c                                   |  4 +--
 mm/mmap.c                                     |  7 +++--
 mm/vmscan.c                                   | 24 ++++++++-------
 scripts/kernel-doc                            |  2 +-
 sound/pci/hda/hda_codec.c                     |  4 ++-
 sound/pci/hda/patch_sigmatel.c                |  4 +--
 sound/soc/codecs/max98090.c                   |  4 +--
 sound/soc/codecs/sigmadsp.c                   |  7 +++++
 sound/soc/dwc/designware_i2s.c                | 14 +++++++++
 sound/usb/mixer_maps.c                        | 15 ++++++++--
 tools/perf/util/hist.h                        |  1 +
 tools/perf/util/session.c                     |  5 ++--
 51 files changed, 359 insertions(+), 150 deletions(-)


