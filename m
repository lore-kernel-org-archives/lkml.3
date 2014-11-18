Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbaKRXP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:15:27 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50565 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbaKRXP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:15:26 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 0/3] Handle IST interrupts from userspace on the normal stack
Date: Tue, 18 Nov 2014 15:15:16 -0800
Message-Id: <cover.1416352397.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently run IST interrupt handlers on the IST stack.  Changing
it may simplify a few things.  See patch 2 for details.

Patch 1 is a fix for a not-quite-bug in uprobes that Oleg noticed
that would be exposed by patch 2.

NB: Tony has seen odd behavior when stress-testing injected
machine checks with this series applied.  I suspect that
it's a bug in something else, possibly his BIOS.  Bugs in
this series shouldn't be ruled out, though.

Andy Lutomirski (3):
  uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME
  x86, entry: Switch stacks on a paranoid entry from userspace
  sched, x86: Check that we're on the right stack in schedule and
    __might_sleep

 Documentation/x86/entry_64.txt         | 18 ++++---
 Documentation/x86/x86_64/kernel-stacks |  8 ++--
 arch/x86/Kconfig                       |  1 +
 arch/x86/include/asm/thread_info.h     | 19 +++++++-
 arch/x86/kernel/entry_64.S             | 86 ++++++++++++++++++----------------
 arch/x86/kernel/irq_32.c               | 13 ++---
 arch/x86/kernel/traps.c                | 23 ++-------
 include/linux/thread_info.h            |  7 +++
 kernel/Kconfig.locks                   |  3 ++
 kernel/events/uprobes.c                |  1 -
 kernel/sched/core.c                    | 14 ++++--
 11 files changed, 109 insertions(+), 84 deletions(-)

-- 
1.9.3

