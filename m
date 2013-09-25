Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3IYAM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:12:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab3IYAMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:12:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/40] 3.4.63-stable review
Date: Tue, 24 Sep 2013 17:11:32 -0700
Message-Id: <20130925001041.939335518@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.63 release.
There are 40 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Sep 27 00:09:16 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.63-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.63-rc1

Anand Avati <avati@redhat.com>
    fuse: invalidate inode attributes on xattr modification

Maxim Patlasov <MPatlasov@parallels.com>
    fuse: postpone end_page_writeback() in fuse_writepage_locked()

Grant Likely <grant.likely@linaro.org>
    of: Fix missing memory initialization on FDT unflattening

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    mmc: tmio_mmc_dma: fix PIO fallback on SDHI

Alex Deucher <alexander.deucher@amd.com>
    drm/edid: add quirk for Medion MD30217PG

Jan Kara <jack@suse.cz>
    isofs: Refuse RW mount of the filesystem instead of making it RO

Libin <huawei.libin@huawei.com>
    mm/huge_memory.c: fix potential NULL pointer dereference

Greg Thelen <gthelen@google.com>
    memcg: fix multiple large threshold notifications

Jie Liu <jeff.liu@oracle.com>
    ocfs2: fix the end cluster offset of FIEMAP

Alex Williamson <alex.williamson@redhat.com>
    intel-iommu: Fix leaks in pagetable freeing

Felix Fietkau <nbd@openwrt.org>
    MIPS: ath79: Fix ar933x watchdog clock

Andrzej Hajda <a.hajda@samsung.com>
    media: v4l2: added missing mutex.h include to v4l2-ctrls.h

Vasily Titskiy <qehgt0@gmail.com>
    HID: usbhid: quirk for N-Trig DuoSense Touch Screen

Kees Cook <keescook@chromium.org>
    HID: check for NULL field when setting values

Jiri Kosina <jkosina@suse.cz>
    HID: battery: don't do DMA from stack

Kees Cook <keescook@chromium.org>
    HID: ntrig: validate feature report details

Kees Cook <keescook@chromium.org>
    HID: validate HID report id size

Stefan Kriwanek <dev@stefankriwanek.de>
    HID: Fix Speedlink VAD Cezanne support for some devices

Kees Cook <keescook@chromium.org>
    HID: pantherlord: validate output report details

Felix Fietkau <nbd@openwrt.org>
    ath9k: avoid accessing MRC registers on single-chain devices

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix rx descriptor related race condition

Felix Fietkau <nbd@openwrt.org>
    ath9k: always clear ps filter bit on new assoc

John W. Linville <linville@tuxdriver.com>
    brcmsmac: Fix WARNING caused by lack of calls to dma_mapping_error()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add Toshiba Satellite C870 to MSI blacklist

Mike Dyer <mike.dyer@md-soft.co.uk>
    ASoC: wm8960: Fix PLL register writes

Tejun Heo <tj@kernel.org>
    rculist: list_first_or_null_rcu() should use list_entry_rcu()

Hans de Goede <hdegoede@redhat.com>
    usb: config->desc.bLength may not exceed amount of data returned by the device

Oliver Neukum <oneukum@suse.de>
    USB: cdc-wdm: fix race between interrupt handler and tasklet

Daniel Mack <zonque@gmail.com>
    usb: ehci-mxc: check for pdata before dereferencing

Johan Hovold <jhovold@gmail.com>
    USB: mos7720: fix big-endian control requests

Dan Carpenter <dan.carpenter@oracle.com>
    USB: mos7720: use GFP_ATOMIC under spinlock

Dan Carpenter <dan.carpenter@oracle.com>
    staging: comedi: dt282x: dt282x_ai_insn_read() always fails

Jeff Layton <jlayton@redhat.com>
    cifs: ensure that srv_mutex is held when dealing with ssocket pointer

Shawn Nematbakhsh <shawnn@chromium.org>
    usb: xhci: Disable runtime PM suspend for quirky controllers

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci-plat: Don't enable legacy PCI interrupts.

Peter Maydell <peter.maydell@linaro.org>
    ARM: PCI: versatile: Fix SMAP register offsets

Roger Pau Monne <roger.pau@citrix.com>
    xen-gnt: prevent adding duplicate gnt callbacks

Anton Blanchard <anton@samba.org>
    powerpc: Handle unaligned ldbrx/stdbrx

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Fix race condition in larval lookup

Alan Stern <stern@rowland.harvard.edu>
    SCSI: sd: Fix potential out-of-bounds access


-------------

Diffstat:

 Makefile                                      |  4 +-
 arch/arm/mach-versatile/pci.c                 |  6 +--
 arch/mips/ath79/clock.c                       |  2 +-
 arch/powerpc/kernel/align.c                   | 10 ++++
 crypto/api.c                                  |  7 ++-
 drivers/gpu/drm/drm_edid.c                    |  3 ++
 drivers/hid/hid-core.c                        | 17 +++++--
 drivers/hid/hid-ids.h                         |  1 +
 drivers/hid/hid-input.c                       | 12 ++++-
 drivers/hid/hid-ntrig.c                       |  3 +-
 drivers/hid/hid-pl.c                          | 10 +++-
 drivers/hid/hid-speedlink.c                   | 11 ++--
 drivers/hid/usbhid/hid-quirks.c               |  2 +
 drivers/iommu/intel-iommu.c                   | 72 +++++++++++++--------------
 drivers/mmc/host/tmio_mmc_dma.c               |  4 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |  4 ++
 drivers/net/wireless/ath/ath9k/ath9k.h        |  5 +-
 drivers/net/wireless/ath/ath9k/recv.c         | 17 +++++--
 drivers/net/wireless/ath/ath9k/xmit.c         |  1 +
 drivers/net/wireless/brcm80211/brcmsmac/dma.c | 15 ++++--
 drivers/of/base.c                             |  1 +
 drivers/scsi/sd.c                             | 11 ++--
 drivers/staging/comedi/drivers/dt282x.c       |  3 +-
 drivers/usb/class/cdc-wdm.c                   | 13 +++--
 drivers/usb/core/config.c                     |  3 +-
 drivers/usb/host/ehci-mxc.c                   |  2 +-
 drivers/usb/host/xhci-plat.c                  |  2 +-
 drivers/usb/host/xhci.c                       | 29 ++++++++++-
 drivers/usb/host/xhci.h                       |  1 +
 drivers/usb/serial/mos7720.c                  |  6 +--
 drivers/xen/grant-table.c                     | 13 ++++-
 fs/cifs/connect.c                             |  2 +
 fs/fuse/dir.c                                 |  4 ++
 fs/fuse/file.c                                |  3 +-
 fs/isofs/inode.c                              | 16 ++----
 fs/ocfs2/extent_map.c                         |  1 -
 include/linux/hid.h                           |  4 +-
 include/linux/rculist.h                       |  5 +-
 include/media/v4l2-ctrls.h                    |  1 +
 mm/huge_memory.c                              |  2 +
 mm/memcontrol.c                               |  8 ++-
 sound/pci/hda/hda_intel.c                     |  1 +
 sound/soc/codecs/wm8960.c                     |  6 +--
 43 files changed, 231 insertions(+), 112 deletions(-)


