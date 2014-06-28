Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbaF1TMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:12:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaF1Rr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/77] 3.10.46-stable review
Date: Sat, 28 Jun 2014 10:45:53 -0700
Message-Id: <20140628174521.691276402@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.46 release.
There are 77 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Jun 30 17:45:02 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.46-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.46-rc1

Andy Lutomirski <luto@amacapital.net>
    x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Wait for proper cleanup before unloading

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Improve cm events handling

Roger Quadros <rogerq@ti.com>
    usb: usbtest: Add timetout to simple_io()

Eric Sandeen <sandeen@redhat.com>
    btrfs: fix use of uninit "ret" in end_extent_writepage()

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: fix scrub_print_warning to handle skinny metadata extents

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: use right type to get real comparison

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
    fs: btrfs: volumes.c: Fix for possible null pointer dereference

Filipe Manana <fdmanana@gmail.com>
    Btrfs: send, don't error in the presence of subvols/snapshots

Wang Shilong <wangsl.fnst@cn.fujitsu.com>
    Btrfs: set right total device count for seeding support

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: mark mapping with error flag to report errors to userspace

Wang Shilong <wangsl.fnst@cn.fujitsu.com>
    Btrfs: make sure there are not any read requests before stopping workers

Miao Xie <miaox@cn.fujitsu.com>
    Btrfs: output warning instead of error when loading free space cache failed

Qu Wenruo <quwenruo@cn.fujitsu.com>
    btrfs: Add ctime/mtime update for btrfs device add/remove.

Chris Mason <clm@fb.com>
    Btrfs: fix double free in find_lock_delalloc_range

Michael S. Tsirkin <mst@redhat.com>
    skbuff: skb_segment: orphan frags before copying

Benjamin LaHaise <bcrl@kvack.org>
    aio: fix kernel memory disclosure in io_getevents() introduced in v3.10

Benjamin LaHaise <bcrl@kvack.org>
    aio: fix aio request leak when events are reaped by userspace

Thomas Gleixner <tglx@linutronix.de>
    genirq: Sanitize spurious interrupt detection of threaded irqs

Mike Frysinger <vapier@gentoo.org>
    x86, x32: Use compat shims for io_{setup,submit}

H. Peter Anvin <hpa@linux.intel.com>
    x86-32, espfix: Remove filter for espfix32 due to race

Nicholas A. Bellinger <nab@linux-iscsi.org>
    target: Explicitly clear ramdisk_mcp backend pages

Roland Dreier <roland@purestorage.com>
    target: Report correct response length for some commands

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix ABORT_TASK + connection reset iscsi_queue_req memory leak

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Use complete_all for se_cmd->t_transport_stop_comp

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Set CMD_T_ACTIVE bit for Task Management Requests

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Fix hangs in connection teardown

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Bail from accept_np if np_thread is trying to close

Jukka Taimisto <jtt@codenomicon.com>
    Bluetooth: Fix L2CAP deadlock

Felipe Balbi <balbi@ti.com>
    bluetooth: hci_ldisc: fix deadlock condition

Jianguo Wu <wujianguo@huawei.com>
    ARM: 8037/1: mm: support big-endian page tables

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: stacktrace: avoid listing stacktrace functions in stacktrace

Olivier Langlois <olivier@trillion01.com>
    media: uvcvideo: Fix clock param realtime setting

Lv Zheng <lv.zheng@intel.com>
    ACPI: Fix conflict between customized DSDT and DSDT local copy

David Binderman <dcb314@hotmail.com>
    ACPICA: utstring: Check array index bound before use.

Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    media: stk1160: Avoid stack-allocated buffer for control URBs

Takashi Iwai <tiwai@suse.de>
    media: ivtv: Fix Oops when no firmware is loaded

Johan Hovold <jhovold@gmail.com>
    USB: serial: fix potential runtime pm imbalance at device remove

Aleksander Morgado <aleksander@aleksander.es>
    usb: qcserial: add additional Sierra Wireless QMI devices

Aleksander Morgado <aleksander@aleksander.es>
    usb: qcserial: add Netgear AirCard 341U

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

Jan Kara <jack@suse.cz>
    ext4: fix zeroing of page during writeback

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/lowcore: reserve 96 bytes for IRB in lowcore

Lai Jiangshan <laijs@cn.fujitsu.com>
    idr: fix overflow bug during maximum ID calculation at maximum height

Will Deacon <will.deacon@arm.com>
    arm64: ptrace: change fs when passing kernel pointer to regset code

Matthew Dempsky <mdempsky@chromium.org>
    ptrace: fix fork event messages across pid namespaces

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

Mel Gorman <mgorman@suse.de>
    mm: vmscan: do not throttle based on pfmemalloc reserves if node has no ZONE_NORMAL

Johan Hovold <jhovold@gmail.com>
    USB: option: fix runtime PM handling

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: avoid BIOS handover on the HASEE E200

Paul Bolle <pebolle@tiscali.nl>
    ARM: OMAP: replace checks for CONFIG_USB_GADGET_OMAP

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

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    extcon: max8997: Fix NULL pointer exception on missing pdata

Johan Hovold <jhovold@gmail.com>
    net: cpsw: fix null dereference at probe

Ursula Braun <ursula.braun@de.ibm.com>
    af_iucv: wrong mapping of sent and confirmed skbs

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_pci: prevent use after free at netdev removal


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/arm/kernel/stacktrace.c                 |  18 ++--
 arch/arm/mach-omap1/board-h2.c               |   2 +-
 arch/arm/mach-omap1/board-h3.c               |   2 +-
 arch/arm/mach-omap1/board-innovator.c        |   2 +-
 arch/arm/mach-omap1/board-osk.c              |   2 +-
 arch/arm/mm/proc-v7-3level.S                 |  18 ++--
 arch/arm64/kernel/ptrace.c                   |   4 +
 arch/s390/include/asm/lowcore.h              |  11 +--
 arch/x86/kernel/entry_32.S                   |  15 ++--
 arch/x86/syscalls/syscall_64.tbl             |   6 +-
 drivers/acpi/acpica/utstring.c               |   2 +-
 drivers/acpi/bus.c                           |   7 ++
 drivers/bluetooth/hci_ldisc.c                |  24 +++--
 drivers/bluetooth/hci_uart.h                 |   1 +
 drivers/char/applicom.c                      |   1 -
 drivers/extcon/extcon-max8997.c              |   2 +-
 drivers/hid/hid-core.c                       |  12 ++-
 drivers/infiniband/ulp/isert/ib_isert.c      |  59 ++++++-------
 drivers/infiniband/ulp/isert/ib_isert.h      |   2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c       |   6 ++
 drivers/media/usb/stk1160/stk1160-core.c     |  10 ++-
 drivers/media/usb/stk1160/stk1160.h          |   1 -
 drivers/media/usb/uvc/uvc_video.c            |  15 ++--
 drivers/net/can/sja1000/peak_pci.c           |  14 +--
 drivers/net/ethernet/ti/cpsw.c               |   4 +
 drivers/staging/tidspbridge/core/dsp-clock.c |   4 +-
 drivers/target/iscsi/iscsi_target.c          |   3 +-
 drivers/target/target_core_rd.c              |   2 +-
 drivers/target/target_core_sbc.c             |   4 +-
 drivers/target/target_core_spc.c             |   9 +-
 drivers/target/target_core_transport.c       |  29 ++++++-
 drivers/usb/dwc3/gadget.c                    |   4 +
 drivers/usb/gadget/inode.c                   |   2 +-
 drivers/usb/host/pci-quirks.c                |  19 +++-
 drivers/usb/misc/usbtest.c                   |  40 ++++++++-
 drivers/usb/phy/phy-isp1301-omap.c           |   2 +-
 drivers/usb/serial/bus.c                     |  14 ++-
 drivers/usb/serial/option.c                  |  11 ++-
 drivers/usb/serial/qcserial.c                |  21 +++++
 drivers/usb/serial/sierra.c                  |  55 +++++++++---
 drivers/usb/serial/usb_wwan.c                | 125 ++++++++++++++-------------
 drivers/video/matrox/matroxfb_base.h         |   2 +-
 fs/aio.c                                     |   6 +-
 fs/btrfs/backref.c                           |  32 ++++---
 fs/btrfs/backref.h                           |   4 +-
 fs/btrfs/disk-io.c                           |   5 ++
 fs/btrfs/extent_io.c                         |   5 +-
 fs/btrfs/free-space-cache.c                  |   4 +-
 fs/btrfs/scrub.c                             |   5 +-
 fs/btrfs/send.c                              |   4 +
 fs/btrfs/volumes.c                           |  32 +++++--
 fs/ext4/mballoc.c                            |   2 +-
 fs/ext4/page-io.c                            |  24 +++--
 include/linux/irqdesc.h                      |   4 +
 include/linux/ptrace.h                       |  32 +++++++
 include/target/target_core_backend.h         |   1 +
 kernel/fork.c                                |  10 ++-
 kernel/irq/manage.c                          |   4 +-
 kernel/irq/spurious.c                        | 106 ++++++++++++++++++++++-
 lib/idr.c                                    |   8 +-
 mm/memory-failure.c                          |  25 +++---
 mm/rmap.c                                    |   8 +-
 mm/vmscan.c                                  |  46 ++++++++--
 net/bluetooth/l2cap_sock.c                   |   5 +-
 net/core/skbuff.c                            |   2 +
 net/iucv/af_iucv.c                           |   2 +-
 67 files changed, 709 insertions(+), 257 deletions(-)


