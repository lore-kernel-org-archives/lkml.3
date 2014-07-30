Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaG3CGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:06:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbaG3Btm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/29] 3.14.15-stable review
Date: Tue, 29 Jul 2014 18:48:35 -0700
Message-Id: <20140730014809.316066303@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.15 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Aug  1 01:47:58 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.15-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.15-rc1

Guenter Roeck <linux@roeck-us.net>
    platform_get_irq: Revert to platform_get_resource if of_irq_get fails

Johannes Berg <johannes.berg@intel.com>
    nl80211: move set_qos_map command into split state

Michael Brown <mbrown@fensystems.co.uk>
    x86/efi: Include a .bss section within the PE/COFF headers

Linus Torvalds <torvalds@linux-foundation.org>
    Fix gcc-4.9.0 miscompilation of load_balance() in scheduler

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm: hugetlb: fix copy_hugetlb_page_range()

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: fix cut and paste issue for hawaii.

Christian König <christian.koenig@amd.com>
    drm/radeon: fix irq ring buffer overflow handling

Sven Wegener <sven.wegener@stealer.net>
    x86_32, entry: Store badsys error code in %eax

Vasily Averin <vvs@parallels.com>
    fs: umount on symlink leaks mnt count

Randy Dunlap <rdunlap@infradead.org>
    parport: fix menu breakage

Guenter Roeck <linux@roeck-us.net>
    hwmon: (smsc47m192) Fix temperature limit and vrm write operations

John David Anglin <dave.anglin@bell.net>
    parisc: Remove SA_RESTORER define

Silesh C V <svellattu@mvista.com>
    coredump: fix the setting of PF_DUMPCORE

Dmitry Torokhov <dtor@chromium.org>
    Input: fix defuzzing logic

Hans de Goede <hdegoede@redhat.com>
    Input: synaptics - add min/max quirk for pnp-id LEN2002 (Edge E531)

Mikulas Patocka <mpatocka@redhat.com>
    slab_common: fix the check for duplicate slab names

Tony Luck <tony.luck@intel.com>
    tracing: Fix wraparound problems in "uptime" trace clock

Tejun Heo <tj@kernel.org>
    blkcg: don't call into policy draining if root_blkg is already gone

Romain Degez <romain.degez@gmail.com>
    ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/ptrace: fix PSW mask check

Tejun Heo <tj@kernel.org>
    libata: introduce ata_host->n_tags to avoid oops on SAS controllers

Kevin Hao <haokexin@gmail.com>
    libata: support the ata host which implements a queue depth less than 32

Christoph Hellwig <hch@lst.de>
    block: don't assume last put of shared tags is for the host

Mikulas Patocka <mpatocka@redhat.com>
    block: provide compat ioctl for BLKZEROOUT

Christoph Hellwig <hch@lst.de>
    nfs: only show Posix ACLs in listxattr if actually present

Antti Palosaari <crope@iki.fi>
    media: tda10071: force modulation to QPSK on DVB-S

Hans Verkuil <hverkuil@xs4all.nl>
    media: hdpvr: fix two audio bugs

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
    media: media: v4l2-core: v4l2-dv-timings.c: Cleaning up code wrong value used in aspect ratio

Arnd Bergmann <arnd@arndb.de>
    media: staging: tighten omap4iss dependencies


-------------

Diffstat:

 Makefile                                  |  6 +++--
 arch/parisc/include/uapi/asm/signal.h     |  2 --
 arch/s390/kernel/ptrace.c                 | 12 +++++++--
 arch/x86/boot/header.S                    | 26 ++++++++++++++++---
 arch/x86/boot/tools/build.c               | 37 +++++++++++++++++++++-----
 arch/x86/kernel/entry_32.S                |  9 ++++---
 block/blk-cgroup.c                        |  7 +++++
 block/blk-tag.c                           | 33 +++++-------------------
 block/compat_ioctl.c                      |  1 +
 drivers/ata/ahci.c                        |  1 +
 drivers/ata/libata-core.c                 | 12 +++++++--
 drivers/base/platform.c                   |  9 +++++--
 drivers/gpu/drm/radeon/cik.c              |  2 ++
 drivers/gpu/drm/radeon/evergreen.c        |  1 +
 drivers/gpu/drm/radeon/r600.c             |  1 +
 drivers/gpu/drm/radeon/si.c               |  1 +
 drivers/hwmon/smsc47m192.c                |  4 ++-
 drivers/input/input.c                     |  6 +++--
 drivers/input/mouse/synaptics.c           |  5 ++--
 drivers/media/dvb-frontends/tda10071.c    |  6 ++++-
 drivers/media/usb/hdpvr/hdpvr-video.c     |  6 ++---
 drivers/media/v4l2-core/v4l2-dv-timings.c |  4 +--
 drivers/parport/Kconfig                   | 12 ++++-----
 drivers/staging/media/omap4iss/Kconfig    |  2 +-
 fs/coredump.c                             |  2 +-
 fs/namei.c                                |  3 ++-
 fs/nfs/nfs3acl.c                          | 43 +++++++++++++++++++++++++++++++
 fs/nfs/nfs3proc.c                         |  4 +--
 include/linux/libata.h                    |  1 +
 kernel/trace/trace.c                      |  2 +-
 kernel/trace/trace_clock.c                |  9 ++++---
 mm/hugetlb.c                              |  1 +
 mm/slab_common.c                          |  2 +-
 net/wireless/nl80211.c                    | 11 ++++----
 34 files changed, 198 insertions(+), 85 deletions(-)


