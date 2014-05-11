Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbaEKTbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:31:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934059AbaEKT0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/22] 3.4.90-stable review
Date: Sun, 11 May 2014 21:21:08 +0200
Message-Id: <20140511192103.733723493@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.90 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue May 13 19:20:50 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.90-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.90-rc1

Mike Snitzer <snitzer@redhat.com>
    dm thin: fix dangling bio in process_deferred_bios error path

Giacomo Comes <comes@naic.edu>
    Skip intel_crt_init for Dell XPS 8700

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: sm_ftl: heap corruption in sm_create_sysfs_attributes()

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: nuc900_nand: NULL dereference in nuc900_nand_enable()

Mikulas Patocka <mpatocka@redhat.com>
    tgafb: fix data copying

Marek Vasut <marex@denx.de>
    gpio: mxs: Allow for recursive enable_irq_wake() call

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192se: Fix too long disable of IRQs

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix too long disable of IRQs

Jeff Layton <jlayton@redhat.com>
    locks: allow __break_lease to sleep even when break_time is 0

Dan Williams <dan.j.williams@intel.com>
    libata/ahci: accommodate tag ordered controllers

Rafał Miłecki <zajec5@gmail.com>
    b43: Fix machine check error due to improper access of B43_MMIO_PSM_PHY_HDR

Mikulas Patocka <mpatocka@redhat.com>
    mach64: fix cursor when character width is not a multiple of 8 pixels

Mikulas Patocka <mpatocka@redhat.com>
    mach64: use unaligned access

Mikulas Patocka <mpatocka@redhat.com>
    matroxfb: restore the registers M_ACCESS and M_PITCH

Mikulas Patocka <mpatocka@redhat.com>
    framebuffer: fix cfb_copyarea

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    crypto: ghash-clmulni-intel - use C implementation for setkey()

Tyler Stachecki <tstache1@binghamton.edu>
    mpt2sas: Don't disable device twice at suspend.

Rusty Russell <rusty@rustcorp.com.au>
    virtio_balloon: don't softlockup on huge balloon changes.

Huacai Chen <chenhc@lemote.com>
    MIPS: Hibernate: Flush TLB entries in swsusp_arch_resume()

Matthew Daley <mattd@bugfuzz.com>
    floppy: don't write kernel-only members to FDRAWCMD ioctl output

Matthew Daley <mattd@bugfuzz.com>
    floppy: ignore kernel-only members in FDRAWCMD ioctl input

Tomoki Sekiyama <tomoki.sekiyama@hds.com>
    drivers/tty/hvc: don't free hvc_console_setup after init


-------------

Diffstat:

 Makefile                                    |   4 +-
 arch/mips/power/hibernate.S                 |   1 +
 arch/x86/crypto/ghash-clmulni-intel_asm.S   |  28 ---
 arch/x86/crypto/ghash-clmulni-intel_glue.c  |  14 +-
 drivers/ata/libata-core.c                   |  21 ++-
 drivers/block/floppy.c                      |  11 +-
 drivers/gpio/gpio-mxs.c                     |   3 +-
 drivers/gpu/drm/i915/intel_crt.c            |   8 +
 drivers/md/dm-thin.c                        |   2 +-
 drivers/mtd/nand/nuc900_nand.c              |   2 +-
 drivers/mtd/sm_ftl.c                        |  11 +-
 drivers/net/wireless/b43/phy_n.c            |  14 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |  15 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c |  27 ++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |   1 -
 drivers/tty/hvc/hvc_console.c               |   2 +-
 drivers/video/aty/mach64_accel.c            |   3 +-
 drivers/video/aty/mach64_cursor.c           |  22 ++-
 drivers/video/cfbcopyarea.c                 | 153 ++++++++--------
 drivers/video/matrox/matroxfb_accel.c       |  38 ++--
 drivers/video/matrox/matroxfb_base.h        |   2 +
 drivers/video/tgafb.c                       | 264 ++++++----------------------
 drivers/virtio/virtio_balloon.c             |   6 +
 fs/locks.c                                  |   7 +-
 include/linux/libata.h                      |   1 +
 25 files changed, 280 insertions(+), 380 deletions(-)


