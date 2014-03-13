Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaCMKRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:17:22 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45917 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaCMKRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:17:19 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: wad@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com,
        arndb@arndb.de
Cc: dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v3 0/3] arm64: Add seccomp support
Date: Thu, 13 Mar 2014 19:17:00 +0900
Message-Id: <1394705823-12465-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393320025-2855-1-git-send-email-takahiro.akashi@linaro.org>
References: <1393320025-2855-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please apply this patch after my ftrace patch and audit patch in order
to avoid some conflict on arm64/Kconfig.)

This patch enables secure computing (system call filtering) on arm64.
System calls can be allowed or denied by loaded bpf-style rules.
Architecture specific part is to run secure_computing() on syscall entry
and check the result. See [2/3]

Prerequisites are:
 * "arm64: make a single hook to syscall_trace() for all syscall features" patch
 * "arm64: split syscall_trace() into separate functions for enter/exit" patch
 * "arm64: Add audit support" patch

This code is tested on ARMv8 fast model using libseccomp v2.1.1 with
modifications for arm64 and verified by its "live" tests, 20, 21 and 24.

Changes v2 -> v3:
* removed unnecessary 'type cast' operations [2/3]
* check for a return value (-1) of secure_computing() explicitly [2/3]
* aligned with the patch, "arm64: split syscall_trace() into separate
  functions for enter/exit" [2/3]
* changed default of CONFIG_SECCOMP to n [2/3]

Changes v1 -> v2:
* added generic seccomp.h for arm64 to utilize it [1,2/3] 
* changed syscall_trace() to return more meaningful value (-EPERM)
  on seccomp failure case [2/3]
* aligned with the change in "arm64: make a single hook to syscall_trace()
  for all syscall features" v2 [2/3]
* removed is_compat_task() definition from compat.h [3/3]

AKASHI Takahiro (3):
  asm-generic: Add generic seccomp.h for secure computing mode 1
  arm64: Add seccomp support
  arm64: is_compat_task is defined both in asm/compat.h and
    linux/compat.h

 arch/arm64/Kconfig                |   14 ++++++++++++++
 arch/arm64/include/asm/compat.h   |    5 -----
 arch/arm64/include/asm/seccomp.h  |   25 +++++++++++++++++++++++++
 arch/arm64/include/asm/unistd.h   |    3 +++
 arch/arm64/kernel/entry.S         |    4 ++++
 arch/arm64/kernel/hw_breakpoint.c |    2 +-
 arch/arm64/kernel/process.c       |    2 +-
 arch/arm64/kernel/ptrace.c        |    8 +++++++-
 arch/arm64/kernel/signal.c        |    2 +-
 include/asm-generic/seccomp.h     |   28 ++++++++++++++++++++++++++++
 10 files changed, 84 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm64/include/asm/seccomp.h
 create mode 100644 include/asm-generic/seccomp.h

-- 
1.7.9.5

