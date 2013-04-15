Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab3DOCnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:43:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab3DOCn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/27] 3.8.8-stable review
Date: Sun, 14 Apr 2013 19:42:59 -0700
Message-Id: <20130415024231.351969241@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.8.8 release.
There are 27 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Apr 17 02:41:37 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.8.8-rc1

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    tty: don't deadlock while flushing workqueue

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare metal

Samu Kallio <samu.kallio@aberdeencloud.com>
    x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

Thomas Gleixner <tglx@linutronix.de>
    sched_clock: Prevent 64bit inatomicity on 32bit systems

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section

Dave Airlie <airlied@gmail.com>
    udl: handle EDID failure properly.

Namhyung Kim <namhyung.kim@lge.com>
    tracing: Fix possible NULL pointer dereferences

Dave Hansen <dave@sr71.net>
    x86-32: Fix possible incomplete TLB invalidate with PAE pagetables

Haojian Zhuang <haojian.zhuang@linaro.org>
    gpio: fix wrong checking condition for gpio range

Linus Torvalds <torvalds@linux-foundation.org>
    kobject: fix kset_find_obj() race with concurrent last kobject_put()

Suleiman Souhlal <suleiman@google.com>
    vfs: Revert spurious fix to spinning prevention in prune_icache_sb

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition CDBs

Sachin Prabhu <sprabhu@redhat.com>
    cifs: Allow passwords which begin with a delimitor

Lukasz Dorau <lukasz.dorau@intel.com>
    SCSI: libsas: fix handling vacant phy in sas_set_ex_phy()

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    GFS2: return error if malloc failed in gfs2_rs_alloc()

Steven Whitehouse <swhiteho@redhat.com>
    GFS2: Fix unlock of fcntl locks during withdrawn state

Stanislav Kinsbursky <skinsbursky@parallels.com>
    ipc: set msg back to -EAGAIN if copy wasn't performed

John W. Linville <linville@tuxdriver.com>
    Revert "brcmsmac: support 4313iPA"

Huacai Chen <chenhc@lemote.com>
    PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()

Peter Ujfalusi <peter.ujfalusi@ti.com>
    dmaengine: omap-dma: Start DMA without delay for cyclic channels

Markus Pargmann <mpa@pengutronix.de>
    ARM: imx35 Bugfix admux clock

Nigel Roberts <nigel@nobiscuit.com>
    ARM: Kirkwood: Fix typo in the definition of ix2-200 rebuild LED

Namhyung Kim <namhyung.kim@lge.com>
    tracing: Fix double free when function profile init failed

Alban Bedel <alban.bedel@avionic-design.de>
    ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is running

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm5102: Correct lookup of arizona struct in SYSCLK event

Joonyoung Shim <jy0922.shim@samsung.com>
    ASoC: core: Fix to check return value of snd_soc_update_bits_locked()

Eldad Zack <eldad@fogrefinery.com>
    ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts      |  14 +-
 arch/arm/mach-imx/clk-imx35.c                      |   1 +
 arch/x86/include/asm/paravirt.h                    |   5 +-
 arch/x86/include/asm/paravirt_types.h              |   2 +
 arch/x86/include/asm/tlb.h                         |   2 +-
 arch/x86/kernel/paravirt.c                         |  25 +-
 arch/x86/lguest/boot.c                             |   1 +
 arch/x86/mm/fault.c                                |   6 +-
 arch/x86/mm/pgtable.c                              |   7 +
 arch/x86/xen/mmu.c                                 |   1 +
 drivers/dma/omap-dma.c                             |  20 +-
 drivers/gpio/gpiolib-of.c                          |   5 +-
 drivers/gpu/drm/udl/udl_connector.c                |   4 +
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  | 369 ++++++++-------------
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   |  64 ++--
 drivers/scsi/libsas/sas_expander.c                 |  12 +
 drivers/target/target_core_alua.c                  |   3 +
 drivers/tty/tty_ldisc.c                            |  10 +-
 fs/cifs/connect.c                                  |  16 +-
 fs/gfs2/file.c                                     |   5 +-
 fs/gfs2/rgrp.c                                     |   2 +-
 fs/inode.c                                         |   2 +-
 include/asm-generic/tlb.h                          |   7 +-
 include/linux/ftrace.h                             |   3 +-
 ipc/msg.c                                          |   1 +
 kernel/sched/clock.c                               |  26 ++
 kernel/sys.c                                       |   3 +-
 kernel/trace/ftrace.c                              |  37 +--
 kernel/trace/trace_stack.c                         |   2 +-
 lib/kobject.c                                      |   9 +-
 mm/memory.c                                        |   1 +
 sound/soc/codecs/wm5102.c                          |   2 +-
 sound/soc/codecs/wm8903.c                          |   2 +
 sound/soc/soc-core.c                               |   2 +-
 sound/usb/mixer_quirks.c                           |   4 +-
 sound/usb/quirks.c                                 |   2 +-
 37 files changed, 336 insertions(+), 345 deletions(-)


