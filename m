Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaIFAGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 20:06:39 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51730 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaIFAGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 20:06:37 -0400
From: behanw@converseincode.com
To: a.ryabinin@samsung.com, anurag19aggarwal@gmail.com, charlebm@gmail.com,
        cl@linux-foundation.org, dave.long@linaro.org,
        k.khlebnikov@samsung.com, linux@arm.linux.org.uk,
        linyongting@gmail.com, Nikolay.Borisov@arm.com, tglx@linutronix.de,
        tj@kernel.org, u.kleine-koenig@pengutronix.de
Cc: behanw@converseincode.com, Dave.Martin@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rabin@rab.in, rostedt@goodmis.org, rric@kernel.org,
        will.deacon@arm.com
Subject: [PATCH v2 0/7] LLVMLinux: Patches to enable the kernel to be compiled with clang/LLVM
Date: Fri,  5 Sep 2014 17:06:10 -0700
Message-Id: <1409961977-11762-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

The LLVMLinux project aims to fully build the Linux kernel using both gcc and
clang (the C front end for the LLVM compiler infrastructure project). 

Clang only supports global named registers for non-allocatable registers like
the stack pointer. By centralizing the definition of current_stack_pointer, the
use of named registers for ARM remains largely unchanged while working for both
gcc and clang.


Behan Webster (6):
  arm: LLVMLinux: Add global named register current_stack_pointer for
    ARM
  arm: LLVMLinux: Use current_stack_pointer to calculate pt_regs address
  arm: LLVMLinux: Use current_stack_pointer for return_address
  arm: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
  arm: LLVMLinux: Calculate current_thread_info from
    current_stack_pointer
  arm: LLVMLinux: Use current_stack_pointer in unwind_backtrace

Mark Charlebois (1):
  arm: LLVMLinux: Use global stack register variable for percpu

 arch/arm/include/asm/percpu.h      | 4 ++--
 arch/arm/include/asm/ptrace.h      | 5 ++---
 arch/arm/include/asm/thread_info.h | 9 +++++++--
 arch/arm/kernel/return_address.c   | 3 +--
 arch/arm/kernel/stacktrace.c       | 4 +---
 arch/arm/kernel/unwind.c           | 3 +--
 6 files changed, 14 insertions(+), 14 deletions(-)

-- 
1.9.1

