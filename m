Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3DOCZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:25:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab3DOCZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:25:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/17] 3.4.41-stable review
Date: Sun, 14 Apr 2013 19:25:10 -0700
Message-Id: <20130415022352.616689034@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.41 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Apr 17 02:23:06 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.41-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.41-rc1

Hayes Wang <hayeswang@realtek.com>
    r8169: fix auto speed down issue

Linus Torvalds <torvalds@linux-foundation.org>
    kobject: fix kset_find_obj() race with concurrent last kobject_put()

Linus Torvalds <torvalds@linux-foundation.org>
    mtdchar: fix offset overflow detection

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare metal

Samu Kallio <samu.kallio@aberdeencloud.com>
    x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

Thomas Gleixner <tglx@linutronix.de>
    sched_clock: Prevent 64bit inatomicity on 32bit systems

Dave Airlie <airlied@gmail.com>
    udl: handle EDID failure properly.

Thomas Hellstrom <thellstrom@vmware.com>
    kref: Implement kref_get_unless_zero v3

Suleiman Souhlal <suleiman@google.com>
    vfs: Revert spurious fix to spinning prevention in prune_icache_sb

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition CDBs

Sachin Prabhu <sprabhu@redhat.com>
    cifs: Allow passwords which begin with a delimitor

Lukasz Dorau <lukasz.dorau@intel.com>
    SCSI: libsas: fix handling vacant phy in sas_set_ex_phy()

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Use the correct size of the GTT for placing the per-process entries

Huacai Chen <chenhc@lemote.com>
    PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()

Namhyung Kim <namhyung.kim@lge.com>
    tracing: Fix double free when function profile init failed

Alban Bedel <alban.bedel@avionic-design.de>
    ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is running

Eldad Zack <eldad@fogrefinery.com>
    ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*


-------------

Diffstat:

 Makefile                              |  4 +--
 arch/x86/include/asm/paravirt.h       |  5 +++-
 arch/x86/include/asm/paravirt_types.h |  2 ++
 arch/x86/kernel/paravirt.c            | 25 +++++++++---------
 arch/x86/lguest/boot.c                |  1 +
 arch/x86/mm/fault.c                   |  6 +++--
 arch/x86/xen/mmu.c                    |  1 +
 drivers/gpu/drm/i915/i915_gem_gtt.c   |  2 +-
 drivers/gpu/drm/udl/udl_connector.c   |  4 +++
 drivers/mtd/mtdchar.c                 | 48 ++++++++++++++++++++++++++++++-----
 drivers/net/ethernet/realtek/r8169.c  | 28 +++++++++++++++++---
 drivers/scsi/libsas/sas_expander.c    | 12 +++++++++
 drivers/target/target_core_alua.c     |  3 +++
 fs/cifs/connect.c                     | 16 +++++++++---
 fs/inode.c                            |  2 +-
 include/linux/kref.h                  | 21 +++++++++++++++
 kernel/sched/clock.c                  | 26 +++++++++++++++++++
 kernel/sys.c                          |  3 ++-
 kernel/trace/ftrace.c                 |  1 -
 lib/kobject.c                         |  9 ++++++-
 sound/soc/codecs/wm8903.c             |  2 ++
 sound/usb/mixer_quirks.c              |  4 +--
 sound/usb/quirks.c                    |  2 +-
 23 files changed, 190 insertions(+), 37 deletions(-)


