Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaHESZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:25:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbaHESOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/39] 3.14.16-stable review
Date: Tue,  5 Aug 2014 11:13:37 -0700
Message-Id: <20140805181336.030349158@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.16 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Aug  7 18:13:27 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.16-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.16-rc1

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/espfix/xen: Fix allocation of pages for paravirt page tables

Minfei Huang <huangminfei@ucloud.cn>
    lib/btree.c: fix leak of whole btree nodes

Sasha Levin <sasha.levin@oracle.com>
    net/l2tp: don't fall back on UDP [get|set]sockopt

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: add fixup for double exception raised in window overflow

David Vrabel <david.vrabel@citrix.com>
    x86/xen: no need to explicitly register an NMI callback

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: move policy kobj to policy->cpu at resume

Johannes Berg <johannes.berg@intel.com>
    Revert "mac80211: move "bufferable MMPDU" check to fix AP mode scan"

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6655: Fix Warning on boot handle_irq_event_percpu.

Roger Quadros <rogerq@ti.com>
    ARM: dts: dra7-evm: Make VDDA_1V8_PHY supply always on

Nishanth Menon <nm@ti.com>
    pinctrl: dra: dt-bindings: Fix pull enable/disable

Andy Lutomirski <luto@amacapital.net>
    x86_64/entry/xen: Do not invoke espfix64 on Xen

H. Peter Anvin <hpa@zytor.com>
    x86, espfix: Make it possible to disable 16-bit support

H. Peter Anvin <hpa@zytor.com>
    x86, espfix: Make espfix64 a Kconfig option, fix UML

H. Peter Anvin <hpa@linux.intel.com>
    x86, espfix: Fix broken header guard

H. Peter Anvin <hpa@linux.intel.com>
    x86, espfix: Move espfix definitions into a separate header file

H. Peter Anvin <hpa@linux.intel.com>
    x86-64, espfix: Don't leak bits 31:16 of %esp returning to 16-bit stack

H. Peter Anvin <hpa@zytor.com>
    Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtime option"

Jan Kara <jack@suse.cz>
    timer: Fix lock inversion between hrtimer_bases.lock and scheduler locks

Stephen Boyd <sboyd@codeaurora.org>
    sched_clock: Avoid corrupting hrtimer tree during suspend

John Stultz <john.stultz@linaro.org>
    printk: rename printk_sched to printk_deferred

Anssi Hannula <anssi.hannula@iki.fi>
    dm cache: fix race affecting dirty block count

Greg Thelen <gthelen@google.com>
    dm bufio: fully initialize shrinker

Lars-Peter Clausen <lars@metafoo.de>
    iio: buffer: Fix demux table creation

Peter Meerwald <pmeerw@pmeerw.net>
    iio:bma180: Missing check for frequency fractional part

Peter Meerwald <pmeerw@pmeerw.net>
    iio:bma180: Fix scale factors to report correct acceleration units

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / PNP: Fix acpi_pnp_match()

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6655: Fix disassociated messages every 10 seconds

Michal Hocko <mhocko@suse.cz>
    memcg: oom_notify use-after-free fix

David Rientjes <rientjes@google.com>
    mm, thp: do not allow thp faults to avoid cpuset restrictions

Maxim Patlasov <MPatlasov@parallels.com>
    mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()

James Bottomley <JBottomley@Parallels.com>
    scsi: handle flush errors properly

Alexandre Bounine <alexandre.bounine@idt.com>
    rapidio/tsi721_dma: fix failure to obtain transaction descriptor

Eliad Peller <eliad@wizery.com>
    cfg80211: fix mic_failure tracing

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix aggregation session lockup

Konstantin Khlebnikov <k.khlebnikov@samsung.com>
    ARM: 8115/1: LPAE: reduce damage caused by idmap to virtual memory layout

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: fix alignment of keystone page table fixup

Haojian Zhuang <haojian.zhuang@linaro.org>
    ARM: dts: fix L2 address in Hi3620

Milan Broz <gmazyland@gmail.com>
    crypto: af_alg - properly label AF_ALG socket

Mikulas Patocka <mpatocka@redhat.com>
    crypto: arm-aes - fix encryption of unaligned data


-------------

Diffstat:

 Documentation/x86/x86_64/mm.txt         |   2 +
 Makefile                                |   4 +-
 arch/arm/boot/dts/dra7-evm.dts          |   1 +
 arch/arm/boot/dts/hi3620.dtsi           |   2 +-
 arch/arm/crypto/aesbs-glue.c            |  10 +-
 arch/arm/mm/idmap.c                     |   7 ++
 arch/arm/mm/mmu.c                       |   6 +-
 arch/x86/Kconfig                        |  25 +++-
 arch/x86/include/asm/espfix.h           |  16 +++
 arch/x86/include/asm/irqflags.h         |   2 +-
 arch/x86/include/asm/pgtable_64_types.h |   2 +
 arch/x86/include/asm/setup.h            |   2 +
 arch/x86/kernel/Makefile                |   1 +
 arch/x86/kernel/entry_32.S              |  12 ++
 arch/x86/kernel/entry_64.S              |  77 +++++++++++-
 arch/x86/kernel/espfix_64.c             | 208 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/ldt.c                   |  10 +-
 arch/x86/kernel/paravirt_patch_64.c     |   2 -
 arch/x86/kernel/smpboot.c               |   7 ++
 arch/x86/mm/dump_pagetables.c           |  31 +++--
 arch/x86/vdso/vdso32-setup.c            |   8 --
 arch/x86/xen/setup.c                    |   9 +-
 arch/xtensa/kernel/vectors.S            | 158 ++++++++++++++++++++----
 arch/xtensa/kernel/vmlinux.lds.S        |   4 +-
 crypto/af_alg.c                         |   2 +
 drivers/cpufreq/cpufreq.c               |   6 +-
 drivers/iio/accel/bma180.c              |   8 +-
 drivers/iio/industrialio-buffer.c       |   2 +-
 drivers/md/dm-bufio.c                   |   2 +-
 drivers/md/dm-cache-target.c            |  13 +-
 drivers/net/wireless/ath/ath9k/xmit.c   |   9 ++
 drivers/pnp/pnpacpi/core.c              |   3 +-
 drivers/rapidio/devices/tsi721_dma.c    |   8 +-
 drivers/scsi/scsi_lib.c                 |   8 ++
 drivers/staging/vt6655/bssdb.c          |   2 +-
 drivers/staging/vt6655/device_main.c    |   7 +-
 include/dt-bindings/pinctrl/dra.h       |   7 +-
 include/linux/printk.h                  |   6 +-
 init/main.c                             |   4 +
 kernel/printk/printk.c                  |   2 +-
 kernel/sched/core.c                     |   2 +-
 kernel/sched/deadline.c                 |   2 +-
 kernel/sched/rt.c                       |   2 +-
 kernel/time/clockevents.c               |  10 +-
 kernel/time/sched_clock.c               |   4 +-
 lib/btree.c                             |   1 +
 mm/memcontrol.c                         |   4 +
 mm/page-writeback.c                     |   6 +-
 mm/page_alloc.c                         |  16 +--
 net/l2tp/l2tp_ppp.c                     |   4 +-
 net/mac80211/tx.c                       |  27 ++---
 net/wireless/trace.h                    |   3 +-
 52 files changed, 629 insertions(+), 147 deletions(-)


