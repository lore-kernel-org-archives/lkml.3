Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab3KIHrX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:47:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3KIGtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:49:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/26] 3.4.69-stable review
Date: Fri,  8 Nov 2013 22:51:29 -0800
Message-Id: <20131109065050.089866597@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.69 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Nov 11 06:50:22 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.69-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.69-rc1

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: workaround vbios bug in transmitter table on rs780

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Prevent overwriting from userspace underallocating core ioctl structs

Khalid Aziz <khalid.aziz@oracle.com>
    mm: fix aio performance regression for database caused by THP

Dan Carpenter <dan.carpenter@oracle.com>
    aacraid: missing capable() check in compat ioctl

Ming Lei <ming.lei@canonical.com>
    lib/scatterlist.c: don't flush_kernel_dcache_page on slab page

Baruch Siach <baruch@tkos.co.il>
    xtensa: don't use alternate signal stack on threads

Dan Carpenter <dan.carpenter@oracle.com>
    uml: check length in exitcode_proc_write()

Dan Carpenter <dan.carpenter@oracle.com>
    Staging: bcm: info leak in ioctl

Dan Carpenter <dan.carpenter@oracle.com>
    staging: ozwpan: prevent overflow in oz_cdev_write()

Takashi Iwai <tiwai@suse.de>
    ASoC: dapm: Fix source list debugfs outputs

Takashi Iwai <tiwai@suse.de>
    ASoC: wm_hubs: Add missing break in hp_supply_event()

Russell King <rmk+kernel@arm.linux.org.uk>
    ALSA: fix oops in snd_pcm_info() caused by ASoC DPCM

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add a fixup for ASUS N76VZ

Helge Deller <deller@gmx.de>
    parisc: Do not crash 64bit SMP kernels on machines with >= 4GB RAM

Thomas Gleixner <tglx@linutronix.de>
    clockevents: Sanitize ticks to nsec conversion

Lukasz Dorau <lukasz.dorau@intel.com>
    md: Fix skipping recovery for read-only arrays.

Gwendal Grignou <gwendal@google.com>
    libata: make ata_eh_qc_retry() bump scmd->allowed on bogus failures

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: flexcan_chip_start: fix regression, mark one MB for TX and abort pending TX

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: fix error path in ialloc

Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
    rtlwifi: rtl8192cu: Fix error in pointer arithmetic

Felix Fietkau <nbd@openwrt.org>
    mac80211: update sta->last_rx on acked tx frames

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    mac80211: correctly close cancelled scans

Алексей Крамаренко <alexeyk13@yandex.ru>
    USB: serial: ftdi_sio: add id for Z3X Box device

Oliver Neukum <oneukum@suse.de>
    USB: quirks: add touchscreen that is dazzeled by remote wakeup

Oliver Neukum <oneukum@suse.de>
    USB: quirks.c: add one device that cannot deal with suspension

Fangxiaozhi (Franko) <fangxiaozhi@huawei.com>
    USB: support new huawei devices in option.c


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/parisc/kernel/head.S                    |   4 +
 arch/um/kernel/exitcode.c                    |   4 +-
 arch/xtensa/kernel/signal.c                  |   2 +-
 drivers/ata/libata-eh.c                      |   6 +-
 drivers/gpu/drm/drm_drv.c                    |   9 +-
 drivers/gpu/drm/radeon/atombios_encoders.c   |   2 +-
 drivers/md/raid1.c                           |   1 +
 drivers/md/raid10.c                          |   1 +
 drivers/net/can/flexcan.c                    |  10 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |   3 +-
 drivers/scsi/aacraid/linit.c                 |   2 +
 drivers/staging/bcm/Bcmchar.c                |   1 +
 drivers/staging/ozwpan/ozcdev.c              |   3 +
 drivers/usb/core/quirks.c                    |   6 +
 drivers/usb/serial/ftdi_sio.c                |   1 +
 drivers/usb/serial/ftdi_sio_ids.h            |   6 +
 drivers/usb/serial/option.c                  | 216 +++++++++++++++++++++++++++
 fs/jfs/jfs_inode.c                           |   3 +-
 kernel/time/clockevents.c                    |  65 ++++++--
 lib/scatterlist.c                            |   3 +-
 mm/swap.c                                    |  31 +++-
 net/mac80211/ieee80211_i.h                   |   3 +
 net/mac80211/scan.c                          |  19 +++
 net/mac80211/status.c                        |   3 +
 sound/core/pcm.c                             |   4 +
 sound/pci/hda/patch_realtek.c                |   1 +
 sound/soc/codecs/wm_hubs.c                   |   1 +
 sound/soc/soc-dapm.c                         |   2 +-
 29 files changed, 383 insertions(+), 33 deletions(-)


