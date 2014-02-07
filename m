Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaBGKMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:12:06 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59923 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaBGKMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:12:03 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: wad@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH 0/2] arm64: Add seccomp support
Date: Fri,  7 Feb 2014 19:11:30 +0900
Message-Id: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables secure computing (system call filtering) on arm64.
System calls can be allowed or denied by loaded bpf-style rules.
Architecture specific part is to run secure_computing() on syscall entry
and check the result. See [1/2]

Prerequisites are:
 * "arm64: Add audit support" patch
 * "arm64: make a single hook to syscall_trace() for all syscall features" patch

This code is tested on ARMv8 fast model using libseccomp v2.1.1 with
modifications for arm64 and verified by its "live" tests, 20, 21 and 24.

AKASHI Takahiro (2):
  arm64: Add seccomp support
  arm64: is_compat_task is defined both in asm/compat.h and
    linux/compat.h

 arch/arm64/Kconfig               |   17 +++++++++++++++++
 arch/arm64/include/asm/compat.h  |    2 ++
 arch/arm64/include/asm/seccomp.h |   28 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/unistd.h  |    3 +++
 arch/arm64/kernel/entry.S        |    4 ++++
 arch/arm64/kernel/ptrace.c       |    5 +++++
 6 files changed, 59 insertions(+)
 create mode 100644 arch/arm64/include/asm/seccomp.h

-- 
1.7.9.5

