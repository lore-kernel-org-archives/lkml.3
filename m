Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbaGOXM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:12:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaGOXMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:12:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/22] 3.4.99-stable review
Date: Tue, 15 Jul 2014 16:17:05 -0700
Message-Id: <20140715231622.121816073@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.99 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jul 17 23:16:04 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.99-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.99-rc1

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

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Plug slow unlock race

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Handle deadlock detection smarter

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Detect changes in the pi lock chain

Thomas Gleixner <tglx@linutronix.de>
    rtmutex: Fix deadlock detector for real

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Remove ftrace_stop/start() from reading the trace file

Christian König <christian.koenig@amd.com>
    drm/radeon: stop poisoning the GART TLB

Theodore Ts'o <tytso@mit.edu>
    ext4: clarify error count warning messages

Anton Blanchard <anton@samba.org>
    powerpc/perf: Never program book3s PMCs with values >= 0x80000000

Axel Lin <axel.lin@ingics.com>
    hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div

Axel Lin <axel.lin@ingics.com>
    hwmon: (amc6821) Fix permissions for temp2_input

Gu Zheng <guz.fnst@cn.fujitsu.com>
    cpuset,mempolicy: fix sleeping function called from invalid context

Bert Vermeulen <bert@biot.com>
    USB: ftdi_sio: Add extra PID.

Andras Kovacs <andras@sth.sze.hu>
    USB: cp210x: add support for Corsair usb dongle

Bernd Wachter <bernd.wachter@jolla.com>
    usb: option: Add ID for Telewell TW-LTE 4G v2


-------------

Diffstat:

 Documentation/x86/x86_64/mm.txt         |   2 +
 Makefile                                |   4 +-
 arch/powerpc/perf/core-book3s.c         |  17 ++-
 arch/x86/Kconfig                        |  25 +++-
 arch/x86/include/asm/espfix.h           |  16 ++
 arch/x86/include/asm/pgtable_64_types.h |   2 +
 arch/x86/include/asm/setup.h            |   2 +
 arch/x86/kernel/Makefile                |   1 +
 arch/x86/kernel/entry_32.S              |  12 ++
 arch/x86/kernel/entry_64.S              |  81 +++++++++-
 arch/x86/kernel/espfix_64.c             | 209 ++++++++++++++++++++++++++
 arch/x86/kernel/ldt.c                   |  10 +-
 arch/x86/kernel/smpboot.c               |   7 +
 arch/x86/mm/dump_pagetables.c           |  31 ++--
 arch/x86/mm/ioremap.c                   |  26 +++-
 arch/x86/vdso/vdso32-setup.c            |   8 -
 drivers/acpi/battery.c                  |  27 +++-
 drivers/gpu/drm/radeon/rs600.c          |   6 +-
 drivers/hwmon/adm1029.c                 |   3 +
 drivers/hwmon/amc6821.c                 |   2 +-
 drivers/usb/serial/cp210x.c             |   1 +
 drivers/usb/serial/ftdi_sio.c           |   3 +-
 drivers/usb/serial/ftdi_sio_ids.h       |   3 +-
 drivers/usb/serial/option.c             |   2 +
 fs/ext4/super.c                         |   7 +-
 init/main.c                             |   4 +
 kernel/cpuset.c                         |   8 +-
 kernel/rtmutex-debug.h                  |   5 +
 kernel/rtmutex.c                        | 252 ++++++++++++++++++++++++++++----
 kernel/rtmutex.h                        |   5 +
 kernel/trace/trace.c                    |   2 -
 mm/mempolicy.c                          |   2 -
 32 files changed, 696 insertions(+), 89 deletions(-)


