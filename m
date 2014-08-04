Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaHDNUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:20:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbaHDNUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:20:42 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/6 v2] x86: entry_64.S: always allocate complete "struct pt_regs"
Date: Mon,  4 Aug 2014 15:19:40 +0200
Message-Id: <1407158386-6201-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2 of the patchset.

Changes since v1 (mainly in patch 4/6):
= Reverted changes to "partial pt_regs saving" on interrupt path.
= Folded PARTIAL_FRAME macro into DEFAULT_FRAME. Patch v1
  had a bug (incorrect dwarf debug info generation).
= Corrected more comments.
= Added use of SAVE_* macros to error_entry and save_paranoid.
= Added another cleanup rename patch.

TODO:
= error_entry and save_paranoid have different CFI decorations.
  At least one of them is likely to be wrong...
= Move save_paranoid closer to the callers.
= "idtentry" macro uses a subroutine to factor out a largish
  common code block. "interrupt" macro inlines a similar
  block every time (~20 instances). Maybe factor it out?

CC: Oleg Nesterov <oleg@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: X86 ML <x86@kernel.org>
CC: Alexei Starovoitov <ast@plumgrid.com>
CC: Will Drewry <wad@chromium.org>
CC: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org

Denys Vlasenko (6):
  x86: entry_64.S: delete unused code
  x86: open-code register save/restore in trace_hardirqs thunks
  x86: entry_64.S: fold SAVE_ARGS_IRQ macro into its sole user
  x86: entry_64.S: always allocate complete "struct pt_regs"
  x86: mass removal of ARGOFFSET
  x86: rename some macros and labels, no code changes

 arch/x86/ia32/ia32entry.S              | 175 +++++++++--------
 arch/x86/include/asm/calling.h         | 216 ++++++++++----------
 arch/x86/include/asm/irqflags.h        |   4 +-
 arch/x86/include/asm/ptrace.h          |  13 +-
 arch/x86/include/uapi/asm/ptrace-abi.h |  16 +-
 arch/x86/include/uapi/asm/ptrace.h     |  13 +-
 arch/x86/kernel/entry_64.S             | 349 +++++++++++++--------------------
 arch/x86/kernel/preempt.S              |  16 +-
 arch/x86/lib/thunk_64.S                |  29 ++-
 9 files changed, 395 insertions(+), 436 deletions(-)

-- 
1.8.1.4

