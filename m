Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaGVJPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:15:40 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47633 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaGVJPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:15:39 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: wad@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com,
        keescook@chromium.org
Cc: dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v5 0/3] arm64: Add seccomp support
Date: Tue, 22 Jul 2014 18:14:56 +0900
Message-Id: <1406020499-5537-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please apply this patch after my audit patch in order to avoid some
conflict on arm64/Kconfig.)

This patch enables secure computing (system call filtering) on arm64.
System calls can be allowed or denied by loaded bpf-style rules.
Architecture specific part is to run secure_computing() on syscall entry
and check the result. See [3/3]

Prerequisites are:
 * "arm64: Add audit support" patch

This code is tested on ARMv8 fast model using
 * libseccomp v2.1.1 with modifications for arm64 and verified by its "live"
   tests, 20, 21 and 24.
 * modified version of Kees' seccomp test for 'changing/skipping a syscall'
   behavior

Changes v4 -> v5:
* rebased to v3.16-rc
* add patch [1/3] to allow ptrace to change a system call
  (please note that this patch should be applied even without seccomp.)

Changes v3 -> v4:
* removed the following patch and moved it to "arm64: prerequisites for
  audit and ftrace" patchset since it is required for audit and ftrace in
  case of !COMPAT, too.
  "arm64: is_compat_task is defined both in asm/compat.h and linux/compat.h"

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
  arm64: ptrace: reload a syscall number after ptrace operations
  asm-generic: Add generic seccomp.h for secure computing mode 1
  arm64: Add seccomp support

 arch/arm64/Kconfig               |   14 ++++++++++++++
 arch/arm64/include/asm/seccomp.h |   25 +++++++++++++++++++++++++
 arch/arm64/include/asm/unistd.h  |    3 +++
 arch/arm64/kernel/entry.S        |    2 ++
 arch/arm64/kernel/ptrace.c       |   18 ++++++++++++++++++
 include/asm-generic/seccomp.h    |   28 ++++++++++++++++++++++++++++
 6 files changed, 90 insertions(+)
 create mode 100644 arch/arm64/include/asm/seccomp.h
 create mode 100644 include/asm-generic/seccomp.h

-- 
1.7.9.5

