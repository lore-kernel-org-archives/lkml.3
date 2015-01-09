Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbbAIP5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:57:37 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58928 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709AbbAIP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:57:36 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/5] arm64 compat syscall table clean-up
Date: Fri,  9 Jan 2015 15:57:23 +0000
Message-Id: <1420819048-3515-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series moves the arm64 compat_sys_call_table from .S to a .c file
for consistency with the native syscalls and also for detecting when the
real number of compat system calls and the __NR_compat_syscalls
definition are out of sync.

The first two patches, however, touch some generic header file, hence
Andrew and Arnd on cc.

Catalin Marinas (4):
  compat: Declare compat_sys_sigpending and compat_sys_sigprocmask
    prototypes
  syscalls: Declare sys_*stat64 prototypes if
    __ARCH_WANT_(COMPAT_)STAT64
  arm64: Implement the compat_sys_call_table in C
  arm64: Remove asm/syscalls.h

Mark Rutland (1):
  arm64: make sys_call_table const

 arch/arm64/include/asm/syscalls.h        | 30 -------------------
 arch/arm64/include/asm/unistd.h          |  3 ++
 arch/arm64/kernel/Makefile               |  2 +-
 arch/arm64/kernel/entry.S                |  2 +-
 arch/arm64/kernel/{sys32.S => entry32.S} | 34 ++++++++-------------
 arch/arm64/kernel/sys.c                  |  5 ++--
 arch/arm64/kernel/sys32.c                | 51 ++++++++++++++++++++++++++++++++
 include/linux/compat.h                   |  9 ++++++
 include/linux/syscalls.h                 |  8 +++--
 9 files changed, 84 insertions(+), 60 deletions(-)
 delete mode 100644 arch/arm64/include/asm/syscalls.h
 rename arch/arm64/kernel/{sys32.S => entry32.S} (80%)
 create mode 100644 arch/arm64/kernel/sys32.c

