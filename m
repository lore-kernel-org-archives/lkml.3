Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbbAJWAx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:00:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbbAJWAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:00:51 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/4 v2] x86: entry.S cleanup
Date: Sat, 10 Jan 2015 23:00:06 +0100
Message-Id: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first part of a bigger patch set I posted last August,
then under title of "x86: entry.S optimizations".

I fully rebased that patch set to Linus tree, but currently
Linus and -next are diverging a bit in arch/x86/kernel/entry_64.S

To make it easier for mainteiners, I'm splitting the old patch set
into more digestible parts.

This is the first set. These four patches apply both to Linus and -next.
They do not contain any substantial code changes.
Patches 2 and 4 don't result in any actual code changes.

Changes since v1:
Patch #3 had a bug.

CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: X86 ML <x86@kernel.org>
CC: Alexei Starovoitov <ast@plumgrid.com>
CC: Will Drewry <wad@chromium.org>
CC: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org

Denys Vlasenko (4):
  x86: entry_64.S: delete unused code
  x86: ia32entry.S: fix wrong symbolic constant usage: R11->ARGOFFSET
  x86: open-code register save/restore in trace_hardirqs thunks
  x86: entry_64.S: fold SAVE_ARGS_IRQ macro into its sole user

 arch/x86/ia32/ia32entry.S      |   4 +-
 arch/x86/include/asm/calling.h |   1 -
 arch/x86/kernel/entry_64.S     | 122 ++++++++++++++---------------------------
 arch/x86/lib/thunk_64.S        |  29 ++++++++--
 4 files changed, 68 insertions(+), 88 deletions(-)

-- 
1.8.1.4

