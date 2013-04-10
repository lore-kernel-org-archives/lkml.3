Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965038Ab3DJWtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:49:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934682Ab3DJWtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:49:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/29] 3.4.40-stable review
Date: Wed, 10 Apr 2013 15:49:18 -0700
Message-Id: <20130410224804.061806042@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.40 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Apr 12 22:47:13 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.40-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.40-rc1

Tim Gardner <tim.gardner@canonical.com>
    rt2x00: rt2x00pci_regbusy_read() - only print register access failure once

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    can: gw: use kmem_cache_free() instead of kfree()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "mwifiex: cancel cmd timer and free curr_cmd in shutdown process

Jan Stancek <jstancek@redhat.com>
    mm: prevent mmap_cache race in find_vma()

Vikram Mulukutla <markivx@codeaurora.org>
    panic: fix a possible deadlock in panic()

Richard Guy Briggs <rbriggs@redhat.com>
    thermal: return an error on failure to register thermal class

Jan Beulich <JBeulich@suse.com>
    x86: Fix rebuild with EFI_STUB enabled

Arnd Bergmann <arnd@arndb.de>
    block: avoid using uninitialized value in from queue_var_store

Jussi Kivilinna <jussi.kivilinna@iki.fi>
    crypto: gcm - fix assumption that assoc has one segment

Linus Torvalds <torvalds@linux-foundation.org>
    spinlocks and preemption points need to be at least compiler barriers

Li Fei <fei.li@intel.com>
    hwspinlock: fix __hwspin_lock_request error path

Paul Moore <pmoore@redhat.com>
    x86: remove the x32 syscall bitmask from syscall_get_nr()

Michael Wolf <mjw@linux.vnet.ibm.com>
    powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being performed before the ANDCOND test

Jan Kiszka <jan.kiszka@siemens.com>
    ftrace: Consistently restore trace function on sysctl enabling

Youquan Song <youquan.song@intel.com>
    ata_piix: Fix DVD not dectected at some Haswell platforms

Jay Estabrook <jay.estabrook@gmail.com>
    alpha: Add irongate_io to PCI bus resources

Shan Hai <shan.hai@windriver.com>
    libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive

Shan Hai <shan.hai@windriver.com>
    libata: Use integer return value for atapi_command_packet_set

Yinghai Lu <yinghai@kernel.org>
    EISA/PCI: Fix bus res reference

Yinghai Lu <yinghai@kernel.org>
    EISA/PCI: Init EISA early, before PNP

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - fix typo in proc output

Rainer Koenig <Rainer.Koenig@ts.fujitsu.com>
    ALSA: hda - Enabling Realtek ALC 671 codec

Mengdong Lin <mengdong.lin@intel.com>
    ALSA: hda - bug fix on return value when getting HDMI ELD info

Jan Kara <jack@suse.cz>
    reiserfs: Fix warning and inode leak when deleting inode with xattrs

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: make space fixup work in the remount case

Anatolij Gustschin <agust@denx.de>
    spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts

Girish K S <girishks2000@gmail.com>
    spi/s3c64xx: modified error interrupt handling and init

Lars-Peter Clausen <lars@metafoo.de>
    regmap: cache Fix regcache-rbtree sync

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: dma-sh7760: Fix compile error


-------------

Diffstat:

 Makefile                                |  4 +-
 arch/alpha/kernel/sys_nautilus.c        |  5 +++
 arch/powerpc/platforms/pseries/lpar.c   |  8 +++-
 arch/x86/boot/compressed/Makefile       |  5 +--
 arch/x86/include/asm/syscall.h          |  4 +-
 block/blk-sysfs.c                       |  2 +
 crypto/gcm.c                            | 17 +++++++--
 drivers/ata/ata_piix.c                  | 13 ++++++-
 drivers/ata/libata-core.c               |  4 ++
 drivers/base/regmap/regcache-rbtree.c   |  2 +-
 drivers/eisa/pci_eisa.c                 | 67 ++++++++++++++++++++++-----------
 drivers/hwspinlock/hwspinlock_core.c    |  2 +
 drivers/net/wireless/mwifiex/init.c     |  8 ----
 drivers/net/wireless/rt2x00/rt2x00pci.c |  4 +-
 drivers/spi/spi-mpc512x-psc.c           |  2 +-
 drivers/spi/spi-s3c64xx.c               | 41 ++++++++++++--------
 drivers/thermal/thermal_sys.c           |  1 +
 fs/reiserfs/xattr.c                     |  4 +-
 fs/ubifs/super.c                        | 12 +++---
 include/linux/ata.h                     |  2 +-
 include/linux/libata.h                  |  1 +
 include/linux/preempt.h                 | 22 +++++++----
 include/linux/spinlock_up.h             | 29 ++++++++------
 kernel/panic.c                          |  8 ++++
 kernel/trace/ftrace.c                   |  8 +---
 mm/mmap.c                               |  2 +-
 mm/nommu.c                              |  2 +-
 net/can/gw.c                            |  6 +--
 sound/pci/hda/hda_codec.c               |  2 +-
 sound/pci/hda/hda_eld.c                 |  2 +-
 sound/pci/hda/patch_realtek.c           |  4 +-
 sound/soc/sh/dma-sh7760.c               |  4 +-
 32 files changed, 192 insertions(+), 105 deletions(-)


