Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaLATXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:23:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:45513 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750988AbaLATXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:23:08 -0500
Message-Id: <20141201192225.548178029@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 01 Dec 2014 14:22:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/9] ftrace/x86: Updated mcount cleanup for 3.19
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 6a06bdbf7f9c669743f58084991ba280f2925586


Steven Rostedt (Red Hat) (9):
      ftrace/x86: Have static tracing also use ftrace_caller_setup
      ftrace/x86: Move MCOUNT_SAVE_FRAME out of header file
      ftrace/x86: Rename MCOUNT_SAVE_FRAME and add more detailed comments
      ftrace/x86: Have save_mcount_regs store RIP in %rdi for first parameter
      ftrace/x86: Simplify save_mcount_regs on getting RIP
      ftrace/x86: Add macro MCOUNT_REG_SIZE for amount of stack used to save mcount regs
      ftrace/x86: Have save_mcount_regs macro also save stack frames if needed
      ftrace/x86: Get rid of ftrace_caller_setup
      ftrace/fgraph/x86: Have prepare_ftrace_return() take ip as first parameter

----
 arch/x86/include/asm/ftrace.h |  33 ------
 arch/x86/kernel/ftrace.c      |   4 +-
 arch/x86/kernel/mcount_64.S   | 233 ++++++++++++++++++++++++++----------------
 3 files changed, 149 insertions(+), 121 deletions(-)
