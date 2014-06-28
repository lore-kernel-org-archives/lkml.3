Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaF1RrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:47:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaF1Rqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:46:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/43] 3.4.96-stable review
Date: Sat, 28 Jun 2014 10:45:51 -0700
Message-Id: <20140628174449.788784511@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.96 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Jun 30 17:44:34 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.96-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.96-rc1

Andy Lutomirski <luto@amacapital.net>
    x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

Roger Quadros <rogerq@ti.com>
    usb: usbtest: Add timetout to simple_io()

Eric Sandeen <sandeen@redhat.com>
    btrfs: fix use of uninit "ret" in end_extent_writepage()

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: use right type to get real comparison

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
    fs: btrfs: volumes.c: Fix for possible null pointer dereference

Chris Mason <clm@fb.com>
    Btrfs: fix double free in find_lock_delalloc_range

Michael S. Tsirkin <mst@redhat.com>
    skbuff: skb_segment: orphan frags before copying

Michael S. Tsirkin <mst@redhat.com>
    skbuff: export skb_copy_ubufs

Michael S. Tsirkin <mst@redhat.com>
    skbuff: add an api to orphan frags

Thomas Gleixner <tglx@linutronix.de>
    genirq: Sanitize spurious interrupt detection of threaded irqs

Mike Frysinger <vapier@gentoo.org>
    x86, x32: Use compat shims for io_{setup,submit}

H. Peter Anvin <hpa@linux.intel.com>
    x86-32, espfix: Remove filter for espfix32 due to race

Nicholas A. Bellinger <nab@linux-iscsi.org>
    target: Explicitly clear ramdisk_mcp backend pages

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: stacktrace: avoid listing stacktrace functions in stacktrace

Lv Zheng <lv.zheng@intel.com>
    ACPI: Fix conflict between customized DSDT and DSDT local copy

Johan Hovold <jhovold@gmail.com>
    USB: sierra: fix remote wakeup

Johan Hovold <jhovold@gmail.com>
    USB: sierra: fix urb and memory leak on disconnect

Johan Hovold <jhovold@gmail.com>
    USB: sierra: fix urb and memory leak in resume error path

Johan Hovold <jhovold@gmail.com>
    USB: sierra: fix use after free at suspend/resume

Johan Hovold <jhovold@gmail.com>
    USB: sierra: fix AA deadlock in open error path

Johan Hovold <jhovold@gmail.com>
    USB: usb_wwan: fix potential blocked I/O after resume

Johan Hovold <jhovold@gmail.com>
    USB: usb_wwan: fix potential NULL-deref at resume

Johan Hovold <jhovold@gmail.com>
    USB: usb_wwan: fix urb leak at shutdown

Johan Hovold <jhovold@gmail.com>
    USB: usb_wwan: fix write and suspend race

xiao jin <jin.xiao@intel.com>
    USB: usb_wwan: fix race between write and resume

xiao jin <jin.xiao@intel.com>
    USB: usb_wwan: fix urb leak in write error path

Mikulas Patocka <mpatocka@redhat.com>
    matroxfb: perform a dummy read of M_STATUS

Maurizio Lombardi <mlombard@redhat.com>
    ext4: fix wrong assert in ext4_mb_normalize_request()

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/lowcore: reserve 96 bytes for IRB in lowcore

Johannes Weiner <hannes@cmpxchg.org>
    mm: vmscan: clear kswapd's special reclaim powers before exiting

Kees Cook <keescook@chromium.org>
    HID: core: fix validation of report id 0

Hugh Dickins <hughd@google.com>
    mm: fix sleeping function warning from __put_anon_vma

Tony Luck <tony.luck@intel.com>
    mm/memory-failure.c: don't let collect_procs() skip over processes for MF_ACTION_REQUIRED

Tony Luck <tony.luck@intel.com>
    mm/memory-failure.c-failure: send right signal code to correct thread

Johan Hovold <jhovold@gmail.com>
    USB: option: fix runtime PM handling

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: avoid BIOS handover on the HASEE E200

Felipe Balbi <balbi@ti.com>
    usb: dwc3: gadget: clear stall when disabling endpoint

Paul Bolle <pebolle@tiscali.nl>
    usb: gadget: rename CONFIG_USB_GADGET_PXA25X

Alan Stern <stern@rowland.harvard.edu>
    USB: usbtest: add a timeout for scatter-gather tests

Huang Rui <ray.huang@amd.com>
    usb: usbtest: fix unlink write error with pattern 1

Dan Carpenter <dan.carpenter@oracle.com>
    applicom: dereferencing NULL on error path

Paul Bolle <pebolle@tiscali.nl>
    staging: tidspbridge: check for CONFIG_SND_OMAP_SOC_MCBSP

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_pci: prevent use after free at netdev removal


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/arm/kernel/stacktrace.c                 |  18 ++--
 arch/s390/include/asm/lowcore.h              |  11 +--
 arch/x86/kernel/entry_32.S                   |  15 ++--
 arch/x86/syscalls/syscall_64.tbl             |   6 +-
 drivers/acpi/bus.c                           |   7 ++
 drivers/char/applicom.c                      |   1 -
 drivers/hid/hid-core.c                       |  12 ++-
 drivers/net/can/sja1000/peak_pci.c           |  14 +--
 drivers/staging/tidspbridge/core/dsp-clock.c |   4 +-
 drivers/target/target_core_rd.c              |   2 +-
 drivers/usb/dwc3/gadget.c                    |   4 +
 drivers/usb/gadget/inode.c                   |   2 +-
 drivers/usb/host/pci-quirks.c                |  19 ++++-
 drivers/usb/misc/usbtest.c                   |  40 ++++++++-
 drivers/usb/serial/option.c                  |  15 +++-
 drivers/usb/serial/sierra.c                  |  54 +++++++++---
 drivers/usb/serial/usb_wwan.c                | 123 +++++++++++++++------------
 drivers/video/matrox/matroxfb_base.h         |   2 +-
 fs/btrfs/backref.c                           |   2 +-
 fs/btrfs/extent_io.c                         |   3 +-
 fs/btrfs/volumes.c                           |   5 +-
 fs/ext4/mballoc.c                            |   2 +-
 include/linux/irqdesc.h                      |   4 +
 include/linux/skbuff.h                       |  16 ++++
 kernel/irq/manage.c                          |   4 +-
 kernel/irq/spurious.c                        | 106 ++++++++++++++++++++++-
 mm/memory-failure.c                          |  25 +++---
 mm/rmap.c                                    |   8 +-
 mm/vmscan.c                                  |   3 +
 net/core/skbuff.c                            |   5 +-
 31 files changed, 400 insertions(+), 136 deletions(-)


