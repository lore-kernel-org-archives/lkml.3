Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3LRVIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:08:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3LRVIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:08:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/31] 3.4.75-stable review
Date: Wed, 18 Dec 2013 13:08:08 -0800
Message-Id: <20131218210522.790152625@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.75 release.
There are 31 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Dec 20 21:05:11 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.75-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.75-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST"

Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
    hpfs: fix warnings when the filesystem fills up

Alan <gnomes@lxorguk.ukuu.org.uk>
    sc1200_wdt: Fix oops

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: ssv_dnp: use comedi_dio_update_state()

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: pcmuio: fix possible NULL deref on detach

Helge Deller <deller@gmx.de>
    nfs: fix do_div() warning by instead using sector_div()

Mikulas Patocka <mpatocka@redhat.com>
    dm table: fail dm_table_create on dm_round_up overflow

Mikulas Patocka <mpatocka@redhat.com>
    dm delay: fix a possible deadlock due to shared workqueue

Mikulas Patocka <mpatocka@redhat.com>
    dm bufio: initialize read-only module parameters

Matthew Garrett <matthew.garrett@nebula.com>
    x86, efi: Don't use (U)EFI time services on 32 bit

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fixup bad vram size on SI

Johannes Berg <johannes.berg@intel.com>
    mac80211: don't attempt to reorder multicast frames

Paul Moore <pmoore@redhat.com>
    selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute()

Paul Moore <pmoore@redhat.com>
    selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()

Linus Pizunski <linus@narrativeteam.com>
    drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap

Christian Engelmayer <christian.engelmayer@frequentis.com>
    Input: usbtouchscreen - separate report and transmit buffer size handling

Fangxiaozhi (Franko) <fangxiaozhi@huawei.com>
    USB: option: support new huawei devices

Gustavo Zacarias <gustavo@zacarias.com.ar>
    USB: serial: option: blacklist interface 1 for Huawei E173s-6

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: composite: reset delayed_status on reset_config

Alan Stern <stern@rowland.harvard.edu>
    usb: dwc3: fix implementation of endpoint wedge

Julius Werner <jwerner@chromium.org>
    usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED

Linus Torvalds <torvalds@linux-foundation.org>
    futex: fix handling of read-only-mapped hugepages

Dan Carpenter <dan.carpenter@oracle.com>
    xfs: underflow bug in xfs_attrlist_by_handle()

Brian Carnes <bmcarnes@gmail.com>
    hwmon: (w83l786ng) Fix fan speed control mode setting and reporting

Andy Honig <ahonig@google.com>
    KVM: Improve create VCPU parameter (CVE-2013-4587)

Konstantin Khlebnikov <k.khlebnikov@samsung.com>
    ARM: 7913/1: fix framepointer check in unwind_frame

Konstantin Khlebnikov <k.khlebnikov@samsung.com>
    ARM: 7912/1: check stack pointer in get_wchan

Roger Quadros <rogerq@ti.com>
    ARM: OMAP3: hwmod data: Don't prevent RESET of USB Host module

Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
    ARM: pxa: tosa: fix keys mapping

Stefano Panella <stefano.panella@citrix.com>
    ALSA: memalloc.h - fix wrong truncation of dma_addr_t

Jim Quinlan <jim2101024@gmail.com>
    MIPS: DMA: For BMIPS5000 cores flush region just like non-coherent R10000


-------------

Diffstat:

 Makefile                                   |   4 +-
 arch/arm/kernel/process.c                  |   7 +-
 arch/arm/kernel/stacktrace.c               |   2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  13 +---
 arch/arm/mach-pxa/tosa.c                   | 102 ++++++++++++++---------------
 arch/mips/mm/dma-default.c                 |  16 +++--
 arch/x86/platform/efi/efi.c                |   7 --
 crypto/algif_hash.c                        |   3 -
 crypto/algif_skcipher.c                    |   3 -
 drivers/gpu/drm/radeon/si.c                |  11 +++-
 drivers/hwmon/w83l786ng.c                  |   4 +-
 drivers/input/touchscreen/usbtouchscreen.c |  22 +++++--
 drivers/md/dm-bufio.c                      |   5 ++
 drivers/md/dm-delay.c                      |  23 ++++---
 drivers/md/dm-table.c                      |   5 ++
 drivers/rtc/rtc-at91rm9200.c               |   2 +
 drivers/staging/comedi/drivers/pcmuio.c    |  12 ++--
 drivers/staging/comedi/drivers/ssv_dnp.c   |   6 +-
 drivers/usb/core/hub.c                     |   5 +-
 drivers/usb/dwc3/ep0.c                     |   2 +
 drivers/usb/dwc3/gadget.c                  |   5 +-
 drivers/usb/gadget/composite.c             |   1 +
 drivers/usb/serial/option.c                |  27 ++++++++
 drivers/watchdog/sc1200wdt.c               |   3 +-
 fs/hpfs/file.c                             |   5 +-
 fs/nfs/blocklayout/extents.c               |   2 +-
 fs/xfs/xfs_ioctl.c                         |   3 +-
 fs/xfs/xfs_ioctl32.c                       |   3 +-
 include/sound/memalloc.h                   |   2 +-
 kernel/futex.c                             |   2 +-
 net/ipv4/udp.c                             |   3 -
 net/mac80211/rx.c                          |   3 +-
 security/selinux/hooks.c                   |  93 +++++++++++++++++++++-----
 virt/kvm/kvm_main.c                        |   3 +
 34 files changed, 261 insertions(+), 148 deletions(-)


