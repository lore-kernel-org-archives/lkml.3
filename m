Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477Ab3HNViD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:38:03 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:50708 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760461Ab3HNViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:38:00 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk
Cc: behanw@converseincode.com, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, charlebm@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix extern inline in ftrace.h for ARM
Date: Wed, 14 Aug 2013 17:37:40 -0400
Message-Id: <1376516261-2071-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

The LLVMLinux Project is working to be able to build the Linux kernel with
clang/LLVM. With the release of LLVM 3.3 clang is now able to compile the Linux
kernel with a number of small patches (available from the LLVMLinux git repo).

This patch removes the use of "extern inline" from the ftrace code for ARM.
This same work has already been completed for ftrace on x86.  Amongst other
things this patch is required in order to have the Linux kernel to be able to
be compiled with both gcc and clang.

Mark Charlebois (1):
  ARM: LLVMLinux: Change "extern inline" to "gnu_inline" in ARM ftrace.h

 arch/arm/include/asm/ftrace.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.8.1.2

