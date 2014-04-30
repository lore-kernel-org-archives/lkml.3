Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbaD3Jwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:52:39 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:56285 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaD3Jwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:52:37 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: will.deacon@arm.com
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v6 0/4] arm64: prerequisites for audit and ftrace
Date: Wed, 30 Apr 2014 18:51:28 +0900
Message-Id: <1398851492-16345-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394861948-28712-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394861948-28712-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This patchset was already acked by the maintainer along with a minor typo
fix. See below.)

This patchset contains some patches commonly applied for audit and ftrace.

Patch [1/4] defines syscall trace related TIF_* flags in order to add hooks,
including ftrace, audit and seccomp, later on.  Those features will be
implemented in separate patchsets, but it's safe to check for all TIF_*
now because they can not be turned on anyway.

Patch [2/4] doesn't change a behavior but make it easy and manageable to
confirm we invoke those hooks in correct order by splitting syscall_trace().

Patch [3/4] adds a commonly used function, which returns a return value of
system call.

Patch [4/4] removes is_compat_task from asm/compat.h to avoid conflicted
definitions.

Changes v5 -> v6:
* renamed a temporary variable's name to more meaningful one [2/4]

Changes v4 -> v5:
* added the following patch from my seccomp patch since it is required for
  audit and ftrace in case of !COMPAT, too. [4/4]
  "arm64: is_compat_task is defined both in asm/compat.h and linux/compat.h"

Changes v3 -> v4:
* added "arm64: split syscall_trace() into separate functions for enter/
  exit", which is just a preparation for adding syscall trace hooks later.

Changes v2 -> v3:
* reverted a change in syscall_trace() in v1 [1/2]
* added "arm64: Add regs_return_value() in syscall.h" patch which was
  previously included in audit patch [2/2]

Changes v1 -> v2:
* added a guard against TIF_SYSCALL_TRACE at tracehook_report_syscall_*()
* renamed _TIF_WORK_SYSCALL to _TIF_SYSCALL_WORK

AKASHI Takahiro (4):
  arm64: make a single hook to syscall_trace() for all syscall features
  arm64: split syscall_trace() into separate functions for enter/exit
  arm64: Add regs_return_value() in syscall.h
  arm64: is_compat_task is defined both in asm/compat.h and
    linux/compat.h

 arch/arm64/include/asm/compat.h      |    5 ----
 arch/arm64/include/asm/ptrace.h      |    5 ++++
 arch/arm64/include/asm/thread_info.h |   13 +++++++++
 arch/arm64/kernel/entry.S            |   15 +++++-----
 arch/arm64/kernel/hw_breakpoint.c    |    2 +-
 arch/arm64/kernel/process.c          |    1 +
 arch/arm64/kernel/ptrace.c           |   51 ++++++++++++++++++++--------------
 arch/arm64/kernel/signal.c           |    2 +-
 8 files changed, 58 insertions(+), 36 deletions(-)

-- 
1.7.9.5

