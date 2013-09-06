Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234Ab3IFVnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 17:43:21 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:39155 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3IFVnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:43:20 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: behanw@converseincode.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Jones <davej@redhat.com>
Subject: [PATCH] arm: LLVMLinux: Use __builtin_frame_address instead of named registers
Date: Fri,  6 Sep 2013 17:42:40 -0400
Message-Id: <1378503762-7236-1-git-send-email-behanw@converseincode.com>
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

Use the frame pointer to calculate the end of the stack for current_pt_regs()
The existing code uses the stack pointer to do this calculation.
Using the frame pointer yeilds the same value in a more portable way.
This change supports being able to compile the kernel with gcc and clang.

Behan Webster (1):
  arm: LLVMLinux: Calculate pt_regs address from fp

 arch/arm/include/asm/ptrace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
1.8.1.2

