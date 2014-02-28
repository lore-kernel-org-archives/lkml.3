Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993AbaB1FQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 00:16:00 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64276 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaB1FP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 00:15:59 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: will.deacon@arm.com
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v3 0/2] arm64: prerequisites for audit and ftrace
Date: Fri, 28 Feb 2014 14:14:23 +0900
Message-Id: <1393564465-3862-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393319683-2707-1-git-send-email-takahiro.akashi@linaro.org>
References: <1393319683-2707-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains some patches commonly used by audit and ftrace.

Patch [1/2] defines system call related TIF_* flags to add syscall_trace()
hooks, including ftrace, audit and seccomp, later.
Those features will be implemented in separate patchsets, but it's safe to
check for all TIF_* now because they can not be turned on anyway.

Patch [2/2] adds a function which returns a return value of system call.

Changes v1 -> v2:
* added a guard against TIF_SYSCALL_TRACE at tracehook_report_syscall_*()
* renamed _TIF_WORK_SYSCALL to _TIF_SYSCALL_WORK

Changes v2 -> v3:
* reverted a change in syscall_trace() in v1 [1/2]
* added "arm64: Add regs_return_value() in syscall.h" patch which was
  previously included in audit patch [2/2]

AKASHI Takahiro (2):
  arm64: make a single hook to syscall_trace() for all syscall features
  arm64: Add regs_return_value() in syscall.h

 arch/arm64/include/asm/ptrace.h      |    5 +++++
 arch/arm64/include/asm/thread_info.h |   13 +++++++++++++
 arch/arm64/kernel/entry.S            |    5 +++--
 3 files changed, 21 insertions(+), 2 deletions(-)

-- 
1.7.9.5

