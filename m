Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbaH0E3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:29:42 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50332 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaH0E3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:29:41 -0400
From: behanw@converseincode.com
To: ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        cl@linux-foundation.org, jays.lee@samsung.com,
        k.khlebnikov@samsung.com, larry.bassel@linaro.org, olof@lixom.net,
        peterz@infradead.org, takahiro.akashi@linaro.org, tglx@linutronix.de,
        tj@kernel.org, will.deacon@arm.com
Cc: christoffer.dall@linaro.org, kgene.kim@samsung.com, khilman@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sungjinn.chung@samsung.com, Behan Webster <behanw@converseincode.com>
Subject: [PATCH V2 0/6] LLVMLinux: Patches to enable the kernel to be compiled with clang/LLVM
Date: Tue, 26 Aug 2014 21:29:28 -0700
Message-Id: <1409113774-3172-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140826141608.GT23445@arm.com>
References: <20140826141608.GT23445@arm.com>
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


Behan Webster (5):
  arm64: LLVMLinux: Add current_stack_pointer() for arm64
  arm64: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
  arm64: LLVMLinux: Calculate current_thread_info from
    current_stack_pointer
  arm64: LLVMLinux: Use current_stack_pointer in kernel/traps.c
  arm64: LLVMLinux: Use global stack pointer in return_address()

Mark Charlebois (1):
  arm64: LLVMLinux: Use global stack register variable for aarch64

 arch/arm64/include/asm/percpu.h      | 4 ++--
 arch/arm64/include/asm/thread_info.h | 9 +++++++--
 arch/arm64/kernel/return_address.c   | 3 +--
 arch/arm64/kernel/stacktrace.c       | 3 +--
 arch/arm64/kernel/traps.c            | 3 +--
 5 files changed, 12 insertions(+), 10 deletions(-)

-- 
1.9.1

