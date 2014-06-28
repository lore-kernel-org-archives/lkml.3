Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbaF1RvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:51:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaF1RvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.15 000/139] 3.15.3-stable review
Date: Sat, 28 Jun 2014 10:46:01 -0700
Message-Id: <20140628174605.352098823@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.15.3 release.
There are 139 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Jun 30 17:45:39 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.15.3-rc1

Andrzej Zaborowski <andrew.zaborowski@intel.com>
    efi-pstore: Fix an overflow on 32-bit builds

Fathi Boudra <fathi.boudra@linaro.org>
    builddeb: use $OBJCOPY variable instead of objcopy

Theodore Ts'o <tytso@mit.edu>
    random: fix nasty entropy accounting bug

Konstantin Khlebnikov <koct9i@gmail.com>
    epoll: fix use-after-free in eventpoll_release_file

Andy Lutomirski <luto@amacapital.net>
    x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lz4: fix another possible overrun

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix properly ignoring LTKs of unknown types

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Clearly distinguish mgmt LTK type from authenticated property

Eric Sandeen <sandeen@redhat.com>
    btrfs: fix use of uninit "ret" in end_extent_writepage()

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: fix scrub_print_warning to handle skinny metadata extents

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: use right type to get real comparison

Josef Bacik <jbacik@fb.com>
    Btrfs: don't check nodes for extent items

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
    fs: btrfs: volumes.c: Fix for possible null pointer dereference

Jeff Mahoney <jeffm@suse.com>
    btrfs: allocate raid type kobjects dynamically

Filipe Manana <fdmanana@gmail.com>
    Btrfs: send, use the right limits for xattr names and values

Filipe Manana <fdmanana@gmail.com>
    Btrfs: send, don't error in the presence of subvols/snapshots

Wang Shilong <wangsl.fnst@cn.fujitsu.com>
    Btrfs: set right total device count for seeding support

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: mark mapping with error flag to report errors to userspace

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: fix NULL pointer crash of deleting a seed device

Wang Shilong <wangsl.fnst@cn.fujitsu.com>
    Btrfs: make sure there are not any read requests before stopping workers

Filipe Manana <fdmanana@gmail.com>
    Btrfs: send, account for orphan directories when building path strings

Miao Xie <miaox@cn.fujitsu.com>
    Btrfs: output warning instead of error when loading free space cache failed

Qu Wenruo <quwenruo@cn.fujitsu.com>
    btrfs: Add ctime/mtime update for btrfs device add/remove.

Filipe Manana <fdmanana@gmail.com>
    Btrfs: read inode size after acquiring the mutex when punching a hole

Chris Mason <clm@fb.com>
    Btrfs: fix double free in find_lock_delalloc_range

Filipe Manana <fdmanana@gmail.com>
    Btrfs: fix leaf corruption caused by ENOSPC while hole punching

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix memory leaks in SMB2_open

Benjamin LaHaise <bcrl@kvack.org>
    aio: fix kernel memory disclosure in io_getevents() introduced in v3.10

Benjamin LaHaise <bcrl@kvack.org>
    aio: fix aio request leak when events are reaped by userspace

Thomas Gleixner <tglx@linutronix.de>
    genirq: Sanitize spurious interrupt detection of threaded irqs

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Revert "offb: Add palette hack for little endian"

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/radeon: use variable UVD clocks"

Mike Frysinger <vapier@gentoo.org>
    x86, x32: Use compat shims for io_{setup,submit}

H. Peter Anvin <hpa@linux.intel.com>
    x86-32, espfix: Remove filter for espfix32 due to race

Will Deacon <will.deacon@arm.com>
    arm64: mm: remove broken &= operator from pmd_mknotpresent

Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
    arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro

Will Deacon <will.deacon@arm.com>
    arm64: uid16: fix __kernel_old_{gid,uid}_t definitions

Jason Cooper <jason@lakedaemon.net>
    ARM: mvebu: DT: fix OpenBlocks AX3-4 RAM size

Jaegeuk Kim <jaegeuk.kim@samsung.com>
    f2fs: submit bio at the reclaim path

Sagi Grimberg <sagig@mellanox.com>
    TARGET/sbc,loopback: Adjust command data length in case pi exists on the wire

Sagi Grimberg <sagig@mellanox.com>
    libiscsi, iser: Adjust data_length to include protection information

Sagi Grimberg <sagig@mellanox.com>
    scsi_cmnd: Introduce scsi_transfer_length helper

Roland Dreier <roland@purestorage.com>
    target: Report correct response length for some commands

Sagi Grimberg <sagig@mellanox.com>
    Target/iscsi: Fix sendtargets response pdu for iser transport

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Fix a wrong dereference in case discovery session is over iser

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix ABORT_TASK + connection reset iscsi_queue_req memory leak

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Use complete_all for se_cmd->t_transport_stop_comp

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Set CMD_T_ACTIVE bit for Task Management Requests

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Gracefully reject T10-PI enabled connect request if not supported

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Wait for proper cleanup before unloading

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Improve cm events handling

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Fix hangs in connection teardown

Sagi Grimberg <sagig@mellanox.com>
    Target/iser: Bail from accept_np if np_thread is trying to close

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix missing check for FIPS security level

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix requiring SMP MITM for outgoing connections

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix authentication check for FIPS security level

Jukka Taimisto <jtt@codenomicon.com>
    Bluetooth: Fix L2CAP deadlock

Jukka Rissanen <jukka.rissanen@linux.intel.com>
    Bluetooth: 6LoWPAN: Fix MAC address universal/local bit handling

Felipe Balbi <balbi@ti.com>
    bluetooth: hci_ldisc: fix deadlock condition

Chander Kashyap <chander.kashyap@linaro.org>
    PM / OPP: fix incorrect OPP count handling in of_init_opp_table

Pekon Gupta <pekon@ti.com>
    ARM: OMAP2+: gpmc: enable BCH_HW ecc-scheme for AM43xx platforms

Jianguo Wu <wujianguo@huawei.com>
    ARM: 8037/1: mm: support big-endian page tables

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: stacktrace: avoid listing stacktrace functions in stacktrace

Hans Verkuil <hans.verkuil@cisco.com>
    media: saa7134: fix regression with tvtime

Pali Rohár <pali.rohar@gmail.com>
    media: radio-bcm2048: fix wrong overflow check

Olivier Langlois <olivier@trillion01.com>
    media: uvcvideo: Fix clock param realtime setting

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Plug slow unlock race

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Handle deadlock detection smarter

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Detect changes in the pi lock chain

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / ia64 / sba_iommu: Restore the working initialization ordering

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / hotplug / PCI: Add hotplug contexts to PCI host bridges

Lv Zheng <lv.zheng@intel.com>
    ACPI: Fix conflict between customized DSDT and DSDT local copy

David Binderman <dcb314@hotmail.com>
    ACPICA: utstring: Check array index bound before use.

Bjørn Mork <bjorn@mork.no>
    ACPI: add dynamic_debug support

Sylwester Nawrocki <s.nawrocki@samsung.com>
    media: exynos4-is: Fix compilation for !CONFIG_COMMON_CLK

Sylwester Nawrocki <s.nawrocki@samsung.com>
    media: exynos4-is: Free FIMC-IS CPU memory only when allocated

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

Namjae Jeon <namjae.jeon@samsung.com>
    ext4: fix ZERO_RANGE test failure in data journalling

Jan Kara <jack@suse.cz>
    ext4: fix zeroing of page during writeback

Namjae Jeon <namjae.jeon@samsung.com>
    ext4: fix data integrity sync in ordered mode

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    regulator: s2mpa01: Fix accidental enable of buck4 ramp delay

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    regulator: s2mps11: Fix accidental enable of buck6 ramp delay

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    regulator: s2mpa01: Use correct register for buck1 ramp delay

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/lowcore: reserve 96 bytes for IRB in lowcore

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/time: cast tv_nsec to u64 prior to shift in update_vsyscall

Lai Jiangshan <laijs@cn.fujitsu.com>
    idr: fix overflow bug during maximum ID calculation at maximum height

Victor Kamensky <victor.kamensky@linaro.org>
    arm64: ptrace: fix empty registers set in prstatus of aarch32 process core

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

Weijie Yang <weijie.yang@samsung.com>
    zram: correct offset usage in zram_bio_discard

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm/memory-failure.c: support use of a dedicated thread to handle SIGBUS(BUS_MCEERR_AO)

Tony Luck <tony.luck@intel.com>
    mm/memory-failure.c: don't let collect_procs() skip over processes for MF_ACTION_REQUIRED

Tony Luck <tony.luck@intel.com>
    mm/memory-failure.c-failure: send right signal code to correct thread

Mel Gorman <mgorman@suse.de>
    mm: page_alloc: use word-based accesses for get/set pageblock bitmaps

Michal Hocko <mhocko@suse.cz>
    memcg: do not hang on OOM when killed by userspace OOM access to memory reserves

Mel Gorman <mgorman@suse.de>
    mm: vmscan: do not throttle based on pfmemalloc reserves if node has no ZONE_NORMAL

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    kthread: fix return value of kthread_create() upon SIGKILL.

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    hugetlb: restrict hugepage_migration_support() to x86_64

Konstantin Khlebnikov <koct9i@gmail.com>
    tools/vm/page-types.c: catch sigbus if raced with truncate

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

Stephen Boyd <sboyd@codeaurora.org>
    staging/mt29f_spinand: Terminate of match table

Dan Carpenter <dan.carpenter@oracle.com>
    Staging: rtl8188eu: overflow in update_sta_support_rate()

Paul Bolle <pebolle@tiscali.nl>
    staging: tidspbridge: check for CONFIG_SND_OMAP_SOC_MCBSP

Antoine Ténart <antoine.tenart@free-electrons.com>
    phy: exynos-mipi-video: fix check on array index

Stephen Chivers <schivers@csc.com>
    printk/of_serial: fix serial console cessation part way through boot.

Alexey Khoroshilov <khoroshilov@ispras.ru>
    w1: do not unlock unheld list_mutex in __w1_remove_master_device()

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    extcon: max14577: Properly handle regmap_irq_get_virq error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    extcon: max14577: Fix probe failure on successful work queue

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    extcon: max77693: Fix two NULL pointer exceptions on missing pdata

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    extcon: max8997: Fix NULL pointer exception on missing pdata

Ming Lei <ming.lei@canonical.com>
    block: virtio_blk: don't hold spin lock during world switch

Russell King <rmk+kernel@arm.linux.org.uk>
    imx-drm: fix hdmi hotplug detection initial state


-------------

Diffstat:

 Documentation/vm/hwpoison.txt                    |   5 +
 Makefile                                         |   4 +-
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts |   2 +-
 arch/arm/kernel/stacktrace.c                     |  18 +-
 arch/arm/mach-omap1/board-h2.c                   |   2 +-
 arch/arm/mach-omap1/board-h3.c                   |   2 +-
 arch/arm/mach-omap1/board-innovator.c            |   2 +-
 arch/arm/mach-omap1/board-osk.c                  |   2 +-
 arch/arm/mach-omap2/gpmc-nand.c                  |   2 +-
 arch/arm/mm/hugetlbpage.c                        |   5 -
 arch/arm/mm/proc-v7-3level.S                     |  18 +-
 arch/arm64/include/asm/Kbuild                    |   1 -
 arch/arm64/include/asm/dma-mapping.h             |   2 -
 arch/arm64/include/asm/pgtable.h                 |   2 +-
 arch/arm64/include/uapi/asm/posix_types.h        |  10 +
 arch/arm64/kernel/ptrace.c                       |  32 ++-
 arch/arm64/mm/hugetlbpage.c                      |   5 -
 arch/ia64/hp/common/sba_iommu.c                  |  64 +++---
 arch/ia64/mm/hugetlbpage.c                       |   5 -
 arch/metag/mm/hugetlbpage.c                      |   5 -
 arch/mips/mm/hugetlbpage.c                       |   5 -
 arch/powerpc/mm/hugetlbpage.c                    |  10 -
 arch/s390/include/asm/lowcore.h                  |  11 +-
 arch/s390/kernel/time.c                          |   2 +-
 arch/s390/mm/hugetlbpage.c                       |   5 -
 arch/sh/mm/hugetlbpage.c                         |   5 -
 arch/sparc/mm/hugetlbpage.c                      |   5 -
 arch/tile/mm/hugetlbpage.c                       |   5 -
 arch/x86/Kconfig                                 |   4 +
 arch/x86/kernel/entry_32.S                       |  15 +-
 arch/x86/mm/hugetlbpage.c                        |  10 -
 arch/x86/syscalls/syscall_64.tbl                 |   6 +-
 drivers/acpi/acpica/utstring.c                   |   2 +-
 drivers/acpi/bus.c                               |   7 +
 drivers/acpi/utils.c                             |  64 ++++--
 drivers/base/power/opp.c                         |   4 +-
 drivers/block/virtio_blk.c                       |   9 +-
 drivers/block/zram/zram_drv.c                    |   4 +-
 drivers/bluetooth/hci_ldisc.c                    |  24 ++-
 drivers/bluetooth/hci_uart.h                     |   1 +
 drivers/char/applicom.c                          |   1 -
 drivers/char/random.c                            |  17 +-
 drivers/extcon/extcon-max14577.c                 |   9 +-
 drivers/extcon/extcon-max77693.c                 |   4 +-
 drivers/extcon/extcon-max8997.c                  |   2 +-
 drivers/firmware/efi/efi-pstore.c                |   2 +-
 drivers/gpu/drm/radeon/radeon_pm.c               |   3 +
 drivers/gpu/drm/radeon/radeon_uvd.c              |   3 +-
 drivers/hid/hid-core.c                           |  12 +-
 drivers/infiniband/ulp/iser/iser_initiator.c     |  34 +---
 drivers/infiniband/ulp/isert/ib_isert.c          |  70 +++----
 drivers/infiniband/ulp/isert/ib_isert.h          |   2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c           |   6 +
 drivers/media/pci/saa7134/saa7134-video.c        |   9 +-
 drivers/media/platform/exynos4-is/fimc-is.c      |   3 +
 drivers/media/platform/exynos4-is/media-dev.c    |   2 +-
 drivers/media/platform/exynos4-is/media-dev.h    |   4 +
 drivers/media/usb/stk1160/stk1160-core.c         |  10 +-
 drivers/media/usb/stk1160/stk1160.h              |   1 -
 drivers/media/usb/uvc/uvc_video.c                |  15 +-
 drivers/pci/hotplug/acpiphp.h                    |  10 +
 drivers/pci/hotplug/acpiphp_glue.c               |  60 ++++--
 drivers/phy/phy-exynos-mipi-video.c              |   2 +-
 drivers/regulator/s2mpa01.c                      |  15 +-
 drivers/regulator/s2mps11.c                      |  15 +-
 drivers/scsi/libiscsi.c                          |  18 +-
 drivers/staging/imx-drm/imx-hdmi.c               |   9 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c    |   2 +-
 drivers/staging/mt29f_spinand/mt29f_spinand.c    |   1 +
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c   |   7 +-
 drivers/staging/tidspbridge/core/dsp-clock.c     |   4 +-
 drivers/target/iscsi/iscsi_target.c              |  17 +-
 drivers/target/loopback/tcm_loop.c               |  15 +-
 drivers/target/target_core_sbc.c                 |  19 +-
 drivers/target/target_core_spc.c                 |   9 +-
 drivers/target/target_core_transport.c           |  29 ++-
 drivers/tty/serial/of_serial.c                   |   1 +
 drivers/usb/dwc3/gadget.c                        |   4 +
 drivers/usb/gadget/inode.c                       |   2 +-
 drivers/usb/host/pci-quirks.c                    |  19 +-
 drivers/usb/misc/usbtest.c                       |  26 ++-
 drivers/usb/phy/phy-isp1301-omap.c               |   2 +-
 drivers/usb/serial/bus.c                         |  14 +-
 drivers/usb/serial/option.c                      |  11 +-
 drivers/usb/serial/qcserial.c                    |  21 ++
 drivers/usb/serial/sierra.c                      |  55 +++--
 drivers/usb/serial/usb_wwan.c                    | 125 ++++++------
 drivers/video/fbdev/matrox/matroxfb_base.h       |   2 +-
 drivers/video/fbdev/offb.c                       |  11 +-
 drivers/w1/w1.c                                  |   2 +
 drivers/w1/w1_int.c                              |   4 +
 fs/aio.c                                         |   6 +-
 fs/btrfs/backref.c                               |  37 ++--
 fs/btrfs/backref.h                               |   4 +-
 fs/btrfs/ctree.h                                 |   8 +-
 fs/btrfs/disk-io.c                               |   5 +
 fs/btrfs/extent-tree.c                           |  39 ++--
 fs/btrfs/extent_io.c                             |   5 +-
 fs/btrfs/file.c                                  |  23 ++-
 fs/btrfs/free-space-cache.c                      |   4 +-
 fs/btrfs/scrub.c                                 |   5 +-
 fs/btrfs/send.c                                  |  67 ++++---
 fs/btrfs/sysfs.c                                 |   5 +-
 fs/btrfs/volumes.c                               |  44 +++-
 fs/cifs/smb2pdu.c                                |   7 +-
 fs/eventpoll.c                                   |   4 +-
 fs/ext4/ext4.h                                   |   3 +-
 fs/ext4/extents.c                                |   7 +
 fs/ext4/inode.c                                  |   6 +-
 fs/ext4/mballoc.c                                |   2 +-
 fs/ext4/page-io.c                                |  32 +--
 fs/f2fs/data.c                                   |   2 +
 include/linux/acpi.h                             |  22 +-
 include/linux/hugetlb.h                          |  13 +-
 include/linux/irqdesc.h                          |   4 +
 include/linux/mempolicy.h                        |   6 +
 include/linux/mmzone.h                           |   6 +-
 include/linux/page-flags.h                       |  12 +-
 include/linux/pageblock-flags.h                  |  37 +++-
 include/linux/ptrace.h                           |  32 +++
 include/net/bluetooth/mgmt.h                     |   3 +
 include/scsi/scsi_cmnd.h                         |  17 ++
 include/target/iscsi/iscsi_transport.h           |   3 +-
 include/target/target_core_backend.h             |   1 +
 kernel/fork.c                                    |  10 +-
 kernel/irq/manage.c                              |   4 +-
 kernel/irq/spurious.c                            | 106 +++++++++-
 kernel/kthread.c                                 |   4 +-
 kernel/locking/rtmutex-debug.h                   |   5 +
 kernel/locking/rtmutex.c                         | 243 +++++++++++++++++++----
 kernel/locking/rtmutex.h                         |   5 +
 kernel/printk/printk.c                           |   1 +
 lib/idr.c                                        |   8 +-
 lib/lz4/lz4_decompress.c                         |   4 +-
 mm/Kconfig                                       |   3 +
 mm/memcontrol.c                                  |   3 +-
 mm/memory-failure.c                              |  73 +++++--
 mm/page-writeback.c                              |  11 +-
 mm/page_alloc.c                                  |  52 +++--
 mm/rmap.c                                        |   8 +-
 mm/vmscan.c                                      |  46 ++++-
 net/bluetooth/6lowpan.c                          |  65 +++---
 net/bluetooth/hci_event.c                        |   4 +-
 net/bluetooth/l2cap_sock.c                       |   5 +-
 net/bluetooth/mgmt.c                             |  25 ++-
 net/bluetooth/smp.c                              |   7 +-
 scripts/package/builddeb                         |   6 +-
 tools/vm/page-types.c                            |  35 +++-
 148 files changed, 1638 insertions(+), 692 deletions(-)


