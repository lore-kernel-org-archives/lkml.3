Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbbAPSiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:38:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbbAPSiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:38:13 -0500
Date: Fri, 16 Jan 2015 10:38:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.65
Message-ID: <20150116183811.GA15068@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.65 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/ramoops.txt                     |   13 ++++++-
 Makefile                                      |    2 -
 arch/arm/mach-mvebu/coherency.c               |   23 +++++++++++++
 arch/x86/include/asm/vsyscall.h               |    2 -
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   22 +++++++++++--
 arch/x86/vdso/vma.c                           |   43 +++++++++++++++++----=
-----
 block/genhd.c                                 |   11 +++++-
 drivers/base/bus.c                            |    8 +++-
 drivers/hid/hid-core.c                        |    1=20
 drivers/hid/hid-ids.h                         |    1=20
 drivers/hid/hid-input.c                       |    3 +
 drivers/hid/hid-kye.c                         |    4 ++
 drivers/hid/hid-roccat-pyra.c                 |    8 +++-
 drivers/hid/i2c-hid/i2c-hid.c                 |   14 +++++---
 drivers/hid/usbhid/hid-quirks.c               |    1=20
 drivers/iommu/intel-iommu.c                   |    8 +---
 drivers/mtd/ubi/upd.c                         |   10 +++---
 drivers/mtd/ubi/wl.c                          |   10 +-----
 drivers/net/can/usb/peak_usb/pcan_usb_core.c  |   17 ++++++----
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c   |    3 -
 drivers/net/wireless/ath/ath5k/qcu.c          |    8 ----
 drivers/net/wireless/ath/ath9k/hw.h           |    4 +-
 drivers/net/wireless/ath/ath9k/mac.c          |    9 -----
 drivers/pci/probe.c                           |    3 +
 drivers/tty/serial/samsung.c                  |    4 ++
 drivers/usb/class/cdc-acm.c                   |   10 +++---
 drivers/xen/swiotlb-xen.c                     |    2 -
 fs/btrfs/delayed-inode.c                      |    8 ++++
 fs/fs-writeback.c                             |   29 +++++++++++++----
 fs/nfsd/nfs4state.c                           |   15 ++++-----
 fs/nfsd/nfs4xdr.c                             |    3 +
 fs/nilfs2/inode.c                             |   32 ++++++++++++++-----
 fs/nilfs2/namei.c                             |   15 +++++++--
 fs/ocfs2/aops.c                               |   16 ++++++++-
 fs/pstore/ram.c                               |   13 ++++++-
 fs/pstore/ram_core.c                          |   31 +++++++++++++-----
 include/linux/mm.h                            |    2 -
 include/linux/pstore_ram.h                    |    4 +-
 kernel/events/core.c                          |    4 +-
 mm/memory.c                                   |    4 +-
 mm/mmap.c                                     |    7 +++-
 mm/vmscan.c                                   |   24 +++++++-------
 scripts/kernel-doc                            |    2 -
 sound/pci/hda/hda_codec.c                     |    4 +-
 sound/pci/hda/patch_sigmatel.c                |    4 +-
 sound/soc/codecs/max98090.c                   |    4 +-
 sound/soc/codecs/sigmadsp.c                   |    7 ++++
 sound/soc/dwc/designware_i2s.c                |   14 ++++++++
 sound/usb/mixer_maps.c                        |   15 +++++++--
 tools/perf/util/hist.h                        |    1=20
 tools/perf/util/session.c                     |    5 +--
 51 files changed, 358 insertions(+), 149 deletions(-)

Alex Williamson (1):
      driver core: Fix unbalanced device reference in drivers_probe

Andrew Jackson (1):
      ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap

Andy Lutomirski (2):
      x86_64, vdso: Fix the vdso address randomization algorithm
      x86, vdso: Use asm volatile in __getcpu

Benjamin Coddington (1):
      nfsd4: fix xdr4 inclusion of escaped char

Chris Mason (1):
      Btrfs: don't delay inode ref updates during log replay

Dan Carpenter (2):
      HID: roccat: potential out of bounds in pyra_sysfs_write_settings()
      ALSA: hda - using uninitialized data

Felix Fietkau (3):
      ath9k_hw: fix hardware queue allocation
      ath9k: fix BE/BK queue order
      ath5k: fix hardware queue index assignment

Giedrius Statkevi=C4=8Dius (1):
      HID: Add a new id 0x501a for Genius MousePen i608X

Greg Kroah-Hartman (2):
      USB: cdc-acm: check for valid interfaces
      Linux 3.10.65

Gwendal Grignou (1):
      HID: i2c-hid: prevent buffer overflow in early IRQ

Jarkko Nikula (1):
      ASoC: max98090: Fix ill-defined sidetone route

Jean-Baptiste Maneyrol (1):
      HID: i2c-hid: fix race condition reading reports

Jens Axboe (1):
      genhd: check for int overflow in disk_expand_part_tbl()

Jiang Liu (1):
      iommu/vt-d: Fix an off-by-one bug in __domain_mapping()

Jiri Jaburek (1):
      ALSA: usb-audio: extend KEF X300A FU 10 tweak to Arcam rPAC

Jiri Olsa (3):
      perf/x86/intel/uncore: Make sure only uncore events are collected
      perf: Fix events installation during moving group
      perf session: Do not fail on processing out of order event

Johannes Berg (1):
      scripts/kernel-doc: don't eat struct members with __aligned

Junxiao Bi (1):
      ocfs2: fix journal commit deadlock

Karl Relton (1):
      HID: add battery quirk for USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO =
keyboard

Lars-Peter Clausen (1):
      ASoC: sigmadsp: Refuse to load firmware files with a non-supported ve=
rsion

Linus Torvalds (2):
      mm: propagate error from stack expansion even for guard page
      mm: Don't count the stack guard page towards RLIMIT_STACK

Myron Stowe (1):
      PCI: Restore detection of read-only BARs

Oliver Neukum (1):
      cdc-acm: memory leak in error case

Rasmus Villemoes (1):
      fs: nfsd: Fix signedness bug in compare_blob

Richard Weinberger (2):
      UBI: Fix invalid vfree()
      UBI: Fix double free after do_sync_erase()

Rob Herring (1):
      pstore-ram: Fix hangs by using write-combine mappings

Robert Baldyga (1):
      serial: samsung: wait for transfer completion before clock disable

Ryusuke Konishi (1):
      nilfs2: fix the nilfs_iget() vs. nilfs_new_inode() races

Stefano Stabellini (1):
      swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single

Stephane Grosjean (2):
      can: peak_usb: fix cleanup sequence order in case of error during init
      can: peak_usb: fix memset() usage

Takashi Iwai (1):
      ALSA: hda - Fix wrong gpio_dir & gpio_mask hint setups for IDT/STAC c=
odecs

Tejun Heo (1):
      writeback: fix a subtle race condition in I_DIRTY clearing

Thomas Petazzoni (1):
      ARM: mvebu: disable I/O coherency on non-SMP situations on Armada 370=
/375/38x/XP

Tony Lindgren (1):
      pstore-ram: Allow optional mapping with pgprot_noncached

Vlastimil Babka (1):
      mm, vmscan: prevent kswapd livelock due to pfmemalloc-throttled proce=
ss being killed


--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUuVqOAAoJEDjbvchgkmk+TN4P/RsV0bp1bfFIw+VP6QAC6/A9
fQXegxhO2/zl0y11W9eqW5J4bmsrWDtM25EbKqKDf1EwQioi+p9jebBk9bH0JpFN
r8RXiVZ4tybRqoZ3DbVQTO8Iqy7cjIQwCdD/Pj09GQsrKcowc+PxHOwc0tGtOtTI
Twq8MiP3xCyLn/hLqfBhWZd2YMqRIOY/lGQewEiUmVuWasIBqcJ8AYex1kX+Z4RD
l+h5h2eLxov8eP7YXRFBjCnTdWcNvdWMANDgtpBeC6BUcynHvnPOGHedbfijpKJe
VbGbsDqKnSW/WKfS63X7Q/9L4bhtv6MvorCCKgn4IWouMwJnZNANkbTG1+tyDBKP
AkGxA13Z6IUpWaDRHLkJqVo4LgaOe3APJ8cdr3+Tj+C9Fvk4R4cCd2dr8rftDzp8
1xNsLW7hRt2uzvwmnW/vQuiBgvKzbArNyvt3r/DmUNwXUADXktMkVeHOakEElxxS
htabcqPLw0VmoMCBkFtHBkJ9EQTLj61KQHdSadtMN8eB/GhDsRzycgh1qByFdYto
9KJtQp7Q9EHcN6HwGtD7Nv2soSwBRWd2dqUWMWiNhgtdKVL8LsDRO1hUiKyuEfbj
rleiNu3sfetZVTA/kAaV0OJFpp6/853yme3srCPt0L+fZbz0N+hrVdRJQ6gB0sJP
uKoV+INcnWAeE1ABuXTI
=qWqp
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
