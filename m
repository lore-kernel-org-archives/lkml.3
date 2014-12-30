Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaL3Awe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 19:52:34 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:35350 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaL3Awd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 19:52:33 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.19 0/3] Possible MPX improvements for 3.19
Date: Mon, 29 Dec 2014 16:52:24 -0800
Message-Id: <cover.1419900414.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have the hardware, so this is only compile-tested.

Patches 1 and 2 should be safe.  Patch 1 is a bugfix, although given the
bitness sensitivity of the MPX data structures, any user code that hits
the bug is probably doomed to failure anyway.  Patch 2 is a hardening
change that adds almost no complexity (it's mostly just reordering some
code) that will make it considerably harder to exploit a possibly insn
decoder vulnerability using threads that modify MPX instructions that
send #BR before the trap handler runs.

Patch 3 will be much more controversial, since it's a complete ABI
break.  The ABI in question has never appeared in a released kernel,
though.  If patch 3 is not okay, then I want to fix the prctl
implementation to at least validate its arguments.

Andy Lutomirski (3):
  x86, mpx: Check user mode bitness correctly when decoding instructions
  x86, mpx: Short-circuit the instruction decoder for unexpected opcodes
  x86, mpx: Change the MPX enable/disable API to arch_prctl

 arch/x86/include/asm/ptrace.h     |  5 +++++
 arch/x86/include/uapi/asm/prctl.h | 15 +++++++++++----
 arch/x86/kernel/process_64.c      | 10 ++++++++++
 arch/x86/mm/mpx.c                 | 28 ++++++++++++++++++----------
 include/uapi/linux/prctl.h        |  6 ------
 kernel/sys.c                      | 12 ------------
 6 files changed, 44 insertions(+), 32 deletions(-)

-- 
2.1.0

