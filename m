Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab3IFVaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 17:30:13 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53802 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3IFVaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:30:11 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk
Cc: behanw@converseincode.com, Russell King <rmk+kernel@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Wade Farnsworth <wade_farnsworth@mentor.com>,
        Will Drewry <wad@chromium.org>, Sahara <keun-o.park@windriver.com>,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 0/5] arm: LLVMLinux: Add current_stack_pointer
Date: Fri,  6 Sep 2013 17:28:06 -0400
Message-Id: <1378502899-1241-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

The LLVMLinux Project is working to be able to build the Linux kernel with
clang/LLVM. With the release of LLVM 3.3 clang is now able to compile the Linux
kernel with a number of small patches (available from the LLVMLinux git repo).

These patches add a macro to get the current stack pointer which allows for a
single place in which to do so with ASM. Before this named registers (a gcc
extension) was used to get the stack pointer. Using ASM is a more portable way
of getting the stack pointer which works with both gcc and clang.  This macro
is of the same name used in the X86 arch.

Behan Webster (5):
  arm: LLVMLinux: Add current_stack_pointer macro for ARM
  arm: LLVMLinux: use current_stack_pointer for percpu
  arm: LLVMLinux: Use current_stack_pointer for return_address
  arm: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
  arm: LLVMLinux: Use current_stack_pointer in unwind_backtrace

 arch/arm/include/asm/percpu.h      | 4 ++--
 arch/arm/include/asm/thread_info.h | 9 +++++++++
 arch/arm/kernel/return_address.c   | 3 +--
 arch/arm/kernel/stacktrace.c       | 4 +---
 arch/arm/kernel/unwind.c           | 3 +--
 5 files changed, 14 insertions(+), 9 deletions(-)

-- 
1.8.1.2

