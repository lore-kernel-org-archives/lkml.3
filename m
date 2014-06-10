Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197AbaFJAVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:21:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843AbaFJAVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:21:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/88] 3.4.93-stable review
Date: Mon,  9 Jun 2014 17:24:10 -0700
Message-Id: <20140610002424.500996570@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.93 release.
There are 88 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun 12 00:24:06 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.93-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.93-rc1

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/p2m: Reuse existing P2M leafs if they are filled with 1:1 PFNs or INVALID.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/p2m: Reserve 8MB of _brk space for P2M leafs when populating back.

zhenzhong.duan <zhenzhong.duan@oracle.com>
    xen: populate correct number of pages when across mem boundary (v2)

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/balloon: Subtract from xen_released_pages the count that is populated.

David Vrabel <dvrabel@cantab.net>
    xen/setup: update VA mapping when releasing memory during setup

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/setup: Combine the two hypercall functions - since they are quite similar.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/setup: Populate freed MFNs from non-RAM E820 entries and gaps to E820 RAM

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/p2m: An early bootup variant of set_phys_to_machine

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/p2m: Collapse early_alloc_p2m_middle redundant checks.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/p2m: Allow alloc_p2m_middle to call reserve_brk depending on argument

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/p2m: Move code around to allow for better re-usage.

Ley Foon Tan <lftan@altera.com>
    tty/serial: Add support for Altera serial port

Stephen Hurd <shurd@broadcom.com>
    8250/16?50: Add support for Broadcom TruManage redirected serial port

Scott Ashcroft <scott.ashcroft@talk21.com>
    Fix 4 port and add support for 8 port 'Unknown' PCI serial port cards

Ilya Zykov <ilya@ilyx.ru>
    tty: Correct tty buffer flush.

Johan Hovold <jhovold@gmail.com>
    serial: pch_uart: fix tty-kref leak in rx-error path

Johan Hovold <jhovold@gmail.com>
    serial: pch_uart: fix tty-kref leak in dma-rx path

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    target/file: Fix 32-bit highmem breakage for SGL -> iovec mapping

Hannes Reinecke <hare@suse.de>
    target: use correct sense code for LUN communication failure

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix MAINTENANCE_IN service action CDB checks to use lower 5 bits

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    target/pscsi: fix return value check

Roland Dreier <roland@purestorage.com>
    iscsi-target: Always send a response before terminating iSCSI connection

Mike Miller <mike.miller@hp.com>
    hpsa: gen8plus Smart Array IDs

Reddy, Sreekanth <Sreekanth.Reddy@lsi.com>
    mpt2sas: Fix for issue Missing delay not getting set during system bootup

Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
    mpt2sas: Fix for device scan following host reset could get stuck in a infinite loop

Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    isci: Fix a race condition in the SSP task management path

Stanislav Kinsbursky <skinsbursky@parallels.com>
    nfsd: check passed socket's net matches NFSd superblock's one

Stanislav Kinsbursky <skinsbursky@parallels.com>
    nfsd: containerize NFSd filesystem

Stanislav Kinsbursky <skinsbursky@parallels.com>
    nfsd: pass proper net to nfsd_destroy() from NFSd kthreads

Stanislav Kinsbursky <skinsbursky@parallels.com>
    nfsd: pass net to __write_ports() and down

Stanislav Kinsbursky <skinsbursky@parallels.com>
    nfsd: pass net to nfsd_set_nrthreads()

Stanislav Kinsbursky <skinsbursky@parallels.com>
    nfsd: pass net to nfsd_svc()

Stanislav Kinsbursky <skinsbursky@parallels.com>
    nfsd: pass net to nfsd_create_serv()

Stanislav Kinsbursky <skinsbursky@parallels.com>
    nfsd: pass net to nfsd_startup() and nfsd_shutdown()

Stanislav Kinsbursky <skinsbursky@parallels.com>
    nfsd: pass net to nfsd_init_socks()

Amit Shah <amit.shah@redhat.com>
    virtio: console: add locking around c_ovq operations

Amit Shah <amit.shah@redhat.com>
    virtio: console: rename cvq_lock to c_ivq_lock

Michael S. Tsirkin <mst@redhat.com>
    virtio_console: fix uapi header

Alexander Graf <agraf@suse.de>
    virtio-blk: Don't free ida when disk is in use

Will Deacon <will.deacon@arm.com>
    virtio: 9p: correctly pass physical address to userspace for high pages

Will Deacon <will.deacon@arm.com>
    mm: highmem: export kmap_to_page for modules

Ben Hutchings <ben@decadent.org.uk>
    mm: add kmap_to_page()

Asias He <asias@redhat.com>
    virtio-blk: Reset device after blk_cleanup_queue()

Asias He <asias@redhat.com>
    virtio-blk: Call del_gendisk() before disable guest kick

Asias He <asias@redhat.com>
    virtio-blk: Fix hot-unplug race in remove method

Asias He <asias@redhat.com>
    virtio_blk: Drop unused request tracking list

Raphael Kubo da Costa <rakuco@FreeBSD.org>
    Bluetooth: Add support for BCM20702A0 [0b05, 17cb]

Peng Chen <pengchen@qti.qualcomm.com>
    Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.

AceLan Kao <acelan.kao@canonical.com>
    Bluetooth: Add support for Atheros [0cf3:e003]

AceLan Kao <acelan.kao@canonical.com>
    Bluetooth: Add support for Atheros [0cf3:3121]

Sujith Manoharan <sujith@msujith.org>
    Bluetooth: ath3k: Add support for ID 0x13d3/0x3402

Thomas Loo <tloo@saltstorm.net>
    Bluetooth: ath3k: Add support for Fujitsu Lifebook UH5x2 [04c5:1330]

Cho, Yu-Chen <acho@suse.com>
    Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]

Noguchi Kazutosi <linux@scaltinof.net>
    Bluetooth: Add support for Foxconn/Hon Hai [0489:e04d]

Sunguk Lee <d3m3vilurr@gmail.com>
    Bluetooth: Device 0cf3:3008 should map AR 3012

Josh Boyer <jwboyer@redhat.com>
    Bluetooth: Add support for atheros 04ca:3004 device to ath3k

Sergio Cambra <sergio@programatica.es>
    Bluetooth device 04ca:3008 should use ath3k

AceLan Kao <acelan.kao@canonical.com>
    Bluetooth: Add support for Foxconn / Hon Hai [0489:e056]

AceLan Kao <acelan.kao@canonical.com>
    Bluetooth: Add support for Foxconn / Hon Hai [0489:e04e]

Daniel Schaal <farbing@web.de>
    Bluetooth: Add support for GC-WB300D PCIe [04ca:3006] to ath3k.

AceLan Kao <acelan.kao@canonical.com>
    Bluetooth: Add support for IMC Networks [13d3:3393]

Jeff Cook <jeff@deserettechnology.com>
    Bluetooth: Add support for BCM20702A0 [0b05, 17b5]

Jaroslav Resler <resler@cs.cas.cz>
    Bluetooth: Add support for BCM20702A0 [04ca, 2003]

Gustavo Padovan <gustavo.padovan@collabora.co.uk>
    Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for Broadcom/Foxconn

Yevgeniy Melnichuk <yevgeniy.melnichuk@googlemail.com>
    Bluetooth: Add support for Sony Vaio T-Series

Michael Gruetzner <mgruetzn@gmx.de>
    Bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C

Peng Chen <pengchen@qca.qualcomm.com>
    Bluetooth: add support for atheros 0489:e057

Giancarlo Formicuccia <giancarlo.formicuccia@gmail.com>
    Bluetooth: add support for atheros 0930:0219

Marek Vasut <marex@denx.de>
    Bluetooth: Support AR3011 in Acer Iconia Tab W500

Jaganath Kanakkassery <jaganath.k@samsung.com>
    Bluetooth: Fix invalid length check in l2cap_information_rsp()

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix missing length checks for L2CAP signalling PDUs

Andrey Ryabinin <a.ryabinin@samsung.com>
    mm: rmap: fix use-after-free in __put_anon_vma

Alan Stern <stern@rowland.harvard.edu>
    USB: Avoid runtime suspend loops for HCDs that can't handle suspend/resume

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix firmware download on big-endian machines (part 2)

Alexej Starschenko <starschenko@gmail.com>
    USB: serial: option: add support for Novatel E371 PCIe card

George McCollister <george.mccollister@gmail.com>
    USB: ftdi_sio: add NovaTech OrionLXm product ID

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup

Ronan Marquet <ronan.marquet@orange.fr>
    ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop

Ben Hutchings <ben@decadent.org.uk>
    Staging: speakup: Move pasting into a work item

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: delete endpoints from bandwidth list before freeing whole device

NeilBrown <neilb@suse.de>
    md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".

Lai Jiangshan <laijs@cn.fujitsu.com>
    sched: Fix hotplug vs. set_cpus_allowed_ptr()

Andrey Ryabinin <a.ryabinin@samsung.com>
    ARM: 8051/1: put_user: fix possible data corruption in put_user

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm/memory-failure.c: fix memory leak by race between poison and unpoison

Peter Zijlstra <peterz@infradead.org>
    perf: Fix race in removing an event

Peter Zijlstra <peterz@infradead.org>
    perf: Limit perf_event_attr::sample_period to 63 bits

Jiri Olsa <jolsa@redhat.com>
    perf: Prevent false warning in perf_swevent_add

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check


-------------

Diffstat:

 .../devicetree/bindings/tty/serial/of-serial.txt   |   3 +
 Makefile                                           |   4 +-
 arch/arm/include/asm/uaccess.h                     |   3 +-
 arch/x86/include/asm/xen/page.h                    |   1 +
 arch/x86/xen/enlighten.c                           |   1 -
 arch/x86/xen/mmu.c                                 |  23 ---
 arch/x86/xen/p2m.c                                 | 198 ++++++++++++++++-----
 arch/x86/xen/setup.c                               | 159 ++++++++++++++---
 arch/x86/xen/xen-ops.h                             |   1 -
 drivers/block/virtio_blk.c                         |  20 +--
 drivers/bluetooth/ath3k.c                          |  39 ++++
 drivers/bluetooth/btusb.c                          |  28 ++-
 drivers/char/virtio_console.c                      |  22 ++-
 drivers/md/md.c                                    |   4 +-
 drivers/scsi/hpsa.c                                |  32 +++-
 drivers/scsi/isci/task.c                           |   9 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c                |  13 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h                |   3 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               | 126 ++++++++++++-
 drivers/staging/speakup/main.c                     |   1 +
 drivers/staging/speakup/selection.c                |  38 +++-
 drivers/staging/speakup/speakup.h                  |   1 +
 drivers/target/iscsi/iscsi_target_login.c          |   8 +-
 drivers/target/iscsi/iscsi_target_nego.c           |  10 +-
 drivers/target/target_core_alua.c                  |   6 +-
 drivers/target/target_core_file.c                  |   9 +-
 drivers/target/target_core_pscsi.c                 |   8 +-
 drivers/target/target_core_transport.c             |   5 +-
 drivers/tty/serial/8250/8250.c                     |  36 +++-
 drivers/tty/serial/8250/8250.h                     |   1 +
 drivers/tty/serial/8250/8250_pci.c                 |  55 ++++--
 drivers/tty/serial/of_serial.c                     |   6 +
 drivers/tty/serial/pch_uart.c                      |   5 +-
 drivers/tty/tty_buffer.c                           |  11 +-
 drivers/usb/core/driver.c                          |   9 +-
 drivers/usb/core/hub.c                             |  15 +-
 drivers/usb/host/xhci-mem.c                        |  20 +--
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   5 +
 drivers/usb/serial/io_ti.c                         |   2 +-
 drivers/usb/serial/io_usbvend.h                    |   2 +-
 drivers/usb/serial/option.c                        |   2 +
 fs/nfsd/nfsctl.c                                   |  62 +++++--
 fs/nfsd/nfsd.h                                     |   6 +-
 fs/nfsd/nfssvc.c                                   |  41 +++--
 include/linux/highmem.h                            |   7 +
 include/linux/pci_ids.h                            |   1 +
 include/linux/serial_core.h                        |   6 +-
 include/linux/sunrpc/svcsock.h                     |   1 +
 include/linux/virtio_console.h                     |   2 +-
 kernel/cpu.c                                       |   6 +-
 kernel/events/core.c                               |  61 ++++---
 kernel/sched/core.c                                |   1 -
 kernel/sched/cpupri.c                              |   3 +-
 mm/highmem.c                                       |  13 ++
 mm/memory-failure.c                                |   2 +
 mm/rmap.c                                          |   3 +-
 net/9p/trans_virtio.c                              |   3 +-
 net/bluetooth/l2cap_core.c                         |  94 +++++++---
 net/sunrpc/svcsock.c                               |  16 ++
 sound/pci/hda/patch_realtek.c                      |  10 +-
 61 files changed, 983 insertions(+), 301 deletions(-)


