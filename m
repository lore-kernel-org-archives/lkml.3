Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaG3X5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:57:42 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:62879 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaG3X5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:57:41 -0400
From: behanw@converseincode.com
To: ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        k.khlebnikov@samsung.com, olof@lixom.net, peterz@infradead.org,
        takahiro.akashi@linaro.org, tglx@linutronix.de, will.deacon@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dwmw2@infradead.org,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH 0/4] LLVMLinux: Patches to enable the kernel to be compiled with clang/LLVM
Date: Wed, 30 Jul 2014 16:57:25 -0700
Message-Id: <1406764649-20326-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

This patch set moves from using locally defined named registers to access the
stack pointer to using a globally defined named register. This allows the code
to work both with gcc and clang.

The LLVMLinux project aims to fully build the Linux kernel using both gcc and
clang (the C front end for the LLVM compiler infrastructure project). 

Behan Webster (4):
  arm64: LLVMLinux: Add current_stack_pointer() for arm64
  arm64: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
  arm64: LLVMLinux: Calculate current_thread_info from
    current_stack_pointer
  arm64: LLVMLinux: Use current_stack_pointer in kernel/traps.c

 arch/arm64/include/asm/thread_info.h | 9 +++++++--
 arch/arm64/kernel/stacktrace.c       | 3 +--
 arch/arm64/kernel/traps.c            | 3 +--
 3 files changed, 9 insertions(+), 6 deletions(-)

-- 
1.9.1

