Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783Ab3BYWT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:19:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130Ab3BYWT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:19:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/58] 3.7.10-stable review
Date: Mon, 25 Feb 2013 14:18:56 -0800
Message-Id: <20130225221636.018756060@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----------------------------------------------------------------
NOTE:
	This is going to be the LAST 3.7.x kernel release.  After this,
	the 3.7 series is end-of-life, please start moving to 3.8 or
	newer at this point in time.
----------------------------------------------------------------

This is the start of the stable review cycle for the 3.7.10 release.
There are 58 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Feb 27 22:14:28 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.10-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.7.10-rc1

David S. Miller <davem@davemloft.net>
    sparc64: Fix huge PMD to PTE translation for sun4u in TLB miss handler.

David S. Miller <davem@davemloft.net>
    sparc64: Fix tsb_grow() in atomic context.

David S. Miller <davem@davemloft.net>
    sparc64: Handle hugepage TSB being NULL.

David S. Miller <davem@davemloft.net>
    sparc64: Fix gfp_flags setting in tsb_grow().

David S. Miller <davem@davemloft.net>
    sparc64: Fix get_user_pages_fast() wrt. THP.

David S. Miller <davem@davemloft.net>
    sparc64: Add missing HAVE_ARCH_TRANSPARENT_HUGEPAGE.

David S. Miller <davem@davemloft.net>
    sunvdc: Fix off-by-one in generic_request().

Bob Peterson <rpeterso@redhat.com>
    GFS2: Get a block reservation before resizing a file

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - hdmi: ELD shouldn't be valid after unplug

Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
    ALSA: hda - Workaround for silent output on Sony Vaio VGC-LN51JGB with ALC889

Anssi Hannula <anssi.hannula@iki.fi>
    ALSA: hda - Fix default multichannel HDMI mapping regression

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Release assigned pin/cvt at error path of hdmi_pcm_open()

Pawel Moll <mail@pawelmoll.com>
    ALSA: usb: Fix Processing Unit Descriptor parsers

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: fix Roland A-PRO support

Tomasz Guszkowski <tsg@o2.pl>
    p54usb: corrected USB ID for T-Com Sinus 154 data II

Weston Andros Adamson <dros@netapp.com>
    NFSv4.1: Don't decode skipped layoutgets

Trond Myklebust <Trond.Myklebust@netapp.com>
    NLM: Ensure that we resend all pending blocking locks after a reclaim

fanchaoting <fanchaoting@cn.fujitsu.com>
    umount oops when remove blocklayoutdriver first

Grant Likely <grant.likely@secretlab.ca>
    drivercore: Fix ordering between deferred_probe and exiting initcalls

Jan Beulich <jbeulich@suse.com>
    xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()

Mel Gorman <mgorman@suse.de>
    mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to discard all pages

Greg Thelen <gthelen@google.com>
    tmpfs: fix use-after-free of mempolicy object

Lars-Peter Clausen <lars@metafoo.de>
    drivers/video/backlight/adp88?0_bl.c: fix resume

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: unlock super lock if lockres refresh failed

MITSUNARI Shigeo <herumi@nifty.com>
    fs/block_dev.c: page cache wrongly left invalidated after revalidate_disk()

Jim Somerville <Jim.Somerville@windriver.com>
    inotify: remove broken mask checks causing unmount to be EINVAL

Thomas Gleixner <tglx@linutronix.de>
    futex: Revert "futex: Mark get_robust_list as deprecated"

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/kvm: Fix store status for ACRS/FPRS

Cornelia Huck <cornelia.huck@de.ibm.com>
    KVM: s390: Handle hosts not supporting s390-virtio.

Robin Holt <holt@sgi.com>
    mmu_notifier_unregister NULL Pointer deref and multiple ->release() callouts

Bjorn Helgaas <bhelgaas@google.com>
    Driver core: treat unregistered bus_types as having no devices

Minchan Kim <minchan@kernel.org>
    zram: Fix deadlock bug in partial read/write

Wei Liu <wei.liu2@citrix.com>
    xen: close evtchn port if binding to irq fails

Stefan Bader <stefan.bader@canonical.com>
    xen: Send spinlock IPI to all waiters

Nicolas Pitre <nicolas.pitre@linaro.org>
    tty vt: fix character insertion overflow

Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
    rtlwifi: usb: allocate URB control message setup_packet and data buffer separately

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Add new USB ID

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Increase number of RX DMA slots

Michael Chan <mchan@broadcom.com>
    serial_core: Fix type definition for PORT_BRCM_TRUMANAGE.

Thomas Gleixner <tglx@linutronix.de>
    serial: imx: Fix recursive locking bug

Johan Hovold <jhovold@gmail.com>
    USB: serial: fix null-pointer dereferences on disconnect

Oleg Nesterov <oleg@redhat.com>
    tty: set_termios/set_termiox should not return -EINTR

Dirkjan Bussink <d.bussink@gmail.com>
    tty: Prevent deadlock in n_gsm driver

Denis Efremov <yefremov.denis@gmail.com>
    ALSA: rme32.c irq enabling after spin_lock_irq

Denis Efremov <yefremov.denis@gmail.com>
    ALSA: ali5451: remove irq enabling in pointer callback

Konstantin Khlebnikov <khlebnikov@openvz.org>
    workqueue: un-GPL function delayed_work_timer_fn()

Olaf Hering <[mailto:olaf@aepfle.de]>
    x86: Hyper-V: register clocksource only if its advertised

Leonid Shatz <leonid.shatz@ravellosystems.com>
    hrtimer: Prevent hrtimer_enqueue_reprogram race

Stanislaw Gruszka <sgruszka@redhat.com>
    posix-cpu-timers: Fix nanosleep task_struct leak

Thomas Gleixner <tglx@linutronix.de>
    genirq: Avoid deadlock in spurious handling

H. Peter Anvin <hpa@linux.intel.com>
    timeconst.pl: Eliminate Perl warning

Linus Torvalds <torvalds@linux-foundation.org>
    mm: fix pageblock bitmap allocation

Jiri Olsa <jolsa@redhat.com>
    perf hists: Fix period symbol_conf.field_sep display

Vinson Lee <vlee@twitter.com>
    perf tools: Fix build with bison 2.3 and older.

H. Peter Anvin <hpa@linux.intel.com>
    x86-32, mm: Remove reference to alloc_remap()

H. Peter Anvin <hpa@linux.intel.com>
    x86-32, mm: Remove reference to resume_map_numa_kva()

Dave Hansen <dave@linux.vnet.ibm.com>
    x86-32, mm: Rip out x86_32 NUMA remapping code

Marcin Slusarz <marcin.slusarz@gmail.com>
    drm/nouveau/vm: fix memory corruption when pgt allocation fails


-------------

Diffstat:

 Makefile                                      |   4 +-
 arch/s390/kvm/kvm-s390.c                      |   8 ++
 arch/sparc/Kconfig                            |   1 +
 arch/sparc/include/asm/hugetlb.h              |   1 -
 arch/sparc/include/asm/page_64.h              |   4 +-
 arch/sparc/include/asm/pgtable_64.h           |  14 +--
 arch/sparc/include/asm/tsb.h                  |  28 +++--
 arch/sparc/kernel/tsb.S                       |  39 ++++++-
 arch/sparc/mm/fault_64.c                      |   9 +-
 arch/sparc/mm/gup.c                           |  59 +++++++++-
 arch/sparc/mm/init_64.c                       |  62 ++++++----
 arch/sparc/mm/tlb.c                           |  11 +-
 arch/sparc/mm/tsb.c                           |   2 +-
 arch/x86/Kconfig                              |   4 -
 arch/x86/include/asm/mmzone_32.h              |   6 -
 arch/x86/kernel/cpu/mshyperv.c                |   3 +-
 arch/x86/mm/numa.c                            |  32 ++---
 arch/x86/mm/numa_32.c                         | 161 --------------------------
 arch/x86/mm/numa_internal.h                   |   6 -
 arch/x86/power/hibernate_32.c                 |   2 -
 arch/x86/xen/spinlock.c                       |   1 -
 drivers/base/bus.c                            |   4 +-
 drivers/base/dd.c                             |   2 +
 drivers/block/sunvdc.c                        |   2 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c |   4 +-
 drivers/net/wireless/b43/dma.h                |   2 +-
 drivers/net/wireless/p54/p54usb.c             |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c   |   1 +
 drivers/net/wireless/rtlwifi/usb.c            |  44 ++++---
 drivers/s390/kvm/kvm_virtio.c                 |  38 ++++--
 drivers/staging/zram/zram_drv.c               |   9 +-
 drivers/tty/n_gsm.c                           |  42 ++++++-
 drivers/tty/serial/imx.c                      |  11 +-
 drivers/tty/tty_ioctl.c                       |   4 +-
 drivers/tty/vt/vt.c                           |   2 +-
 drivers/usb/serial/ftdi_sio.c                 |  20 ++--
 drivers/usb/serial/mct_u232.c                 |  22 ++--
 drivers/usb/serial/quatech2.c                 |  18 ++-
 drivers/usb/serial/sierra.c                   |   8 +-
 drivers/usb/serial/ssu100.c                   |  19 ++-
 drivers/usb/serial/usb-serial.c               |  14 ++-
 drivers/usb/serial/usb_wwan.c                 |   8 +-
 drivers/video/backlight/adp8860_bl.c          |   2 +-
 drivers/video/backlight/adp8870_bl.c          |   2 +-
 drivers/xen/evtchn.c                          |  10 ++
 drivers/xen/xen-pciback/pciback_ops.c         |  14 +--
 fs/block_dev.c                                |   1 +
 fs/gfs2/bmap.c                                |   4 +
 fs/lockd/clntproc.c                           |   3 +
 fs/nfs/blocklayout/blocklayout.c              |   1 +
 fs/nfs/nfs4proc.c                             |   3 +-
 fs/nfs/objlayout/objio_osd.c                  |   1 +
 fs/notify/inotify/inotify_user.c              |   4 -
 fs/ocfs2/dlmglue.c                            |   5 +-
 include/uapi/linux/serial_core.h              |   2 +-
 include/uapi/linux/usb/audio.h                |   6 +-
 kernel/futex.c                                |   2 -
 kernel/futex_compat.c                         |   2 -
 kernel/hrtimer.c                              |  36 +++---
 kernel/irq/spurious.c                         |   7 +-
 kernel/posix-cpu-timers.c                     |  23 +++-
 kernel/timeconst.pl                           |   6 +-
 kernel/workqueue.c                            |   2 +-
 mm/fadvise.c                                  |  18 ++-
 mm/mmu_notifier.c                             |  82 ++++++-------
 mm/page_alloc.c                               |  15 ++-
 mm/shmem.c                                    |  10 +-
 sound/pci/ali5451/ali5451.c                   |   2 +-
 sound/pci/hda/patch_hdmi.c                    |  18 ++-
 sound/pci/hda/patch_realtek.c                 |   1 +
 sound/pci/rme32.c                             |   2 +-
 sound/usb/quirks-table.h                      |   2 +-
 tools/perf/Makefile                           |   4 +-
 tools/perf/ui/hist.c                          |   6 +-
 tools/perf/util/parse-events.y                |   1 -
 tools/perf/util/pmu.y                         |   1 -
 76 files changed, 562 insertions(+), 469 deletions(-)


