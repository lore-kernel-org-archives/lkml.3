Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029AbaGPAHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:07:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896AbaGOXNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/44] 3.10.49-stable review
Date: Tue, 15 Jul 2014 16:16:58 -0700
Message-Id: <20140715231646.690728348@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.49 release.
There are 44 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jul 17 23:16:37 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.49-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.49-rc1

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / battery: Retry to get battery information if failed during probing

Roland Dreier <roland@purestorage.com>
    x86, ioremap: Speed up check for RAM pages

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

Lennox Wu <lennox.wu@gmail.com>
    Score: Modify the Makefile of Score, remove -mlong-calls for compiling

Lennox Wu <lennox.wu@gmail.com>
    Score: The commit is for compiling successfully.

Lennox Wu <lennox.wu@gmail.com>
    Score: Implement the function csum_ipv6_magic

Jiang Liu <liuj97@gmail.com>
    score: normalize global variables exported by vmlinux.lds

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Plug slow unlock race

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Handle deadlock detection smarter

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Detect changes in the pi lock chain

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Fix deadlock detector for real

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ring-buffer: Check if buffer exists before polling

Christian König <christian.koenig@amd.com>
    drm/radeon: stop poisoning the GART TLB

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in golden register setup on evergreen

Eric Sandeen <sandeen@redhat.com>
    ext4: disable synchronous transaction batching if max_batch_time==0

Theodore Ts'o <tytso@mit.edu>
    ext4: clarify error count warning messages

Theodore Ts'o <tytso@mit.edu>
    ext4: fix unjournalled bg descriptor while initializing inode bitmap

Joe Thornber <thornber@redhat.com>
    dm io: fix a race condition in the wake up code for sync_io

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code

Thomas Gleixner <tglx@linutronix.de>
    clk: spear3xx: Use proper control register offset

Colin Cross <ccross@android.com>
    arm64: implement TASK_SIZE_OF

Jussi Kivilinna <jussi.kivilinna@iki.fi>
    crypto: sha512_ssse3 - fix byte count to bit count conversion

Prabhakar Lad <prabhakar.csengg@gmail.com>
    cpufreq: Makefile: fix compilation for davinci platform

Joel Stanley <joel@jms.id.au>
    powerpc/perf: Clear MMCR2 when enabling PMU

Joel Stanley <joel@jms.id.au>
    powerpc/perf: Add PPMU_ARCH_207S define

Anton Blanchard <anton@samba.org>
    powerpc/perf: Never program book3s PMCs with values >= 0x80000000

Andy Whitcroft <apw@canonical.com>
    ACPI / resources: only reject zero length resources based at address zero

Axel Lin <axel.lin@ingics.com>
    hwmon: (adm1021) Fix cache problem when writing temperature limits

Axel Lin <axel.lin@ingics.com>
    hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div

Guenter Roeck <linux@roeck-us.net>
    hwmon: (adm1031) Fix writes to limit registers

Axel Lin <axel.lin@ingics.com>
    hwmon: (amc6821) Fix permissions for temp2_input

Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
    workqueue: zero cpumask of wq_numa_possible_cpumask on init

Gu Zheng <guz.fnst@cn.fujitsu.com>
    cpuset,mempolicy: fix sleeping function called from invalid context

Maxime Bizon <mbizon@freebox.fr>
    workqueue: fix dev_set_uevent_suppress() imbalance

Helge Deller <deller@gmx.de>
    parisc: add serial ports of C8000/1GHz machine to hardware database

Michal Sojka <sojkam1@fel.cvut.cz>
    USB: serial: ftdi_sio: Add Infineon Triboard

Bert Vermeulen <bert@biot.com>
    USB: ftdi_sio: Add extra PID.

Andras Kovacs <andras@sth.sze.hu>
    USB: cp210x: add support for Corsair usb dongle

Bernd Wachter <bernd.wachter@jolla.com>
    usb: option: Add ID for Telewell TW-LTE 4G v2


-------------

Diffstat:

 Documentation/x86/x86_64/mm.txt              |   2 +
 Makefile                                     |   4 +-
 arch/arm64/include/asm/memory.h              |   2 +
 arch/parisc/kernel/hardware.c                |   3 +-
 arch/powerpc/include/asm/perf_event_server.h |   2 +-
 arch/powerpc/perf/core-book3s.c              |  22 ++-
 arch/powerpc/perf/power8-pmu.c               |   2 +-
 arch/score/Kconfig                           |   3 +
 arch/score/Makefile                          |   4 +-
 arch/score/include/asm/checksum.h            |  93 +++++-----
 arch/score/include/asm/io.h                  |   1 -
 arch/score/include/asm/pgalloc.h             |   2 +-
 arch/score/kernel/entry.S                    |   4 +-
 arch/score/kernel/process.c                  |   4 +-
 arch/score/kernel/vmlinux.lds.S              |   1 +
 arch/x86/Kconfig                             |  25 ++-
 arch/x86/crypto/sha512_ssse3_glue.c          |   2 +-
 arch/x86/include/asm/espfix.h                |  16 ++
 arch/x86/include/asm/pgtable_64_types.h      |   2 +
 arch/x86/include/asm/setup.h                 |   2 +
 arch/x86/kernel/Makefile                     |   1 +
 arch/x86/kernel/entry_32.S                   |  12 ++
 arch/x86/kernel/entry_64.S                   |  81 ++++++++-
 arch/x86/kernel/espfix_64.c                  | 209 ++++++++++++++++++++++
 arch/x86/kernel/ldt.c                        |  10 +-
 arch/x86/kernel/smpboot.c                    |   7 +
 arch/x86/mm/dump_pagetables.c                |  31 ++--
 arch/x86/mm/ioremap.c                        |  26 ++-
 arch/x86/vdso/vdso32-setup.c                 |   8 -
 drivers/acpi/battery.c                       |  27 ++-
 drivers/acpi/resource.c                      |  10 +-
 drivers/clk/spear/spear3xx_clock.c           |   2 +-
 drivers/cpufreq/Makefile                     |   2 +-
 drivers/gpu/drm/radeon/evergreen.c           |   8 +-
 drivers/gpu/drm/radeon/rs600.c               |   6 +-
 drivers/hv/connection.c                      |   8 +-
 drivers/hwmon/adm1021.c                      |  14 +-
 drivers/hwmon/adm1029.c                      |   3 +
 drivers/hwmon/adm1031.c                      |   8 +-
 drivers/hwmon/amc6821.c                      |   2 +-
 drivers/md/dm-io.c                           |  22 +--
 drivers/usb/serial/cp210x.c                  |   1 +
 drivers/usb/serial/ftdi_sio.c                |   5 +-
 drivers/usb/serial/ftdi_sio_ids.h            |   9 +-
 drivers/usb/serial/option.c                  |   2 +
 fs/ext4/ialloc.c                             |  14 +-
 fs/ext4/super.c                              |   9 +-
 fs/jbd2/transaction.c                        |   5 +-
 include/linux/ring_buffer.h                  |   2 +-
 init/main.c                                  |   4 +
 kernel/cpuset.c                              |   8 +-
 kernel/rtmutex-debug.h                       |   5 +
 kernel/rtmutex.c                             | 252 ++++++++++++++++++++++++---
 kernel/rtmutex.h                             |   5 +
 kernel/trace/ring_buffer.c                   |   5 +-
 kernel/trace/trace.c                         |  25 ++-
 kernel/trace/trace.h                         |   4 +-
 kernel/workqueue.c                           |   3 +-
 mm/mempolicy.c                               |   2 -
 59 files changed, 853 insertions(+), 200 deletions(-)


